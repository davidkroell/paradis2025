#!/bin/bash

# Check if the first parameter is provided
if [ -z "$1" ]; then
  echo "Error: Parameter task file is missing"
  echo "Usage: $0 <task_file>"
  exit 1        
fi

# Define the files to compile and test
MODULE_FILES="*.erl"
TEST_MODULE="$1_test"

# Compile the modules
echo "Compiling erlang..."
for FILE in $MODULE_FILES; do
    erlc $FILE > /dev/null 2>&1
    echo "$FILE"
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
