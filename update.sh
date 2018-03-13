#!/bin/bash

# This script calls the database updating script, then creates the dataset page
# Then, it builds the html, commits the changes, and pushes to master.

# Make the html table for file status:
# summarize_projects.py

# Create the dataset html page:

rm -f tempDatasets.md

touch tempDatasets.md
echo "title: Datasets" >> tempDatasets.md
echo "Last updated: $(date)" >> tempDatasets.md

cat harvard-production-summary.html >> tempDatasets.md

mv tempDatasets.md content/pages/Datasets.md

make html
# git add pages/datasets.html
# git commit -m "Update datasets $(date)"
# git push