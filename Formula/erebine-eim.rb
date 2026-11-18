# SPDX-License-Identifier: MIT
# Prebuilt erebine-eim binary, the Erebine Inference Microservice (EIM), from
# Erebine/binaries releases. Renamed from erebine-eim-agent in 2.10; see
# formula_renames.json.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEim < Formula
  desc "Erebine Inference Microservice (EIM)"
  homepage "https://erebine.ai"
  license "MIT"

  depends_on "zeromq"
  depends_on "zstd"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.5.0/erebine-eim-Darwin-arm64"
      sha256 "7df46e31128119eb258a94426d2f19e1b384841c3c6bf50dc5f7e19f1e1f3065"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.5.0/erebine-eim-Darwin-arm64"
      sha256 "7df46e31128119eb258a94426d2f19e1b384841c3c6bf50dc5f7e19f1e1f3065"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.5.0/erebine-eim-Linux-x86_64"
      sha256 "534182e4222e37fce15cc0a9f32542695ef01a4deaf63a44b3ec079dd848a9e9"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.5.0/erebine-eim-Linux-aarch64"
      sha256 "5da4c99ae5ba2aac243d94df67c4f1c3a692207a0ee83e95388ed8748781915c"
    end
  end

  def install
    binary = Dir["erebine-eim-*"].first
    # The Linux build finds libzmq and libzstd by soname in the loader's
    # default path, where Homebrew's are not: add their opt directories to
    # its RUNPATH, after the $ORIGIN the build set.
    if OS.linux?
      rpath = %w[zeromq zstd].map { |dep| formula_opt_lib(dep) }.join(":")
      system "patchelf", "--add-rpath", rpath, binary
    end
    bin.install binary => "erebine-eim"
    # The pre-2.10 name, for the units and scripts that still call it.
    bin.install_symlink "erebine-eim" => "erebine-eim-agent"
  end

  test do
    system bin/"erebine-eim", "--help"
    assert_path_exists bin/"erebine-eim-agent"
  end
end
