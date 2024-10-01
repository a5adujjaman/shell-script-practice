#!/bin/bash

function calculate_times() {
    local n=$1

    for (( i=0; i<$n; i++ ))
    do
        if (( i == 0 )); then
            # First process
            CT[$i]=${AT[$i]}+${BT[$i]}
        else
            if (( ${AT[$i]} > ${CT[$((i-1))]} )); then
                # If the process arrives after the last one finishes, CPU will be idle
                CT[$i]=$(( ${AT[$i]} + ${BT[$i]} ))
            else
                # Otherwise, process will start immediately after the last one finishes
                CT[$i]=$(( ${CT[$((i-1))]} + ${BT[$i]} ))
            fi
        fi

        TAT[$i]=$(( ${CT[$i]} - ${AT[$i]} ))
        WT[$i]=$(( ${TAT[$i]} - ${BT[$i]} ))

        totalWT=$((totalWT + ${WT[$i]}))
        totalTAT=$((totalTAT + ${TAT[$i]}))
    done
}

# Function to display the results
function display_results() {
    local n=$1

    echo -e "\nProcess\tArrival Time\tBurst Time\tCompletion Time\tTurnaround Time\tWaiting Time"
    for (( i=0; i<$n; i++ ))
    do
        echo -e "${PN[$i]}\t\t${AT[$i]}\t\t${BT[$i]}\t\t${CT[$i]}\t\t${TAT[$i]}\t\t${WT[$i]}"
    done

    avgWT=$(echo "scale=2; $totalWT / $n" | bc -l)
    avgTAT=$(echo "scale=2; $totalTAT / $n" | bc -l)

    echo -e "\nAverage Waiting Time: $avgWT"
    echo -e "Average Turnaround Time: $avgTAT"
}

# Main script

# Get the number of processes
read -p "Enter the number of processes: " n

declare -a PN AT BT CT TAT WT
totalWT=0
totalTAT=0

# Input process details
for (( i=0; i<$n; i++ ))
do
    read -p "Enter Process Name : " PN[$i]
    read -p "Enter Arrival Time for ${PN[$i]}: " AT[$i]
    read -p "Enter Burst Time for ${PN[$i]}: " BT[$i]
done

# Sort processes by arrival time (if needed)
for (( i=0; i<$n-1; i++ ))
do
    for (( j=0; j<$n-i-1; j++ ))
    do
        if (( ${AT[$j]} > ${AT[$((j+1))]} )); then
            # Swap process name
            temp=${PN[$j]}
            PN[$j]=${PN[$((j+1))]}
            PN[$((j+1))]=$temp

            # Swap arrival time
            temp=${AT[$j]}
            AT[$j]=${AT[$((j+1))]}
            AT[$((j+1))]=$temp

            # Swap burst time
            temp=${BT[$j]}
            BT[$j]=${BT[$((j+1))]}
            BT[$((j+1))]=$temp
        fi
    done
done

# Calculate waiting time, turnaround time, and completion time
calculate_times $n

# Display the results
display_results $n
