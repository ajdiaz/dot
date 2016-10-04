#!/usr/bin/env python

import os
import logging
import subprocess

from alot.settings import settings
import alot.crypto as crypto
from alot import errors


devnull = open(os.devnull, 'w')


def pre_global_exit(**kwargs):
    accounts = settings.get_accounts()
    logging.info('Syncing mail with offlineimap')

    subprocess.call(["offlineimap"], stdout=devnull, stderr=devnull)

    if accounts:
        logging.info('goodbye, %s!' % accounts[0].realname)
    else:
        logging.info('goodbye!')


def pre_buffer_focus(ui, dbm, buf):
    if buf.modename == 'search':
        buf.rebuild()


def text_quote(message):
    # avoid importing a big module by using a simple heuristic to guess the
    # right encoding
    def decode(s, encodings=('ascii', 'utf8', 'latin1')):
        for encoding in encodings:
            try:
                return s.decode(encoding)
            except UnicodeDecodeError:
                pass
        return s.decode('ascii', 'ignore')
    lines = message.splitlines()
    # delete empty lines at beginning and end (some email client insert these
    # outside of the pgp signed message...)
    if lines[0] == '' or lines[-1] == '':
        from itertools import dropwhile
        lines = list(dropwhile(lambda l: l == '', lines))
        lines = list(reversed(list(dropwhile(
            lambda l: l == '', reversed(lines)))))
    if len(lines) > 0 and lines[0] == '-----BEGIN PGP MESSAGE-----' \
            and lines[-1] == '-----END PGP MESSAGE-----':
        try:
            sigs, d = crypto.decrypt_verify(message.encode('utf-8'))
            message = decode(d)
        except errors.GPGProblem:
            pass
    elif len(lines) > 0 and lines[0] == '-----BEGIN PGP SIGNED MESSAGE-----' \
            and lines[-1] == '-----END PGP SIGNATURE-----':
        # gpgme does not seem to be able to extract the plain text part of
        # a signed message
        import gnupg
        gpg = gnupg.GPG()
        d = gpg.decrypt(message.encode('utf8'))
        message = d.data.decode('utf8')
    quote_prefix = settings.get('quote_prefix')
    return "\n".join([quote_prefix + line for line in message.splitlines()])


# def pre_global_refresh(**kwargs):
#     logging.info('Syncing mail with offlineimap')
#
#     subprocess.call(["offlineimap"], stdout=devnull, stderr=devnull)
