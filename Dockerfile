FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install python3 python3-pip python3-apt python3-requests git -y

# Copy requirements.txt manually first so we don't reinstall deps every time we modify a file in this repository.
COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt
RUN rm /requirements.txt

COPY ./ /usr/local/share/prebuilt-mpr

ENTRYPOINT ["/usr/local/share/prebuilt-mpr/main.py"]
