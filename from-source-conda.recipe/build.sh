pushd soar
python scons/scons.py --scu --opt --verbose --tcl=$PREFIX --tcl-suffix="" all performance_tests sml_tcl
popd

#./soar/setup.sh
mkdir -p $PREFIX/soar
cp -r soar/out $PREFIX/soar/bin
cp -r src/bin/soar $PREFIX/bin
cp -r src/bin/SoarJavaDebugger $PREFIX/bin

# Add soar/bin directory to python
SITE_PACKAGES=$($PYTHON -c "import site; print(site.getsitepackages()[0])")
echo "../../../soar/bin" > $SITE_PACKAGES/soar.pth

# Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
# This will allow them to be run on environment activation.
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done
