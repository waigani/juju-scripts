#!/bin/sh
set -e

# This script runs CI scripts locally on an Ubuntu OS. It should be run in a
# working directory.
# Prerequisites:
# wget
# bzr
# juju

# To run the script:
# mkdir jujuci; cd jujuci
# wget -qO- https://raw.githubusercontent.com/waigani/juju-scripts/master/ci.sh | sh
#
# or, a little shorter:
# wget -qO- http://goo.gl/A0WnhZ | sh
#
# The script takes one optional argument which is the path to a newer juju
# bin. If this arg is set, the full job will be run:
# # wget -qO- http://goo.gl/A0WnhZ | sh -s /abs/path/to/new/juju/bin/
 
# get the CI tools
if [ ! -d juju-ci-tools ]; then
 	bzr checkout lp:juju-ci-tools
fi

# get charms used for testing
if [ ! -d juju-ci-tools/repository ]; then
 	bzr checkout lp:juju-ci-tools/repository
fi

# cd into repository and run the tools from there. Normally, you'd add the
# charms to you $JUJU_REPOSITORY path, but we keep running the tests isolated
# to the working dir.
cd repository


if [ $# -eq 0 ]
  then
	# deploy a stack of two services and add a relation
	python ../juju-ci-tools/deploy_stack.py local --charm-prefix=local:
  else
	# run the full deploy and upgrade job. This will exit on failure, and destroy
	# the environment on success. logs will be stored in logs/0 this directory
	# needs to be removed before running the script again.
	#
	# If you are running the full job which upgrades juju, you will need a
	# ./newjuju/bin/ dir with a version of Juju greater than the one currently in
	# $PATH.

	# create a logs dir for the tests
	mkdir ../logs

	python ../juju-ci-tools/deploy_job.py local ../logs local --new-juju-bin $1
fi
	




