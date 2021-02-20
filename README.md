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

Change netplan settings to make optional the connection on ethernet port:
```yaml
# file located on /etc/netplan/00-installer-config.yaml or similar
network:
	ethernets:
		enp3s0:
			optional: true # this is the change
			dhcp4: true
	version: 2
```

Reboot again and install only what is strictly needed, to start Basic Vanilla Gnome:

```bash
sudo apt install gnome-session gdm3
```

Then execute this dotfiles:

```bash
bash -c "$(wget -qO - https://raw.github.com/llstarscreamll/dotfiles/main/src/os/setup.sh)"
```

Fix `Initramfs unpacking failed: Decoding failed` error by changing `COMPRESS=lz4` to `COMPRESS=gzip` in `/etc/initramfs-tools/initramfs.conf`.

Fix audio interfaces issues like `sof-audio-pci 0000:00:1f.3: error: no reply expected, received 0x0` or microphone that does not work by upgrading to the last kernel. With the 5.11.0 Kernel versión this issues are gone. Install some utility that helps you getting the latest Kernel available, i.g. ubuntu-main-line-kernel:

```bash
wget https://raw.githubusercontent.com/pimlie/ubuntu-mainline-kernel.sh/master/ubuntu-mainline-kernel.sh

sudo install ubuntu-mainline-kernel.sh /usr/local/bin/
```

Then upgrade to the latest kernel and restart:

```bash
sudo ubuntu-mainline-kernel.sh -i # optionaly specify a kernel versión: sudo ubuntu-mainline-kernel.sh -i 5.11.0
sudo reboot -h now
```