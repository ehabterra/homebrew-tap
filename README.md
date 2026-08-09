# ehabterra/homebrew-tap

Homebrew formulae for [ehabterra](https://github.com/ehabterra)'s tools.

```bash
brew install ehabterra/tap/apispec
```

`brew tap ehabterra/tap` first is optional — the fully-qualified name taps it for you.

## Formulae

| formula | what it is |
|---|---|
| [`apispec`](https://github.com/ehabterra/apispec) | Generate OpenAPI 3.1 specs from Go source by static analysis |

Each formula installs the project's **pre-built release binary**, so no Go
toolchain is needed and installation takes seconds.

## Updating

`Formula/apispec.rb` is generated. It is pushed here automatically by the
[apispec release workflow](https://github.com/ehabterra/apispec/blob/main/.github/workflows/release.yml)
on every tag, with checksums taken from the artifacts that release just built.

**Edit it in the source repo, not here** — see
[`packaging/homebrew/`](https://github.com/ehabterra/apispec/tree/main/packaging/homebrew).
A change made directly in this repo is overwritten by the next release.
