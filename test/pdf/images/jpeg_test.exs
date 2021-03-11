defmodule PDF.Images.JPEGTest do
  use PDF.Case, async: true

  alias PDF.Images.JPEG

  test "decode/1" do
    assert %{bit_depth: 8, height: 75, width: 100, color_type: 3} =
             JPEG.decode(File.read!(fixture("rgb.jpg")))

    assert %{bit_depth: 8, height: 75, width: 100, color_type: 4} =
             JPEG.decode(File.read!(fixture("cmyk.jpg")))

    assert %{bit_depth: 8, height: 75, width: 100, color_type: 1} =
             JPEG.decode(File.read!(fixture("grayscale.jpg")))
  end
end
