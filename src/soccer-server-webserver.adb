with Soccer.Server.WebServer;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Server.WebServer is

   procedure Start is
   begin
      Config.Set.Reuse_Address (Web_Config, true);

      Config.Set.Server_Host (Web_Config, Host);
      Config.Set.Server_Port (Web_Config, Port);

      --  Start the server

      AWS.Server.Start(Web_Server => Web_Server,
		       Config     => Web_Config,
		       Callback   => Soccer.Server.Callbacks.Services'Unrestricted_Access);

      Net.WebSocket.Registry.Control.Start;

      Net.WebSocket.Registry.Register ("/managerVisitors/registerForStatistics", Soccer.Server.WebSockets.Create'Access);
      Net.WebSocket.Registry.Register ("/managerHome/registerForStatistics", Soccer.Server.WebSockets.Create'Access);
      Net.WebSocket.Registry.Register ("/field/registerForEvents", Soccer.Server.WebSockets.Create'Access);

   end Start;

   procedure PublishManagersUpdate (events : JSON_Array) is
      container : JSON_Value := Create_Object;
   begin
      container.Set_Field (Field_Name => "events",
			   Field      => events);
      Net.WebSocket.Registry.Send(ManagerHome, Write (Item => container));
      Net.WebSocket.Registry.Send(ManagerVisitors, Write (Item => container));
   end PublishManagersUpdate;

   procedure SendQuitSignalsToManagers is
      container : JSON_Value := Create_Object;
   begin
      container.Set_Field (Field_Name => "command",
			   Field      => "quit");
      Net.WebSocket.Registry.Send(ManagerHome, Write (Item => container));
      Net.WebSocket.Registry.Send(ManagerVisitors, Write (Item => container));
   end SendQuitSignalsToManagers;

   procedure PublishManagerTeams (team1 : String; team2 : String) is
   begin
      Net.WebSocket.Registry.Send(ManagerHome, team1);
      Net.WebSocket.Registry.Send(ManagerVisitors, team2);
   end PublishManagerTeams;

   procedure PublishFieldUpdate (events : JSON_Array) is
      container : JSON_Value := Create_Object;
   begin
      container.Set_Field (Field_Name => "events",
			   Field      => events);
      Net.WebSocket.Registry.Send(Field, Write (Item => container));
   end PublishFieldUpdate;

   procedure Notify_Field_With_Params (payload : String) is
      container : JSON_Value := Create_Object;
   begin
      container.Set_Field (Field_Name => "players_params",
			   Field      => payload);
      Net.WebSocket.Registry.Send (Field, Write (container));
   end Notify_Field_With_Params;

   procedure PublishTestUpdate is
   begin
      Net.WebSocket.Registry.Send(Field, "test!");
   end PublishTestUpdate;

end Soccer.Server.WebServer;
