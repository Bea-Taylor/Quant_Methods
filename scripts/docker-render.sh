#!/usr/bin/env bash
# Runs inside the `quant-methods-render` container (see Dockerfile / render-docker.sh).
# Restores R + Python deps (cached on the host via bind mounts) then renders
# the Quarto project. Any arguments are passed straight through to `quarto render`.
set -euo pipefail
cd /project

# Python here is only for `reticulate` calls from R chunks (mixed R+Python
# practicals). Pure-Python/Jupyter pages render locally with the host's
# `qmFork` conda env instead - see README.
echo "==> Python venv (for reticulate)"
if [ ! -x .venv-reticulate/bin/python ]; then
  python3 -m venv .venv-reticulate
fi
PIP=.venv-reticulate/bin/pip
$PIP install --quiet --upgrade pip

# Mirrors .github/workflows/publish.yml's "CRITICAL FIX FOR pandas-flavor
# ATTRIBUTEERROR": pyjanitor 0.26.0 needs pandas-flavor's pre-0.7.0 API
# (register_groupby_method was removed in 0.7.0), and letting pip's resolver
# pick versions independently pulls in incompatible combinations.
cat > /tmp/constraints.txt <<'TXT'
pandas-flavor==0.6.0
pyjanitor==0.26.0
pandas>=2.2.2,<3
TXT
$PIP uninstall -y pandas-flavor pyjanitor pandas >/dev/null 2>&1 || true
$PIP install --quiet --no-deps 'pandas-flavor==0.6.0'
$PIP install --quiet --no-deps 'pyjanitor==0.26.0'
$PIP install --quiet -r requirements.txt --constraint /tmp/constraints.txt --upgrade-strategy only-if-needed
export RETICULATE_PYTHON=/project/.venv-reticulate/bin/python
export RETICULATE_AUTOCONFIGURE=FALSE

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

echo "==> Custom revealjs theme"
cp css/casa-slides.scss /opt/quarto/share/formats/revealjs/themes/ 2>/dev/null || true

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
