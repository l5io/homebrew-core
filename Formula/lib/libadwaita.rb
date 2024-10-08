class Libadwaita < Formula
  desc "Building blocks for modern adaptive GNOME applications"
  homepage "https://gnome.pages.gitlab.gnome.org/libadwaita/"
  url "https://download.gnome.org/sources/libadwaita/1.6/libadwaita-1.6.0.tar.xz"
  sha256 "9ed783934cb99c9101639194e1fc072cb09303b8f3c2fc6623390186a9dad8d3"
  license "LGPL-2.1-or-later"

  # libadwaita doesn't use GNOME's "even-numbered minor is stable" version
  # scheme. This regex is the same as the one generated by the `Gnome` strategy
  # but it's necessary to avoid the related version scheme logic.
  livecheck do
    url :stable
    regex(/libadwaita-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "ffabe2eb1fe00e5efbca6c18327ae1a728e9d345534011cf8772b16d4f059734"
    sha256 arm64_sonoma:  "b7c170a947a74e6d2516cc1ddcca5a015ef6c6e6441d4c407eb82911422e27bd"
    sha256 arm64_ventura: "a7ba69ef314653be437a9571e3b906bd415c78a70d3ae2214727d83187718c8e"
    sha256 sonoma:        "fc1c4a672a249f1a07941c94f4e4cabee840b09d7bfd89d674996a695bc7dd6f"
    sha256 ventura:       "cdb4eee5e5a1164bd76199e09565ae0303a4479f44f7f05cd6a33609c2d39150"
    sha256 x86_64_linux:  "00c3d3da21b4def84e564ac2eec6681dc27b74583d709db86e772831195cc883"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build

  depends_on "appstream"
  depends_on "fribidi"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "pango"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <adwaita.h>

      int main(int argc, char *argv[]) {
        g_autoptr (AdwApplication) app = NULL;
        app = adw_application_new ("org.example.Hello", G_APPLICATION_DEFAULT_FLAGS);
        return g_application_run (G_APPLICATION (app), argc, argv);
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libadwaita-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test", "--help"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/libadwaita-1.pc").read
  end
end
