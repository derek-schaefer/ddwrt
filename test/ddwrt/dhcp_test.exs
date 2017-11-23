defmodule DDWRT.DHCPTest do
  use ExUnit.Case

  alias DDWRT.DHCP
  alias DDWRT.DHCP.Lease

  test "assigns default field values" do
    assert %DHCP{} == %DHCP{leases: []}
  end

  describe "#new" do
    test "extracts from an empty dhcp leases value" do
      assert DHCP.new(%{"dhcp_leases" => ""}) == %DHCP{leases: []}
    end

    test "extracts from a populated dhcp leases value" do
      assert DHCP.new(%{"dhcp_leases" => "'1','2','3','4','5','1','2','3','4','5'"}) == %DHCP{leases: [%Lease{ip: "2", mac: "3", name: "1", period: "4"}, %Lease{ip: "2", mac: "3", name: "1", period: "4"}]}
    end
  end
end
