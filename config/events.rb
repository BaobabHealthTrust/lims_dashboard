WebsocketRails::EventMap.describe do
  # You can use this file to map incoming events to controller actions.
  # One event can be mapped to any number of controller actions. The
  # actions will be executed in the order they were subscribed.
  #
  # Uncomment and edit the next line to handle the client connected event:
    subscribe :client_connected, :to => DashboardController, :with_method => :client_online
 	  subscribe :client_disconnected, :to => DashboardController, :with_method => :client_offline
		subscribe :connection_closed, :to => DashboardController, :with_method => :client_closed

		#subscribe :server_datetime, to: DashboardController, with_method: :server_datetime

    subscribe :lab_department, :to => DashboardController, :with_method => :lab_department

  # Here is an example of mapping namespaced events:
  #   namespace :lab_department do
  #     subscribe :haematology, :to => DashboardController, :with_method => :haematology
  #   end
  # The above will handle an event triggered on the client like `product.new`.
end
