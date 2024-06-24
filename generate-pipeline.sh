#!/bin/bash

# Define the dynamic pipeline JSON
PIPELINE='{
  "steps": [
    {
      "label": "Say Hello World",
      "command": "echo Hello, World! This is a dynamic step"
    }
  ]
}'

# Upload the dynamic pipeline to Buildkite
echo "$PIPELINE" | buildkite-agent pipeline upload
