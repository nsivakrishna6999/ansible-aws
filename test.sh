#!/bin/bash
#

function testcommand {
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo -e "\nThe command was:\n$@\nand it exited with error: $status\n" >&2
    else
        echo -e "\nThe command was:\n$@\nand it exited without error: $status\n" >&2
    fi
    return $status
}

echo -e "\n\n\n" >&2
echo -e "#######################" >&2
echo -e "# TESTING ansible-aws #" >&2
echo -e "#######################" >&2
echo -e "\n" >&2

echo -e "# First: create/process/delete in one run" >&2
echo -e "#########################################" >&2
echo -e "\n" >&2
testcommand ansible-playbook -i hosts bootstrap.yml

echo -e "# Second: create alone" >&2
echo -e "######################" >&2
echo -e "\n" >&2
testcommand ansible-playbook -i hosts --tags "create" bootstrap.yml


echo -e "\n" >&2
echo -e "# Third: delete alone" >&2
echo -e "#####################" >&2
echo -e "\n" >&2
testcommand cat /tmp/instances.yaml|sed 's/^[ \t]*- instances:/        - instances:/' > delete.yaml
testcommand ansible-playbook -i hosts --tags "delete" --extra-vars "@delete.yaml" bootstrap.yml

