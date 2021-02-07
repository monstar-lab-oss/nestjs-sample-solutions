# AWS ECS Fargate Deployment

Infrastructure automation for ML NestJS Starter Kit using [Terraform](https://www.terraform.io/).

## Output

TBD

## Dependency

- Make
- [Terraform](https://www.terraform.io)
- [AWS CLI](https://aws.amazon.com/cli)

## Setup

### Environment

_terraform/envs_ folder contains the environments.
_terraform/modules_ folder contains the modules.

Create an _.env_ file in the _terraform/envs/{env}_ folder.

```bash
TF_VAR_db_username=dbuser
TF_VAR_db_password=foobarbaz
```

All required variables can be found in _terraform/envs/{env}/variables.tf_ file.

[The _TF_VAR_ prefix must be included for terraform variables](https://www.terraform.io/docs/commands/environment-variables.html#tf_var_name).

Setup aws cli credentials in local machine in the _~/.aws_ folder.
The profile must also match the one in _terraform/envs/{env}/backend.tf_ file, e.g., `ml-nestjs-starter`.

### Remote State

S3 is used for storing state remotely, and dynamodb for state lock. These two resources have to be created manually (once).

S3 bucket name: `ml-nestjs-starter-tfstate`
Dynamodb table: `tf-state-lock` (with string `LockID` as partition key)

These can also be changed but the `backend.tf` file has to also be updated.

### Misc

For AWS CodeBuild to be able to connect to github, there has to be an oauth connection made. Go to aws code build via aws console, create a build project and just connect github to it. No need to save the project.

## Commands

```bash
# init
$ make init ENV={env}
# e.g.: $ make init ENV=dev

# plan
$ make plan ENV={env}

# apply
$ make apply ENV={env}

# destroy
$ make destroy ENV={env}
```

## References

- <https://www.terraform.io/docs>
