class SyncAiClis < Formula
  desc "Detect, install, and keep up to date multiple AI coding CLIs (Claude Code, Codex, Gemini, Kiro, Antigravity) with one command"
  homepage "https://github.com/hyeonbungi/sync-ai-clis"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.2.1/sync-ai-clis-aarch64-apple-darwin.tar.gz"
      sha256 "ce84652cc8c4548818d5f8dc834ec322b37bf5c11f203f733b2954ab436c98ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.2.1/sync-ai-clis-x86_64-apple-darwin.tar.gz"
      sha256 "c4ac83b46767223052f1cf1aa15df6d5913bd790ae2be6dd0376be6176f4b743"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.2.1/sync-ai-clis-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b5b2eb54dcac5917556b202bbc6fbb9dfcb77a090084900f7c60c84c0911b3b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.2.1/sync-ai-clis-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "959b42c4597bcecec901fddcb7261f5e97d9fa2568964328cb6a32b161508d7a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "sync-ai-clis" if OS.mac? && Hardware::CPU.arm?
    bin.install "sync-ai-clis" if OS.mac? && Hardware::CPU.intel?
    bin.install "sync-ai-clis" if OS.linux? && Hardware::CPU.arm?
    bin.install "sync-ai-clis" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
