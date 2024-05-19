variable access_key {
  description = "Ncloud Subaccount API AccessKey"
  default = "YOUR_ACCESS_KEY"
}

variable secret_key {
  description = "Ncloud Subaccount API SecretKey"
  default = "YOUR_SECRET_KEY"
}

variable site {
  description = "Ncloud site" # Public / gov / fin
  default = "fin"
}

variable region {
  description = "Ncloud region" # Ncloud API - Compute > Server > Common > getRegionList 에서 확인 가능
  default = "FKR"
}

variable zone {
  default = "KR-1" # KR-1 / KR-2
}