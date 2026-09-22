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

# Git Bash / MSYS on Windows rewrites arguments that look like Unix paths into
# Windows ones before the command runs, so `-v "$(pwd)":/project` arrives as
# `-v /e/Quant_Methods:C:/Program Files/Git/project`. The bind mount then lands
# somewhere unexpected, /project inside the container is empty, and the run
# dies with "bash: scripts/docker-render.sh: No such file or directory" while
# the file is plainly sitting there on the host.
#
# MSYS_NO_PATHCONV=1 turns that rewriting off. It is simply an unused variable
# on macOS and Linux, so this is safe for everyone.
export MSYS_NO_PATHCONV=1

docker build -t quant-methods-render .
docker run --rm \
  -v "$(pwd)":/project \
  -v /project/.quarto \
  -p 4200:4200 \
  quant-methods-render \
  bash scripts/docker-render.sh "$@"

# The bare `-v /project/.quarto` above is deliberate. Quarto's project cache is
# a SQLite database (.quarto/project-cache/deno-kv-file) in WAL mode, which
# needs shared-memory file locking. That does not work over a Docker Desktop
# bind mount on Windows, and the render fails with "ERROR: disk I/O error".
# Naming the path with no source gives the container an anonymous volume on a
# real Linux filesystem, shadowing the host's .quarto. The cache is rebuilt
# each run (a few seconds) and the host's own cache is left untouched, so
# alternating between container and native renders no longer corrupts either.
