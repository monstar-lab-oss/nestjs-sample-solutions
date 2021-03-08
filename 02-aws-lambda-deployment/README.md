## NestJS Starter-Kit - AWS Lambda Deployment

## NOTE :

This project was cloned from the [nestjs-starter-rest-api](https://github.com/monstar-lab-oss/nestjs-starter-rest-api) repository.

Please refer to the project's starter-kit's README file to understand more about the project's business logic, etc.

This README that you are viewing now talks more about how to deploy the project on `AWS Lambda`.

### PoC Contents

- [nestjs-starter-rest-api](https://github.com/monstar-lab-oss/nestjs-starter-rest-api) - NestJS Starter-Kit for REST API.
- [Serverless Framework](https://github.com/serverless/serverless) - Build applications with serverless architectures using AWS Lambda.

## Installation

```bash
# Project Dependencies:
$ npm install

# Serverless Framework:
npm install -g serverless
```

## Running the app

We need the various required environment variables to exist in order to run the app.

Create a `.env` file from the template `.env.template` file. For more details, please refer to the starter-kit's README file.

To run the app we need this pre-requisite:

- MySQL server running

## Running the app in local


Commands:

```bash
# development
$ npm run start

# watch mode
$ npm run start:dev

# production mode
$ npm run start:prod
```

## Running the app in serverless offline mode

```bash
$ npm run sls-offline
```

<<<<<<< HEAD
## Deployment via serverless

We need the various required environment variables to exist in order to run the app. 

We currently hard-code them in the `serverless.yml` file. Our recommended way is to use `AWS SSM - Parameter Store` and point to the SSM variable path in the `serverless.yml` file.

=======
## Deployment via CloudFormation
>>>>>>> e2c7c11... feat: update readme with lambda container image deployment info

```sh
# deploy to DEV environment
npm run deploy:dev
```

## Alternative Deployment via Lambda Container Image

Usually when we use the serverless deploy command, the framework runs (serverless package)[https://www.serverless.com/framework/docs/providers/aws/guide/packaging/] in the background first, and then (deploys)[https://www.serverless.com/framework/docs/providers/aws/cli-reference/deploy/] the generated package(Lamda packages are zip files) via CloudFormation.

But as of Dec 2020, AWS Lambda allows us to package it with a Docker container image that can be up to 10 GB in size, instead of traditional zip files. That means we can have a Dockerfile with all the dependencies, push it to ECR, and just point Lambda to the AWS ECR image.

You can avail docker support with the help of serverless framework also instead of the manual process. Read (here)[https://www.serverless.com/blog/container-support-for-lambda] for more detailed steps where you start off by changing in the serverless.yml file.

## External Link

<a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo.svg" width="150" alt="Nest Logo" /></a>

<a href="https://www.serverless.com/" target="blank"><img src="https://user-images.githubusercontent.com/2752551/30405068-a7733b34-989e-11e7-8f66-7badaf1373ed.png" width="150" alt="Nest Logo" /></a>
