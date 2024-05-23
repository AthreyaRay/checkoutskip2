terraform {
  required_providers {
    buildkite = {
      source  = "buildkite/buildkite"
      version = "~> 0.1"  # You can change this to the latest version available
    }
  }
}

provider "buildkite" {
  # Configuration options, if needed
  organization = "personal-use-4"
  api_token = "bkua_c342bc1e8133bdbabadbe9ef3ebeb71cb6fd884f"
}

resource "buildkite_pipeline" "example_pipeline" {
  name       = "Example Pipeline"
  repository = "https://github.com/AthreyaRay/checkoutskip2.git"
  cluster_id= "Q2x1c3Rlci0tLWRlNDc4NjE0LTA4OWMtNDExOC1hZTM1LWUzYzkyMzMxMzM5Mw=="
  steps = jsonencode([
    {
      type = "script"
      name = "Upload Pipeline"
      command = "buildkite-agent pipeline upload pipeline3.yml"
    }
  ])
}  

resource "random_pet" "my-pet"{
    prefix = "Mrs"
    separator = "."
    length = "1"

}