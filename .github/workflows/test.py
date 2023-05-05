import os
import requests
import json
import logging

# Define the Terraform Cloud API endpoint and organization name
API_ENDPOINT = "https://app.terraform.io/api/v2/organizations/{ORG_NAME}/workspaces"

# Set your Terraform Cloud API token
api_token = os.getenv('TF_API_TOKEN')
headers = {
    "Authorization": f"Bearer {api_token}",
    "Content-Type": "application/vnd.api+json",
}

# Define the name of the workspace you want to create
workspace_name = os.getenv('WORKSPACE_NAME')

# Check if the workspace already exists
params = {"filter[name]": "workspace_name"}
try:
    response = requests.get(API_ENDPOINT.format(ORG_NAME=os.getenv('TF_CLOUD_ORGANIZATION')), headers=headers, params=params)
    response.raise_for_status() # raise an exception if response status code is not 200 OK
    workspaces = response.json()["data"]
    workspace_exists = any(workspace["attributes"]["name"] == workspace_name for workspace in workspaces)
except requests.exceptions.RequestException as e:
    logging.error(f"Failed to retrieve workspace list. Error: {e}")
    workspace_exists = False

# If the workspace doesn't exist, create it
if not workspace_exists:
    payload = {
        "data": {
            "type": "workspaces",
            "attributes": {
                "name": "workspace_name",
                "auto-apply": False,
                "terraform_version": "1.4.6",
                "working-directory": "",
            },
        }
    }
    try:
        response = requests.post(API_ENDPOINT.format(ORG_NAME=os.getenv('TF_CLOUD_ORGANIZATION')), headers=headers, json=payload)
        response.raise_for_status() # raise an exception if response status code is not 201 Created
        print("Workspace created successfully.")
        # Write the workspace ID to a file using os.getenv('GITHUB_ENV')
        workspace_id = response.json()['data']['id']
        with open(os.getenv('GITHUB_ENV'), 'a') as f:
            f.write(f"TFC_WORKSPACE_ID={workspace_id}\n")
    except requests.exceptions.RequestException as e:
        raise SystemExit(f"Error: {e}") # print error message and exit the script
else:
    print("Workspace already exists.")
