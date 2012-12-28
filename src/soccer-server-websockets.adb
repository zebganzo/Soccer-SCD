with Ada.Text_IO;

package body Soccer.Server.WebSockets is

   ------------
   -- Create --
   ------------

   function Create
     (Socket  : Net.Socket_Access;
      Request : Status.Data) return Net.WebSocket.Object'Class is
   begin
      Ada.Text_IO.Put_Line("Creating socket for " & Socket.Get_Addr);
      return Object'(Net.WebSocket.Object
                       (Net.WebSocket.Create (Socket, Request)) with null record);
   end Create;

end Soccer.Server.WebSockets;
