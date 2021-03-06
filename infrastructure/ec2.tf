
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "rady-bucket-2"
    key    = "myec2/terraform-web-app"
    region = "us-east-1"
  }
}
resource "aws_instance" "web" {
  ami                  = "ami-04d29b6f966df1537"
  instance_type        = "t2.micro"
  user_data            = file("codedeployagent.sh")
  key_name             = "rady_key"
  iam_instance_profile = aws_iam_instance_profile.codebuild_profile.id

  tags = {
    Name = "SampleApp"
  }
}

resource "aws_iam_instance_profile" "codebuild_profile" {
  name = "codededeploy"
  role = aws_iam_role.deploy_role.name
}


resource "aws_iam_role" "deploy_role" {
  name = "test_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

/*
resource "aws_iam_policy" "codedeploy-policy" {
  name = "codedeploy"
  path = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:ListBucket",
                "s3:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}
*/

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.deploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}
