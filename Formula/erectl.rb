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
      url "https://github.com/Erebine/binaries/releases/download/v3.3.9/erectl-Darwin-arm64"
      sha256 "0fa28af34224e4ca4519766701a84666642f42f86d3baf0fd03b3b87a9fa3ecd"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.9/erectl-Darwin-arm64"
      sha256 "0fa28af34224e4ca4519766701a84666642f42f86d3baf0fd03b3b87a9fa3ecd"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.9/erectl-Linux-x86_64"
      sha256 "4a5e4579776d5d4dcc37e50c3397a5df4e629bbe0955749d5a0a17a31f24e559"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.9/erectl-Linux-aarch64"
      sha256 "d1b666a5cd6cce5252feedfaaeeab52b1fdc7e49865da03c5777f424bd7dd284"
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
