class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-19.11.1.tar.gz"
  sha256 "d3744fe7596f14dcbce550f592b3b699ce9ec216edecd2e4f5380b4b0d562fd6"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    cellar :any
    sha256 "6538212a18e24c5450ab5c78054089b22ae96b0affc58df57da435ca6463c0a4" => :catalina
    sha256 "9045f4071191fdc2ab09f5c930f43251abe29d8ebb5e944f28574e651953830d" => :mojave
    sha256 "7107a38f3a94689606f75d5d956af91c181d917ec580a7359eeed552a61bc37e" => :high_sierra
    sha256 "c1d33b0c333798bdff602a6021d2df44da2c5c6b9b5736394e687d87e149b872" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "wxmac"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    prefix.install "wxMaxima.app" if OS.mac?

    bash_completion.install "data/wxmaxima"
  end

  def caveats; <<~EOS
    When you start wxMaxima the first time, set the path to Maxima
    (e.g. #{HOMEBREW_PREFIX}/bin/maxima) in the Preferences.

    Enable gnuplot functionality by setting the following variables
    in ~/.maxima/maxima-init.mac:
      gnuplot_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
      draw_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
  EOS
  end

  test do
    # Test is disbaled on Linux as circle has no X (Error: Unable to initialize GTK+, is DISPLAY set properly)
    assert_match "algebra", shell_output("#{bin}/wxmaxima --help 2>&1", 255) if OS.mac?
  end
end
