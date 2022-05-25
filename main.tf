module "elk_stack" {
    source = "./modules/elk_stack"
    tag = var.tag
}