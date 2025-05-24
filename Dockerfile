FROM ubuntu:latest

ARG USERNAME=nandesh

RUN apt-get update \
  && apt-get install software-properties-common -y \
  && add-apt-repository ppa:neovim-ppa/stable \
  && apt-get update \
  && apt-get install -y \
  openssh-server \
  curl sudo \
  git gh \
  neovim gcc ripgrep xclip \
  && apt-get remove -y w3m

RUN adduser $USERNAME \
  && usermod -aG sudo $USERNAME \
  && echo "$USERNAME:insecure" | chpasswd

RUN mkdir /home/$USERNAME/.config \
  && git clone https://github.com/nandesh-dev/nvim.git /home/$USERNAME/.config/ \
  && echo 'export EDITOR="nvim"' >> /home/$USERNAME/.bashrc \
  && echo 'export VISUAL="nvim"' >> /home/$USERNAME/.bashrc \
  && update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 100 \
  && sudo update-alternatives --config editor

RUN mkdir "/workspace" \
  && chown $USERNAME:$USERNAME -R /home/$USERNAME \
  && chown $USERNAME:$USERNAME /workspace \
  && echo 'cd /workspace' >> /home/$USERNAME/.bashrc

WORKDIR /workspace

RUN mkdir -p /var/run/sshd
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
