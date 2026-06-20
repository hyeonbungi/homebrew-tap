class SyncAiClis < Formula
  desc "Detect, install, and keep up to date multiple AI coding CLIs (Claude Code, Codex, Gemini, Kiro, Antigravity) with one command"
  homepage "https://github.com/hyeonbungi/sync-ai-clis"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.4.1/sync-ai-clis-aarch64-apple-darwin.tar.gz"
      sha256 "0a82d6fc8ada65449b71d8619d94f7b9152d591be6282663d524bde034701c71"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.4.1/sync-ai-clis-x86_64-apple-darwin.tar.gz"
      sha256 "12712d91df579d5f8d892a5704cab57bdde1c7e5ec24057be008b05cbfe48d7a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.4.1/sync-ai-clis-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "87cf5580bcae745a6a7d4597f60bacd505736ae3aa630343f39525098f479dea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.4.1/sync-ai-clis-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1e0b7e8e88899ee4981f8a4084f6eab2b8e0bb71426c6d86f5919930474cb457"
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
