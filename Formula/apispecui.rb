# Homebrew formula for apispecui: installs the pre-built release binary, so
# `brew install` compiles nothing. Go is still a RUNTIME dependency (below):
# the UI runs the same analysis, which shells out to `go list`.
#
# packaging/homebrew/apispecui.rb.tmpl is the SOURCE; apispecui.rb is it
# rendered at the current release. .github/workflows/release.yml renders the
# template with the checksums of the artifacts it just built and pushes the
# result to the tap (ehabterra/homebrew-tap, Formula/apispecui.rb).
# TestHomebrewFormulaMatchesTemplate keeps the two from drifting.
class Apispecui < Formula
  desc "Interactive web UI to configure and preview an OpenAPI spec from Go source"
  homepage "https://github.com/ehabterra/apispec"
  license "Apache-2.0"

  # Same runtime requirement as apispec: the UI analyses a project by loading
  # its packages through go/packages, which shells out to `go list`. The web
  # assets are embedded in the binary, so nothing else is needed.
  depends_on "go"

  on_macos do
    on_arm do
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.8/apispecui-darwin-arm64"
      sha256 "54a0df3a7d90a8762965b740c4a5b20f7461870d4a81c5d626ce2f0f8b8aea25"
    end
    on_intel do
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.8/apispecui-darwin-amd64"
      sha256 "4e217ee404c00c517d8662d064691649a5639a1900ccfca6d90e73f3b7349c0a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.8/apispecui-linux-arm64"
      sha256 "3f34552a4bb5c1492468d4bdc6a751e725481f5915a38072df3570e8d564c1c5"
    end
    on_intel do
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.8/apispecui-linux-amd64"
      sha256 "cfc0ca978bc9bd2dd1556b0ab8da8c86ff56cdc01167db572e6af88c2517d09d"
    end
  end

  def install
    # The download keeps its asset name; install it under the short one.
    bin.install Dir["apispecui-*"].first => "apispecui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apispecui --version")
  end
end
