class SyncAiClis < Formula
  desc "Detect, install, and keep up to date multiple AI coding CLIs (Claude Code, Codex, Gemini, Kiro, Antigravity) with one command"
  homepage "https://github.com/hyeonbungi/sync-ai-clis"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.3.0/sync-ai-clis-aarch64-apple-darwin.tar.gz"
      sha256 "d1434759391f829b4c78f7c74475916fcd46c039ba3d6027dc0430b761cbe875"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.3.0/sync-ai-clis-x86_64-apple-darwin.tar.gz"
      sha256 "7a7ac1163fa14408db54a9ccb0cce4541e2ff8f9cb872ecaf759ee41ee854756"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.3.0/sync-ai-clis-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1b5efb1c82e33d5703200f3d0b3110fc811ce7ccb2104819ccb56a81484a44b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.3.0/sync-ai-clis-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "842690ce5daccae91084640378d29068f9195b839ffb0667cf6b1848a3a95bc1"
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
