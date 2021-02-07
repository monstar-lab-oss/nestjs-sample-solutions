## NestJS Starter-Kit - AWS Lambda Deployment

## NOTE : 

This project was cloned from the [nestjs-starter-rest-api](https://github.com/monstar-lab-oss/nestjs-starter-rest-api) repository.

Please refer to the project's original README file to understand more about the project's business logic, etc.

This README that you are viewing now talks more about how to deploy the project on `AWS Lambda`.

### PoC Contents

- [nestjs-starter-rest-api](https://github.com/monstar-lab-oss/nestjs-starter-rest-api) - NestJS Starter-Kit for REST API.
- [Serverless Framework](https://github.com/serverless/serverless) - Build applications with serverless architectures using AWS Lambda.

## Installation

```bash
$ npm install
```

Create a `.env` file from the template `.env.template` file.

Generate public and private key pair for jwt authentication:

```bash
$ ssh-keygen -t rsa -b 2048 -m PEM -f jwtRS256.key
# Don't add passphrase
$ openssl rsa -in jwtRS256.key -pubout -outform PEM -out jwtRS256.key.pub
```

You may save these key files in `./local` directory as it is ignored in git.

Encode keys to base64:

```bash
$ base64 -i local/jwtRS256.key

$ base64 -i local/jwtRS256.key.pub
```

Must enter the base64 of the key files in `.env`:

```bash
JWT_PUBLIC_KEY_BASE64=BASE64_OF_JWT_PUBLIC_KEY
JWT_PRIVATE_KEY_BASE64=BASE64_OF_JWT_PRIVATE_KEY
```

## Running the app

We can run the project with or without docker.

### Local

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

### Docker

```bash
# build image
$ docker build -t my-app .

# run container from image
$ docker run -p 3000:3000 --volume 'pwd':/usr/src/app --network --env-file .env my-app

# run using docker compose
$ docker-compose up
```

Learn more about Docker conventions [here](https://github.com/monstar-lab-group/nodejs-backend/blob/master/architecture/docker-ready.md). (WIP - Currently this is an internal org link.)





## External Links

<a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo.svg" width="150" alt="Nest Logo" /></a>

