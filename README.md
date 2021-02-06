# Johan DotFiles

DotFiles for Mac and Ubuntu inspired on [alrra/dotfiles](https://github.com/alrra/dotfiles)

## Fixes for Asus TUF Gaming laptop

Install ubuntu server from booteable USB drive with no swap partition, reboot and fix errors given by Western Digilal Black Label SSD:

```bash
# edit the grub config file 
sudo vim /etc/default/grub
# set GRUB_CMDLINE_LINUX_DEFAULT entry to:
GRUB_CMDLINE_LINUX_DEFAULT="pci=nommconf"
# and reinstall grub
sudo update-grub
```

Reboot again and install only what is strictly needed, in this case Basic Vanilla Gnome:

```bash
sudo apt install gnome-session gdm3
```

The execute this dotfiles:

```bash
bash -c "$(wget -qO - https://raw.github.com/llstarscreamll/dotfiles/main/src/os/setup.sh)"
```
