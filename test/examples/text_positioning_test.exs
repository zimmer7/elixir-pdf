defmodule PDF.Examples.TextPositioningTest do
  use PDF.Case, async: true

  @open false
  test "" do
    file_path = output("text_positioning.pdf")
    pdf = PDF.new(size: :a4, compress: false)
    %{width: width, height: height} = PDF.size(pdf)

    pdf
    |> PDF.set_line_width(0.5)
    |> PDF.set_stroke_color(:gray)
    |> PDF.set_fill_color(:black)
    |> PDF.line({20, height - 100}, {width - 40, height - 100})
    |> PDF.stroke()
    |> PDF.set_font("Helvetica", 10)
    |> PDF.text_at({20, height - 100}, "This should write on the line")
    # Text wrap is calculated from top left (because it needs to write down until it runs out of space)
    |> PDF.text_wrap!({200, height - 100}, {200, 10}, "This should write under the line")
    # The rectangle is drawn from bottom left
    |> PDF.rectangle({200, height - 100 - 10}, {200, 10})
    |> PDF.stroke()
    |> PDF.write_to(file_path)

    if @open, do: System.cmd("open", ["-g", file_path])
  end
end
