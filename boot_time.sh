#!/bin/bash

# ./boot_time.sh <tests>
# Example of how to run the script:
# ./boot_time.sh 10

NUMBER_OF_TESTS=${1:-10}

total=0

kraft_boot_time() {
    START=$(date +%s%N)

    ./run_unikraft_oci.sh > /dev/null 2>&1 &
    KRAFT_PID=$!

    while ! nc -z localhost 3000; do
        sleep 0.1
    done

    END=$(date +%s%N)
    RESULT=$(( (END - START) / 1000000 )) # In milliseconds

    echo "$RESULT"
    kill $KRAFT_PID 2>/dev/null
}

echo "Running $NUMBER_OF_TESTS tests..."

for (( i=1; i<=$NUMBER_OF_TESTS; i++ )); do
    time_ms=$(kraft_boot_time)
    echo "Test $i: $time_ms ms"
    total=$(( total + time_ms ))
    sleep 1.5
done

# bc for floating point support
average=$(echo "scale=2; $total / $NUMBER_OF_TESTS" | bc)
echo "Average boot time over $NUMBER_OF_TESTS tests: $average ms"