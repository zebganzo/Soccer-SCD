
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
      json_obj      : JSON_Value;			-- JSON object
      coords_array  : JSON_Array;			-- Array of coordinates
      event         : Game_Event_Ptr;			-- generic Game Event ptr
      ball_team     : Team_Id;				-- team holding the ball
      ball_x        : Integer;
      ball_y        : Integer;
      player_team   : Team_Id;				-- player's team
      player_stats  : Player_Statistics(1..7);		-- player's statistics
      nearby_folks  : JSON_Array;			-- nearby players list
      nearby_player : JSON_Array;			-- naerby player info
      player_number : Integer;				-- player's number
      decision      : Unbounded_String;
      decision_x    : Integer;
      decision_y    : Integer;
      do_nothing    : Boolean := False;
      formation_pos : Coordinate;

      -- True if the player is the one assigned to resume the game after a
      -- game event
      resume_player : Boolean := False;

      -- width of the "influence bubble" of the player. It is computed by
      -- dividing the sum of the player's statistics by a factor
      player_radius : Integer;

      -- factor by which divide the sum of the statistics
      -- (Max_Stat_Value * Num_Stats) / (Field_Height/2)
      factor : Integer := (100*7) / (field_max_y/2);

      -- Unary Event (Goal_Kick, Corner_Kick, ...) pointer
      u_event : Unary_Event_Ptr;

      -- Match Event (Begin_Of_Match, End_Of_First_Half, ...) pointer
      m_event : Match_Event_Ptr;

      -- Output file with JSON object
      output      : File_Type;
      output_name : String(1..8);			-- output file name

      -- Variables needed to launch the Intelligence.jar file
      command     : constant String := "/usr/bin/java -Djava.library.path=/usr/local/pl-6.4.1/lib/swipl-6.4.1/lib/i686-linux -jar Intelligence.jar ";
      arguments   : Argument_List_Access;
      exit_status : Integer;
      file        : File_Type;
      json        : JSON_Value;


   begin
      Controller.Get_Id (id);
--        Print ("[PLAYER_" & I2S (id) & "] Chiamato Start_1T");
      Game_Entity.Start_1T;

      -- chiedo il mio ID al controllore
      Print ("[PLAYER_" & I2S (id) & "] Ho il mio nuovo ID!");

--        current_action.event := new Move_Event;
--        current_generic_status := ControllerPkg.Get_Generic_Status(id => id);
--        current_coord := current_generic_status.coord;
--        target_coord := oblivium;
--
--        current_action.event.Initialize(nPlayer_Id => id,
--  				      nFrom      => current_coord,
--  				      nTo        => target_coord);
--        current_action.utility := 10;
--
--        Controller.Write(current_action => current_action);

      loop
	 Print ("[PLAYER_" & I2S (id) & "] Leggo Generic Status");
	 current_generic_status := ControllerPkg.Get_Generic_Status(id => id);
     --    Print ("[PLAYER_" & I2S (id) & "] MAGLIA: " & I2S(current_generic_status.number) &
     --     " TEAM: " & Team_Id'Image(current_generic_status.team));
	 current_coord := current_generic_status.coord;
	 current_game_status := current_generic_status.game_status;

         -- Creates an empty JSON object
         json_obj := Create_Object;

	 -- Get player current position
   	 Append(coords_array, Create(current_generic_status.coord.coord_x));
  	 Append(coords_array, Create(current_generic_status.coord.coord_y));
   	 json_obj.Set_Field(Field_Name => "position",
                    	    Field      => coords_array);
	 coords_array := Empty_Array;

	 -- Get player's team
	 player_team := current_generic_status.team;
         if player_team = Team_One then
            json_obj.Set_Field(Field_Name => "team",
                               Field 	  => "team1");
         else
            json_obj.Set_Field(Field_Name => "team",
                               Field 	  => "team2");
         end if;

         -- Get player's number
         player_number := current_generic_status.number;
         json_obj.Set_Field(Field_Name => "number",
                            Field      => Create(player_number));

         -- Check if the player is the goalkeeper
         if player_number = Get_Goalkeeper_Number(player_team) then
            json_obj.Set_Field(Field_Name => "goalkeeper",
                               Field      => "yes");
         end if;

         -- Get player's starting position
         formation_pos := Get_Starting_Position(player_number, player_team);
         Append(coords_array, Create(formation_pos.coord_x));
	 Append(coords_array, Create(formation_pos.coord_y));
         json_obj.Set_Field(Field_Name => "starting_position",
                            Field      => coords_array);
         coords_array := Empty_Array;

         -- Get player's defense position
         formation_pos := Get_Defense_Position(player_number, player_team);
         Append(coords_array, Create(formation_pos.coord_x));
	 Append(coords_array, Create(formation_pos.coord_y));
         json_obj.Set_Field(Field_Name => "defense_position",
                            Field      => coords_array);
         coords_array := Empty_Array;

         -- Get player's attack position
         formation_pos := Get_Attack_Position(player_number, player_team);
	 Append(coords_array, Create(formation_pos.coord_x));
	 Append(coords_array, Create(formation_pos.coord_y));
         json_obj.Set_Field(Field_Name => "attack_position",
                            Field      => coords_array);
         coords_array := Empty_Array;

         -- Get the ball coordinates
         ball_x := Ball.Get_Position.coord_x;
         ball_y := Ball.Get_Position.coord_y;
         Append(coords_array, Create(ball_x));
         Append(coords_array, Create(ball_y));
         json_obj.Set_Field(Field_Name => "ball_position",
                            Field      => coords_array);
         coords_array := Empty_Array;

         -- Do I have the ball?
         if current_generic_status.holder then
            json_obj.Set_Field(Field_Name => "possession",
                               Field      => "has");
         else
            json_obj.Set_Field(Field_Name => "possession",
                               Field 	  => "has_not");
         end if;

         -- Get game status (running, blocked, ready)
         if current_generic_status.game_status = Game_Running then
            json_obj.Set_Field(Field_Name => "game",
                               Field 	  => "running");
         elsif current_generic_status.game_status = Game_Blocked then
            json_obj.Set_Field(Field_Name => "game",
                               Field 	  => "blocked");
         elsif current_generic_status.game_status = Game_Ready then
           json_obj.Set_Field(Field_Name => "game",
                              Field 	 => "ready");
         end if;

         -- Get goal position
         if player_team = Team_One then
            Append(coords_array, Create(51));
            Append(coords_array, Create(15));
            Append(coords_array, Create(51));
            Append(coords_array, Create(19));
         else
            Append(coords_array, Create(1));
            Append(coords_array, Create(15));
            Append(coords_array, Create(1));
            Append(coords_array, Create(19));
         end if;
         json_obj.Set_Field(Field_Name => "goal_position",
                            Field      => coords_array);
         coords_array := Empty_Array;

         -- Get player's statistics
         player_stats := Get_Statistics(player_number,player_team);
--	 json_obj.Set_Field(Field_Name => "attack",
--                     	    Field      => Create(player_stats(1)));
--         json_obj.Set_Field(Field_Name => "defense",
--                            Field      => Create(player_stats(2)));
--         json_obj.Set_Field(Field_Name => "goal_keeping",
--                            Field      => Create(player_stats(3)));
--         json_obj.Set_Field(Field_Name => "power",
--                            Field      => Create(player_stats(4)));
--         json_obj.Set_Field(Field_Name => "precision",
--                            Field      => Create(player_stats(5)));
--         json_obj.Set_Field(Field_Name => "speed",
--                            Field      => Create(player_stats(6)));
--         json_obj.Set_Field(Field_Name => "tackle",
--                            Field      => Create(player_stats(7)));

        -- Compute player's radius
         player_radius := (player_stats(1) +
                           player_stats(2) +
           		   player_stats(3) +
           		   player_stats(4) +
           		   player_stats(5) +
           		   player_stats(6) +
                           player_stats(7)) / factor;
         json_obj.Set_Field(Field_Name => "radius",
                            Field      => Create(player_radius));

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
                  json_obj.Set_Field(Field_Name => "event",
                                     Field 	=> "init");

                  -- If it's my duty to start the game
                  if Get_Kick_Off_Player(m_event) = id then
                     -- Get the ball coordinates
                     Append(coords_array, Create(ball_x));
                     Append(coords_array, Create(ball_y));
                     json_obj.Set_Field(Field_Name => "reference_position",
                                        Field      => coords_array);
                     coords_array := Empty_Array;
                     resume_player := True;
                  end if;
               else
		  -- Match Event: End_Of_First_Half or End_Of_Match
                  json_obj.Set_Field(Field_Name => "event",
                                     Field 	=> "end");
               end if;
	    else
	       -- Unary Event
	       u_event := Unary_Event_Ptr(event);
               if current_generic_status.game_status = Game_Ready then
                  case Get_Type(u_event) is
                     when Goal         => json_obj.Set_Field(Field_Name => "event",
                                                             Field      => "goal");
                     when Throw_In     => json_obj.Set_Field(Field_Name => "event",
                                                             Field      => "throw_in");
                     when Goal_Kick    => json_obj.Set_Field(Field_Name => "event",
                                                             Field      => "goal_kick");
                     when Corner_Kick  => json_obj.Set_Field(Field_Name => "event",
                                                             Field      => "corner_kick");
                     when Free_Kick    => json_obj.Set_Field(Field_Name => "event",
                                                             Field      => "free_kick");
                     when Penalty_Kick => json_obj.Set_Field(Field_Name => "event",
                                                             Field      => "penalty_kick");
                  end case;
               elsif current_generic_status.game_status = Game_Blocked then
                  case Get_Type(u_event) is
                     when Goal =>
                        json_obj.Set_Field(Field_Name => "event",
                                           Field      => "goal");
                     when Goal_Kick =>
                        json_obj.Set_Field(Field_Name => "event",
                                           Field      => "goal_kick");

                        -- get player's goal kick position
                        formation_pos := Get_Goal_Kick_Position(player_number, player_team);
                        Append(coords_array, Create(formation_pos.coord_x));
                        Append(coords_array, Create(formation_pos.coord_y));
                        json_obj.Set_Field(Field_Name => "goal_kick_position",
                                           Field      => coords_array);
                        coords_array := Empty_Array;
                     when Corner_Kick =>
                        json_obj.Set_Field(Field_Name => "event",
                                           Field      => "corner_kick");

                        -- get player's corner kick position
                        formation_pos := Get_Corner_Kick_Position(player_number,
                                                                  player_team,
                                                                  current_generic_status.holder_team);
                        Append(coords_array, Create(formation_pos.coord_x));
                        Append(coords_array, Create(formation_pos.coord_y));
                        json_obj.Set_Field(Field_Name => "corner_kick_position",
                                           Field      => coords_array);
                        coords_array := Empty_Array;
                     when Penalty_Kick =>
                        json_obj.Set_Field(Field_Name => "event",
                                           Field      => "penalty_kick");

                        -- get player's penalty kick position
                        formation_pos := Get_Penalty_Kick_Position(player_number,
                                                                   player_team,
                                                                   current_generic_status.holder_team);
                        Append(coords_array, Create(formation_pos.coord_x));
                        Append(coords_array, Create(formation_pos.coord_y));
                        json_obj.Set_Field(Field_Name => "penalty_kick_position",
                                           Field      => coords_array);
                        coords_array := Empty_Array;
                     when Throw_In .. Free_Kick =>
                        json_obj.Set_Field(Field_Name => "event",
                                           Field      => "inactive_ball");
                  end case;
               end if;

	       -- If it's my duty to resume the game
               if Get_Player_Id(u_event) = id then
		  -- Get the event coordinates
                  Append(coords_array, Create(Get_Coordinate(u_event).coord_x));
                  Append(coords_array, Create(Get_Coordinate(u_event).coord_y));
                  json_obj.Set_Field(Field_Name => "reference_position",
                                     Field      => coords_array);
               	  coords_array := Empty_Array;
                  resume_player := True;
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
                                        r => player_radius + 100);
            -- reset resume_player variable
            resume_player := False;
         else
            current_read_result :=
              ControllerPkg.Read_Status(x => current_generic_status.coord.coord_x,
                                        y => current_generic_status.coord.coord_y,
                                        r => player_radius);
         end if;

         -- Get the team with ball possession
--           if Ball.Get_Controlled then
--              ball_team := Get_Player_Team_From_Id(current_read_result.holder_id);
         ball_team := current_generic_status.holder_team;
         if ball_team = Team_One then
            json_obj.Set_Field(Field_Name => "team_possession",
                               Field      => "team1");
         elsif ball_team = Team_Two then
            json_obj.Set_Field(Field_Name => "team_possession",
                               Field      => "team2");
         end if;

         -- Checks if the player was the last ball holder
         if current_generic_status.last_ball_holder_id = id then
            json_obj.Set_Field(Field_Name => "last_holder",
                               Field      => "yes");
         end if;
            --           else
            --              json_obj.Set_Field(Field_Name => "team_possession",
            --                                 Field      => "none");
            --              if current_generic_status.last_ball_holder_id = id then
            --                 json_obj.Set_Field(Field_Name => "last_holder",
            --                                    Field      => "yes");
--           end if;

         for i in current_read_result.players_in_my_zone.First_Index ..
           current_read_result.players_in_my_zone.Last_Index loop
            Append(nearby_player,
                   Create(current_read_result.players_in_my_zone.Element(i).coord.coord_x));
            Append(nearby_player,
                   Create(current_read_result.players_in_my_zone.Element(i).coord.coord_y));
            if current_read_result.holder_id = current_read_result.players_in_my_zone.Element(i).id then
               Append(nearby_player, Create("has"));
            else
               Append(nearby_player, Create("has_not"));
            end if;
            if current_read_result.players_in_my_zone.Element(i).team = Team_One then
               Append(nearby_player, Create("team1"));
            else
               Append(nearby_player, Create("team2"));
            end if;
            Append(nearby_folks, Create(nearby_player));
            nearby_player := Empty_Array;
         end loop;

         if current_read_result.players_in_my_zone.Length > 0 then
            json_obj.Set_Field(Field_Name => "nearby",
                               Field   => nearby_folks);
            nearby_folks := Empty_Array;
         end if;

         -- Json file name : STATUS<PlayerID>
--           if current_generic_status.game_status = Game_Ready then
--              output_name := "READYS" & Integer'Image(id);
--           else
            output_name := "STATUS " & I2S(id);
--           end if;
	 -- Creates the file
         Create (File => output,
                 Mode => Out_File,
                 Name => output_name);
--  	 -- Writes the Json object in the file
  	 String'Write(Stream(Output), json_obj.Write);
	 Close (Output);

         -- Load Intelligence.jar and read output file
--           Put_Line("************LOAD JAR" & Integer'Image(id) & "************");
         arguments := Argument_String_To_List(command & Integer'Image(id));
         exit_status := Spawn(Program_Name => arguments(arguments'First).all,
                              Args	   => arguments(arguments'First + 1 .. arguments'Last));

         json := Read(Strm     => Load_File("DECISION" & Integer'Image(id)),
                      Filename => "");

--           Print("************JSON RESULT" & Integer'Image(id) & "************");
--           Print(Get(Val   => json,
--                     Field => "X"));
--           Print(Get(Val   => json,
--                     Field => "Y"));
--           Print(Get(Val   => json,
--                     Field => "Decision"));

         decision_x := Integer'Value(Get(Val   => json,
                                         Field  => "X"));
         if decision_x = 1000 then
            decision_x := id;
         end if;
         decision_y := Integer'Value(Get(Val   => json,
                           	        Field  => "Y"));
         decision := Get(Val   => json,
                         Field => "Decision");

         if decision = "shot" or decision = "pass" then
            declare
               new_shot_event : Shot_Event_Ptr;
            begin
               new_shot_event := new Shot_Event;

               new_shot_event.Initialize(id,
                                         current_coord,
                                         Coordinate'(decision_x,decision_y));
               new_shot_event.Set_Shot_Power(15);
               current_action.event := Motion_Event_Ptr(new_shot_event);
               current_action.utility := 10;
            end;
         elsif decision = "catch" then
            declare
               new_catch_event : Catch_Event_Ptr;
            begin
               new_catch_event := new Catch_Event;

               new_catch_event.Initialize(id,
                                          current_coord,
                                          Coordinate'(decision_x,decision_y));
               current_action.event := Motion_Event_Ptr(new_catch_event);
               current_action.utility := 10;
            end;
         elsif decision = "tackle" then
            declare
               new_tackle_event : Tackle_Event_Ptr;
            begin
               new_tackle_event := new Tackle_Event;

               new_tackle_event.Initialize(id,
                                           current_coord,
                                           Coordinate'(decision_x,decision_y));
               for i in current_read_result.players_in_my_zone.First_Index ..
                 current_read_result.players_in_my_zone.Last_Index loop
                  if Compare_Coordinates(Coordinate'(decision_x,decision_y),
                                         current_read_result.players_in_my_zone.Element(i).coord) then
                     new_tackle_event.Set_Other_Player_Id(id => current_read_result.players_in_my_zone.Element(i).id);
                     exit;
                  end if;
               end loop;
               current_action.event := Motion_Event_Ptr(new_tackle_event);
               current_action.utility := 10;
               -- todo: id giocatore su cui fare tackle
            end;
         else
            declare
               new_move_event : Move_Event_Prt;
            begin
               new_move_event := new Move_Event;

               new_move_event.Initialize(id,
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
                           delay duration (id / 5);
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

         Print ("[PLAYER_" & I2S (id) & " (" & I2S (player_number) &
                  ") ] Starting coord: " & Print_Coord (current_coord));

         Print ("[PLAYER_" & I2S (id) & " (" & I2S (player_number) &
                  ") ] Target coord: " & Print_Coord (Coordinate'(decision_x, decision_y)) &
               "Decision: " & Ada.Strings.Unbounded.To_String(decision));

	 if current_action.event /= null and not do_nothing then
--  	    Put_Line ("[PLAYER_" & I2S (id) & "] Chiamo la Start");
--  	    Game_Entity.Start;
	    Print ("[PLAYER_" & I2S (id) & "] Chiamo la Write");
	    ControllerPkg.Controller.Write(current_action);
         end if;

         current_action.event := null;
         do_nothing := False;

	 delay duration (players_delay); -- TODO:: metterla proporzionale alle statistiche e all'iperperiodo
      end loop;

   end Player;

end Soccer.PlayersPkg;
