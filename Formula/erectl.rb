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
      url "https://github.com/Erebine/binaries/releases/download/v3.3.4/erectl-Darwin-arm64"
      sha256 "1e8e84498728b2ac45128d40d3a61eed71f23989a342ba2d10a258cb6b9fa362"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.4/erectl-Darwin-arm64"
      sha256 "1e8e84498728b2ac45128d40d3a61eed71f23989a342ba2d10a258cb6b9fa362"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.4/erectl-Linux-x86_64"
      sha256 "844069f8e6de1afe612c3c269d336c3a31b285ca1f38a1396ce7d24dd7cd855d"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.4/erectl-Linux-aarch64"
      sha256 "54e91484832197258622eb4ee8decd8c4149bb5b642aac3b115febb8fb74cd2c"
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
