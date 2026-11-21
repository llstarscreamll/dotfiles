cask "agentbar" do
  version "1.4.1"
  sha256 "6802b2f011de7f74167988d2868d1ebb13c21d53a48db87ea9ade2dd6dcce043"

  url "https://github.com/aliyar/AgentBar/releases/download/v#{version}/AgentBar-#{version}.dmg"
  name "AgentBar"
  desc "Menu bar usage for Claude Code, Codex, and Cursor"
  homepage "https://agentbar.greatpixels.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :sonoma

  app "AgentBar.app"

  zap trash: [
    "~/Library/Application Support/AgentBar",
    "~/Library/Caches/com.greatpixels.AgentBar",
    "~/Library/HTTPStorages/com.greatpixels.AgentBar",
    "~/Library/Preferences/com.greatpixels.AgentBar.plist",
  ]
end
