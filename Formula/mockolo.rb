class Mockolo < Formula
  desc "Efficient Mock Generator for Swift"
  homepage "https://github.com/uber/mockolo"
  url "https://github.com/uber/mockolo/archive/1.7.1.tar.gz"
  sha256 "0ea108672945eade97d78ec07e193611b180279215fc2e3399bc87a881559964"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a8a98e2b2613fdeefed39dfea246f629745dffbddad4d82b9fb0de5ed60c3e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89b3d3abf4c2eeb32f4cd80e4f2e51a147e8efa601b67041c21f47d601a45969"
    sha256 cellar: :any_skip_relocation, monterey:       "ed59d563d1d3db610445ad676e4e537c2c478ff179d01b8c126b76e14854547a"
    sha256 cellar: :any_skip_relocation, big_sur:        "57baa74a6d3a17befdc9fd1682a98118e106cadf1a5f62559b08267faee6b13f"
  end

  depends_on xcode: ["12.5", :build]
  depends_on :macos # depends on os.signpost, which is macOS-only.

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/mockolo"
  end

  test do
    (testpath/"testfile.swift").write <<~EOS
      /// @mockable
      public protocol Foo {
          var num: Int { get set }
          func bar(arg: Float) -> String
      }
    EOS
    system "#{bin}/mockolo", "-srcs", testpath/"testfile.swift", "-d", testpath/"GeneratedMocks.swift"
    assert_predicate testpath/"GeneratedMocks.swift", :exist?
    output = <<~EOS.gsub(/\s+/, "").strip
      ///
      /// @Generated by Mockolo
      ///
      public class FooMock: Foo {
        public init() { }
        public init(num: Int = 0) {
            self.num = num
        }

        public private(set) var numSetCallCount = 0
        public var num: Int = 0 { didSet { numSetCallCount += 1 } }

        public private(set) var barCallCount = 0
        public var barHandler: ((Float) -> (String))?
        public func bar(arg: Float) -> String {
            barCallCount += 1
            if let barHandler = barHandler {
                return barHandler(arg)
            }
            return ""
        }
      }
    EOS
    assert_equal output, shell_output("cat #{testpath/"GeneratedMocks.swift"}").gsub(/\s+/, "").strip
  end
end
