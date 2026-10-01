class Litetune < Formula
  include Language::Python::Virtualenv

  desc "Fine-tune, convert and verify small models for on-device"
  homepage "https://github.com/DenisovAV/litetune"
  url "https://files.pythonhosted.org/packages/27/31/67167e41ec4e15669d016df67f884f12f1e9c691d24eb608c13b11bece3f/litetune-0.2.1.tar.gz"
  sha256 "f89bbe14a8552b552f67b6c85229a822a489d1f753cac690509d881a1d056677"
  license "Apache-2.0"

  # `numpy==2.0.2`, pinned by the stage environments litetune provisions,
  # publishes wheels up to cp312. Homebrew's newest python would put `convert`
  # and `verify` out of reach on a fresh install, which is the opposite of what
  # packaging this is for.
  depends_on "python@3.12"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      `convert` and `verify` build their own environments on first use and pull
      several GB, including torch. `prepare`, `tune` and `bundle` do not.

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
