class Glaze < Formula
  desc "Extremely fast, in-memory JSON and interface library for modern C++"
  homepage "https://github.com/stephenberry/glaze"
  url "https://github.com/stephenberry/glaze/archive/refs/tags/v5.5.3.tar.gz"
  sha256 "c2b62e525ff5dea91a28676943a648bf9564ad4326fd55afce2ac5026964ee71"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f85e82aed786116ee4c394e094b01da1724b09737103c172765d4f0a5b5e778b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "llvm" => :test

  def install
    args = %w[
      -Dglaze_DEVELOPER_MODE=OFF
    ]
    args << "-Dglaze_ENABLE_AVX2=#{(!build.bottle? && Hardware::CPU.intel?) ? "ON" : "OFF"}"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
    # Issue ref: https://github.com/stephenberry/glaze/issues/1500
    ENV.append_to_cflags "-stdlib=libc++" if OS.linux?

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.16)
      project(GlazeTest LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 20)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      find_package(glaze REQUIRED)

      add_executable(glaze_test test.cpp)
      target_link_libraries(glaze_test PRIVATE glaze::glaze)
    CMAKE

    (testpath/"test.cpp").write <<~CPP
      #include <glaze/glaze.hpp>
      #include <map>
      #include <string_view>

      int main() {
        const std::string_view json = R"({"key": "value"})";
        std::map<std::string, std::string> data;
        auto result = glz::read_json(data, json);
        return (!result && data["key"] == "value") ? 0 : 1;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build", "-Dglaze_DIR=#{share}/glaze"
    system "cmake", "--build", "build"
    system "./build/glaze_test"
  end
end
