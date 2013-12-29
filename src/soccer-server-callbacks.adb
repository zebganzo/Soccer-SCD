
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
with Soccer.Game; use Soccer.Game;
with Soccer.ControllerPkg.Referee; use Soccer.ControllerPkg.Referee;
with Soccer.ControllerPkg; use Soccer.ControllerPkg;
with Soccer.TeamPkg; use Soccer.TeamPkg;


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
      if URI = "/manager/setFormation" then
	 -- set formation (enum_formation)
	 null;
      elsif URI = "/manager/substitutePlayer" then
	 -- substitute player (id_out, id_in)
         null;
      elsif URI = "/manager/getStats" then
         declare
            t_manager : String := AWS.Parameters.Get(PARAMS,"team");
         begin
            -- send players stats
            return AWS.Response.Build (MIME.Text_Plain, Get_Stats (t_manager));
         end;
      elsif URI = "/field/newGame" then
	 -- start new game
	 Soccer.ControllerPkg.Referee.Simulate_Begin_Of_1T;
	 Game_Entity.Notify;
      elsif URI = "/field/secondHalf" then
	 -- continue with second half
	 Soccer.ControllerPkg.Referee.Simulate_Begin_Of_2T;
      elsif URI = "/field/pauseGame" then
	 -- pause the current game
	 null;
      elsif URI = "/field/getParams" then
	 -- send players' params
	 return AWS.Response.Build (MIME.Text_Plain, Get_Params);
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

   function Get_Params return String is
      result : JSON_Array;
      current : JSON_Value;
      container : JSON_Value;
   begin
      for player in 1 .. total_players loop
	 current := Create_Object;
	 Set_Field (current, "id", player);
	 Set_Field (current, "number", ControllerPkg.Get_Number_From_Id (player));
	 Set_Field (current, "on_the_field", ControllerPkg.Is_On_The_Field (player));
	 Set_Field (current, "team", Team_Id'Image (ControllerPkg.Get_Player_Team_From_Id (player)));
	 Append (result, current);
      end loop;

      container := Create_Object;
      Set_Field (container, "players", result);
      return Write (container);
   end Get_Params;

   function Get_Stats (manager : in String) return String is
      json_obj     : JSON_Value;
      player       : JSON_Value;
      team     	   : JSON_Array;
      player_team  : Team_Id;
   begin
      for i in 1 .. total_players loop
         player_team := ControllerPkg.Get_Player_Team_From_Id (i);
         if manager = Team_Id'Image (player_team) then
            declare
               number : Integer := ControllerPkg.Get_Number_From_Id (i);
            begin
               player := Create_Object;
               player.Set_Field ("number"	, number);
               player.Set_Field ("attack"	, TeamPkg.Get_Attack       (number, player_team));
               player.Set_Field ("defense"	, TeamPkg.Get_Defense 	   (number, player_team));
               player.Set_Field ("goal_keeping"	, TeamPkg.Get_Goal_Keeping (number, player_team));
               player.Set_Field ("power"	, TeamPkg.Get_Power 	   (number, player_team));
               player.Set_Field ("precision"	, TeamPkg.Get_Precision    (number, player_team));
               player.Set_Field ("speed"	, TeamPkg.Get_Speed 	   (number, player_team));
               player.Set_Field ("tackle"	, TeamPkg.Get_Tackle 	   (number, player_team));
               Append (team, player);
            end;
         end if;
      end loop;

      json_obj := Create_Object;
      json_obj.Set_Field("formation",Formation_Scheme_Id'Image(TeamPkg.Get_Formation(Team_Id'Value(manager))));
      json_obj.Set_Field ("stats", Create(team));
      --json_obj.Set_Field ("in", manager);
      return Write (json_obj);
   end Get_Stats;


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
