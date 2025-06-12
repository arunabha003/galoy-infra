#!/bin/bash

set -eu

source pipeline-tasks/ci/tasks/helpers.sh

pushd repo/examples/aws

update_examples_git_ref || true

init_kubeconfig

if [ -f postgresql/terraform.tfstate.d/testflight*/terraform.tfstate ]; then
  echo yes | make destroy-postgresql || echo "ignore postgresql destroy"
else
  echo "No postgresql terraform state found - nothing to destroy"
fi 