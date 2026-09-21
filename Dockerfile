# Container for rendering the Quarto site without installing R/Python/GDAL
# locally. Mirrors the system deps + toolchain used in
# .github/workflows/publish.yml. Python deps are baked into the image at
# /opt/venv (see below); R packages are restored at `docker run` time.

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

# `jupyter: qmFork` in _quarto.yml resolves to the kernel registered above;
# the same venv serves reticulate calls from R chunks.
ENV QUARTO_PYTHON=/opt/venv/bin/python \
    RETICULATE_PYTHON=/opt/venv/bin/python \
    RETICULATE_AUTOCONFIGURE=FALSE

WORKDIR /project
CMD ["bash", "scripts/docker-render.sh"]
