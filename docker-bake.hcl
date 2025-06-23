variable "VERSION" {
  default = "dev"
}

variable "REPOSITORY" {
  default = "docker.micky5991.dev/ddd-learn"
}

group "default" {
  targets = ["webapp"]
}

group "release" {
  targets = ["webapp-release"]
}

target "webapp" {
  dockerfile = "./Library/Dockerfile"
  output = [
    "type=cacheonly"
  ]
}

target "webapp-release" {
  inherits = ["webapp"]
  tags = [
    "${REPOSITORY}/webapp:${VERSION}"
  ]
  output = [
    "type=registry"
  ]
}

