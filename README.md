# Conda build for Soar

This repository contains a recipe and instructions for building a conda package for
the Soar cognitive architecture.

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

## Available releases

The following builds are available on [garage-conda-local] on [Artifactory]:

| Version         | Platforms        |
|-----------------|------------------|
| 9.6.3 (build 6) | MacOS M1.        |

## How to install

You can install into a conda environment on a supported platform using either conda or mamba:

```bash
conda install -c https://artifactory.analog.com/artifactory/garage-conda-local soar
```

If you have not already done so, we recommend that you configure `garage-conda-local` as a custom channel:

```bash
conda config --set custom_channels.garage-conda-local https://artifactory.analog.com/artifactory/
```

then you can install using the simple channel name:

```bash
conda install -c garage-conda-local soar
```


## How to build

First make sure to increment the build number in the `meta.yaml` file,
if it is the same as the previous build. Then you can build the package
simply by running conda-build (on MacOS):

```bash
conda build conda.recipe
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

## Implementation notes

The recipe does not build Soar from source. It simply downloads the binary
distribution from [GitHub][soar-releases] and copies and patches some
files. This is done by the `build.sh` script in the recipe. Specifically,
the build script does the following:

1. Runs the `setup.sh` script from the Soar distribution. This will
    copy binaries into place based on the architecture and will remove
    any MacOS quarantine attributes.
2. Copies the resulting soar distribution directory to the `soar/`
    directory in the build prefix.
3. Copies shell scripts from `src/bin` in this repo into the `bin/`
    directory of the build prefix.
4. On MacOS uses `install_name_tool` to modify some hard-coded shared library
    dependencies from absolute paths in global install locations, to relative
    paths within the conda environment:

    * `_Python_sml_ClientInterface.so`: fixes python dependency
    * `libTcl_sml_ClientInterface.dylib`: fixes libtcl dependency
    * `libtclsoarlib.dylib`: fixes libtcl dependency
5. Adds a `soar.pth` file to the Python `site-packages` directory to
    add the `soar/bin` directory to the Python path.
6. Copies the `activate.sh`/`deactivate.sh` scriptes from the recipe into
    the corresponding `etc/conda/activate.d`/`etc/conda/deactivate.d`
    directories.

    The activate/deactivate scripts will be invoked when an environment
    using this package is activated or deactivated. The activate script
    will add the `$JAVA_HOME/bin` directory to the path, so that the java
    executables from the environment will be used. And it will also set
    the `SOAR_HOME` environment variable to the location of the Soar binaries.

[Artifactory]: https://artifactory.analog.com/
[garconda]: http://boston-garage.pages.gitlab.analog.com/garconda/
[garage-conda-local]: https://artifactory.analog.com/ui/repos/tree/General/garage-conda-local
[garconda-upload]: http://boston-garage.pages.gitlab.analog.com/garconda/cli/garconda-upload/
[github-soar]: https://github.com/SoarGroup/Soar
[soar-releases]: https://github.com/SoarGroup/Soar/releases
