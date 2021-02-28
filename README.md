# Ansible-with-Docker

A partir du Dockerfile d'origine, j'ai fait<br>
docker build -t ansible  .

puis <br>
docker run -it -d --name ansible-docker-container ansible

ensuite <br>
docker exec -it ansible-docker-container bash

et là j'ai pu vérifier Ansible et Python.<br>

root@7ed767729ae5:/# ansible --version<br>
ansible 2.9.18<br>
  config file = /etc/ansible/ansible.cfg<br>
  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']<br>
  ansible python module location = /usr/lib/python2.7/dist-packages/ansible<br>
  executable location = /usr/bin/ansible<br>
  python version = 2.7.17 (default, Feb 25 2021, 14:02:55) [GCC 7.5.0]<br>

ssh n'étant pas intallé, j'ai fait
root@7ed767729ae5:/# apt-get update && apt-get install -y openssh-server

mais il aurait été préférable de tout mettre dans le Dockerfile comme ceci:

FROM ubuntu:18.04<br>
RUN apt-get update && \<br>
 apt-get install --no-install-recommends -y software-properties-common && \<br>
 apt-add-repository ppa:ansible/ansible && \<br>
 apt-get update && \<br>
 apt-get install -y ansible <br>
RUN echo '[local]\nlocalhost\n' > /etc/ansible/hosts<br>
RUN apt-get update && apt-get install -y openssh-server sudo<br>
RUN mkdir /var/run/sshd<br>
RUN echo 'root:password' | chpasswd<br>
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config<br>
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd<br>
ENV NOTVISIBLE "in users profile"<br>
RUN echo "export VISIBLE=now" >> /etc/profile<br>
EXPOSE 22<br>
CMD ["/usr/sbin/sshd", "-D"]<br>

donc j'ai refait un Dockerfile et testé et ça fonctionnait.
