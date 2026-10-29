class Litetune < Formula
  include Language::Python::Virtualenv

  desc "Fine-tune, convert and verify small models for on-device"
  homepage "https://github.com/DenisovAV/litetune"
  url "https://files.pythonhosted.org/packages/2b/ba/3dc5cfdf6b92019da4ebc82a4e729891f616cb98f87c34e2f84d70ca77c0/litetune-0.7.1.tar.gz"
  sha256 "da12dfb2009edebc61e193aa8d1f99f454b802faca68e52d3d8e1ffb65517e12"
  license "Apache-2.0"

  # `numpy==2.0.2`, pinned by the stage environments litetune provisions,
  # publishes wheels up to cp312. Homebrew's newest python would put `convert`
  # and `verify` out of reach on a fresh install, which is the opposite of what
  # packaging this is for.
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      `tune`, `convert` and `verify` build their own environments on first use
      and pull several GB, including torch; so does `prepare --tokenizer`.
      `bundle`, and `prepare` without `--tokenizer`, do not.

      On Linux the runtime needs libvulkan1 -- litert-lm dlopen()s a
      Vulkan-linked library even for the CPU backend:
        sudo apt-get install -y libvulkan1
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/litetune --version")

    # `shell_output` raises unless the exit status matches, so this line is the
    # assertion. Exit 4 is "could not check", which is what a usage error must
    # produce here: 2 already means "measured, inconclusive", and a typo is not
    # a measurement.
    shell_output("#{bin}/litetune nonesuch 2>&1", 4)
  end
end
