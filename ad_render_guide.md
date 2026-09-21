# Rendering the QM site locally

Two ways. Both serve on <http://localhost:4200>.

## Option A — Docker (Bea's setup, self-contained)

Everything is baked into the image, so it goes straight to rendering.
Run from the `Quant_Methods` folder in **PowerShell**:

```powershell
docker run --rm --name qm-preview -v "${PWD}:/project" -v /project/.venv-reticulate -p 4200:4200 -w /project -e QUARTO_PYTHON=/opt/venv/bin/python -e RETICULATE_PYTHON=/opt/venv/bin/python quant-methods-render:ready quarto preview --no-browser --host 0.0.0.0 --port 4200
```

Stop it with:

```powershell
docker stop qm-preview
```

## Option B — local toolchain (gitignored `render-local.sh`)

Uses the R install on this machine plus QM_Fork's venv. Run from **Git Bash**:

```bash
./render-local.sh preview
```

Or to build without serving:

```bash
./render-local.sh render
```

## Notes

- Do not paste commands out of the rendered Markdown preview — it escapes
  underscores and ampersands as `\_` and `\&\&`, which bash rejects with
  "too many arguments". Copy from the raw file or from a code block.
- Option B depends on `E:\QM_Fork\venv` still existing. Option A does not.
- `pandas` is pinned `<3` in requirements.txt; 3.0 breaks the `.astype(str)`
  patterns in the practicals.
