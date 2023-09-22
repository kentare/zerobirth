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
       port: 8080,
       options: [
         keyfile: "priv/keys/localhost.key",
         certfile: "priv/keys/localhost.crt",
         otp_app: :zerobirthwebsite,
         verify: :verify_peer,
         verify_fun: {&verify_fun_selfsigned_cert/3, []}
       ]}
    ]

    opts = [strategy: :one_for_one, name: ZeroBirthWebsite.Supervisor]

    Logger.info("Starting application...")

    Supervisor.start_link(children, opts)
  end
end
