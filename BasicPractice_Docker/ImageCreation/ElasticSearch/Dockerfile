FROM debian:latest

# Install required dependencies
RUN apt update && apt install -y wget tar bash && \
    useradd -m -d /home/elk/ -s /bin/bash elk



WORKDIR /home/elk

# Download and extract Elasticsearch
RUN wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.17.2-linux-x86_64.tar.gz && \
    tar -xzf elasticsearch-8.17.2-linux-x86_64.tar.gz --strip-components=1 && \
    rm elasticsearch-8.17.2-linux-x86_64.tar.gz && \
    echo "network.host: 0.0.0.0" >> /home/elk/config/elasticsearch.yml && \
    echo "xpack.security.enabled: false" >> /home/elk/config/elasticsearch.yml && \
    echo "discovery.type: single-node" >> /home/elk/config/elasticsearch.yml && \
    chown -R elk:elk *

USER elk

EXPOSE 9200 9300

ENTRYPOINT ["/home/elk/bin/elasticsearch"]



