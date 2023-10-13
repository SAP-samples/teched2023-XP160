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

# Output of raw value (DO NOT DO THIS IN PRODUCTIVE SCENARIOS AS SENSTIVE DATA IS CONTAINED)
echo "DO NOT DO THIS IN PRODUCTIVE SCENARIOS AS SENSTIVE DATA IS CONTAINED"
terraform output -raw FUNCTION_URL