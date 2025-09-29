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

git checkout 991b1443d376b9acbcd0c9e164b20e527f0e06cb

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
