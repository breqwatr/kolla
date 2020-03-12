#!/bin/bash

if [[ "$AWS_ACCOUNT_ID" == "" ]]; then
  echo "ERROR: \$AWS_ACCOUNT_ID must be defined"
  exit 1
fi

if [[ "$AWS_DEFAULT_REGION" == "" ]]; then
  echo "ERROR: \$AWS_DEFAULT_REGION must be defined"
  exit 1
fi

# Log in
$(aws ecr get-login --no-include-email --region ca-central-1)

# Push all the newly created images
docker images | tail -n +2 | while read line; do
  name=$(echo $line | awk '{print $1}')
  tag=$(echo $line | awk '{print $2}')
  url="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com"
  base_name="$name:$tag"
  ecr_name="$url/$base_name"
  echo "docker tag $base_name $ecr_name"
  docker tag $base_name $ecr_name
  aws ecr describe-repositories --repository-names $name \
    || aws ecr create-repository --repository-name $name
  echo "docker push $ecr_name"
  docker push $ecr_name
done

