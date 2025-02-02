class Osc < Formula
  include Language::Python::Virtualenv

  desc "The command-line interface to work with an Open Build Service"
  homepage "https://github.com/openSUSE/osc"
  url "https://github.com/openSUSE/osc/archive/0.166.2.tar.gz"
  sha256 "fe4cfb84accf305692a31c288204b9e7a14a544bb01ae14a7ce9bfe05589b18d"
  head "https://github.com/openSUSE/osc.git"

  bottle do
    cellar :any
    sha256 "235bb8763edf360326f214d9607bc8e772cbe58108520ad3fee267d1c02b690d" => :catalina
    sha256 "c51b9342a906a10fe69d7fc7ae3401b91e3b0e918865e7e0888ac091d4f49e0f" => :mojave
    sha256 "b73d5d5d9c8eaf3e9543a6cec703b62621986d7e99147e8355ac282346ae03dc" => :high_sierra
    sha256 "d5bd4ab1f331fce77ca1986070153614203ed63f7ac52af631f5ced20b890212" => :x86_64_linux
  end

  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python"
  uses_from_macos "curl"

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/74/18/3beedd4ac48b52d1a4d12f2a8c5cf0ae342ce974859fba838cbbc1580249/M2Crypto-0.35.2.tar.gz"
    sha256 "4c6ad45ffb88670c590233683074f2440d96aaccb05b831371869fc387cbd127"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/67/b0/b2ea2bd67bfb80ea5d12a5baa1d12bda002cab3b6c9b48f7708cd40c34bf/typing-3.7.4.1.tar.gz"
    sha256 "91dfe6f3f706ee8cc32d38edbbf304e9b7583fb37108fef38229617f8b3eba23"
  end

  def install
    ENV["SWIG_FEATURES"]="-I#{Formula["openssl@1.1"].opt_include}"

    # Fix building of M2Crypto on High Sierra https://github.com/Homebrew/homebrew-core/pull/45895#issuecomment-557200007
    ENV.delete("HOMEBREW_SDKROOT") if MacOS.version == :high_sierra

    inreplace "osc/conf.py", "'/etc/ssl/certs'", "'#{etc}/openssl/cert.pem'"
    virtualenv_install_with_resources
    mv bin/"osc-wrapper.py", bin/"osc"
  end

  test do
    system bin/"osc", "--version"
  end
end
