defmodule DDWRTTest do
  use ExUnit.Case

  setup do
    ddwrt = %DDWRT{password: System.get_env("DDWRT_PASSWORD")}

    {:ok, %{ddwrt: ddwrt}}
  end

  test "assigns default field values" do
    assert %DDWRT{} == %DDWRT{address: "http://192.168.1.1", username: "root", password: nil}
  end

  describe "#get" do
    @tag :external
    test "requests from a result endpoint", %{ddwrt: ddwrt} do
      assert {:ok, %HTTPoison.Response{}} = DDWRT.get(ddwrt, "/Status_Lan.live.asp")
    end
  end

  describe "#get_results" do
    @tag :external
    test "requests and extracts from a results endpoint", %{ddwrt: ddwrt} do
      assert {:ok, %{}} = DDWRT.get_results(ddwrt, "/Status_Lan.live.asp")
    end
  end

  describe "#status_lan" do
    @tag :external
    test "requests and extracts from the lan status endpoint", %{ddwrt: ddwrt} do
      assert {:ok, %DDWRT.DHCP{}} = DDWRT.status_lan(ddwrt)
    end
  end

  describe "#status_wireless" do
    @tag :external
    test "requests and extracts from the wireless status endpoint", %{ddwrt: ddwrt} do
      assert {:ok, %DDWRT.Wireless{}} = DDWRT.status_wireless(ddwrt)
    end
  end

  describe "#extract_results" do
    test "extracts from an empty payload" do
      assert DDWRT.extract_results("") == %{}
    end

    test "extracts from a payload with one result" do
      assert DDWRT.extract_results("{key::value}") == %{"key" => "value"}
    end

    test "extracts from a payload with multiple results" do
      assert DDWRT.extract_results("{key1::value1}\n{key2::value2}") == %{"key1" => "value1", "key2" => "value2"}
    end
  end

  describe "#extract_entries" do
    test "extracts from an empty result value" do
      assert DDWRT.extract_entries("") == []
    end

    test "extracts from a result value with one entry" do
      assert DDWRT.extract_entries("'test'") == ["test"]
    end

    test "extracts from a result value with multiple entries" do
      assert DDWRT.extract_entries("'test1','test2'") == ["test1", "test2"]
    end
  end

  describe "#extract_and_chunk_entries" do
    test "extracts and chunks from an empty result value" do
      assert DDWRT.extract_and_chunk_entries("", 2) == []
    end

    test "extracts and chunks from a result value with one entry" do
      assert DDWRT.extract_and_chunk_entries("'test'", 2) == [["test"]]
    end

    test "extracts and chunks from a result value with multiple entries" do
      assert DDWRT.extract_and_chunk_entries("'test1','test2','test3','test4'", 2) == [["test1", "test2"], ["test3", "test4"]]
    end
  end

  describe "#headers" do
    test "builds a header keyword list with an authorization value" do
      assert %DDWRT{username: "test", password: "test"} |> DDWRT.headers == [authorization: "Basic " <> Base.encode64("test:test")]
    end
  end

  describe "#authorization" do
    test "builds an authorization value using the username and password" do
      assert %DDWRT{username: "test", password: "test"} |> DDWRT.authorization == Base.encode64("test:test")
    end
  end
end
