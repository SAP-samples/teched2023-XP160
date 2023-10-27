output "FUNCTION_URL" {
  value = "${var.function_app_url}api/${var.function_name}"
  description = "Function URL"
}
