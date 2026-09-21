#!/usr/bin/env bash
# Runs inside the `quant-methods-render` container (see Dockerfile / render-docker.sh).
# Restores R deps then renders the Quarto project. Python deps and the
# `qmFork` Jupyter kernel are baked into the image (see Dockerfile).
# Any arguments are passed straight through to `quarto render`.
set -euo pipefail
cd /project

echo "==> R packages (renv::restore)"
Rscript -e 'if (!requireNamespace("renv", quietly = TRUE)) install.packages("renv", repos = "https://cloud.r-project.org"); renv::restore(prompt = FALSE)'

echo "==> casaviz (from setup/casaviz.zip)"
if ! Rscript -e 'quit(status = as.integer(!requireNamespace("casaviz", quietly = TRUE)))'; then
  rm -rf /tmp/casaviz && unzip -q setup/casaviz.zip -d /tmp/casaviz
  R CMD INSTALL /tmp/casaviz
  rm -rf /tmp/casaviz
fi

echo "==> Extra R packages installed ad hoc in CI but not pinned in renv.lock"
Rscript -e '
pkgs <- c("magick", "eurostat", "downlit", "xml2", "giscoR", "ggimage", "see", "huxtable")
missing <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) install.packages(missing, repos = "https://cloud.r-project.org")
'

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
