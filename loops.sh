#!/bin/bash
for i in 1 2 3 4 5; do
    echo "Итерация: $i"
done

COUNT=1
while [ $COUNT -le 5 ]; do
    echo "Счетчик: $COUNT"
    ((COUNT++))
done