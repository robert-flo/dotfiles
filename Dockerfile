FROM archlinux:latest

RUN pacman -Syu --noconfirm --needed \
    git \
    github-cli \
    gnupg \
    openssh \
    git-delta

WORKDIR /opt/robertflo-dotfiles
COPY . /opt/robertflo-dotfiles
RUN chmod +x robertflo-dotfiles scripts/*

ENTRYPOINT ["/opt/robertflo-dotfiles/robertflo-dotfiles"]
