# Homebrew formula for apispecui: installs the pre-built release binary, so
# `brew install` compiles nothing. Go is still needed at RUNTIME (below):
# the UI runs the same analysis, which shells out to `go list`.
#
# packaging/homebrew/apispecui.rb.tmpl is the SOURCE; apispecui.rb is it
# rendered at the current release. .github/workflows/release.yml renders the
# template with the checksums of the artifacts it just built and pushes the
# result to the tap (ehabterra/homebrew-tap, Formula/apispecui.rb).
# TestHomebrewFormulaMatchesTemplate keeps the two from drifting.

# ANY go on PATH satisfies apispecui, so this is a requirement and not
# `depends_on "go"`.
#
# A formula dependency can only ever be satisfied by Homebrew's own keg. So
# `brew install apispecui` downloaded the newest Go — hundreds of megabytes — onto
# machines that already had a working toolchain from go.dev, gvm, asdf or a
# distro package, and then did not even use it: apispecui shells out to whatever
# `go` PATH resolves to, which on those machines is still the one that was
# already there. The keg was pure download.
#
# `satisfy` checks for that binary instead, and `fatal` means a machine with no
# Go at all is told so up front rather than discovering it on the first run.
#
# apispec.rb declares this class too, WORD FOR WORD. A tap loads its formulae
# into one Ruby process, so the second definition reopens the first class rather
# than defining another — keeping them identical is what makes that a no-op, and
# is why the text below names no tool.
class GoRequirement < Requirement
  fatal true

  # build_env: false — the check runs in the user's own environment, so a Go
  # installed outside Homebrew's PATH is seen.
  satisfy(build_env: false) { which("go") }

  def display_s
    "go (any installation on PATH)"
  end

  def message
    <<~EOS
      This tool needs the Go toolchain on PATH at RUNTIME: it analyses a project
      by loading its packages through go/packages, which shells out to `go list`.
      Without it every run exits with "go command required, not found".

      Any Go installation will do. If you have none:
        brew install go
      or install one from https://go.dev/dl/
    EOS
  end
end

class Apispecui < Formula
  desc "Interactive web UI to configure and preview an OpenAPI spec from Go source"
  homepage "https://github.com/ehabterra/apispec"
  license "Apache-2.0"

  # Same requirement as apispec: the UI analyses a project by loading its
  # packages through go/packages, which shells out to `go list`. The web assets
  # are embedded in the binary, so nothing else is needed.
  depends_on GoRequirement

  on_macos do
    on_arm do
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.10/apispecui-darwin-arm64"
      sha256 "3442454d27fd18dda8d61c78d2731de0a23b512eaf6b0848cad9df97c5abd6d3"
    end
    on_intel do
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.10/apispecui-darwin-amd64"
      sha256 "55c312306484bbd793cc75a27f12a911e8839e0345e44ecee86b28388b7df964"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.10/apispecui-linux-arm64"
      sha256 "3c7f51e783f8f18a99f320bc0557f62fbc7e9e978a72aaef4bb7ca9315601ea4"
    end
    on_intel do
      url "https://github.com/ehabterra/apispec/releases/download/v0.5.10/apispecui-linux-amd64"
      sha256 "9b861cea757495a111d04a562a5b7f5dfa33cc47878638aab180a243fa45159d"
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
