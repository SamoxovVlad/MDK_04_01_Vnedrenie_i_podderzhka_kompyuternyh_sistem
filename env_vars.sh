#!/bin/bash
export MY_VAR="hello_kali"
echo $MY_VAR
echo "--- Переменные локали: ---"
printenv | grep ^PATH