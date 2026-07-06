#!/usr/bin/env bash
# Regenera html/*.html a partir de las fuentes en md/ vía pandoc + prettier.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

MD_DIR="md"
HTML_DIR="html"

command -v pandoc >/dev/null || {
  echo "error: pandoc no está instalado" >&2
  exit 1
}
command -v npx >/dev/null || {
  echo "error: npx no está disponible (se necesita para prettier)" >&2
  exit 1
}

pages=(
  "index.md:index.html:"
  "proyectos.md:proyectos.html:"
  "sobre-mi.md:sobre-mi.html:"
  "sobre-el-servidor.md:sobre-el-proyecto.html:mermaid.html"
)

for entry in "${pages[@]}"; do
  IFS=':' read -r md_file html_file extra_header <<<"$entry"
  src="$MD_DIR/$md_file"
  dst="$HTML_DIR/$html_file"

  [ -f "$src" ] || {
    echo "error: no existe $src" >&2
    exit 1
  }

  echo "-> $src => $dst"

  header_flags=(-H "$HTML_DIR/favicon.html")
  if [ -n "$extra_header" ]; then
    header_flags+=(-H "$HTML_DIR/$extra_header")
  fi

  tmp="$(mktemp --suffix=.html)"
  pandoc "$src" \
    -f markdown-native_divs \
    -t html5 \
    -s \
    --css=style.css \
    "${header_flags[@]}" \
    -B "$HTML_DIR/theme-toggle.html" \
    -o "$tmp"

  npx --yes prettier --parser html "$tmp" >"$dst"
  rm -f "$tmp"
done

echo "listo."
