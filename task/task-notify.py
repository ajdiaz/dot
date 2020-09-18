#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8

import os
import sys
import json
import datetime


DEFAULT_TITLE = "  {description}"
DEFAULT_MESSAGE = "<i>{_duedate}</i>"
AUTOPURGE_SECONDS = -1

COMMAND = "notify-send -t 0 '{title}' "\
          "'{message}' && task modify {id} notified:1"

COMMAND_CLEAN = "task done {id}"


def main(title=DEFAULT_TITLE, message=DEFAULT_MESSAGE):
    data = json.load(sys.stdin)
    for item in data:
        if item['status'] != 'pending':
            continue
        if not item.get('due', None):
            continue

        _duedate = datetime.datetime.strptime(
            item['due'],
            "%Y%m%dT%H%M%S%z"
        )

        now = datetime.datetime.now()

        if item['notified'] != 0:
            if AUTOPURGE_SECONDS != -1:
                if (now - _duedate).total_seconds() > AUTOPURGE_SECONDS:
                    os.system(COMMAND_CLEAN.format(id=item['id']))
            continue

        item["_duedate"] = datetime.datetime.strptime(
            item['due'],
            "%Y%m%dT%H%M%S%z"
        ).strftime("%Y-%m-%d %H:%M")

        os.system(COMMAND.format(
            id=item['id'],
            title=title.format(**item),
            message=message.format(**item)))


if __name__ == "__main__":
    main()
