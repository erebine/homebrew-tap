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
      url "https://github.com/Erebine/binaries/releases/download/v3.3.2/erectl-Darwin-arm64"
      sha256 "188ed6c0a0cb2142f3707fa3fed56e738a7845191aee801dd6fe0771eef43980"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.2/erectl-Darwin-arm64"
      sha256 "188ed6c0a0cb2142f3707fa3fed56e738a7845191aee801dd6fe0771eef43980"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.2/erectl-Linux-x86_64"
      sha256 "43559014efadb4da01e93650f247832b95ae4661943d8f5f24db9b05dc631b70"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.2/erectl-Linux-aarch64"
      sha256 "a9a2a6ee86658071927c4122889f593aa336c5d5280d4300a508166ca947b6b3"
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
