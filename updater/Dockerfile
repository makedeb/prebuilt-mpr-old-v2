FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install python3 python3-pip python3-apt python3-requests git -y

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt
RUN rm /requirements.txt

COPY main.py /usr/local/bin/prebuilt-mpr-updater
ENTRYPOINT ["/usr/local/bin/prebuilt-mpr-updater"]
