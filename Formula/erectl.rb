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
      url "https://github.com/Erebine/binaries/releases/download/v3.3.1/erectl-Darwin-arm64"
      sha256 "eb5fa8f752acd80159630b1cbfb46cc07f4a5647762da86186fa3138de69ac0a"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.1/erectl-Darwin-arm64"
      sha256 "eb5fa8f752acd80159630b1cbfb46cc07f4a5647762da86186fa3138de69ac0a"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.1/erectl-Linux-x86_64"
      sha256 "22c01dc1311692ce0a5d3ab61f8a01e0fa32faeeecb6ce4b03390a32024e8ac0"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.1/erectl-Linux-aarch64"
      sha256 "39552eb30adcabe72599afc24f0d18d1c6ae754a1f4979cc7f9b6602e664b09f"
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
