
# Remove previous test project
rm -rf test
rm -rf test-build-fc1cb9-Release

# Create the new test project
./pydroid test t.e
test/zip_libs

# Start qtcreator and open the created project
/home/aaron/necessitas/QtCreator/bin/necessitas test/test.pro