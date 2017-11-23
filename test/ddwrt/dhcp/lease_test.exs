defmodule DDWRT.DHCP.LeaseTest do
  use ExUnit.Case

  alias DDWRT.DHCP.Lease

  describe "#new" do
    test "extracts from an empty entry list" do
      assert Lease.new([]) == %Lease{}
    end

    test "extracts from a populated entry list" do
      assert Lease.new(["name", "ip", "mac", "period"]) == %Lease{name: "name", ip: "ip", mac: "mac", period: "period"}
    end
  end
end
