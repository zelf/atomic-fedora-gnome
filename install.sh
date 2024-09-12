#!/usr/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

RPMFUSION_MIRROR_RPMS="https://mirrors.rpmfusion.org"

mkdir -p /tmp/rpm-repos
curl -Lo /tmp/rpm-repos/rpmfusion-free-release-"${RELEASE}".noarch.rpm "${RPMFUSION_MIRROR_RPMS}"/free/fedora/rpmfusion-free-release-"${RELEASE}".noarch.rpm
curl -Lo /tmp/rpm-repos/rpmfusion-nonfree-release-"${RELEASE}".noarch.rpm "${RPMFUSION_MIRROR_RPMS}"/nonfree/fedora/rpmfusion-nonfree-release-"${RELEASE}".noarch.rpm

mkdir -p /tmp/rpms
curl -Lo /tmp/rpms/wezterm-nightly-fedora40.rpm https://github.com/wez/wezterm/releases/download/nightly/wezterm-nightly-fedora40.rpm

curl -Lo /etc/yum.repos.d/_copr_ryanabx-cosmic.repo \
  https://copr.fedorainfracloud.org/coprs/ryanabx/cosmic-epoch/repo/fedora-"${RELEASE}"/ryanabx-cosmic-epoch-fedora-"${RELEASE}".repo

cp /ctx/files/usr/etc/yum.repos.d/docker-ce.repo /etc/yum.repos.d/docker-ce.repo

rpm-ostree install \
  /tmp/rpms/*.rpm \
  /tmp/rpm-repos/*.rpm \
  fedora-repos-archive

wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

/ctx/packages.sh
