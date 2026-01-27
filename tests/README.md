# Test Suite for Dotfiles

This directory contains tests for the dotfiles setup scripts.
The tests use [bats-core](https://github.com/bats-core/bats-core).

## Running Tests

To run all tests:
```bash
bats tests/
```

To run a specific test file:
```bash
bats tests/test_setup.bats
```

## Structure

- `test_utils.bats`: Tests for helper functions in `utils.sh`.
- `test_setup.bats`: Tests for installation logic in `setup.sh`. Mocks system commands to prevent actual changes during testing.
