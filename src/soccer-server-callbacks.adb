
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


package body Soccer.Server.Callbacks is

   -------------
   -- Default --
   -------------

   function Services (Request : in Status.Data) return Response.Data is
      URI : constant String := Status.URI (Request);
      PARAMS : constant AWS.Parameters.List := AWS.Status.Parameters (Request);
      a : JSON_Value := GNATCOLL.JSON.Read ( "{""foo"":""bar"",""foo2"":""bar2""}", "");
      b : JSON_Value;

   begin
      if URI = "/manager/setFormation" then
	 -- set formation (enum_formation)
	 null;
      elsif URI = "/manager/substitutePlayer" then
	 -- substitute player (id_out, id_in)
	 null;
      elsif URI = "/field/newGame" then
	 -- start new game
	 null;
      elsif URI = "/field/pauseGame" then
	 -- pause the current game
	 null;

      end if;

--        Put_Line (AWS.Parameters.Get (PARAMS, "a"));
      Put_Line ("received payload is " & AWS.Parameters.Get (PARAMS, "a"));
      Put_Line ("decoded payload is " & AWS.URL.Decode (AWS.Parameters.Get (PARAMS, "a")));

      b := GNATCOLL.JSON.Read (AWS.Parameters.Get (PARAMS, "a"), "");
      Put_Line ("foo is " & GNATCOLL.JSON.Get (Val   => b,
					       Field => "foo"));

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
