ARG BUILD_FROM="homeassistant/amd64-base-ubuntu:18.04"
FROM ${BUILD_FROM}

WORKDIR /tmp

RUN apt-get update && apt-get install -y gnupg
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list
RUN echo "deb https://packages.cloud.google.com/apt coral-cloud-stable main" | tee /etc/apt/sources.list.d/coral-cloud.list

RUN apt-get update && apt-get install -y python3 wget unzip python3-pip
RUN apt-get -y install python3-edgetpu libedgetpu1-legacy-std

# install the APP
RUN cd /tmp && \
    wget "https://github.com/robmarkcole/coral-pi-rest-server/archive/refs/tags/v1.0.zip" -O /tmp/server.zip && \
    unzip /tmp/server.zip && \
    rm -f /tmp/server.zip && \
    mv coral-pi-rest-server-1.0 /app



WORKDIR /app
RUN  pip3 install --no-cache-dir -r requirements.txt 

COPY run.sh /app
RUN chmod a+x /app/run.sh

EXPOSE 5000

CMD [ "/app/run.sh" ]

