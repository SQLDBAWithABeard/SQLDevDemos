# Log in to azd.
azd auth login --tenant-id f98042ad-9bbc-499d-adb4-17193696b9a3

git config --global --add safe.directory /workspaces/SQLDevDemos

mkdir demo

cd demo

# First-time project setup. Initialize a project in the current directory, using this template.
azd init --template jasontaylordev/azd-blazor

# Provision and deploy to Azure
azd up


azd init -t azure-sql-db-session-recommender-v2