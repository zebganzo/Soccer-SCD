with Ada.Directories; use Ada.Directories;
with Soccer.Manager_Event.Substitution; use Soccer.Manager_Event.Substitution;
with Ada.Containers.Vectors; use Ada.Containers;
with GNATCOLL.JSON; use GNATCOLL.JSON;

with Util.Processes;
with Util.Streams.Pipes;
with Util.Streams.Buffered;

with GNAT.String_Split; use GNAT.String_Split;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

package body Soccer.PlayersPkg is

   use Players_Container;

   type Rand_Range is range 1 .. 8;
   package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);

   pass_range   : Integer := 3;
   tackle_range : Integer := 2;

   procedure Update_Distance (index : in Integer; players : in out Vector; distance : in Integer) is
      procedure Set_New_Distance (Element : in out Player_Status)  is
      begin
	 Element.distance := distance;
      end Set_New_Distance;
   begin
      players.Update_Element(index, Set_New_Distance'Access);
   end Update_Distance;

   -- needed to read the output file from Intelligence.jar
   function Load_File (Filename : in String) return String is
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

   function Get_Move_Utility (current_coord : in Coordinate; ball_coord : in Coordinate) return Integer is
      dist : Integer;
      result : Integer;
   begin
      dist := Distance(current_coord, ball_coord);
      result := (10 - (dist/5));
      if result = 0 then
         return 1;
      else
         return result;
      end if;
   end Get_Move_Utility;

   function Action_Outcome(target : in Coordinate; stat_1 : in Integer; stat_2 : in Integer) return Coordinate is
      type Probability is Range 1 .. 100;
      type Offset is Range 1 .. 24;
      package Random_Index is new Ada.Numerics.Discrete_Random (Probability);
      package Random_Offset is new Ada.Numerics.Discrete_Random (Offset);
      seed 	  : Random_Index.Generator;
      off         : Random_Offset.Generator;
      action_prob : Integer;
      outcome     : Integer;
      error	  : Offset;
      new_target  : Coordinate;
   begin
      action_prob := ((stat_1 + stat_2)/2);

      Random_Index.Reset(seed);
      outcome := Integer(Random_Index.Random(seed));

      if outcome <= action_prob then
         return target;
      else
         Random_Offset.Reset(off);
         error := Random_Offset.Random(off);
         case error is
            when 1  =>
               if target.coord_x > 0 then
                  new_target.coord_x := target.coord_x-1;
               else
                  new_target.coord_x := target.coord_x+1;
               end if;
               if target.coord_y < field_max_y then
                  new_target.coord_y := target.coord_y+1;
               else
                  new_target.coord_y := target.coord_y-1;
               end if;
               return Coordinate'(new_target.coord_x, new_target.coord_y);
--                 return Coordinate'(target.coord_x-1,target.coord_y+1);
            when 2  =>
               if target.coord_y < field_max_y then
                  new_target.coord_y := target.coord_y+1;
               else
                  new_target.coord_y := target.coord_y-1;
               end if;
               return Coordinate'(target.coord_x, new_target.coord_y);
--                 return Coordinate'(target.coord_x  ,target.coord_y+1);
            when 3  =>
               if target.coord_x < field_max_x then
                  new_target.coord_x := target.coord_x+1;
               else
                  new_target.coord_x := target.coord_x-1;
               end if;
               if target.coord_y < field_max_y then
                  new_target.coord_y := target.coord_y+1;
               else
                  new_target.coord_y := target.coord_y-1;
               end if;
               return Coordinate'(new_target.coord_x,new_target.coord_y);
--                 return Coordinate'(target.coord_x+1,target.coord_y+1);
            when 4  =>
               if target.coord_x < field_max_x then
                  new_target.coord_x := target.coord_x+1;
               else
                  new_target.coord_x := target.coord_x-1;
               end if;
               return Coordinate'(new_target.coord_x,target.coord_y);
--                  return Coordinate'(target.coord_x+1,target.coord_y);
            when 5  =>
               if target.coord_x < field_max_x then
                  new_target.coord_x := target.coord_x+1;
               else
                  new_target.coord_x := target.coord_x-1;
               end if;
               if target.coord_y > 0 then
                  new_target.coord_y := target.coord_y-1;
               else
                  new_target.coord_y := target.coord_y+1;
               end if;
               return Coordinate'(new_target.coord_x,new_target.coord_y);
--                 return Coordinate'(target.coord_x+1,target.coord_y-1);
            when 6  =>
               if target.coord_y > 0 then
                  new_target.coord_y := target.coord_y-1;
               else
                  new_target.coord_y := target.coord_y+1;
               end if;
               return Coordinate'(target.coord_x,new_target.coord_y);
--                 new_target := Coordinate'(target.coord_x  ,target.coord_y-1);
            when 7  =>
               if target.coord_x > 0 then
                  new_target.coord_x := target.coord_x-1;
               else
                  new_target.coord_x := target.coord_x+1;
               end if;
               if target.coord_y > 0 then
                  new_target.coord_y := target.coord_y-1;
               else
                  new_target.coord_x := target.coord_y+1;
               end if;
               return Coordinate'(new_target.coord_x,new_target.coord_y);
--                 new_target := Coordinate'(target.coord_x-1,target.coord_y-1);
            when 8  =>
               if target.coord_x > 0 then
                  new_target.coord_x := target.coord_x-1;
               else
                  new_target.coord_x := target.coord_x+1;
               end if;
               return Coordinate'(new_target.coord_x,target.coord_y);
--                 new_target := Coordinate'(target.coord_x-1,target.coord_y);
            when 9  =>
               if target.coord_x > 0 then
                  new_target.coord_x := target.coord_x-1;
               else
                  new_target.coord_x := target.coord_x+1;
               end if;
               if target.coord_y < field_max_y-1 then
                  new_target.coord_y := target.coord_y+2;
               else
                  new_target.coord_y := target.coord_y-2;
               end if;
               return Coordinate'(new_target.coord_x,new_target.coord_y);
--                 new_target := Coordinate'(target.coord_x-1,target.coord_y+2);
            when 10 =>
               if target.coord_y < field_max_y-1 then
                  new_target.coord_y := target.coord_y+2;
               else
                  new_target.coord_y := target.coord_y-2;
               end if;
               return Coordinate'(target.coord_x, new_target.coord_y);
--                 new_target := Coordinate'(target.coord_x  ,target.coord_y+2);
            when 11 =>
               if target.coord_x < field_max_x then
                  new_target.coord_x := target.coord_x+1;
               else
                  new_target.coord_x := target.coord_x-1;
               end if;
               if target.coord_y < field_max_y-1 then
                  new_target.coord_y := target.coord_y+2;
               else
                  new_target.coord_y := target.coord_y-2;
               end if;
               return Coordinate'(new_target.coord_x+1, new_target.coord_y+2);
--                 new_target := Coordinate'(target.coord_x+1,target.coord_y+2);
            when 12 =>
               if target.coord_x < field_max_x-1 then
                  new_target.coord_x := target.coord_x+2;
               else
                  new_target.coord_x := target.coord_x-2;
               end if;
               if target.coord_y < field_max_y-1 then
                  new_target.coord_y := target.coord_y+2;
               else
                  new_target.coord_y := target.coord_y-2;
               end if;
               return Coordinate'(new_target.coord_x, new_target.coord_y);
--                 new_target := Coordinate'(target.coord_x+2,target.coord_y+2);
            when 13 =>
               if target.coord_x < field_max_x-1 then
                  new_target.coord_x := target.coord_x+2;
               else
                  new_target.coord_x := target.coord_x-2;
               end if;
               if target.coord_y < field_max_y then
                  new_target.coord_y := target.coord_y+1;
               else
                  new_target.coord_y := target.coord_y-1;
               end if;
               return Coordinate'(target.coord_x, target.coord_y);
--                 new_target := Coordinate'(target.coord_x+2,target.coord_y+1);
            when 14 =>
               if target.coord_x < field_max_x-1 then
                  new_target.coord_x := target.coord_x+2;
               else
                  new_target.coord_x := target.coord_x-2;
               end if;
               return Coordinate'(new_target.coord_x, target.coord_y);
--                 new_target := Coordinate'(target.coord_x+2,target.coord_y);
            when 15 =>
               if target.coord_x < field_max_x-1 then
                  new_target.coord_x := target.coord_x+2;
               else
                  new_target.coord_x := target.coord_x-2;
               end if;
               if target.coord_y > 0 then
                  new_target.coord_y := target.coord_y-1;
               else
                  new_target.coord_y := target.coord_y+1;
               end if;
               return Coordinate'(new_target.coord_x, new_target.coord_y);
--                 new_target := Coordinate'(target.coord_x+2,target.coord_y-1);
            when 16 =>
               if target.coord_x < field_max_x-1 then
                  new_target.coord_x := target.coord_x+2;
               else
                  new_target.coord_x := target.coord_x-2;
               end if;
               if target.coord_y > 1 then
                  new_target.coord_y := target.coord_y-2;
               else
                  new_target.coord_y := target.coord_y+2;
               end if;
               return Coordinate'(new_target.coord_x, new_target.coord_y);
--                 new_target := Coordinate'(target.coord_x+2,target.coord_y-2);
            when 17 =>
               if target.coord_x < field_max_x then
                  new_target.coord_x := target.coord_x+1;
               else
                  new_target.coord_x := target.coord_x-1;
               end if;
               if target.coord_y > 1 then
                  new_target.coord_y := target.coord_y-2;
               else
                  new_target.coord_y := target.coord_y+2;
               end if;
               return Coordinate'(new_target.coord_x, new_target.coord_y);
--                 new_target := Coordinate'(target.coord_x+1,target.coord_y-2);
            when 18 =>
               if target.coord_y > 1 then
                  new_target.coord_y := target.coord_y-2;
               else
                  new_target.coord_y := target.coord_y+2;
               end if;
               return Coordinate'(target.coord_x, new_target.coord_y);
--                 new_target := Coordinate'(target.coord_x  ,target.coord_y-2);
            when 19 =>
               if target.coord_x > 0 then
                  new_target.coord_x := target.coord_x-1;
               else
                  new_target.coord_x := target.coord_x+1;
               end if;
               if target.coord_y > 1 then
                  new_target.coord_y := target.coord_y-2;
               else
                  new_target.coord_y := target.coord_y+2;
               end if;
               return Coordinate'(new_target.coord_x, new_target.coord_y);
--                 new_target := Coordinate'(target.coord_x-1,target.coord_y-2);
            when 20 =>
               if target.coord_x > 1 then
                  new_target.coord_x := target.coord_x-2;
               else
                  new_target.coord_x := target.coord_x+2;
               end if;
               if target.coord_y > 1 then
                  new_target.coord_y := target.coord_y-2;
               else
                  new_target.coord_y := target.coord_y+2;
               end if;
               return Coordinate'(new_target.coord_x, new_target.coord_y);
--                 new_target := Coordinate'(target.coord_x-2,target.coord_y-2);
            when 21 =>
               if target.coord_x > 1 then
                  new_target.coord_x := target.coord_x-2;
               else
                  new_target.coord_x := target.coord_x+2;
               end if;
               if target.coord_y > 0 then
                  new_target.coord_y := target.coord_y-1;
               else
                  new_target.coord_y := target.coord_y+1;
               end if;
               return Coordinate'(new_target.coord_x, new_target.coord_y);
--                 new_target := Coordinate'(target.coord_x-2,target.coord_y-1);
            when 22 =>
               if target.coord_x > 1 then
                  new_target.coord_x := target.coord_x-2;
               else
                  new_target.coord_x := target.coord_x+2;
               end if;
               return Coordinate'(new_target.coord_x, target.coord_y);
--                 new_target := Coordinate'(target.coord_x-2,target.coord_y);
            when 23 =>
               if target.coord_x > 1 then
                  new_target.coord_x := target.coord_x-2;
               else
                  new_target.coord_x := target.coord_x+2;
               end if;
               if target.coord_y < field_max_y then
                  new_target.coord_y := target.coord_y+1;
               else
                  new_target.coord_y := target.coord_y-1;
               end if;
               return Coordinate'(new_target.coord_x, new_target.coord_y);
--                 new_target := Coordinate'(target.coord_x-2,target.coord_y+1);
            when 24 =>
               if target.coord_x > 1 then
                  new_target.coord_x := target.coord_x-2;
               else
                  new_target.coord_x := target.coord_x+2;
               end if;
               if target.coord_y > 1 then
                  new_target.coord_y := target.coord_y-2;
               else
                  new_target.coord_y := target.coord_y+2;
               end if;
               return Coordinate'(new_target.coord_x, new_target.coord_y);
--                 new_target := Coordinate'(target.coord_x-2,target.coord_y+2);
         end case;
      end if;
   end Action_Outcome;

   function Get_Shot_Power (player_power : in Integer) return Power_Range is
      power : Integer;
      power_range : Integer range 1 .. 100;
   begin
      power := player_power;
      if power = 0 then
	 power := 1;
      end if;

      power_range := power;

      case power_range is
         when 1..10  => return 1;
         when 11..20 => return 2;
         when 21..30 => return 3;
         when 31..40 => return 4;
         when 41..50 => return 5;
         when 51..60 => return 6;
         when 61..70 => return 7;
         when 71..80 => return 8;
         when 81..90 => return 9;
         when 91..100 => return 10;
      end case;
   end Get_Shot_Power;

   procedure Print (input : String) is
   begin
      if debug then
	 pragma Debug (Put_Line (input));
	 null;
      end if;
   end Print;

   task body Player is
      id : Integer;
      current_coord : Coordinate;
      current_read_result : Read_Result;
      current_generic_status : Generic_Status_Ptr;
      current_game_status : Game_State;
      current_action : Action;
      seed_x : Rand_Int.Generator;
      seed_y : Rand_Int.Generator;

      -- Artificial Intelligence Related Variables
      event           : Game_Event_Ptr;			-- generic Game Event ptr
      ball_team       : Team_Id;			-- team holding the ball
      ball_x          : Integer;
      ball_y          : Integer;
      player_team     : Team_Id;			-- player's team
      player_number   : Integer;			-- player's number
      player_position : Coordinate;			-- player's current position
      player_stats    : Player_Statistics(1..7);	-- player's statistics
      nearby_folks    : JSON_Array;			-- nearby players list
      nearby_player   : JSON_Array;			-- naerby player info
      decision        : Unbounded_String;
      decision_x      : Integer;
      decision_y      : Integer;
      do_nothing      : Boolean := False;
      formation_pos   : Coordinate;
      subbed          : Boolean := False;
      change_id       : Boolean := False;
      new_player_number : Integer;
      new_player_id   : Integer;			-- id of the player that will substitute the current player

      -- True if the player is the one assigned to resume the game after a
      -- game event
      resume_player : Boolean := False;

      -- width of the "influence bubble" of the player. It is computed by
      -- dividing the sum of the player's statistics by a factor
      player_radius : Integer;
      radius_offset : Integer := 0;

      -- factor by which divide the sum of the statistics
      -- (Max_Stat_Value * Num_Stats) / (Field_Height/2)
      factor : Integer := (100*7) / (field_max_y/2);

      -- Unary Event (Goal_Kick, Corner_Kick, ...) pointer
      u_event : Unary_Event_Ptr;

      -- Match Event (Begin_Of_Match, End_Of_First_Half, ...) pointer
      m_event : Match_Event_Ptr;

      foolproof_catch : Boolean := False;

      -- Output file with JSON object
      output      : File_Type;
      output_name : Unbounded_String;			-- output file name

      assert_game_status : Unbounded_String;		-- game status
      assert_event 	 : Unbounded_String;		-- event type
      assert_goal_pos	 : Unbounded_String;		-- goal position

      package Nearby_Players is new Vectors(Natural, Unbounded_String);
      assert_nearby_all  : Nearby_Players.Vector;
      assert_nearby 	 : Unbounded_String;		-- nearby player
      assert_nearby_poss : Unbounded_String;		-- nearby player ball possession
      assert_nearby_team : Unbounded_String;		-- nearby player team

      assert_sub	 : Unbounded_String;		-- substitution

      assert_ball	 : Unbounded_String;		-- ball
      assert_ball_pos	 : Unbounded_String;		-- ball position
      assert_ball_poss	 : Unbounded_String;		-- ball possession

      assert_att_pos 	 : Unbounded_String;		-- attack position
      assert_start_pos 	 : Unbounded_String;		-- starting position
      assert_def_pos 	 : Unbounded_String;		-- defense position
      assert_ref_pos 	 : Unbounded_String;		-- reference position
      assert_gkick_pos	 : Unbounded_String;		-- goal kick position
      assert_ckick_pos   : Unbounded_String;		-- corner kick position
      assert_pkick_pos   : Unbounded_String;		-- penalty kick position
      assert_tin_pos	 : Unbounded_String;		-- throw-in position
      assert_fkick_pos	 : Unbounded_String;		-- free kick position

      assert_player	 : Unbounded_String;		-- player
      assert_position 	 : Unbounded_String;		-- player position
      assert_team	 : Unbounded_String;		-- player team
      assert_possession  : Unbounded_String;		-- player ball possession
      assert_last_holder : Unbounded_String;		-- player last holder
      assert_number 	 : Unbounded_String;		-- player number
      assert_radius	 : Unbounded_String;		-- player radius
      goalkeeper	 : Boolean := False;		-- goal keeper

      -- Variables needed to launch the Prolog engine
      command : Unbounded_String;
--        arguments : Argument_List_Access;
--        exit_status : Integer;
      file : File_Type;
--        count : Integer;

      status_string : Unbounded_String;

--        Pipe    : aliased Util.Streams.Pipes.Pipe_Stream;
--        Buffer  : Util.Streams.Buffered.Buffered_Stream;

--        Content : Unbounded_String;

      Subs : Slice_Set;
      Seps : constant String := "" & Comma;

      -- Time measuring variables
      t_start : Time;
      t_end : Time;

      t_ai_start : Time;
      t_ai_end : Time;

      t_controller_start : Time;
      t_controller_end : Time;

--        t_prolog_start : Time;
--        t_prolog_end : Time;

--        t_decision_start : Time;
--        t_decision_end : Time;

      previous_checkpoint : Time;
      previous_release : Time;

   begin

      previous_checkpoint := Clock;

--        Set_Directory (ai_basedir);

      --        Print ("[PLAYER_" & I2S (id) & "] Chiamato Start_1T");
      Game_Entity.Rest;
      Controller.Get_Id (id);
      Game_Entity.Start_1T;

      -- chiedo il mio ID al controllore
--        Print ("[PLAYER_" & I2S (id) & "] Ho il mio nuovo ID!");
--        Put_Line ("[PLAYER_" & I2S (id) & "] Ho il mio nuovo ID!");

--        ControllerPkg.Print_Status;

      loop

	 t_start := Clock;

--  	 Print ("[PLAYER_" & I2S (id) & "] Leggo Generic Status");
	 current_generic_status := ControllerPkg.Get_Generic_Status(id => id);
     --    Print ("[PLAYER_" & I2S (id) & "] MAGLIA: " & I2S(current_generic_status.number) &
     --     " TEAM: " & Team_Id'Image(current_generic_status.team));

	 if previous_checkpoint /= current_generic_status.last_checkpoint then
	    previous_checkpoint := current_generic_status.last_checkpoint;
	    previous_release := current_generic_status.last_checkpoint;
--  	    if id = 4 then
--  	       Print ("[PLAYER_" & I2S (id) & "] Nuovo checkpoint: " & Duration'Image (previous_checkpoint - t0));
--  	    end if;
	 end if;


	 current_coord := current_generic_status.coord;
	 current_game_status := current_generic_status.game_status;

	 if current_generic_status.must_exit then
	    ControllerPkg.Controller.Must_Exit;
	    exit;
	 end if;

         -- Json file name : STATUS<PlayerID>
         output_name := To_Unbounded_String("STATUS") & I2S(id);

	 -- Creates the file
--           Create (File => output,
--                   Mode => Out_File,
--                   Name => To_String(output_name));
--           Close (output);

--           Open (File => output,
--                 Mode => Append_File,
--                 Name => To_String(output_name));

         -- Get player current position
         player_position := current_generic_status.coord;
         assert_position := To_Unbounded_String("position(") & I2S(player_position.coord_x) & ","
           & I2S(player_position.coord_y) & ")";

         -- Get player's team
         player_team := current_generic_status.team;
         if player_team = Team_One then
            assert_team := To_Unbounded_String("team1");
         else
            assert_team := To_Unbounded_String("team2");
         end if;

         -- Do I have the ball?
         if current_generic_status.holder then
            assert_possession := To_Unbounded_String("has");
         else
            assert_possession := To_Unbounded_String("has_not");
         end if;

         -- Checks if the player was the last ball holder
         if current_generic_status.last_ball_holder_id = id then
            assert_last_holder := To_Unbounded_String("last_holder");
         else
            assert_last_holder := To_Unbounded_String("not_last_holder");
         end if;

         -- Create player clause
         assert_player := "player(" & assert_position & "," & assert_possession & "," &
           assert_team & "," & assert_last_holder & ")";
         status_string := status_string & assert_player & ",";

--  	String'Write(Stream(output), To_String(assert_player) & Ada.Characters.Latin_1.CR);

         -- Get player's number
         player_number := current_generic_status.number;
         assert_number := To_Unbounded_String("player_number(") & I2S(player_number) & ")";
--           String'Write(Stream(output), To_String(assert_number) & Ada.Characters.Latin_1.CR);
	status_string := status_string & assert_number & ",";

         -- Check if the player is the goalkeeper
         if player_number = Get_Goalkeeper_Number(player_team) then
            goalkeeper := True;
         else
            goalkeeper := False;
         end if;

         -- Get player's starting position
         formation_pos := Get_Starting_Position(player_number, player_team);
         assert_start_pos := To_Unbounded_String("starting_position(") & I2S(formation_pos.coord_x) & ","
           & I2S(formation_pos.coord_y) & ")";
--           String'Write(Stream(output), To_String(assert_start_pos) & Ada.Characters.Latin_1.CR);
         status_string := status_string & assert_start_pos & ",";

         -- Get player's defense position
         formation_pos := Get_Defense_Position(player_number, player_team);
         assert_def_pos := To_Unbounded_String("defense_position(") & I2S(formation_pos.coord_x) & ","
           & I2S(formation_pos.coord_y) & ")";
--           String'Write(Stream(output), To_String(assert_def_pos) & Ada.Characters.Latin_1.CR);
         status_string := status_string & assert_def_pos & ",";

         -- Get player's attack position
         formation_pos := Get_Attack_Position(player_number, player_team);
	 assert_att_pos := To_Unbounded_String("attack_position(") & I2S(formation_pos.coord_x) & ","
           & I2S(formation_pos.coord_y) & ")";
--           String'Write(Stream(output), To_String(assert_att_pos) & Ada.Characters.Latin_1.CR);
         status_string := status_string & assert_att_pos & ",";

         -- Get the ball coordinates
         ball_x := Ball.Get_Position.coord_x;
         ball_y := Ball.Get_Position.coord_y;
         assert_ball_pos := To_Unbounded_String("position(") & I2S(ball_x) & "," & I2S(ball_y) & ")";

         -- Get the team with ball possession
         ball_team := current_generic_status.holder_team;
         if ball_team = Team_One then
            assert_ball_poss := To_Unbounded_String("team1");
         elsif ball_team = Team_Two then
            assert_ball_poss := To_Unbounded_String("team2");
         end if;

         assert_ball := "ball(" & assert_ball_pos & "," & assert_ball_poss & ")";
--           String'Write(Stream(output), To_String(assert_ball) & Ada.Characters.Latin_1.CR);
         status_string := status_string & assert_ball & ",";

         -- Get game status (running, blocked, ready)
         if current_generic_status.game_status = Game_Running then
            assert_game_status := To_Unbounded_String("game(running)");
         elsif current_generic_status.game_status = Game_Blocked then
            assert_game_status := To_Unbounded_String("game(blocked)");
         elsif current_generic_status.game_status = Game_Ready then
            assert_game_status := To_Unbounded_String("game(ready)");
         end if;
--           String'Write(Stream(output), To_String(assert_game_status) & Ada.Characters.Latin_1.CR);
         status_string := status_string & assert_game_status & ",";

         -- Get goal position
         if player_team = Team_One then
            assert_goal_pos := To_Unbounded_String("goal_position(position(") & I2S(51) & "," &
              I2S(15) & "),position(" & I2S(51) & "," & I2S(19) & "))";
         else
           assert_goal_pos := To_Unbounded_String("goal_position(position(") & I2S(1) & "," &
              I2S(15) & "),position(" & I2S(1) & "," & I2S(19) & "))";
         end if;
--           String'Write(Stream(output), To_String(assert_goal_pos) & Ada.Characters.Latin_1.CR);
         status_string := status_string & assert_goal_pos & ",";

         -- Get player's statistics
         player_stats := Get_Statistics(player_number,player_team);

        -- Compute player's radius
         player_radius := (player_stats(1) +
                           player_stats(2) +
           		   player_stats(3) +
           		   player_stats(4) +
           		   player_stats(5) +
           		   player_stats(6) +
                           player_stats(7)) / factor;
         assert_radius := To_Unbounded_String("radius(") & I2S(player_radius) & ")";
--           String'Write(Stream(output), To_String(assert_radius) & Ada.Characters.Latin_1.CR);
         status_string := status_string & assert_radius & ",";

         -- Get game event.
         -- It could be either an Unary_Event_Ptr (Goal_Kick, Corner_Kick, ...)
         -- or a Match_Event_Ptr (Begin_Of_Match, End_Of_First_Half, ...)
	 event := Game_Event_Ptr(current_generic_status.last_game_event);
         if event /= null then
	    -- Match Event
            if event.all in Match_Event'Class then
	       m_event := Match_Event_Ptr(event);
	       -- Match Event: Begin_Of_Match or Begin_Of_Second_Half
               if Get_Match_Event_Id(m_event) = Begin_Of_Match
                 or Get_Match_Event_Id(m_event) = Begin_Of_Second_Half then
                  assert_event := To_Unbounded_String("event(init)");
--                    String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                  status_string := status_string & assert_event & ",";

                  -- If it's my duty to start the game
                  if Get_Kick_Off_Player(m_event) = id then
                     -- Get the ball coordinates
                     assert_ref_pos := To_Unbounded_String("reference_position(") & I2S(ball_x) & ","
                       & I2S(ball_y) & ")";
--                       String'Write(Stream(output), To_String(assert_ref_pos) & Ada.Characters.Latin_1.CR);
                     status_string := status_string & assert_ref_pos & ",";
                     resume_player := True;
                     radius_offset := 10;
                  end if;
               else
		  -- Match Event: End_Of_First_Half or End_Of_Match
                  assert_event := To_Unbounded_String("event(end)");
--                    String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                  status_string := status_string & assert_event & ",";
               end if;
	    else
	       -- Unary Event
	       u_event := Unary_Event_Ptr(event);
               if current_generic_status.game_status = Game_Ready then
                  case Get_Type(u_event) is
                     when Goal         =>
                        assert_event := To_Unbounded_String("event(goal)");
--                          String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                        status_string := status_string & assert_event & ",";
                     when Throw_In     =>
                        assert_event := To_Unbounded_String("event(throw_in)");
--                          String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                        status_string := status_string & assert_event & ",";
                     when Goal_Kick    =>
                        assert_event := To_Unbounded_String("event(goal_kick)");
--                          String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                        status_string := status_string & assert_event & ",";
                     when Corner_Kick  =>
                        assert_event := To_Unbounded_String("event(corner_kick)");
--                          String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                        status_string := status_string & assert_event & ",";
                     when Free_Kick    =>
                        assert_event := To_Unbounded_String("event(free_kick)");
--                          String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                        status_string := status_string & assert_event & ",";
                     when Penalty_Kick =>
                        assert_event := To_Unbounded_String("event(penalty_kick)");
--                          String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                        status_string := status_string & assert_event & ",";
                  end case;
               elsif current_generic_status.game_status = Game_Blocked then
                  foolproof_catch := True;
                  if current_generic_status.substitutions.Length > 0 then
                     declare
                        id_1 : Integer;
			id_2 : Integer;
                     begin
                        if subbed and (player_position.coord_x = id and player_position.coord_y = 0)  then
                           subbed := False;
                           assert_sub := To_Unbounded_String("substitution(in)");
                        elsif subbed then
                           assert_sub := To_Unbounded_String("substitution(out)");
			elsif not subbed then
                           for i in current_generic_status.substitutions.First_Index ..
                             current_generic_status.substitutions.Last_Index loop
                              Get_Numbers(current_generic_status.substitutions.Element(i), id_1, id_2);
                              new_player_number := Get_Backup_Number(current_generic_status.substitutions.Element(i));
                              if id = id_1 then
                                 assert_sub := To_Unbounded_String("substitution(out)");
                                 subbed := True;
                                 new_player_id := id_2;
                              end if;
                           end loop;
                        end if;
--                          String'Write(Stream(output), To_String(assert_sub) & Ada.Characters.Latin_1.CR);

			declare
			   assert_sub_fixed_string : String := To_String (assert_sub);
			begin
			   if assert_sub_fixed_string'Size /= 0 or assert_sub /= "" then
			      status_string := status_string & assert_sub & ",";
--  			      Put_Line ("[SUBSTITUTION] " & To_String (assert_sub));
			   end if;
			end;
                     end;
                  end if;

                  case Get_Type(u_event) is
                     when Goal =>
                        assert_event := To_Unbounded_String("event(goal)");
--                          String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                        status_string := status_string & assert_event & ",";
                     when Goal_Kick =>
                        assert_event := To_Unbounded_String("event(goal_kick)");
--                          String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                        status_string := status_string & assert_event & ",";
                        -- get player's goal kick position
                        formation_pos := Get_Goal_Kick_Position(player_number, player_team);
                        assert_gkick_pos := To_Unbounded_String("goal_kick_position(") & I2S(formation_pos.coord_x) &
                          "," & I2S(formation_pos.coord_y) & ")";
--                          String'Write(Stream(output), To_String(assert_gkick_pos) & Ada.Characters.Latin_1.CR);
                        status_string := status_string & assert_gkick_pos & ",";
                     when Corner_Kick =>
                        assert_event := To_Unbounded_String("event(corner_kick)");
--                          String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                        status_string := status_string & assert_event & ",";
                        -- get player's corner kick position
                        formation_pos := Get_Corner_Kick_Position(player_number,
                                                                  player_team,
                                                                  current_generic_status.holder_team);
                        assert_ckick_pos := To_Unbounded_String("corner_kick_position(") & I2S(formation_pos.coord_x) &
                          "," & I2S(formation_pos.coord_y) & ")";
--                          String'Write(Stream(output), To_String(assert_ckick_pos) & Ada.Characters.Latin_1.CR);
                        status_string := status_string & assert_ckick_pos & ",";
                     when Penalty_Kick =>
                        assert_event := To_Unbounded_String("event(penalty_kick)");
--                          String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                        status_string := status_string & assert_event & ",";
                        -- get player's penalty kick position
                        formation_pos := Get_Penalty_Kick_Position(player_number,
                                                                   player_team,
                                                                   current_generic_status.holder_team);
                        assert_pkick_pos := To_Unbounded_String("penalty_kick_position(") & I2S(formation_pos.coord_x) &
                          "," & I2S(formation_pos.coord_y) & ")";
--                          String'Write(Stream(output), To_String(assert_pkick_pos) & Ada.Characters.Latin_1.CR);
                        status_string := status_string & assert_pkick_pos & ",";
                     when Throw_In =>
                        assert_event := To_Unbounded_String("event(throw_in)");
--                          String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                        status_string := status_string & assert_event & ",";
                     when Free_Kick =>
                        assert_event := To_Unbounded_String("event(free_kick)");
--                          String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                        status_string := status_string & assert_event & ",";
                  end case;
               end if;

	       -- If it's my duty to resume the game
               if Get_Player_Id(u_event) = id then
		  -- Get the event coordinates
                  assert_ref_pos := To_Unbounded_String("reference_position(") & I2S(Get_Coordinate(u_event).coord_x) &
                    "," & I2S(Get_Coordinate(u_event).coord_y) & ")";
--                    String'Write(Stream(output), To_String(assert_ref_pos) & Ada.Characters.Latin_1.CR);
                  status_string := status_string & assert_ref_pos & ",";
                  resume_player := True;
                  radius_offset := 50;
               end if;
            end if;
         end if;

         -- Read Specific Status
         -- Returns players near me and the player currently holding the ball
         -- If the game is in status 'Ready' and the player is the one assigned to
         -- resume the game, I perform a Read_Status with an increased radius to
         -- avoid a situation where he has no team mates in his range (therefore
         -- he would not be able to resume the game)
         if resume_player and current_generic_status.game_status = Game_Ready then
            current_read_result :=
              ControllerPkg.Read_Status(x => current_generic_status.coord.coord_x,
                                        y => current_generic_status.coord.coord_y,
                                        r => player_radius + radius_offset);
            -- reset resume_player variable
            resume_player := False;
            radius_offset := 0;
         else
            current_read_result :=
              ControllerPkg.Read_Status(x => current_generic_status.coord.coord_x,
                                        y => current_generic_status.coord.coord_y,
                                        r => player_radius);
         end if;

         if current_read_result.players_in_my_zone.Length > 0 then
            for i in current_read_result.players_in_my_zone.First_Index ..
              current_read_result.players_in_my_zone.Last_Index loop
               assert_nearby := To_Unbounded_String("nearby_player(position(") &
                 I2S(current_read_result.players_in_my_zone.Element(i).coord.coord_x) &
                 "," &
                 I2S(current_read_result.players_in_my_zone.Element(i).coord.coord_y) & "),";

               if current_read_result.holder_id = current_read_result.players_in_my_zone.Element(i).id then
                  assert_nearby := assert_nearby & "has,";
               else
                  assert_nearby := assert_nearby & "has_not,";
               end if;
               if current_read_result.players_in_my_zone.Element(i).team = Team_One then
                  assert_nearby := assert_nearby & "team1)";
               else
                  assert_nearby := assert_nearby & "team2)";
               end if;
--                 String'Write(Stream(output), To_String(assert_nearby) & Ada.Characters.Latin_1.CR);
               status_string := status_string & assert_nearby & ",";
            end loop;
         end if;

         status_string := Delete(status_string, Length(status_string),Length(status_string));
         status_string := status_String;
--           Put_Line("************************** STRING **********************");
--           Put_Line(To_String(status_string));
--           Close (output);

	 t_ai_start := Clock;

         if goalkeeper then
            command := To_Unbounded_String("./launch_keeper.sh " & To_String(status_string));
         else
            command := To_Unbounded_String("./launch_player.sh " & To_String(status_string));
         end if;

--           if id = 12 then
--              Put_Line(To_String(status_string));
--           end if;
	 declare
	    Pipe    : aliased Util.Streams.Pipes.Pipe_Stream;
	    Buffer  : Util.Streams.Buffered.Buffered_Stream;

	    Content : Unbounded_String;
	 begin
	    Buffer.Initialize (null, Pipe'Unchecked_Access, 1024);
	    Pipe.Open (To_String (command), Util.Processes.READ);

	    Buffer.Read (Content);
	    Pipe.Close;

	    Create (S   => Subs,
	     From       => To_String (Content),
	     Separators => Seps,
	     Mode       => Multiple);

	    for I in 1 .. Slice_Count (Subs) loop
	       declare
		  Sub : constant String := Slice (Subs, I);
	       begin
		  if I = 1 then
		     decision_x := Integer'Value (Sub);
		  elsif I = 2 then
		     decision_y := Integer'Value (Sub);
		  else
		     decision := To_Unbounded_String (Sub);
		  end if;
	       end;
	    end loop;
	 end;

	 t_ai_end := Clock;

         if decision_x = 1000 and subbed then
            change_id := True;
         end if;

         if decision_x = 1000 then
            decision_x := id;
         end if;

         if decision = "pass" then
            declare
               new_shot_event : Shot_Event_Ptr;
            begin
               new_shot_event := new Shot_Event;

               new_shot_event.Initialize(id,
                                         player_number,
                                         player_team,
                                         current_coord,
                                         Action_Outcome(Coordinate'(decision_x,decision_y),
                   					player_stats(4),
                   					player_stats(5)));
               new_shot_event.Set_Shot_Power(Get_Shot_Power(player_stats(3)));
               current_action.event := Motion_Event_Ptr(new_shot_event);
	       current_action.utility := Get_Move_Utility(current_coord, Coordinate'(ball_x,ball_y));
            end;
         elsif decision = "shot" then
            declare
               new_shot_event : Shot_Event_Ptr;
            begin
               new_shot_event := new Shot_Event;

               new_shot_event.Initialize(id,
                 player_number,
                 player_team,
                 current_coord,
                 Action_Outcome(Coordinate'(decision_x,decision_y),
                   player_stats(1),
                   player_stats(4)));
               new_shot_event.Set_Shot_Power(Get_Shot_Power(player_stats(3)));
               current_action.event := Motion_Event_Ptr(new_shot_event);
               current_action.utility := Get_Move_Utility(current_coord, Coordinate'(ball_x,ball_y));
            end;
         elsif decision = "catch" then
            declare
               new_catch_event : Catch_Event_Ptr;
               target 	       : Coordinate;
            begin
               if not foolproof_catch then
                  if Get_Formation_Id(player_number, player_team) = 1 then
                     target := Action_Outcome(Coordinate'(decision_x,decision_y),
                                              player_stats(3),
                                              player_stats(6));
                  else
                     target := Action_Outcome(Coordinate'(decision_x,decision_y),
                                              player_stats(5),
                                              player_stats(6));
                  end if;
               else
                  target := Coordinate'(decision_x,decision_y);
                  foolproof_catch := False;
               end if;

               new_catch_event := new Catch_Event;

               new_catch_event.Initialize(id,
                                          player_number,
                                          player_team,
                                          current_coord,
                                          target);
               current_action.event := Motion_Event_Ptr(new_catch_event);
               current_action.utility := Get_Move_Utility(current_coord, Coordinate'(ball_x,ball_y));
            end;
         elsif decision = "tackle" then
            declare
               new_tackle_event : Tackle_Event_Ptr;
               target           : Coordinate;
            begin
               target := Action_Outcome(Coordinate'(decision_x,decision_y),
                                        player_stats(2),
                                        player_stats(7));
               -- se coordinate ottenute dall'IA e quelle ottenute dalla funzione
               -- Action_Outcome sono uguali allora la tackle viene eseguita
               if Compare_Coordinates(Coordinate'(decision_x,decision_y), target) then
                  new_tackle_event := new Tackle_Event;
                  new_tackle_event.Initialize(id,
                                              player_number,
                                              player_team,
                                              current_coord,
                                              target);
                  for i in current_read_result.players_in_my_zone.First_Index ..
                    current_read_result.players_in_my_zone.Last_Index loop
                     if Compare_Coordinates(target,
                                            current_read_result.players_in_my_zone.Element(i).coord) then
                        new_tackle_event.Set_Other_Player_Id(id => current_read_result.players_in_my_zone.Element(i).id);
                        exit;
                     end if;
                  end loop;
                  current_action.event := Motion_Event_Ptr(new_tackle_event);
                  current_action.utility := Get_Move_Utility(current_coord, Coordinate'(ball_x,ball_y));
               else
                  -- altrimenti la tackle non viene eseguita
                  -- faccio eseguire una move al giocatore sulle coordinate
                  -- ottenute dalla funzione Action_Outcome (target)
                  declare
                     new_move_event : Move_Event_Prt;
                  begin
                     new_move_event := new Move_Event;
                     new_move_event.Initialize(id,
                                               player_number,
                                               player_team,
                                               current_coord,
                                               target);
                     current_action.event := Motion_Event_Ptr(new_move_event);
                     current_action.utility := Get_Move_Utility(current_coord, Coordinate'(ball_x,ball_y));
                  end;
               end if;
            end;
         else
            declare
               new_move_event : Move_Event_Prt;
            begin
               new_move_event := new Move_Event;

               new_move_event.Initialize(id,
                                         player_number,
                                         player_team,
                                         current_coord,
                                         Coordinate'(decision_x,decision_y));
               current_action.event := Motion_Event_Ptr(new_move_event);

               if event /= null then
                  current_action.utility := 1;
               else
                  current_action.utility := Get_Move_Utility(current_coord, Coordinate'(ball_x,ball_y));
               end if;

               if current_coord.coord_x = decision_x and
                 current_coord.coord_y = decision_y then
                  do_nothing := True;
               end if;

               if event /= null then
                  -- Match Event
                  if event.all in Match_Event'Class then
                     m_event := Match_Event_Ptr(event);
                     if Get_Match_Event_Id(m_event) = End_Of_First_Half then
                        if current_coord = Coordinate'(id, 0) then
                           current_action.event := null;

                           -- aspetto l'inizio del secondo tempo
                           Game_Entity.Rest;
                           Game_Entity.Start_2T;
                        end if;
                     elsif Get_Match_Event_Id(m_event) = End_Of_Match then
                        if current_coord = Coordinate'(id, 0) then
                           current_action.event := null;
			   Game_Entity.End_Match;
			   Controller.Get_Id (id);
			   Game_Entity.Rest;
                           Game_Entity.Start_1T;
                            -- chiedo il mio ID al controllore
                           Print ("[PLAYER_" & I2S (id) & "] Ho il mio nuovo ID!");
                        end if;
                     end if;
                  end if;
               end if;
            end;
         end if;

	 t_controller_start := Clock;

	 if current_action.event /= null and not do_nothing then
            ControllerPkg.Controller.Write(current_action);

	    if change_id then
	       -- notifico alla squadra il cambiamento
	       Update_Map (player_number, new_player_number, player_team);

               id := new_player_id;
               change_id := False;
            end if;
         end if;

	 t_controller_end := Clock;

         current_action.event := null;
         do_nothing := False;
	 status_string := Null_Unbounded_String;

	 t_end := Clock;

--  	 Print ("[PLAYER " & I2S (id) & "] TOTAL TIME: " & Duration'Image (t_end - t_start));
--  	 Print ("[PLAYER " & I2S (id) & "] AI TIME: " & Duration'Image (t_ai_end - t_ai_start));
--  	 Print ("[PLAYER " & I2S (id) & "] PROLOG TIME: " & Duration'Image (t_prolog_end - t_prolog_start));
--  	 Print ("[PLAYER " & I2S (id) & "] DECISION TIME: " & Duration'Image (t_decision_end - t_decision_start));
--  	 Print ("[PLAYER " & I2S (id) & "] CONTROLLER TIME: " & Duration'Image (t_controller_end - t_controller_start));

	 --  	 if id = 4 then
--  	    Print ("[PLAYER " & I2S (id) & "] RELEASE BEFORE: " & Duration'Image (previous_release - t0) & " (hyperperiod is " & Duration'Image (hyperperiod_length) & ")");
--  	 end if;

	 previous_release := previous_release + (hyperperiod_length / (id mod 5 + 1));

--  	 if id = 4 then
--  	    Print ("[PLAYER " & I2S (id) & "] RELEASE AFTER: " & Duration'Image (previous_release - t0) & " (hyperperiod is " & Duration'Image (hyperperiod_length) & ")");
--  	 end if;

--  	 delay until previous_release; -- TODO:: metterla proporzionale alle statistiche e all'iperperiodo

--  	 if t_end - t_start > 3.0 then
--  	    raise Constraint_Error;
--  	 end if;

--  	 delay duration (players_delay); -- TODO:: metterla proporzionale alle statistiche e all'iperperiodo
      end loop;

   end Player;

end Soccer.PlayersPkg;
