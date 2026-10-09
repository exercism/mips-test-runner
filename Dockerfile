FROM eclipse-temurin:27_35-jdk@sha256:2771efbbc159b89dc38b82ebe01312fd1b5f226071ff715ca9edd5411a389761

RUN apt-get update && \
    apt-get install --yes --no-install-recommends jq && \
    apt-get purge --auto-remove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/test-runner

ADD https://github.com/dpetersanderson/MARS/releases/download/v.4.5.1/Mars4_5.jar /opt/test-runner/Mars4_5.jar

COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
