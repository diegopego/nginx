#!/bin/bash -Eeu

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${ROOT_DIR}/scripts/echo_versioner_env_vars.sh"
export $(echo_versioner_env_vars)

MERKELY_CHANGE=merkely/change:latest
MERKELY_OWNER=cyber-dojo
MERKELY_PIPELINE=nginx

# - - - - - - - - - - - - - - - - - - -
merkely_fingerprint()
{
  echo "docker://${CYBER_DOJO_NGINX_IMAGE}:${CYBER_DOJO_NGINX_TAG}"
}

# - - - - - - - - - - - - - - - - - - -
merkely_log_deployment()
{
  local -r environment="${1}"
  local -r hostname="${2}"

	docker run \
    --env MERKELY_COMMAND=log_deployment \
    --env MERKELY_OWNER=${MERKELY_OWNER} \
    --env MERKELY_PIPELINE=${MERKELY_PIPELINE} \
    --env MERKELY_FINGERPRINT=$(merkely_fingerprint) \
    --env MERKELY_DESCRIPTION="Deployed to ${environment} in circleci pipeline" \
    --env MERKELY_ENVIRONMENT="${environment}" \
    --env MERKELY_CI_BUILD_URL=${CIRCLE_BUILD_URL} \
    --env MERKELY_API_TOKEN=${MERKELY_API_TOKEN} \
    --env MERKELY_HOST="${hostname}" \
    --rm \
    --volume /var/run/docker.sock:/var/run/docker.sock \
      ${MERKELY_CHANGE}
}

docker pull ${CYBER_DOJO_NGINX_IMAGE}:${CYBER_DOJO_NGINX_TAG}