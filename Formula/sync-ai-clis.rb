class SyncAiClis < Formula
  desc "Detect, install, and keep up to date multiple AI coding CLIs (Claude Code, Codex, Gemini, Kiro, Antigravity) with one command"
  homepage "https://github.com/hyeonbungi/sync-ai-clis"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.1.3/sync-ai-clis-aarch64-apple-darwin.tar.gz"
      sha256 "663794f998e966bd6ddd8c0ae0059d0a5cebe06a599d6421bef2ac3d8d34e844"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.1.3/sync-ai-clis-x86_64-apple-darwin.tar.gz"
      sha256 "68a932c2ada336c813817025a62a146969855668cdc1d5c580a20fbf7a6efd4a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.1.3/sync-ai-clis-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7c1d771b780f5a3ff0075805fd3c0d420dd0b6859c637e99c95578d71e063a05"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hyeonbungi/sync-ai-clis/releases/download/v0.1.3/sync-ai-clis-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8e8fb2e2a305542d622f00358f83c2387bc1cf3e2a6600a13c481829b811c15b"
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
