#!/usr/bin/env python

import gnomekeyring as gkey


def set_credentials(repo, user, pw):
    KEYRING_NAME = "mails"
    attrs = {"repo": repo, "user": user}
    keyring = gkey.get_default_keyring_sync()
    gkey.item_create_sync(
        keyring, gkey.ITEM_NETWORK_PASSWORD,
        KEYRING_NAME, attrs, pw, True)


def get_credentials(repo):
    attrs = {"repo": repo}
    items = gkey.find_items_sync(gkey.ITEM_NETWORK_PASSWORD, attrs)
    return (items[0].attributes["user"], items[0].secret)


def get_username(repo):
    return get_credentials(repo)[0]


def get_password(repo):
    return get_credentials(repo)[1]


if __name__ == "__main__":
    import sys
    import os
    import getpass

    if len(sys.argv) < 2:
        print("Usage: %s (get|set)" % (os.path.basename(sys.argv[0])))
        sys.exit(0)

    method = sys.argv[1]

    if method == "set":
        if len(sys.argv) != 4:
            print("Usage: %s set <repository> <username>" %
                  (os.path.basename(sys.argv[0])))
            sys.exit(0)

        repo, username = sys.argv[2:]
        password = getpass.getpass("Enter password for user '%s': " % username)
        password_confirmation = getpass.getpass("Confirm password: ")
        if password != password_confirmation:
            print("Error: password confirmation does not match")
            sys.exit(1)
        set_credentials(repo, username, password)

    elif method == "get":
        if len(sys.argv) != 4:
            print("Usage: %s get <repository> (username|password)" %
                  (os.path.basename(sys.argv[0])))
            sys.exit(0)

        repo, toget = sys.argv[2:]
        if toget == "username":
            print(get_username(repo))
        elif toget == "password":
            print(get_password(repo))
