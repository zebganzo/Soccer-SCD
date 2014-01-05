with Ada.Directories; use Ada.Directories;
with Soccer.Manager_Event.Substitution; use Soccer.Manager_Event.Substitution;
with Ada.Containers.Vectors; use Ada.Containers;
with GNATCOLL.JSON; use GNATCOLL.JSON;
with Ada.Characters;
with Ada.Characters.Latin_1;

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
            when 1  => return Coordinate'(target.coord_x-1,target.coord_y+1);
            when 2  => return Coordinate'(target.coord_x  ,target.coord_y+1);
            when 3  => return Coordinate'(target.coord_x+1,target.coord_y+1);
            when 4  => return Coordinate'(target.coord_x+1,target.coord_y);
            when 5  => return Coordinate'(target.coord_x+1,target.coord_y-1);
            when 6  => return Coordinate'(target.coord_x  ,target.coord_y-1);
            when 7  => return Coordinate'(target.coord_x-1,target.coord_y-1);
            when 8  => return Coordinate'(target.coord_x-1,target.coord_y);
            when 9  => return Coordinate'(target.coord_x-1,target.coord_y+2);
            when 10 => return Coordinate'(target.coord_x  ,target.coord_y+2);
            when 11 => return Coordinate'(target.coord_x+1,target.coord_y+2);
            when 12 => return Coordinate'(target.coord_x+2,target.coord_y+2);
            when 13 => return Coordinate'(target.coord_x+2,target.coord_y+1);
            when 14 => return Coordinate'(target.coord_x+2,target.coord_y);
            when 15 => return Coordinate'(target.coord_x+2,target.coord_y-1);
            when 16 => return Coordinate'(target.coord_x+2,target.coord_y-2);
            when 17 => return Coordinate'(target.coord_x+1,target.coord_y-2);
            when 18 => return Coordinate'(target.coord_x  ,target.coord_y-2);
            when 19 => return Coordinate'(target.coord_x-1,target.coord_y-2);
            when 20 => return Coordinate'(target.coord_x-2,target.coord_y-2);
            when 21 => return Coordinate'(target.coord_x-2,target.coord_y-1);
            when 22 => return Coordinate'(target.coord_x-2,target.coord_y);
            when 23 => return Coordinate'(target.coord_x-2,target.coord_y+1);
            when 24 => return Coordinate'(target.coord_x-2,target.coord_y+2);
         end case;
      end if;
   end Action_Outcome;

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
      arguments : Argument_List_Access;
      exit_status : Integer;
      file : File_Type;
      count : Integer;

   begin

--        Set_Directory (ai_basedir);

      Controller.Get_Id (id);
      --        Print ("[PLAYER_" & I2S (id) & "] Chiamato Start_1T");
      Game_Entity.Rest;
      Game_Entity.Start_1T;

      -- chiedo il mio ID al controllore
      Print ("[PLAYER_" & I2S (id) & "] Ho il mio nuovo ID!");

      loop
	 Print ("[PLAYER_" & I2S (id) & "] Leggo Generic Status");
	 current_generic_status := ControllerPkg.Get_Generic_Status(id => id);
     --    Print ("[PLAYER_" & I2S (id) & "] MAGLIA: " & I2S(current_generic_status.number) &
     --     " TEAM: " & Team_Id'Image(current_generic_status.team));
	 current_coord := current_generic_status.coord;
	 current_game_status := current_generic_status.game_status;

         -- Json file name : STATUS<PlayerID>
         output_name := To_Unbounded_String("STATUS") & I2S(id);

	 -- Creates the file
         Create (File => output,
                 Mode => Out_File,
                 Name => To_String(output_name));
         Close (output);

         Open (File => output,
               Mode => Append_File,
               Name => To_String(output_name));

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
           assert_team & "," & assert_last_holder & ").";

	String'Write(Stream(output), To_String(assert_player) & Ada.Characters.Latin_1.CR);

         -- Get player's number
         player_number := current_generic_status.number;
         assert_number := To_Unbounded_String("number(") & I2S(player_number) & ").";
        -- String'Write(Stream(output), To_String(assert_number) & Ada.Characters.Latin_1.CR);

         -- Check if the player is the goalkeeper
         if player_number = Get_Goalkeeper_Number(player_team) then
            goalkeeper := True;
         else
            goalkeeper := False;
         end if;

         -- Get player's starting position
         formation_pos := Get_Starting_Position(player_number, player_team);
         assert_start_pos := To_Unbounded_String("starting_position(") & I2S(formation_pos.coord_x) & ","
           & I2S(formation_pos.coord_y) & ").";
         String'Write(Stream(output), To_String(assert_start_pos) & Ada.Characters.Latin_1.CR);

         -- Get player's defense position
         formation_pos := Get_Defense_Position(player_number, player_team);
         assert_def_pos := To_Unbounded_String("defense_position(") & I2S(formation_pos.coord_x) & ","
           & I2S(formation_pos.coord_y) & ").";
         String'Write(Stream(output), To_String(assert_def_pos) & Ada.Characters.Latin_1.CR);

         -- Get player's attack position
         formation_pos := Get_Attack_Position(player_number, player_team);
	 assert_att_pos := To_Unbounded_String("attack_position(") & I2S(formation_pos.coord_x) & ","
           & I2S(formation_pos.coord_y) & ").";
         String'Write(Stream(output), To_String(assert_att_pos) & Ada.Characters.Latin_1.CR);

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

         assert_ball := "ball(" & assert_ball_pos & "," & assert_ball_poss & ").";
         String'Write(Stream(output), To_String(assert_ball) & Ada.Characters.Latin_1.CR);

         -- Get game status (running, blocked, ready)
         if current_generic_status.game_status = Game_Running then
            assert_game_status := To_Unbounded_String("game(running).");
         elsif current_generic_status.game_status = Game_Blocked then
            assert_game_status := To_Unbounded_String("game(blocked).");
         elsif current_generic_status.game_status = Game_Ready then
            assert_game_status := To_Unbounded_String("game(ready).");
         end if;
         String'Write(Stream(output), To_String(assert_game_status) & Ada.Characters.Latin_1.CR);

         -- Get goal position
         if player_team = Team_One then
            assert_goal_pos := To_Unbounded_String("goal_position(position(") & I2S(51) & "," &
              I2S(15) & "),position(" & I2S(51) & "," & I2S(19) & ")).";
         else
           assert_goal_pos := To_Unbounded_String("goal_position(position(") & I2S(1) & "," &
              I2S(15) & "),position(" & I2S(1) & "," & I2S(19) & ")).";
         end if;
         String'Write(Stream(output), To_String(assert_goal_pos) & Ada.Characters.Latin_1.CR);

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
         assert_radius := To_Unbounded_String("radius(") & I2S(player_radius) & ").";
         String'Write(Stream(output), To_String(assert_radius) & Ada.Characters.Latin_1.CR);

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
                  assert_event := To_Unbounded_String("event(init).");
                  String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);

                  -- If it's my duty to start the game
                  if Get_Kick_Off_Player(m_event) = id then
                     -- Get the ball coordinates
                     assert_ref_pos := To_Unbounded_String("reference_position(") & I2S(ball_x) & ","
                       & I2S(ball_y) & ").";
                     String'Write(Stream(output), To_String(assert_ref_pos) & Ada.Characters.Latin_1.CR);
                     resume_player := True;
                     radius_offset := 10;
                  end if;
               else
		  -- Match Event: End_Of_First_Half or End_Of_Match
                  assert_event := To_Unbounded_String("event(end).");
                  String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
               end if;
	    else
	       -- Unary Event
	       u_event := Unary_Event_Ptr(event);
               if current_generic_status.game_status = Game_Ready then
                  case Get_Type(u_event) is
                     when Goal         =>
                        assert_event := To_Unbounded_String("event(goal).");
                        String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                     when Throw_In     =>
                        assert_event := To_Unbounded_String("event(throw_in).");
                        String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                     when Goal_Kick    =>
                        assert_event := To_Unbounded_String("event(goal_kick).");
                        String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                     when Corner_Kick  =>
                        assert_event := To_Unbounded_String("event(corner_kick).");
                        String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                     when Free_Kick    =>
                        assert_event := To_Unbounded_String("event(free_kick).");
                        String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                     when Penalty_Kick =>
                        assert_event := To_Unbounded_String("event(penalty_kick).");
                        String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                  end case;
               elsif current_generic_status.game_status = Game_Blocked then
                  foolproof_catch := True;
                  if current_generic_status.substitutions.Length > 0 then
                     declare
                        id_1 : Integer;
                        id_2 : Integer;
                     begin
                        if subbed and (player_position.coord_y = 0)  then
                           subbed := False;
                           assert_sub := To_Unbounded_String("substitution(in).");
                        elsif subbed then
                           assert_sub := To_Unbounded_String("substitution(out).");
			elsif not subbed then
                           for i in current_generic_status.substitutions.First_Index ..
                             current_generic_status.substitutions.Last_Index loop
                              Get_Numbers(current_generic_status.substitutions.Element(i), id_1, id_2);
                              if id = id_1 then
                                 assert_sub := To_Unbounded_String("substitution(out).");
                                 subbed := True;
                                 new_player_id := id_2;
                              end if;
                           end loop;
                        end if;
                        String'Write(Stream(output), To_String(assert_sub) & Ada.Characters.Latin_1.CR);
                     end;
                  end if;

                  case Get_Type(u_event) is
                     when Goal =>
                        assert_event := To_Unbounded_String("event(goal).");
                        String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                     when Goal_Kick =>
                        assert_event := To_Unbounded_String("event(goal_kick).");
                        String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                        -- get player's goal kick position
                        formation_pos := Get_Goal_Kick_Position(player_number, player_team);
                        assert_gkick_pos := To_Unbounded_String("goal_kick_position(") & I2S(formation_pos.coord_x) &
                          "," & I2S(formation_pos.coord_y) & ").";
                        String'Write(Stream(output), To_String(assert_gkick_pos) & Ada.Characters.Latin_1.CR);
                     when Corner_Kick =>
                        assert_event := To_Unbounded_String("event(corner_kick).");
                        String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                        -- get player's corner kick position
                        formation_pos := Get_Corner_Kick_Position(player_number,
                                                                  player_team,
                                                                  current_generic_status.holder_team);
                        assert_ckick_pos := To_Unbounded_String("corner_kick_position(") & I2S(formation_pos.coord_x) &
                          "," & I2S(formation_pos.coord_y) & ").";
                        String'Write(Stream(output), To_String(assert_ckick_pos) & Ada.Characters.Latin_1.CR);
                     when Penalty_Kick =>
                        assert_event := To_Unbounded_String("event(penalty_kick).");
                        String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                        -- get player's penalty kick position
                        formation_pos := Get_Penalty_Kick_Position(player_number,
                                                                   player_team,
                                                                   current_generic_status.holder_team);
                        assert_pkick_pos := To_Unbounded_String("penalty_kick_position(") & I2S(formation_pos.coord_x) &
                          "," & I2S(formation_pos.coord_y) & ").";
                        String'Write(Stream(output), To_String(assert_pkick_pos) & Ada.Characters.Latin_1.CR);
                     when Throw_In =>
                        assert_event := To_Unbounded_String("event(throw_in).");
                        String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                     when Free_Kick =>
                        assert_event := To_Unbounded_String("event(free_kick).");
                        String'Write(Stream(output), To_String(assert_event) & Ada.Characters.Latin_1.CR);
                  end case;
               end if;

	       -- If it's my duty to resume the game
               if Get_Player_Id(u_event) = id then
		  -- Get the event coordinates
                  assert_ref_pos := To_Unbounded_String("reference_position(") & I2S(Get_Coordinate(u_event).coord_x) &
                    "," & I2S(Get_Coordinate(u_event).coord_y) & ").";
                  String'Write(Stream(output), To_String(assert_ref_pos) & Ada.Characters.Latin_1.CR);
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
         -- he would not be able to resume the game).
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
                  assert_nearby := assert_nearby & "team1).";
               else
                  assert_nearby := assert_nearby & "team2).";
               end if;
               String'Write(Stream(output), To_String(assert_nearby) & Ada.Characters.Latin_1.CR);
            end loop;
         end if;

         Close (output);

--           if goalkeeper then
--              command := To_Unbounded_String("sh launch_keeper.sh");
--           else
--              command := To_Unbounded_String("sh launch_player.sh");
--           end if;

         if goalkeeper then
            command := To_Unbounded_String("./exe_keeper " & To_String(output_name));
         else
            command := To_Unbounded_String("./exe_player " & To_String(output_name));
         end if;

         -- Load Prolog engine and read output file
         arguments := Argument_String_To_List (To_String(command));
         exit_status := Spawn (Program_Name => arguments(arguments'First).all,
                               Args         => arguments(arguments'First + 1 .. arguments'Last));

         --  Free memory
         Free (arguments);

--           Put_Line("PLAYER" & I2S(id) & "***************");
         Open (File => file,
               Mode => In_File,
               Name => "DECISION" & I2S(id));

         count := 0;
         while not End_Of_File (file) loop
            declare
               line  : String := Get_Line (file);
            begin
--                 Put_Line("DECISION" & I2S(id) & ": " & line & "****************");
               if count = 0 then
                  decision_x := Integer'Value(line);
                  count := count + 1;
--                    Put_Line("DECISION" & I2S(id) & ": decision_x : " & I2S(decision_x) & "****************");
               elsif count = 1 then
                  decision_y := Integer'Value(line);
                  count := count + 1;
--                    Put_Line("DECISION" & I2S(id) & ": decision_y : " & I2S(decision_y) & "****************");
               else
                  decision := To_Unbounded_String(line);
--                    Put_Line("DECISION" & I2S(id) & ": decision : " & To_String(decision) & "****************");
               end if;
            end;
         end loop;

         Close (file);

--           decision_x := 26;
--           decision_y := 17;
--           decision := To_Unbounded_String("move");

--           json := Read(Strm     => Load_File("DECISION" & I2S(id)),
--                        Filename => "");

--           Print("************JSON RESULT" & I2S(id) & "************");
--           Print(Get(Val   => json,
--                     Field => "X"));
--           Print(Get(Val   => json,
--                     Field => "Y"));
--           Print(Get(Val   => json,
--                     Field => "Decision"));

--           decision_x := Integer'Value(Get(Val   => json,
--                                           Field  => "X"));
         if decision_x = 1000 then
            decision_x := id;
         end if;

--           decision_y := Integer'Value(Get(Val   => json,
--                             	        Field  => "Y"));
--           decision := Get(Val   => json,
--                           Field => "Decision");

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
               new_shot_event.Set_Shot_Power(15);
               current_action.event := Motion_Event_Ptr(new_shot_event);
	       current_action.utility := 10;
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
                  new_shot_event.Set_Shot_Power(15);
                  current_action.event := Motion_Event_Ptr(new_shot_event);
                  current_action.utility := 10;

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
               current_action.utility := 10;
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
                  current_action.utility := 10;
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
               --                 Print ("[PLAYER_" & I2S (id) & " UTILITY: " & I2S(current_action.utility));
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
                           delay duration (id / 5); -- TODO:: change delay!
                           Game_Entity.Start_2T;
                        end if;
                     elsif Get_Match_Event_Id(m_event) = End_Of_Match then
                        if current_coord = Coordinate'(id, 0) then
                           current_action.event := null;
                           Game_Entity.End_Match;
                        end if;
                     end if;
                  end if;
               end if;
            end;
         end if;

--           Print ("[PLAYER_" & I2S (id) & " (" & I2S (player_number) &
--                    ") ] Starting coord: " & Print_Coord (current_coord));

--           Print ("[PLAYER_" & I2S (id) & " (" & I2S (player_number) &
--                    ") ] Target coord: " & Print_Coord (Coordinate'(decision_x, decision_y)) &
--                 "Decision: " & Ada.Strings.Unbounded.To_String(decision));

	 if current_action.event /= null and not do_nothing then
--  	    Put_Line ("[PLAYER_" & I2S (id) & "] Chiamo la Start");
--  	    Game_Entity.Start;
--  	    Print ("[PLAYER_" & I2S (id) & "] Chiamo la Write");
            ControllerPkg.Controller.Write(current_action);

	    if subbed and player_position.coord_x = 26 and player_position.coord_y = 0 then
	       -- notifico alla squadra il cambiamento
	       Update_Map (id, new_player_id, player_team);

               id := new_player_id;
            end if;
         end if;

         current_action.event := null;
         do_nothing := False;

	 delay duration (players_delay); -- TODO:: metterla proporzionale alle statistiche e all'iperperiodo
      end loop;

   end Player;

end Soccer.PlayersPkg;
