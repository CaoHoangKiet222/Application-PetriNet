#!/bin/bash

function MySplit {
  local inputstr=$1
  local separator=$2
  if [[ -z $separator ]]; then
    separator="%s"
  fi
  local t=()
  for str in $(echo "$inputstr" | grep -oE "[^${separator}]+"); do
    t+=("$str")
  done
  echo "${t[@]}"
}

function GetPWD {
  local array_split=($(MySplit $(realpath --relative-to="$PWD" "$1") "/"))
  local pwd="./"
  for ((index=0; index<${#array_split[@]}; index++)); do
    value=${array_split[$index]}
    if ((index != ${#array_split[@]} - 1)); then
      pwd="$pwd$value"
    fi
    if ((index < ${#array_split[@]} - 2)); then
      pwd="$pwd/"
    fi
  done
  echo "$pwd"
}

function GetClassJavac {
  local array_split=($(MySplit $(realpath --relative-to="$PWD" "$1") "/"))
  echo $(echo "${array_split[-1]}" | sed 's/\.[^.]*$//')
}

function CompileAndRunWithPackageFloat() {
  local PWD=$(GetPWD "$1")
  local class_javac=$(GetClassJavac "$1")
  package=$(grep "package" "$1" | awk '{print $2}' | sed 's/;//')
  javac -d "../bin" "$PWD"/*.java && java -cp "../bin" "$package.$class_javac"
}

CompileAndRunWithPackageFloat "$1"
