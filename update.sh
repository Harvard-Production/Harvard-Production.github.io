#!/bin/bash

# Setup the needed software:
source /n/holylfs/LABS/guenette_lab/software/python_tools/setup.sh
source /n/holylfs/LABS/guenette_lab/production/production-tools/setup.sh

# Go to the website directory, if needed:
cd /n/holylfs/LABS/guenette_lab/production/Harvard-Production.github.io/

# This script calls the database updating script, then creates the dataset page
# Then, it builds the html, commits the changes, and pushes to master.

# Make the html table for file status:
rm -f harvard_projects_summary.html
summarize_projects.py

# Create the dataset html page:

rm -f tempDatasets.md

touch tempDatasets.md
echo "title: Datasets" >> tempDatasets.md
echo "Last updated: $(date)" >> tempDatasets.md

cat harvard_projects_summary.html >> tempDatasets.md

mv tempDatasets.md content/pages/Datasets.md

make html
mv output/pages/datasets.html pages/
git add pages/datasets.html
git commit -m "Update datasets $(date)"
git push
