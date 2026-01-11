defmodule HelloPhoenix.OAuth.Store do
  @moduledoc """
  OAuth token store usando DETS (key-value persistente).

    token_map assumes "expires_in" as :system_time seconds until it's expired
    and add its token_map "expires_at" summing up System.system_time(:second)
  """

  @table :oauth_token
  @file_name "oauth_store.dets"

  ## Public API

  def put(key, token_map) when is_map(token_map) do
    with {:ok, table} <- open() do
      :dets.insert(table, {key, add_expires_at(token_map)})
      :ok
    end
  end

  def get(key) do
    with {:ok, table} <- open(),
         [{_, token}] <- :dets.lookup(table, key),
         true <- valid?(token) do
      {:ok, token}
    else
      _ ->
        {:error, :not_found}
    end
  end

  def valid?(token_map) do
    case token_map do
      %{"expires_at" => expires_at} ->
        now() < expires_at

      _ ->
        false
    end
  end

  ## Internal

  def open do
    base_path =
      Application.fetch_env!(:hello_phoenix, :oauth)
      |> Keyword.fetch!(:base_path)

    File.mkdir_p!(base_path)

    file = Path.join(base_path, @file_name)

    :dets.open_file(@table, file: String.to_charlist(file))
  end

  defp add_expires_at(token_map) do
    Map.put(token_map, "expires_at", now() + token_map["expires_in"])
  end

  defp now do
    System.system_time(:second)
  end
end
