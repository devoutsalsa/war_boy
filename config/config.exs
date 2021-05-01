use Mix.Config

config :logger, :console,
  format: "[$level] $message $metadata\n",
  metadata: [:error_code, :file]
