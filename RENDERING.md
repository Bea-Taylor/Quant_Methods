# Rendering the site locally

Three ways to build or preview the site. All serve at <http://localhost:4200>.

| Path | Needs | Use when |
|---|---|---|
| [A. Prebuilt image](#a-prebuilt-image) | Docker + the saved `quant-methods-render:ready` image | Day-to-day previewing, fastest start |
| [B. Build from the Dockerfile](#b-build-from-the-dockerfile) | Docker | Fresh clone, new machine, or after `requirements.txt` changes |
| [C. Host toolchain](#c-host-toolchain-local-only) | R + Python installed on the machine | You have no Docker, or want the fastest incremental renders |

> **Copy commands from this file, not from a rendered Markdown preview.**
> Rendered views escape underscores and ampersands as `\_` and `\&\&`, and
> bash rejects those with `cd: too many arguments`.

## A. Prebuilt image

Everything is already installed in the saved image, so this goes straight to
rendering. Run from the `Quant_Methods` folder in **PowerShell**:

```powershell
docker run --rm --name qm-preview -v "${PWD}:/project" -v /project/.venv-reticulate -p 4200:4200 -w /project -e QUARTO_PYTHON=/opt/venv/bin/python -e RETICULATE_PYTHON=/opt/venv/bin/python quant-methods-render:ready quarto preview --no-browser --host 0.0.0.0 --port 4200
```

Stop it with:

```powershell
docker stop qm-preview
```

## B. Build from the Dockerfile

Builds the image, then restores the R packages into the bind-mounted
`renv/library` so later runs reuse them. First run is slow (~216 R packages);
later runs are not.

```bash
scripts/render.sh                     # render the whole site
scripts/render.sh sessions/week1.qmd  # render a single file
scripts/render.sh preview             # live preview
```

What the container does on each run is in `scripts/docker-render.sh`: restore
renv, install `casaviz` from `setup/casaviz.zip`, add the CRAN packages that CI
installs ad hoc but `renv.lock` does not pin, then render.

## C. Host toolchain (local only)

Uses R and Python installed directly on the machine. This is driven by
`render-local.sh`, which is **gitignored and not in the clone** — it hardcodes
machine-specific paths, so each person creates their own:

```bash
#!/usr/bin/env bash
# Local dev render (gitignored helper)
export PATH="/c/Program Files/R/R-4.5.2/bin/x64:$PATH"
export QUARTO_PYTHON="E:/QM_Fork/venv/Scripts/python.exe"
export RETICULATE_PYTHON="$QUARTO_PYTHON"
export RETICULATE_AUTOCONFIGURE=FALSE
quarto "$@"
```

Save as `render-local.sh`, `chmod +x render-local.sh`, then from **Git Bash**:

```bash
./render-local.sh preview
./render-local.sh render
```

Stop a preview with:

```bash
pkill -f "quarto preview"
```

This path needs the toolchain set up by hand — see **Gotchas** below.

## Gotchas

**The Jupyter kernel name is case-sensitive.** `_quarto.yml` sets
`jupyter: qmFork`, and Quarto matches that against the kernelspec *directory
name*. Registering it with `ipykernel install --name qmFork` silently lowercases
the directory to `qmfork`, and the render then fails with:

```
ERROR: Jupyter kernel 'qmFork' not found. Known kernels: python3, qmfork
```

Fix by renaming the directory to match exactly. On Windows the spec lives in
`%APPDATA%\jupyter\kernels\`. Note `jupyter kernelspec list` lowercases its own
output, so it will keep showing `qmfork` even once the directory is correct —
trust the directory name, not the listing.

**`pandas` is pinned `>=2.2.2,<3`.** pandas 3.0 tightened string-dtype coercion
and breaks the `.astype(str)` patterns used throughout the practicals. The
Dockerfile also pins `pandas-flavor==0.6.0` and `pyjanitor==0.26.0` together,
mirroring the CI workflow — `register_groupby_method` was removed in
pandas-flavor 0.7.0.

**Quarto versions differ between paths.** The Dockerfile pins 1.9.37; whatever
is installed on the host drives path C. Output can differ between them.

**Re-rendering rewrites files under `sessions/`.** Figure directories
(`sessions/*_files/`) and the maps written by `week6_practical.qmd` are
gitignored precisely because every render regenerates them. If `git status`
looks noisy after a render, that is why.
