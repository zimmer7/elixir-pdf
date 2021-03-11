defprotocol PDF.Size do
  @moduledoc false
  def size_of(object)
end

defimpl PDF.Size, for: BitString do
  def size_of(string), do: byte_size(string)
end

defimpl PDF.Size, for: Integer do
  def size_of(number), do: PDF.Size.size_of(Integer.to_string(number))
end

defimpl PDF.Size, for: Float do
  def size_of(number),
    do: PDF.Size.size_of(PDF.Export.to_iolist(number))
end

defimpl PDF.Size, for: Date do
  def size_of(_date), do: 12
end

defimpl PDF.Size, for: DateTime do
  def size_of(%{utc_offset: 0}), do: 19
  def size_of(_date), do: 24
end

defimpl PDF.Size, for: List do
  def size_of([]), do: 0
  def size_of([_ | _] = list), do: Enum.reduce(list, 0, &(PDF.Size.size_of(&1) + &2))
end

defimpl PDF.Size, for: Tuple do
  def size_of({:name, string}), do: 1 + PDF.Size.size_of(string)

  def size_of({:string, string}), do: 2 + PDF.Size.size_of(string)

  def size_of({:object, number, generation}),
    do: 4 + PDF.Size.size_of(number) + PDF.Size.size_of(generation)

  def size_of({:command, [_ | _] = list}), do: length(list) - 1 + PDF.Size.size_of(list)
  def size_of({:command, command}), do: PDF.Size.size_of(command)
end
