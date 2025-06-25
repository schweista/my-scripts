#!/bin/bash

# Script to convert a .p12 file to various PEM formats using OpenSSL
# Usage: ./convert-p12-to-pem.sh <input-p12-file>
# Ensure the script is run with an argument

validate_inputs() {
  # Check if the user requested help
  if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo
    echo "Convert .p12 file to PEM format"
    echo
    echo "Usage: $0 <input-p12-file>"
    echo "Converts a .p12 file to PEM format including all-in-one, CA, CL, and private key."
    exit 0
  fi

  # Check if an argument is provided
  if [ -z "$1" ]; then
    echo "Error: No input file provided."
    echo "Usage: $0 <input-p12-file> [--help|-h]"
    exit 1
  fi

  # Check if openssl is installed
  if ! command -v openssl &> /dev/null; then
    echo "Error: openssl is not installed."
    exit 1
  fi

  # Check if the input file exists
  if [ ! -f "$1" ]; then
    echo "Error: Input file '$1' does not exist."
    exit 1
  fi

  # Check if the input file has a .p12 extension
  if [[ "$1" != *.p12 ]]; then
    echo "Error: Input file must have a .p12 extension."
    exit 1
  fi
}

validate_inputs "$@"

INPUT_FILE="$1"
BASENAME="${INPUT_FILE%.p12}"

# Prompt for password (hidden input)
read -s -p "Enter certificate password: " CERT_PASSWORD
echo

# Example placeholder commands
extract_all_in_one() {
  echo "Extracting all-in-one pem certificate.."
  openssl pkcs12 -legacy -in "$INPUT_FILE" -out "${BASENAME}.pem" -nodes -passin pass:"$CERT_PASSWORD" || {
    echo "Error: Failed to extract all-in-one PEM certificate."
    rm -f "${BASENAME}.pem"  # Clean up if extraction fails
    exit 1
  }
}

extract_ca() {
  echo "Extracting CA certificate.."
  openssl pkcs12 -legacy -in "$INPUT_FILE" -out "${BASENAME}_cacerts.pem" -cacerts -nokeys -passin pass:"$CERT_PASSWORD" || {
    echo "Error: Failed to extract CA certificate."
    rm -f "${BASENAME}_cacerts.pem"  # Clean up if extraction fails
    exit 1
  }
}

extract_cl() {
  echo "Extracting CL certificate.."
  openssl pkcs12 -legacy -in "$INPUT_FILE" -out "${BASENAME}_clcerts.pem" -clcerts -nokeys -passin pass:"$CERT_PASSWORD" || {
    echo "Error: Failed to extract CL certificate."
    rm -f "${BASENAME}_clcerts.pem"  # Clean up if extraction fails
    exit 1
  }
}

extract_secret_key() {
  echo "Extracting private key.."
  openssl pkcs12 -legacy -in "$INPUT_FILE" -out "${BASENAME}_privatekey.pem" -nocerts -nodes -passin pass:"$CERT_PASSWORD" || {
    echo "Error: Failed to extract private key."
    rm -f "${BASENAME}_privatekey.pem"  # Clean up if extraction fails
    exit 1
  }
}

# Export variables and run commands in parallel
export INPUT_FILE CERT_PASSWORD
(extract_all_in_one) &
(extract_ca) &
(extract_cl) &
(extract_secret_key) &

wait
echo "Done."
