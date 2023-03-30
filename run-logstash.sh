#!/bin/bash

ELA_PASSWORD=$(kubectl get secret elastic-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)

docker run --rm -d -p 5959:5959 -p 5960:5960 -v ~/git/elastic/logstash/pipeline:/usr/share/logstash/pipeline/  -v ~/git/elastic/logstash/settings/logstash.yml:/usr/share/logstash/config/logstash.yml -e ELASTIC_PASSWORD=$ELA_PASSWORD docker.elastic.co/logstash/logstash:8.6.2
