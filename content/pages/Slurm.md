title: Slurm
sortorder: 444

### About Slurm
Slurm is an open source resource management software.  You can even install it on your laptop if you want ... though, why would you?

Most features you want from a batch submission software are available, and slurm has a decent tutorial and documentation at it's [website](https://slurm.schedmd.com/).  Plus, it's fairly popular, so good questions and answers are available on stack overflow.

If you use the production software, a lot of slurm actions are done for you and you don't need to worry about it.  Here I'll just share some useful commands for reference, specific to our group.

#### Job status for running jobs

In general, [`squeue`](https://slurm.schedmd.com/squeue.html) is the command you want for checking a job's status.  For example:

```shell
squeue -u [username]
squeue -p guenette
squeue -j [jobid]
```
Harvard uses it's own version of squeue.  It mostly works fine, though it only updates every few seconds.  If you think it should list a job and you don't see it, you can try again in a few seconds and it should work.

Harvard's squeue does have a noteable missing feature, it behaves poorly for job arrays (which is what is used with our production tools).  If you launch job `38349837` with an array of 10 jobs, you expect `squeue -j 38349837` to list all 10 jobs in the array.  It doesn't, but `/usr/bin/squeue -j 38349837` **does** work as you expect.

#### Job status for finished jobs

Once a job has finished, it's no longer visibile in `squeue`.  Instead, you can get information about the job with [`sacct`](https://slurm.schedmd.com/sacct.html) which will queury the slurm database for the information you want.

#### Changing the parameters of a running job

You can change many of the requirements of a running job or pending job without having to reschedule the job.  [`scontrol`](https://slurm.schedmd.com/scontrol.html) is the command you want for this.

#### Other things?

There is probably more you want to do.  Great!  Your best resources are google, and you can always send me (Corey) an email or message and I'll try to help.  If you find something that you want to do often, or think it would be good to have in the production tools software, let me know and we'll see what we can do.