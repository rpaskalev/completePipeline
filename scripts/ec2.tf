
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-04d29b6f966df1537"
  instance_type = "t2.micro"
user_data = file("codedeployagent.sh")
key_name        = rady_key
  tags = {
    Name = "SampleApp"
  }
}