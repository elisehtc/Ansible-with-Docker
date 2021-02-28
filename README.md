# Ansible-with-Docker

A partir du Dockerfile d'origine, j'ai fait
docker build -t ansible  .

puis 
docker run -it -d --name ansible-docker-container ansible

ensuite 
docker exec -it ansible-docker-container bash

et là j'ai pu vérifier Ansible et Python.

root@7ed767729ae5:/# ansible --version
ansible 2.9.18
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.17 (default, Feb 25 2021, 14:02:55) [GCC 7.5.0]

ssh n'étant pas intallé, j'ai fait
root@7ed767729ae5:/# apt-get update && apt-get install -y openssh-server

mais il aurait été préférable de tout mettre dans le Dockerfile comme ceci:

FROM ubuntu:18.04
RUN apt-get update && \
 apt-get install --no-install-recommends -y software-properties-common && \
 apt-add-repository ppa:ansible/ansible && \
 apt-get update && \
 apt-get install -y ansible 
RUN echo '[local]\nlocalhost\n' > /etc/ansible/hosts
RUN apt-get update && apt-get install -y openssh-server sudo
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

donc j'ai refait un Dockerfile et testé et ça fonctionnait.
