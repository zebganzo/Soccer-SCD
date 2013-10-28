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

      AWS.Server.Start(Web_Server => Web_Server,
                       Config     => Web_Config,
                       Callback   => Soccer.Server.Callbacks.Services'Unrestricted_Access);

   end Start;

   procedure PublishManagersUpdate (events : JSON_Array) is
      container : JSON_Value := Create_Object;
   begin
      container.Set_Field (Field_Name => "events",
			   Field      => events);
      Net.WebSocket.Registry.Send(ManagerHome, Write (Item => container));
   end PublishManagersUpdate;

   procedure PublishFieldUpdate (events : JSON_Array) is
      container : JSON_Value := Create_Object;
   begin
      container.Set_Field (Field_Name => "events",
			   Field      => events);
      Net.WebSocket.Registry.Send(Field, Write (Item => container));
   end PublishFieldUpdate;

end Soccer.Server.WebServer;
