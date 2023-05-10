- [Pentest Docker Image](#pentest-docker-image)
  - [Features](#features)
  - [Instructions](#instructions)
  - [Application Specific Notes](#application-specific-notes)
    - [Burp Suite Community](#burp-suite-community)
    - [GoWitness](#gowitness)
    - [Google Chrome](#google-chrome)
  - [Examples of Running the Image](#examples-of-running-the-image)
    - [Running](#running)
  - [Scratch](#scratch)

# Pentest Docker Image

__For Kali Linux-based, isolated pentesting with bare metal performance and X11 (GUI) Support regardless of your host machine's linux distribution.__

I find that I prefer a particular linux distribution as my desktop environment and a different linux distribution as a penetration testing distribution. However, I don't want the performance limitations of running the penetration testing distribution in a VM or the additional effort of cloning a new VM for each engagement, managing disk space, virtual cpus, and etc. This project is an experiment to determine the level of isolation I can achieve (there is a trade off as compared to a full VM) versus the increased convenience for setting up a new penetration testing base for each engagement.

![](screenshots/screenshot.jpg)

## Features

firefox-esr curl iputils-ping iproute2 nuclei sqlmap git && nuclei -ut
- Run Kali Linux as a docker image with preinstalled tools (customize further if you desire)
- Run as a lower privileged user (pentest) with sudo rights
- GUI (X11) support
- Persistent storage directory (a docker volume) to preserve data between container restarts (local directory `data_volume` is mounted at `/data` inside of the container)
- Preinstalled tools, including
  - Utilties
    - wget
    - nano
    - tmux
    - screen
    - xclip
    - sudo
    - firefox-esr
    - google chrome
  - Pentesting Tools
    - assetfinder
    - subfinder
    - amass
    - nmap
    - cloud-enum
    - masscan
    - ffuf
    - sslyze
    - seclists
    - massdns
    - wordlists
    - burpsuite
    - gau
    - gowitness
    - puredns  
    - rustscan  
    - ripgen
    - nuclei
    - sqlmap
    - httpx
    - tlsx
    - sqlmap
    - dnsrecon

## Instructions
1. Install the docker cli and daemon if not already installed: `sudo apt install docker docker.io docker-compose`
2. Clone this repository and cd into the cloned directory
3. `export DOCKERKALIPENTESTPASSWORD=youpasswordhere`: This will be the password for the `pentest` user inside the image
    - Use `IFS= read -p 'Docker Kali Pentest User Password: ' -r DOCKERKALIPENTESTPASSWORD` then `export DOCKERKALIPENTESTPASSWORD` if you don't want the password to show up in bash history
4. `mkdir -p data_volume`
5. `touch prefs.xml UserConfigPro.json` <-- `prefs.xml` is where the Burp Suite Pro license is stored.
6. `mkdir -p .BurpSuite` <-- `.BurpSuite` is where your extensions and configuration are stored
7. Enable BuildKit: `export DOCKER_BUILDKIT=1` ([Docker BuildKit Tutorial: Why do we need a new Docker Builder?](https://www.youtube.com/watch?v=3B89b_gXAPU))
8. Download the BurpSuite Pro Jar file from https://portswigger.net/burp/releases and save the jar as `burppro.jar`
9. Build the image with `docker-compose build`
10. Run the image with `docker-compose up -d`
11. Attach to the image with `docker attach kalidocker_dockerkali_1` (Detach with Ctrl+P then Ctrl+Q instead of exiting)
12. For more terminals, consider the following options:
    - using `tmux` (installed) or `screen` on the first terminal
    - Run `docker-compose exec dockerkali bash`
    - Run `docker exec -it kalidocker_dockerkali_1 bash`
13. the `/data_volume` directory is on the host mounted at `/data` inside docker to persist files
14. To run GUI applications from the docker container:
    - On the host: `xhost +local:*`
    - In the container: `google-chrome`
    - Remove xhost permissions afterward: `xhost -local:*`

## Application Specific Notes

### Burp Suite Community

Even though it runs as the user "pentest", it still complains about not being able to run the browser in a sandbox. To get the browser to run disable the sandbox (Really think about whether this is a good idea as it does expose you to risk). Go to Burp -> Settings -> Tools -> Burp's Browser, and check "Run Burp's browser without a sandbox".

### GoWitness
Run with `gowitness single -F https://www.example.com --chrome-path google-chrome-no-sandbox` or `gowitness file -f hosts.txt -F --chrome-path google-chrome-no-sandbox`

### Google Chrome

Run with `google-chrome --no-sandbox` and see the warning above.

## Examples of Running the Image

### Running

```bash
blah@~/Documents/kalidocker$ docker-compose up -d
Creating kalidocker_dockerkali_1 ... done

blah@~/Documents/kalidocker$ docker attach kalidocker_dockerkali_1
└─$ whoami
pentest

┌──(pentest㉿blah-Laptop)-[~/Downloads]
└─$ sudo whoami
[sudo] password for pentest: 
root

# Ctrl-P then Ctrl-Q
blah@~/Documents/kalidocker$
└─$ read escape sequence

~/Documents/kalidocker$ docker-compose exec dockerkali bash
┌──(pentest㉿blah-Laptop)-[~/Downloads]
└─$ exit
exit

blah@~/Documents/kalidocker$ docker-compose exec dockerkali bash
┌──(pentest㉿blah-Laptop)-[~/Downloads]
└─$ exit
exit

blah@~/Documents/kalidocker$ docker exec -it kalidocker_dockerkali_1 bash
┌──(pentest㉿blah-Laptop)-[~/Downloads]
└─$ sudo nmap www.google.com -p 80 -T4 -sV
Starting Nmap 7.93 ( https://nmap.org ) at 2023-03-24 14:25 UTC
Nmap scan report for www.google.com (142.250.190.68)
Host is up (0.016s latency).
Other addresses for www.google.com (not scanned): 2607:f8b0:4009:819::2004
rDNS record for 142.250.190.68: ord37s34-in-f4.1e100.net

PORT   STATE SERVICE VERSION
80/tcp open  http    gws
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port80-TCP:V=7.93%I=7%D=3/24%Time=641DB2EA%P=x86_64-pc-linux-gnu%r(GetR
SF:equest,36B0,"HTTP/1\.0\x20200\x20OK\r\nDate:\x20Fri,\x2024\x20Mar\x2020
SF:23\x2014:25:46\x20GMT\r\nExpires:\x20-1\r\nCache-Control:\x20private,\x
SF:20max-age=0\r\nContent-Type:\x20text/html;\x20charset=ISO-8859-1\r\nCon
SF:tent-Security-Policy-Report-Only:\x20object-src\x20'none';base-uri\x20'
SF:self';script-src\x20'nonce-KHoIIbmminm7vrJC2pEi9Q'\x20'strict-dynamic'\
SF:x20'report-sample'\x20'unsafe-eval'\x20'unsafe-inline'\x20https:\x20htt
SF:p:;report-uri\x20https://csp\.withgoogle\.com/csp/gws/other-hp\r\nP3P:\
SF:x20CP=\"This\x20is\x20not\x20a\x20P3P\x20policy!\x20See\x20g\.co/p3phel
SF:p\x20for\x20more\x20info\.\"\r\nServer:\x20gws\r\nX-XSS-Protection:\x20
SF:0\r\nX-Frame-Options:\x20SAMEORIGIN\r\nSet-Cookie:\x201P_JAR=2023-03-24
SF:-14;\x20expires=Sun,\x2023-Apr-2023\x2014:25:46\x20GMT;\x20path=/;\x20d
SF:omain=\.google\.com;\x20Secure\r\nSet-Cookie:\x20AEC=AUEFqZeT945Az4zj_-
SF:5RI2B2goVRgLa8R0R1Go-aZGEq0vXSozAcPtOGU0I;\x20expires=Wed,\x2020-Sep-20
SF:23\x2014:25:46\x20GMT;\x20path=/;\x20domain=\.google\.com;\x20Secure;\x
SF:20HttpOnly;\x20SameSite=lax\r\nSet-Cookie:\x20NID=511=vcg-mouczgRpm1poH
SF:Je1oFXbRdjkTqn6myEfzag3MqdWSaQiWgaih8ESysPkW8YJcrvcIPB")%r(HTTPOptions,
SF:70F,"HTTP/1\.0\x20405\x20Method\x20Not\x20Allowed\r\nAllow:\x20GET,\x20
SF:HEAD\r\nDate:\x20Fri,\x2024\x20Mar\x202023\x2014:25:46\x20GMT\r\nConten
SF:t-Type:\x20text/html;\x20charset=UTF-8\r\nServer:\x20gws\r\nContent-Len
SF:gth:\x201592\r\nX-XSS-Protection:\x200\r\nX-Frame-Options:\x20SAMEORIGI
SF:N\r\n\r\n<!DOCTYPE\x20html>\n<html\x20lang=en>\n\x20\x20<meta\x20charse
SF:t=utf-8>\n\x20\x20<meta\x20name=viewport\x20content=\"initial-scale=1,\
SF:x20minimum-scale=1,\x20width=device-width\">\n\x20\x20<title>Error\x204
SF:05\x20\(Method\x20Not\x20Allowed\)!!1</title>\n\x20\x20<style>\n\x20\x2
SF:0\x20\x20\*{margin:0;padding:0}html,code{font:15px/22px\x20arial,sans-s
SF:erif}html{background:#fff;color:#222;padding:15px}body{margin:7%\x20aut
SF:o\x200;max-width:390px;min-height:180px;padding:30px\x200\x2015px}\*\x2
SF:0>\x20body{background:url\(//www\.google\.com/images/errors/robot\.png\
SF:)\x20100%\x205px\x20no-repeat;padding-right:205px}p{margin:11px\x200\x2
SF:022px;overflow:hidden}ins{color:#777;text-decoration:none}a\x20img{bord
SF:er:0}@media\x20screen\x20and\x20\(max-width:772px\){body{background:non
SF:e;margin-top:0;max-width:none;padding-right:0}}#l");

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 61.54 seconds

```

## Scratch
`sudo apt install moby-buildx`
`wget -O burppro2023.2.4.jar 'https://portswigger-cdn.net/burp/releases/download?product=pro&version=2023.2.4&type=Jar'`
`java -XX:MaxRAMPercentage=50 -jar burppro2023.2.4.jar`
`docker cp kalidocker_dockerkali_1:/home/pentest/.java/.userPrefs/burp/prefs.xml prefs.xml`
`/home/pentest/.java/.userPrefs/burp/prefs.xml`
