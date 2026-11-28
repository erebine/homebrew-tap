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
      url "https://github.com/Erebine/binaries/releases/download/v3.7.0/erectl-Darwin-arm64"
      sha256 "471e6dcbcf8e0f6e3f511c974b81b9a79b5916ae4dc801f98eedc491891dc284"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.7.0/erectl-Darwin-arm64"
      sha256 "471e6dcbcf8e0f6e3f511c974b81b9a79b5916ae4dc801f98eedc491891dc284"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.7.0/erectl-Linux-x86_64"
      sha256 "1534d5121c07e47bfc91b0e6cbe2b833f63af343f9dba76ac41794245a5749a7"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.7.0/erectl-Linux-aarch64"
      sha256 "ab998e3856f6b80353f1a7ac6293b9bf2ebddc56e539a4b2523f94a11e2d87fc"
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
