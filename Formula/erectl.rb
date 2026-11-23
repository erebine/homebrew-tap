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
      url "https://github.com/Erebine/binaries/releases/download/v3.6.1/erectl-Darwin-arm64"
      sha256 "f94c9caeea9b0705e8690e4a23236aa08ddc2d7f7b19942722d31cc3249221d8"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.1/erectl-Darwin-arm64"
      sha256 "f94c9caeea9b0705e8690e4a23236aa08ddc2d7f7b19942722d31cc3249221d8"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.1/erectl-Linux-x86_64"
      sha256 "4c387fa5ddcf1159ff46823869adb9de1063d68fc5b8b79817a2a7acdc700d54"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.1/erectl-Linux-aarch64"
      sha256 "bde72d2b2488bedd6a83b524f2f3f46a3751db88dc5d215fa4c78804bc8cecb4"
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
