set -euo pipefail

readonly PRODUCT_NAME=${1:?"Merci le produit (orion, monitoring)"}; shift;
readonly ENV_NAME=${1:?"Merci de préciser un environnement (ex. recette ou production)"}; shift;

readonly MODULE_DIR="${SCRIPT_DIR}/ovh/ovh-nodejs-client"

function main() {
  local env_ip=$("${BIN_DIR}/infra.sh" product:env:ip "${PRODUCT_NAME}" "${ENV_NAME}")
  if [ -z $env_ip ]; then exit 1; fi

  cd "${MODULE_DIR}"
  yarn --silent install

  export APP_KEY=$(op item get "API OVH"  --vault "vault-passwords-common" --account inserjeunes --fields username)
  export APP_SECRET=$(op item get "API OVH"  --vault "vault-passwords-common" --account inserjeunes --fields credential --reveal)

  yarn --silent cli closeService "${env_ip}" "$PRODUCT_NAME" "$@"
  cd - >/dev/null
}

main "$@"
