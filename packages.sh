#!/bin/sh

set -ouex pipefail

rpm-ostree install \
  alsa-firmware \
  distrobox \
  ffmpeg \
  ffmpeg-libs \
  ffmpegthumbnailer \
  flatpak-spawn \
  fzf \
  grub2-tools-extra \
  heif-pixbuf-loader \
  htop \
  intel-media-driver \
  just \
  kernel-tools \
  libcamera \
  libcamera-tools \
  libcamera-gstreamer \
  libcamera-ipa \
  libheif-freeworld \
  libheif-tools \
  libratbag-ratbagd \
  libva-intel-driver \
  libva-utils \
  lshw \
  mesa-va-drivers-freeworld.x86_64 \
  net-tools \
  nvme-cli \
  nvtop \
  openssl \
  pam-u2f \
  pam_yubico \
  pamu2fcfg \
  pipewire-codec-aptx \
  pipewire-plugin-libcamera \
  powerstat \
  smartmontools \
  squashfs-tools \
  symlinks \
  tcpdump \
  tmux \
  traceroute \
  neovim \
  wireguard-tools \
  zst \
  gnome-epub-thumbnailer \
  gnome-tweaks \
  gvfs-nf

rpm-ostree override remove \
  ffmpeg-free \
  libavcodec-free \
  libavdevice-free \
  libavfilter-free \
  libavformat-free \
  libavutil-free \
  libpostproc-free \
  libswresample-free \
  libswscale-free \
  mesa-va-drivers \
  default-fonts-cjk-san
