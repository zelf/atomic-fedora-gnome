#!/usr/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

RPMFUSION_MIRROR_RPMS="https://mirrors.rpmfusion.org"

mkdir -p /tmp/rpm-repos
curl -Lo /tmp/rpm-repos/rpmfusion-free-release-"${RELEASE}".noarch.rpm "${RPMFUSION_MIRROR_RPMS}"/free/fedora/rpmfusion-free-release-"${RELEASE}".noarch.rpm
curl -Lo /tmp/rpm-repos/rpmfusion-nonfree-release-"${RELEASE}".noarch.rpm "${RPMFUSION_MIRROR_RPMS}"/nonfree/fedora/rpmfusion-nonfree-release-"${RELEASE}".noarch.rpm

curl -Lo /tmp/rpms/wezterm-nightly-fedora40.rpm https://github.com/wez/wezterm/releases/download/nightly/wezterm-nightly-fedora40.rpm

rpm-ostree install \
  /tmp/rpms/*.rpm \
  /tmp/rpm-repos/*.rpm \
  fedora-repos-archive

/ctx/packages.sh
