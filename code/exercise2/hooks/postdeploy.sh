# Navigate to the terraform folder
cd ./hooks/tfconfig

# Initialize terraform
echo "Initializing Terraform"
terraform init

# Export the Terraform variables via the env variables
export TF_VAR_resource_group_name=$RESOURCE_GROUP_NAME
export TF_VAR_function_name=$FUNCTION_NAME
export TF_VAR_function_app_url=$AZFUNC_APP_URL

# Apply terraform (data source only)
echo "Constructing Azure Function URL"
terraform apply -auto-approve

echo "The URL of the Azure Function endpoint"
terraform output -raw FUNCTION_URL