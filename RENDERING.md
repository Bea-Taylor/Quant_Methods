# Rendering the site locally

Two ways to build or preview the site. Both serve at <http://localhost:4200>.

| Path | Needs | Use when |
|---|---|---|
| [A. Docker](#a-docker) | Docker | Default. Fresh clone, new machine, day-to-day previewing |
| [B. Host toolchain](#b-host-toolchain-local-only) | R + Python installed on the machine | You have no Docker, or want the fastest incremental renders |

> **Copy commands from this file, not from a rendered Markdown preview.**
> Rendered views escape underscores and ampersands as `\_` and `\&\&`, and
> bash rejects those with `cd: too many arguments`.

## A. Docker

R and Python packages are both baked into the image at **build** time (see
`Dockerfile`), outside `/project`, so a container never restores anything at
`docker run` time - it goes straight to rendering. Rebuild after changing
`renv.lock` or `requirements.txt`; otherwise the image is reused as-is.

```bash
scripts/render.sh                     # render the whole site
scripts/render.sh sessions/week1.qmd  # render a single file
scripts/render.sh preview             # live preview
```

`docker build` is the slow step the first time (~216 R packages via prebuilt
binaries, a couple of minutes) or after a lockfile/requirements change; every
render after that starts immediately.

There used to be a separate "prebuilt image" path referencing a
`quant-methods-render:ready` tag. That tag was never produced by anything in
this repo (no commit touching the `Dockerfile` created it) - it looks like a
one-off local `docker commit` snapshot, not something `git clone` reproduces.
`scripts/render.sh` above **is** the reproducible equivalent now: `docker
build` alone produces a fully ready image.

This also shrinks what Quarto has to crawl inside the bind mount before
rendering anything (see the Windows gotcha in **Gotchas** below):
`renv/library` and `.venv-reticulate` no longer exist under `/project` at
all, since the packages they used to hold now live in the image instead.

## B. Host toolchain (local only)

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

**The Jupyter kernel name is case-sensitive, and must be lowercase.**
`_quarto.yml` sets `jupyter: qmfork`, and Quarto matches that against the
kernelspec *directory* name, case-sensitively. `ipykernel install` lowercases
whatever you pass to `--name`, so the directory is always lowercase even if you
ask for `qmFork` — it will even print "Installed kernelspec qmFork" while
creating `qmfork`. Keep the yaml lowercase to match.

If they ever drift apart the render fails before executing anything:

```
ERROR: Jupyter kernel 'qmFork' not found. Known kernels: python3, qmfork
```

Note `jupyter kernelspec list` lowercases its own output, so it cannot tell you
whether the directory is correct — check the directory name itself. On Windows
the specs live in `%APPDATA%\jupyter\kernels\`.

**`pandas` is pinned `>=2.2.2,<3`.** pandas 3.0 tightened string-dtype coercion
and breaks the `.astype(str)` patterns used throughout the practicals. The
Dockerfile also pins `pandas-flavor==0.6.0` and `pyjanitor==0.26.0` together,
mirroring the CI workflow — `register_groupby_method` was removed in
pandas-flavor 0.7.0.

**Quarto versions differ between paths.** The Dockerfile pins 1.9.37; whatever
is installed on the host drives path B. Output can differ between them.

**Re-rendering rewrites files under `sessions/`.** Figure directories
(`sessions/*_files/`) and the maps written by `week6_practical.qmd` are
gitignored precisely because every render regenerates them. If `git status`
looks noisy after a render, that is why.

**Docker Desktop on Windows can be slow to start rendering.** Quarto crawls
the whole bind-mounted `/project` over the host file share (WSL2's
cross-filesystem tax) before running anything, which can take minutes on a
large project. Baking R/Python packages into the image (path A) removes a lot
of what used to sit in that mount (`renv/library`, `.venv-reticulate`), which
should help, but hasn't been verified against the original ~8-minute report.
If it's still slow: either keep the project inside WSL2's own filesystem
rather than `/mnt/c/...`, or exclude the remaining large dirs (`_freeze`,
`sessions/*_files`) from the mount with anonymous volumes. Not verified on
macOS, where bind mounts have a smaller but nonzero version of the same tax.
