import requests
import json
from datetime import datetime, timedelta, timezone

def fetch_all_builds(organization, pipeline, auth_token , start_date, branch):
    url = f'https://api.buildkite.com/v2/organizations/{organization}/pipelines/{pipeline}/builds'
    headers = {'Authorization': f'Bearer {auth_token}', 'Accept': '*/*'}
    builds = []
    page = 1

    while True:
        params = {'page': page, 'state[]': ['failed', 'passed'], 'branch': branch, 'created_from': start_date.isoformat()}
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()
        data = response.json()
        if not data:
            break
        builds.extend(data)
        page += 1
        #print(params)

    return builds

def filter_builds(builds, branch, start_date, end_date):
    filtered_builds = []
    for build in builds:
        build_date = datetime.fromisoformat(build['created_at'].replace('Z', '+00:00'))
        if build['branch'] == branch and start_date <= build_date <= end_date:
            filtered_builds.append(build)
    return filtered_builds

def calculate_failed_time(builds):
    total_failed_time = timedelta()
    last_failed_build_finished = None
    builds.sort(key=lambda x: x['created_at'])

    for build in builds:
        #print(build)
        if build['state'] == 'failed':
            print('failed build number: ', build['number'])
            print('failed build created at: ', build['created_at'])
            if last_failed_build_finished is None or build['created_at'] > last_failed_build_finished:
                print('failed build', build['created_at'])
                last_failed_build_finished = build['finished_at']
        elif build['state'] == 'passed' and last_failed_build_finished:
            failed_start = datetime.fromisoformat(last_failed_build_finished.replace('Z', '+00:00'))
            passed_end = datetime.fromisoformat(build['created_at'].replace('Z', '+00:00'))
            total_failed_time += passed_end - failed_start
            last_failed_build_finished = None
            #print(total_failed_time)

    return total_failed_time



def format_timedelta(td):
    days = td.days
    hours, remainder = divmod(td.seconds, 3600)
    minutes, seconds = divmod(remainder, 60)
    return f"{days} days {hours} hours {minutes} minutes {seconds} seconds"

def main():
    organization = 'org slug'
    pipeline = 'pipeline slug'
    branch = 'branch'
    auth_token = 'token'
    start_date = datetime(2024, 7, 1, tzinfo=timezone.utc)
    end_date = datetime(2024, 7, 6, tzinfo=timezone.utc)

    all_builds = fetch_all_builds(organization, pipeline, auth_token, start_date, branch)
    filtered_builds = filter_builds(all_builds, branch, start_date, end_date)
    total_failed_time = calculate_failed_time(filtered_builds)
    formatted_time = format_timedelta(total_failed_time)

    print(f"Total time for pipeline '{pipeline}' branch '{branch}' in 'failed' state: {formatted_time}")

main()