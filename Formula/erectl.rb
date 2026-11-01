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
      url "https://github.com/Erebine/binaries/releases/download/v2.10.0/erectl-Darwin-arm64"
      sha256 "b2023d7adb80e27b6f5b23c0fa60545a088131b4fd20f8161aee490250e46a67"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v2.10.0/erectl-Darwin-arm64"
      sha256 "b2023d7adb80e27b6f5b23c0fa60545a088131b4fd20f8161aee490250e46a67"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v2.10.0/erectl-Linux-x86_64"
      sha256 "a7eac2156382390f9071efb1b58bd6351b955dd85a3a5e19fa386ad959c751e5"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.10.0/erectl-Linux-aarch64"
      sha256 "20711a3bda61cda77e822f54feb1a843d1d5dbdf59b229dbf89c79089f7beef1"
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
