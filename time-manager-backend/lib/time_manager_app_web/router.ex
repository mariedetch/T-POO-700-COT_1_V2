defmodule TimeManagementWeb.Router do
  use TimeManagementWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug TimeManagementWeb.Plugs.AuthenticationPlug
  end

  scope "/api/auth", TimeManagementWeb do
    pipe_through :api

    post "/login", AuthController, :login
    post "/forgot-password", AuthController, :forgot_password
    post "/verify-token/:email/:token", AuthController, :verify_token
    post "/reset-password/:token", AuthController, :reset_password
    post "/activate-account/:token", AuthController, :activate_account
  end

  scope "/api", TimeManagementWeb do
    pipe_through [:api, :authenticated]

    resources "/users", UserController, except: [:new, :edit]
    resources "/teams", TeamController, except: [:new, :edit] do
      get "/available", UserController, :list_users_not_in_team
      resources "/members", MemberController, only: [:index, :create]
    end

    resources "/members", MemberController, only: [:delete]

    get "/clocks", ClockController, :index
    get "/clocks/latest", ClockController, :show
    post "/clocks", ClockController, :create

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
