#!/usr/bin/env python3

import subprocess
import re
import os
import sys

class BumpVersion:
    def __init__(self, tag):
        self.patch = int(last_tag.split(".")[-1])
        self.minor = int(last_tag.split(".")[-2])
        self.major = int(''.join(c for c in last_tag.split(".")[-3] if c.isdigit()))
        self.prefix = ''.join(c for c in last_tag.split(".")[-3] if not c.isdigit())

    def bump(self, bump_flag):
        if bump_flag == "patch":
            self.patch += 1
        elif bump_flag == "minor":
            self.minor += 1
        elif bump_flag == "major":
            self.major += 1
        else:
            print(f"unsupported bump flag {bump_flag}")
            sys.exit(1)
        
        return self.prefix + str(self.major) + "." + str(self.minor) + "." + str(self.patch) 

# Strip the optional 'v' in the front, and any possible suffixes
def strip(tag):
    return re.match('(v?)([0-9]+\.[0-9]+\.[0-9]+)', tag).groups()[1]

def has_postfix(tag):
    return re.match('(v?)([0-9]+\.[0-9]+\.[0-9]+)', tag).span()[1] != len(tag)

if __name__ == '__main__':

    if len(sys.argv) != 2:
        print(f"Incorrect number of arguments. Received {sys.argv}.")
        sys.exit(1)

    bump = sys.argv[-1]

    out, tags = subprocess.getstatusoutput('git tag -l')

    if out != 0:
        print("Failed to list the git tags.")
        sys.exit(1)

    tags = tags.split('\n')
    tags = [tag for tag in tags if re.match(r"v?[0-9]+\.[0-9]+\.[0-9]+", tag)]
    tags.sort(key=lambda s: list(map(int, strip(s).split('.'))))

    if has_postfix(tags[-1]):
        print("latest tag has a postfix! Exiting!")
        sys.exit(1)
    
    last_tag = tags[-1]

    bump_version = BumpVersion(last_tag)
    out_version = bump_version.bump(bump)

    with open("/env.sh", "w") as env_file:
        env_file.write(f"#!/bin/bash\nexport NEW_VERSION={out_version}")

    with open(os.environ.get("GITHUB_ENV"), "a") as env_file:
        env_file.write(f"NEW_VERSION={out_version}")

