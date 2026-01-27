#!/usr/bin/env bats

setup() {
    # Source the utils file from the parent directory
    # We need to be careful about paths. 
    # Provided we run bats from the root dir: import "./utils.sh"
    # But often tests are run from root.
    source "./utils.sh"
}

@test "utils.sh: print function succeeds" {
    run print "Test Message"
    [ "$status" -eq 0 ]
}

@test "utils.sh: print function contains message" {
    run print "Test Message"
    [[ "$output" =~ "Test Message" ]]
}

@test "utils.sh: print function has separators" {
    run print "Test Message"
    [[ "$output" =~ "------------------------------------------------------------" ]]
}
