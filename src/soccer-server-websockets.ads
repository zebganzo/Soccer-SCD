with Ada.Streams;

with AWS.Net.Log;
with AWS.Response;
with AWS.Status;

with AWS.Net.WebSocket;

package Soccer.Server.WebSockets is
   use AWS;

   type Object is new AWS.Net.WebSocket.Object with private;

   function Create
     (Socket  : Net.Socket_Access;
      Request : Status.Data) return Net.WebSocket.Object'Class;

private

   type Object is new Net.WebSocket.Object with null record;

end Soccer.Server.WebSockets;
