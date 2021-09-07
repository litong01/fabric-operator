# fabric-operator molecule test
Hyperledger Fabric K8S operator molecule test

# Prerequisite
To use molecule to test the fabric operator, the following software
must be installed:

1. Ansible==2.9.x
2. kubernetes==11.0.0
3. openshift==0.11.2
4. kind
5. molecule

# Run the molecule test

# Run the molecule test

```
export MOLECULE_PROJECT_DIRECTORY=$(pwd)
export KUSTOMIZE_PATH=${MOLECULE_PROJECT_DIRECTORY}/bin/kustomize
export MOLECULE_EPHEMERAL_DIRECTORY=${MOLECULE_PROJECT_DIRECTORY}/build
export K8S_AUTH_KUBECONFIG=${HOME}/.kube/config
export KUBECONFIG=${HOME}/.kube/config
export OPERATOR_IMAGE=email4tong/fabricop:v1.0.0

mol converge -s aws

```
