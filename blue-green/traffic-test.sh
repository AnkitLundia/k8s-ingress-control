#!/bin/sh

# Define the Node IP and ports for the services
NODE_IP="192.168.49.2"
ENDPOINT="bluegreen.demo"
BLUE_PORT=30855
GREENT_PORT=31614

# Number of requests to send
REQUESTS=100

# Initialize counters
SUCCESS_BLUE=0
SUCCESS_GREEN=0
FAILURES_ENDPOINT=0


test_overall() {
    response=$(wget -qO- --server-response http://$ENDPOINT)
    if [[ "$response" == "I am blue" ]]; then
        SUCCESS_BLUE=$(($SUCCESS_BLUE + 1))
    elif [[ "$response" == "I am green" ]]; then
        SUCCESS_GREEN=$(($SUCCESS_GREEN + 1))
    else
        FAILURES_ENDPOINT=$(($FAILURES_ENDPOINT + 1))
    fi
}



# Send requests to the host
i=1
while [ $i -le $REQUESTS ]; do
    test_overall 
    i=$(($i + 1))
done

# Output the results
echo "Results:"
echo "Successful responses from BLUE: $SUCCESS_BLUE"
echo "Successful responses from GREEN: $SUCCESS_GREEN"
echo "Failed responses for endpoint: $FAILURES_ENDPOINT"