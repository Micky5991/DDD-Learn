variable "TAG" {
  default = ""
}

variable "BRANCH" {
  default = ""
}

variable "PR" {
  default = ""
}

variable "REPOSITORY" {
  default = "ddd-learn"
}

variable "REGISTRY" {
  default = "docker.micky5991.dev"
}

function "get_tags" {
  params = [service]
  result = compact([
    # Main tag: always present
    "${REGISTRY}/${REPOSITORY}${service != "" ? "/${service}" : ""}:${
      TAG != "" ? TAG :
      PR != "" ? "pr-${PR}" :
      "preview-${BRANCH}"
    }",

    # Latest tag: only for release tags
    TAG != "" ? "${REGISTRY}/${REPOSITORY}${service != "" ? "/${service}" : ""}:latest" : "",

    # Edge tag: only for main branch builds (without tag)
    BRANCH == "main" && TAG == "" ? "${REGISTRY}/${REPOSITORY}${service != "" ? "/${service}" : ""}:edge" : ""
  ])
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
  tags = get_tags("web")
  output = [
    "type=registry"
  ]
}

