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
      url "https://github.com/Erebine/binaries/releases/download/v2.11.0/erectl-Darwin-arm64"
      sha256 "a1eaf3eb905276c12da739406ad49cc999538c89004f6ead9dac48baf0de7af1"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v2.11.0/erectl-Darwin-arm64"
      sha256 "a1eaf3eb905276c12da739406ad49cc999538c89004f6ead9dac48baf0de7af1"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v2.11.0/erectl-Linux-x86_64"
      sha256 "783b56276cab92e9119bb6b67a11b4cc486dfcaecdd8de6735447706a3af5086"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.11.0/erectl-Linux-aarch64"
      sha256 "c448cfec067400c2aaa6c721412a04a55d9c342e10db73775e2ea62c0cab0ff7"
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
