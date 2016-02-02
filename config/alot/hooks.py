#!/usr/bin/env python

import os
import logging
import subprocess

from alot.settings import settings

devnull = open(os.devnull, 'w')


def pre_global_exit(**kwargs):
    accounts = settings.get_accounts()
    logging.info('Syncing mail with offlineimap')

    subprocess.call(["offlineimap"], stdout=devnull, stderr=devnull)

    if accounts:
        logging.info('goodbye, %s!' % accounts[0].realname)
    else:
        logging.info('goodbye!')


def pre_global_refresh(**kwargs):
    logging.info('Syncing mail with offlineimap')

    subprocess.call(["offlineimap"], stdout=devnull, stderr=devnull)
