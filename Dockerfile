# Container for rendering the Quarto site without installing R/Python/GDAL
# locally. Mirrors the system deps + toolchain used in
# .github/workflows/publish.yml. Both R and Python packages are baked into
# the image at build time, outside /project, so the bind-mounted project
# directory at `docker run` time can't shadow them and nothing needs to
# restore at container start. Rebuild the image after changing renv.lock or
# requirements.txt.

FROM rocker/r-ver:4.5.1

RUN apt-get update && apt-get install -y --no-install-recommends \
    libudunits2-dev libproj-dev libgeos-dev libgdal-dev \
    libglu1-mesa freeglut3-dev mesa-common-dev \
    libmagick++-dev gdal-bin \
    python3 python3-venv python3-pip python3-dev \
    curl gdebi-core git unzip ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Quarto CLI, pinned to match the version used for local dev (see `quarto --version`)
ARG QUARTO_VERSION=1.9.37
RUN ARCH=$(dpkg --print-architecture) \
    && curl -LO https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${ARCH}.deb \
    && gdebi --non-interactive quarto-${QUARTO_VERSION}-linux-${ARCH}.deb \
    && rm quarto-${QUARTO_VERSION}-linux-${ARCH}.deb

# Python env lives in the image, not the bind-mounted project: a venv under
# /project is ~35k files, and on Docker Desktop (Windows/macOS) Quarto crawls
# the whole project over the slow host file share before rendering anything.
# Layer is cached until requirements.txt changes.
#
# Pins mirror .github/workflows/publish.yml's "CRITICAL FIX FOR pandas-flavor
# ATTRIBUTEERROR": pyjanitor 0.26.0 needs pandas-flavor's pre-0.7.0 API
# (register_groupby_method was removed in 0.7.0), and letting pip's resolver
# pick versions independently pulls in incompatible combinations.
COPY requirements.txt /tmp/requirements.txt
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --quiet --upgrade pip \
    && printf 'pandas-flavor==0.6.0\npyjanitor==0.26.0\npandas>=2.2.2,<3\n' > /tmp/constraints.txt \
    && /opt/venv/bin/pip install --quiet --no-deps 'pandas-flavor==0.6.0' 'pyjanitor==0.26.0' \
    && /opt/venv/bin/pip install --quiet -r /tmp/requirements.txt ipykernel \
       --constraint /tmp/constraints.txt --upgrade-strategy only-if-needed \
    && /opt/venv/bin/python -m ipykernel install --name qmfork --display-name qmFork --prefix /usr/local \
    && rm /tmp/requirements.txt /tmp/constraints.txt

# `jupyter: qmfork` in _quarto.yml resolves to the kernel registered above;
# the same venv serves reticulate calls from R chunks.
ENV QUARTO_PYTHON=/opt/venv/bin/python \
    RETICULATE_PYTHON=/opt/venv/bin/python \
    RETICULATE_AUTOCONFIGURE=FALSE

# R packages, baked at build time so a container never restores anything.
# renv::restore() here runs against a lockfile with no activated project (no
# .Rprofile calling renv::activate() - none is committed, see _quarto.yml's
# jupyter engine notes), so it ignores RENV_PATHS_LIBRARY entirely and just
# installs into R's own default site-library. That's actually simpler than
# redirecting it: /usr/local/lib/R/site-library is already on every R
# session's .libPaths() with no extra env needed, and it lives in the image
# rather than /project, so the runtime bind mount can't shadow it either.
WORKDIR /opt/build-renv
COPY renv.lock renv.lock
COPY renv/activate.R renv/activate.R
COPY renv/settings.json renv/settings.json
RUN Rscript -e 'install.packages("renv", repos = "https://cloud.r-project.org"); renv::restore(prompt = FALSE)'

# casaviz and the CRAN packages CI installs ad hoc but renv.lock doesn't pin,
# into that same default library. The path goes via a file rather than
# $(...): renv writes some of its startup notices to stdout, so command
# substitution captures those too.
COPY setup/casaviz.zip casaviz.zip
RUN Rscript -e 'writeLines(.libPaths()[1], "r-lib-path")' \
    && unzip -q casaviz.zip -d casaviz \
    && R CMD INSTALL -l "$(cat r-lib-path)" casaviz \
    && Rscript -e 'install.packages(c("magick", "eurostat", "downlit", "xml2", "giscoR", "ggimage", "see", "huxtable"), repos = "https://cloud.r-project.org")' \
    && rm -rf casaviz casaviz.zip r-lib-path

WORKDIR /project
CMD ["quarto", "render"]
