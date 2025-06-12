#!/bin/bash

set -eu

source pipeline-tasks/ci/tasks/helpers.sh

pushd repo/examples/aws

update_examples_git_ref || true

init_kubeconfig

write_aws_users

make inception 