defmodule PDF.Examples.GeneralDocumentTest do
  use PDF.Case, async: true

  @open false
  test "generate document" do
    file_path = output("general_document.pdf")

    PDF.new(size: :a4, compress: false)
    |> PDF.set_info(
      title: "Test Document",
      producer: "Test producer",
      creator: "Test Creator",
      created: ~D"2020-03-17",
      modified: Date.utc_today(),
      author: "Test Author",
      subject: "Test Subject"
    )
    |> add_header("Lorem ipsum dolor sit amet")
    |> write_paragraphs1()
    |> write_paragraphs2()
    |> PDF.add_page({:a4, :landscape})
    |> PDF.move_down(20)
    |> write_paragraphs1()
    |> write_paragraphs2()
    |> PDF.write_to(file_path)

    if @open, do: System.cmd("open", ["-g", file_path])
  end

  defp add_header(pdf, header) do
    %{width: width, height: height} = PDF.size(pdf)

    pdf
    |> PDF.set_font("Helvetica", 16, bold: true)
    |> PDF.text_wrap!({20, height - 40}, {width - 40, 20}, header, align: :center)
    |> PDF.move_down(16)
  end

  defp write_paragraphs1(pdf) do
    %{width: width} = PDF.size(pdf)

    cursor = PDF.cursor(pdf)

    text = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse elementum enim metus, quis posuere sem molestie interdum. Ut efficitur odio lectus, uty facilisis odio tempor quis. Ut ut risus quis tellus placerat tristique ut ultrices leo. Etiam ante lacus, pulvinar non aliquam luctus, efficitur vel velit. Aenean nec urna metus. Sed aliquam libero ligula, ac commodo turpis pulvinar sed. Aenean interdum elementum tempor. Cras tempus feugiat consequat. Mauris ut nulla et orci dapibus auctor a sit amet odio. Vivamus sit amet mi libero. Fusce a neque sagittis, volutpat ligula sed, eleifend felis. Ut luctus metus justo, id porta dui dignissim vitae. Duis sit amet maximus justo, non finibus quam. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nulla ultrices diam nec vulputate congue. Duis ornare pulvinar nulla. Sed at justo nec tortor efficitur dapibus ac non enim. Nam sed finibus odio, ac pretium mi. In mattis viverra cursus. Integer a risus sagittis tortor eleifend sollicitudin. Nullam fermentum maximus odio at laoreet. Maecenas malesuada sagittis aliquet.

    Vivamus sodales eros eu auctor imperdiet. Praesent sit amet nibh sollicitudin, tincidunt est ac, auctor tortor. Nunc ipsum massa, pharetra id sem id, convallis malesuada orci. Donec consequat id metus a mollis. Fusce luctus nisi ipsum. Cras id magna hendrerit, facilisis lorem vitae, pellentesque diam. Morbi imperdiet suscipit turpis et pulvinar. Nam convallis sit amet nibh sit amet condimentum. Donec sit amet neque eget tortor ultrices dignissim. Mauris ac justo convallis, ultricies arcu a, auctor elit. Suspendisse facilisis vulputate pharetra. Sed in malesuada neque. Fusce sed sodales lectus.
    """

    padding = 20
    image_width = 100
    image_height = 75
    image_margin = 10

    {updated_pdf, {:continue, _} = remaining} =
      pdf
      |> PDF.set_font("Helvetica", 12)
      |> PDF.add_image({padding, cursor - image_height}, fixture("rgb.jpg"))
      |> PDF.text_wrap(
        {padding + image_width + image_margin, cursor},
        {width - padding * 2 - image_width - image_margin, image_height + image_margin},
        String.trim(text)
      )

    cursor = PDF.cursor(updated_pdf)

    {final_pdf, :complete} =
      updated_pdf
      |> PDF.set_font("Helvetica", 12)
      |> PDF.text_wrap({padding, cursor}, {width - padding * 2, cursor - padding}, remaining)

    PDF.move_down(final_pdf, 12)
  end

  defp write_paragraphs2(pdf) do
    %{width: width} = PDF.size(pdf)

    cursor = PDF.cursor(pdf)

    text = """
    Etiam fermentum molestie diam vitae consequat. Etiam vitae arcu orci. Curabitur at feugiat mauris. Vestibulum ultrices ipsum dolor, ac fringilla nibh suscipit eget. Donec convallis leo sit amet euismod convallis. Fusce id dui fermentum velit venenatis facilisis. Sed eleifend eget tellus vel dictum. Donec nec nibh quis ex elementum fringilla volutpat in dui. Nunc porta luctus turpis, vel eleifend sapien bibendum faucibus. Cras malesuada sit amet neque sit amet varius.

    Praesent eget lacinia arcu. Quisque vitae nisl consectetur, ullamcorper leo id, elementum erat. Quisque eget ullamcorper orci. Curabitur dignissim dui et posuere tempus. Ut sagittis sollicitudin hendrerit. Aenean mollis tincidunt tortor, a ultrices justo euismod accumsan. Cras tincidunt quis ante id luctus. Donec rhoncus sodales nisl sed sagittis. Curabitur convallis purus eu aliquet venenatis. Aliquam dignissim massa in consectetur facilisis. Fusce hendrerit ullamcorper dui non consectetur. Proin lobortis nulla quis elit varius, vitae egestas tortor lobortis. Ut id scelerisque ligula, tristique gravida sem. Sed vitae varius massa. Donec ac eros sapien.
    """

    padding = 20

    pdf
    |> PDF.set_font("Helvetica", 12)
    |> PDF.text_wrap!(
      {padding, cursor},
      {width - padding * 2, cursor - padding},
      String.trim(text)
    )
    |> PDF.move_down(12)
  end
end
