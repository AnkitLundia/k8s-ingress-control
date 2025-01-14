#!/bin/sh

# Define the Node IP and ports for the services
NODE_IP="192.168.49.2"
ENDPOINT="bluegreen.demo"
DEPLOYMENT_A_PORT=30855
DEPLOYMENT_B_PORT=31614

# Number of requests to send
REQUESTS=100

# Initialize counters
SUCCESS_A=0
SUCCESS_B=0
FAILURES_A=0
FAILURES_B=0

# Function to test Deployment A
test_deployment_a() {
    response=$(wget -q --spider --server-response http://$NODE_IP:$DEPLOYMENT_A_PORT 2>&1 | awk '/HTTP\// {print $2}')
    if [ "$response" -eq 200 ]; then
        SUCCESS_A=$(($SUCCESS_A + 1))
    else
        FAILURES_A=$(($FAILURES_A + 1))
    fi
}

# Function to test Deployment B
test_deployment_b() {
    response=$(wget -q --spider --server-response http://$NODE_IP:$DEPLOYMENT_B_PORT 2>&1 | awk '/HTTP\// {print $2}')
    if [ "$response" -eq 200 ]; then
        SUCCESS_B=$(($SUCCESS_B + 1))
    else
        FAILURES_B=$(($FAILURES_B + 1))
    fi
}

test_overall() {
    response=$(wget -qO- --server-response http://$ENDPOINT)
    if [[ "$response" == "I am blue" ]]; then
        SUCCESS_A=$(($SUCCESS_A + 1))
    elif [[ "$response" == "I am green" ]]; then
        SUCCESS_B=$(($SUCCESS_B + 1))
    else
        FAILURES_B=$(($FAILURES_B + 1))
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
echo "Successful responses from Deployment A: $SUCCESS_A"
echo "Successful responses from Deployment B: $SUCCESS_B"
echo "Failed responses For A: $FAILURES_A"
echo "Failed responses For B: $FAILURES_B"