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
      url "https://github.com/Erebine/binaries/releases/download/v2.10.1/erectl-Darwin-arm64"
      sha256 "8e5e5d943b3a952c619e0d059ddbfa72922a3cdc5ff26aa74fd81e62bde938e3"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v2.10.1/erectl-Darwin-arm64"
      sha256 "8e5e5d943b3a952c619e0d059ddbfa72922a3cdc5ff26aa74fd81e62bde938e3"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v2.10.1/erectl-Linux-x86_64"
      sha256 "6d6af053ae20f0dea10b6e80b6a2ee11638e13c89bf8900f7cbec72cecf54812"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.10.1/erectl-Linux-aarch64"
      sha256 "f692af0fac08d025eb9ddf57b58676530f51c4468c150b0363591f61df106926"
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
