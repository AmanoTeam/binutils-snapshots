#!/bin/bash

set -eu

declare -r workdir="${PWD}"

declare -r binutils_tarball='/tmp/binutils.tar.xz'
declare -r binutils_directory='/tmp/binutils'

sudo apt-get install --assume-yes 'gettext'

function checkout_source() {
	
	git \
		clone \
		--depth '12' \
		"${1}" \
		"${binutils_directory}"

}

checkout_source 'https://sourceware.org/git/binutils-gdb.git' ||
checkout_source 'https://gnu.googlesource.com/binutils-gdb' ||
checkout_source 'https://github.com/bminor/binutils-gdb.git'

cd "${binutils_directory}"

git config --global user.email "105828205+Kartatz@users.noreply.github.com"
git config --global user.name "Kartatz"

./src-release.sh 'binutils' || true

tar \
	--directory='/tmp' \
	--extract \
	--file="$(echo "${PWD}/binutils-"*'.tar')"

rm --force --recursive "${binutils_directory}"

mv '/tmp/binutils-'* "${binutils_directory}"

tar \
	--directory="$(dirname "${binutils_directory}")" \
	--create \
	--file=- \
	'binutils' | \
		xz \
			--threads='0' \
			--compress \
			-9 > "${binutils_tarball}"
