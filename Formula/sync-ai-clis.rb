class SyncAiClis < Formula
  desc "Detect, install, and keep up to date multiple AI coding CLIs (Claude Code, Codex, Gemini, Kiro, Antigravity) with one command"
  homepage "https://github.com/hyeonbungi/sync-ai-clis"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.1.1/sync-ai-clis-aarch64-apple-darwin.tar.gz"
      sha256 "a9f499e84f53e024840b5d3f4308342bd2e24197da1ef5e271ca57fc0f4144c3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.1.1/sync-ai-clis-x86_64-apple-darwin.tar.gz"
      sha256 "9782a3a7c7aba98363010dd96b988f385354ef54fea512b80bfb8de2d3fd4fb3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.1.1/sync-ai-clis-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6b3ed87152b53875e805e2b135d80fcd9f46d163375cb7d3b449a165e061cb1a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.1.1/sync-ai-clis-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7ac7db769d30df90196d23ca4312916645bc094ddcabd8137751a0bf72b86317"
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
