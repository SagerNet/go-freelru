#!/usr/bin/env bash

OLD_MODULE_NAME="github.com/elastic/go-freelru"
NEW_MODULE_NAME="github.com/sagernet/go-freelru"

rules=$(cat <<EOF
id: replace-module
language: go
rule:
  kind: import_spec
  pattern: \$OLD_IMPORT
constraints:
  OLD_IMPORT:
    has:
      field: path
      regex: ^"$OLD_MODULE_NAME
transform:
  NEW_IMPORT:
    replace:
      source: \$OLD_IMPORT
      replace: $OLD_MODULE_NAME(?<PATH>.*)
      by: $NEW_MODULE_NAME\$PATH
fix: \$NEW_IMPORT
EOF
)


sg scan --inline-rules "$rules" -U

sed -i "s|module $OLD_MODULE_NAME|module $NEW_MODULE_NAME|" go.mod

go mod tidy

gci write .
gci write .

git commit -m "Rename module" -a
