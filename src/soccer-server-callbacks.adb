
with AWS.Messages;
with AWS.MIME;
with Ada.Text_IO;
use Ada.Text_IO;
with AWS.Parameters;
with AWS.Containers;
with AWS.Containers.Tables;
with AWS;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNATCOLL.JSON; use GNATCOLL.JSON;
with AWS.URL;
with Ada.Directories;
use Ada.Directories;
with Ada.Direct_IO;
with Soccer.Server.Callbacks; use Soccer.Server.Callbacks;
with Soccer.Bridge.Input;
with Soccer.ControllerPkg; use Soccer.ControllerPkg;

package body Soccer.Server.Callbacks is

   -------------
   -- Default --
   -------------

   function Services (Request : in AWS.Status.Data) return Response.Data is
      URI : constant String := AWS.Status.URI (Request);
      PARAMS : constant AWS.Parameters.List := AWS.Status.Parameters (Request);
      a : JSON_Value := GNATCOLL.JSON.Read ( "{""foo"":""bar"",""foo2"":""bar2""}", "");
      b : JSON_Value;
      -- AWS.Parameters.Get(PARAMS,nome);

   begin
      if URI = "/manager/updates" then
         declare
            updates : String := AWS.URL.Decode (AWS.Parameters.Get (PARAMS, "data"));
	 begin
	    Bridge.Input.Apply_Manager_Updates (updates);
         end;
      elsif URI = "/manager/getStats" then
	 -- send players stats
	 declare
	    t_manager : String := AWS.Parameters.Get(PARAMS,"team");
	    result : Unbounded_String;
         begin
	    Bridge.Input.Get_Players_Stats (t_manager, result);
	    return AWS.Response.Build (MIME.Text_Plain, To_String (result));
         end;
      elsif URI = "/field/newGame" then
	 -- start new game
	 Bridge.Input.New_Game;
      elsif URI = "/field/secondHalf" then
	 -- continue with second half
	 Bridge.Input.Second_Half;
      elsif URI = "/field/pauseGame" then
	 -- pause the current game
	 declare
	    new_status : Unbounded_String;
	 begin
	    Bridge.Input.Pause_Game (new_status);
	    return AWS.Response.Build (MIME.Text_Plain, To_String (new_status));
	 end;
      elsif URI = "/field/quit" then
	 -- quit everything!
	 Bridge.Input.Quit;
      elsif URI = "/field/setTeamsConf" then
         Bridge.Input.Update_Teams_Configuration (AWS.URL.Decode (AWS.Parameters.Get (PARAMS, "conf")));
--           ControllerPkg.Initialize;
      elsif URI = "/field/getParams" then
	 -- send players' params
	 declare
	    params : Unbounded_String;
	 begin
	    Bridge.Input.Get_Players_Params (params);
	    return AWS.Response.Build (MIME.Text_Plain, To_String (params));
	 end;
      end if;

--        Put_Line (AWS.Parameters.Get (PARAMS, "a"));
--        Put_Line ("received payload is " & AWS.Parameters.Get (PARAMS, "a"));
--        Put_Line ("decoded payload is " & AWS.URL.Decode (AWS.Parameters.Get (PARAMS, "a")));
--
--        b := GNATCOLL.JSON.Read (AWS.Parameters.Get (PARAMS, "a"), "");
--        Put_Line ("foo is " & GNATCOLL.JSON.Get (Val   => b,
--  					       Field => "foo"));

      return AWS.Response.Build (MIME.Text_HTML, "Hello WebServer!");

   end Services;

   ----------------
   --  Iterator  --
   ----------------

   procedure Handler
     (Name  : in UTF8_String;
      Value : in JSON_Value)
   is
      use Ada.Text_IO;
   begin
      case Kind (Val => Value) is
         when JSON_Null_Type =>
            Put_Line (Name & "(null):null");
         when JSON_Boolean_Type =>
            Put_Line (Name & "(boolean):" & Boolean'Image (Get (Value)));
         when JSON_Int_Type =>
            Put_Line (Name & "(integer):" & Integer'Image (Get (Value)));
         when JSON_Float_Type =>
            Put_Line (Name & "(float):" & Float'Image (Get (Value)));
         when JSON_String_Type =>
            Put_Line (Name & "(string):" & Get (Value));
         when JSON_Array_Type =>
            declare
               A_JSON_Array : constant JSON_Array := Get (Val => Value);
               A_JSON_Value : JSON_Value;
               Array_Length : constant Natural := Length (A_JSON_Array);
            begin
               Put (Name & "(array):[");
               for J in 1 .. Array_Length loop
                  A_JSON_Value := Get (Arr   => A_JSON_Array,
                                       Index => J);
                  Put (Get (A_JSON_Value));

                  if J < Array_Length then
                     Put (", ");
                  end if;
               end loop;
               Put ("]");
               New_Line;
            end;
         when JSON_Object_Type =>
            Put_Line (Name & "(object):");
            Map_JSON_Object (Val => Value,
                             CB  => Handler'Access);
      end case;
      --  Decide output depending on the kind of JSON field we're dealing with.
      --  Note that if we get a JSON_Object_Type, then we recursively call
      --  Map_JSON_Object again, which in turn calls this Handler procedure.
   end Handler;

   function Load_File
     (Filename : in String)
      return String
   is
      use Ada.Directories;

      File_Size    : constant Natural := Natural (Size (Filename));

      subtype Test_JSON_Str is String (1 .. File_Size);
      package File_IO is new Ada.Direct_IO (Test_JSON_Str);

      File           : File_IO.File_Type;
      String_Content : Test_JSON_Str;
   begin
      File_IO.Open (File => File,
		    Mode => File_IO.In_File,
		    Name => Filename);
      File_IO.Read (File => File,
		    Item => String_Content);
      File_IO.Close (File => File);

      return String_Content;
   end Load_File;

end Soccer.Server.Callbacks;
