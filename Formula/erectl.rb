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
      url "https://github.com/Erebine/binaries/releases/download/v3.2.0/erectl-Darwin-arm64"
      sha256 "6282e98cb1e637974a633e23233fb6368926e4a4f4bfc3be607ccb0703d789a2"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.2.0/erectl-Darwin-arm64"
      sha256 "6282e98cb1e637974a633e23233fb6368926e4a4f4bfc3be607ccb0703d789a2"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.2.0/erectl-Linux-x86_64"
      sha256 "5a7e94d5b33fd4a13da8417a87fd6a2276d9845e2d61a28764b272b9402fc449"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.2.0/erectl-Linux-aarch64"
      sha256 "9317d08c7e3e778982b6bea86f690541e58a202931153e769d12c31d0d43536c"
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
