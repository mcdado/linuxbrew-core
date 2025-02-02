require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.7.0.tgz"
  sha256 "dc837b00c13f7f428e53b1e087571d3ca9c852e09ca7a2ed094adfc0e685c770"
  head "https://github.com/teambit/bit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6656343f7a44a0e1c5bbdb79b1e417683c68d8cb6f995a229178adb2fbb3c15d" => :catalina
    sha256 "551e000c90e0401fafb7516d9c072ba884ba74d1da364f0013b14f05768cf7ca" => :mojave
    sha256 "593fb3b40f9a31fee227f09d4a4e2e5108b9c8cd05096216fb8458b838fa1237" => :high_sierra
    sha256 "e17f914796401c671e26d62872269212e49164be90f7915c3cb70542871b80a6" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"Library/Caches/Bit/config/config.json").write <<~EOS
      { "analytics_reporting": false, "error_reporting": false }
    EOS
    output = shell_output("#{bin}/bit init --skip-update")
    assert_match "successfully initialized", output
  end
end
