defmodule ExCSSModules do
  @moduledoc """
  CSS Modules helpers
  """

  alias __MODULE__
  alias Phoenix.HTML

  @doc """
  Reads the stylesheet. Returns a map if the stylesheet is already a map. Reads
  the file if the stylesheet is a string.

  ## Examples

    iex> stylesheet(%{})
    %{}

    iex> stylesheet("../stylesheet.css")
    %{}
  """
  def stylesheet(definition) when is_map(definition), do: definition

  @doc false
  def stylesheet(definition), do: definition |> read_stylesheet()

  def read_stylesheet(filename) do
    case File.exists?(filename) do
      true -> filename <> ".json"
              |> File.read!
              |> Poison.decode!
      false -> %{}
    end
  end

  @doc """
  Reads the class definitions from the definition map and maps them to a class
  attribute. The classes argument takes any argument the class_name for the key.

  ## Examples
    iex> class(%{ "hello" => "world"}, "hello")
    {:safe, ~s(class="world")}
  """
  def class(definition, classes) do
    definition
    |> class_name(classes)
    |> class_attribute
  end

  @doc """
  Returns the class name from the definition map is value is true.

  ## Examples
    iex> class_name(%{"hello" => "world"}, "hello", true)
    "world"

    iex> class_name(%{"hello" => "world"}, "hello", false)
    nil
  """
  def class_name(definition, key, value) do
    if value do
      class_name(definition, key)
    end
  end

  @doc """
  Returns the class name from the definition map is the second argument
  in the tuple is true.

  ## Examples
    iex> class_name(%{"hello" => "world"}, {"hello", true})
    "world"

    iex> class_name(%{"hello" => "world"}, {"hello", false})
    nil
  """
  def class_name(definition, {key, value}), do:
    class_name(definition, key, value)

  @doc """
  Returns the class name sfrom the definition map when the argument is a list
  of values or tuples.

  ## Examples
    iex> class_name(%{"hello" => "world", "foo" => "bar"}, ["hello", "foo"])
    "world bar"

    iex> class_name(%{"hello" => "world", "foo" => "bar"}, [{"hello", true}, {"foo", true}])
    "world bar"

    iex> class_name(%{"hello" => "world", "foo" => "bar"}, [{"hello", true}, {"foo", false}])
    "world"
  """
  def class_name(definition, keys) when is_list(keys) do
    keys
    |> Enum.map(&class_name(definition, &1))
    |> Enum.reject(&is_nil/1)
    |> Enum.join(" ")
  end

  @doc """
  Returns the class name sfrom the definition map when the argument is a list
  of values or tuples.

  ## Examples
    iex> class_name(%{"hello" => "world"}, "hello")
    "world"

    iex> class_name(%{"hello" => "world"}, "foo")
    nil
  """
  def class_name(stylesheet, key) do
    stylesheet
    |> stylesheet()
    |> Map.get(key, nil)
  end

  @doc """
  Takes the definition and makes a class selector that can be used in CSS out of
  the classes given. Takes either a single value or a list of classes.

  ## Examples
    iex> class_selector(%{ "hello" => "world"}, "hello")
    ".world"
    iex> class_selector(%{ "hello" => "world", "foo" => "bar"}, ["hello", "foo"])
    ".world.foo"
  """
  def class_selector(definition, classes) when is_list(classes) do
    classes
    |> Enum.map(&class_selector(definition, &1))
    |> Enum.reject(&is_nil/1)
    |> Enum.join("")
  end

  @doc false
  def class_selector(definition, class) do
    case class_name(definition, class) do
      nil -> nil
      value -> ".#{value}"
    end
  end

  defp class_attribute(class), do: HTML.raw(~s(class="#{class}"))
end
