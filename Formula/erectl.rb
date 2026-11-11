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
      url "https://github.com/Erebine/binaries/releases/download/v3.3.3/erectl-Darwin-arm64"
      sha256 "6020f9291c1ee543b8ffeba93f38f6b7305665de307d42a85a6f6c1712687d9c"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.3/erectl-Darwin-arm64"
      sha256 "6020f9291c1ee543b8ffeba93f38f6b7305665de307d42a85a6f6c1712687d9c"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.3/erectl-Linux-x86_64"
      sha256 "71d2dfe4b9181990b700cf594cd8300013f0b13779023a97e4dcd2d52f454240"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.3/erectl-Linux-aarch64"
      sha256 "4f4569f91dc1aba3487e33332494b8507322665e947601e3e6ee56c38cbb0bda"
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
