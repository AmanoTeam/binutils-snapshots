#!/bin/bash

set -eu

declare -r workdir="${PWD}"

declare -r binutils_tarball='/tmp/binutils.tar.xz'
declare -r binutils_directory='/tmp/source'

declare -r gdb_tarball='/tmp/gdb.tar.xz'
declare -r gdb_directory='/tmp/gdb'

sudo apt-get install --assume-yes 'gettext' 'libmpfr-dev'

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

# rm --force --recursive "${binutils_directory}"

mv '/tmp/binutils-'* '/tmp/binutils'

tar \
	--directory='/tmp' \
	--create \
	--file=- \
	'binutils' | \
		xz \
			--threads='0' \
			--compress \
			-9 > "${binutils_tarball}"

./src-release.sh 'gdb' || true

tar \
	--directory='/tmp' \
	--extract \
	--file="$(echo "${PWD}/gdb-"*'.tar')"

mv '/tmp/gdb-'* "${gdb_directory}"

tar \
	--directory='/tmp' \
	--create \
	--file=- \
	'gdb' | \
		xz \
			--threads='0' \
			--compress \
			-9 > "${gdb_tarball}"

