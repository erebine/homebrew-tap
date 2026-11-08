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
      url "https://github.com/Erebine/binaries/releases/download/v3.2.0/erebine-eim-Darwin-arm64"
      sha256 "ebca68bb88cfba675e82e66719c2f0d51bdcbc9cb50d1714e8606f79b0da06e9"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.2.0/erebine-eim-Darwin-arm64"
      sha256 "ebca68bb88cfba675e82e66719c2f0d51bdcbc9cb50d1714e8606f79b0da06e9"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.2.0/erebine-eim-Linux-x86_64"
      sha256 "03dce2515de679cec495e232e1d1aae66ca3889c1347e1c776b876caca06235b"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.2.0/erebine-eim-Linux-aarch64"
      sha256 "81ae0acd1719003dd50a4e6a5193401735448708086e863529d805d0ea1ed7e1"
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
