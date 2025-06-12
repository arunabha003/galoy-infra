#!/bin/bash

set -eu

source pipeline-tasks/ci/tasks/helpers.sh

if [ -f ${CI_ROOT}/postgresql-error ]; then
  echo "PostgreSQL tests did not pass"
  exit 1
fi

pushd repo/examples/aws

update_examples_git_ref || true

init_kubeconfig

make postgresql &
make_pid=$!

for i in $(seq 1 30); do
  if kill -0 $make_pid 2>/dev/null; then
    echo "Waiting for postgresql script to complete (${i}/30)..."
    sleep 60
  else
    echo "Script completed."
    break
  fi
done

if kill -0 $make_pid 2>/dev/null; then
  echo "Script is still running after 30 minutes."
  kill $make_pid
  echo "Script was killed."
  touch ${CI_ROOT}/postgresql-error
  exit 1
fi

if wait $make_pid; then
  echo "PostgreSQL tests passed"
else
  echo "PostgreSQL tests failed"
  touch ${CI_ROOT}/postgresql-error
  exit 1
fi 