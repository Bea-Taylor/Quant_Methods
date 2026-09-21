#!/usr/bin/env bash
# Renders (or previews) the Quarto site inside Docker, so no R/Python/GDAL
# toolchain needs to be installed on the host.
#
# Usage:
#   scripts/render.sh                    # render the whole site
#   scripts/render.sh sessions/week1.qmd # render a single file
#   scripts/render.sh preview            # live preview at http://localhost:4200
#
# R and Python packages are both baked into the image at build time (see
# Dockerfile), so `docker build` is the slow step (~216 R packages the first
# time, or after renv.lock/requirements.txt change) and every `docker run`
# after that goes straight to rendering.
set -euo pipefail
cd "$(dirname "$0")/.."

docker build -t quant-methods-render .
docker run --rm \
  -v "$(pwd)":/project \
  -p 4200:4200 \
  quant-methods-render \
  bash scripts/docker-render.sh "$@"
