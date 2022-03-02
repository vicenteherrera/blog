---
layout: post
title:  "Log4j 2 vulnerabilities, part III: Fixes and mitigations"
tags: [CVE, Log4j, vulnerability, remote code execution, JNDI, CVE-2021-44228, CVE‑2015‑4902, CVE‑2015‑4902, log4shell, RCE, proof of concept, fix, mitigation, security, cybersecurity, Kubernetes]
category: Security
excerpt_separator: <!--more-->
date: 2022-02-08 22:25:00 +01
image:
  src: /blog/images/featured/dome.jpg
  width: 1795  # in pixels
  height: 1120   # in pixels
  alt: Dome skylight, beyond it a blue sky with several white clouds
pin: false
description: "Evidence based evaluation of security tools, fixes and mitigations for Log4j 2 vulnerabilities."
---

This is the third and last post about the Log4j&nbsp;2 vulnerabilities, where I invite you to test with me several fixes, mitigations and how different security tools perform in relation to this problem. Some of them work better than others.

To learn more about what is and the history of Log4j&nbsp;2, JNDI, the vulnerability, and technical details about how they work and my provided proof of concept on Kubernetes, visit the other posts on this serie:

* [Part I: History]({% post_url 2021-12-17-log4j-part-i %}){:target="_blank"}
* [Part II: Kubernetes POC]({% post_url 2022-02-01-log4j-part-ii %}){:target="_blank"}
* [Part III: Security, fixes, and mitigations]({% post_url 2022-02-08-log4j-part-iii %}){:target="_blank"} (this post)

## Running the proof of concept

I will start running the same proof of concept I created for Kubernetes in the previous part, but with some modifications to make this a little harder on the security part.

* We will modify the LDAP port for the connection to 80 instead of the default 192 (most attackers will avoid that as it is easy and harmless to block)
* Instead of using the JNDI string to trigger the attack in the header of the CURL call, we will use it inside the URL. Some security tools are looking at headers, and a wise hacker will surely avoid that.

## Detection

The first thing we want to test is detecting that we have a problem in the first place.

### Source code level

At the source code level, the two most important tools that we can use is Snyk analyzer and GitHub code security.

### Container level

At a container level, there are many container vulnerability scanners that we can test, like:

* Sysdig scanner
* Sysdig new scanner (alpha)
* Anchore grype
* Anchore (legacy)
* Snyk container scan
* Claire
* Docker scan (powered by Snyk)

As the container we use uses first a build image and then a minimal run image, it doesn't make the `pom.xml` file or other metadata file available in the container, so the scanners have to build its _bill of materials_ analyzing one by one its files, and looking into `.war` and other compressed files.

## Where and when the container image scan is done

Another important thing to tackle is when and where the container scan is happening, and this is important.

* Command line: for developer testing by hand container images
* On CI/CD pipelines: automatically checks new builds before pushing them to a registry, but lacks visibility once new vulnerabilities appear
* On a registry:
  * On push: Similar to scan on the pipeline, but this would force you to scan once even images pushed directly by hand to the registry.
  * On a schedule: It seems sensible to scan periodically all containers in a registry, as when new vulnerabilities are discovered, all previous image scan reports gets obsolete. But investigate the schedule of your security tool, it may be longer than you imagined (days even), having many images on registries makes this timing worse. 
  * Whenever there is change to vulnerability database: This is costly, but some security tools store the container's _build of materials_ alongside scan results, and can automatically match it again on vulnerability database changes. Combine this with custom reports on new detections for high or critical vulnerabilities (you can also filter if there is a fix available), and you get the best kind of coverage. 
* On running containers: It can be more important to know the security posture of all your running workloads than the images on registries. An image may be running that has been deleted from the registry, or you need a very tight schedule for scanning taking less images in consideration.
  * On a schedule: Same consideration as above, look into how short the schedule is, and if you have many running containers if it's even feasible.
  * Whenever there is change to vulnerability database: Again, using stored _build of materials_ is the best approach.

The best protection should be for using at the same time image scanning on the CI/CD pipeline (so known vulnerable or non compliant images doesn't live in the registry to start), on the registry, and for running images. And if possible, using stored _build of materials_ on vulnerability database change instead of schedule.

## Definitive fix

Looking into fixes, let's start with the definitive one. Replacing the Log4j&nbsp;2 library for the fixed version that should have any problem.

## Hardening

I don't like when people use the term "hardening", meaning setting up a system so it's more resilient to problems. For me it implies the system was good all along, and a coat of armour could be added later. But as it is very popular and easy to understand, this sections is called that.

Here I want to talk about the steps that should have been taken to avoid problems in the first case:

* Sanitize what Log4j&nbsp;2 processes: This would avoid any trouble on any Log4j&nbsp;2 version.
* Restrict network outward communications of the server: This would prevent communications using LDAP to the malicious server.

## Mitigations

For me mitigations are partial fixes, or catch'all solutions.

* Changing Java settings
* Hot scanning and patching
* Firewall
  * 

## Aftermath

Ok, every container has been patched, all hardening techniques have been applied. But where you hacked when the vulnerability was still present in your system?

You can't be sure of that no matter how soon you reacted. It has existed for several years as we explained in history until it was reported.

As you have been using Log4j&nbsp;2 for... logging, you should have a record of log messages. Maybe you discard the old ones, but whatever you do, it would be useful to check what you have to try to detect evidence of compromise.

[...]

All right, is that everything? No! Almost every SaaS and cloud service was compromised, so if you rely on those, check also any logs you have for activity that would help you make sure the services they provide for you have not been compromised and you have been affected.

## Thanks

Thanks to Brian Klug for the original featured image:
* Title: Anonymous Hacker
* Author: [Mike Mozart](https://www.flickr.com/photos/jeepersmedia/){:target="_blank"}
* URL: [flickr.com/photos/jeepersmedia/27717319460](https://www.flickr.com/photos/jeepersmedia/27717319460/){:target="_blank"}
* License: [Attribution 2.0 Generic (CC BY 2.0)](https://creativecommons.org/licenses/by/2.0/){:target="_blank"}

## Conclusion

JNDI used for _remote code execution_ is an old story that hasn't been patched in a long time. Log4j&nbsp;2 failing to sanitize strings is vulnerable to this kind of attack. Using the [GitHub repository I've created](https://github.com/vicenteherrera/log4shell-kubernetes){:target="_blank"}, you can in very few steps reproduce the attack to experiment and test security tools.

Read more about History of Log4j vulnerabilities and JNDI on "[Part I: History]({% post_url 2021-12-17-log4j-part-i %}){:target="_blank"}" of this article series. Be ready for part III, where we evaluate and put to the test fixes and mitigations, which work, which doesn't.

{% include tweet-me.html %}
{% include author-profile.html %}