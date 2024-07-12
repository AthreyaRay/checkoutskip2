#!/bin/bash
API_TOKEN="bkua_57c5d5324e03b00d612e200afc53a1da3846a15b"
ORG_SLUG="personal-use-4"
PIPELINE_SLUG="skiptest123"
BUILD_NUMBER="463"

# Using the belwo Curl to fetch the build information from https://buildkite.com/docs/apis/rest-api/builds#get-a-build
build_api_response=$(curl -s -H "Authorization: Bearer ${API_TOKEN}" \
  "https://api.buildkite.com/v2/organizations/${ORG_SLUG}/pipelines/${PIPELINE_SLUG}/builds/${BUILD_NUMBER}")

# Print the raw JSON response for debugging if needed 
# echo "Raw JSON response:"
# echo "$response" | jq .

# Using the below script to calculate the job wait time. The idea is that wait time is the difference between created time and start time 
echo "$build_api_response" | jq -r '
  def removing_fractional_seconds:
    sub("\\.[0-9]+Z"; "Z");

  if .jobs then
    .jobs[] |
    select(.started_at != null) |
    {
      job_name: .name,
      waiting_time: ( ( ( .started_at | removing_fractional_seconds | fromdateiso8601 ) - ( .created_at | removing_fractional_seconds | fromdateiso8601 ) ) | . as $time | "\($time / 3600 | floor) hours, \($time % 3600 / 60 | floor) minutes, \($time % 60) seconds" )
    } |
    "Job \(.job_name) waited \(.waiting_time) to get an agent."
  else
    "No build information was found : Please check if all variables are declared accurately and build exists. Uncomment Print the raw JSON response for debugging if needed."
  end
'
