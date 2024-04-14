
# ELASTIC BEANSTALK DOCKER APPLICATION WITH TERRAFORM

This guide outlines the steps to deploy a simple Todo List application to AWS Elastic Beanstalk using Terraform and Docker.

## Configuration Files


*   **Dockerfile:** Defines the configuration for building the Docker image.
*   **Dockerrun.aws.json:** Specifies the Docker container configuration for Elastic Beanstalk.
*   **provider.tf:** Terraform configuration file for provider configuration.
*   **iam.tf:** Terraform configuration file containing iam roles and policy definitions.
*   **ecr.tf:** Terraform configuration file for containing elastic container registry to storing the docker images as well as automated resource for pushing docker image  to the ecr.
*   **main.tf:** Terraform configuration file for creating AWS resources(elastic beanstalk and other related resources).
*   **output.tf:** Terraform output file for defining the outputs of the deployment.
*   **/todo-list:** Directory containing the source code for the todo list application. origanlly pulled from https://github.com/bradtraversy/50projects50days/tree/master/todo-list


## Todos app Features
- Add new tasks
- Mark tasks as completed
- Delete tasks

## Prerequisites
Before deploying the application, ensure you have the following prerequisites installed:

*   Terraform
*   Docker
*   AWS CLI configured with appropriate credentials

## Deployement 

1.  **Clone the Repository:**
    
    ```bash
    git clone https://github.com/Dhruvnotfound/<repo_name>.git
    cd <repo_name>
    ```
2.  **updating dokcerrun.aws.json with your credentials**
Open the `Dockerrun.aws.json` file in your project directory and update the `<Name>` fields with your AWS account ID, region, repository name, and version. The format should be:

    ```json
    "Name": "<ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/<NAME>:<VERSION>"
    ```

3.  **Deploy Infrastructure with Terraform:**
    
    Initialize Terraform and apply the configuration to deploy the Todo List application on AWS Elastic Beanstalk.
    
    ```bash
    terraform init
    terraform apply --auto-approve
    ```
4. **Access the Application:**
    
    Once the deployment is complete, you can access the Todo List application in your browser using the outputed URL from the terminal .

## Clean Up (Optional)

If you want to tear down the infrastructure, you can destroy it using Terraform:
    
    ```bash
    terraform destroy --auto-approve
    ``` 
A S3 bucket will be created by the elastic beanstalk by the name "elasticbeanstalk-<your-region>-<your-account-id>"
which is not automatically deleted to prevent accidental deletion of the bucket as it contain important config for the elastic beanstalk to delete that refer to 
https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/AWSHowTo.S3.html

Also remove the docker images from your local system 
    
    ```bash
    docker images //to view the current running images
    docker rmi <image-id>
    ```


