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
      url "https://github.com/Erebine/binaries/releases/download/v3.4.1/erectl-Darwin-arm64"
      sha256 "b4fbd488cac121ba7a9d3f9aa4ff1163cbf80fcc5922602c266024dd4202aaae"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.4.1/erectl-Darwin-arm64"
      sha256 "b4fbd488cac121ba7a9d3f9aa4ff1163cbf80fcc5922602c266024dd4202aaae"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.4.1/erectl-Linux-x86_64"
      sha256 "c39b5016d4f5b43c3b26b9e97be3c7b95880857098834a1941521d7b17dffc25"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.4.1/erectl-Linux-aarch64"
      sha256 "8bc3dbca8eb8ac2810b4a9b7d91307b96592337d579ae6b12006d84e261fb143"
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
