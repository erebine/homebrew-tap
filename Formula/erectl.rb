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
      url "https://github.com/Erebine/binaries/releases/download/v3.5.2/erectl-Darwin-arm64"
      sha256 "53b2b3baf92d8608c98cfd6c4f684d3f65f8c3a2ff40cc3234820487aabe9d0b"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.5.2/erectl-Darwin-arm64"
      sha256 "53b2b3baf92d8608c98cfd6c4f684d3f65f8c3a2ff40cc3234820487aabe9d0b"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.5.2/erectl-Linux-x86_64"
      sha256 "ccf86bd75af4246b957ce528592cb26e9aa19f79a527cdbe6dd433d5934b4c14"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.5.2/erectl-Linux-aarch64"
      sha256 "40e9eac7c0f161036b0119fa8968cf7fbfbbfc56479265889821177115fb4013"
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
