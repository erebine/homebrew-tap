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
      url "https://github.com/Erebine/binaries/releases/download/v3.3.7/erebine-eem-Darwin-arm64"
      sha256 "700c681c490b19b5fb09299f0d07eb39c3ab95ea3ea0986e5b3dc440cc618329"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.7/erebine-eem-Darwin-arm64"
      sha256 "700c681c490b19b5fb09299f0d07eb39c3ab95ea3ea0986e5b3dc440cc618329"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.7/erebine-eem-Linux-x86_64"
      sha256 "b27800a4f92eb7f683f148972c2cfec9d0bbfc7c6953416b395013f66d9ab91b"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.7/erebine-eem-Linux-aarch64"
      sha256 "c68b5a7c993722e9b371c2a98e40f2be6cda4cd6c1c2dd7978a1c1850388e8ca"
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
