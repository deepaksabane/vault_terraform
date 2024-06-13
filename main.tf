provider "aws" {
    region = "ap-south-1"
  
}

provider "vault" {
  address = "http://18.60.232.119:8200"
  skip_child_token = true

  auth_login {
    path = "auth/terraform/login"

    parameters = {
      role_id = "4f6055a9-0496-8fbd-393d-842f89a00786"
      secret_id = "04d5a091-1232-ee57-18e3-fcb85ebd3663"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv" // change it according to your mount
  name  = "test-secret" // change it according to your secret
}

resource "aws_instance" "my_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  tags = {
    Name = "test"
    Secret = data.vault_kv_secret_v2.example.data["foo"]
  }
}
