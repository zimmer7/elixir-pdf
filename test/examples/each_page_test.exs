defmodule PDF.Examples.EachPageTest do
  use PDF.Case, async: true

  @open false
  test "generate document" do
    file_path = output("each_page.pdf")
    size = :a4

    pdf =
      PDF.new(size: size, compress: false)
      |> PDF.add_page(size)
      |> PDF.add_page(size)
      |> PDF.add_page(size)

    page_count = length(pdf.pages)

    pdf
    |> PDF.each_page(fn {page, i} ->
      page
      |> PDF.Page.set_font("Helvetica", 10)
      |> PDF.Page.text_at(
        {PDF.cm(1), PDF.cm(1)},
        "#{i + 1}/#{page_count}"
      )
    end)
    |> PDF.write_to(file_path)

    if @open, do: System.cmd("open", ["-g", file_path])
  end
end
