defmodule PDF.ObjectCollectionTest do
  use ExUnit.Case, async: true

  alias PDF.{Dictionary, ObjectCollection}

  test "adding an object to the collection" do
    {:ok, collection} = ObjectCollection.start_link()
    dictionary = Dictionary.new()
    object = ObjectCollection.create_object(collection, dictionary)
    assert object == {:object, 1, 0}
  end
end
