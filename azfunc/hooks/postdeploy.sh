# execute a terraform apply command based on script in the current folder and store the output to an env variable
 
# Naviagt to the terraform folder
cd ./tfconfig

# Check variable
echo $FUNCTION_NAME; echo $RESOURCE_GROUP_NAME

# Initialize terraform
terraform init

# Apply terraform (data source only)
TF_VAR_function_app_name=$FUNCTION_NAME TF_VAR_resource_group_name=&RESOURCE_GROUP_NAME terraform apply