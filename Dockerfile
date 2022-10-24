FROM python:3.7-stretch

# Requirements for sdl
RUN apt-get update && apt-get install -y \
    gcc \
    musl-dev \
    curl \
    apt-utils

# RMR repository
RUN curl -s "https://packagecloud.io/install/repositories/o-ran-sc/release/script.deb.sh" | bash

# Install RMR library
RUN mkdir -p /opt/route/
COPY init/test_route.rt /opt/route/route.rt
ENV LD_LIBRARY_PATH /usr/local/lib/:/usr/local/lib64
ENV RMR_SEED_RT /opt/route/route.rt

RUN apt-get update && apt-get install -y \
    rmr=4.8.2 \
    && rm -rf /var/lib/apt/lists/*



RUN mkdir -p /app
COPY app/ app/

WORKDIR /app

RUN  pip install -r requirements.txt


ENV PYTHONUNBUFFERED 1
# ENV CONFIG_FILE=/app/init/config-file.json

# For Default DB connection, modify for resp kubernetes env
ENV DBAAS_SERVICE_PORT=6379
ENV DBAAS_SERVICE_HOST=service-ricplt-dbaas-tcp.ricplt.svc.cluster.local

