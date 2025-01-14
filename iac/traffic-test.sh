#!/bin/sh

# Define the Node IP and ports for the services
NODE_IP="192.168.49.2"
ENDPOINT="assignment.demo"
FOO_PORT=30851
BAR_PORT=31858
BOOM_PORT=32615

# Number of requests to send
REQUESTS=100

# Initialize counters
SUCCESS_FOO=0
SUCCESS_BAR=0
SUCCESS_BOOM=0
FAILURES_ENDPOINT=0

test_overall() {
    response=$(wget -qO- --server-response http://$ENDPOINT)
    if [[ "$response" == "\"I am foo\"" ]]; then
        SUCCESS_FOO=$(($SUCCESS_FOO + 1))
    elif [[ "$response" == "\"I am bar\"" ]]; then
        SUCCESS_BAR=$(($SUCCESS_BAR + 1))
    elif [[ "$response" == "\"I am boom\"" ]]; then
        SUCCESS_BOOM=$(($SUCCESS_BOOM + 1))
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
echo "Successful responses from foo: $SUCCESS_FOO"
echo "Successful responses from bar: $SUCCESS_BAR"
echo "Successful responses from boom: $SUCCESS_BOOM"
echo "Failed responses For Endpoint: $FAILURES_ENDPOINT"