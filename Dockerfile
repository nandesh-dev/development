FROM ubuntu:latest

ARG USERNAME=nandesh
ARG SSH_PUBLIC_KEY
ARG GIT_NAME=nandesh-dev
ARG GIT_EMAIL=nandesh.dev@gmail.com

RUN apt-get update \
  && apt-get install software-properties-common -y \
  && add-apt-repository ppa:neovim-ppa/unstable \
  && apt-get update \
  && apt-get install -y \
  openssh-server \
  curl sudo \
  git gh \
  neovim gcc ripgrep xclip \
  && apt-get remove -y w3m

RUN adduser $USERNAME \
  && usermod -aG sudo $USERNAME

RUN mkdir /home/$USERNAME/.config \
  && git clone https://github.com/nandesh-dev/nvim.git /home/$USERNAME/.config/nvim \
  && echo 'export EDITOR="nvim"' >> /home/$USERNAME/.bashrc \
  && echo 'export VISUAL="nvim"' >> /home/$USERNAME/.bashrc \
  && update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 100 \
  && su - $USERNAME -c 'nvim --headless -c "lua require(\"lazy\").install()" -c "qa"'

RUN su - $USERNAME -c "git config --global user.name \"$GIT_NAME\"" \
  && su - $USERNAME -c "git config --global user.email \"$GIT_EMAIL\""

RUN mkdir "/workspace" \
  && chown $USERNAME:$USERNAME -R /home/$USERNAME \
  && chown $USERNAME:$USERNAME /workspace \
  && echo 'cd /workspace' >> /home/$USERNAME/.bashrc

WORKDIR /workspace

RUN mkdir -p /home/$USERNAME/.ssh \
  && echo "$SSH_PUBLIC_KEY" > /home/$USERNAME/.ssh/authorized_keys \
  && chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh \
  && chmod 700 /home/$USERNAME/.ssh \
  && chmod 600 /home/$USERNAME/.ssh/authorized_keys \
  && echo "PasswordAuthentication no" > /etc/ssh/sshd_config

RUN mkdir -p /var/run/sshd
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
