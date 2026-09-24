#!/usr/bin/env bash
# Runs inside the `quant-methods-render` container (see Dockerfile /
# scripts/render.sh). R and Python packages are baked into the image at
# build time (see Dockerfile) - there's nothing to restore here, just render.
# Any arguments are passed straight through to `quarto render`.
set -euo pipefail
cd /project

# Ignore any .Rprofile sitting in the project. The image bakes every package
# into R's default site-library and nothing needs restoring at run time, but a
# developer's local (gitignored) .Rprofile will typically call
# renv/activate.R - and because the project is bind-mounted, the container
# sources it too. That repoints .libPaths() at /project/renv/library, which
# may be stale, incomplete or built for another platform, and the render dies
# with things like "The rmarkdown package is not available".
export R_PROFILE_USER=/dev/null

if [ "${1:-}" = "preview" ]; then
  shift
  echo "==> quarto preview $*"
  exec quarto preview --no-browser --host 0.0.0.0 "$@"
elif [ "$#" -eq 0 ]; then
  echo "==> quarto render (whole project)"
  quarto render
else
  # `quarto render` only takes one input path at a time; extra args get
  # silently forwarded to pandoc instead of triggering separate renders.
  for f in "$@"; do
    echo "==> quarto render $f"
    quarto render "$f"
  done
fi
