defmodule ZeroBirthWebsite.Router do
  use Plug.Router
  # import Plug.Conn

  plug(PlugEarlyHints,
    paths: [
      # "https://gravatar.com/": [rel: "dns-prefetch"],
      # "https://gravatar.com/": [rel: "preconnect"]
      "birth.css": [rel: "stylesheet", as: "style"]
    ]
  )

  plug(:match)
  plug(:dispatch)

  defp get_file_path(filename) do
    Path.join([__DIR__, "..", "..", "assets", filename])
  end

  def get_user_agent(conn) do
    conn
    |> Plug.Conn.get_req_header("user-agent")
    |> List.first()
    |> UAParser.parse()
  end

  def get_html(conn) do
    case get_user_agent(conn) do
      %{family: "Firefox"} -> "1"
      _ -> "2"
    end
    |> get_file_path()
  end

  def get_css(conn) do
    case get_user_agent(conn) do
      %{family: "Firefox"} -> "3"
      _ -> "4"
    end
    |> get_file_path()
  end

  def set_css_header(conn) do
    case get_user_agent(conn) do
      %{family: "Firefox"} ->
        put_resp_header(conn, "link", "<i>; rel=stylesheet;")

      _ ->
        conn
    end
  end

  get "/" do
    file_path = get_html(conn)

    conn
    |> set_css_header()
    |> put_resp_header("content-type", "text/html")
    |> send_file(200, file_path)
  end

  get "/i" do
    file_path = get_css(conn)

    conn
    |> put_resp_content_type("text/css")
    |> send_file(200, file_path)
  end

  match _ do
    send_resp(conn, 404, "Oops!\n")
  end
end
