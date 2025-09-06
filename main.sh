#!/bin/bash

declare -r binutils_tarball='/tmp/binutils.tar.xz'
declare -r binutils_directory='/tmp/binutils'

sudo apt-get install --assume-yes 'gettext'

git \
	clone \
	--depth '1' \
	'https://sourceware.org/git/binutils-gdb.git' \
	"${binutils_directory}"

cd "${binutils_directory}"

./src-release.sh 'binutils'

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
