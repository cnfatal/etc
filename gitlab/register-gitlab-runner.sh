#!/usr/bin/env sh

GITLAB_HOST="http://git.ghostcloud.cn/"
PROJECT_REGISTRATION_TOKEN="iAJiAq4xzyuQToHQsmC2"

docker run \
--rm \
-v $(pwd)/gitlab-runner:/etc/gitlab-runner \
gitlab/gitlab-runner:alpine \
register \
--non-interactive \
--executor "docker" \
--docker-image alpine:latest \
--url ${GITLAB_HOST} \
--registration-token ${PROJECT_REGISTRATION_TOKEN} \
--description "docker-runner" \
--tag-list "docker,linux,alpine" \
--run-untagged="true" \
--locked="false" \
--access-level="not_protected"