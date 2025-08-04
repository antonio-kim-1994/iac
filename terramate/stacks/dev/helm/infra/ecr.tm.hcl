generate_hcl "ecr.tf" {
  content {
    module "ecr" {
      source               = "../../../../modules/ecr"
      image_tag_mutability = "IMMUTABLE"
      scan_on_push         = true
      lifecycle_policy     = file("ecr_lifecycle_policy.json") # JSON 포맷의 라이프사이클 정책 파일 경로 (최근 3개)

      service_list = global.service_list
      service_env  = global.env
      service_name = global.project_name

      tags = global.tags
    }

    module "ecr-common" {
      source               = "../../../../modules/ecr"
      image_tag_mutability = "IMMUTABLE"
      scan_on_push         = true
      lifecycle_policy     = file("ecr_lifecycle_policy.json") # JSON 포맷의 라이프사이클 정책 파일 경로 (최근 3개)

      service_list = [
        {
          name : "devops-relay-server"
          namespace : "devops"
          gitUrl : ""
          dnsName : ""
          createDns : false
          createEcr : false
        }
      ]
      service_env  = "common"
      service_name = global.project_name
    }
  }
}