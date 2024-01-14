include {
  path = find_in_parent_folders()
}
terraform {
    source = "../../../../modules/app_services"
}
dependency "east_rg" {
    config_path = "../east_rg"
    mock_outputs = {
      rg_name  = "east_rg_preprod_mock"
      location = "East US"
    }
}

inputs = {
  rg_name               = dependency.east_rg.outputs.rg_name
  location              = dependency.east_rg.outputs.location
  app_service_plan_name = "EastServicePlan-preprod"
  app_service_name      = "EastWebApp-preprod"
  repo_url              = "https://github.com/Selmouni-Abdelilah/WebApplication_East.git"
  branch                = "master"
}

