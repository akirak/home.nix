# Name of the created container
NAME=akirak/home.nix:latest

# Run tests in a Docker container
( docker build -t $NAME . && docker run --rm $NAME make -f test/test.mk all ) \
    2> .errors.txt

# Exit if there was an error
if [ $? -gt 0 ]; then
    echo "An error occurred during testing." >&2
    exit 1
fi

if [ ! -f .errors.txt ]; then
    exit 0
fi

# Clean up the error file if it is empty
if [ $(stat -c '%s' .errors.txt) = "0" ]; then
    rm .errors.txt
fi
