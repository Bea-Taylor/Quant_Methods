# Container for rendering the Quarto site without installing R/Python/GDAL
# locally. Mirrors the system deps + toolchain used in
# .github/workflows/publish.yml, but R/Python packages are restored at
# `docker run` time into ./renv/library and ./.venv (bind-mounted, so they
# persist on the host and are reused across runs).

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

WORKDIR /project
CMD ["bash", "scripts/docker-render.sh"]
