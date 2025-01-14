# INFRA DEVELOPER ASSIGNMENT

As specified in the problem statement, there are two main objectives:

1. Implement a blue-green deployment scenario as specified. Please find the documentation at [blue-green-doc](blue-green/README.md).

2. Implement a multi-service deployment and automate it via Terraform. The service deployments will be similar to the first objective. Please find the documentation at [terraform-deployment-doc](iac/README.md).

Documentation for both objectives is present in their respective folders. Before proceeding to the respective docs, please read through the following prerequisites.

### PRE-REQUISITES

1. Install Minikube by following steps 1 and 2 on the page [minikube start](https://minikube.sigs.k8s.io/docs/start/).

2. Install kubectl based on your OS from [kubectl-install](https://kubernetes.io/docs/tasks/tools/).

3. Start Minikube by running `minikube start`.

4. Enable the NGINX Ingress Controller by running `minikube addons enable ingress` from your command line. Minikube supports the NGINX Ingress Controller by default.

5. Ensure that the latest version of Terraform is installed. Follow the instructions at [terraform installation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).# k8s-ingress-control
