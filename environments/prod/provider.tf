provider "azurerm" {
  features {}
  
  # CI/CD 환경에서는 환경 변수 사용 (ARM_CLIENT_ID, ARM_CLIENT_SECRET 등)
  # 로컬 환경에서는 Azure CLI 인증 사용 (az login)
  use_cli = var.use_azure_cli
  
  # v5.0에서 제거될 예정이므로 resource_provider_registrations 사용 권장
  resource_provider_registrations = "none"
}