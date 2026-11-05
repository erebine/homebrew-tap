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
      url "https://github.com/Erebine/binaries/releases/download/v2.11.1/erectl-Darwin-arm64"
      sha256 "0a3b402e7466c03a26ec8c9332d1f7d4a6a754019e5ac77a9f2b6808f6e0d482"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v2.11.1/erectl-Darwin-arm64"
      sha256 "0a3b402e7466c03a26ec8c9332d1f7d4a6a754019e5ac77a9f2b6808f6e0d482"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v2.11.1/erectl-Linux-x86_64"
      sha256 "a3f1fcc132df4d8747f9a61c81810a03c8ff96bbda93eca4ab5b9eea74c8124c"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.11.1/erectl-Linux-aarch64"
      sha256 "6fff643ba3bb9ec1420cf36d48ec3ffe50997e286a4a124d7c19b951284b755f"
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
