resource "aws_s3_bucket" "bucket_gp3" {
  bucket = var.nome_bucket
  force_destroy = true

  tags = {
    Grupo = "de-op-009-dtech-gp3"
  }
}