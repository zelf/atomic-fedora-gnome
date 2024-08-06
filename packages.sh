#!/bin/sh

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

# Helper function to parse included/excluded packages
parse_packages() {
    local key="$1"
    jq -r "[
        (.all.${key} | (.all, select(.\"${IMAGE_NAME}\" != null).\"${IMAGE_NAME}\")[]), 
        (select(.\"${FEDORA_MAJOR_VERSION}\" != null).\"${FEDORA_MAJOR_VERSION}\".${key} | (.all, select(.\"${IMAGE_NAME}\" != null).\"${IMAGE_NAME}\")[])] 
        | sort | unique[]" /ctx/packages.json
}

# Build list of all packages requested for inclusion
INCLUDED_PACKAGES=($(parse_packages "include"))

# Build list of all packages requested for exclusion
EXCLUDED_PACKAGES=($(parse_packages "exclude"))

# Ensure exclusion list only contains packages already present on image
if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    EXCLUDED_PACKAGES=($(rpm -qa --queryformat='%{NAME} ' ${EXCLUDED_PACKAGES[@]}))
fi

# Simple case to install where no packages need excluding
if [[ "${#INCLUDED_PACKAGES[@]}" -gt 0 && "${#EXCLUDED_PACKAGES[@]}" -eq 0 ]]; then
    rpm-ostree install \
        ${INCLUDED_PACKAGES[@]}

# Install/excluded packages both at same time
elif [[ "${#INCLUDED_PACKAGES[@]}" -gt 0 && "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    rpm-ostree override remove \
        ${EXCLUDED_PACKAGES[@]} \
        $(printf -- "--install=%s " ${INCLUDED_PACKAGES[@]})

else
    echo "No packages to install."
fi

# Check if any excluded packages are still present
# (this can happen if an included package pulls in a dependency)
EXCLUDED_PACKAGES=($(parse_packages "exclude"))

if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    EXCLUDED_PACKAGES=($(rpm -qa --queryformat='%{NAME} ' ${EXCLUDED_PACKAGES[@]}))
fi

# Remove any excluded packages which are still present on image
if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    rpm-ostree override remove \
        ${EXCLUDED_PACKAGES[@]}
fi
