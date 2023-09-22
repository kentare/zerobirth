defmodule ZeroBirthWebsiteTest do
  use ExUnit.Case
  doctest ZeroBirthWebsite

  test "greets the world" do
    assert ZeroBirthWebsite.hello() == :world
  end
end
