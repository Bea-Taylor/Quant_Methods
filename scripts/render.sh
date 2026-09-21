#!/usr/bin/env bash
# Renders (or previews) the Quarto site inside Docker, so no R/Python/GDAL
# toolchain needs to be installed on the host.
#
# Usage:
#   scripts/render.sh                    # render the whole site
#   scripts/render.sh sessions/week1.qmd # render a single file
#   scripts/render.sh preview            # live preview at http://localhost:4200
#
# First run builds the image and restores ~208 R packages into ./renv/library,
# which is bind-mounted. Python deps are baked into the image at /opt/venv.
#
# The `renv-cache` named volume is required, not an optimisation: renv installs
# into its cache and leaves symlinks in renv/library. The cache lives under
# /root/.cache/R/renv inside the container, so without the volume it dies with
# the container and the bind-mounted library is left holding only dangling
# symlinks — every later run then reports all packages missing and restores
# again from scratch.
set -euo pipefail
cd "$(dirname "$0")/.."

docker build -t quant-methods-render .
docker run --rm \
  -v "$(pwd)":/project \
  -v renv-cache:/root/.cache/R/renv \
  -p 4200:4200 \
  quant-methods-render \
  bash scripts/docker-render.sh "$@"
