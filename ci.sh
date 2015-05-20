#!/bin/bash
set -e

# This script runs CI scripts locally on an Ubuntu OS. It should be run in a
# working directory.
#
# Prerequisites:
# bzr
# juju
# wget (optional)

# To run the script:
#
# $ ci.sh  
# This will use the Juju in your PATH to bootstrap on the local provider,
# deploy two services and add a relation between them. The environment will
# then be destroyed.
#
# Options:
#
# $ ci.sh -h 
# This will display help on all options for running a CI job. Any flag passed
# to ci.sh will be forwarded to the CI job. Note that flag arguments must be
# set with "=", not " ". When using --upgrade you need to also specify --new-
# juju-bin=<path/to/newer/juju/bin>.
#
# Ignore the positional arguments in the help documentation. They have been
# set with the following defaults: 
# env=local (override this with the --provider=<provider-name>) 
# logs=logs (override this with the --logs-dir=</path/to/logs/dir>) 
# job_name=$provider (override this with the --job-name=<name>)
#
# Note that job_name is used to name the environment.
#
# Extra Options:
#
# --current-juju-bin=<path/to/juju/bin>
# Set this if you wish to use a version of Juju different to the one currently
# set in PATH.
#
# For the adventurous, you can also execute the script directly from the web:
# wget -qO- https://raw.githubusercontent.com/waigani/juju-scripts/master/ci.sh |\
# sh -s --provider=amazon --current-juju-bin=~/exotic/version/juju/bin
#
# or, a little shorter:
# wget -qO- http://goo.gl/A0WnhZ | sh -s --provider=amazon --current-juju-bin=~/exotic/version/juju/bin
#
# Warning:
#
# This script checks out the tip of the CI repositories, which are under
# active development. As such, their APIs may change which could break this
# script.

# patch charm repo path
JUJU_REPOSITORY=$(pwd)/repository/

# defaults
provider=local
logs=logs

# flags
for i in "$@"
do
case $i in
  --current-juju-bin=*)
  PATH=${i#*=}:$PATH
  shift
  ;;
  --provider=*)
  provider="${i#*=}"
  shift
  ;;
  --logs-dir=*)
  logs="${i#*=}"
  shift
  ;;
  --job-name=*)
  job_name="${i#*=}"
  shift
  ;;
  -*)
  flags="$flags ${i/=/ }"
  ;;
esac
done

if [ -z "$job_name" ]
  then
  job_name=$provider
fi

# get the CI tools
if [ ! -d juju-ci-tools ]; then
     bzr checkout lp:juju-ci-tools
fi

# get charms used for testing
if [ ! -d repository ]; then
     bzr checkout lp:juju-ci-tools/repository
fi

mkdir -p $logs

python juju-ci-tools/deploy_job.py $provider $logs $job_name $flags
