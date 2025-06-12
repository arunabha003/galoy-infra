#!/bin/bash

set -eu

source pipeline-tasks/ci/tasks/helpers.sh

pushd repo/examples/aws

update_examples_git_ref || true

init_kubeconfig

echo yes | make destroy-smoketest || echo "ignore smoketest destroy"
sleep 5

echo yes | make destroy-platform || echo "ignore platform destroy"
sleep 5

echo yes | make destroy-inception || echo "ignore inception destroy"
sleep 5

echo yes | make destroy-bootstrap || echo "ignore bootstrap destroy" 