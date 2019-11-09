FROM ubuntu:18.04


ENV DEBIAN_FRONTEND noninteractive
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all

ENV NOMACHINE_URL https://download.nomachine.com/download/6.8/Linux/nomachine_6.8.1_1_amd64.deb

RUN apt update && apt dist-upgrade -y
RUN apt install -y vim xterm pulseaudio cups firefox nano sudo curl gdebi
RUN apt install -y mate-desktop-environment-core mate-desktop-environment mate-indicator-applet ubuntu-mate-themes ubuntu-mate-wallpapers
RUN apt install -y bash-completion

RUN curl -SL "$NOMACHINE_URL" -o nomachine.deb

RUN gdebi --n nomachine.deb

RUN apt autoclean -y
RUN apt remove -y

RUN echo 'pref("browser.tabs.remote.autostart", false);' >> /usr/lib/firefox/browser/defaults/preferences/vendor-firefox.js
RUN rm -rf /var/lib/apt/lists/*

RUN groupadd -r nomachine -g 433 && \
useradd -u 431 -r -g nomachine -d /home/nomachine -s /bin/bash -c "NoMachine" nomachine && \
mkdir /home/nomachine && \
chown -R nomachine:nomachine /home/nomachine && \
echo 'nomachine:nomachine' | chpasswd

RUN echo "nomachine    ALL=(ALL) ALL" >> /etc/sudoers


ADD nxserver.sh /
RUN chmod +x /nxserver.sh

EXPOSE 4000

VOLUME /home/nomachine

ENTRYPOINT /nxserver.sh
