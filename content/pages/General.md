title: General

Ssh portal:
[username]@login.rc.fas.harvard.edu

Group area:
/n/holylfs/LABS/guenette_lab/

Check our group nodes:
sinfo -p guenette

Check job status:
squeue -u cadams

Use /n/holylfs/LABS/guenette_lab/data/users for output

How to get an interactive node:
srun --pty -n 32 -N 1 -p guenette -t 200 --mem 128000 /bin/bash

Put your software /n/holylfs/LABS/guenette_lab/users

Check our group quota with: lfs quota -hg guenette_lab /n/holylfs/

Setup larsoft area at:
source /n/holylfs/LABS/guenette_lab/software/larsoft/setup
setup larsoft v0....
setup mrb

There is also cvmfs

[Stupid bug: need to set up curl: 'module load curl']