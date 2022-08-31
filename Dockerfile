
FROM quay.io/operator-framework/ansible-operator:v1.11.0 as BASE

FROM registry.access.redhat.com/ubi8/ubi:8.4

COPY Pipfile* ./

ENV PIP_NO_CACHE_DIR=1 \
    PIPENV_SYSTEM=1 \
    PIPENV_CLEAR=1

RUN mkdir -p /etc/ansible \
  && echo "localhost ansible_connection=local" > /etc/ansible/hosts \
  && echo '[defaults]' > /etc/ansible/ansible.cfg \
  && echo 'roles_path = /opt/ansible/roles' >> /etc/ansible/ansible.cfg \
  && echo 'library = /usr/share/ansible/openshift' >> /etc/ansible/ansible.cfg

RUN yum clean all && rm -rf /var/cache/yum/* \
  && yum update -y \
  && yum install -y unzip tar python38-pip python38-setuptools jq \
  && pip3 install --upgrade pip~=21.1.0 \
  && pip3 install pipenv==2020.11.15 \
  && pipenv install --deploy \
  && yum clean all \
  && rm -rf /var/cache/yum

COPY --from=BASE /usr/local/bin/ansible-runner /usr/local/bin/ansible-runner
COPY --from=BASE /usr/local/bin/ansible-operator /usr/local/bin/ansible-operator

ENV HOME=/opt/ansible \
    USER_NAME=ansible \
    USER_UID=1001

RUN echo "${USER_NAME}:x:${USER_UID}:0:${USER_NAME} user:${HOME}:/sbin/nologin" >> /etc/passwd \
  && mkdir -p ${HOME}/.ansible/tmp \
  && chown -R ${USER_UID}:0 ${HOME} \
  && chmod -R ug+rwx ${HOME}

COPY requirements.yml ${HOME}/requirements.yml
RUN ansible-galaxy collection install -r ${HOME}/requirements.yml

ENV TINI_VERSION=v0.19.0
RUN curl -L -o /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-amd64 \
  && chmod +x /tini && /tini --version

# Get the custom callback in
# COPY plugins ${HOME}/.ansible/plugins

COPY watches.yaml ${HOME}/watches.yaml
COPY roles/ ${HOME}/roles/
COPY playbooks/ ${HOME}/playbooks/
COPY utilities/launcher/ ${HOME}/launcher/
COPY ansible.cfg ${HOME}/launcher/bin/
COPY utilities/downloader/ ${HOME}/downloader/

COPY test.yaml ${HOME}/test.yaml
WORKDIR ${HOME}
USER ${USER_UID}
RUN mkdir -p ${HOME}/agent/upload ${HOME}/agent/download

ENTRYPOINT ["/tini", "--", "/usr/local/bin/ansible-operator", "run", "--watches-file=./watches.yaml"]