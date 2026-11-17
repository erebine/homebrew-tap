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
      url "https://github.com/Erebine/binaries/releases/download/v3.4.1/erebine-eem-Darwin-arm64"
      sha256 "533496dea06688efb879090e024048850f8bf0861ed11dc5c5f34331d7c3db4a"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.4.1/erebine-eem-Darwin-arm64"
      sha256 "533496dea06688efb879090e024048850f8bf0861ed11dc5c5f34331d7c3db4a"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.4.1/erebine-eem-Linux-x86_64"
      sha256 "22938e8a8abe4032dbf97076d4ff1c0b4160ab19169d8dca120d517a9f7bcdf1"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.4.1/erebine-eem-Linux-aarch64"
      sha256 "5fbdbb5467f8863856e7d3c78a9e3fd7fe09ad2aab05e2360a48a1e56862559c"
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
