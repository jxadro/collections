#!/bin/bash

# setup environment
. $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/env.sh

if [ $# -gt 0 ]
then
    # ignore the old basedir argument
    dir=$1
    if [ -d $dir ] && [ -f $dir/RELEASE.md ]
    then
        shift
    fi
fi

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 1"
# Fetch previously released stacks
. $script_dir/prefetch.sh

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 2"
 
# Allow multiple stacks to be selected
if [ $# -gt 0 ]
then
  export STACKS_LIST="$@"
  echo "STACKS_LIST=$STACKS_LIST"

  for stack_name in $STACKS_LIST
  do
    if [ "${stack_name: -1}" == "/" ]
    then
      stack_name=${stack_name%?}
    fi
     
    stack_no_slash="$stack_no_slash $stack_name"
  done

  STACKS_LIST=$stack_no_slash
fi

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 3"

if [ -z "$STACKS_LIST" ]
then
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 4"
  . $script_dir/list.sh
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 5"
fi

. $script_dir/lint.sh
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 6"
. $script_dir/package.sh
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 7"
if [ -z $SKIP_TESTS ]; then
    . $script_dir/test.sh
else
    echo "Not running tests"
fi

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 8"
