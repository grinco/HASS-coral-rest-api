ARG BUILD_FROM="homeassistant/amd64-base-ubuntu:20.04"
FROM ${BUILD_FROM}

WORKDIR /tmp

RUN apt-get update && apt-get install -y gnupg
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list
RUN echo "deb https://packages.cloud.google.com/apt coral-cloud-stable main" | tee /etc/apt/sources.list.d/coral-cloud.list

RUN apt-get update && apt-get install -y python3 wget unzip python3-pip
RUN apt-get -y install python3-edgetpu libedgetpu1-legacy-std

# install the APP
ENV APP_VERSION="2.2"
RUN cd /tmp && \
    wget "https://github.com/robmarkcole/coral-pi-rest-server/archive/refs/tags/${APP_VERSION}.zip" -O /tmp/server.zip && \
    unzip /tmp/server.zip && \
    rm -f /tmp/server.zip && \
    mv coral-pi-rest-server-${APP_VERSION} /app



WORKDIR /app
RUN  pip3 install --no-cache-dir -r requirements.txt 

# mitigate https://github.com/robmarkcole/coral-pi-rest-server/issues/66
RUN sed -i -e 's/port=args.port)/port=args.port, use_reloader=False)\n/' /app/coral-app.py

COPY run.sh /app
RUN chmod a+x /app/run.sh

EXPOSE 5000

CMD [ "/app/run.sh" ]

