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
      url "https://github.com/Erebine/binaries/releases/download/v3.6.0/erectl-Darwin-arm64"
      sha256 "dbd8863bb9fd2995c98bbf9cca9649eacf7722ae4a26e642b68bc8240f9bbb33"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.0/erectl-Darwin-arm64"
      sha256 "dbd8863bb9fd2995c98bbf9cca9649eacf7722ae4a26e642b68bc8240f9bbb33"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.0/erectl-Linux-x86_64"
      sha256 "b342e67dbc569e13f8f6aecbfa3a02fe8f34edfbaa3fee6cd973387afaf31683"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.0/erectl-Linux-aarch64"
      sha256 "fde067394e32bd62d468885a805de4d320f2a6b38dfcace886820a4127e0b669"
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
