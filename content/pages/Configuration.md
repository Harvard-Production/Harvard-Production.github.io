title: Configuration Files
sortorder: 555

The production software is organized through yaml files, which is a pretty straight forward language specification.  I thought about xml, and I thought about json, and I picked yaml because it seemed easy.  If we all agree it's terrible, I'll rewrite this and switch it.

Yaml files essentially get parsed as a dictionary into the python code that runs our production software.  So, a file needs (as of now) four pieces of information to be a valid file for our production code:
```yaml
name:
top_dir:
software:
stages:
```

I'll go through each of these sections here, and subsections as necessary.  There are some **example files** where I keep all of the production level files: [github](https://github.com/Harvard-Production/yml-configs).  By the way, the production software knows to check for the required keys.  If you miss one, it will tell you, you won't be able to submit jobs, and hopefully it will be obvious how to fix it.  If not, just ask.

# name

This is the easiest one.  Give your job a useful name.  Grid jobs will run under this name.  This doesn't have to be unique, but I recommend it.

# top_dir

The top level directory for your work files.  I frequently define it like this:
```yaml
top_dir: &top_dir /n/holylfs/LABS/guenette_lab/data/production/example_project
```

By putting `&top_dir` after the colon, I make this into a 'reference' in yaml, so this can be used later.  Yaml doesn't allow operations (so you can't say outdir : &top_dir /subdirectories, sorry), but you can at least not have to rely on copy/paste.

In your top directory, the production code will generate a work directory. Work will have subdirectories for each stage of jobs you run from this file.  I typically define the output location as `location: *top_dir` after setting the reference, since output will be default make a directory with the stage name under that location.  More on that below.

# software

Software forms a sub-dictionary of the whole configuration file.  You have two options here.  First, you can define the whole dictionary in your main configuration file, or you can simply put a path to an independent yaml file that contains the software dictionary.  The point-to-a-software file funcationality is ready to go, I think, but has a few tests to finish it off so it's not yet on the master branch of the production tools.  It should be soon.

Depending on what type of software you want, the format can vary, but the larsoft configuration is like so:
```yaml
# REQUIRED
type: larsoft
# REQUIRED: List of product areas.  All must contain 'setup' and all will be called
# There can be multiple product areas, though I haven't seen this used.
product_areas:
    - /n/holylfs/LABS/guenette_lab/software/larsoft
# OPTIONAL - local areas can be added here
local_areas:
    - /n/holylfs/LABS/guenette_lab/users/cadams/marco/larsoft_dev/localProducts_larsoft_v06_26_01_09_e1
# REQUIRED: Specific product to set up (larsoft, uboonecode, sbndcode, etc)
product: uboonecode
# REQUIRED: Version of product to set up
version: v06_26_01_10
# REQUIRED: Qualifiers to use for this product
quals: e10:prof
```

There is an option for gallery code which adds the key `setup_scripts`, and it's not too hard to add an additional software configuration.  If you want to do something that doesn't seem supported, let me know.

# stages

Your job can have multiple stages.  Each stage is listed here with the `-` character, indicating a list in yaml.  They don't **really** have to be in order, or even depend on each other.  By design, ALL stages either have no input, or receive a dataset as input.  ALL stages write their output files to a dataset.  There is no list_of_files.txt.  That was just too chaotic to manage.

The `stages` section of your config file is structured like this, then:
```yaml
stages:
    - stage1:
        [config stuff]
    - stage2:
        [config stuff]

```

The "config stuff" looks like this, for the larsoft software:
```yaml
stages:
    # It's always good to put comments :)
    - stage_name:
        # REQUIRED: name of fcl
        # These can be run successively
        fcl:
            - run_ubxsec_mc_bnbcosmic.fcl
        # REQUIRED: number of jobs to run
        n_jobs: 50
        # OPTIONAL, used to calculate number of makeup jobs
        event_target: 50
        # OPTIONAL: maximum number of jobs to run simultaneously
        max_concurrent_jobs: 50
        # REQUIRED: number of events per job
        # -1 is "all events in the input file[s]" and is the default
        events_per_job: -1
        # REQUIRED: input definition
        input:
            # REQUIRED: input type
            dataset: bnb_plus_cosmics_mcc86_reco2_test # Can be none or a name

            #OPTIONAL: number of files per job, default == 1
            n_files: 1
        # REQUIRED: output definition
        output:
            #REQUIRED: output location
            # Must be a location for outputfiles, will add stage name if not there
            location: *top_dir
            # The following lines are not yet implemented
            #REQUIRED: dataset name (will be stored in this projects database)
            dataset: sbnd_dl_NC_larsoft
            #REQUIRED: skip root files - default false
            anaonly: true
            #OPTIONAL: string matching key for the ana files
            ana_name: 'hist'

        # REQUIRED: required memory size - default 4000, units are MB
        memory: 6000
        # REQUIRED: time limit.  Default 6 hours.  Format HH:MM:SS
        time: "01:00:00"
```

There are a few things to point out.

- There is a little bit of sloppiness on my part with the event counting, job submitting, etc.  You can end up in the situation where you have events_per_job == -1 (all events) and n_jobs=50, but 10 files per job of differing sizes, etc.   It gets messy, particularly when you want to figure out how many makeup jobs to launch.  I try to handle this gracefully but if it's giving you weird behavior, please let me know.

- fcl files can be chained together.  The software will parse stdout from larsoft, figure out the output name, and use that as the input to the next fcl.  It works pretty well so far.

- `n_jobs` tops out at about 7000.  This is a limitation of the slurm scheduler at Harvard.  It hasn't caused me issues, but good to know.

- The input and output blocks are themselves dictionaries.

  - Input:

    - You have to either say `none` or provided a dataset name for input.  If you provide a dataset, n_files will specify how many files from that dataset will get pulled per worker node.  If a job fails, the files pulled are tagged and it's recoverable.

  - Output:

    - You have to specify a location for your output files, if it's a big project please put it under /n/holylfs/LABS/guenette_lab/data/users/[your username].

    - You have to specify an output dataset name.  This really should be unique.  It will only warn you if that dataset already exists, but submit your jobs anyways.   They won't crash, but just append to that dataset.  If you really want this behavior, great.  I didn't block this by design because it's necessary for makeup jobs and extending datasets.

    - Your output dataset will appear on the (datasets)[{filename}Datasets.md] page with it's statistics.  That site updates every hour, towards the end of the hour.  You can see the latest update timestamp on that page, so if it's not updating let me know.

    - You can say a job is `anaonly` if you don't want to copy back the heavy input files.  If you run over the MCC8 files, you'd better do this!!

    - If your job makes an anafile, you can add an `ana_name` parameter like "hist" or "ntuple" or whatever you please.  Files that have that string in their name will get copied back.  The default is 'hist'.

- For reasons I haven't tried to debug, if you don't put the time in quotes it will get messed up.

- You can request as much memory as you need for your jobs.  Our current nodes have 4GB / core, shared across 128GB per node (32 nodes).  Soon, we will get half upgraded to 8GB / core, across 256 GB.  If your jobs go over memory, or time, they get killed by slurm mercilessly.

One other thing: You can have multiple datasets as input.  If your previous project is split into two pieces for whatever reason, you can input them as a list:

```yaml
    input:
        - dataset1
        - dataset1
```
They will merge in the input of this stage (though the original datasets are untouched in the database), and the output will contain a mixture of both datasets.
