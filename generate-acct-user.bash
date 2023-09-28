#!/usr/bin/env bash

# This tool generates boilerplate acct-user/ entries for nix-daemon.

# Remove existing users
rm -rf -- acct-user/nixbld*

for i in {1..64}; do
    # nix users:
    d=acct-user/nixbld${i}
    mkdir "${d}"

    cat > ${d}/nixbld${i}-1.ebuild <<EOF
# Copyright $(date +%Y) Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# #===------------------------------------------------===#
# |This file is auto-generated by generate-acct-user.bash|
# #===------------------------------------------------===#
EAPI=8

inherit acct-user

DESCRIPTION="Builder user for nix-daemon from sys-apps/nix"

ACCT_USER_ID=$((30000 + $i))
# We list 'nixbld' twice to both assign:
# - primary group for user
# - add user to /etc/group
ACCT_USER_GROUPS=( nixbld nixbld )

acct-user_add_deps
EOF

    cat > ${d}/metadata.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE pkgmetadata SYSTEM "http://www.gentoo.org/dtd/metadata.dtd">
<pkgmetadata>
	<maintainer type="person">
		<email>slyich@gmail.com</email>
		<name>Sergei Trofimovich</name>
	</maintainer>
</pkgmetadata>
EOF
done
