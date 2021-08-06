#! /bin/bash
# This script sets up k8s cluster using metallb and istio
# Make sure you have the following executable in your path
#     kubectl
#     kind
#     istioctl

# Setup some colors
ColorOff='\033[0m'        # Text Reset
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green

rm -rf ~/.kube/*

kind create cluster

# The following procedure is to setup load balancer
kubectl cluster-info --context kind-kind

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/namespace.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/metallb.yaml

PREFIX=$(docker network inspect -f '{{range .IPAM.Config }}{{ .Gateway }}{{end}}' kind | cut -d '.' -f1,2)

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - $PREFIX.255.230-$PREFIX.255.240
EOF

# Now setup istio
istioctl install -y

echo ''
ENDPOINT=''
while : ; do
  ENDPOINT=$(kubectl get -n istio-system service/istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress}')
  if [[ ! -z $ENDPOINT ]]; then
    break
  fi
  echo -e ${Green}Waiting${ColorOff} for Istio Ingress Gateway to be ready...
  sleep 3
done

echo ''
echo -e Access service at ${Green}${ENDPOINT}$ColorOff!!!
