defmodule DDWRT.Wireless.ClientTest do
  use ExUnit.Case

  alias DDWRT.Wireless.Client

  describe "#new" do
    test "extracts from an empty entry list" do
      assert Client.new([]) == %Client{}
    end

    test "extracts from a populated entry list" do
      assert Client.new(["mac"]) == %Client{mac: "mac"}
    end
  end
end
