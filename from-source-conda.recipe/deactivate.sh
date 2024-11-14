#!/bin/bash

function __path_remove(){
    local D=":${PATH}:";
    [ "${D/:$1:/:}" != "$D" ] && PATH="${D/:$1:/:}";
    PATH="${PATH/#:/}";
    export PATH="${PATH/%:/}";
}

__path_remove "$JAVA_HOME/bin"

export SOAR_HOME="$OLD_SOAR_HOME"
unset OLD_SOAR_HOME
