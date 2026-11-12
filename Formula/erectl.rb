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
      url "https://github.com/Erebine/binaries/releases/download/v3.3.6/erectl-Darwin-arm64"
      sha256 "b9030c15e69e16672d6f94cfc6cb9cc78866b493cd2db5146f20b9a70881573f"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.6/erectl-Darwin-arm64"
      sha256 "b9030c15e69e16672d6f94cfc6cb9cc78866b493cd2db5146f20b9a70881573f"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.6/erectl-Linux-x86_64"
      sha256 "3ca3c8899ef5bf325044a31d7949a581862d37641103a61be3ec9149b04535bd"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.6/erectl-Linux-aarch64"
      sha256 "a66f81d7163ee2c62db653e21461bc570033b00f0c1147793b49dbb387c6c5e0"
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
