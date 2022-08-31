# fabric-operator
Hyperledger Fabric K8S operator

The Fabric Operator to be used to deploy/manage Fabric network in Kubernetes environment

# Prerequsite
This Fabric operator rely on ingress nginx or istio gateway to expose various Fabric
node endpoints to outside of your Kubernetes cluster, so you will have to deploy either
ingress nginx controller or istio in your cluster. Please refer to the following two
places for installing them into your kuberentes.

[Ingress Nginx Controller](https://kubernetes.github.io/ingress-nginx/deploy/)
Your vendor specific k8s may require a different way to install nginx ingress
controller, please refer to their document for installation. Here is an example:
```
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.0/deploy/static/provider/cloud/deploy.yam
```

[Istio](https://istio.io/latest/docs/setup/)
Example command to install istio
```
    istioctl install -y
```

### For specific kubernetes such as AKS, IKS, OpenShift etc, please follow istio deployment [document](https://istio.io/latest/docs/setup/platform-setup)

# To deploy the Fabric Operator to your Kubernetes cluster

Run the following command:

```
    kubectl apply -f https://raw.githubusercontent.com/litong01/fabric-operator/main/deploy/fabric_operator.yaml
```

# Deploy a Fabric node

After you have Fabric operator running in your cluster, run one of the following
commands to stand up a node, a Fabric operation console.

Notice that the Custom Resource file used are examples provided by this project,
your CR file most likely need to be changed to your need, use these example CR
files as a blueprint to create your own.

For a CA:
```
    kubectl apply -f https://raw.githubusercontent.com/litong01/fabric-operator/main/config/samples/operator_v1alpha1_ca.yaml
```

For a Orderer:
```
    kubectl apply -f https://raw.githubusercontent.com/litong01/fabric-operator/main/config/samples/operator_v1alpha1_orderer.yaml
```

For a Peer:
```
    kubectl apply -f https://raw.githubusercontent.com/litong01/fabric-operator/main/config/samples/operator_v1alpha1_peer.yaml
```

For a Console:
```
    kubectl apply -f https://raw.githubusercontent.com/litong01/fabric-operator/main/config/samples/operator_v1alpha1_console.yaml
```
