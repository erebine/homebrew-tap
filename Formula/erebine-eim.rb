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
      url "https://github.com/Erebine/binaries/releases/download/v3.3.7/erebine-eim-Darwin-arm64"
      sha256 "0c634d2ad670e290b218055905b3290736383010c5b629878be1bae21637fda9"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.7/erebine-eim-Darwin-arm64"
      sha256 "0c634d2ad670e290b218055905b3290736383010c5b629878be1bae21637fda9"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.7/erebine-eim-Linux-x86_64"
      sha256 "0176e0730b18df1c5e29b3a7579f7919c4f7a989f1da57e937bc7ede43fb108f"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.3.7/erebine-eim-Linux-aarch64"
      sha256 "ebc3bcdbcc5c59f89f9bd4b67912e764fb77680b1b6ae61acfd4708e70ff46a8"
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
