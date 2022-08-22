#! /bin/bash

trust_directories() {
    for arg in $@; do
        git config --global --add safe.directory /workspaces/vitass/$arg
    done
}
trust_directories .devcontainer TTK4250Exercises hwlib
git config --global user.email "emil.martens@gmail.com"
git config --global user.name "Emil Martens"