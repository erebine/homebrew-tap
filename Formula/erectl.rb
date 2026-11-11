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
      url "https://github.com/Erebine/binaries/releases/download/v3.3.5/erectl-Darwin-arm64"
      sha256 "db24b3adf0863d74adec62789c1b7c5c219192c57269cccf56f5a0c58410bf25"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.5/erectl-Darwin-arm64"
      sha256 "db24b3adf0863d74adec62789c1b7c5c219192c57269cccf56f5a0c58410bf25"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.5/erectl-Linux-x86_64"
      sha256 "2f78d062e366d765589d2a22b64b929578de0317bb0313b6a22c8a9a6add4fe7"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.5/erectl-Linux-aarch64"
      sha256 "55dc84f22e311a712e7081ed31d4af8a1a1a1d1f21173c77e8d9e5e5e2aab41d"
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
