cask "librewolf" do
  arch arm: "arm64", intel: "x86_64"
  os macos: "macos-#{arch}-package.dmg", linux: "linux-#{arch}-appimage.AppImage"

  version "160.0.1,1"
  sha256 arm:          "63fecdaff40925486c1c5023c651b61a0858e49847ea338a64d6e47d517f774c",
         intel:        "97079db0bbc4366effc531fa1affc1abcad497e3e9b20c3b38b1412e8cc589a6",
         arm64_linux:  "587654be766cd0d700f19d1e3d18b1a2ce606bba30b8e65df0a0d372f767846f",
         x86_64_linux: "73970f0bc7b971b2a3d297fe2ddb598c144eafc1fc14f67b22ac24663fa57d72"

  on_macos do
    app "LibreWolf.app"
    # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
    shimscript = "#{staged_path}/librewolf.wrapper.sh"
    binary shimscript, target: "librewolf"

    preflight_steps do
      write_file "librewolf.wrapper.sh", <<~EOS
        #!/bin/sh
        exec '{{appdir}}/LibreWolf.app/Contents/MacOS/librewolf' "$@"
      EOS
    end

    zap trash: [
      "~/.librewolf",
      "~/Library/Application Support/LibreWolf",
      "~/Library/Caches/LibreWolf Community",
      "~/Library/Caches/LibreWolf",
      "~/Library/Preferences/io.gitlab.librewolf-community.librewolf.plist",
      "~/Library/Saved Application State/io.gitlab.librewolf-community.librewolf.savedState",
    ]
  end
  on_linux do
    app_image "librewolf-#{version.tr(",", "-")}-#{os}", target: "LibreWolf.AppImage"
  end

  url "https://codeberg.org/api/packages/librewolf/generic/librewolf/#{version.tr(",", "-")}/librewolf-#{version.tr(",", "-")}-#{os}"
  name "LibreWolf"
  desc "Web browser"
  homepage "https://librewolf.net/"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url "https://codeberg.org/api/v1/repos/librewolf/bsys6/releases/latest"
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :json do |json, regex|
      json["tag_name"]&.[](regex, 1)&.tr("-", ",")
    end
  end
end
