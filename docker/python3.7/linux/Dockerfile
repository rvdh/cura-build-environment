#
# cura-build-environment image based on Debian stretch with prebuilt Python
# 3.7.6.
#
FROM python:3.7.6-stretch

# Create unprivileged user
RUN groupadd -g 1000 ultimaker && \
    useradd -g ultimaker -u 1000 ultimaker -m

ADD docker-entrypoint.sh /docker-entrypoint.sh

# Change working directory
WORKDIR /home/ultimaker

RUN /docker-entrypoint.sh \
    rm /docker-entrypoint.sh
