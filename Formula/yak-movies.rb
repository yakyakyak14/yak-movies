class YakMovies < Formula
  VERSION = "0.1.29"
  MACOS_SHA256 = "b5d631d13fb0bbb93a9f8223ca0c2adbe400870c502c6ca620021b6c0c058f8a"
  LINUX_X64_SHA256 = "b71d4d912a874057fc41ed9a3709b7fbb04bedb8ff4edeea44ecfba7ae82e6df"
  LINUX_ARM64_SHA256 = "36ab1fb772ee9ab2f2daba8fef9b82325ec035b4dffec6a457049f1af05266d0"

  desc "Stream movies, shows, anime, and live TV from your terminal"
  homepage "https://github.com/yakyakyak14/yak-movies"
  version VERSION
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/yakyakyak14/yak-movies.git", branch: "main"

  depends_on "mpv"

  on_macos do
    url "https://github.com/yakyakyak14/yak-movies/releases/download/v#{VERSION}/MovieBox_macOS_Universal.tar.gz"
    sha256 MACOS_SHA256
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/yakyakyak14/yak-movies/releases/download/v#{VERSION}/MovieBox_Linux_arm64.tar.gz"
      sha256 LINUX_ARM64_SHA256
    else
      url "https://github.com/yakyakyak14/yak-movies/releases/download/v#{VERSION}/MovieBox_Linux_x64.tar.gz"
      sha256 LINUX_X64_SHA256
    end
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      if File.exist?("yak-movies")
        bin.install "yak-movies"
      elsif File.exist?("moviebox-tui")
        bin.install "moviebox-tui" => "yak-movies"
      end
      bin.install_symlink "yak-movies" => "moviebox-tui"
    end

    # Ad-hoc code signing and quarantine removal for macOS 14 through macOS 27+ / Darwin 20-27+
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

      Compatibility:
        Accommodates macOS 14 through macOS 27+ (Darwin 20-27+) across both
        Apple Silicon (arm64) and Intel (x86_64) architectures.
    EOS
  end

  test do
    system "#{bin}/yak-movies", "--version"
  end
end
