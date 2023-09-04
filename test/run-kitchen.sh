# Parse parameters
while [[ "$#" > 0 ]]; do case $1 in
  --module) MODULE="$2"; shift; shift;;
  --pipeline-id) PIPELINE_ID="$2"; shift; shift;;
  --tag) TAG="$2"; shift; shift;;
  --aws-profile) AWS_PROFILE="$2"; shift; shift;;
  --action) ACTION="$2"; shift; shift;;
  --args) ARGS="$2"; shift; shift;;
  *) usage "Unknown parameter passed: $1"; shift; shift;;
esac; done

# Default version of Kitchen Terraform when not specified a tag
TAG="${TAG:-"2.1.0"}"

# Default AWS Profile
AWS_PROFILE="${AWS_PROFILE:-"default"}"

printf "\n*************************************************************\n"
printf "  Running Kitchen Terraform using the following parameters:\n"
printf "  %-22s %s\n" "- Pipeline ID:" ${PIPELINE_ID:-"(not set)"}
printf "  %-22s %s\n" "- Kitchen Terraform:" $TAG
printf "  %-22s %s\n" "- AWS Profile:" $AWS_PROFILE
printf "  %-22s %s\n" "- Kitchen action:" ${ACTION:-"(not set)"}
printf "  %-22s %s\n" "- Kitchen arguments:" ${ARGS:-"(not set)"}
printf "*************************************************************\n\n"

if [[ -n "$PIPELINE_ID" ]] && [[ -n "$ACTION" ]]; then

  if [[ ${ACTION} == "debug" ]]; then
    docker run -ti --rm \
      --env pipeline_id=$PIPELINE_ID \
      --env AWS_PROFILE=$AWS_PROFILE \
      --env CUSTOM_CA_DIR=/usr/share/ca-certificates/custom \
      --volume /etc/ssl/certs/:/usr/share/ca-certificates/custom \
      --volume $(pwd):/usr/action \
      --volume ~/.ssh:/root/.ssh \
      --volume ~/.aws:/root/.aws \
      --volume ~/.terraformrc:/root/.terraformrc \
      --user root \
      --workdir /usr/action \
      --entrypoint bash \
      quay.io/dwp/kitchen-terraform:$TAG
  else
    docker run --rm \
      --env pipeline_id=$PIPELINE_ID \
      --env AWS_PROFILE=$AWS_PROFILE \
      --env CUSTOM_CA_DIR=/usr/share/ca-certificates/custom \
      --volume /etc/ssl/certs/:/usr/share/ca-certificates/custom \
      --volume $(pwd):/usr/action \
      --volume ~/.ssh:/root/.ssh \
      --volume ~/.aws:/root/.aws \
      --volume ~/.terraformrc:/root/.terraformrc \
      --user root \
      --workdir /usr/action \
      quay.io/dwp/kitchen-terraform:${TAG} "${ACTION} ${ARGS}"
  fi

else
  echo "The following arguments are required: \`--pipeline-id\` and \`--action\`."
fi
