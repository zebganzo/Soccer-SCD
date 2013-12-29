with Ada.Text_IO;
use Ada.Text_IO;

package body Soccer.Server.WebSockets is

   ------------
   -- Create --
   ------------

   function Create (Socket  : Net.Socket_Access; Request : Status.Data) return Net.WebSocket.Object'Class is
   begin
      Ada.Text_IO.Put_Line("Creating socket for " & Socket.Get_Addr);
      return Object'(Net.WebSocket.Object (Net.WebSocket.Create (Socket, Request)) with null record);
   end Create;

   overriding procedure On_Close (Socket : in out Object; Message : String) is
   begin
      Put_Line ("Received : Connection_Close " & Net.WebSocket.Error_Type'Image (Socket.Error) & ", " & Message);
   end On_Close;

   overriding procedure On_Message (Socket : in out Object; Message : String) is
   begin
      Put_Line ("Received : " & Message);
   end On_Message;

   overriding procedure On_Open (Socket : in out Object; Message : String) is
   begin
      Put_Line ("Aperta connessione. ");
   end On_Open;

   overriding procedure Send (Socket : in out Object; Message : String) is
   begin
      -- Invio del messaggio
      Net.WebSocket.Object (Socket).Send (Message);
   end Send;

end Soccer.Server.WebSockets;
