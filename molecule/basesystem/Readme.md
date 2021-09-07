# fabric-operator molecule test
Hyperledger Fabric K8S operator molecule test

# Prerequisite
To use molecule to test the fabric operator, the following software
must be installed:

1. Ansible==2.9.x
2. kind
3. molecule
4. kubectl

# Run the molecule test

```
export MOLECULE_PROJECT_DIRECTORY=$(pwd)
export MOLECULE_PROJECT_DIRECTORY=${MOLECULE_PROJECT_DIRECTORY}
export KUSTOMIZE_PATH=${MOLECULE_PROJECT_DIRECTORY}/bin/kustomize
export MOLECULE_EPHEMERAL_DIRECTORY=${MOLECULE_PROJECT_DIRECTORY}/build
export K8S_AUTH_KUBECONFIG=${MOLECULE_PROJECT_DIRECTORY}/build/kubeconfig
export KUBECONFIG=${MOLECULE_PROJECT_DIRECTORY}/build/kubeconfig
export OPERATOR_IMAGE=email4tong/fabricop:v1.0.0

mol converge -s basesystem

```
