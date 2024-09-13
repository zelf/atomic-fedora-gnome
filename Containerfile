ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
ARG SOURCE_ORG="${SOURCE_ORG:-fedora-ostree-desktops}"
ARG BASE_IMAGE="quay.io/${SOURCE_ORG}/${SOURCE_IMAGE}"

FROM scratch AS ctx
COPY / /

FROM quay.io/fedora-ostree-desktops/silverblue:40

COPY files/usr /usr

RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
  --mount=type=bind,from=ctx,src=/,dst=/ctx \
  mkdir -p /var/lib/alternatives && \
  /ctx/install.sh && \
  mv /var/lib/alternatives /staged-alternatives && \
  /ctx/cleanup.sh && \
  ostree container commit && \
  mkdir -p /var/lib && mv /staged-alternatives /var/lib/alternatives && \
  mkdir -p /var/tmp && \
  chmod -R 1777 /var/tmp
