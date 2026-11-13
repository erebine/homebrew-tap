# SPDX-License-Identifier: MIT
# Prebuilt erebine-eem binary, the Erebine Execution Manager (EEM), from
# Erebine/binaries releases. Renamed from erebine-eem-agent in 2.10; see
# formula_renames.json.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEem < Formula
  desc "Erebine Execution Manager (EEM)"
  homepage "https://erebine.ai"
  license "MIT"

  depends_on "zeromq"
  depends_on "zstd"

  uses_from_macos "curl"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.9/erebine-eem-Darwin-arm64"
      sha256 "9aa6df528da513ecbc8700e7c121b5e90ad2d59c0e78d1d7f8a5d96c47f80c4e"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.9/erebine-eem-Darwin-arm64"
      sha256 "9aa6df528da513ecbc8700e7c121b5e90ad2d59c0e78d1d7f8a5d96c47f80c4e"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.9/erebine-eem-Linux-x86_64"
      sha256 "89ba696090d5d2b787b63fec61aa7c22858c59d7035b8198ced62c7e770a00f0"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.9/erebine-eem-Linux-aarch64"
      sha256 "6516a3f97bdaf87bee52eb9a2a5af320dccde3ec9bdc9d4796eb0a7c4d0a48e2"
    end
  end

  def install
    binary = Dir["erebine-eem-*"].first
    # The Linux build finds libzmq, libzstd and libcurl by soname in the loader's
    # default path, where Homebrew's are not: add their opt directories to
    # its RUNPATH, after the $ORIGIN the build set.
    if OS.linux?
      rpath = %w[zeromq zstd curl].map { |dep| formula_opt_lib(dep) }.join(":")
      system "patchelf", "--add-rpath", rpath, binary
    end
    bin.install binary => "erebine-eem"
    # The pre-2.10 name, for the units and scripts that still call it.
    bin.install_symlink "erebine-eem" => "erebine-eem-agent"
  end

  test do
    system bin/"erebine-eem", "--help"
    assert_path_exists bin/"erebine-eem-agent"
  end
end
