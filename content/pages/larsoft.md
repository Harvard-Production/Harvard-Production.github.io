title: Larsoft
status: hidden

So you want to install a new version of larsoft?  Ok.  But be careful.  You are going to be modifying the software directory, which is shared and maybe someone is even using it right now on the grid.  So if you break it, it could be disruptive.  That said, if you know what you're doing, you'll be fine following the instructions here.

### pullProducts.sh

Fermilab uses a script called pullProducts.sh to get an install software that they distribute.  We already have this script ready to go at `/n/holylfs/LABS/guenette_lab/software/pullProducts.sh`.  The script takes arguments like this:
```shell
pullProducts <options> <product_topdir> <OS> <bundle-spec> <qual_set> <build-spec>
```

If you want to install uboonecode v06_26_01_5000 (which I'm sure is coming soon) you would do:
```shell
cd /n/holylfs/LABS/guenette_lab/software
./pullProducts /n/holylfs/LABS/guenette_lab/software/larsoft/ slf7 uboone-v06_26_01_5000 e10 prof
```

After this, it will pull down a lot of this (it will skip things that already exist in that directory) and eventually will complete.  You can then remove all of the `*.bz2` files it generates, and your software is good to go

### Other installations
In principle, if you have a package you've built yourself using mrb, you can install it here.  If you know how to do this, and for some reason you want to, great.  If you think you want to do this but don't know how, contact me at coreyadams [at] fas.harvard.edu and I can help you.