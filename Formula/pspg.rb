class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.6.0.tar.gz"
  sha256 "02029132144552914a9aa1d813cd1bdbf3612e13f362a49f3ef4bf63007760aa"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "635a6c2304a3f4f3edb8a00020f37c265ac3be27f7c599059334afaa017a78da" => :catalina
    sha256 "c2fea23e4da00501c1dd89bbf4c22618e77d455b49cf39046163a0c9b8313630" => :mojave
    sha256 "351b781a01908ecee72be4f42683c858859a003fc6d804b274f4e38d7f424aeb" => :high_sierra
    sha256 "cb8a8b98d97efa1e5375fbe15421d581e065c89bc67cf8a8b3089c25d42cc011" => :x86_64_linux
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    Add the following line to your psql profile (e.g. ~/.psqlrc)
      \\setenv PAGER pspg
      \\pset border 2
      \\pset linestyle unicode
  EOS
  end

  test do
    assert_match "pspg-#{version.to_f}", shell_output("#{bin}/pspg --version")
  end
end
