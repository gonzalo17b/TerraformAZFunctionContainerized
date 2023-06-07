# Azure Function Deployment with Docker Containers

## Project Objective:

The main objective of this project was to deploy an Azure Function using Docker containers. The Azure Function in this project is a simple and "dirty" code that listens to messages from a Service Bus through a GET trigger. Once a message is received, it redirects it to another Service Bus.

In other words, we have an Azure Function connected to a subnet. This Azure Function reads from one Service Bus, and when it receives a message, it sends it to the other Service Bus.

## Setup:

1.  Go to the `terraform/acr` folder. This folder, through Terraform `init/plan/apply`, will create an Azure Container Registry (ACR) to store the Docker image of the Azure Function named `audit`.
2.  Navigate to the folder where the Dockerfile is located and run the following commands:
    -   `az acr login --n <ACR_name>`: Login to your Azure Container Registry.
    -   `docker build . -t <ACR_name>.azurecr.io/audit:v1`: Build the Docker image for the Azure Function.
    -   `docker push <ACR_name>.azurecr.io/audit:v1`: Push the Docker image to the Azure Container Registry.
3.  Go to the `terraform/services` folder. Run Terraform `plan` and `apply` to configure all the required services.

Please make sure you have the necessary permissions, credentials, and configurations set up in your Azure environment before running the above commands.

## Contributing

Contributions are welcome! If you find any issues or want to enhance this project, feel free to submit a pull request.