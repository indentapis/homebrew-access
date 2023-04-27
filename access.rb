class Access < Formula
  desc "Easiest way to request and grant access without leaving your terminal"
  homepage "https://indent.com"
  url "https://github.com/indentapis/access.git",
      tag:      "v0.10.8",
      revision: "a124ea66f8fb8f798de28635458dfe2fb3362bd0"
  license "Apache-2.0"
  head "https://github.com/indentapis/access.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.GitVersion=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/access"

    # Install shell completions
    generate_completions_from_executable(bin/"access", "completion")
  end

  test do
    test_file = testpath/"access.yaml"
    test_file.write("")
    Dir.chdir(testpath) do
      system "#{bin}/access", "config", "set", "space", "some-space"
    end
    assert_equal "space: some-space", File.read(test_file).strip
  end
end
