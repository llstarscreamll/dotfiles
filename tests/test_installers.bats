#!/usr/bin/env bats

setup() {
    source ./setup.sh
}

@test "installers: shell.sh functions are available" {
    run type -t install_shell_utils
    [[ "$output" == "function" ]]
    
    run type -t link_config_files
    [[ "$output" == "function" ]]
}

@test "installers: dev.sh functions are available" {
    run type -t install_dev_tools
    [[ "$output" == "function" ]]
    
    run type -t install_mise
    [[ "$output" == "function" ]]
}

@test "installers: web.sh functions are available" {
    run type -t install_flatpaks
    [[ "$output" == "function" ]]
}

@test "installers: misc.sh functions are available" {
    run type -t install_fonts
    [[ "$output" == "function" ]]

    run type -t configure_udev_rules
    [[ "$output" == "function" ]]
}

@test "installers: ide.sh functions are available" {
    run type -t install_cursor
    [[ "$output" == "function" ]]
}
