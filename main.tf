module "criacao_s3" {
  source = "./s3"
}

module "criacao_vpc" {
  source = "./vpc"
}

module "criacao_role_lambda" {
  source = "./iam"
}

module "criacao_sg" {
  source = "./security_group"

  vpc_id = module.criacao_vpc.vpc_id

  depends_on = [
    module.criacao_vpc
  ]
}

module "criacao_rds" {
  source      = "./rds"

  subnet_list = module.criacao_vpc.subnet_id_list
  sg_id       = module.criacao_sg.sg_db_id

  depends_on = [
    module.criacao_sg
  ]
}

module "criacao_lambda_gp3" {
  source           = "./lambda"

  sg_ids           = [module.criacao_sg.sg_lambda_id]
  subnet_ids       = module.criacao_vpc.subnet_id_list
  iam_role_arn     = module.criacao_role_lambda.iam_role

  db_endpoint      = module.criacao_rds.rds_endpoint
  db_username      = module.criacao_rds.rds_username
  db_password      = module.criacao_rds.rds_password
  db_port          = module.criacao_rds.rds_port
  db_database_name = module.criacao_rds.rds_database_name

  depends_on = [
    module.criacao_rds
  ]
}

module "criacao_lambda_script" {
  source           = "./lambda_script_rds"

  sg_ids           = [module.criacao_sg.sg_lambda_id]
  subnet_ids       = module.criacao_vpc.subnet_id_list
  iam_role_arn     = module.criacao_role_lambda.iam_role

  db_endpoint      = module.criacao_rds.rds_endpoint
  db_username      = module.criacao_rds.rds_username
  db_password      = module.criacao_rds.rds_password
  db_port          = module.criacao_rds.rds_port
  db_database_name = module.criacao_rds.rds_database_name

  depends_on = [
    module.criacao_rds
  ]
}

module "criacao_lambda_s3_notification" {
  source      = "./lambda_s3_notification"

  lambda_arn  = module.criacao_lambda_gp3.lambda_arn
  lambda_name = module.criacao_lambda_gp3.lambda_name
  bucket_id   = module.criacao_s3.bucket_id
  bucket_arn  = module.criacao_s3.bucket_arn

  depends_on = [
    module.criacao_lambda_gp3
  ]
}