#! /bin/sh
#
# generate-sec.conf.sh
# Copyright (C) 2020 acat <ajdiaz@ajdiaz.me>
#
# Distributed under terms of the MIT license.
#


cat > ~/.weechat/sec.conf << EOF
#
# weechat -- sec.conf
#
# WARNING: It is NOT recommended to edit this file by hand,
# especially if WeeChat is running.
#
# Use /set or similar command to change settings in WeeChat.
#
# For more info, see: https://weechat.org/doc/quickstart
#

[crypt]
cipher = aes256
hash_algo = sha256
passphrase_file = ""
salt = on

[data]
__passphrase__ = off
matrix.matrix_org.password = "$(pass tech/ajdiaz.me/app.element.io | head -n 1)"
slack.token = "$(pass tech/ajdiaz.me/bcneng.slack.com | grep token: | cut -d ' ' -f2)"
EOF
