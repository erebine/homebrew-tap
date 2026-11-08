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
      url "https://github.com/Erebine/binaries/releases/download/v3.1.2/erectl-Darwin-arm64"
      sha256 "8c4f2a8a16f7298bd9ab32bcabe5c1579bea9db837d19ce5c28dad3204ae6921"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.1.2/erectl-Darwin-arm64"
      sha256 "8c4f2a8a16f7298bd9ab32bcabe5c1579bea9db837d19ce5c28dad3204ae6921"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.1.2/erectl-Linux-x86_64"
      sha256 "ffd77be9a75413e35fc39a73fdd70a801f2d1c982469d0fec5d2344b5bd3ead1"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.1.2/erectl-Linux-aarch64"
      sha256 "d518fd86344376b9a3968d377501085df5f74ae79cc69bec437e049c69f0c609"
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
