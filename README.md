# Conda build for Soar

This repository contains for providing Soar as a conda package. This recipe
simply copies the binary distribution from GitHub and repackages it for conda.

Currently this specifically is for MacOS.

The recipe includes dependencies on Python 3.12, Tcl/Tk 8.6, openjdk >=19,
and graphviz.

The recipe hard codes the version of Soar and must be updated manually for new releases.
