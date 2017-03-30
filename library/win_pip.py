#!/usr/bin/python
# -*- coding: utf-8 -*-


DOCUMENTATION = '''
---
module: win_pip
short_description: A custom windows version of the pip module.
description:
  - Installs python modules with pip
options:
  name:
    description:
      - The name of the pip module
    required: false
  state:
    description:
      - The state of module
    required: false
    default: 'present'
'''

EXAMPLES = '''
# Install virtualenv on the windows host
ansible winserver -m win_pip -a "name=virtualenv state=present"
'''
