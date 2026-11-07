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
      url "https://github.com/Erebine/binaries/releases/download/v3.1.0/erectl-Darwin-arm64"
      sha256 "5a70f4b3ea06cc209d1970a02bac28f83b8a89a7a51a5f77c8afa5e0f4e0dc0a"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.1.0/erectl-Darwin-arm64"
      sha256 "5a70f4b3ea06cc209d1970a02bac28f83b8a89a7a51a5f77c8afa5e0f4e0dc0a"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.1.0/erectl-Linux-x86_64"
      sha256 "ee67d37c1839e7773f59db86b4875ccada4aab0a7754a8935bac06124b42f5b7"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.1.0/erectl-Linux-aarch64"
      sha256 "ae168453c5921ba89806313e98d56b4fe411d5895ec78c5c486e09681cde4fbe"
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
