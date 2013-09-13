

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

   task body Player is
      id : Integer;
      current_coord : Coordinate;
      target_coord : Coordinate;
      current_read_result : Read_Result;
      current_generic_status : Generic_Status_Ptr;
      current_game_status : Game_State;
      current_team : Team_Id;
      last_game_event : Unary_Event_Ptr;
      current_match_event : Match_Event_Ptr;
      current_range : Integer;
      current_action : Action;
      seed_x : Rand_Int.Generator;
      seed_y : Rand_Int.Generator;

      -- Artificial Intelligence Related Variables
      json_obj      : JSON_Value;			-- JSON object
      coords_array  : JSON_Array;			-- Array of coordinates
      event         : Game_Event_Ptr;			-- generic Game Event ptr
      ball_team     : Team_Id;				-- team holding the ball
      player_team   : Team_Id;				-- player's team
      player_stats  : Player_Statistics(1..7);		-- player's statistics
      nearby_folks  : JSON_Array;			-- nearby players list
      nearby_player : JSON_Array;			-- naerby player info
      player_number : Integer;				-- player's number

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

   begin
      Controller.Get_Id (id);
--        ControllerPkg.Get_Id (id);

--        pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Chiamato Start_1T"));
      Game_Entity.Start_1T;

      -- chiedo il mio ID al controllore
      pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Ho il mio nuovo ID!"));

      current_action.event := new Move_Event;
      current_generic_status := ControllerPkg.Get_Generic_Status(id => id);
      current_coord := current_generic_status.coord;
      target_coord := oblivium;

      current_action.event.Initialize(nPlayer_Id => id,
				      nFrom      => current_coord,
				      nTo        => target_coord);
      current_action.utility := 10;

      Controller.Write(current_action => current_action);

      loop
	 pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Leggo Generic Status"));
	 current_generic_status := ControllerPkg.Get_Generic_Status(id => id);
     --    pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] MAGLIA: " & I2S(current_generic_status.number) &
     --     " TEAM: " & Team_Id'Image(current_generic_status.team)));
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

         -- Get player's starting position
         Append(coords_array, Create(Get_Starting_Position(player_number, player_team).coord_x));
	 Append(coords_array, Create(Get_Starting_Position(player_number, player_team).coord_y));
         json_obj.Set_Field(Field_Name => "starting_position",
                            Field      => coords_array);
         coords_array := Empty_Array;

         -- Get player's defense position
         Append(coords_array, Create(Get_Defense_Position(player_number, player_team).coord_x));
	 Append(coords_array, Create(Get_Defense_Position(player_number, player_team).coord_y));
         json_obj.Set_Field(Field_Name => "defense_position",
                            Field      => coords_array);
         coords_array := Empty_Array;

	 -- Get player's attack position
	 Append(coords_array, Create(Get_Attack_Position(player_number, player_team).coord_x));
	 Append(coords_array, Create(Get_Attack_Position(player_number, player_team).coord_y));
         json_obj.Set_Field(Field_Name => "attack_position",
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

         -- Get game status (running, blocked)
         if current_generic_status.game_status = Game_Running then
            json_obj.Set_Field(Field_Name => "game",
                               Field 	  => "running");
         elsif current_generic_status.game_status = Game_Blocked then
            json_obj.Set_Field(Field_Name => "game",
                               Field 	  => "blocked");
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
                     Append(coords_array, Create(Ball.Get_Position.coord_x));
                     Append(coords_array, Create(Ball.Get_Position.coord_y));
                     json_obj.Set_Field(Field_Name => "reference_position",
                                        Field      => coords_array);
                     coords_array := Empty_Array;
                  end if;
               else
		  -- Match Event: End_Of_First_Half or End_Of_Match
                  json_obj.Set_Field(Field_Name => "event",
                                     Field 	=> "end");
               end if;
	    else
	       -- Unary Event
	       u_event := Unary_Event_Ptr(event);
	       json_obj.Set_Field(Field_Name => "event",
                                  Field      => "inactive_ball");

	       -- If it's my duty to resume the game
               if Get_Player_Id(u_event) = id then
		  -- Get the event coordinates
                  Append(coords_array, Create(Get_Coordinate(u_event).coord_x));
                  Append(coords_array, Create(Get_Coordinate(u_event).coord_y));
                  json_obj.Set_Field(Field_Name => "reference_position",
                                     Field      => coords_array);
               	  coords_array := Empty_Array;
               end if;
            end if;
         end if;

         -- Get the ball coordinates
         Append(coords_array, Create(Ball.Get_Position.coord_x));
         Append(coords_array, Create(Ball.Get_Position.coord_y));
         json_obj.Set_Field(Field_Name => "ball_position",
                            Field      => coords_array);
         coords_array := Empty_Array;

         -- Read Specific Status
         -- Returns players near me and the player currently holding the ball
         current_read_result :=
           ControllerPkg.Read_Status(x => current_generic_status.coord.coord_x,
	                             y => current_generic_status.coord.coord_y,
                                     r => player_radius);

         -- Get the team with ball possession
         if Ball.Get_Controlled then
            ball_team := Get_Team_From_Id(current_read_result.holder_id);
            if ball_team = Team_One then
               json_obj.Set_Field(Field_Name => "team_possession",
                                  Field      => "team1");
            else
               json_obj.Set_Field(Field_Name => "team_possession",
                                  Field      => "team2");
            end if;
         else
            json_obj.Set_Field(Field_Name => "team_possession",
                               Field      => "none");
         end if;

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
            json_obj.Set_Field(Field_Name => "nearby",
                               Field      => nearby_folks);
            nearby_folks := Empty_Array;
         end loop;

         -- Json file name : STATUS<PlayerID>
	 output_name := "STATUS" & Integer'Image(id);
	 -- Creates the file
        Create (File => output,
                 Mode => Out_File,
                 Name => output_name);
--  	 -- Writes the Json object in the file
  	 String'Write(Stream(Output), json_obj.Write);
	 Close (Output);


	 pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Controllo che tipo di evento c'e'"));
	 if current_generic_status.last_game_event /= null then
	    if current_generic_status.last_game_event.all in Match_Event'Class then
	       pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] C'e' un Match_Event"));
	       current_match_event := Match_Event_Ptr (current_generic_status.last_game_event);
	       last_game_event := null;
	    else
	       pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] C'e' un Game_Event"));
	       last_game_event := Unary_Event_Ptr (current_generic_status.last_game_event);
	       current_match_event := null;
	    end if;
	 end if;

	 current_team := current_generic_status.team;

	 if current_generic_status.holder then
	    current_range := player_radius;
	 elsif current_generic_status.nearby then
	    current_range := nearby_distance;
	 else
	    current_range := 1;
	 end if;

	 -- sulla base delle mie statistiche, chiedo la mia "bolla" di stato
	 pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Leggo lo stato con la mia bolla"));
	 current_read_result := ControllerPkg.Read_Status(x => current_coord.coord_x,
						   y => current_coord.coord_y,
						   r => current_range);

	 -- calcolo la distanza che mi separa dai giocatori che ho intorno
  	 pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Pre-calcolo le distanze con gli altri giocatori che ho vicino a me"));
	 for i in current_read_result.players_in_my_zone.First_Index .. current_read_result.players_in_my_zone.Last_Index loop
	    declare
	       other_coord : Coordinate;
	    begin
	       other_coord := current_read_result.players_in_my_zone.Element (Index => i).coord;
	       Update_Distance(index       => i,
			players  => current_read_result.players_in_my_zone,
			distance => Utils.Distance(From => current_coord,
			      To   => other_coord));

	    end;
	 end loop;

	 -- controllo lo stato di gioco e decido l'azione da fare
	 pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Controllo lo stato di gioco per decidere l'azione"));
	 pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] La mia posizione e' " & Print_Coord (current_coord)));
	 case current_game_status is
	 when Game_Running =>

	    pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Stato di gioco: Game_Running"));

	    --+---------------
     	    --+ GAME RUNNING
	    --+---------------

	    pragma Debug (Put_Line("[PLAYER_" & I2S (id) & "] Ho la palla vicina? " & Boolean'Image(current_generic_status.nearby)));

	    if current_generic_status.holder then
	       -- Che bello ho la palla, se sono in pericolo la passo se no fanculo tutti!
	       declare
		  foundPlayer : Boolean := False;
	       begin
		  for i in current_read_result.players_in_my_zone.First_Index .. current_read_result.players_in_my_zone.Last_Index loop
		     if current_read_result.players_in_my_zone.Element(Index => i).team /= player_team and
		       current_read_result.players_in_my_zone.Element(Index => i).distance <= pass_range then
			foundPlayer := True;
		     end if;
		  end loop;

		  if foundPlayer then
		     declare
			playerTarget : Integer := -1;
		     begin
			for i in current_read_result.players_in_my_zone.First_Index .. current_read_result.players_in_my_zone.Last_Index loop
			   if current_read_result.players_in_my_zone.Element(Index => i).team = player_team and
			     current_read_result.players_in_my_zone.Element(Index => i).distance <= 10 then -- tutti con la stessa forza di tiro
			      playerTarget := i;
			   end if;
			end loop;

			if playerTarget = -1 then
			   declare
			      target : Coordinate := Utils.Get_Random_Target(coord => current_coord);
			   begin

			      current_action.event := new Move_Event;
			      current_action.event.Initialize(nPlayer_Id => id,
					 nFrom      => current_coord,
					 nTo        => target);
			      current_action.utility := 10;
			   end;
			else
			   current_action.event := new Shot_Event;
			   current_action.event.Initialize(id, current_coord,
				      current_read_result.players_in_my_zone.Element(Index => playerTarget).coord);
			   pragma Debug (Put_Line("[PLAYER_" & I2S (id) & "] Mi stanno per rubare palla, la passo al mio amico " & I2S(current_read_result.players_in_my_zone.Element(Index => playerTarget).id)));
			   Shot_Event_Ptr(current_action.event).Set_Shot_Power (10);
			   current_action.utility := 10;
			end if;
		     end;
		  else
		     declare
			target : Coordinate := Utils.Get_Random_Target(coord => current_coord);
		     begin

			current_action.event := new Move_Event;
			current_action.event.Initialize(nPlayer_Id => id,
				   nFrom      => current_coord,
				   nTo        => target);
			current_action.utility := 10;
		     end;
		  end if;
	       end;
	    elsif current_generic_status.nearby then
	       -- Sono vicnino alla palla! Meglio essere coscienziosi
	       if Compare_Coordinates (Ball.Get_Position, current_coord) then
		  current_action.event := new Catch_Event;
		  current_action.event.Initialize (id, current_coord,
				     Ball.Get_Position);
		  current_action.utility := 10;
	       else
		  if Ball.Get_Controlled then
		     declare
			targetPlayer : Coordinate := Coordinate'(coord_x => 0,
					    coord_y => 0);
			targetPlayerId : Integer := 0;
		     begin
			-- controllata da un giocatore
			for i in current_read_result.players_in_my_zone.First_Index .. current_read_result.players_in_my_zone.Last_Index loop
			   if current_read_result.players_in_my_zone.Element(Index => i).id = current_read_result.holder_id then
			      if current_read_result.players_in_my_zone.Element(Index => i).team /= player_team then
				 -- la controlla un avversario
				 targetPlayer := current_read_result.players_in_my_zone.Element(Index => i).coord;
				 targetPlayerId := current_read_result.players_in_my_zone.Element(Index => i).id;
			      end if;
			   end if;
			end loop;
			if targetPlayer.coord_x = 0 then
			   -- la controlla un compagno di squadra -> mi muovo a caso!
			   declare
			      target : Coordinate := Utils.Get_Random_Target(coord => current_coord);
			   begin

			      current_action.event := new Move_Event;
			      current_action.event.Initialize(nPlayer_Id => id,
					 nFrom      => current_coord,
					 nTo        => target);
			      current_action.utility := 10;
			   end;
			else
			   if Utils.Distance(From => current_coord,
			To   => targetPlayer) = 1 then
			      -- tackle!
			      current_action.event := new Tackle_Event;
			      current_action.event.Initialize(id, current_coord,
					 targetPlayer);
			      Tackle_Event_Ptr(current_action.event).Set_Other_Player_Id(id => targetPlayerId);
			      current_action.utility := 10;
			   else
			      -- mi sposto verso di lui!!
			      current_action.event := new Move_Event;
			      current_action.event.Initialize(nPlayer_Id => id,
					 nFrom      => current_coord,
					 nTo        => Utils.Get_Next_Coordinate(myCoord     => current_coord,
					      targetCoord => targetPlayer));
			      current_action.utility := 10;
			   end if;
			end if;
		     end;
		  else
		     current_action.event := new Move_Event;
		     current_action.event.Initialize(nPlayer_Id => id,
				       nFrom      => current_coord,
				       nTo        => Utils.Get_Next_Coordinate(myCoord     => current_coord,
						   targetCoord => Ball.Get_Position));
		     current_action.utility := 10;
		  end if;
	       end if;
	    else
	       -- Mi muovo a caso!
	       declare
		  target : Coordinate := Utils.Get_Random_Target(coord => current_coord);
	       begin

		  current_action.event := new Move_Event;
		  current_action.event.Initialize (nPlayer_Id => id,
				     nFrom      => current_coord,
				     nTo        => target);
		  current_action.utility := 10;
	       end;
	    end if;

	 when Game_Ready =>

	    --+---------------
     	    --+ GAME READY
	    --+---------------

	    pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Stato di gioco: Game_Ready"));

	    -- controllo se sono ad un evento notevole della partita
	    pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Controllo se il Match_Event e' settato"));
	    if current_match_event /= null then
	       pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Controllo se sono all'inizio del gioco"));
	       if Get_Match_Event_Id (current_match_event) = Begin_Of_Match
		 or Get_Match_Event_Id (current_match_event) = Begin_Of_Second_Half then
		  pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Controllo se sono il giocatore che deve far ripartire il gioco"));
		  -- controllo se sono il giocatore che deve far ripartire il gioco
		  if Get_Kick_Off_Player (current_match_event) = id then
		     declare
			shot_target : Coordinate := Coordinate'(current_coord.coord_x, current_coord.coord_y);
		     begin
			-- cerco il compagno piu' lontano
			for i in current_read_result.players_in_my_zone.First_Index .. current_read_result.players_in_my_zone.Last_Index loop
			   declare
			      current_player_status : Player_Status := current_read_result.players_in_my_zone.Element (i);
			   begin
			      if current_player_status.team = player_team then
				 if Distance (current_player_status.coord, current_coord) > Distance (shot_target, current_coord) then
				    shot_target := current_player_status.coord;
				 end if;
			      end if;
			   end;
			end loop;

			-- la passo al mio compagno
			current_action.event := new Shot_Event;
			current_action.event.Initialize (id,
				    current_coord,
				    shot_target);
			Shot_Event_Ptr(current_action.event).Set_Shot_Power (10);
			current_action.utility := 10;
			pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Calcio d'inizio verso la cella " & Print_Coord (shot_target)));
		     end;
		  end if;
	       end if;

	    -- controllo se sono il giocatore che fa ripartire il gioco
	    elsif id = Get_Player_Id (last_game_event) then
	       -- ho sicuramente la palla, altrimenti il gioco non sarebbe ready
	       -- devo solo farlo ripartire, passandola ad uno dei miei compagni (a caso)

	       declare
		  shot_target : Coordinate := Coordinate'(0,0);
	       begin
		  -- cerco il compagno piu' lontano
		  for i in current_read_result.players_in_my_zone.First_Index .. current_read_result.players_in_my_zone.Last_Index loop
		     declare
			current_player_status : Player_Status := current_read_result.players_in_my_zone.Element (i);
		     begin
			if current_player_status.team = player_team then
			   if Distance (current_player_status.coord, current_coord) >
			     Distance (shot_target, current_coord) then
			      shot_target := current_player_status.coord;
			   end if;
			end if;
		     end;
		  end loop;

		  -- la passo al mio compagno
		  current_action.event := new Shot_Event;
		  current_action.event.Initialize (id,
				     current_coord,
				     shot_target);
		  Shot_Event_Ptr(current_action.event).Set_Shot_Power (10);
		  current_action.utility := 10;
	       end;
	    else
	       -- sono uno degli altri giocatori
	       if player_team = Get_Team (last_game_event) then
		  -- sono un compagno di squadra di chi deve battere, quindi al
		  -- massimo vado nella mia posizione di riferimeto, oppure sto fermo
                  if current_coord /= Get_Coordinate_For_Player (player_team,
                                                                 current_generic_status.holder_team,
                                                                 player_number) then
		     current_action.event := new Move_Event;
                     current_action.event.Initialize (id,
                                                      current_coord,
                                                      Get_Next_Coordinate (current_coord,
                         						   Get_Coordinate_For_Player (player_team,
                           									      current_generic_status.holder_team,
                           									      player_number)));
		     current_action.utility := 10; -- TODO:: cambiare utilita'
		  end if;
	       else
		  -- sono un avversario, sto fermo dove sono
		  -- TODO:: al massimo mi sposto verso la mia porta
		  null;
	       end if;
	    end if;

	 when Game_Blocked =>

	    --+---------------
     	    --+ GAME BLOCKED
	    --+---------------

	    pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Stato di gioco: Game_Blocked"));

	    -- controllo se sono ad un evento notevole della partita
	    pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Controllo se il Match_Event e' settato"));
	    if current_match_event /= null then
	       pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Controllo se sono all'inizio del gioco"));
	       if Get_Match_Event_Id (current_match_event) = Begin_Of_Match or Get_Match_Event_Id (current_match_event) = Begin_Of_Second_Half then
		  pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Controllo se sono il giocatore che deve far ripartire il gioco"));
		  -- controllo se sono il giocatore che deve far ripartire il gioco
		  if Get_Kick_Off_Player (current_match_event) = id then
		     pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Sono quello che deve far riprendere il gioco"));
		     -- controllo se ho la palla
		     if not current_generic_status.holder then
			-- controllo se sono sopra la palla
			if Compare_Coordinates (coord1 => current_generic_status.coord,
			   coord2 => Ball.Get_Position) then
			   -- prendo la palla
			   current_action.event := new Catch_Event;
			   current_action.event.Initialize(nPlayer_Id => id,
				      nFrom      => current_coord,
				      nTo        => Ball.Get_Position);

			   current_action.utility := 10; -- TODO:: cambiare utilita'
			else
			   -- mi muovo verso la palla
			   current_action.event := new Move_Event;
			   current_action.event.Initialize (nPlayer_Id => id,
				       nFrom      => current_coord,
				       nTo        => Get_Next_Coordinate (current_coord,
					 Ball.Get_Position));
			   current_action.utility := 5; -- TODO:: cambiare utilita'
			   pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Mi sposto alla coordinata "
		& Print_Coord (Get_Next_Coordinate (current_coord, Ball.Get_Position))));
			end if;
		     end if;
		  else
		     pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Non devo far riprendere il gioco"));
		     -- controllo se sono nella mia posizione di riferimento
		     if not Compare_Coordinates (current_coord, Get_Starting_Position (player_number,player_team)) then

			-- controllo se sono in panchina
			if Compare_Coordinates (current_coord, Coordinate'(id,0)) then
			   -- mi sposto su oblivium
			   pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Mi sposto verso Oblivium"));
			   current_action.event := new Move_Event;
			   current_action.event.Initialize (nPlayer_Id => id,
				       nFrom      => current_coord,
				       nTo        => Get_Next_Coordinate (current_coord, oblivium));
			   current_action.utility := 10; -- TODO:: cambiare utilita'
			elsif Compare_Coordinates (current_coord, oblivium) then
			   -- entro in campo
			   declare
			      next_to_oblivium : Coordinate;
			   begin
			      next_to_oblivium := oblivium;
			      next_to_oblivium.coord_y := 1;

			      current_action.event := new Move_Event;
			      current_action.event.Initialize (nPlayer_Id => id,
					  nFrom      => current_coord,
					  nTo        => next_to_oblivium);
			      current_action.utility := 10; -- TODO:: cambiare utilita'
			   end;
			else
			   -- mi sposto nella mia posizione di riferimento
			   pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Mi sposto nella cella "
			     & Print_Coord (Get_Next_Coordinate (current_coord, Get_Starting_Position (player_number,player_team)))
			     & " verso la mia posizione di riferimento " & Print_Coord (Get_Starting_Position (player_number,player_team))
			     & " partendo dalla cella " & Print_Coord (current_coord)));
			   current_action.event := new Move_Event;
			   current_action.event.Initialize (id,
				       current_coord,
				       Get_Next_Coordinate (current_coord, Get_Starting_Position (player_number,player_team)));
			   current_action.utility := 5; -- TODO:: cambiare utilita'
			end if;
		     else
			pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Sono nella mia posizione di riferimento"));
			current_action.event := null;
		     end if;
		  end if;
	       elsif Get_Match_Event_Id (current_match_event) = End_Of_First_Half then
		  if current_coord = Coordinate'(id, 0) then
		     -- aspetto l'inizio del secondo tempo
		     Game_Entity.Rest;
		     delay duration (id / 5);
		     Game_Entity.Start_2T;
		  elsif current_coord = oblivium then
		     -- mi sposto nella mia cella in panchina
		     current_action.event := new Move_Event;
		     current_action.event.Initialize (nPlayer_Id => id,
					nFrom      => current_coord,
					nTo        => Coordinate'(id, 0));
		     current_action.utility := 10; -- TODO:: cambiare utilita'
		  else
		     -- se ho la palla, la mollo giu'
		     if current_generic_status.holder then
			-- mollo la palla (la tiro nella posizione dove sono)
			current_action.event := new Shot_Event;
			current_action.event.Initialize(id, current_coord, current_coord);
			Shot_Event_Ptr(current_action.event).Set_Shot_Power (1);
			current_action.utility := 10;
		     else
			-- mi sposto verso la cella oblivium
			pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Mi sposto verso Oblivium"));
			current_action.event := new Move_Event;
			current_action.event.Initialize (nPlayer_Id => id,
				    nFrom      => current_coord,
				    nTo        => Get_Next_Coordinate (current_coord, oblivium));
			current_action.utility := 10; -- TODO:: cambiare utilita'
		     end if;
		  end if;

	       elsif Get_Match_Event_Id (current_match_event) = End_Of_Match then
		  if current_coord = Coordinate'(id, 0) then
		     -- mi accodo per la distruzione
		     Game_Entity.End_Match;
		  elsif current_coord = oblivium then
		     -- mi sposto nella mia cella in panchina
		     current_action.event := new Move_Event;
		     current_action.event.Initialize (nPlayer_Id => id,
					nFrom      => current_coord,
					nTo        => Coordinate'(id, 0));
		     current_action.utility := 10; -- TODO:: cambiare utilita'
		  else
		     -- se ho la palla, la mollo giu'
		     if current_generic_status.holder then
			-- mollo la palla (la tiro nella posizione dove sono)
			current_action.event := new Shot_Event;
			current_action.event.Initialize(id, current_coord, current_coord);
			Shot_Event_Ptr(current_action.event).Set_Shot_Power (1);
			current_action.utility := 10;
		     else
			-- mi sposto verso la cella oblivium
			pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Mi sposto verso Oblivium"));
			current_action.event := new Move_Event;
			current_action.event.Initialize (nPlayer_Id => id,
				    nFrom      => current_coord,
				    nTo        => Get_Next_Coordinate (current_coord, oblivium));
			current_action.utility := 10; -- TODO:: cambiare utilita'
		     end if;
		  end if;
	       end if;

	    -- controllo se sono il giocatore che fa ripartire il gioco
	    elsif id = Get_Player_Id (last_game_event) then
	       -- controllo se ho la palla
	       if not current_generic_status.holder then
		  -- controllo se sono sopra la palla
		  if Compare_Coordinates (coord1 => current_generic_status.coord,
			    coord2 => Ball.Get_Position) then
		     -- prendo la palla
		     current_action.event := new Catch_Event;
		     current_action.event.Initialize(nPlayer_Id => id,
				      nFrom      => current_coord,
				      nTo        => Ball.Get_Position);

		     current_action.utility := 10; -- TODO:: cambiare utilita'
		  else
		     -- mi muovo verso la palla
		     current_action.event := new Move_Event;
		     current_action.event.Initialize (nPlayer_Id => id,
					nFrom      => current_coord,
					nTo        => Get_Next_Coordinate (current_coord,
					  Ball.Get_Position));
		     current_action.utility := 10; -- TODO:: cambiare utilita'
		  end if;
	       end if;
	    else
	       -- sono un altro giocatore, ma devo determinare di che squadra
	       if current_team = Get_Team (last_game_event) then
		  -- sono un compagno di squadra di chi deve sbloccare il gioco

		  -- mi sposto a caso, per il momento
		  current_action.event := new Move_Event;
		  current_action.event.Initialize (nPlayer_Id => id,
				     nFrom      => current_coord,
				     nTo        => Get_Random_Target (current_coord));
		  current_action.utility := 10; -- TODO:: cambiare utilita'
	       else
		  -- sono un avversario, devo eventualmente spostarmi dalla zona
    		  -- di ripresa del gioco
		  declare
		     opponents_team : Team_Id;
		  begin
--  		     for i in current_read_result.players_in_my_zone.First_Index .. current_read_result.players_in_my_zone.Last_Index loop
--  			if current_read_result.players_in_my_zone.Element (i).id = id then
--  			   opponents_team := current_read_result.players_in_my_zone.Element (i).team;
--  			   exit;
--  			end if;
--  		     end loop;

		     if Distance (current_coord, Get_Coordinate (last_game_event)) < free_kick_area then
			current_action.event := new Move_Event;
			current_action.event.Initialize (nPlayer_Id => id,
				    nFrom      => current_coord,
                                    nTo        => Back_Off (current_coord,
                                      			    Get_Coordinate_For_Player (player_team,
                                                                 		       current_generic_status.holder_team,
                                        					       player_number),
                                      			    Get_Coordinate (last_game_event)));
		     end if;
		  end;
	       end if;
--  	    else
	       -- aggiungere la gestione per eventi di gioco
--  	       null;
	    end if;

	 when Game_Paused =>

	    --+---------------
     	    --+ GAME PAUSED
	    --+---------------

	    Put_Line ("[PLAYER_" & I2S (id) & "] Stato di gioco: Game_Paused");

	    if current_match_event /= null then
	       if Get_Match_Event_Id (current_match_event) = Begin_Of_Match then
		  pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Gioco in pausa per inizio primo tempo"));
--  		  target_coord := TEMP_Get_Coordinate_For_Player (0); -- TODO:: decommenta per farli entrare in campo in ordine!
		  target_coord := Get_Starting_Position (player_number,player_team);

		  pragma Debug (Put_Line ("initial_x = " & I2S (current_coord.coord_x) & " - initial_y = " & I2S (current_coord.coord_y)));

		  current_action.event := new Move_Event;
		  current_action.event.Initialize(nPlayer_Id => id,
				    nFrom      => current_coord,
				    nTo        => target_coord);
		  current_action.utility := 10;
	       end if;
	    end if;

	 end case;

	 if current_action.event /= null then
--  	    Put_Line ("[PLAYER_" & I2S (id) & "] Chiamo la Start");
--  	    Game_Entity.Start;
	    pragma Debug (Put_Line ("[PLAYER_" & I2S (id) & "] Chiamo la Write"));
	    ControllerPkg.Controller.Write(current_action);

	    current_action.event := null;
	 end if;

	 delay duration (players_delay); -- TODO:: metterla proporzionale alle statistiche e all'iperperiodo
      end loop;

   end Player;

end Soccer.PlayersPkg;
