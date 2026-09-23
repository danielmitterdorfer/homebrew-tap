cask "librewolf" do
  arch arm: "arm64", intel: "x86_64"
  os macos: "macos-#{arch}-package.dmg", linux: "linux-#{arch}-appimage.AppImage"

  version "156.0,1"
  sha256 arm:          "e957e3fb07dc7452aae41b50375f3a860fb5c9c385f3505353b2f498e670ce28",
         intel:        "258f0a571c8de36be6210b4dc0d11db83f8daadb9ac52b631bc1260eed3adf1b",
         arm64_linux:  "fbee90de56fd96da8466254bc0ca0f5fdcc51c27e418df327e27df5aa9c9b62e",
         x86_64_linux: "1140bf9710ce58506278c90c856e68c9d9fbb93ee192d0e3248b99c929a6ab7f"

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
