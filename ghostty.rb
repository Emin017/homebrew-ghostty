# ghostty.rb
class Ghostty < Formula
  desc "Terminal emulator that uses platform-native UI and GPU acceleration"
  homepage "https://ghostty.org"
  license "MIT"
  head "https://github.com/ghostty-org/ghostty.git", branch: "main"

  def caveats
    <<~EOS
      This is a head-only formula as Ghostty is currently under active development.
      No stable release is available yet.
    EOS
  end

  depends_on "zig" => :build
  depends_on "pkg-config" => :build

  def install
    system "zig", "build", "-Doptimize=ReleaseFast"
    bin.install "zig-out/bin/ghostty"
  end

  test do
    assert_match "Ghostty", shell_output("#{bin}/ghostty --version")
  end
end
