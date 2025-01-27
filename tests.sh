#!/bin/bash

# Define the files to compile and test
MODULE_FILES="task1.erl task1_test.erl"
TEST_MODULE="task1_test"

# Compile the modules
echo "Compiling erlang..."
for FILE in $MODULE_FILES; do
    erlc $FILE
    if [ $? -ne 0 ]; then
        echo "Compilation failed for $FILE."
        exit 1
    fi
done

# Run the tests
echo "Running EUnit tests..."
erl -noshell -eval "eunit:test($TEST_MODULE), halt()."

# Check if the tests passed
if [ $? -eq 0 ]; then
    echo "All tests passed successfully!"
else
    echo "Some tests failed. Check the test output above."
    exit 1
fi
