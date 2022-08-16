#! /bin/bash

trust_directories() {
    for arg in $@; do
        git config --global --add safe.directory /workspaces/vitass/$arg
    done
}
trust_directories .devcontainer TTK4250Exercises handoutgen
git config --global user.email "you@example.com"
git config --global user.name "Your Name"