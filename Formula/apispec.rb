# Homebrew formula for apispec: installs the pre-built release binary, so
# `brew install` compiles nothing. Go is still a RUNTIME dependency (below):
# apispec shells out to `go list` and cannot analyse anything without it.
#
# packaging/homebrew/apispec.rb.tmpl is the SOURCE; apispec.rb is it rendered at
# the current release. .github/workflows/release.yml renders the template with
# the checksums of the artifacts it just built and pushes the result to the tap
# (ehabterra/homebrew-tap, Formula/apispec.rb). TestHomebrewFormulaMatchesTemplate
# keeps the two from drifting.
class Apispec < Formula
  desc "Generate OpenAPI 3.1 specs from Go source by static analysis"
  homepage "https://github.com/ehabterra/apispec"
  license "Apache-2.0"

  # apispec analyses a project by loading its packages through go/packages, which
  # shells out to `go list`. The pre-built binary still needs the go toolchain on
  # PATH at RUNTIME — without it every run exits with "go command required".
  depends_on "go"

  on_macos do
    on_arm do
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.7/apispec-darwin-arm64"
      sha256 "06e6fc5cfab3aceba2caa9b1b2af1406b2508865591461051061cf92fa494818"
    end
    on_intel do
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.7/apispec-darwin-amd64"
      sha256 "3fd89262c268b73f5324bae39a685655db6d55a62be696ae939e3e8b2caccdc6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.7/apispec-linux-arm64"
      sha256 "a6debf6df3ae997a075f46e25ffd532a9bb0c3b1782267fdcc47315b7f326350"
    end
    on_intel do
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.7/apispec-linux-amd64"
      sha256 "d57a4ee00fd695d01fcffc19cc84e0c26f45c5b146c76ad58ee0c47724d3fa90"
    end
  end

  def install
    # The download keeps its asset name; install it under the short one.
    bin.install Dir["apispec-*"].first => "apispec"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apispec --version")
  end
end
