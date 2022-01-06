# Dotfiles

This repository contains my personal dotfiles, a collection of useful scripts and other utils. It heavily relies on [ansible](https://www.ansible.com/).

## How to install

Copy the `inventory.ini.example` to `inventory.ini` and change the `YOUR_USER` to the current user that you want

```bash
sudo pacman -Syyu ansible
ansible-galaxy collection install -r requirements.yml
ansible-playbook ./playbook.yaml --ask-become-pass --ask-vault-pass
```
