class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://google.github.io/zx/"
  url "https://registry.npmjs.org/zx/-/zx-8.7.1.tgz"
  sha256 "be5d2cda2fbe0dd41f490e08b7849bfd1a6694820eb55e94f2a6904bd7656363"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cdb6da9d8da9e13091eafff3e13bc3d7ef23c17cebad08114fe1123d1882af53"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.mjs").write <<~JAVASCRIPT
      #!/usr/bin/env zx

      let name = YAML.parse('foo: bar').foo
      console.log(`name is ${name}`)
      await $`touch ${name}`
    JAVASCRIPT

    output = shell_output("#{bin}/zx #{testpath}/test.mjs")
    assert_match "name is bar", output
    assert_path_exists testpath/"bar"

    assert_match version.to_s, shell_output("#{bin}/zx --version")
  end
end
