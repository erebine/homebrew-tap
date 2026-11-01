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
      url "https://github.com/Erebine/binaries/releases/download/v2.10.1/erebine-eem-Darwin-arm64"
      sha256 "9a3dd28f3f3e11d1083fa80b47021d95bcfe635a6092e5718ce342566d41e63e"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v2.10.1/erebine-eem-Darwin-arm64"
      sha256 "9a3dd28f3f3e11d1083fa80b47021d95bcfe635a6092e5718ce342566d41e63e"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v2.10.1/erebine-eem-Linux-x86_64"
      sha256 "5f1a5d62e2ad0dcc26fd27405bc89f634cc87e186ec972ed193eca8627443ec7"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.10.1/erebine-eem-Linux-aarch64"
      sha256 "8e2ff2c72163ec62a0b1d239ae70d92b2afc9a9040f00b972af531874d4b0d6f"
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
