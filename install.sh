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
cp /ctx/files/usr/etc/yum.repos.d/tailscale.repo /etc/yum.repos.d/tailscale.repo

rpm-ostree install \
  /tmp/rpms/*.rpm \
  /tmp/rpm-repos/*.rpm \
  fedora-repos-archive

wget --no-hsts https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq
chmod +x /usr/bin/yq

/ctx/packages.sh

rm -f /usr/bin/yq

sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-cisco-openh264.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:phracek:PyCharm.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/docker-ce.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/tailscale.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ryanabx-cosmic.repo

for i in /etc/yum.repos.d/rpmfusion-*; do
  sed -i 's@enabled=1@enabled=0@g' "$i"
done


systemctl enable docker.socket
systemctl enable podman.socket
systemctl enable dconf-update.service
systemctl enable zelf-groups.service
