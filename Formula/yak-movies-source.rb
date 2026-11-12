class YakMoviesSource < Formula
  desc "Stream movies, shows, anime, and live TV from your terminal (built from source)"
  homepage "https://github.com/yakyakyak14/yak-movies"
  url "https://github.com/yakyakyak14/yak-movies/archive/refs/tags/v0.1.29.tar.gz"
  sha256 "870b1c122e3adef0bee3e8591de530c7d674da9e22523360fc1d37df824bb73e"
  version "0.1.29"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/yakyakyak14/yak-movies.git", branch: "main"

  depends_on "rust" => :build
  depends_on "mpv"

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink "yak-movies" => "moviebox-tui"

    if OS.mac?
      system "codesign", "--force", "--deep", "-s", "-", "#{bin}/yak-movies" rescue nil
      system "xattr", "-d", "com.apple.quarantine", "#{bin}/yak-movies" rescue nil
    end
  end

  def caveats
    <<~EOS
      YAK-movies requires a media player such as mpv, VLC, or IINA.
      To install mpv:
        brew install mpv

      Built from source natively targeting your exact macOS version (macOS 14 - macOS 27+ / Darwin 20-27+).
    EOS
  end

  test do
    system "#{bin}/yak-movies", "--version"
  end
end
