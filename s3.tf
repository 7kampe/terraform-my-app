# resource "aws_s3_bucket" "s3-bucket-from-terraform" {
#   bucket = "s3-bucket-from-terraform"
#   tags = {
#     Name    = "S3 Bucket from Terraform"
#     Purpose = "S3 Bucket from Terraform"
#   }
# }

# resource "aws_s3_bucket_acl" "my_new_bucket_acl" {
#   bucket = aws_s3_bucket.s3-bucket-from-terraform.id
#   acl    = "private"
# }