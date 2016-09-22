#!/usr/bin/env python

import subprocess

PASS = "pass"


def get_credentials(keyname):
    proc = subprocess.Popen([PASS, "show", keyname],
                            stdout=subprocess.PIPE)
    output = proc.stdout.readlines()
    if not output:
        raise ValueError("Credential not found")
    else:
        password = output[0].strip()
        username = output[1].split(":")[1].strip()

    return (username, password)


def get_username(keyname):
    return get_credentials(keyname)[0]


def get_password(keyname):
    return get_credentials(keyname)[1]
