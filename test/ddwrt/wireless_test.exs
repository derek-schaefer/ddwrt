defmodule DDWRT.WirelessTest do
  use ExUnit.Case

  alias DDWRT.Wireless
  alias DDWRT.Wireless.Client

  test "assigns default field values" do
    assert %Wireless{} == %Wireless{clients: []}
  end

  describe "#new" do
    test "extracts from an empty active wireless value" do
      assert Wireless.new(%{"active_wireless" => ""}) == %Wireless{clients: []}
    end

    test "extracts from a populated active wireless value" do
      assert Wireless.new(%{"active_wireless" => "'1','2','3','4','5','6','7','8','9','1','2','3','4','5','6','7','8','9'"}) == %Wireless{clients: [%Client{mac: "1"}, %Client{mac: "1"}]}
    end
  end
end
