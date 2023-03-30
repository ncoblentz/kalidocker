FROM kalilinux/kali-rolling:latest
ARG PENTESTUSERPASSWORD
VOLUME ["/data"]
VOLUME ["/tmp/.X11-unix/"]
RUN apt-get update && apt-get -y upgrade && apt-get install -y wget nano assetfinder tmux subfinder amass nmap cloud-enum masscan ffuf sslyze golang seclists cargo massdns xclip flatpak fonts-liberation libu2f-udev libvulkan1 xdg-utils dbus-x11 packagekit-gtk3-module libcanberra-gtk3-0 wordlists burpsuite sudo firefox-esr curl iputils-ping iproute2 screen nuclei sqlmap && nuclei -ut
WORKDIR /root
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && apt install ./google-chrome-stable_current_amd64.deb
RUN useradd -m pentest && usermod -aG sudo pentest && echo "pentest:$PENTESTUSERPASSWORD" | chpasswd && chown -R pentest:pentest /home/pentest
USER pentest
WORKDIR /home/pentest
RUN echo "export PATH=$PATH:~/go/bin:~/.cargo/bin:~/.local/bin" >> ~/.bashrc
RUN go install github.com/lc/gau/v2/cmd/gau@latest && go install github.com/sensepost/gowitness@latest && go install github.com/d3mondev/puredns/v2@latest && cargo install rustscan && cargo install ripgen
#WORKDIR /home/pentest/Downloads

#RUN wget -O burpproinstall.sh "https://portswigger-cdn.net/burp/releases/download?product=pro&version=2023.2.4&type=Linux" && chmod 700 burpproinstall.sh

#ENTRYPOINT ["/bin/sh"]
#CMD ["-c","/bin/bash"]
