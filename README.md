# udacity_cloud-devops-engineer_coworking-space
The Coworking Space Service is a set of APIs that enables users to request one-time tokens and administrators to authorize access to a coworking space. This service follows a microservice pattern and the APIs are split into distinct services that can be deployed and managed independently of one another.

## Getting Started
1. Setup eks cluster
- Create EKS cluster & node group
- Update configuration to map with aws account

2. Configure database for the Service
- Create respective yaml file to apply for kubenetes (Using postgres)

3. Build the Analytics Application Locally
- Setup Flask python app & run locally

4. Deploy the Analytics Application
- Dockerized the app
- Set up Continuous Integration with CodeBuild
- Deploy the Application with Config Map, Secret, Deployment file

5. Setup CloudWatch Logging
- Use Logs feature in AWS CloudWatch

~ Authored by wendigo ~~