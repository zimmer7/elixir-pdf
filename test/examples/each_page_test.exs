defmodule Pdf.Examples.EachPageTest do
  use Pdf.Case, async: true

  @open false
  test "generate document" do
    file_path = output("each_page.pdf")
    size = :a4

    pdf =
      Pdf.new(size: size, compress: false)
      |> Pdf.add_page(size)
      |> Pdf.add_page(size)
      |> Pdf.add_page(size)

    page_count = length(pdf.pages)

    pdf
    |> Pdf.each_page(fn {page, i} ->
      page
      |> Pdf.Page.set_font("Helvetica", 10)
      |> Pdf.Page.text_at(
        {Pdf.cm(1), Pdf.cm(1)},
        "#{i + 1}/#{page_count}"
      )
    end)
    |> Pdf.write_to(file_path)

    if @open, do: System.cmd("open", ["-g", file_path])
  end
end
