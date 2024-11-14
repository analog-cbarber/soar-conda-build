#!/bin/bash

# Add jvm/bin to path
export PATH="$JAVA_HOME/bin:$PATH"

# Set SOAR_HOME to soar bin directory
export OLD_SOAR_HOME="$SOAR_HOME"
export SOAR_HOME="$CONDA_PREFIX/soar/bin"
