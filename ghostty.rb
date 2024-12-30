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
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on :xcode => :build if OS.mac?

  def install
    args = %W[
      -Doptimize=ReleaseFast
    ]
    if OS.mac?
      unless File.exist?("/Applications/Xcode.app")
        odie "Xcode is required but not installed in /Applications/Xcode.app"
      end

      system "zig", "build", *args

      cd "macos" do
        system "xcodebuild",
      end

      prefix.install "macos/build/ReleaseLocal/Ghostty.app"
      Applications.install_symlink prefix/"Ghostty.app"
    else
      system "zig", "build", *args
      bin.install "zig-out/bin/ghostty"
    end
  end

  test do
    if OS.mac?
      assert_predicate prefix/"Ghostty.app", :exist?
    else
      assert_match "Ghostty", shell_output("#{bin}/ghostty --version")
    end
  end
end
