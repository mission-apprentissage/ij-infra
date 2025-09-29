#!/usr/bin/env bash
set -euo pipefail

readonly VAULT_FILE="${ROOT_DIR}/.infra/vault/vault.yml"

if [[ -n "${ANSIBLE_VAULT_PASSWORD_FILE:-}" ]]; then
  # Use the password file specified in the environment variable
  ansible-vault view --vault-password-file="${ROOT_DIR}/${ANSIBLE_VAULT_PASSWORD_FILE}" "${VAULT_FILE}"
else
  # Fall back to the default password script
  ansible-vault view --vault-password-file="${SCRIPT_DIR}/get-vault-password-client.sh" "${VAULT_FILE}"
fi