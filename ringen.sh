#!/bin/bash


env 'Z3=/opt/homebrew/bin/z3' ringen solve --solver z3 --path $1
# echo $1