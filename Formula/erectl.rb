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
      url "https://github.com/Erebine/binaries/releases/download/v3.3.7/erectl-Darwin-arm64"
      sha256 "263eebcc4ed528874ca42432a88b9c75d2cdbfa0a3f28376163bbdb5ed20a5ac"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.7/erectl-Darwin-arm64"
      sha256 "263eebcc4ed528874ca42432a88b9c75d2cdbfa0a3f28376163bbdb5ed20a5ac"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.7/erectl-Linux-x86_64"
      sha256 "ee53c7c2dda25a2ff933c270d0880a1096150a494007fcd55e57211330f5fde9"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.7/erectl-Linux-aarch64"
      sha256 "d7ea59ade8501900bfc6468853c0673ab24df56b7d8c148072ef4cafe65affe9"
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
