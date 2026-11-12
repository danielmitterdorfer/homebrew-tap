cask "librewolf" do
  arch arm: "arm64", intel: "x86_64"
  os macos: "macos-#{arch}-package.dmg", linux: "linux-#{arch}-appimage.AppImage"

  version "160.0,1"
  sha256 arm:          "416a2fa78e4b67e97a48751aaf783f1fe5711d9495a52a3b1f245b89adc1c638",
         intel:        "83306a47a223a41d4bf1f251ffbecc41e7999f519df70e1a22051fd4008ae0dd",
         arm64_linux:  "a62283398f8e8735e8191fe04d7f395e83a9d03282d40dce2bbc418aa1eea0bf",
         x86_64_linux: "656054abcc32f39b6d720cc76ea4359dbceff465ca039b2d963050ce0d1f9005"

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
