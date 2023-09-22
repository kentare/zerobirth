defmodule ZeroBirthWebsite.Router do
  use Plug.Router
  # import Plug.Conn

  plug(:match)
  plug(:dispatch)

  # plug(PlugEarlyHints,
  #   paths: [
  #     "https://gravatar.com/": [rel: "dns-prefetch"],
  #     "https://gravatar.com/": [rel: "preconnect"]
  #     # "birth.css": [rel: "stylesheet", as: "style"]
  #   ]
  # )

  defp get_file_path(filename) do
    Path.join([__DIR__, "..", "..", "assets", filename])
  end

  get "/" do
    file_path = get_file_path("index.html")

    # IO.inspect(newConn)
    conn
    # |> Plug.Conn.inform(:early_hints, [{:link, "</birth.css>; rel=preload; as=style"}])
    |> put_resp_content_type("text/html")
    # |> put_resp_header("Link", "</birth.css>; rel=preload; as=style")
    # |> put_resp_header("Link", "</birth.css>; rel=stylesheet")
    |> send_file(200, file_path)
  end

  get "/birth.css" do
    file_path = get_file_path("birth.css")

    conn
    |> put_resp_content_type("text/css")
    |> send_file(200, file_path)
  end

  match _ do
    send_resp(conn, 404, "Oops!\n")
  end
end
