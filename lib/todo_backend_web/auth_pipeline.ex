defmodule TodoBackend.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :todo_backend,
  module: TodoBackend.Guardian,
  error_handler: TodoBackend.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
