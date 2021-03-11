defmodule PDF.Array do
  @moduledoc false

  defstruct values: []

  import PDF.Size

  @array_start "[ "
  @array_start_length byte_size(@array_start)
  @array_end "]"
  @array_end_length byte_size(@array_end)
  @initial_length @array_start_length + @array_end_length

  def new(list), do: %__MODULE__{values: list}

  def size(array), do: calculate_size(array.values)

  def to_iolist(%PDF.Array{values: values}) do
    PDF.Export.to_iolist([
      @array_start,
      Enum.map(values, fn value -> [value, " "] end),
      @array_end
    ])
  end

  defp calculate_size([]), do: 0

  defp calculate_size([_ | _] = list) do
    @initial_length + Enum.reduce(list, length(list), fn value, acc -> acc + size_of(value) end)
  end

  defimpl PDF.Size do
    def size_of(%PDF.Array{} = array), do: PDF.Array.size(array)
  end

  defimpl PDF.Export do
    def to_iolist(array), do: PDF.Array.to_iolist(array)
  end
end
