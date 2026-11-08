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
      url "https://github.com/Erebine/binaries/releases/download/v3.2.0/erebine-eem-Darwin-arm64"
      sha256 "2f6ac3e7f0ec1a72ecf15c2a892a9ac3644325d00a4a69ace574a201bd6ad15c"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.2.0/erebine-eem-Darwin-arm64"
      sha256 "2f6ac3e7f0ec1a72ecf15c2a892a9ac3644325d00a4a69ace574a201bd6ad15c"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.2.0/erebine-eem-Linux-x86_64"
      sha256 "c22f8a741e05aa79f71d5cb15b9fd50fa1dd36f960eac5ab607b69649b14e770"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.2.0/erebine-eem-Linux-aarch64"
      sha256 "34098693cc7b218c9e14e7c6bfb941d12542d952cda107ccaa517858819adaec"
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
