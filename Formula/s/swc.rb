class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.11.11.tar.gz"
  sha256 "c876e2407e712b58b3a226e3bf79367198a4a7d5f64b0614e2aa7ea792d66531"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1cfe540724d45503f37b0cb28cd69d584f721d607962b4adcee3d8754393565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be4dfbabc9fdfe7facd496149a7e3967779b6926c107a4e84e64f925afaf0792"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4921d9c3ea6da71df044301ba35386ac4ad4c86c801dafba8352658798096cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f03679aeb9a8b3f91501683e5fcf015de7c24518d977c2d740d24a4075250d9b"
    sha256 cellar: :any_skip_relocation, ventura:       "a0520c2202d4d23bb42c41a817edfdd4bb525f4bf565a41adf3a8b6b73a1d299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "301c0a588a612ba1454ceaefda6051eb8bc42b6d9c95f427a5366a6b4469dd9a"
  end

  depends_on "rust" => :build

  def install
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/swc_cli_impl")
  end

  test do
    (testpath/"test.js").write <<~JS
      const x = () => 42;
    JS

    system bin/"swc", "compile", "test.js", "--out-file", "test.out.js"
    assert_path_exists testpath/"test.out.js"

    output = shell_output("#{bin}/swc lint 2>&1", 101)
    assert_match "Lint command is not yet implemented", output
  end
end
