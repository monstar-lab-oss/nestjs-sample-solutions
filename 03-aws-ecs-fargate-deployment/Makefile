ENV = $1
CD = [ -d terraform/envs/${ENV} ] && cd terraform/envs/${ENV}
OS = $$(uname)

include terraform/envs/${ENV}/.env
export $(shell sed 's/=.*//' terraform/envs/${ENV}/.env)

init:
	@${CD} && terraform init

validate:
	@${CD} && terraform validate

plan:
	@${CD} && terraform plan

apply:
	@${CD} && terraform apply

destroy:
	@${CD} && terraform destroy
