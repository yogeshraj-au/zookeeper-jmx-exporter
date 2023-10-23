# Use CentOS 7 as the base image
FROM centos:7

# Install Java (required for Kafka)
RUN yum install java-1.8.0-openjdk -y

#Install wget
RUN yum install wget -y

# Set the Kafka version
ENV KAFKA_VERSION=3.1.2
ENV SCALA_VERSION=2.13
ENV KAFKA_HOME=/opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"

# Download and extract Kafka
RUN wget "https://archive.apache.org/dist/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz" -O /tmp/kafka.tgz && \
    tar -xzf /tmp/kafka.tgz -C /opt && \
    rm /tmp/kafka.tgz

# Create Directory structure for monitoring
RUN mkdir -p $KAFKA_HOME/monitoring
ADD https://repo.maven.apache.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.15.0/jmx_prometheus_javaagent-0.15.0.jar $KAFKA_HOME/monitoring/
ADD https://raw.githubusercontent.com/prometheus/jmx_exporter/main/example_configs/zookeeper.yaml $KAFKA_HOME/monitoring/zookeeper.yaml

#Add the jmx config
RUN sed -i '43i export EXTRA_ARGS="-javaagent:$KAFKA_HOME/monitoring/jmx_prometheus_javaagent-0.15.0.jar=2200:$KAFKA_HOME/monitoring/zookeeper.yaml"' $KAFKA_HOME/bin/zookeeper-server-start.sh

# Expose necessary ports
EXPOSE 2181 2200

# Start ZooKeeper, Kafka, and MirrorMaker when the container starts
ENTRYPOINT ["/opt/kafka_2.13-3.1.2/bin/zookeeper-server-start.sh"]

CMD [ "/opt/kafka_2.13-3.1.2/config/zookeeper.properties" ]
