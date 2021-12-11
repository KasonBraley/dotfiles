FROM archlinux:latest

RUN pacman -Syu --noconfirm sudo
RUN useradd -m -s /bin/bash dockeruser
RUN usermod --append --groups wheel dockeruser
RUN echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER dockeruser:wheel

COPY --chown=dockeruser:dockeruser ./pacman/corePackages.txt /home/dockeruser/corePackages.txt
RUN cat /home/dockeruser/corePackages.txt | xargs sudo pacman -Sy --noconfirm
RUN rm /home/dockeruser/corePackages.txt

COPY --chown=dockeruser:dockeruser . /home/dockeruser/dotfiles

RUN mkdir /home/dockeruser/.local/share/nvim/site/autoload/ -p
RUN stow -d /home/dockeruser/dotfiles -t /home/dockeruser --stow zsh bin nvim git

RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'sleep 2' -c 'PackerSync'

RUN sudo usermod --shell /usr/bin/zsh dockeruser

WORKDIR /home/dockeruser

CMD ["zsh"]
