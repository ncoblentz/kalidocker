FROM kalilinux/kali-rolling:latest as stage1
ARG PENTESTUSERPASSWORD
RUN useradd -m pentest && usermod -aG sudo pentest && echo "pentest:$PENTESTUSERPASSWORD" | chpasswd && chown -R pentest:pentest /home/pentest
RUN sed -i 's/http\.kali\.org/mirrors\.ocf\.berkeley\.edu/' /etc/apt/sources.list
#RUN cat /etc/apt/sources.list && sleep 1m
RUN apt-get update && apt-get -y upgrade && apt-get install -y wget cargo golang sudo flatpak fonts-liberation libu2f-udev libvulkan1 xdg-utils dbus-x11 xclip apt-transport-https git

FROM stage1 as stage2a
RUN apt-get install -y nano assetfinder subfinder whois dnsutils dnsrecon sublist3r amass nmap cloud-enum masscan ffuf sslyze massdns packagekit-gtk3-module libcanberra-gtk3-0 wordlists tmux screen burpsuite firefox-esr curl iputils-ping iproute2  sqlmap libpcap-dev make gcc build-essentials python3 python3-pip seclists 
WORKDIR /root
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && apt install ./google-chrome-stable_current_amd64.deb

FROM stage1 as stage2b
USER pentest
WORKDIR /home/pentest
RUN go install github.com/lc/gau/v2/cmd/gau@latest && go install github.com/sensepost/gowitness@latest && go install github.com/d3mondev/puredns/v2@latest && go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest && go install github.com/projectdiscovery/tlsx/cmd/tlsx@latest && go install -v github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest && go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest && ~/go/bin/nuclei -ut

FROM stage1 as stage2c
USER pentest
WORKDIR /home/pentest
RUN cargo install rustscan && cargo install ripgen

FROM stage1 as stage2d
USER pentest
WORKDIR /home/pentest
RUN git clone https://github.com/nullt3r/jfscan.git && cd jfscan && pip3 install .

FROM stage2a as final
VOLUME ["/data"]
VOLUME ["/tmp/.X11-unix/"]
VOLUME ["/home/pentest/.java/.userPrefs/burp/prefs.xml"]
VOLUME ["/home/pentest/.BurpSuite"]
WORKDIR /home/pentest
COPY --from=stage2b /home/pentest/go /home/pentest/go
COPY --from=stage2c /home/pentest/.cargo /home/pentest/.cargo
COPY --from=stage2d /home/pentest/.local /home/pentest/.local
COPY ./burppro.jar /home/pentest/
COPY ./burppro.sh /home/pentest/.local/bin/
COPY ./google-chrome-no-sandbox /home/pentest/.local/bin/
RUN chown -R pentest:pentest /home/pentest/.local/
RUN setcap CAP_NET_RAW+ep /usr/bin/masscan
USER pentest
RUN echo "export PATH=$PATH:~/go/bin:~/.cargo/bin:~/.local/bin" >> ~/.bashrc
