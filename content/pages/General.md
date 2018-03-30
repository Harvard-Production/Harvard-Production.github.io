title: General
sortorder: 222

## Harvard Odyssey Cluster

Harvard's Odyssey cluster quick start guide is [here](https://www.rc.fas.harvard.edu/resources/odyssey-quickstart-guide/).  It's a good way to get up to speed on the basics of the cluster.

You will need to set up two factor authentication to log in to the cluster, instructions from harvard are available [here](https://www.rc.fas.harvard.edu/resources/documentation/openauth/).  For problems or questions, please contact harvard directly.

## Logging in to the Harvard Cluster

Once you have you authentication squared away, you can log in to the nodes via `ssh [username]@login.rc.fas.harvard.edu`.  This will land you in your home directory (for me, `/n/home00/cadams/`).  We also have a shared group space which is at `/n/holylfs/LABS/guenette_lab`.

If you log in and take a look in our shared group area, you'll see this type of structure:

```shell
[cadams@holy2c18201 guenette_lab]$ pwd
/n/holylfs/LABS/guenette_lab
[cadams@holy2c18201 guenette_lab]$ ls
data  production  software  users
[cadams@holy2c18201 guenette_lab]$
```
Here, the `users` directory is a good spot to do development, store you built code (anything stored in our group area is accessible from worker nodes), and put small files and such.  For large output files, particularly if you're writing many simultaneously, you're better off writing them to the `data/users/` area.  You don't need special permissions to make yourself a directory in these areas.  Just go ahead and do it.

### Software

In the `software` directory, I have installed larsoft and several other things.  Currently, the following versions of uboonecode are installed there:

- v06_26_01_09 (e10:prof)
- v06_26_01_10 (e10:prof)
- v06_26_01_12 (e10:prof)
- v06_26_01_13 (e10:prof)

Additionally, you can get larsoft versions:

* v06_26_01_07 (e10:prof)
* v06_26_01_08 (e10:prof)
* v06_26_01_09 (e10:prof)
* v06_26_01_10 (e10:prof)
* v06_67_00 (e15:prof)

Need a different version of larsoft?  Check out [installing a new version of larsoft]({filename}larsoft.md)

## Interactive Jobs

Once you log on, unless you are just here to check the status of your running jobs, you probably want an interactive node.  If you're just submitting jobs from an interactive node (which is fine if the log in nodes are slow and driving you crazy), you can get a single interactive node of ours with:
```shell
srun --pty -n 1 -N 1 -p guenette -t 200 --mem 4000 /bin/bash
```

Please, don't put this in your .bash_profile.  If our queue is full, or something changes about our partition info, it's possible this command will never complete and you will just have a hanging shell waiting to get an impossible interactive job.  Feel free to alias it in you .bash_profile, though, something like this:
```shell
alias interactive_node='srun --pty -n 1 -N 1 -p guenette -t 200 --mem 4000 /bin/bash'
alias interactive_node_8core='srun --pty -n 8 -N 1 -p guenette -t 200 --mem 32000 /bin/bash'
```

Our current nodes have 32 cores, and share 128 GB of memory.  We have 16 total nodes.  We're supposed to get upgraded to 16 new nodes, 8 of which will have 256GB of memory per node (8GB per core).  I don't know when that will happen ...

## Submitting Jobs

You can read all about slurm and how to submit jobs on the [Odyssey quick start guide](https://www.rc.fas.harvard.edu/resources/odyssey-quickstart-guide/) or the slurm site [itself](https://slurm.schedmd.com/).

For small jobs, if you want to write a little script to run the jobs go right ahead.  If you want to run larger jobs, or use our MCC8 dataset for microboone, use the production software [github](https://github.com/Harvard-Production/production-tools).

I maintain the production tools instance for everyone.  You are welcome to browse the code, suggest changes, make pull requests, etc.  To ensure stability of jobs, there is a static version of the production code available at `/n/holylfs/LABS/guenette_lab/production/production-tools/`.  You can set up the tools like this:
```shell
[cadams@holy2c18201 production]$ source /n/holylfs/LABS/guenette_lab/production/production-tools/setup.sh
Setting up production tools from /n/holylfs/LABS/guenette_lab/production/production-tools...
To submit jobs, use the syntax
  production.py -y config.yml [-s stage] --[clean | submit | check | status]
```

You can see this is telling you to use the script `production.py` - if you're coming from the fermigrid and microboone, you're familiar with `project.py`.  This is pretty similar.  I deliberately changed the name in case someone sets up ubutil here, there will be no confusing conflicts.

To run these jobs, you need a yaml configuration file.  In particular this uses the python implementation of [yaml](https://github.com/yaml).  You can learn more about the configuration files, and find some examples, over on the [configuration]({filename}Configuration.md) page.

## Monitoring jobs
You can monitor your jobs online through harvards job [portal](https://portal.rc.fas.harvard.edu/jobs/).  Or, if you are on an interactive or login node, you can use squeue.  If you have the production tools set up, you can can use the `--check` and `--status` commands to see how your jobs are doing.

`sinfo -p guenette` will tell you the status of our dedicated nodes.

## Disk Usage
You can check our group quota with: `lfs quota -hg guenette_lab /n/holylfs/`.  Our quota is currently 140TB, but we've been promised 500TB.  Since most of the disk usage is from production jobs, and the production database stores file size, the [datasets]({filename}Datasets.md) page's "total" row at the bottom of the page is a pretty accurate measurement of our disk usage.

## Downtimes

Once per month, roughly, there are downtimes.  Sometimes, unscheduled interruptions happen, and if they're known you can see about them [here](https://status.rc.fas.harvard.edu/).  Sometimes, you might be the first to notice a problem, so you can always submit a [ticket](https://portal.rc.fas.harvard.edu/rcrt/submit_ticket) (you can also find help through the [support](https://www.rc.fas.harvard.edu/resources/support/) page).

## Miscellaneous

Here I'll just list some things that don't fit elsewhere.

There is a small bug when building uboonecode from scratch. You need to set up curl: `module load curl`.  It also complains about -lxml2, which you can avoid by removing the problem directory from the build list.

By default, the work directory of our jobs is `/n/regal/guenette_lab/work`.  You can use this space on interactive nodes if you want, but it's temporary storage, lifetime of ~30 days or so.  Don't store anything valuable there.  But, if your jobs are crashing and you're not sure why, you can look in the work directories to see what happened and browse the log files.

Each node also has a /scratch space that you can use, if you need high speed IO.  This is as fast as it gets, since it's physically connected to the node and not shared.  But, it's only 360GB (~10 GB per core) so it can easily fill up during larsoft jobs.  In general, running interactive things from the group's home directories (/n/holylfs/LABS/guenette_lab/users/) is just fine.  You can also run from your own personal home directory.