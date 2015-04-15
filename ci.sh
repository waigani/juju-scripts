#!/bin/sh
set -e

# This script runs CI scripts locally on an Ubuntu OS. It should be run in a
# working directory.
# Prerequisites:
# bzr
# juju
# wget (optional)

# There are three ways to run this script:
#
# 1) $ ci.sh
# Deploy two services with a relation on the local provider.
#
# 2) $ ci.sh <provider>
# As above, but on the given provider.
#
# 3) $ ci.sh <provider> <path/to/new/juju/bin>
# As above, but the environment will also be upgraded and then destroyed on
# completion.
#
# For the adventurous, you can also execute the script directly from the web:
# wget -qO- https://raw.githubusercontent.com/waigani/juju-scripts/master/ci.sh | sh -s <provider> <new/juju/bin>
#
# or, a little shorter:
# wget -qO- http://goo.gl/A0WnhZ | sh -s <provider> <new/juju/bin>

# patch charm repo path
JUJU_REPOSITORY=$(pwd)/repository/

# set the provider to use
provider=$1
if [ -z "$provider" ]
    then
    provider=local
fi
 
# get the CI tools
if [ ! -d juju-ci-tools ]; then
     bzr checkout lp:juju-ci-tools
fi

# get charms used for testing
if [ ! -d repository ]; then
     bzr checkout lp:juju-ci-tools/repository
fi

if [ $# -eq 2 ]
  then
      # run the full deploy and upgrade job. This will exit on failure, and destroy
    # the environment on success. logs will be stored in logs/0 this directory
    # needs to be removed before running the script again.
    #
    # If you are running the full job which upgrades Juju, you will need a
    # ./newjuju/bin/ dir with a version of Juju greater than the one currently in
    # $PATH.

    # create a logs dir for the tests
    mkdir -p logs

    python juju-ci-tools/deploy_job.py $provider logs $provider --new-juju-bin $2
  else
      # deploy a stack of two services and add a relation
    python juju-ci-tools/deploy_stack.py $provider --charm-prefix=local:
fi
