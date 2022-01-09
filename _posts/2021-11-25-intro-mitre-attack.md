---
layout: post
title:  "Introduction to MITRE ATT&CK"
tags: MITRE ATT&CK D3FEND security cybersecurity cloud-native
category: Security
excerpt_separator: <!--more-->
date: 2021-11-25 19:34:00 +01
image:
  src: /blog/images/featured/mitre-attack-logo.png
  width: 644   # in pixels
  height: 163   # in pixels
  alt: MITRE ATT&CK logo
pin: false
description: When you start working on cybersecurity, you see references to things like privilege escalation, lateral movement, or exfiltration all the time. What do they exactly mean?
---

When you start working on cybersecurity, you for sure start seeing references to things like **privilege escalation**, **lateral movement**, or **exfiltration** continuously.<!--more--> As categories for security tools, rules, or types of attacks, with mentions to something called **MITRE**.

Then you head to the **[MITRE ATT&CK website](https://attack.mitre.org/matrices){:target="_blank"}** and discover a treasure of useful information. But it is a huge amount of it, and in retrospect, a gentler introduction to what it is there and how to consume it would be useful.

This is my explanation to other people starting to look into the **MITRE ATT&CK framework**, _The MITRE Corporation_, its activities, and other interesting tools from them.


## What is this information useful for?

The **MITRE ATT&CK framework** provides information that is useful to categorize cybersecurity tools, rules, actions, and attacks; in a way that mentioning a single tactic or technique name (or its id), can give people a lot of context of what it is about. It doesn’t employ a very long or formal description about each one, but instead, a summary accompanied by several very relevant exploitation samples and mitigation information with many references. It also provides many real-world categorized examples of well-documented threats.

What _MITRE ATT&CK_ is not good for is to replicate automated tests on evaluated infrastructure, or to automatically classify malware or adversarial activity. That is up to other tools, some of which are referenced later in this article.


## MITRE Corporation

**The MITRE Corporation** is a not-for-profit USA organization that, as they state, works in the public interest across federal, state, and local governments, as well as industry and academia.

As you can read in [their FAQ](https://www.mitre.org/sites/default/files/pdf/media-FAQs-2018.pdf){:target="_blank"}:

> We bring innovative ideas into existence in areas
as varied as artificial intelligence, intuitive data science, quantum information science, health
informatics, space security, policy, and economic expertise, trustworthy autonomy, cyber threat
sharing, and cyber resilience.
We operate [FFRDCs](https://www.mitre.org/centers/we-operate-ffrdcs){:target="_blank"} —federally funded research and development centers. We also have
an independent research program that explores new and expanded uses of technologies to solve
our sponsors' problems. Our federal sponsors include the Department of Defense, the Federal Aviation Administration, the Internal Revenue Service, the Department of Veterans Affairs, the Department of Homeland Security, the Administrative Office of the U.S. Courts, the Centers for Medicare & Medicaid Services, and the National Institute of Standards and Technology.
{:.quote}

They have some interesting free publications like [Ten Strategies of a World-Class](https://www.mitre.org/publications/all/ten-strategies-of-a-world-class-cybersecurity-operations-center){:target="_blank"}, [Cybersecurity Operations Center](https://www.mitre.org/publications/all/ten-strategies-of-a-world-class-cybersecurity-operations-center){:target="_blank"}, and other works unrelated to cybersecurity like [AI Ethics discussion](https://govmatters.tv/tech-leadership-series-a-i-ethics/){:target="_blank"} or [Space Policy podcast](https://www.aiaa.org/events-learning/podcasts){:target="_blank"}.

<i class="fas fa-info-circle" aria-hidden="true"></i> "MITRE" is not an acronym, has no special meaning, and their official full name is just "The MITRE Corporation".
{:.alert.alert-info}


## MITRE ATT&CK

Among their initiatives, is the creation and update of the **[MITRE ATT&CK framework](https://attack.mitre.org/){:target="_blank"}**, a knowledge base of cybersecurity adversary Tactics, Techniques, and Procedures (sometimes called TTP).

_ATT&CK_ is very well known in the cybersecurity community as it is an invaluable resource for learning about and mapping security threats and tools.

![MITRE ATT&CK](/blog/images/mitre-attack.png "MITRE ATT&CK"){: .shadow}
_Screenshot of the MITRE ATT&CK enterprise matrix, with tactics and techniques_

_ATT&CK_ includes definitions of **tactics**, that include several **techniques** and **subtechniques**, which in turn group related adversarial behaviors. They are represented in different nested **matrices** depending on the field of application, the main ones being _Enterprise_ and _Mobile_.

The official full name of the project is _MITRE ATT&CK®_, including the registered trademark that you should use in an official product that mentions it.
{: .note}


### Matrices

The **matrices** are a way to scope the knowledge base hierarchically depending on the field of application:

<div class="table-wrapper">
<table class="dashed-table">
    <tbody>
        <tr>
            <td rowspan=12><a href="https://attack.mitre.org/matrices/enterprise/" target="_blank">Enterprise</a></td>
            <td colspan=3><a href="https://attack.mitre.org/matrices/enterprise/pre/" target="_blank">PRE</a> (preparatory techniques)</td>
        </tr>
        <tr>
            <td colspan=2><a href="https://attack.mitre.org/matrices/enterprise/windows/" target="_blank">Windows</a></td>
        </tr>
        <tr>
            <td colspan=2><a href="https://attack.mitre.org/matrices/enterprise/macos/" target="_blank">MacOS</a></td>
        </tr>
        <tr>
            <td colspan=2><a href="https://attack.mitre.org/matrices/enterprise/linux/" target="_blank">Linux</a></td>
        </tr>
        <tr>
            <td rowspan=6><a href="https://attack.mitre.org/matrices/enterprise/cloud/" target="_blank">Cloud</a></td>
        </tr>
        <tr>
            <td><a href="https://attack.mitre.org/matrices/enterprise/cloud/office365/" target="_blank">Office 365</a></td>
        </tr>
        <tr>
            <td colspan=2><a href="https://attack.mitre.org/matrices/enterprise/cloud/azuread/" target="_blank">Azure AD</a> (Active Directory)</td>
        </tr>
        <tr>
            <td><a href="https://attack.mitre.org/matrices/enterprise/cloud/googleworkspace/" target="_blank">Google Workspace</a></td>
        </tr>
        <tr>
            <td><a href="https://attack.mitre.org/matrices/enterprise/cloud/saas/" target="_blank">SaaS</a> (cloud managed services)</td>
        </tr>
        <tr>
            <td><a href="https://attack.mitre.org/matrices/enterprise/cloud/iaas/" target="_blank">IaaS</a> Infrastructure as a Service<br>(classic cloud provider infrastructure)</td>
        </tr>
        <tr>
            <td colspan=2><a href="https://attack.mitre.org/matrices/enterprise/network/" target="_blank">Network</a></td>
        </tr>
        <tr>
            <td colspan=2><a href="https://attack.mitre.org/matrices/enterprise/containers/" target="_blank">Containers</a></td>
        </tr>
        <tr>
            <td rowspan=2><a href="https://attack.mitre.org/matrices/mobile/" target="_blank">Mobile</a></td>
            <td colspan=2><a href="https://attack.mitre.org/matrices/mobile/android/" target="_blank">Android</a></td>
        </tr>
        <tr>
            <td colspan=2><a href="https://attack.mitre.org/matrices/mobile/ios/" target="_blank">iOS</a></td>
        </tr>
        <tr>
            <td colspan=3><a href="https://collaborate.mitre.org/attackics/index.php/Main_Page" target="_blank">ICS</a> (industrial control systems)</td>
        </tr>
    </tbody>
</table>
</div>

If are interested mostly in **cloud-native security** (containers, Kubernetes, and cloud), you should focus on _containers_ and _IaaS_ matrices, followed closely by _Linux_, _Cloud SaaS_, and _Networking_. The latest matrices to be added have been _Cloud_ and _Containers_ in 2021, but the list keeps growing.

When you access one of the specialized matrices, you will see in it only the tactics and techniques that are relevant to the platform, but when you click on any of them you will see the same generic information with all data relevant to all platforms unfiltered.


### Tactics

**Tactics** are the first level of classification for adversarial activities. They do not contain adversarial information directly, they only serve as sets to group _techniques_ that are the ones that do contain it. 


The list of all possible available _tactics_ on any of the _matrices_ is:

* [Reconnaissance](https://attack.mitre.org/tactics/TA0043/){:target="_blank"}: The adversary is trying to gather information they can use to plan future operations.
* [Resource Development](https://attack.mitre.org/tactics/TA0042/){:target="_blank"}: The adversary is trying to establish resources they can use to support operations.
* [Initial Access](https://attack.mitre.org/tactics/TA0001/){:target="_blank"}: The adversary is trying to get into your network.
* [Execution](https://attack.mitre.org/tactics/TA0002/){:target="_blank"}: The adversary is trying to run malicious code.
* [Persistence](https://attack.mitre.org/tactics/TA0003/){:target="_blank"}: The adversary is trying to maintain their foothold.
* [Privilege Escalation](https://attack.mitre.org/tactics/TA0004/){:target="_blank"}: The adversary is trying to gain higher-level permissions.
* [Defense Evasion](https://attack.mitre.org/tactics/TA0005/){:target="_blank"}: The adversary is trying to avoid being detected.
* [Credential Access](https://attack.mitre.org/tactics/TA0006/){:target="_blank"}: The adversary is trying to steal account names and passwords.
* [Discovery](https://attack.mitre.org/tactics/TA0007/){:target="_blank"}: The adversary is trying to figure out your environment.
* [Lateral Movement](https://attack.mitre.org/tactics/TA0008/){:target="_blank"}: The adversary is trying to figure out your environment.
* [Collection](https://attack.mitre.org/tactics/TA0009/){:target="_blank"}: The adversary is trying to gather data of interest to their goal.
* [Command and Control](https://attack.mitre.org/tactics/TA0011/){:target="_blank"}: The adversary is trying to communicate with compromised systems to control them.
* [Exfiltration](https://attack.mitre.org/tactics/TA0010/){:target="_blank"}: The adversary is trying to steal data.
* [Impact](https://attack.mitre.org/tactics/TA0040/){:target="_blank"}: The adversary is trying to manipulate, interrupt, or destroy your systems and data.

<i class="fas fa-exclamation-triangle" aria-hidden="true"></i> Understanding this list of tactics, what each one means and the difference between each other is the most direct value you are going to take from _ATT&CK_. Go ahead and visit each one of their links to read their definitions.
{:.alert.alert-warning}

Only relevant _tactics_ and _techniques_ are included on each matrix, so they may not show in their representation on _ATT&CK_ website.


### Techniques

_Tactics_ contain several _techniques_ and _subtechniques_, that is the categorization level that holds direct information of related adversarial behaviors.

When browsing a _matrix_ on _ATT&CK_ website, once you visit the link on a specific _technique_, you will be taken to the general description for the _technique_ that is common to any of the _matrices_, and the _procedures_ and _mitigations_ listed will not be specific to the _matrix_ you were browsing. Also, some _techniques_ are featured in more than one _tactic_ (it is an n:m mapping).

The full list of _techniques_ is too varied to list here.  Visit the [MITRE ATT&CK website](https://attack.mitre.org/){:target="_blank"} and browse the full catalog for that. Let's take a look here at an example of one of the _techniques_ to see the kind of information we can find there.


#### Exploitation for Privilege Escalation

The **[Exploitation for Privilege Escalation](https://attack.mitre.org/techniques/T1068/){:target="_blank"}** technique is described in _ATT&CK_ as:

> Adversaries may exploit software vulnerabilities in an attempt to elevate privileges. Exploitation of a software vulnerability occurs when an adversary takes advantage of a programming error in a program, service, or within the operating system software or kernel itself to execute adversary-controlled code. Security constructs such as permission levels will often hinder access to information and use of certain techniques, so adversaries will likely need to perform privilege escalation to include use of software exploitation to circumvent those restrictions.
{:.quote}

It includes descriptions for 26 **procedures examples**, including:

* [G0080](https://attack.mitre.org/groups/G0080){:target="_blank"} : [Cobalt Group](https://attack.mitre.org/groups/G0080){:target="_blank"} has used exploits to increase their levels of rights and privileges.[[10]](https://www.group-ib.com/blog/cobalt)
* [S0154](https://attack.mitre.org/software/S0154){:target="_blank"} : [Cobalt Strike](https://attack.mitre.org/software/S0154){:target="_blank"} can exploit vulnerabilities such as MS14-058. [[11]](https://www.cobaltstrike.com/downloads/reports/tacticstechniquesandprocedures.pdf){:target="_blank"} [[12]](https://web.archive.org/web/20210708035426/https://www.cobaltstrike.com/downloads/csmanual43.pdf){:target="_blank"}
* [S0601](https://attack.mitre.org/software/S0601/){:target="_blank"} : [Hildegard](https://attack.mitre.org/software/S0601/){:target="_blank"} has used the BOtB tool which exploits CVE-2019-5736.[[18]](https://unit42.paloaltonetworks.com/hildegard-malware-teamtnt/)
* [S0654](https://attack.mitre.org/software/S0654/){:target="_blank"} : [ProLock](https://attack.mitre.org/software/S0654/){:target="_blank"} can use CVE-2019-0859 to escalate privileges on a compromised host.[[23]](https://groupib.pathfactory.com/ransomware-reports/prolock_wp)
* [S0603](https://attack.mitre.org/software/S0603/){:target="_blank"} : [Stuxnet](https://attack.mitre.org/software/S0603/){:target="_blank"} used MS10-073 and an undisclosed Task Scheduler vulnerability to escalate privileges on local Windows machines.[[26]](https://www.wired.com/images_blogs/threatlevel/2010/11/w32_stuxnet_dossier.pdf){:target="_blank"}

As you can see, the procedures mention _Groups_ (G) as well as _Software_ (S). Although links to the **CVE**s (Common Vulnerabilities and Exposures) are not provided, you can check them on [its website also from MITRE](https://www.cve.org/){:target="_blank"}. The numbered links take you to original publications from independent published research from renowned organizations and security companies, where each one of the procedures has been explained in detail for the first time.

One of the 5 **mitigations** described in this _technique_ is:

* [M1048 Application Isolation and Sandboxing](https://attack.mitre.org/mitigations/M1048/){:target="_blank"}: Make it difficult for adversaries to advance their operation through exploitation of undiscovered or unpatched vulnerabilities by using sandboxing. Other types of virtualization and application microsegmentation may also mitigate the impact of some types of exploitation. Risks of additional exploits and weaknesses in these systems may still exist. [[33]](https://arstechnica.com/information-technology/2017/03/hack-that-escapes-vm-by-exploiting-edge-browser-fetches-105000-at-pwn2own/){:target="_blank"}

And the single **detection mechanism** listed is:

* [DS0027](https://attack.mitre.org/datasources/DS0027/){:target="_blank"} [Driver](https://attack.mitre.org/datasources/DS0027/){:target="_blank"}: [Driver Load](https://attack.mitre.org/datasources/DS0027/){:target="_blank"}

With more information about difficulties and behaviors to take into consideration for detections.


## ATT&CK Navigator

MITRE ATT&CK Navigator is an [open-source webapp](https://github.com/mitre-attack/attack-navigator){:target="_blank"} that you can [use online](https://mitre-attack.github.io/attack-navigator/){:target="_blank"} or run [locally](https://github.com/mitre-attack/attack-navigator#install-and-run){:target="_blank"}, to provide basic navigation and annotation of _ATT&CK_ matrices, similar to what you could do manually exporting the original matrices to Excel.

It makes it easy to define your own layer to highlight and filter some of the tactics and techniques defined in _ATT&CK_, maybe to represent techniques involved in an attack, or covered by a security tool.

![MITRE ATT&CK Navigator](/blog/images/mitre-attack-navigator.png "MITRE ATT&CK Navigator"){:target="_blank"}
_Screenshot of the MITRE ATT&CK Navigator with a layer showing all tactics and techniques_

You can export or import the layers' data in JSON format.


## CAPEC

The [Common Attack Pattern Enumeration and Classification (CAPEC)](https://capec.mitre.org/){:target="_blank"} is as they state:

> A comprehensive dictionary of known patterns of attack employed by adversaries to exploit known weaknesses in cyber-enabled capabilities.
{:.quote}

It has many things in common with _ATT&CK_ but compiled from a different angle. In my opinion, it has more data that is more structured and with better references, but that is more difficult to navigate to learn from it “by hand” unfiltered. In my work on cybersecurity, I see _ATT&CK_ referenced many times (sometimes as a synonym for _MITRE_ itself in the cybersecurity world), but I’ve never seen _CAPEC_ referenced. See their article on the main differences between [here](https://capec.mitre.org/about/attack_comparison.html){:target="_blank"}.

![MITRE CAPEC](/blog/images/mitre-capec.png "MITRE CAPEC")
_Diagram of the relation between CWE, CAPEC, and CVE_

Read an example of _CAPEC_ information for [SQL injection here](https://capec.mitre.org/data/definitions/66.html){:target="_blank"}.


## MITRE D3FEND

[MITRE D3FEND](https://d3fend.mitre.org){:target="_blank"} is a knowledge graph of cybersecurity countermeasures. While _ATT&CK_ shows tactics, techniques, and procedures for adversary actions, _D3FEND_ shows corresponding countermeasures.

![MITRE D3FEND](/blog/images/mitre-defend.png "MITRE D3FEND"){:target="_blank"}
_Screenshot of MITRE D3FEND technique tree_

It was published in 2021 and still has to pass some time for security tools to use if, but it should be useful to map what is the real protective coverage of the tools you are using, and in which areas you may want to look for additional ones.

[![MITRE ATT&CK to D3FEND DAO](/blog/images/mitre-attack-dao-defend.png "MITRE ATT&CK to D3FEND DAO")](https://d3fend.mitre.org/dao){:target="_blank"}
_Diagram showing digital artifact ontology relation between offensive and defensive models_ 

Expect soon an article from me telling more about _MITRE D3FEND_.


## Other projects and tools

In addition to _ATT&CK_ matrices, _MITRE_ provides several other related projects and knowledge bases related to cybersecurity.


### Adversary Emulation Library

The **[Adversary Emulation Library](https://github.com/center-for-threat-informed-defense/adversary_emulation_library){:target="_blank"}** is a compilation of plans that adversaries may take on an organization based on the real-world threats they face. _Emulation plans_ are an essential component in testing current defenses for organizations that are looking to prioritize their defenses around actual adversary behavior.

They are designed to empower red teams to manually emulate a specific threat actor to test and evaluate defensive capabilities from a threat-informed perspective. Rather than focusing on static signatures, these intelligence-driven emulation plans provide a repeatable means to test and tune defensive capabilities and products against the evolving _Tactics_, _Techniques_, and _Procedures_ (TTPs) of threat actors and malware.

[Learn more on this blog post from MITRE](https://medium.com/mitre-engenuity/introducing-the-all-new-adversary-emulation-plan-library-234b1d543f6b){:target="_blank"}


### CALDERA

**[CALDERA](https://github.com/mitre/caldera){:target="_blank"}** is a cybersecurity platform designed to easily automate adversary emulation, assist manual red-teams, and automate incident response, using the Adversary Emulation Library and built on top of the _MITRE ATT&CK_ framework.

It is not a simple tool, and you will need specialized training to obtain the best out of it. Read more about it on [its documentation website](https://caldera.readthedocs.io/en/latest/){:target="_blank"}.


### Threat Report ATT&CK Mapping

**[Threat Report ATT&CK Mapping (TRAM)](https://github.com/center-for-threat-informed-defense/tram/){:target="_blank"}** is an open-source platform designed to automate the mapping of cyber threat intelligence reports to MITRE ATT&CK.

Using Machine Learning, you can train a model to read threat intelligence reports. The results can be generated in a JSON format that can be imported into _ATT&CK Navigator_ for visualization.


### ATT&CK and CAPEC STIX Data

**Structured Threat Information Expression (STIX)** is a language and serialization format used to exchange _Cyber Threat Intelligence_ (CTI). There are two repositories that stores data for _ATT&CK_ and _CAPEC_ in STIX format:

* [github.com/mitre-attack/attack-stix-data](https://github.com/mitre-attack/attack-stix-data){:target="_blank"} : repository contains the _MITRE ATT&CK_ dataset represented in STIX 2.1 JSON collections. 

* [github.com/mitre/cti](https://github.com/mitre/cti){:target="_blank"} : _MITRE ATT&CK_ and _CAPEC_ datasets expressed in STIX 2.0.


## Conclusion

_The MITRE Corporation_ is an important source of diverse cybersecurity information. The _MITRE ATT&CK framework_ contains descriptions of _Tactics_, _Techniques_, and _Procedures_ that help categorize and research security threats.

If you think I should include more information on any of the _MITRE_ tools, want some advice on _cloud-native cybersecurity_, or just want to chat with me, [<i class="fab fa-twitter" style="color:#1DA1F2;" aria-hidden="true"></i> let me know](https://twitter.com/vicen_herrera){:target="_blank"}.

And if you found this information useful, let others know and [<i class="fab fa-twitter" style="color:#1DA1F2;" aria-hidden="true"></i> share it in a tweet](https://twitter.com/share?url={{ site.url }}{{ page.url }}&title={{ page.title | url_encode }}){:target="_blank"}, or [buy me a coffee](https://ko-fi.com/R5R77UF84){:target="_blank"} if you want!
