---
layout: post
title:  "Log4j 2 vulnerabilities, part III: Prevention, mitigation and fixing"
tags: [CVE, Log4j, vulnerability, remote code execution, CVE-2021-44228, log4shell, cybersecurity, RCE, container image scanning, runtime security, mitigation, cloud, Kubernetes]
category: Security
excerpt_separator: <!--more-->
date: 2023-06-27 22:45:00 +01
image:
  src: /blog/images/featured/closed_windows.jpg
  width: 1024   # in pixels
  height: 616   # in pixels
  alt: A building with all window shutters closed
pin: false
description: "How to prepare before you are impacted by a vulnerability to minimize its possible reach, and how to properly fix things afterwards."
---

Wow, more than a year without writing anything more, and even leaving a three-part blog post unfinished... So what happened?
{:.alert.alert-success.vicente-opinion}

_Well, I started a new job, which requires a lot of focus as the beginning is crucial. All the time I had for starting the blog and writing the first articles was indeed because I already had left the old one and was waiting for the new job._

_A year of many interesting things has passed, and many times I had the desire to write about several different things. But having first to finish the trilogy prevented me to tell what I wanted to tell at that particular time. Then this major vulnerability has become water in the river and people seem to not care so much anymore._

_So I've decided I will at least create an abstract theoretical post to close the topic. That way I can continue writing about other things._

Ok, so if you are here is because you are interested in the Log4j 2 vulnerability, at least from a historical standpoint, and as a way to apply "lessons learned" to your current process.

To learn more about Log4j and vulnerabilities, don't forget to visit also my other posts:
* [Part I: History]({% post_url 2021-12-17-log4j-part-i %}){:target="_blank"}
* [Part II: Kubernetes POC]({% post_url 2022-02-01-log4j-part-ii %})
* [Part III: Prevention, mitigation, and fixing]({% post_url 2023-06-27-log4j-part-iii %}) (this post)

The two big questions that I will answer in this post are:

* How could this be prevented or mitigated?
* How should you proceed once a situation like this is detected?

I'll set up problems in a generic way, but focus on Kubernetes for specific examples.

## 1. Prevention and mitigation

A _zero-day_ like this vulnerability, by definition, can't be detected in advance. So it's impossible to know it's there. 

But there are things that can be done to detect their behavior and contain their reach, like:

* Less and better dependencies
* Runtime detection
* Network segmentation
* Process containment

### Less and better dependencies

Although we will speak about a lot of security concerns, the focus in this post is vulnerabilities. They can live in your software, on libraries and external dependencies you use, and you may not know it. One way of reducing risk is... running less software!

Specifically for container images, you should wisely choose your base images so they have the least packages possible, and those that have to be there to really be very carefully chosen. A good starting point is using [distroless container images](https://github.com/GoogleContainerTools/distroless) and statically linking your software. It that is not possible, consider not all base images are the same. Try to start with a small Alpine or Debian-slim. If you don't want to craft all dependencies inside the image yourself, consider the ones from [Bitnami](https://bitnami.com/stacks/containers) are sometimes better (less unnecessary dependencies and vulnerabilities) than the official images from open source projects. Other alternatives like [Chainguard](https://github.com/chainguard-images/images) have an enticing promise of zero vulnerabilities in their images that is worth putting to the test.

Also the quality of your dependencies is important, you should choose carefully which dependencies written by other people you execute alongside your software. Make sure they come from reputable sources, open source projects with many maintainers that regularly release new versions and fix issues. That will reduce the amount of vulnerability they have, and the time for a new one to be addressed.

### Runtime detection

Even if you don't know about a vulnerability, you can use _runtime detection_ to examine the behavior of compute elements looking for suspicious activity. A tool like open source [Falco](https://github.com/falcosecurity/falco) that can be installed as a _eBPF_ or _Kernel module_ for hosts, containers, or Kubernetes. It has [an extensive set of more than 80 curated rules](https://github.com/falcosecurity/rules/blob/main/rules/falco_rules.yaml) that would detect undesirable activity once someone is exploiting a zero-day, like running an interactive shell, searching for passwords or certificates, exfiltrating them, or trying to break security boundaries. Alternatives like [Tetragon](https://github.com/cilium/tetragon) looks interesting, leveraging just _eBPF_, but you lack any starting point for security rules and have to write everything from scratch. It has a great capability of being able to stop a process just after a detection, but [it has been disclaimed](https://grsecurity.net/tetragone_a_lesson_in_security_fundamentals) this is as useful as it sounds.

### Network segmentation

If compute components (microservices, pods, servers) were network isolated, when one was compromised it would be impossible to contact back to the source hacker. This showed not to be implemented in all compromised resources that got a connection back, as [the first post on this series demonstrated]({% post_url 2021-12-17-log4j-part-i %}).

For Kubernetes, you can use [Kubernetes Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) for easily setting how pods can talk to each other. 

Depending on the _Container Network Interface (CNI)_ of the dataplane your Kubernetes cluster uses, you may need to _activate_ network policies, or do additional installations, to have access to that feature; even replacing the CNI for [Calico](https://github.com/projectcalico/cni-plugin) or [Cilium](https://github.com/cilium/cilium), both of them having their own propietary more powerful network policies. Remember that you can replace the CNI of worker nodes, but not for control plane ones that will remain under the original CNI with their own IP range, that will not know anything about pods range. If that is the case, you will need for example to run on "host network" pods with webhooks that have to be called from the Kubernetes API (but not the other way around). And pods on the host network share the IP address and network interface of the host, which at the same time can't be controlled with normal Kubernetes Network policies.

_Kubernetes Network Policies_ work very well to manage pod traffic inside the cluster on regular pods. But if you want to filter external traffic, when using load balancers the external source IP address of the connection may be masked. To avoid this, you can opt to lose perfect balancing vs preserving client ip by setting [externalTrafficPolicy to local](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip). It's a good idea to use a cloud firewall when possible for rules that can apply in this case.

### Process containment

A computer CPU runs software in a process, many of them at the same time for parallelism. A service may run in a container, which is just a process with some isolation from other processes in the same host machine, and its own network layer.

When running containers, if the vulnerable workload gets compromised, there is already some isolation from the host that is running it, may it be on a Kubernetes cluster, or other kind of orchestrator. But if the malicious agent knows a way to escape the confinements of the container via a vulnerability in the orchestrator, [which has happened in the past](https://nvd.nist.gov/vuln/detail/CVE-2022-0185), he could switch to run on the host virtual machine directly. There are also several privileged settings for pods that will enable them to run very privileged capabilities, that when it gets compromised, makes escaping the container and gaining root privileges on the host machine extremely easy. From there, the malicious agent will be able to do a lot of harm.

To prevent pods in a Kubernetes cluster from having insecure settings you can use [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/), where you can set a namespace at three different levels:

* _Privileged:_ anything is allowed
* _Baseline:_ any setting that will make compromise the host automatic is prevented, like _privileged containers_ or _host network_.
* _Restricted:_ containers need to run as non-root, drop almost all Linux capabilities, and specify a seccomp profile that filters system calls.

Remember _namespaces_ do not limit anything at all until you put extra limiting settings on how they behave. Don't worry if at first you don't understand the implications of all these. You can start with setting _baseline_, as it will require mostly you to do nothing to your pod specs, otherwise you'll know they are already insecure.

When using third party Helm charts, You can use my own [psa-checker](https://github.com/vicenteherrera/psa-checker#checking-a-helm-chart) open source tool to evaluate the pods a chart will deploy for _Pod Security Standard_ level. You can also _shift-left_ and put it into a pipeline to fail early if it sees pods of the wrong level.

If you need a more fine-tuned permissions system that is not just those three levels, or enforce additional restrictions not included in them, you can install your own _admission controller_ like [Gatekeeper](https://github.com/open-policy-agent/gatekeeper) or [Kyberno](https://github.com/kyverno/kyverno/), and write your own policies for them using _OPA_ for the first or plain _YAML_ for the second.

An important thing you can do to improve your container's security is **to make sure they do not run as root user**. You can specify in the _Dockerfile_ with _USER_ a different user, or at least make sure that they are compatible with running the as non-root. Then on the pod spec, use _runAsUser_ to specify a userId. Then, in case the container is compromised and its isolation is breached, will make the malicious actor still being executing things without root privileges, so what they can do will on the host machine will be limited.


### Kubernetes RBAC

When thinking of cluster orchestation for a single containerized workload, or even complex microservice architectures, is that those workloads just need to declare what they need and let the orchestrator carry the work of making it possible. But some of the cloud native applications you can run in the cluster is to extend how the orchestrator works, or your workload is complex enough to need to be aware and interact with the orchestrator. This is where Kubernetes _Role Based Access Control (RBAC)_ come into play to give some permissions, but not all.

As always, you should give the least permissions possible to do the job intended. Leverage roles, rolebindings, clusterrole, clustesrrolebindings, service accounts, users and groups. Remember _namespaces_ do not limit anything at all until you put extra limiting settings on how they behave. Learn how to master this, including using subresources permissions, like _pod/exec_ or _pod/logs_, and indicating specific resource names, like to which specific deployment you are givin a permission. Avoid using _*_ (everything) anywhere, and remember that Kubernetes accepts anything for RBAC, even if the kinds have typos and do not exist... at the moment you are deploying the RBAC rules.

There are some permissions that require special consideration. Giving _read secrets_ permission will allow to get tokens that can be used to authenticate to other services, facilitating _lateral movement_. Note there is no distintion on _list secrets_ and _read secrets_, it's the same permission, and even if with _kubectl_ there is a difference, if you just directly use _curl_ there is none. Modifying any _event_ will allow someone to tamper with information that may be important to detect a malicious attach. Also important is _pod/exec_, that would allow someone to execute an shell into containers, with potential to insert their own malicious code, exfiltrate secret information, etc.

Every namespace has a _default_ service account that is assigned to each pod if in their spec there is none specific, with a token to auth to the Kubernetes API that has very few permissions, just to "ask" what it can do (that will be nothing). [It's a good idea to opt out of automounting this token on all pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#opt-out-of-api-credential-automounting), as if not specifically required, pods should not even be able to talk with that API to begin with; think that if they get compromised it can be the starting point of exploiting some Kubernetes API vulnerability. Also someone may have the disastrous idea of start giving permissions to that _default_ account, which will unknownlying give those permissions to all existing and future pods created on the namespace, with unintended side effects.

Kubernetes RBAC system will not allow a user (or _service account_) to create a rolebinding that would give to itself or others more permissions that they currently have, which is nice to let less permissioned users create their own even least permissioned RBAC rules. But take into consideration that if you have permissions to create a pod, deplyment, daemonset, job, or cronjob, in some namespace, and there is another service account in that namespace, you can create a workload tied to such service account, with the command of your choosing, triggering a de-facto privilege scalation.

When deploying third party workload, like helm charts or operators, review the RBAC permissions they include, and seek alternatives if they just deploy a Clusterrole with all permissions on the cluster, as it will be a big security risk. As explained before you can [psa-checker](https://github.com/vicenteherrera/psa-checker#checking-a-helm-chart) to evaluate PSS level of pods in a Helm chart. This will no tell you info about the chart RBAC rules that you have to investigate yourself, but at least will tell you if the pods already are restricted to insecure process containment. And you can use the open source tool [bad robot](https://github.com/controlplaneio/badrobot) to evaluate the security posture of operators, including their RBAC rules.

## 2. Detection and fix

The only way to detect if you are using a vulnerable dependency in your projects is if that vulnerability is already known. [Mitre CVE](https://vicenteherrera.com/blog/what-is-a-cve/#cve-ids), and [Nist NVD](https://vicenteherrera.com/blog/what-is-a-cve/#nvd) databases, as well as others, publish known vulnerabilities in software with details about how important they are. But you shouldn't be manually reading every single day if the [NVD database](https://nvd.nist.gov/vuln/detail/CVE-2021-44228) has new entries.

You can do **container image scanning**, list all known dependencies on your containers, and match that list with the NVD or other vulnerability database. Some open source scanners for command line are [Trivy](https://github.com/aquasecurity/trivy), [Grype](https://github.com/anchore/grype), [Snyk](https://snyk.io/product/container-vulnerability-management/), and [Docker Scout](https://docs.docker.com/scout/). The first time you do this, you will be surprised to learn how many vulnerabilities are out there, so you better filter for the high or critical ones that have a known exploit. 

Remember the sooner you scan the better, developers when test-building images, on build pipelines so very vulnerable images are stopped, and when publishing to a container registry. But even after your container image has long been built, new vulnerabilities may be discovered. Then you want to continually scan existing container images on registries as well as on running hosts and clusters. Most scan solutions in this latter case rely on having an _SBOM (Software Bill of Materials)_, a list of all known software on the image, as the list shouldn't change, so they can continuously keep matching the SBOM list to updates of the vulnerability database to warn on newly discovered vulnerabilities. You shouldn't have to bother how _SBOMs_ work at all, an enterprise solution like [Sysdig](https://sysdig.com/), [Aqua](https://www.aquasec.com/), [Prisma](https://www.paloaltonetworks.com/prisma/cloud), [Lacework](https://www.lacework.com/), or [Snyk](https://snyk.io/) should take care of that. You just have to set up scanning at every step, establish acceptance criteria, and centralize reporting of findings.

The first time you are warned of an important vulnerability (high or critical with known exploits, for example), two things can happen:

* You are using the vulnerable dependency **for the first time**
* You **already** were using the vulnerable dependency

### Using vulnerable dependency for the first time

You are just using that dependency with the vulnerability **for the first time**. You should research if it has been recently discovered, and if you can use an alternate (older) version that is less vulnerable until the newer one gets fixed. If the package is in general in a very bad situation vulnerability-wise on all versions, consider using a completely different dependency that can do the same job.

### You already were using the vulnerable dependency

If you **already were using the vulnerable dependency**. Then other possible options arise.

* There is an **upgraded version** that is known to **fix the vulnerability** (it would be indicated in the vulnerability database). Then just rebuild the container image using this version, following all the test processes that you should have in place to make sure everything works as expected. In this process, you may want to also upgrade other dependencies, but be careful. If you change a lot of packages, you may also be introducing new vulnerabilities to consider, or your tests may show that your software no longer behaves the way it should. To be able to do this in a controlled manner, it's important to _version-fix_ the dependencies in your build process, so it's easier for you to choose what to upgrade, and maybe even to have your own copy of the original dependencies you use, in your own controller artifact registry (like [Artifactory](https://jfrog.com/community/open-source/), [GitHub Actions Artifacts](https://docs.github.com/en/rest/actions/artifacts?apiVersion=2022-11-28), [AWS Artifact Repository](https://aws.amazon.com/codeartifact/), [Azure Artifact](https://azure.microsoft.com/es-es/products/devops/artifacts)), [Google Artifact Registry](https://cloud.google.com/artifact-registry). It is also useful to separate the build process by creating or using a base container image that is reliable and you trust, and on a separate step additional layer(s) for the very specific software of that container, that way it's easier to keep the base consistent if you don't need to change its packages. **Reproducibility** is a very important concept for security and stability. Also automating rolling out new releases will reduce the time it takes you from detection to complete vulnerability removal of your production workloads.

* There is **no upgrade version that fixes the vulnerability**, or the alternative is a different mayor (or minor) version that breaks some functionality. In this case, again you have two options.

  * You think you need to **remove the vulnerable dependency no matter how**. You should then replace it with a very different version, or even a different dependency that provides a similar set of features. This can be arduous and coding-intensive, where having good tests is essential. Also good planning in separating in-layer functionality instead of calling directly the dependency will help replace it. Balance is the key, you can't make everything abstract or code will be very convoluted even for simple things (I'm looking at you, enterprise Java).

  * The vulnerability **doesn't look so serious**, or you think known **mitigations** may be put in place to prevent it from being "activated" or "reached". In this scenario, you have the advantage of the vulnerability already being known and researched. If it relies on some specific network connection or unfiltered input, you may add some network filter with specific blocking rules (like [Snort](https://www.snort.org/rule_docs/1-58744)) or a security web proxy (like [OWASP ZAP](https://owasp.org/www-project-zap/)). You may not need to write your own rules, but keep an eye on runtime behavior and seek updated rules if the vulnerability is further analyzed to be activated in new ways.

## 3. That's (not) all folks

No, no... that is not all. This is enough for vulnerabilities in containers, but there are still general recommendations to follow:

* Your own coded software may have insecure code practices. Ensure you define a good architecture and use some code quality analysis tools like [SonarQube](https://docs.sonarqube.org/latest/).

* Misconfiguration in your infrastructure is the number one reason for breaches. Check your IaC (Infrastructure as Code) with tools like [Checkov](https://www.checkov.io/) for possible vulnerabilities.

* Update your container images with new dependencies regularly, that way you skip entirely being affected by a vulnerability in many cases. It's easier if you automate your software build and deployment, for which there are many open source tools like [ArgoCD](https://github.com/argoproj/argo-cd) or [Tekton](https://github.com/tektoncd). You should also set up a blue/green deployment strategy, including implementing good liveness and health checks on your pods.

* Check you employ known best practices for your cloud provider. Remember misconfiguration on infrastructure or cloud usage is not in the scope of vulnerability databases, it's completely on you. You can download [Center for Internet Security (CIS) Benchmarks](https://www.cisecurity.org/benchmark/amazon_web_services) with security recommendations for AWS, GCP, Azure, Kubernetes, Openshift, and many other platforms, and use automated tools for checking like [Kubebench](https://github.com/aquasecurity/kube-bench), or [Prowler](https://github.com/prowler-cloud/prowler).

* Managing **Identity and Access Management (IAM)** on cloud providers, and **Kubernetes RBAC**, the right way, is important and would deserve its own blog post. When you are in the cloud, usually there is a way to link cloud IAM RBAC to Kubernetes RBAC. Also if you don't need it, revoke access from pods to the cloud metadata endpoint and giving IAM identity to pods.

* Managing **secrets and certificates**, who creates them, how to deliver them to your workloads in a secure way, how to revoke and rotate tokens, etc, would also deserve its own blog post. Kubernetes secrets have been criticized for initial lack of strong security like not keeping them in memory instead of disk, not using encryption at rest, or loading them only to nodes that didn't need them, and [poor document explanation of how they are secure](https://www.redhat.com/sysadmin/managing-secrets-kubernetes-pods). Those days are over, but Kubernetes secrets is just a delivery mechanism, you still have a source to store, manage, deliver them to your cluster, and update and revoke secrets and certificates. There is where open source tools like [Vault](https://github.com/hashicorp/vault) or [Cert Manager](https://github.com/cert-manager/cert-manager) can help you.

* Observability is heavily related to security. The most recognized open source tools for that are [Prometheus](https://github.com/prometheus) for scraping, storing, and querying time series metrics, [Alertmanager](https://github.com/prometheus/alertmanager) for triggering alerts based on your metric rules written in _PromQL_ language, and [Grafana](https://github.com/grafana/grafana) for displaying dashboards. Install all at the same time using [this helm chart](https://github.com/prometheus-community/helm-charts). You can complement that with [Robusta](https://github.com/robusta-dev/robusta), also open source, to make sure the information for troubleshooting incidents easily arrives to developers. When handling many cloud accounts, each possibly with many clusters can be a real challenge that requires enterprise tools. In this case, [Sysdig](https://sysdig.com/) is exceptional as it not only is a top-tier observability tool, but also a top-tier security one all in the same product.

## Thanks

Thanks to [Flaquivurus](https://www.flickr.com/photos/flaquivurus) for the cover photo.

## Conclusion

Sorry for taking so long on completing this post series. I was busy with my new job, and as I already are speaking daily about cloud, container and Kubernetes security full time, I wanted to write about other topics. But it was important to first close this chapter. I have the feeling that I will write less about security in following posts.

Vulnerabilities are a reality that you will face, so you better plan for that in your software project. Be it dealing with unknown ones, mitigating what is known but can't be fixed, or making things easier to upgrade, test and roll out.

{% include tweet-me.html %}
{% include author-profile.html %}
