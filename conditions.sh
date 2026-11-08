#!/bin/bash
read -p "Введите число: " NUMBER

if [ $NUMBER -gt 10 ]; then
    echo "Число больше 10"
elif [ $NUMBER -eq 10 ]; then
    echo "Число равно 10"
else
    echo "Число меньше 10"
fi