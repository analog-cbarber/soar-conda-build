./soar/setup.sh
cp -r soar $PREFIX/soar
cp -r src/bin/* $PREFIX/bin

# Fix the path to the python executable in the _Python_sml_ClientInterface.so module
install_name_tool \
  -change /Library/Frameworks/Python.framework/Versions/3.12/Python \
    @loader_path/../../bin/python3.12 \
  $PREFIX/soar/bin/_Python_sml_ClientInterface.so

# Fix the path to the Tcl library in the libTcl_sml_ClientInterface.dylib module
install_name_tool \
  -change /opt/homebrew/opt/tcl-tk/lib/libtcl8.6.dylib \
    @loader_path/../../lib/libtcl8.6.dylib \
  $PREFIX/soar/bin/libTcl_sml_ClientInterface.dylib
install_name_tool \
  -change /opt/homebrew/opt/tcl-tk/lib/libtcl8.6.dylib \
    @loader_path/../../lib/libtcl8.6.dylib \
  $PREFIX/soar/bin/libtclsoarlib.dylib

# Add soar/bin directory to python
echo "../../../soar/bin" > $PREFIX/lib/python3.12/site-packages/soar.pth

# Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
# This will allow them to be run on environment activation.
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done
