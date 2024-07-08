API_TOKENer="bkua_2da3209f82823f206db04c145a426167c3953b1b"

API_TOKEN="bkua_64f927c0203faa1b6ab56c3b514f1d9a244fb4eb" ##this is with all access

TOKEN="bkua_c342bc1e8133bdbabadbe9ef3ebeb71cb6fd884f"

TOKEN1="LzWHQ5Kub9fCXGvfoNGmekXz"
TOKENER="ANiKMowcoPVARzrZkRqBiGUn"

# Organization slug, pipeline slug, build number, and job ID
ORG_SLUG="personal-use-4"
PIPELINE_SLUG="skiptest123"
BUILD_NUMBER="018e5c01-d6b9-477b-9d69-5482bcf061e8"
JOB_ID="018e5c01-d6ca-43ce-8c88-1ea1706445a5"


#!/bin/bash

# Function to trigger a new build
trigger_build() {
  local api_token="bkua_c342bc1e8133bdbabadbe9ef3ebeb71cb6fd884f"
  local organization_slug="personal-use-4"
  local pipeline_slug="checkout-skip-test"
  local build_message="Triggered by another step"
  local env_var1="VALUE1"
  local env_var2="VALUE2"

  curl -X POST "https://api.buildkite.com/v2/organizations/$organization_slug/pipelines/$pipeline_slug/builds" \
    -H "Authorization: Bearer $api_token" \
    -H "Content-Type: application/json" \
    -d '{
      "commit": "HEAD",
      "branch": "main",
      "message": "'"$build_message"'",
      "env": {
        "ENV_VAR1": "'"$env_var1"'",
        "ENV_VAR2": "'"$env_var2"'"
      }
    }'
}

# Conditional logic to decide whether to trigger the build
if [ "$CONDITION" == "true" ]; then
  trigger_build
fi
