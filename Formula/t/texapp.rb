class Texapp < Formula
  desc "App.net client based on TTYtter"
  homepage "https://www.floodgap.com/software/texapp/"
  url "https://www.floodgap.com/software/texapp/dist0/0.6.11.txt"
  sha256 "03c3d5475dfb7877000ce238d342023aeab3d44f7bac4feadc475e501aa06051"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92f9ae64e6e0a3fd143ecb1b8a77dc8d752002f8c9f19105034adfb3ad39f6a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3de41340c8be2327e079f024ac9c4cc0ebe27c937934f827b53c20869cebbf88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3de41340c8be2327e079f024ac9c4cc0ebe27c937934f827b53c20869cebbf88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f347b14baaf4d85e9cb2e1655b14e56734f2155dd450a47c66a93a2103f4528b"
    sha256 cellar: :any_skip_relocation, sonoma:         "92f9ae64e6e0a3fd143ecb1b8a77dc8d752002f8c9f19105034adfb3ad39f6a0"
    sha256 cellar: :any_skip_relocation, ventura:        "3de41340c8be2327e079f024ac9c4cc0ebe27c937934f827b53c20869cebbf88"
    sha256 cellar: :any_skip_relocation, monterey:       "3de41340c8be2327e079f024ac9c4cc0ebe27c937934f827b53c20869cebbf88"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb4cd0f1075e83c70659b71c6700819d3fa8004fdf9159081fc02258ff656e4d"
    sha256 cellar: :any_skip_relocation, catalina:       "416f71ee320ac9efd58e5da5cb91cae807c61d542e90ad624bc778e4b060dfed"
    sha256 cellar: :any_skip_relocation, mojave:         "8d0f4b422910cdff2f791a2c7e916f2dfc001bb060b2e43760c3db8bb7f1ac3f"
    sha256 cellar: :any_skip_relocation, high_sierra:    "6615c40b9f733227163ad90b0082c40e7a5885c8ffa36dcb6c5892c09367c279"
    sha256 cellar: :any_skip_relocation, sierra:         "6615c40b9f733227163ad90b0082c40e7a5885c8ffa36dcb6c5892c09367c279"
    sha256 cellar: :any_skip_relocation, el_capitan:     "6615c40b9f733227163ad90b0082c40e7a5885c8ffa36dcb6c5892c09367c279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3de41340c8be2327e079f024ac9c4cc0ebe27c937934f827b53c20869cebbf88"
  end

  # website now shows "The last moments of App.net global, as witnessed from Texapp"
  disable! date: "2024-02-15", because: :repo_archived

  def install
    bin.install "#{version}.txt" => "texapp"
  end

  test do
    assert_match "trying to find cURL ...", pipe_output(bin/"texapp", "^C")
  end
end
