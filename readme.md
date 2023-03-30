DEPLOY ELASTIC ON THE CLUSTER

kubectl create -f https://download.elastic.co/downloads/eck/2.6.1/crds.yaml

kubectl apply -f https://download.elastic.co/downloads/eck/2.6.1/operator.yaml

```
cat <<EOF >> elastic.yaml
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: elastic
spec:
  version: 8.6.2
  nodeSets:
  - name: default
    count: 1
    config:
      node.store.allow_mmap: false
EOF
```

kubectl apply -f elastic.yaml

kubectl expose pod elastic-es-default-0 --type=NodePort --name=elastic-svc

#PASSWORD=$(kubectl get secret elastic-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')


------------------------------------------------------
DEPLOY KIBANA ON THE CLUSTER

```
cat <<EOF >> kibana.yaml
apiVersion: kibana.k8s.elastic.co/v1
kind: Kibana
metadata:
  name: kibana
spec:
  version: 8.6.2
  count: 1
  elasticsearchRef:
    name: elastic
  http:
    service:
      spec:
        type: LoadBalancer
  config:
    server.publicBaseUrl: https://swan.softwaremind.com
EOF
```

------------------------------------------------------
RUN LOGSTASH ON DOCKER

./run-logstash.sh


OR:

ELA_PASSWORD=$(kubectl get secret elastic-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)

docker run  --rm -p 5959:5959 -d -v ~/git/elastic/logstash/pipeline:/usr/share/logstash/pipeline/  -v ~/git/elastic/logstash/settings/logstash.yml:/usr/share/logstash/config/logstash.yml -e ELASTIC_PASSWORD=$ELA_PASSWORD docker.elastic.co/logstash/logstash:8.6.2
