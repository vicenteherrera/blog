---
layout: post
title:  "What is a CVE?"
tags: CVE CNA MITRE NVD NIST CVSS SCAP OpenSCAP OVAL security cybersecurity cloud-native
category: Security
excerpt_separator: <!--more-->
date: 2021-12-06 5:20:00 +01
image:
  src: /blog/images/cyberpunk-cve.png
  width: 1101   # in pixels
  height: 669   # in pixels
  alt: Cyberpunk 2077 car hijack
pin: false
---

You are playing _Cyberpunk 2077_, and [on the introductory mission](https://youtube.com/clip/Ugkx76_kl_Faj6ShXC7pk2cqRINrr_d3VxhD){:target="_blank"}, you have to steal a car. After using an electronic tool first to open its door, you get inside, and while the hijack takes place, a message appears on the sophisticated onscreen display of the car<!--more-->:

> `RUN:EXPLOIT.CVE-0322.B/055BCCAC9FEC/LOADING`
{:quote}

That sounds familiar, isn't it? You are trying to figure out the numbers written there, but immediately Jackie appears for the first time, and interrupts you.

<iframe width="666" height="370" src="https://www.youtube.com/embed/H3isCdVVPbk?start=1153" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

You have seen it before on many occasions where a new vulnerability is discovered, and while some may have a fancy name as _"SMBGhost"_ or _"BlueKeep"_, they are always accompanied by a sequence identifier like **CVE-2020-0796** or **CVE-2019-0708**.

For example, scanning the container image [node:latest](https://hub.docker.com/_/node){:target="_blank"} at the time of writing this post with an open-source vulnerability scanner like [Trivy](https://github.com/aquasecurity/trivy){:target="_blank"} or [Clair](https://github.com/quay/clair); or a commercial one like [Sysdig](https://sysdig.com){:target="_blank"} or [Aqua](https://www.aquasec.com/){:target="_blank"}, you see many entries like:

Library        | Vulnerability ID | Severity | Installed| Fixed| TITLE 
---------------|------------------|----------|----------------|------------|----------------------------------
python3.9      | CVE-2021-29921   | CRITICAL | 3.9.2-1          |               | python-ipaddress: Improper input validation of octal strings
curl           | CVE-2021-22945   | CRITICAL | 7.74.0-1.3       |               | curl: use-after-free and double-free in MQTT sending  
ansi-regex     | CVE-2021-3807    | HIGH     | 3.0.0            | 5.0.1, 6.0.1  | nodejs-ansi-regex: Regular expression denial of service (ReDoS) matching ANSI escape codes

## What does CVE stand for?

The **Common Vulnerability and Exposures (CVE)** program was launched in 1999 by [MITRE](/blog/intro-mitre-attack#mitre-corporation). Their intent as described in [their website](https://www.cve.org/About/Overview) is:

> The mission of the _CVE Program_ is to identify, define, and catalog publicly disclosed cybersecurity vulnerabilities. There is one CVE Record for each vulnerability in the catalog. The vulnerabilities are discovered then assigned and published by organizations from around the world that have partnered with the _CVE Program_. Partners publish _CVE Records_ to communicate consistent descriptions of vulnerabilities. Information technology and cybersecurity professionals use _CVE Records_ to ensure they are discussing the same issue, and to coordinate their efforts to prioritize and address the vulnerabilities.
{:.quote}

At the current date, the new [cve.org](https://cve.org){:target="_blank"} website holds information on **165,047** vulnerabilities; the old [cve.mitre.org](https://cve.mitre.org){:target="_blank"} is still used for [downloading](https://cve.mitre.org/data/downloads/index.html){:target="_blank"} and [keyword searching](https://cve.mitre.org/cve/search_cve_list.html){:target="_blank"}. The website [cvedetails.com](https://www.cvedetails.com/){:target="_blank"} is also nice for searching, as well as the [National Vulnerability Database (NVD)](https://nvd.nist.gov/vuln/search){:target="_blank"} (more on that later).

The _CVE program_ is sponsored by the [U.S. Department of Homeland Security (DHS)](https://www.dhs.gov/){:target="_blank"} [Cybersecurity and Infrastructure Agency (CISA)](https://www.dhs.gov/cisa/cybersecurity-division/){:target="_blank"}, available to the public and free to use. CVE and its logo are also registered trademarks of [The MITRE Corporation](/blog/intro-mitre-attack#mitre-corporation).

## CVE IDs

CVE IDs are used to univocally identify registered vulnerabilities. Organizations that assign CVE are called [CVE Numbering Authorities (CNAs)](https://www.cve.org/ProgramOrganization/CNAs){:target="_blank"}.

A CVE ID takes the form of:

`CVE-<year>-<id number>`

That makes it easy to know if a given vulnerability is recent or very old. For example:
* [CVE-2020-0796](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-0796){:target="_blank"}, aka "SMBGhost", registered in the year 2020.
* [CVE-2007-0029](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-0029){:target="_blank"}, aka "Excel Malformed String Vulnerability", registered in the year 2007

This doesn't mean the vulnerability didn't exist earlier, that is the year where it first was documented. By the way, that means that the CVE shown in Cyberpunk 2077 should have started with `CVE-2077`. Well, add that to the list of problems with that game.

## CVE record

A _CVE ID_ has descriptive data associated with the vulnerability that is called **CVE record**. This can be in one of the following states:

* _Reserved_: The initial state for a _CVE Record_, can just contain an identification number (CVE ID).
* _Published/Public_: Data published for public use. Must contain _CVE ID_, prose description, and at least one public reference.
* _Rejected_: If the CVE ID and associated _CVE Record_ should no longer be used, it is placed in this state, so that users can know it is invalid.

For example, the _CVE record_ for [CVE-2017-5638](https://www.cve.org/CVERecord?id=CVE-2017-5638){:target="_blank"} includes the following information:
* _Description_: The Jakarta Multipart parser in Apache Struts 2 2.3.x before 2.3.32 and 2.5.x before 2.5.10.1 has incorrect exception handling and error-message generation during file-upload attempts, which allows remote attackers to execute arbitrary commands via a crafted Content-Type, Content-Disposition, or Content-Length HTTP header, as exploited in the wild in March 2017 with a Content-Type header containing a #cmd= string.
* _State_: Public
* _Vendors, products & versions_:
  * Vendor: Apache Software Foundation
    * Product: Apache Struts
      * Versions Affected:
        * 2.3.x before 2.3.32
        * 2.5.x before 2.5.10.1
* _Reference links_: (a long [list of references](https://www.cve.org/CVERecord?id=CVE-2017-5638){:target="_blank"} with additional information)

<i class="fas fa-info-circle" aria-hidden="true"></i> **MITRE ATT&CK** _tactics_ and _techniques_ are sometimes referenced in the description of the vulnerability, and are planned [to be formaly added to _CVE records_ soon](https://medium.com/mitre-engenuity/cve-mitre-att-ck-to-understand-vulnerability-impact-c40165111bf7){:target="_blank"}. Learn more about them in my blog post ["Introduction to MITRE ATT&CK"](/blog/intro-mitre-attack){:target="_blank"}
{:.alert.alert-info}

## NVD

The [National Institute of Standards and Technology (NIST)](https://www.nist.gov/){:target="_blank"} maintains the **[National Vulnerability Database (NVD)](https://nvd.nist.gov/vuln/search)** since 2005. It is [built upon and fully synchronized with the _CVE list_](https://cve.mitre.org/about/cve_and_nvd_relationship.html){:target="_blank"}, any update on _CVE_ website appears immediately in the _NVD_. But it also provides enhanced information such as fix, severity score, and impact ratings. _NVD_ also provides advanced searching features such as by OS; by vendor name, product name, and/or version number; and by vulnerability type, severity, related exploit range, and impact.

> The _NVD_ is the U.S. government repository of standards based vulnerability management data represented using the _Security Content Automation Protocol (SCAP)_. This data enables automation of vulnerability management, security measurement, and compliance. The _NVD_ includes databases of security checklist references, security-related software flaws, misconfigurations, product names, and impact metrics.
{:.quote}

The _NVD_ is also sponsored by [CISA](https://www.dhs.gov/cisa/cybersecurity-division/){:target="_blank"} (as is the _CVE program_), and is also available to the public and free to use.

An example _NVD_ entry for a _CVE id_ is the [CVE-2020-0796 NVD entry](https://nvd.nist.gov/vuln/detail/cve-2020-0796){:target="_blank"}:

**CVE-2020-0796**

* CVSS 3.X Severity and vector (more information in the following section)
  * Base Score: **10.0 CRITICAL**
  * Vector: `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:H/I:H/A:H`
* References to Advisories, Solutions, and Tools
  * [http://packetstormsecurity.com/files/156731/CoronaBlue-SMBGhost-Microsoft-Windows-10-SMB-3.1.1-Proof-Of-Concept.html](http://packetstormsecurity.com/files/156731/CoronaBlue-SMBGhost-Microsoft-Windows-10-SMB-3.1.1-Proof-Of-Concept.html), **Third Party Advisory**
  * [http://packetstormsecurity.com/files/156732/Microsoft-Windows-SMB-3.1.1-Remote-Code-Execution.html](http://packetstormsecurity.com/files/156732/Microsoft-Windows-SMB-3.1.1-Remote-Code-Execution.html), **Third Party Advisory**
  * [http://packetstormsecurity.com/files/156980/Microsoft-Windows-10-SMB-3.1.1-Local-Privilege-Escalation.html](http://packetstormsecurity.com/files/156980/Microsoft-Windows-10-SMB-3.1.1-Local-Privilege-Escalation.html)
  * [http://packetstormsecurity.com/files/157110/SMBv3-Compression-Buffer-Overflow.html](http://packetstormsecurity.com/files/157110/SMBv3-Compression-Buffer-Overflow.html)	
  * [http://packetstormsecurity.com/files/157901/Microsoft-Windows-SMBGhost-Remote-Code-Execution.html](http://packetstormsecurity.com/files/157901/Microsoft-Windows-SMBGhost-Remote-Code-Execution.html)
  * [http://packetstormsecurity.com/files/158054/SMBleed-SMBGhost-Pre-Authentication-Remote-Code-Execution-Proof-Of-Concept.html](http://packetstormsecurity.com/files/158054/SMBleed-SMBGhost-Pre-Authentication-Remote-Code-Execution-Proof-Of-Concept.html)
  * [https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2020-0796](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2020-0796), **Patch**, **Vendor Advisory**
* Weakness Enumeration
  * [CWE-119](https://cwe.mitre.org/data/definitions/119.html){:target="_blank"}, Improper Restriction of Operations within the Bounds of a Memory Buffer
* Known Affected Software Configurations
  * `cpe:2.3:o:microsoft:windows_10:1903:*:*:*:*:*:*:*`
  * `cpe:2.3:o:microsoft:windows_10:1909:*:*:*:*:*:*:*`
  * `cpe:2.3:o:microsoft:windows_server_2016:1903:*:*:*:*:*:*:*`
  * `cpe:2.3:o:microsoft:windows_server_2016:1909:*:*:*:*:*:*:*`
* Change History
  * 7 change records found [show changes](https://nvd.nist.gov/vuln/detail/cve-2020-0796#VulnChangeHistorySection)

[CPE (Common Platform Enumeration)](https://nvd.nist.gov/products){:target="_blank"} and [SWID (Software Identification)](https://csrc.nist.gov/projects/Software-Identification-SWID){:target="_blank"} are used to identify the software and version where a vulnerability has been found.

_NVD_ also includes references to the [Common Weakness Enumeration (CWE)](https://cwe.mitre.org/){:target="_blank"} by [MITRE](/blog/intro-mitre-attack#mitre-corporation) when describing the vulnerability.

<i class="fas fa-info-circle" aria-hidden="true"></i> When people talk about the information "on a _CVE_", they usually mean the extended information available on the _NVD_.
{:.alert.alert-info}

## CVSS

The [Common Vulnerability Scoring System (CVSS)](https://nvd.nist.gov/vuln-metrics/cvss){:target="_blank"} is a way to assess the severity of vulnerabilities. Two versions of this standard are used right now, _CVSS_ V2 and V3.1.

[CVSS V2 severity score](https://nvd.nist.gov/vuln-metrics/cvss/v2-calculator){:target="_blank"} ranks them as Low (0.0-3.9), Medium (4.0-6.9) or High (7.0-10.0). It also includes information about Base metrics (Access Vector, Access Complexity, Authentication) and Impact metrics (Confidentiality, Integrity, Availability) which combines in a formula for the base score, as well as Temporal metrics (Exploitability, Remediation Level, Report Confidence), Environmental metrics (Collateral Damage Potential, Target Distribution, Impact Subscore Modifier).

[CVSS V3.X severity score](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator){:target="_blank"} ranks vulnerabilities as None (0.0), Low (0.1-3.9), Medium (4.0-6.9), High (7.0-8.9) or Critical (9.0-10.0). It includes new metrics for User Interaction, Privileges required, and Scope; Access Complexity was renamed Attack Complexity, some metrics values were updated, and Environmental metrics were replaced by a second Base score known as Modified vector.

_CVSS_ V3.1 metrics and possible values are:

* Base Score
  * Attack Vector (AV): Network (N), Adjacent (A), Local (L), Physical (P) 
  * Attack Complexity (AC): Low (L), High (H)
  * Privileges Required (PR): None (N), Low (L), Hight (H)
  * User Interaction (UI): None (N), Required (R)
  * Scope (S): Unchanged (U), Changed (C)
  * Confidentiality (C): None (N), Low (L), High (H)
  * Integrity (I): None (N), Low (L), High (H)
  * Availability (A): None (N), Low (L), High (H)

* Temporal score
  * Exploit Code Maturity (E): Not Defined (X), Unproven (U), Proof-of-Concept (P), Functional (F), High (H)
  * Remediation Level (RL): Not Defined (X), Official Fix (O), Temporary Fix (T), Workaround (W), Unavailable (U)
  * Report Confidence (RC): Not Defined (X), Unknown (U), Reasonable (R), Confirmed (C)
   
* Environmental Score
  * Confidentiality Requirement (CR): Not Defined (X), Low (L), Medium (M), High (H)
  * Integrity Requirement (IR): Not Defined (X), Low (L), Medium (M), High (H)
  * Availability Requirement (AR): Not Defined (X), Low (L), Medium (M), High (H)
  * Modified Attack Vector (MAV): Not Defined (X), Network (N), Adjacent Network (A), Local (L), Physical (P)
  * Modified Attack Complexity (MAC): Not Defined (X), Low (L), High (H)
  * Modified Privileges Required (MPR): Not Defined (X), None, Low (L), High (H)
  * Modified User Interaction (MUI): Not Defined (X), None (N), Required (R)
  * Modified Scope (MS): Not Defined (X), Unchanged (U), Changed (C)
  * Modified Confidentiality (MC): Not Defined (X), None (N), Low (L), High (H)
  * Modified Integrity (MI): Not Defined (X), None (N), Low (L), High (H)
  * Modified Availability (MA): Not Defined (X), None (N), Low (L), High (H)

The metrics and values can be shown in a vector representation, that requires all metrics from the base score, and optionally some from the temporal or environmental score. The Severity is a combined score calculated with pre-established formula in the range from 0 to 10.

For example, for [CVE-2020-0796](https://nvd.nist.gov/vuln/detail/cve-2020-0796){:target="_blank"}:
* CVSS 3.X Severity: **10.0**
* Vector: `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:H/I:H/A:H`

Pretty scary that one, isn't it?

CVSS metrics is a complex topic that [requires further study](https://en.wikipedia.org/wiki/Common_Vulnerability_Scoring_System){:target="_blank"} if you want to learn the fine details about this information, where you can find several [websites](https://www.first.org/cvss/calculator/3.1){:target="_blank"} that assist in its calculation.

## Two kinds of vulnerabilities

Me and other experts say that [there is only two kinds of vulnerabilities](https://vaceituno.medium.com/only-two-classes-of-vulnerabilities-exist-not-three-233d1af89aac){:target="_blank"}: those that you are going to fix, and those that you are not.
{:.alert.alert-success.vicente-opinion}

A vulnerability scanner may show you in a container or host a plethora of found vulnerabilities on operating system or software packages. You usually should focus on:

* Those that have a _fix available_
* Those that have a _critical_ or _high_ score
* Those that have a _known exploit_

If there is a fix available, the decision is easy, go apply the fixing version. Be careful, sometimes when upgrading a component you may end up with more vulnerabilities than the one you were replacing. You may have the choice of upgrading the minor or the major version. An alternative could be to look for an equivalent piece of software or package that could replace the original one (that may be costly as it may require further modifications). In any case, integration and quality tests should be conducted prior to deploying to production to ensure the change works as expected.

Vulnerabilities with critical or high scores mean that they live on an important part of that software, or that if they are compromised the level of access a malicious actor can obtain is huge. But if there is no known exploit, it may be just something programmers have found not being done well in its code, but for which there is no practical way of exploiting. Several vulnerabilities like this, with _critical_ score, are old but have no fix because it's practically impossible to exploit.

<i class="fas fa-exclamation-triangle" aria-hidden="true"></i> An important additional consideration is **risk**: how critical is the workload you are protecting in the whole scheme of your application/infrastructure. For you, **workloads exposed to the public Internet**, that **handle payments** or **sensitive private personal information**, for example, should boost the priority of the vulnerabilities found there.
{:.alert.alert-warning}

Judging what to do in each situation is part of the security specialist's job.

## SCAP and OVAL

The [Security Content Automation Protocol (SCAP)](https://csrc.nist.gov/projects/security-content-automation-protocol){:target="_blank"} is a multi-purpose framework of specifications maintained by _NIST_ that supports automated configuration, vulnerability and patch checking, technical control compliance activities, and security measurement. 

The [Open Vulnerability and Assessment Language (OVAL)](https://oval.mitre.org/){:target="_blank"} is one of the standards defined in _SCAP_, designed to check for the presence of vulnerabilities and configuration issues on computer systems. _OVAL_ includes a language to encode system details and an assortment of content repositories held throughout the community. The [official OVAL repository](https://oval.cisecurity.org/repository){:target="_blank"} is hosted by the [Center for Internet Security (CIS)](https://www.cisecurity.org/){:target="_blank"}, but there are also [other repositories](https://oval.mitre.org/repository/about/other_repositories.html){:target="_blank"} like the ones provided by [Debian](https://www.debian.org/security/oval/){:target="_blank"}, or [Red Hat](https://www.redhat.com/security/data/oval/v2/){:target="_blank"}.

The [OpenSCAP](https://www.open-scap.org/){:target="_blank"} project is a collection of open source tools for implementing and enforcing this _SCAP_ and _OVAL_.

For example, Red Hat's [Atomic Scan](https://developers.redhat.com/blog/2016/05/02/introducing-atomic-scan-container-vulnerability-detection){:target="_blank"} is a container vulnerability scan tool by Red Hat that forms part of _OpenSCAP_, and can be used to search for vulnerabilities and check compliance defined as defined by _SCAP_.

## Is this all?

No, there are several more things you can learn from beyond _CVE_ and _NVD_.

Vulnerability scanners can use alternative sources of information in addition to the _CVE/NVD_, like the private, subscription-based [VulnDB](https://vulndb.cyberriskanalytics.com/){:target="_blank"}, or Google's [Open Source Vulnerabilities (OSV)](https://osv.dev/){:target="_blank"} database. Here you can find [a list of other vulnerability databases from mayor vendors](https://github.com/aquasecurity/vuln-list){:target="_blank"}, some in OVAL format, as well as their own CVE trackers. Some other security [vendors](https://avd.aquasec.com/){:target="_blank"} [provide](https://security.snyk.io/){:target="_blank"} [their own](https://msrc.microsoft.com/update-guide/vulnerability){:target="_blank"} vulnerability databases, but usually it's just a copy of the official _NVD_ with better UI (just look for the CVE number on each entry).

Other interesting sources of adversarial information are the [Malware Attribute Enumeration and Characterization (MAEC)](http://maecproject.github.io/){:target="_blank"} and the [Common Attack Pattern Enumeration and Classification (CAPEC)](/blog/intro-mitre-attack#capec), both also by [MITRE](/blog/intro-mitre-attack#mitre-corporation).

## Conclusion

The _Common Vulnerability and Exposures (CVE)_ by [MITRE](/blog/intro-mitre-attack#mitre-corporation) is a way to centralize the identification of vulnerabilities as they are discovered by several organizations. You should check the [National Vulnerability Database (NVD)](https://nvd.nist.gov/vuln/search){:target="_blank"} as it always improves on the base CVE, with additional information like the CVSS vulnerabilities metrics and severity. When using a vulnerability scanner, focus on critical and high vulnerabilities, that have a fix or a known exploit.

If there is something extra about CVEs that you want to know, you want some advice on _cloud-native cybersecurity_, or just want to chat with me, [<i class="fab fa-twitter" style="color:#1DA1F2;" aria-hidden="true"></i> let me know](https://twitter.com/vicen_herrera){:target="_blank"}.

And if you found this information useful, let others know and [<i class="fab fa-twitter" style="color:#1DA1F2;" aria-hidden="true"></i> share it in a tweet!](https://twitter.com/share?url={{ site.url }}{{ page.url }}&title={{ page.title | url_encode }}){:target="_blank"}

