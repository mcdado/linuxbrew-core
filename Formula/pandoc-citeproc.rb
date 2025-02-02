require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.16.4/pandoc-citeproc-0.16.4.tar.gz"
  sha256 "8c807dc073ea03137b859f32d3438cef989f0502de12c7bc65885f53a487d356"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "09d86750536112710486f090ec39e3f6b09eae3736a0ec6c3fd8b4dca15f9d7d" => :catalina
    sha256 "b2f54ed9de019cb998df0c2c1040975682de3ff0191a324312ace64cef778285" => :mojave
    sha256 "ae6ce3ab98af7c720c17f1df18664ba8f19360a18fde1eddc7c3a72e52097f98" => :high_sierra
    sha256 "1f9ee64df7e7d2a28068f228d442f4ca4e8c264880334c2a6841ee257be7ecd5" => :x86_64_linux
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"
  depends_on "unzip" => :build unless OS.mac?

  def install
    install_cabal_package
  end

  test do
    (testpath/"test.bib").write <<~EOS
      @Book{item1,
      author="John Doe",
      title="First Book",
      year="2005",
      address="Cambridge",
      publisher="Cambridge University Press"
      }
    EOS
    expected = <<~EOS
      ---
      references:
      - id: item1
        type: book
        author:
        - family: Doe
          given: John
        issued:
        - year: 2005
        title: First book
        publisher: Cambridge University Press
        publisher-place: Cambridge
      ...
    EOS
    assert_equal expected, shell_output("#{bin}/pandoc-citeproc -y test.bib")
  end
end
