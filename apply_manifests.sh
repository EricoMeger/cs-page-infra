#!/bin/bash

MANIFESTS_DIR="./manifests"

for file in "$MANIFESTS_DIR"/*.yaml; do
  if [ -f "$file" ]; then
    kubectl apply -f "$file"
  fi
done