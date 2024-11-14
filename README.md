# Conda build for Soar

This repository contains recipes and instructions for building a conda package for
the Soar cognitive architecture.

There are currently two recipes in this repository:

* from-dist-conda.recipe - builds from official Soar binary distribution
    This currently includes VisualSoar and the TankSoar and Eaters tutorial programs.
    This should be changed to produce a soar package and add-on packages for
    VisualSoar and tutorial programs.
* from-source.recipe - builds a local Soar source tree. 
    This does not include VisualSoar or the tutorial programs.

(*We should probably have the first recipe produce two or more packages.*)

## from-dist-conda.recipe

The recipe is based on the binary distribution of Soar available from the
[Soar releases][soar-releases] on [GitHub][github-soar].

Currently this specifically is for MacOS but probably would extend fairly
easily to Linux.

The recipe contains the following dependencies:

```yaml
    - python 3.12
    - graphviz
    - tk 8.6.13
    - openjdk >=19.0.0
```

The recipe currently hard codes the version of Soar and must be updated 
manually for new releases.

## from-source.recipe

This recipe builds Soar from a local Soar source tree.

In order to use this recipe, you must create a symbolic link in this
directory named `local-soar-root` that points to the root of the
of a local Soar source tree.

## How to build

The version number must be adjusted manually in the `meta.yaml` file
as needed. The build number should also be incremented if you do multiple
builds of the same version for the same architeture and python version.

```bash
conda build <recipe-dir>
```

For `from-source-conda.recipe` you should add the `--python` argument
to specify the desired target python version. For example:

```bash
conda build --python 3.12 from-source-conda.recipe
```

The resulting package can be found in the architecture-specific subdirectory
of your local `conda-bld` directory, which by default is a subdirectory of
your conda build install location, e.g. `~/miniforge3/conda-bld/osx-arm64`.

You can install and test this locally by creating a test environment:

```bash
conda create -n soar-test --use-local soar # You can add =<version>
```

## Upload to artifactory.analog.com

You must have been granted write permission to upload to the
[garage-conda-local] repository in order to upload this or
any other package.

### Using garconda

If you have installed [garconda], you can use [garconda upload][garconda-upload] to 
upload the package to the Analog Artifactory [garage-conda-local] repository:

```bash
garconda upload -c garage-conda-local --latest 'soar-*' 
```
You can add `--dry-run` to see what would be uploaded before actually uploading.
Add `--help` to see information about more options.

### Using the web UI

Alternatively, you can simply upload via the artifactory web interface:

1. Open [garage-conda-local] in your browser
2. Log in with your Analog credentials using the button in the upper right corner.
3. Click on `garage-conda-local` in the left pane to see the list of subdirectories
4. Select the directory appropriate to the architecture you built (e.g. `osx-arm64`)
5. Press the `Deploy` button in the upper right corner
6. Use `Select File` in the dialog select the file to upload from your local
    file system (in the `conda-bld` directory). Then press `Deploy` to complete the upload.

### Testing

Once uploaded, you should see the package when you search using conda or mamba:

```bash
$ conda search -c garage-conda-local soar
Loading channels: done
# Name                       Version           Build  Channel             
soar                           9.6.3         py312_5  garage-conda-local  ```
```
and should be able to create an environment from the channel using
the specified version, e.g.:

```bash
conda create -n soar-test -c garage-conda-local soar=9.6.3
```

[garconda]: http://boston-garage.pages.gitlab.analog.com/garconda/
[garage-conda-local]: https://artifactory.analog.com/ui/repos/tree/General/garage-conda-local
[garconda-upload]: http://boston-garage.pages.gitlab.analog.com/garconda/cli/garconda-upload/
[github-soar]: https://github.com/SoarGroup/Soar
[soar-releases]: https://github.com/SoarGroup/Soar/releases
