defmodule TimeManagementWeb.Router do
  use TimeManagementWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimeManagementWeb do
    pipe_through :api
    get "/users",  UserController, :index
    get "/users/:id",  UserController, :show
    post "/users", UserController, :create
    put "/users/promote/:id", UserController, :promote
    put  "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete

    get "/clocks/:userId", ClockController, :index
    get "/clocks/:userId/latest", ClockController, :show
    post "/clocks/:userId", ClockController, :create

    get "/workingtime/:userID",  WorkingTimeController, :index
    get "/workingtime/:userID/:id",  WorkingTimeController, :show
    post "/workingtime/:userID", WorkingTimeController, :create
    post "/workingtimes", WorkingTimeController, :create_for_users
    put  "/workingtime/:id", WorkingTimeController, :update
    delete "/workingtime/:id", WorkingTimeController, :delete
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
