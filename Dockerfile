FROM kalilinux/kali-rolling:latest
VOLUME ["/data"]
RUN echo "export PATH=$PATH:~/go/bin:~/.cargo/bin:~/.local/bin" >> ~/.zshrc
RUN apt-get update && apt-get -y upgrade && apt-get install -y wget nano assetfinder tmux subfinder amass nmap cloud-enum masscan ffuf sslyze golang seclists cargo massdns xclip flatpak
RUN go install github.com/lc/gau/v2/cmd/gau@latest && go install github.com/sensepost/gowitness@latest && go install github.com/d3mondev/puredns/v2@latest 
RUN cargo install rustscan && cargo install ripgen 
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && dpkg -i google-chrome-stable_current_amd64.deb
#RUN ln -s /usr/share/seclists /usr/share/wordlists/seclists 
#ENTRYPOINT ["/bin/sh"]
#CMD ["/bin/bash"]
