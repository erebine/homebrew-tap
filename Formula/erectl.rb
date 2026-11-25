# SPDX-License-Identifier: MIT
# Prebuilt erectl binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Erectl < Formula
  desc "Erebine command-line client"
  homepage "https://erebine.ai"
  license "MIT"

  depends_on "zstd"

  uses_from_macos "curl"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.4/erectl-Darwin-arm64"
      sha256 "420318ced81fbd3e6aa5a4667b16291056e87ed91b88b8eac1f410f7ffbf9655"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.4/erectl-Darwin-arm64"
      sha256 "420318ced81fbd3e6aa5a4667b16291056e87ed91b88b8eac1f410f7ffbf9655"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.4/erectl-Linux-x86_64"
      sha256 "c6b121c6c01a8a01ea3ebfb7edcb2a8b4640eafad28c74430f5311381df6128c"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.4/erectl-Linux-aarch64"
      sha256 "11d19e204e316da6625e6a5eb2d1b5f9d1c3801e7a5ba4b2177d172bfc2b35f4"
    end
  end

  def install
    binary = Dir["erectl-*"].first
    # The Linux build finds libzstd and libcurl by soname in the loader's
    # default path, where Homebrew's are not: add their opt directories to
    # its RUNPATH, after the $ORIGIN the build set.
    if OS.linux?
      rpath = %w[zstd curl].map { |dep| formula_opt_lib(dep) }.join(":")
      system "patchelf", "--add-rpath", rpath, binary
    end
    bin.install binary => "erectl"
  end

  test do
    system bin/"erectl", "--help"
  end
end
