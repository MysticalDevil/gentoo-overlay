# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# #===------------------------------------------------===#
# |This file is auto-generated by generate-acct-user.bash|
# #===------------------------------------------------===#
EAPI=8

inherit acct-user

DESCRIPTION="Builder user for nix-daemon from sys-apps/nix"

ACCT_USER_ID=30042
# We list 'nixbld' twice to both assign:
# - primary group for user
# - add user to /etc/group
ACCT_USER_GROUPS=( nixbld nixbld )

acct-user_add_deps
