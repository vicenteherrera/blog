---
layout: post
title:  "Log4j 2 vulnerabilities, part III: Prevention, mitigation and fixing"
tags: [CVE, Log4j, vulnerability, remote code execution, CVE-2021-44228, log4shell, cybersecurity, RCE, container image scanning, runtime security, mitigation, cloud, Kubernetes]
category: Security
excerpt_separator: <!--more-->
date: 2023-06-08 22:45:00 +01
image:
  src: /blog/images/featured/closed_windows.jpg
  width: 1024   # in pixels
  height: 616   # in pixels
  alt: A building with all window shutters closed
pin: false
description: "How to prevent, mitigate and fix a vulnerability."
---

_Wow, more than a year without writing anything more, and even leaving a three part blog post unfinished... So what happened?

Well, I started a new job, which requires a lot of focus as the beginning is crucial. All the time I had for starting the blog and writting the first articles was indeed because I already had left the old one and was waiting for the new job.

A year of many interesting things has passed, and many times I had the desired to write about several different things. But having first to finish the trilogy prevented me to tell what I wanted to tell at that particular time. Then this major vulnerability has become water in the river and people seems to not care so much anymore.

So I've decided I will at least create an abstract theoretical post to close the topic. That way I can continue writing about other things._

Ok, so if you are here is because you are interested in the Log4j 2 vulnerability, at least from an historical standpoint, and as a way to apply "lessons learnt" to your current process.

Big questions then are:

* How could this be prevented or mitigated?
* How should you proceed once a situation like this is detected?

### Prevention and mitigation

A _zero day_ like this vulnerability was, by definition, can't be detected in advance. So it's impossible to know it's there.

But there are things that can be done:

* Even if you don't know about a vulnerability, you can use _runtime detection_ to examine behaviour of compute elements looking for suspicious activity. A tool like open source _Falco_ for hosts, containers or Kubernetes has an extensive set of curated rules that would detect undesirable activity once someone is exploting a zero day, like running an interactive shell, searching for passwords or certificates, exfiltrating them, or trying to break security boundaries.

* If compute components (microservices, pods, servers) were network isolated, when one was compromised it would be impossible to contact back to the source hacker. This showed not to be implemented in all compromised resources that got a connection back. For Kubernetes, you can use _Kubernetes Network Polices_ for that.

### Detection and fix

The only way to detect if you are using a vulnerable dependency in your projects is if that vulnerability is already known. [Mitre CVE](https://vicenteherrera.com/blog/what-is-a-cve/#cve-ids), and [Nist NVD](https://vicenteherrera.com/blog/what-is-a-cve/#nvd) databases publish known vulnerabilities in software with details about how important they are. But you shouldn't be reading every single day if the [NVD database](https://nvd.nist.gov/vuln/detail/CVE-2021-44228) has new entries.

* You can automate container image scanning, that will list all known dependencies on your containers, and match that list with the NVD or other vulnerability database, using tools like [Trivy](https://github.com/aquasecurity/trivy), [Grype](https://github.com/anchore/grype), [Snyk](https://snyk.io/product/container-vulnerability-management/), [Docker Scout](https://docs.docker.com/scout/), and many others. First time you do this, you will be surprised to learn how many vulnerabilities are out there, so you better filter for the high or critical ones that have a known exploit. Remember the sooner you scan the better, developers when test-building images, on build pipelines so very vulnerable images are stopped, and when publishing to a container registry. But even after your container image has long been built, new vulnerabilities may be discovered. You want then to continually scan existing container images on registries as well as on running hosts and clusters. Most scan solutions on this latter case rely on having an SBOM (Software Bill of Materials), a list of all known software on the image, as the list shouldn't change. The they can continusly keep matching the SBOM list to updates of the vulnerability database to warn on newly discovered vulnerabilities.

* First time you are warned of an important vulnerability (high or critical with known exploit, for example), several things can happen.

  * You are just using that dependency with the vulnerability for the first time. You should research if it has been recently discovered, and if you can use an alternate (older) version that is less vulnerable until the newer one gets fixed. If the package is in general in a very bad situation vulnerability wise on all versions, consider using a complete different dependency that can do the same job.

  * You already are using the package. Then other possible options arise.

    * There is an upgraded version that is known to fix the vulnerability (it would be indicated in the vulnerability database). Then just rebuild the container image using this version, following all the test process that you should have in place to make sure everything works as expected. In this process you may want to also upgrade other dependencies, but be careful. If you change a lot of packages, you may also be introducing new vulnerabilities to consider, or your tests may show that your software no longer behaves the way it should. To be able to do this on a controlled manner, it's important to _version fix_ the dependencies in your build process, so it's easier for you to choose what to upgrade, and maybe even to have your own copy of the original dependencies you use, in your own controller artifact registry (like Artifactory, GitHub Actions Artifacts, Google Artifact Registry, AWS Artifact Repository, Azure Artifact). It is also useful to seperate the build process creating or using a base container image that is reliable and you trust, and on a separate step additional layer(s) for the very specific software of that container, that way it's easier to keep the base consistent if you don't need to change its packages. Reproducibility is a very important concept for security and stability. Also automating rolling out new releases will reduce the time it takes from you from detection to complete vulnerability removal of your production workloads.

    * There is no upgrade version that fixes the vulnerability, or the alternative is a different mayor (or minor) version that breaks some functionality. In this case again you have two options.

      * You think you need to remove the vulnerable dependency no matter why. You should then replace it with a very different version, or even a different dependency that provides a similar set of features. This can be arduous and coding intensive, where having good tests is essential. Also good planning in separating in layer functionality instead of calling directly the dependency will help replace it. Balance is the key, you can't make everything abstract or code will be very convoluted even for simple things (I'm looking at you, enterprise Java).

      * The vulnerability doesn't looks so serious, or you think known mitigation factors may be put in place to prevent it from being "activated" or "reached". In this scenario, you have the advantage of the vulnerability already being known and researched. If it relies on some specific network connection or unfiltered input, you may add some rules for network filter (like [Snort](https://www.snort.org/rule_docs/1-58744)) or a security web proxy (like [OWASP ZAP](https://owasp.org/www-project-zap/)). You may not need to write your own rules, but keep an eye on runtime behaviour and seeking updated rules if the vulnerability is further analyzed to be activated in new ways.
  

### That's all folks

No, no... that is not all. This is enough for vulnerabilities on containers, but there are still general recomendations to follow:

* Update your container images with new dependencies regulary, that way you completely skip being affected for a vulnerability in many cases.

* Your own coded software may have insecure code practices. Ensure a good architecture and use some code quality analysis tool like [SonarQube](https://docs.sonarqube.org/latest/).

* Misconfiguration in your infrastructure is number one reason for breaches. Check your IaC (Infrastructure as Code) with tools like [Checkov](https://www.checkov.io/) for possible vulnerabilities.

* Check best practices for your cloud provider. Remember misconfiguration on infrastructure or cloud usage is not in the scope of vulnerability databases, it's completely on you. You can download [Center for Internet Security (CIS) Benchmarks](https://www.cisecurity.org/benchmark/amazon_web_services) with security recommendations for AWS, GCP, Azure, Kubernetes, Openshift and many other platforms, as well as use automated tools for checking like [Kubebench](https://github.com/aquasecurity/kube-bench), or [Prowler](https://github.com/prowler-cloud/prowler).

* Managing Identity and Access Management (IAM) on cloud providers as well as Kubernetes RBAC, the right way, is important and would deserve its own blog post.

* Managing secrets and certificates, who creates them, how to deliver them to your workloads in a secure way, how to revoke and rotate tokens, etc, would also deserve its own blot post.



## Conclusion

Sorry for taking so long on completing this post series. I was busy with my new job, and as I already are speaking daily about cloud, container and Kubernetes security full time, I wanted to write about other topics. But it was important to first close this chapter. I have the feeling that I will write less about security on following posts.

Vulnerabilities are a reality that you will face, so you better plan for that in your software project. Be it dealing with unkown ones, mitigating what is known but can't be fixed, or making thins easier to upgrade, test and roll out.

{% include tweet-me.html %}
{% include author-profile.html %}