provider "azurerm" {
  features {}
}

# user as referance https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app

# Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "WorkExperienceAuto"
  location = "UK South"
}

# Create the app service plan
resource "azurerm_service_plan" "appserviceplan" { 
    name = "FlaskWebApp2"
    resource_group_location = azurerm_resource_group.location
    resource_gresource_group_name = azurerm_resource_group.name
    os_type = "Linux"
    sku_name = "B1"
  }

# Create the app service
resource "azurem_linux_web_app" "appservice" { 
    name = "Bookings"
    resource_group_name = azurerm_resource_group.example.name
    location            = azurerm_service_plan.example.location
    service_plan_id     = azurerm_service_plan.example.id
    https_only = false
    site_config = {application_stack = {python_version = 3.11}
                    app_command_line  = "flask --app app --debug run --port=8000 --host=0.0.0.0 && gunicorn --bind=0.0.0.0 --timeout 600 app:app"
                    ftps_state = FtpsOnly
                    always_on = false
                    http2_enabled = false
                    minimum_tls_version = 1.2
                    remote_debugging_enabled = false

                    }
    app_settings = {
                    "AZURE_MYSQL_HOST":"Flaskwebapp2-server.mysql.database.azure.com"
                    "AZURE_MYSQL_NAME":"flaskwebapp2db"
                    "AZURE_MYSQL_PASSWORD":"J3EG03B13AD3MV57$"
                    "AZURE_MYSQL_USER": "isxsdzfobl"
                    "SCM_DO_BUILD_DURING_DEPLOYMENT": true

                    }
  }

resource "azurerm_resource_group" "mysql-rg" {
    name = "mysql-rg"
    location = "UK South"
}
resource "azurem_mysql_server" "mysql-server" {
    name = "flaskwebapp2-server"
    resource_group_name = azurerm_resource_group.mysql-rg.name
    location = azurerm_resource_group.mysql-rg.location
    administrator_login = var.admin_login
    administrator_login_password = var.admin_password

    sku_name = var.mysql-sku-name
    version = var.mysql-version

    storage_mb = var.mysql-storage
    auto_grow_enabled = true

    backup_retention_days = 7
    geo_redundant_backup_enabled = false

    public_network_access_enabled = true
    ssl_enforcement_enabled = true
    ssl_minimum_tls_version_enforced = "TLS1_2"
}

resource "azurem_mysql_database" "mysql-db" {
  name = "flaskwebapp2db"
  resource_group_name = azurerm_resource_group.mysql-rg.name
  server_name = azurem_mysql_server.mysql-server.name
  charset = "utf8"
  collation = "utf8_unicode_ci"
}