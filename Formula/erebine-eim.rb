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
      url "https://github.com/Erebine/binaries/releases/download/v3.6.4/erebine-eim-Darwin-arm64"
      sha256 "22503ff43bcf18cb04fc9292bf3f1bdfcc916b9143c819d644b942f22ec0d4f5"
    end
    # There is no Intel macOS build. Homebrew loads a formula only when
    # it has a url for the running system, so this repeats the arm64
    # block and an Intel Mac stops on the arm64 requirement above.
    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.4/erebine-eim-Darwin-arm64"
      sha256 "22503ff43bcf18cb04fc9292bf3f1bdfcc916b9143c819d644b942f22ec0d4f5"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_intel do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.4/erebine-eim-Linux-x86_64"
      sha256 "d6d342c2ec6c952c4e58af320be6b87c1730533cc77c4fb3b0280cd733bcf588"
    end
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v3.6.4/erebine-eim-Linux-aarch64"
      sha256 "8d0e82bddb472a735adf5899f0d919f1d893de0f739fc61f728cf12696fae011"
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
