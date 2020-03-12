#!/usr/bin/env python

# Supports python 2 and python 3 (for now)

import configparser
import os


assert 'RELEASE' in os.environ, 'Env var RELEASE must be set'
release = os.environ['RELEASE']
supported_releases = ['rocky', 'stein', 'train']
assert release in supported_releases, 'Value of env var RELEASE must be valid'


def apply_config(source_path, target_path):
    """ Overwrite target config values with source config values """
    print('applying {} config to {}'.format(source_path, target_path))
    source = configparser.ConfigParser()
    source.read(source_path)
    target = configparser.ConfigParser()
    target.read(target_path)
    for section in source:
        for key in source[section]:
            value = source[section][key]
            print('[{}] {} = {}'.format(section, key, value))
            target.set(section, key, value)
    with open(target_path, 'w') as target_file:
        target.write(target_file)


kolla_config = 'kolla/etc/kolla/kolla-build.conf'
default_config = 'conf/defaults.ini'
release_config = 'conf/{}.ini'.format(release)
apply_config(default_config, kolla_config)
apply_config(release_config, kolla_config)
