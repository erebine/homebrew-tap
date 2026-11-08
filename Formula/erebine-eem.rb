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
      url "https://github.com/Erebine/binaries/releases/download/v3.1.2/erebine-eem-Darwin-arm64"
      sha256 "f71f79c464adb9b813c3abc8d52d06ebaa80b8d9ca035fa184e4b13fd7e6deb3"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.1.2/erebine-eem-Darwin-arm64"
      sha256 "f71f79c464adb9b813c3abc8d52d06ebaa80b8d9ca035fa184e4b13fd7e6deb3"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.1.2/erebine-eem-Linux-x86_64"
      sha256 "8af3225d6145296ba9dc794607f11e88478dddd54dbf7dba5db6566bfc5d50b6"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.1.2/erebine-eem-Linux-aarch64"
      sha256 "1c0e6a45c00dc31b95433168feddc8c3f78b23a0473258c2542e9a59060bb354"
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
