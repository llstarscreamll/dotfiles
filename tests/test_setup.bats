#!/usr/bin/env bats

@test "setup.sh: defines main function" {
    source ./setup.sh
    run type -t main
    [[ "$output" == "function" ]]
}

@test "setup.sh: update_system calls expected commands" {
    run bash -c "
        source ./setup.sh
        print() { echo \"MOCK_PRINT: \$*\"; }
        flatpak() { echo \"MOCK_FLATPAK: \$*\"; }
        dnf() { echo \"MOCK_DNF: \$*\"; }
        sudo() { echo \"MOCK_SUDO: \$*\"; }
        update_system
    "
    
    [ "$status" -eq 0 ]
    [[ "$output" =~ "MOCK_PRINT: Update system packages" ]]
    [[ "$output" =~ "MOCK_FLATPAK: update -y" ]]
    [[ "$output" =~ "MOCK_DNF: check-update" ]]
    [[ "$output" =~ "MOCK_SUDO: dnf update -y" ]]
}

@test "setup.sh: install_vscode checks for code command" {
     run bash -c "
        source ./setup.sh
        print() { echo \"MOCK_PRINT: \$*\"; }
        command() { return 0; } # Command exists
        sudo() { echo \"MOCK_SUDO: \$*\"; }
        install_vscode
    "
    [ "$status" -eq 0 ]
    [[ ! "$output" =~ "MOCK_PRINT: Install VSCode" ]]
}

@test "setup.sh: install_vscode installs if missing" {
     run bash -c "
        source ./setup.sh
        print() { echo \"MOCK_PRINT: \$*\"; }
        command() { return 1; } # Command missing
        sudo() { echo \"MOCK_SUDO: \$*\"; }
        dnf() { echo \"MOCK_DNF: \$*\"; }
        rpm() { echo \"MOCK_RPM: \$*\"; }
        tee() { cat; }
        install_vscode
    "
    [ "$status" -eq 0 ]
    [[ "$output" =~ "MOCK_PRINT: Install VSCode" ]]
    [[ "$output" =~ "MOCK_SUDO: dnf install code -y" ]]
}
