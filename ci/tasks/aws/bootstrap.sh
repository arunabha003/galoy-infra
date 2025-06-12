#!/bin/bash

set -eu

source pipeline-tasks/ci/tasks/helpers.sh

pushd repo/examples/aws

update_examples_git_ref

init_kubeconfig
init_bootstrap_aws

write_aws_users

echo yes | make bootstrap 