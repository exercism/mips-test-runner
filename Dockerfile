FROM eclipse-temurin:27_35-jdk@sha256:473d02d477a8152a05dc42fde10b965754f1863d45e586a97763ef298965c48b

RUN apt-get update && \
    apt-get install --yes --no-install-recommends jq && \
    apt-get purge --auto-remove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/test-runner

ADD https://github.com/dpetersanderson/MARS/releases/download/v.4.5.1/Mars4_5.jar /tmp/Mars4_5.jar

# Repack the MARS jar without its "Class-Path: ." manifest entry. The JVM
# refuses to create or use an AOT cache when a non-empty directory is on the
# class path, and "." would put /opt/test-runner there.
RUN mkdir /tmp/mars && \
    cd /tmp/mars && \
    jar --extract --file /tmp/Mars4_5.jar && \
    rm META-INF/MANIFEST.MF && \
    jar --create --file /opt/test-runner/Mars4_5.jar --main-class Mars . && \
    rm -rf /tmp/mars /tmp/Mars4_5.jar

COPY . .

# Run MARS once on a sample solution to record an AOT cache. Each run loads the
# classes MARS needs from the cache, already parsed and linked, so the JVM
# starts much faster.
RUN java -XX:AOTCacheOutput=/opt/test-runner/mars.aot -Djava.util.prefs.userRoot=/tmp \
      -jar /opt/test-runner/Mars4_5.jar nc aot-training/runner.mips aot-training/impl.mips
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
