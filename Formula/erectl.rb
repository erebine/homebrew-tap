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
      url "https://github.com/Erebine/binaries/releases/download/v3.3.0/erectl-Darwin-arm64"
      sha256 "30500f30fd03744d93100ca3d58ddeab1e03340896d4c7d0e838835bb55e1848"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.0/erectl-Darwin-arm64"
      sha256 "30500f30fd03744d93100ca3d58ddeab1e03340896d4c7d0e838835bb55e1848"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.0/erectl-Linux-x86_64"
      sha256 "f14e5ee6f89ad0950a43de95391b114784868a4572179035b95f7262854dd9fa"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.0/erectl-Linux-aarch64"
      sha256 "ad1c2a9a34a6a0969f282bad9d92c0f21db815296d23cbb7df9fd16a16988ca5"
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
