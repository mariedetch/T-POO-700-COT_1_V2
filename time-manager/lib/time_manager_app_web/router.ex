defmodule TimeManagementWeb.Router do
  use TimeManagementWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimeManagementWeb do
    pipe_through :api
<<<<<<< HEAD
    resources "/users", UserController, except: [:new, :edit]
=======
    get "/clocks/:userId", ClockController, :index
    post "/clocks/:userId", ClockController, :create
>>>>>>> 27c86625d442214529eb46d8d64768cb6eeb4f09
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:time_manager_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TimeManagementWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
