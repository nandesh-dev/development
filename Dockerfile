FROM ubuntu:latest

ARG USERNAME=nandesh

RUN apt-get update \
  && apt-get install -y \
  openssh-server \
  curl sudo \
  git gh \
  neofetch \
  neovim gcc ripgrep xclip

RUN apt-get remove -y w3m

RUN mkdir -p /var/run/sshd

RUN adduser $USERNAME \
  && usermod -aG sudo $USERNAME

RUN echo "$USERNAME:insecure" | chpasswd

WORKDIR /home/$USERNAME/.config/
RUN git clone https://github.com/nandesh-dev/nvim.git

WORKDIR /workspace
RUN echo 'cd /workspace' >> /home/$USERNAME/.bashrc

RUN chown $USERNAME:$USERNAME -R /home/$USERNAME \
  && chown $USERNAME:$USERNAME /workspace

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
