#!/usr/bin/env bash

declare -A listaExtensoes
declare pathToCloneExtensions="/tmp"

function addExtensionURLToArray() {
    local extensionFullURL="${1}"
    local extensionNameWithGit="${extensionFullURL#*.*/*/*}"
    local extensionNameNoGit="${extensionNameWithGit%.*}"
    listaExtensoes=( ["${extensionNameNoGit}"]="${extensionFullURL}" )
}

function getMajorMinorGnomeVersion() {
    local majorMinor
    majorMinor="$(awk '{ print $3 }' <(gnome-shell --version))"
    echo "${majorMinor%.*}"
}

function cloneRepositoryExtension() {
    local extensionURLToClone="${1}"
    local directoryToClone="${2}"
    git clone "${extensionURLToClone}" "${directoryToClone}"
}

function installBackSlide() {
    if [ ! -z "${listaExtensoes[backslide]}" ]; then
        cloneRepositoryExtension "${listaExtensoes[backslide]}" "${pathToCloneExtensions}"/backslide
        if pushd "${pathToCloneExtensions}"/backslide; then
            glib-compile-schemas backslide\@codeisland.org/schemas/
            cp -r backslide\@codeisland.org/ "${HOME}"/.local/share/gnome-shell/extensions/
        fi
        popd || exit
        rm -rf "${pathToCloneExtensions}"/backslide
    fi
}

function installCaffeine() {
    if [ ! -z "${listaExtensoes[caffeine]}" ]; then
        cloneRepositoryExtension "${listaExtensoes[caffeine]}" "${pathToCloneExtensions}"/caffeine
        if pushd "${pathToCloneExtensions}"/caffeine; then
            ./update-locale.sh
            glib-compile-schemas --strict --targetdir=caffeine\@patapon.info/schemas/ caffeine\@patapon.info/schemas
            cp -r caffeine\@patapon.info/schema/ "${HOME}"/.local/share/gnome-shell/extensions/
        fi
        popd || exit 
        rm -rf "${pathToCloneExtensions}"/caffeine
    fi
}

function installFreon() {
    if [ ! -z "${listaExtensoes[freon]}" ]; then
        cloneRepositoryExtension "${listaExtensoes[freon]}" "${pathToCloneExtensions}"/freon
        if pushd "${pathToCloneExtensions}"/freon; then
            cp -r freon\@UshakovVasilii_Github.yahoo.com "${HOME}"/.local/share/gnome-shell/extensions/
        fi
        popd || exit 
        rm -rf "${pathToCloneExtensions}"/freon
    fi
}


