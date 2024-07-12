#!/bin/bash

# Load the previous state from a metadata
previous_failed=$(buildkite-agent meta-data get "failed_job" --default "false")

# Determine current build status
if [ "$BUILDKITE_BUILD_STATE" == "failed" ]; then
  current_failed="true"
else
  current_failed="false"
fi

# Compare and decide the notification
if [ "$current_failed" == "true" ]; then
  # Notify only if this is the first failure after a success
  if [ "$previous_failed" == "false" ]; then
    echo "Build failed, sending notification..."
    curl -X POST -H 'Content-type: application/json' --data '{"text":"Build failed!"}' $SLACK_WEBHOOK_URL
  fi
elif [ "$previous_failed" == "true" ]; then
  echo "Build passed after failure, sending notification..."
  curl -X POST -H 'Content-type: application/json' --data '{"text":"Build passed after failure!"}' $SLACK_WEBHOOK_URL
fi

# Update the state in metadata for the next run
buildkite-agent meta-data set "failed_job" "$current_failed"
