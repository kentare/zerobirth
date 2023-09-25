defmodule ZeroBirthWebsite.Application do
  use Application
  require Logger

  defp verify_fun_selfsigned_cert(_, {:bad_cert, :selfsigned_peer}, user_state),
    do: {:valid, user_state}

  defp verify_fun_selfsigned_cert(_, {:bad_cert, _} = reason, _),
    do: {:fail, reason}

  defp verify_fun_selfsigned_cert(_, {:extension, _}, user_state),
    do: {:unkown, user_state}

  defp verify_fun_selfsigned_cert(_, :valid, user_state),
    do: {:valid, user_state}

  defp verify_fun_selfsigned_cert(_, :valid_peer, user_state),
    do: {:valid, user_state}

  def start(_type, _args) do
    children = [
      {Plug.Cowboy,
       scheme: :https,
       plug: ZeroBirthWebsite.Router,
       port: 4040,
       stream_handlers: [
         :cowboy_compress_h,
         ZeroBirthWebsite.Stripheaders,
         :cowboy_stream_h
       ],
       keyfile: "priv/cert/selfsigned_key.pem",
       certfile: "priv/cert/selfsigned.pem",
       otp_app: :zerobirthwebsite}
      # {
      #   Bandit,
      #   plug: ZeroBirthWebsite.Router,
      #   scheme: :https,
      #   keyfile: "priv/cert/selfsigned_key.pem",
      #   certfile: "priv/cert/selfsigned.pem",
      #   otp_app: :zerobirthwebsite
      # }
    ]

    opts = [strategy: :one_for_one, name: ZeroBirthWebsite.Supervisor]

    Logger.info("Starting application...")

    Supervisor.start_link(children, opts)
  end
end
