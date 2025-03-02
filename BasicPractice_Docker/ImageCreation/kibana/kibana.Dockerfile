# Use a lightweight Ubuntu base image
FROM ubuntu:jammy

# ENV ElasticsearchContainerName=esC1
# Install dependencies
RUN apt update && \
    apt install -y wget tar bash && apt clean && rm -rf /var/lib/apt/lists/* && \ 
    useradd -m -d /home/kibana -s /bin/bash kibana

# Default value for Elasticsearch container name
ARG ElasticsearchContainerName=esC1

# Set the environment variable (this can be overridden)
ENV ElasticsearchContainerName=${ElasticsearchContainerName}

WORKDIR /home/kibana

COPY kibana-8.17.2-linux-x86_64.tar.gz /home/kibana/
# Download and extract Kibana
RUN tar -xzf kibana-8.17.2-linux-x86_64.tar.gz --strip-components=1 && \
    rm kibana-8.17.2-linux-x86_64.tar.gz && \
    echo "server.host: 0.0.0.0" >> /home/kibana/config/kibana.yml && \
    echo "elasticsearch.hosts: [\"http://${ElasticsearchContainerName}:9200\"]" >> /home/kibana/config/kibana.yml && \
    chown -R kibana:kibana /home/kibana && chmod -R 755 /home/kibana

USER kibana

# Kibana config for single-node mode
# RUN 

EXPOSE 5601

# WORKDIR /home/kibana/bin

ENTRYPOINT ["/home/kibana/bin/kibana"]
