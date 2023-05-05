terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "hashi-demos-apj"
    workspaces {
      name = "test-ws"
    }
  }
}