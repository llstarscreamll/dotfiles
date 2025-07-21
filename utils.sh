#!/usr/bin/env bash

# Function to print text in blue color
print() {
    local blue='\033[0;34m'
    local nc='\033[0m' # No Color
    echo -e "${blue}\n------------------------------------------------------------"
    echo -e "$1"
    echo -e "------------------------------------------------------------\n${nc}"
}