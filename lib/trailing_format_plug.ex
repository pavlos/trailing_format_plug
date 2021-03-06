defmodule TrailingFormatPlug do
  @behaviour Plug

  def init(options), do: options

  def call(conn, opts) do
    conn.path_info |> List.last |> String.split(".") |> Enum.reverse |> case do
      [ _ ] -> conn
      [ format | fragments ] ->
        new_path       = fragments |> Enum.reverse |> Enum.join(".")
        path_fragments = List.replace_at conn.path_info, -1, new_path
        params         =
          Plug.Conn.fetch_params(conn).params
          |> Dict.put("format", format)
        %{conn | path_info: path_fragments, params: params}
    end
  end
end
