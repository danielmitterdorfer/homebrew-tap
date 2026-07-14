cask "logseq-og" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0"
  sha256 arm:   "82af43917c0aa0ce2e12949f741c527b8eaf71522223981317751c51487d7797",
         intel: "f1480c81a0ef12efc5de1b46d59ed2adb5b17b4c32061bab29779b1e84b9c1e5"

  url "https://github.com/logseq/og/releases/download/#{version}/Logseq-OG-darwin-#{arch}-#{version}.dmg"
  name "Logseq OG"
  desc "File-based fork of Logseq, preserving the pre-DB version"
  homepage "https://github.com/logseq/og"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :monterey

  app "Logseq-OG.app"

  zap trash: [
    "~/Library/Application Support/Logseq OG",
    "~/Library/Logs/Logseq OG",
    "~/Library/Preferences/com.logseq.logseq-og.plist",
    "~/Library/Saved Application State/com.logseq.logseq-og.savedState",
  ]
end
