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
      url "https://github.com/Erebine/binaries/releases/download/v3.2.1/erectl-Darwin-arm64"
      sha256 "dea56fdcc67b945aa044c7defeb121d16ecb4353421025fa65b8a684184b12bb"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.2.1/erectl-Darwin-arm64"
      sha256 "dea56fdcc67b945aa044c7defeb121d16ecb4353421025fa65b8a684184b12bb"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.2.1/erectl-Linux-x86_64"
      sha256 "2dee8dc975f6e530ac45380cb7aea8d63a22a6ed0162cad116056699a448dd71"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.2.1/erectl-Linux-aarch64"
      sha256 "8e5b396a9430b268bc872698940ab170d67d2464ce44ff115f32a83b95e2853f"
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
