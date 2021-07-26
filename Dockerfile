FROM quay.io/operator-framework/ansible-operator:v1.10.0

COPY requirements.yml ${HOME}/requirements.yml
RUN ansible-galaxy collection install -r ${HOME}/requirements.yml \
  && chmod -R ug+rwx ${HOME}/.ansible \
  && mkdir -p ${HOME}/.ansible/plugins

# Get the custom callback in
# COPY plugins ${HOME}/.ansible/plugins

COPY watches.yaml ${HOME}/watches.yaml
COPY roles/ ${HOME}/roles/
COPY playbooks/ ${HOME}/playbooks/
ENV ANSIBLE_CONFIG=${HOME}/ansible.cfg
COPY ansible.cfg ${HOME}/ansible.cfg
COPY test.yaml ${HOME}/test.yaml