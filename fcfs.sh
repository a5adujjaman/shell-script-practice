#!/bin/bash

# Replace "12345678" with your actual student ID
STUDENT_ID="2125051065"

# Generate a unique hash using your student ID and the script name
SCRIPT_HASH=$(echo "$STUDENT_ID $(basename "$0")" | md5sum | awk '{print $1}')

# Print the hash at the top of the script (for identification)
echo "Script Hash: $SCRIPT_HASH"

echo "Enter number of processes:"
read n

declare -a processNames arrivalTimes burstTimes waitingTimes turnaroundTimes completionTimes

for ((i=0; i<n; i++)); do
    echo "Enter process name (e.g., P1, P2):"
    read processNames[$i]
    
    echo "Enter arrival time for ${processNames[$i]}:"
    read arrivalTimes[$i]
    
    echo "Enter burst time for ${processNames[$i]}:"
    read burstTimes[$i]
done

# Initialize waiting and turnaround times
waitingTimes[0]=0
completionTimes[0]=$((arrivalTimes[0] + burstTimes[0]))
turnaroundTimes[0]=$((completionTimes[0] - arrivalTimes[0]))

# Calculate waiting, turnaround, and completion times
for (( i=1; i<n; i++ )); do
    if (( arrivalTimes[i] > completionTimes[i-1] )); then
        completionTimes[$i]=$((arrivalTimes[i] + burstTimes[i]))  # CPU is idle
    else
        completionTimes[$i]=$((completionTimes[i-1] + burstTimes[i]))  # Continue after previous process
    fi
    
    turnaroundTimes[$i]=$((completionTimes[i] - arrivalTimes[i]))
    waitingTimes[$i]=$((turnaroundTimes[i] - burstTimes[i]))
done

# Print process details
echo -e "\nProcess\tArrival Time\tBurst Time\tCompletion Time\tTurnaround Time\tWaiting Time"
for ((i=0; i<n; i++)); do
    echo -e "${processNames[$i]}\t\t${arrivalTimes[$i]}\t\t${burstTimes[$i]}\t\t${completionTimes[$i]}\t\t${turnaroundTimes[$i]}\t\t${waitingTimes[$i]}"
done

# Calculate total waiting and turnaround times for averages
totalWT=0
totalTAT=0
for (( i=0; i<n; i++ )); do
    totalWT=$((totalWT + waitingTimes[i]))
    totalTAT=$((totalTAT + turnaroundTimes[i]))
done

avgWT=$(echo "scale=2; $totalWT / $n" | bc)
avgTAT=$(echo "scale=2; $totalTAT / $n" | bc)

echo -e "\nAverage Waiting Time: $avgWT"
echo -e "Average Turnaround Time: $avgTAT"
