class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.113.0.tar.gz"
  sha256 "c3fe9e0e95b28a9d4648508999ef2d89fbf46732ec7e9484537026ff62b18b62"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f858a0b8c5d7605d4dc93725acb5726d3a4b53db8341180c325d2d9a391d1fb" => :catalina
    sha256 "0baefb8645467160e55b2cb06dcd0209b2283aa5579924b803cff32ddda5bbac" => :mojave
    sha256 "acad156f495d7af5b7965045ed58a7a877fb62013ec3abb0da0f7f84317fc51c" => :high_sierra
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build
  unless OS.mac?
    depends_on "m4" => :build
    depends_on "rsync" => :build
    depends_on "unzip" => :build
    depends_on "elfutils"
  end

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
