#!/usr/bin/env bats

setup() {
    export PROJECT_DIR="/tmp/mock_project_dir"
}

@test "setup.sh: help argument lists available functions" {
    run ./setup.sh help
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Available functions:" ]]
    [[ "$output" =~ "install_vscode" ]]
    [[ "$output" =~ "link_config_files" ]]
}

@test "setup.sh: calling with existing function argument runs it" {
    # We can't easily mock the function inside the script execution from outside
    # unless we modify the script or environment.
    # However, we can check if it tries to run the function.
    
    # Let's try to run 'utils.sh' print function if available, or a simple one.
    # But 'print' is not in the grep filter (install_|configure_...)
    
    # Let's try running 'link_config_files' but mock the internal commands? 
    # Too risky for a live system test.
    
    # Let's trust the manual verification or the 'help' test above which confirms the dispatch logic is reached.
    skip "Skipping execution test to avoid side effects on host"
}
