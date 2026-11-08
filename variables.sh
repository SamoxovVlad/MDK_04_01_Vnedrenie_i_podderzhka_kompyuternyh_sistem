#!/bin/bash
NAME="Иван"
AGE=25
SCRIPT_DIR=$(pwd)

echo "Имя: $NAME"
echo "Возраст: $AGE"
echo "Директория: $SCRIPT_DIR"
echo "Домашняя директория: $HOME"
echo "Текущая оболочка: $SHELL"

read -p "Введите ваше имя: " USERNAME
echo "Привет, $USERNAME!"
read -s -p "Введите пароль: " PASSWORD
echo
echo "Пароль принят"