with Soccer.Server.WebServer;

package body Soccer.Server.WebServer is

   procedure Start is
   begin
      Config.Set.Reuse_Address (Web_Config, true);

      Config.Set.Server_Host (Web_Config, Host);
      Config.Set.Server_Port (Web_Config, Port);

      --  Start the server

      Net.WebSocket.Registry.Register ("/managerVisitors/registerForStatistics", Soccer.Server.WebSockets.Create'Access);
      Net.WebSocket.Registry.Register ("/managerHome/registerForStatistics", Soccer.Server.WebSockets.Create'Access);
      Net.WebSocket.Registry.Register ("/field/registerForEvents", Soccer.Server.WebSockets.Create'Access);

      Net.WebSocket.Registry.Control.Start;

      AWS.Server.Start(Web_Server,
		   Config => Web_Config,
		   Callback => Soccer.Server.Callbacks.Services'Unrestricted_Access);

   end Start;

   procedure PublishManagerUpdate is
   begin
      Net.WebSocket.Registry.Send(ManagerHome, "i'm da manager");
   end PublishManagerUpdate;

   procedure PublishFieldUpdate is
   begin
      Net.WebSocket.Registry.Send(Field, "i'm da field");
   end PublishFieldUpdate;

end Soccer.Server.WebServer;
