#!/bin/bash

set -eu

source pipeline-tasks/ci/tasks/helpers.sh

pushd repo/examples/aws

update_examples_git_ref || true

init_kubeconfig

export KUBECONFIG=${CI_ROOT}/.kube/config

make smoketest

SMOKETEST_RESULTS=$(kubectl get secret -n galoy \
  smoketest-results-$(cat testflight-uid/version | tr -d .) \
  -o jsonpath='{.data.results}' | base64 -d)

if ! echo $SMOKETEST_RESULTS | grep -q "\"failures\": 0,"; then
  echo "Some smoketest failed"
  echo $SMOKETEST_RESULTS | jq
  exit 1
fi

if ! echo $SMOKETEST_RESULTS | grep -q "\"errors\": 0,"; then
  echo "Some smoketest errored"
  echo $SMOKETEST_RESULTS | jq
  exit 1
fi

echo "All smoketest passed"
echo $SMOKETEST_RESULTS | jq 