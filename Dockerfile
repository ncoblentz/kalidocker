FROM kalilinux/kali-rolling:latest as stage1
ARG PENTESTUSERPASSWORD
RUN useradd -m pentest && usermod -aG sudo pentest && echo "pentest:$PENTESTUSERPASSWORD" | chpasswd && chown -R pentest:pentest /home/pentest
RUN apt-get update && apt-get -y upgrade && apt-get install -y wget cargo golang sudo flatpak fonts-liberation libu2f-udev libvulkan1 xdg-utils dbus-x11 xclip

FROM stage1 as stage2a
RUN apt-get install -y nano assetfinder openvpn subfinder whois dnsutils dnsrecon sublist3r amass nmap cloud-enum masscan ffuf sslyze seclists massdns packagekit-gtk3-module libcanberra-gtk3-0 wordlists tmux screen burpsuite firefox-esr curl iputils-ping iproute2 nuclei sqlmap git && nuclei -ut
WORKDIR /root
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && apt install ./google-chrome-stable_current_amd64.deb
COPY burppro.jar /home/pentest/burppro.jar

FROM stage1 as stage2b
USER pentest
WORKDIR /home/pentest
RUN go install github.com/lc/gau/v2/cmd/gau@latest && go install github.com/sensepost/gowitness@latest && go install github.com/d3mondev/puredns/v2@latest && go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest && go install github.com/projectdiscovery/tlsx/cmd/tlsx@latest

FROM stage1 as stage2c
USER pentest
WORKDIR /home/pentest
RUN cargo install rustscan && cargo install ripgen

FROM stage2a as final
VOLUME ["/data"]
VOLUME ["/tmp/.X11-unix/"]
VOLUME ["/home/pentest/.java/.userPrefs/burp/prefs.xml"]
VOLUME ["/home/pentest/.BurpSuite"]
USER pentest
WORKDIR /home/pentest
COPY --from=stage2b /home/pentest/go /home/pentest/go
COPY --from=stage2c /home/pentest/.cargo /home/pentest/.cargo
COPY ./burppro.jar /home/pentest/
COPY ./burppro.sh /home/pentest/.local/bin/

RUN echo "export PATH=$PATH:~/go/bin:~/.cargo/bin:~/.local/bin" >> ~/.bashrc