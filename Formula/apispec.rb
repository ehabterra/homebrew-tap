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
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.8/apispec-darwin-arm64"
      sha256 "198a90ed4a82847667ac15f793b1faf7846b9c95085887633c0e5816e0d64de4"
    end
    on_intel do
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.8/apispec-darwin-amd64"
      sha256 "2f48bef5ba8419062079a47d8e547de491dc332806f4102af8919e337e46f313"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.8/apispec-linux-arm64"
      sha256 "edbe3d3e4027ffd3e2e6406412b27f87ac9240ead0d9581f783a5cbf88c709d5"
    end
    on_intel do
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.8/apispec-linux-amd64"
      sha256 "453d6d16ad9434c460e3ca71a0d79c39e6feab177febc91590b004e1ac5d568c"
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
