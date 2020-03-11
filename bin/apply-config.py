#!/usr/bin/env python

# Supports python 2 and python 3 (for now)

import configparser
import os


assert 'RELEASE' in os.environ, 'Env var RELEASE must be set'
release = os.environ['RELEASE']
supported_releases = ['stable/rocky', 'stable/stein', 'stable/train']
assert release in supported_releases, 'Value of env var RELEASE must be valid'


def apply_config(source_path, target_path):
    """ Overwrite target config values with source config values """
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

print('Applying default configuration to kolla-build.conf')
default_config = 'conf/defaults.ini'
apply_config(default_config, kolla_config)

print ('Applying {} release configs'.format(release))
release_configs = {
    'stable/rocky': 'conf/rocky.ini',
    'stable/stein': 'conf/stein.ini',
    'stable/train': 'conf/train.ini',
}
apply_config(release_configs[release], kolla_config)
