#!/usr/bin/env bash
# Renders (or previews) the Quarto site inside Docker, so no R/Python/GDAL
# toolchain needs to be installed on the host.
#
# Usage:
#   scripts/render.sh                    # render the whole site
#   scripts/render.sh sessions/week1.qmd # render a single file
#   scripts/render.sh preview            # live preview at http://localhost:4200
#
# First run builds the image and restores ~216 R packages + Python deps into
# ./renv/library and ./.venv, which are bind-mounted so later runs reuse them.
set -euo pipefail
cd "$(dirname "$0")/.."

docker build -t quant-methods-render .
docker run --rm \
  -v "$(pwd)":/project \
  -p 4200:4200 \
  quant-methods-render \
  bash scripts/docker-render.sh "$@"
