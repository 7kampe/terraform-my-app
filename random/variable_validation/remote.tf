terraform {
  backend "remote" {
    organization = "test-kamil"
    workspaces {
      name = "variable_validation"
    }
  }
}