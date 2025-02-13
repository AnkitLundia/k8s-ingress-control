# USING TERRAFORM TO AUTOMATE DEPLOYMENT

This document helps you deploy three echo applications and distribute the traffic among them using an Ingress controller with Terraform.

### STEPS TO DEPLOY

1. Navigate to the `iac` folder of this repository.

2. Make sure there are no services running on ports 8081, 8082, and 8083. If there are any, please delete them before proceeding. If that is not possible, please modify the port numbers in the **deployment.json** file accordingly and proceed.

3. Run `terraform init` to initialize the workspace.

4. Run `terraform plan`, and you will be able to see all the resources being created.

5. Run `terraform apply`, and enter **"yes"** when prompted to approve the plan.

6. All the resources should be created and in an available state after the apply is complete. Verify this by running the command `kubectl get all`.

7. Run `kubectl get ingress` and verify the following:
   1. Class is set to **"nginx"**.
   2. Hosts is set to **"bluegreen.demo"**.
   3. Address is assigned to the address of the Minikube cluster (usually 192.168.49.2). You can get the cluster IP by running `minikube ip` and match it with the value in the address.

8. Since we are running this locally, we need to modify the hosts file so that requests to the hostname are redirected to the Minikube cluster IP.
   1. Navigate to the root folder `/`.
   2. Run `sudo vi /etc/hosts`. (This will work on macOS and Linux; for Windows, please look for an equivalent command to modify the hosts file.)
   3. Add the following at the end of the file: `<minikube_ip> assignment.demo`.

9. Now that everything is set up, we can proceed with testing.

### TESTING

1. We'll run some simple commands from a temporary pod to test.
   1. Run `kubectl run -it --rm --restart=Never test-pod --image=busybox -- /bin/sh`. This will take you to the command line of the pod.
   2. Create a file `vi test_response.sh`.
   3. Replace the ports for foo, bar and boom deployments in the "iac/traffic-test.sh" script.
      1. You can find the node ports by running the command `kubectl get services`.
   4. Copy the contents from "iac/traffic-test.sh" into the file created.
   5. Save the file.
   6. Run `chmod +x test_response.sh` to make the script executable.
   7. Run `./test_response.sh`.
   8. You will be able to see the count of responses received from both blue and green deployments and the count of failed requests.

2. In case of any failed requests, further debugging will be required.
   1. You can check the NGINX logs.
   2. Run `kubectl get pods -n ingress-nginx` to list the pods running for the Ingress controller.
   3. Look for the **controller** pod.
   4. Run `kubectl logs <controller_pod_name> -n ingress-nginx` to see the logs.
   5. Perform further debugging/fix according to the error seen.

3. You can also check the logs of the deployment by running `kubectl logs <deployment_name>` if required.

4. You have now deployed a simple echo app with Ingress rules in effect.