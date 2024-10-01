
#!/bin/bash

echo "give a number input: "

read number
factorial = 1
for(i=0; i<=number; i++)
	{
	factorial = $((factorial*1))
	}

echo "The the factorial is $factorial"
