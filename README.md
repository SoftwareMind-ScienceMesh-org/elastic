
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

#PASSWORD=$(kubectl get secret elastic-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')

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
    server.publicBaseUrl: https://rds.softwaremind.com
EOF
```

kubectl get secret quickstart-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo

kubectl expose pod elastic-es-default-0 --type=NodePort --name=elastic-svc
