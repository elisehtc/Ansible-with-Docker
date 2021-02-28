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