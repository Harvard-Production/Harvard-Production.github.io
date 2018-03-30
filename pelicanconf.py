#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = u'Corey Adams'
SITENAME = u'Harvard-Production'
SITEURL = ''

THEME = 'theme/bootstrap'

PATH = 'output'

TIMEZONE = 'America/New_York'

DEFAULT_LANG = u'en'
DEFAULT_DATE = 'fs'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

PAGE_ORDER_BY = 'sortorder'

# Blogroll
LINKS = (('Github', 'https://github.com/Harvard-Production'),
         ('Research', 'https://www.physics.harvard.edu/people/facpages/guenette'),
         ('Microboone', 'https://microboone-exp.fnal.gov/'),
         ('NEXT', 'http://next.ific.uv.es/next/'),
)

# Social widget
SOCIAL = (('Github', ''),
         )

DEFAULT_PAGINATION = False

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True
