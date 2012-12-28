
with AWS.Config.Set;
with AWS.Server;

with Soccer.Server.Callbacks;
with Soccer.Server.WebSockets;

with AWS;
with AWS.Net.WebSocket.Registry.Control;
with AWS.Response;
with AWS.Status;
with Ada;
with Ada.Text_IO;

package Soccer.Server.WebServer is

   use AWS;
   use AWS.Config;
   use type AWS.Net.Socket_Access;

   Web_Server : AWS.Server.HTTP;
   Web_Config : Config.Object;

   -- WebSockets configuration

   ManagerVisitors : Net.WebSocket.Registry.Recipient :=
     Net.WebSocket.Registry.Create (URI => "/managerVisitors/registerForStatistics");

   ManagerHome : Net.WebSocket.Registry.Recipient :=
     Net.WebSocket.Registry.Create (URI => "/managerHome/registerForStatistics");

   Field : Net.WebSocket.Registry.Recipient :=
     Net.WebSocket.Registry.Create (URI => "/field/registerForEvents");

   -- Starts the WebServer

   procedure Start ;

   -- Updates both managers

   procedure PublishManagerUpdate ;

   -- Updates the field

   procedure PublishFieldUpdate ;

end Soccer.Server.WebServer;
