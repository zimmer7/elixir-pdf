defmodule PDF.Trailer do
  alias PDF.Dictionary

  @moduledoc false

  defstruct objects: [], offset: 0, root: nil, info: nil

  def new(objects, offset, root, info),
    do: %__MODULE__{objects: objects, offset: offset, root: root, info: info}

  defimpl PDF.Export do
    def to_iolist(trailer) do
      dictionary =
        Dictionary.new()
        |> Dictionary.put("Size", length(trailer.objects) + 1)
        |> Dictionary.put("Root", trailer.root)
        |> Dictionary.put("Info", trailer.info)

      PDF.Export.to_iolist(["trailer\n", dictionary, "\nstartxref\n", trailer.offset, "\n%%EOF"])
    end
  end
end
