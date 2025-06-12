#!/bin/bash

set -eu

source pipeline-tasks/ci/tasks/helpers.sh

pushd repo/examples/aws

make_commit "Bump examples to '${MODULES_GIT_REF}'" 