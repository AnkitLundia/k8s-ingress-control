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
FAILURES_FOO=0
FAILURES_BAR=0
FAILURES_BOOM=0
FAILURES_ENDPOINT=0

# Function to test Deployment A
test_foo() {
    response=$(wget -q --spider --server-response http://$NODE_IP:$FOO_PORT 2>&1 | awk '/HTTP\// {print $2}')
    if [ "$response" -eq 200 ]; then
        SUCCESS_FOO=$(($SUCCESS_FOO + 1))
    else
        FAILURES_FOO=$(($FAILURES_FOO + 1))
    fi
}

# Function to test Deployment B
test_bar() {
    response=$(wget -q --spider --server-response http://$NODE_IP:$BAR_PORT 2>&1 | awk '/HTTP\// {print $2}')
    if [ "$response" -eq 200 ]; then
        SUCCESS_BAR=$(($SUCCESS_BAR + 1))
    else
        FAILURES_BAR=$(($FAILURES_BAR + 1))
    fi
}

test_boom() {
    response=$(wget -q --spider --server-response http://$NODE_IP:$BOOM_PORT 2>&1 | awk '/HTTP\// {print $2}')
    if [ "$response" -eq 200 ]; then
        SUCCESS_BOOM=$(($SUCCESS_BOOM + 1))
    else
        FAILURES_BOOM=$(($FAILURES_BOOM + 1))
    fi
}

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



# Send requests to Deployment A and B
i=1
while [ $i -le $REQUESTS ]; do
    test_overall  # 25% of requests to Deployment B  # 75% of requests to Deployment A
    i=$(($i + 1))
done

# Output the results
echo "Results:"
echo "Successful responses from foo: $SUCCESS_FOO"
echo "Successful responses from bar: $SUCCESS_BAR"
echo "Successful responses from boom: $SUCCESS_BOOM"
echo "Failed responses For foo: $FAILURES_FOO"
echo "Failed responses For Bar: $FAILURES_BAR"
echo "Failed responses For Boom: $FAILURES_BOOM"
echo "Failed responses For Endpoint: $FAILURES_ENDPOINT"