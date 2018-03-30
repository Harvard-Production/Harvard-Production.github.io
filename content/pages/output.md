title: Using Output Files
sortorder: 666

On this page, I'll describe some of the ways in which you can use the output files.

## Database interactions

If you have the production software set up, you have access to some python classes that will handle database interactions yourself.  In particular, there is a class for reading the list of datasets `ProjectReader.py` and a class for reading attributes of a particular dataset `DatasetReader.py`.

### Project Reader

Probably, you wont have to interact much with this class, but if you want to your options are basically limited to listing all datasets, and then finding heirarchy information.
```python
>>> from database import ProjectReader
>>> pr = ProjectReader()
>>> pr.list_datasets()
(('bnb_plus_cosmics_mcc86_reco2',), ('bnb_plus_cosmics_mcc86_reco2_test',), ('sbnd_dl_cosmics_larcv',), ('sbnd_dl_cosmics_larsoft',), ('sbnd_dl_NC_cosmics_larcv',), ('sbnd_dl_NC_cosmics_larsoft',), ('sbnd_dl_NC_larcv',), ('sbnd_dl_NC_larsoft',), ('sbnd_dl_nueCC_cosmics_larcv',), ('sbnd_dl_nueCC_cosmics_larsoft',), ('sbnd_dl_nueCC_larcv',), ('sbnd_dl_nueCC_larsoft',), ('sbnd_dl_numuCC_cosmics_larcv',), ('sbnd_dl_numuCC_cosmics_larsoft',), ('sbnd_dl_numuCC_larcv',), ('sbnd_dl_numuCC_larsoft',))

```

### Dataset Reader

This is more useful if you want to right a script that can process your output files.

There are a few useful functions:

`list_file_locations(dataset)` will tell you all the full path of all the files in a dataset.  If it's a big dataset, you're going to get a very long list back.

`sum(dataset, target)` will sum the target value in the database.  So, for example:

```python
>>> from database import DatasetReader
>>> dr = DatasetReader()
>>> dr.sum('bnb_plus_cosmics_mcc86_reco2_test', 'nevents')
Decimal('10')
>>> dr.sum('bnb_plus_cosmics_mcc86_reco2_test', 'nevents', type=0)
Decimal('5')
```

On the second call, I constrained the type of file to be '0' which is the real output file.  (1 == ana file)

#### Database Schema

If you want to know more about the database schema, you can see the scheme file on the production tools [github](https://github.com/Harvard-Production/production-tools/blob/master/python/database/schema.md)

## Merging output files

There is a script, `merge_ana.py`, that can merge ana output files for you from a dataset.  If you want, you can even have it split the output files into several different files.  The only know use case if for training a machine learning algorithm and having train/test/val files, etc.

```shell
usage: merge_ana.py [-h] -p PROJECT -o OUTPUT [-s SPLIT] [--script SCRIPT]

Analysis file merger

optional arguments:
  -h, --help            show this help message and exit
  -p PROJECT, --project PROJECT
                        Project to merge analysis files for
  -o OUTPUT, --output OUTPUT
                        Top Level output directory for this merging.
  -s SPLIT, --split SPLIT
                        Dictionary format for how to split the data, order
                        matters.
  --script SCRIPT       Optional script to run merging with, defaults to
                        'hadd'
```

This script will use `hadd` by default, but you can override this.  In principle, if you have a script that processes your files, and the format is `[script] [output_name] [inputfile1 inputfile2 ...]` then you can pass it as the argument to this script and it will run for you.  I've never tried it, though ....

The split functionality requires a json formatted string on the command line.