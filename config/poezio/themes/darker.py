import theming


class DarkerTheme(theming.Theme):
    COLOR_INFORMATION_BAR = (244, 236)
    COLOR_STATUS_XA = (53, -1)
    COLOR_STATUS_AWAY = (214, -1)
    COLOR_STATUS_DND = (160, -1)
    COLOR_STATUS_CHAT = (34, -1)
    COLOR_STATUS_UNAVAILABLE = (242, -1)
    COLOR_STATUS_ONLINE = (34, -1)
    COLOR_STATUS_NONE = (236, -1)

    COLOR_VERTICAL_SEPARATOR = (236, -1)
    COLOR_NEW_TEXT_SEPARATOR = (213, -1)
    COLOR_MORE_INDICATOR = (6, 4)

    COLOR_TAB_NORMAL = (-1, 236)
    COLOR_TAB_NONEMPTY = (-1, 236)
    COLOR_TAB_CURRENT = (39, 236)
    COLOR_TAB_COMPOSING = (3, 236)
    COLOR_TAB_NEW_MESSAGE = (77, 236)
    COLOR_TAB_HIGHLIGHT = (1, 236)
    COLOR_TAB_ATTENTION = (6, 236)
    COLOR_TAB_PRIVATE = (2, 236)
    COLOR_TAB_DISCONNECTED = (196, 236)
    COLOR_TAB_SCROLLED = (66, 236)

    COLOR_TOPIC_BAR = (-1, 236)
    COLOR_SCROLLABLE_NUMBER = (220, 236, 'b')
    COLOR_SELECTED_ROW = (-1, 238)
    COLOR_PRIVATE_NAME = (173, 236)
    COLOR_CONVERSATION_NAME = (2, 236)
    COLOR_CONVERSATION_RESOURCE = (58, 236)
    COLOR_GROUPCHAT_NAME = (106, 236)
    COLOR_COLUMN_HEADER = (36, 236)

    COLOR_VERTICAL_TAB_NORMAL = (240, -1)
    COLOR_VERTICAL_TAB_CURRENT = (-1, 236)
    COLOR_VERTICAL_TAB_NEW_MESSAGE = (3, -1)
    COLOR_VERTICAL_TAB_COMPOSING = (3, -1)
    COLOR_VERTICAL_TAB_HIGHLIGHT = (1, -1)
    COLOR_VERTICAL_TAB_PRIVATE = (2, -1)
    COLOR_VERTICAL_TAB_ATTENTION = (6, -1)
    COLOR_VERTICAL_TAB_DISCONNECTED = (13, -1)

    COLOR_INFORMATION_TEXT = (240, -1)
    COLOR_LOG_MSG = (240, -1)

    # Time
    COLOR_TIME_SEPARATOR = (106, -1)
    COLOR_TIME_LIMITER = (240, -1)
    CHAR_TIME_LEFT = ''
    CHAR_TIME_RIGHT = ''
    COLOR_TIME_NUMBERS = (240, -1)

    # Vertical tab list color
    COLOR_VERTICAL_TAB_NUMBER = (240, -1)

    # STATUS
    CHAR_STATUS = '●'
    COLOR_MUC_JID = (39, -1)

    # User list color
    COLOR_USER_VISITOR = (239, -1)
    COLOR_USER_PARTICIPANT = (167, -1)
    COLOR_USER_NONE = (240, -1)
    COLOR_USER_MODERATOR = (39, -1)

    # nickname colors
    COLOR_REMOTE_USER = (39, -1)

    # Strings for special messages (like join, quit, nick change, etc)
    # Special messages
    CHAR_JOIN = '▶'
    CHAR_QUIT = '◀'
    CHAR_KICK = '🕱'
    CHAR_NEW_TEXT_SEPARATOR = '―'
    CHAR_OK = '✔'
    CHAR_ERROR = '✖'
    CHAR_EMPTY = ' '
    CHAR_ACK_RECEIVED = CHAR_OK
    CHAR_NACK = CHAR_ERROR
    CHAR_COLUMN_ASC = ' ▲'
    CHAR_COLUMN_DESC = ' ▼'
    CHAR_ROSTER_ERROR = CHAR_ERROR
    CHAR_ROSTER_TUNE = '♪'
    CHAR_ROSTER_ASKED = '?'
    CHAR_ROSTER_ACTIVITY = 'A'
    CHAR_ROSTER_MOOD = 'M'
    CHAR_ROSTER_GAMING = 'G'
    CHAR_ROSTER_FROM = '←'
    CHAR_ROSTER_BOTH = '↔'
    CHAR_ROSTER_TO = '→'
    CHAR_ROSTER_NONE = '⇹'

    CHAR_AFFILIATION_OWNER = '#'
    CHAR_AFFILIATION_ADMIN = '@'
    CHAR_AFFILIATION_MEMBER = '+'
    CHAR_AFFILIATION_NONE = ' '

    CHAR_CHATSTATE_ACTIVE = '●'
    CHAR_CHATSTATE_COMPOSING = '…'
    CHAR_CHATSTATE_PAUSED = '✖'

    COLOR_JOIN_CHAR = (41, -1)
    COLOR_QUIT_CHAR = (236, -1)
    COLOR_KICK_CHAR = (196, -1)

    # Info messages color (the part before the ">")
    INFO_COLORS = {
            'info': (39, -1),
            'error': (196, -1),
            'warning': (221, -1),
            'roster': (72, -1),
            'help': (39, -1),
            'headline': (11, -1, 'b'),
            'tune': (6, -1),
            'gaming': (6, -1),
            'mood': (2, -1),
            'activity': (3, -1),
            'default': (7, -1),
    }

theme = theming.theme = DarkerTheme()
