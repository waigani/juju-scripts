#!/bin/bash
set -e

# This script downloads the CI repositories and lists what tests can be run. It should be run in a
# working directory on Ubuntu OS.
#
# Prerequisites:
# bzr
# juju
# curl (optional)
#
# For the adventurous, you can execute the script directly from the web:
# bash <( curl https://raw.githubusercontent.com/waigani/juju-scripts/master/ci_tests.sh )
#

echo "Select a CI test from the list below and run:
$ python <test_file.py> -h

To use test charms, you'll need to run the following before running the test:
$ export JUJU_REPOSITORY=$(pwd)/repository/
"

# get the CI tools
if [ ! -d juju-ci-tools ]; then
     bzr checkout lp:juju-ci-tools
fi

# get charms used for testing
if [ ! -d repository ]; then
     bzr checkout lp:juju-ci-tools/repository
fi

tests=`grep -l -d skip "if __name__ == '__main__':" juju-ci-tools/*`

for t in $tests
do
  echo "$t"
done
