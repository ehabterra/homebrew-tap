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
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.7/apispecui-darwin-arm64"
      sha256 "089d41dd660da389bd06c40d671403228228ec1851c3254aec9ad99a072cb346"
    end
    on_intel do
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.7/apispecui-darwin-amd64"
      sha256 "2b818a6d8eced6e97ee9096a248ce17256efd63ca46604541b0a4f6bfc66f614"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.7/apispecui-linux-arm64"
      sha256 "9215b66dd5ca29889fc8575cd040e656f563738c86c5a6e95ffac25e79bfd240"
    end
    on_intel do
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.7/apispecui-linux-amd64"
      sha256 "184783963b2a95c279dc02e40c55149da092fbf5b9804d33ea99a39951764fd3"
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
