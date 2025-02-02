class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.35.0.tar.gz"
  sha256 "2cad6b85612f7c9f4cc980cae019e1ff9a2f1df614f469d075441cf3da79e9d2"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "10e16b5a0d98451f8bf9fdc96ac7d5cbc2ea9735e086c4607141c9c3f8ad49ab" => :catalina
    sha256 "6b1cef0962a90cc8a1df0a2763a8a0bcc07ccc0677f6f7ea5acb8ebabb84d5c0" => :mojave
    sha256 "2a54d17165cebdc6e3ab3e296d94d15da2483ea531e1dce494a5ba5721512376" => :high_sierra
    sha256 "d2ad72190d95f3c605d49641be009e0f44ddb2b9b370292e606e10bbdd1fd7d3" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    doctl_version = version.to_s.split(/\./)

    src = buildpath/"src/github.com/digitalocean/doctl"
    src.install buildpath.children
    src.cd do
      base_flag = "-X github.com/digitalocean/doctl"
      ldflags = %W[
        #{base_flag}.Major=#{doctl_version[0]}
        #{base_flag}.Minor=#{doctl_version[1]}
        #{base_flag}.Patch=#{doctl_version[2]}
        #{base_flag}.Label=release
      ].join(" ")
      system "go", "build", "-ldflags", ldflags, "-o", bin/"doctl", "github.com/digitalocean/doctl/cmd/doctl"
    end

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
