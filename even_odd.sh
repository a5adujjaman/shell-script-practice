#!/bin/bash

echo "Give a number: "

read a 
if ((a%2 ==0))
then
echo "even"
else
echo "odd"
fi

