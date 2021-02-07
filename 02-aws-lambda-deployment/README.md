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

## Running the app in local

To run the server without Docker we need this pre-requisite:

- MySQL server running

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

## Deployment

```sh
# deploy to DEV environment
npm run deploy:dev
```

## External Links

<a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo.svg" width="150" alt="Nest Logo" /></a>

<a href="https://www.serverless.com/" target="blank"><img src="https://user-images.githubusercontent.com/2752551/30405068-a7733b34-989e-11e7-8f66-7badaf1373ed.png" width="150" alt="Nest Logo" /></a>
