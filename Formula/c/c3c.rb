class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://github.com/c3lang/c3c"
  url "https://github.com/c3lang/c3c/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "f84cb31954100e8b9af67e6d8f8ab66526964c07230c1cbc4ab9a16102d84562"
  license "LGPL-3.0-only"
  revision 1
  head "https://github.com/c3lang/c3c.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "4e3e81a90f428a524fb1fe247fd09b9c7044a79f81e625767ac7ef9a837c3441"
    sha256 cellar: :any, arm64_sonoma:  "000442a03f72526350dac1b6ceeb86cbebd11f2fb71c692cd038e73b9aa3c1c3"
    sha256 cellar: :any, arm64_ventura: "6546943258ad231be505b55ce876eac74f0e3b0800f374b458dce3c436ca2686"
    sha256 cellar: :any, sonoma:        "e50318e100d1251b8fad71ebe1f32a4f8f6c1b32490a183c0e577bf00ac62e13"
    sha256 cellar: :any, ventura:       "be87e459a83fdda796d2440f8ab043bcba84c699acdcbf809450cfdd7a2e9f62"
    sha256               arm64_linux:   "4ca837fed3ad2e3c3a5963dd4ddc046d5d029e7cc6192ae8b44652931afc613e"
    sha256               x86_64_linux:  "d2cf20c5ef48945abec0073efcd6627bd7c3497ac2e7b73b65e3ed5e1c6e142b"
  end

  depends_on "cmake" => :build
  depends_on "lld"
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  # Linking dynamically with LLVM fails with GCC.
  fails_with :gcc

  def install
    args = [
      "-DC3_LINK_DYNAMIC=ON",
      "-DC3_USE_MIMALLOC=OFF",
      "-DC3_USE_TB=OFF",
      "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
      "-DLLVM=#{Formula["llvm"].opt_lib/shared_library("libLLVM")}",
      "-DLLD_COFF=#{Formula["lld"].opt_lib/shared_library("liblldCOFF")}",
      "-DLLD_COMMON=#{Formula["lld"].opt_lib/shared_library("liblldCommon")}",
      "-DLLD_ELF=#{Formula["lld"].opt_lib/shared_library("liblldELF")}",
      "-DLLD_MACHO=#{Formula["lld"].opt_lib/shared_library("liblldMachO")}",
      "-DLLD_MINGW=#{Formula["lld"].opt_lib/shared_library("liblldMinGW")}",
      "-DLLD_WASM=#{Formula["lld"].opt_lib/shared_library("liblldWasm")}",
    ]

    ENV.append "LDFLAGS", "-lzstd -lz"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    return unless OS.mac?

    # The build copies LLVM runtime libraries into its `bin` directory.
    # Let's replace those copies with a symlink instead.
    libexec.install bin.children
    bin.install_symlink libexec.children.select { |child| child.file? && child.executable? }
    rm_r libexec/"c3c_rt"
    llvm = Formula["llvm"]
    libexec.install_symlink llvm.opt_lib/"clang"/llvm.version.major/"lib/darwin" => "c3c_rt"
  end

  test do
    (testpath/"test.c3").write <<~EOS
      module hello_world;
      import std::io;

      fn void main()
      {
        io::printn("Hello, world!");
      }
    EOS
    system bin/"c3c", "compile", "test.c3", "-o", "test"
    assert_match "Hello, world!", shell_output("#{testpath}/test")
  end
end
