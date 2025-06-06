class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "d8f1b3b61f65b6dabe174dc4c35e7faac2832a5c228687060bf26492c1a5b537"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "487fce7c4509790fb13f0c9ff14c47458c44c7d7c36efc93aed56175c923dbb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "487fce7c4509790fb13f0c9ff14c47458c44c7d7c36efc93aed56175c923dbb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "487fce7c4509790fb13f0c9ff14c47458c44c7d7c36efc93aed56175c923dbb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "38903bee9d50f8d831f923752683255e976e513c1d24cfcccf76d4bde4b59d17"
    sha256 cellar: :any_skip_relocation, ventura:       "38903bee9d50f8d831f923752683255e976e513c1d24cfcccf76d4bde4b59d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47508db4bd1f0a37c569fa41e7c92d275fdc2a9e8aec6529b64da19a67f4b19e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end
