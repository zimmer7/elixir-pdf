defmodule Pdf do
  alias Pdf.Document

  @moduledoc """
  The missing PDF library for Elixir.

  ## Usage

  ```elixir
  Pdf.build([size: :a4, compress: true], fn pdf ->
    pdf
    |> Pdf.set_info(title: "Demo PDF")
    |> Pdf.set_font("Helvetica", 10)
    |> Pdf.text_at({200,200}, "Welcome to Pdf")
    |> Pdf.write_to("test.pdf")
  end)
  ```
  ## Page sizes

  The available page sizes are:

   - `:a0` - `:a9`
   - `:b0` - `:b9`
   - `:c5e`
   - `:comm10e`
   - `:dle`
   - `:executive`
   - `:folio`
   - `:ledger`
   - `:legal`
   - `:letter`
   - `:tabloid`
   - a custom size `[width, height]` in Pdf points.

  or you can also specify a tuple `{size, :landscape}`.
  """

  @typedoc """
  Most functions take a coordinates tuple, `{x, y}`.
  In Pdf these start from the bottom-left of the page.
  """
  @type coords :: {x, y}
  @typedoc "Width and height expressed in Pdf points"
  @type dimension :: {width, height}
  @typedoc "The x-coordinate"
  @type x :: number
  @typedoc "The y-coordinate"
  @type y :: number
  @typedoc "The width in points"
  @type width :: number
  @typedoc "The height in points"
  @type height :: number
  @typedoc """
  Use one of the colors in the `Pdf.Color` module.
  """
  @type color_name :: atom
  @typedoc """
  Specify a color by it's RGB make-up.
  """
  @type rgb :: {byte, byte, byte}
  @typedoc """
  Specify a color by it's CMYK make-up.
  """
  @type cmyk :: {float, float, float, float}
  @typedoc """
  A code specifiying the shape of the endpoints for an open path that is stroked.

  - :butt (default)

    The stroke shall be squared of at the endpoint of the path.

  - :round

    A small semicircular arc with a diameter equal to the line width shall be drawn around the endpoint and shall be filled in.

  - :square | :projecting_square

    The stroke shall continue beyond the endpoint of the path for a distance equal to half the line width and shall be squared of.
  """
  @type cap_style :: :butt | :round | :projecting_square | :square | integer()
  @typedoc """
  The line join style shall specify the shape to be used at the corners of paths that are stroked.

  - :miter

    The outer edges of the strokes for the two segments shall be extended until they meet at an angle. If the segments meet at too sharp an angle (as defined in section 8.4.3.5 of the PDF specs), a bevel join shall be used instead.

  - :round

    An arc of a circle with a diameter equal to the line width shall be drawn around the point where the two segments meet, connecting the outer edges of the strokes for the two segments.  This pieslice-shae figure shall be filled in, producing a rounded corner.

  - :bevel

    The two segments shall be finished with butt caps (see `t:cap_style/0`) and the resulting notch beyond the ends of the segments shall be filled with a triangle.
  """
  @type join_style :: :miter | :round | :bevel | integer()

  @doc """
  Create a new Pdf process

  The following options can be given:

  :size      |  Page size, defaults to `:a4`
  :compress  |  Compress the Pdf, default: `true`

  There is no standard font selected when creating a new PDF, so set one with `set_font/3` before adding text.

  """
  @spec new(any) :: :ignore | {:error, any} | {:ok, pid}
  def new(opts \\ []), do: Document.new(opts)

  @doc """
  The unit of measurement in a Pdf are points, where *1 point = 1/72 inch*.
  This means that a standard A4 page, 8.27 inch, translates to 595 points.
  """
  def points(x), do: x
  @doc "Convert the given value from picas to Pdf points"
  def picas(x), do: x * 6
  @doc "Convert the given value from inches to Pdf points"
  def inches(x), do: round(x * 72)
  @doc "Convert the given value from cm to Pdf points"
  def cm(x), do: round(x * 72 / 2.54)

  @doc "Convert the given value from pixels to Pdf points"
  def pixels_to_points(pixels, dpi \\ 300), do: round(pixels / dpi * 72)

  @doc "Write the PDF to the given path"
  def write_to(%Document{} = document, path) do
    File.write!(path, Document.to_iolist(%Document{} = document))
    document
  end

  @doc """
  Export the Pdf to a binary representation.

  This is can be used in eg Phoenix to send a PDF to the browser.

  ```elixir
    report =
      pdf
      |> ...
      |> Pdf.export()

   conn
    |> put_resp_content_type("application/pdf")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=\\"document.pdf\\""
    )
    |> send_resp(200, report)
  ```
  """
  def export(%Document{} = document) do
    Document.to_iolist(%Document{} = document)
    |> :binary.list_to_bin()
  end

  @doc """
  Add a new page to the Pdf with the given page size.
  """
  def add_page(%Document{} = document, size) do
    Document.add_page(%Document{} = document, size: size)
  end

  @doc "Returns the current page number."
  def page_number(%Document{} = document) do
    Document.page_number(%Document{} = document)
  end

  @doc """
  Set the color to use when filling.

  This takes either a `Pdf.Color.color/1` atom, an RGB tuple or a CMYK tuple.
  """
  # @spec set_fill_color(pid, color_name | rgb | cmyk) :: pid
  def set_fill_color(%Document{} = document, color) do
    Document.set_fill_color(%Document{} = document, color)
  end

  @doc """
  Set the color to use when drawing lines.

  This takes either a `Pdf.Color.color/1` atom, an RGB tuple or a CMYK tuple.
  """
  # @spec set_stroke_color(pid, color_name | rgb | cmyk) :: pid
  def set_stroke_color(%Document{} = document, color) do
    Document.set_stroke_color(%Document{} = document, color)
  end

  @doc """
  The width to use when drawing lines.
  """
  # @spec set_line_width(pid, number) :: pid
  def set_line_width(%Document{} = document, width) do
    Document.set_line_width(%Document{} = document, width)
  end

  @doc """
  The line endings to draw, see `t:cap_style/0`.
  """
  # @spec set_line_cap(pid, cap_style) :: pid
  def set_line_cap(%Document{} = document, style) do
    Document.set_line_cap(%Document{} = document, style)
  end

  @doc """
  The join style to use where lines meet, see `t:join_style/0`.
  """
  # @spec set_line_join(pid, join_style) :: pid
  def set_line_join(%Document{} = document, style) do
    Document.set_line_join(%Document{} = document, style)
  end

  @doc """
  Draw a rectangle from coordinates x,y (lower left corner) for a given width and height.
  """
  # @spec rectangle(pid, coords, dimension) :: pid
  def rectangle(%Document{} = document, coords, dimensions) do
    Document.rectangle(%Document{} = document, coords, dimensions)
  end

  @doc """
  Draw a line between 2 points.
  """
  # @spec line(pid, coords, coords) :: pid
  def line(%Document{} = document, coords, coords_to) do
    Document.line(%Document{} = document, coords, coords_to)
  end

  @doc """
  Move the cursor to the given coordinates.
  """
  # @spec move_to(pid, coords) :: pid
  def move_to(%Document{} = document, coords) do
    Document.move_to(%Document{} = document, coords)
  end

  @doc """
  Draw a line from the last position to the given coordinates.
  ```elixir
    pdf
    |> Pdf.move_to({100, 100})
    |> Pdf.line_append({200, 200})
  ```
  """
  # @spec line_append(pid, coords) :: pid
  def line_append(%Document{} = document, coords) do
    Document.line_append(%Document{} = document, coords)
  end

  @doc """
  Perform all the previous graphic commands.
  """
  # @spec stroke(pid) :: pid
  def stroke(%Document{} = document) do
    Document.stroke(%Document{} = document)
  end

  @doc """
  Fill the current drawing with the previously set color.
  """
  # @spec fill(pid) :: pid
  def fill(%Document{} = document) do
    Document.fill(%Document{} = document)
  end

  @doc """
  Sets the font that will be used for all text from here on.
  You can either specify the font size, or a list of options:

  Option  |  Value  | Default
  :------ | :------ | :------
  `:size`   | integer | 10
  `:bold`   | boolean | false
  `:italic` | boolean | false
  """
  #  @spec set_font(pid, binary, integer | list) :: pid
  def set_font(%Document{} = document, font_name, opts) when is_list(opts) do
    font_size = Keyword.get(opts, :size, 16)
    set_font(%Document{} = document, font_name, font_size, Keyword.delete(opts, :size))
  end

  def set_font(%Document{} = document, font_name, font_size) when is_number(font_size) do
    set_font(%Document{} = document, font_name, font_size, [])
  end

  @doc false
  def set_font(%Document{} = document, font_name, font_size, opts) do
    Document.set_font(%Document{} = document, font_name, font_size, opts)
  end

  @doc """
  Sets the font size.

  The font has to have been previously set!
  """
  def set_font_size(%Document{} = document, size) do
    Document.set_font_size(%Document{} = document, size)
  end

  @doc """
  Add a font to the list of available fonts.

  Currently only _Type 1_ AFM/PFB fonts are supported.

  ```elixir

  fonts_dir = Application.app_dir(:my_app) |> Path.join("priv", "fonts")

  pdf
  |> Pdf.add_font(Path.join(fonts_dir, "DejavuSans.afm")
  |> Pdf.add_font(Path.join(fonts_dir, "DejavuSans-Bold.afm")
  ```

  The font can then be set with `set_font/3`.

  You have to `add_font/2` all variants you want to use, bold, italic, ...
  """
  def add_font(%Document{} = document, path) do
    Document.add_external_font(%Document{} = document, path)
  end

  @doc """
  Leading is a typography term that describes the distance between each line of text. The name comes from a time when typesetting was done by hand and pieces of lead were used to separate the lines.

  Today, leading is often used synonymously with "line height" or "line spacing."
  """
  def set_text_leading(%Document{} = document, leading) do
    Document.set_text_leading(%Document{} = document, leading)
  end

  @doc """
  Writes the text at the given coordinates.
  The coordinates are the bottom left of the text.

  The _text_ can be either a binary or a list of binaries or annotated binaries.
  All text will be drawn on the same line, no wrapping will occur, it may overrun the page.

  When given a list, you can supply a mix of binaries and annotated binaries.
  An annotated binary is a tuple `{binary, options}`, with the options being:

  Option  |  Value  | Default
  :------ | :------ | :------
  `:font_size`   | integer | current
  `:bold`   | boolean | false
  `:italic` | boolean | false
  `:leading` | integer | current
  `:color` | :atom | current

  When setting `bold: true` or `italic: true`, make sure that your current font supports these or an error will occur.
  If using an external font, you have to `add_font/2` all variants you want to use.

  """
  def text_at(%Document{} = document, coords, text) do
    Document.text_at(%Document{} = document, coords, text)
  end

  @doc """
  Writes the text at the given coordinates.
  The coordinates are the bottom left of the text.

  The _text_ can be either a binary or a list of binaries or annotated binaries, see `text_at/3`.
  All text will be drawn on the same line, no wrapping will occur, it may overrun the page.

  The `:kerning` option if set to `true` will apply to all rendered text.
  Kerning refers to the spacing between the characters of a font. Without kerning, each character takes up a block of space and the next character is printed after it. When kerning is applied to a font, the characters can vertically overlap. This does not mean that the characters actually touch, but instead it allows part of two characters to take up the same vertical space. Kerning is available in some fonts.

  """
  def text_at(%Document{} = document, coords, text, opts) do
    Document.text_at(%Document{} = document, coords, text, opts)
  end

  @doc """
  Writes the text wrapped within the confines of the given dimensions.
  The `{x,y}` is the top-left of corner of the box, for this reason it is not wise to try to match it up with `text_at` on the same line.

  The y-coordinate can also be set to `:cursor`.

  The text will break at whitespace, such as, space, soft-hyphen, hyphen, cr, lf,  tab, ...

  If the text is too large for the box, it may overrun its boundaries, but only horizontally.

  This function will return a tuple `{pid, :complete}` if all text was rendered, or `{pid, remaining}` if not.
  It can subsequently be called with the _remaining_ data, after eg starting a new page, until `{pid, :complete}`.

  The _text_ can be either a binary or a list of binaries or annotated binaries.
  The `:kerning` option if set will apply to all rendered text.

  When given a list, you can supply a mix of binaries and annotated binaries.
  An annotated binary is a tuple `{binary, options}`, with the options being:

  Option  |  Value  | Default
  :------ | :------ | :------
  `:font_size`   | integer | current
  `:bold`   | boolean | false
  `:italic` | boolean | false
  `:leading` | integer | current
  `:color` | :atom | current

  When choosing `:bold` or `:italic`, make sure that your current font supports these or an error will occur.
  If using an external font, you have to `add_font/2` all variants you want to use.


  """
  # @spec text_wrap(pid, coords(), dimension(), binary | list) :: pid
  def text_wrap(%Document{} = document, coords, dimensions, text) do
    Document.text_wrap(%Document{} = document, coords, dimensions, text)
  end

  @doc """
  This function has the same options as `text_wrap/4`, but also supports additional options that will be applied to the complete text.

  Option  |  Value  | Default
  :------ | :------ | :------
  `:align` | :left , :center , :right | :left
  `:kerning` | `boolean` | false
  """
  # @spec text_wrap(pid, coords(), dimension(), binary | list, keyword) :: pid
  def text_wrap(%Document{} = document, coords, dimensions, text, opts) do
    Document.text_wrap(%Document{} = document, coords, dimensions, text, opts)
  end

  @doc """
  This function has the same options as `text_wrap/4`, but if the text is too large for the box, a `RuntimeError` will be raised.
  """
  # @spec text_wrap!(pid, coords(), dimension(), binary | list) :: pid
  def text_wrap!(%Document{} = document, coords, dimensions, text) do
    Document.text_wrap!(%Document{} = document, coords, dimensions, text)
  end

  @doc """
  This function has the same options as `text_wrap/5`, but if the text is too large for the box, a `RuntimeError` will be raised.
  """
  # @spec text_wrap!(pid, coords(), dimension(), binary | list, keyword) :: pid
  def text_wrap!(%Document{} = document, coords, dimensions, text, opts) do
    Document.text_wrap!(%Document{} = document, coords, dimensions, text, opts)
  end

  @doc """
  This function draws a number of text lines starting at the given coordinates.
  The list can overrun the page, no errors or wrapping will occur.

  Kerning can be set, see `text_at/4` for more information.
  """
  # @spec text_lines(pid, coords(), list, keyword) :: pid
  def text_lines(%Document{} = document, coords, lines, opts) do
    Document.text_lines(%Document{} = document, coords, lines, opts)
  end

  @doc """
  This function draws a number of text lines starting at the given coordinates.
  The list can overrun the page, no errors or wrapping will occur.
  """
  # @spec text_lines(pid, coords(), list) :: pid
  def text_lines(%Document{} = document, coords, lines) do
    Document.text_lines(%Document{} = document, coords, lines)
  end

  @doc false
  def table(%Document{} = document, coords, dimensions, data) do
    Document.table(%Document{} = document, coords, dimensions, data)
  end

  @doc """
  Add a table in the document at the given coordinates.

  See [Tables](tables.html) for more information on how to use tables.
  """
  def table(%Document{} = document, coords, dimensions, data, opts) do
    Document.table(%Document{} = document, coords, dimensions, data, opts)
  end

  @doc false
  def table!(%Document{} = document, coords, dimensions, data) do
    Document.table!(%Document{} = document, coords, dimensions, data)
  end

  @doc """
  Add a table in the document at the given coordinates.
  Raises an exception if the table does not fit the dimensions.

  See [Tables](tables.html) for more information on how to use tables.
  """
  def table!(%Document{} = document, coords, dimensions, data, opts) do
    Document.table!(%Document{} = document, coords, dimensions, data, opts)
  end

  @doc """
  Add an images (PNG, or JPEG only) at the given coordinates.
  """
  def add_image(%Document{} = document, coords, image_path),
    do: add_image(%Document{} = document, coords, image_path, [])

  @doc """
  Add an images (PNG, or JPEG only) at the given coordinates.

  You can specift a `:width` and `:height` in the options, the image will then be scaled.
  """
  def add_image(%Document{} = document, coords, image_path, opts) do
    Document.add_image(%Document{} = document, coords, image_path, opts)
  end

  @doc """
  Returns a `{width, height}` for the current page.
  """
  def size(%Document{} = document) do
    Document.size(document)
  end

  @doc """
  Gets the current cursor position, that is the vertical position.
  """
  # @spec cursor(pid) :: number
  def cursor(%Document{} = document) do
    Document.cursor(%Document{} = document)
  end

  @doc """
  Set the cursor position.
  """
  # @spec set_cursor(pid, number) :: pid
  def set_cursor(%Document{} = document, y) do
    Document.set_cursor(%Document{} = document, y)
  end

  @doc """
  Move the cursor `amount` points down.
  """
  def move_down(%Document{} = document, amount) do
    Document.move_down(%Document{} = document, amount)
  end

  @doc """
  Sets the author in the PDF information section.
  """
  def set_author(%Document{} = document, author),
    do: set_info(%Document{} = document, :author, author)

  @doc """
  Sets the creator in the PDF information section.
  """
  def set_creator(%Document{} = document, creator),
    do: set_info(%Document{} = document, :creator, creator)

  @doc """
  Sets the keywords in the PDF information section.
  """
  def set_keywords(%Document{} = document, keywords),
    do: set_info(%Document{} = document, :keywords, keywords)

  @doc """
  Sets the producer in the PDF information section.
  """
  def set_producer(%Document{} = document, producer),
    do: set_info(%Document{} = document, :producer, producer)

  @doc """
  Sets the subject in the PDF information section.
  """
  def set_subject(%Document{} = document, subject),
    do: set_info(%Document{} = document, :subject, subject)

  @doc """
  Sets the title in the PDF information section.
  """
  def set_title(%Document{} = document, title),
    do: set_info(%Document{} = document, :title, title)

  @doc """
  Set multiple keys in the PDF information section.

  Valid keys
    - `:author`
    - `:created`
    - `:creator`
    - `:keywords`
    - `:modified`
    - `:producer`
    - `:subject`
    - `:title`
  """
  @typedoc false
  @type info_list :: keyword
  # @spec set_info(pid, info_list) :: pid
  def set_info(%Document{} = document, info_list) do
    Document.put_info(%Document{} = document, info_list)
  end

  @doc """
  Manipulate every page, e.g. add pagemarks like `page 1/10`.

  Pass a function that will be passed a page and the index (zero based).
  """
  @spec each_page(Document.t(), ({Page.t(), pos_integer()} -> Page.t())) :: Document.t()
  def each_page(%Document{pages: pages} = document, fun) when is_function(fun, 1) do
    updated_pages = Enum.with_index(pages) |> Enum.map(fun)
    %Document{document | pages: updated_pages}
  end

  defp set_info(%Document{} = document, key, value) do
    Document.put_info(%Document{} = document, key, value)
  end
end
