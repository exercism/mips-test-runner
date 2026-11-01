FROM eclipse-temurin:27_35-jdk@sha256:473d02d477a8152a05dc42fde10b965754f1863d45e586a97763ef298965c48b

RUN apt-get update && \
    apt-get install --yes --no-install-recommends jq && \
    apt-get purge --auto-remove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/test-runner

ADD https://github.com/dpetersanderson/MARS/releases/download/v.4.5.1/Mars4_5.jar /opt/test-runner/Mars4_5.jar

COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
