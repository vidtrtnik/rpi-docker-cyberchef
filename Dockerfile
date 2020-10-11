FROM debian:buster

RUN apt-get update 
RUN apt-get install -y build-essential curl git phantomjs chromium libatomic1 libc6 libevent-2.1-6 libglib2.0-0 libicu63 libminizip1 libnspr4 libnss3 libre2-5 libstdc++6 libx11-6 zlib1g

#RUN curl http://ftp.de.debian.org/debian/pool/main/c/chromium/chromium-driver_83.0.4103.116-1~deb10u3_armhf.deb --output chromium-driver_83.0.4103.116-1~deb10u3_armhf.deb
RUN curl http://ftp.de.debian.org/debian/pool/main/c/chromium/chromium-driver_83.0.4103.116-1~deb10u3_arm64.deb --output chromium-driver_83.0.4103.116-1~deb10u3_arm64.deb

#RUN dpkg -i chromium-driver_83.0.4103.116-1~deb10u3_armhf.deb
RUN dpkg -i chromium-driver_83.0.4103.116-1~deb10u3_arm64.deb

#RUN rm chromium-driver_83.0.4103.116-1~deb10u3_armhf.deb
RUN rm chromium-driver_83.0.4103.116-1~deb10u3_arm64.deb

#RUN curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt install -y nodejs

RUN git clone https://github.com/gchq/CyberChef

WORKDIR /CyberChef
RUN sed -i '/"chromedriver": "^83.0.0",/d' package.json
RUN export QT_QPA_PLATFORM=offscreen && npm cache clean --force
RUN export QT_QPA_PLATFORM=offscreen && npm install -g
RUN export QT_QPA_PLATFORM=offscreen && npm install grunt-cli
RUN export QT_QPA_PLATFORM=offscreen && npm install -g grunt-cli http-server

RUN grunt prod

RUN npm audit fix
RUN apt autoremove

#ENTRYPOINT ["grunt","dev"]

WORKDIR /CyberChef/build/prod
EXPOSE 8080
ENTRYPOINT ["http-server", "-p", "8080"]
