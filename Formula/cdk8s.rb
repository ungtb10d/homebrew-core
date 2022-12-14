require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.36.tgz"
  sha256 "0e9de6588a0ea5dfb59452d126e6b318cc5e1945b67d40382a918152ec00f9f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e68281123fafb217c0b78819bd856613446e335c7ac5c0a615ac868618111a8d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
