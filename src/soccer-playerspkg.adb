

package body Soccer.PlayersPkg is

   use Players_Container;

   type Rand_Range is range 1 .. 8;
   package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);

   --
   --     Rand_Int.Reset(seedX); Integer(Rand_Int.Random(seedX)
   --     Rand_Int.Reset(seedY); Integer(Rand_Int.Random(seedY))

   pass_range : Integer := 3;
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
   begin

--        Rand_Int.Reset(seed_x);
--        Rand_Int.Reset(seed_y);
--
--  --        target_coord := Coordinate'(coord_x => initial_coord_x,
--  --  				  coord_y => initial_coord_y);
--
--        -- all'inizio, cerco di occupare la cella 0,0 per l'ingresso in campo
--        target_coord := TEMP_Get_Coordinate_For_Player (0);
--
--        current_action.event := new Move_Event;
--        current_generic_status := ControllerPkg.Get_Generic_Status(id => id);
--        current_coord := current_generic_status.coord;
--
--        current_action.event.Initialize(nPlayer_Id => id,
--  				      nFrom      => current_coord,
--  				      nTo        => target_coord);
--        current_action.utility := 10;
--
--        Put_Line ("[PLAYER_" & I2S (id) & "] Chiamo la Start");
--        Game_Entity.Start;
--        Put_Line ("[PLAYER_" & I2S (id) & "] Chiamo la Write");
--        ControllerPkg.Controller.Write(current_action => current_action);
--
--        delay duration(5);

      loop
	 Put_Line ("[PLAYER_" & I2S (id) & "] Leggo Generic Status");
	 current_generic_status := ControllerPkg.Get_Generic_Status(id => id);
	 current_coord := current_generic_status.coord;

	 current_game_status := current_generic_status.game_status;

	 Put_Line ("[PLAYER_" & I2S (id) & "] Controllo che tipo di evento c'e'");
	 if current_generic_status.last_game_event /= null then
	    if current_generic_status.last_game_event.all in Match_Event'Class then
	       Put_Line ("[PLAYER_" & I2S (id) & "] C'e' un Match_Event");
	       current_match_event := Match_Event_Ptr (current_generic_status.last_game_event);
	       last_game_event := null;
	    else
	       Put_Line ("[PLAYER_" & I2S (id) & "] C'e' un Game_Event");
	       last_game_event := Unary_Event_Ptr (current_generic_status.last_game_event);
	       current_match_event := null;
	    end if;
	 end if;

	 current_team := current_generic_status.team;

	 if current_generic_status.holder then
	    current_range := ability;
	 elsif current_generic_status.nearby then
	    current_range := nearby_distance;
	 else
	    current_range := 1;
	 end if;

	 -- sulla base delle mie statistiche, chiedo la mia "bolla" di stato
	 Put_Line ("[PLAYER_" & I2S (id) & "] Leggo lo stato con la mia bolla");
	 current_read_result := ControllerPkg.Read_Status(x => current_coord.coord_x,
						   y => current_coord.coord_y,
						   r => current_range);

	 -- calcolo la distanza che mi separa dai giocatori che ho intorno
  	 Put_Line ("[PLAYER_" & I2S (id) & "] Pre-calcolo le distanze con gli altri giocatori che ho vicino a me");
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
	 Put_Line ("[PLAYER_" & I2S (id) & "] Controllo lo stato di gioco per decidere l'azione");
	 case current_game_status is
	 when Game_Running =>

	    Put_Line ("[PLAYER_" & I2S (id) & "] Stato di gioco: Game_Running");

	    --+---------------
     	    --+ GAME RUNNING
	    --+---------------

	    Put_Line("[PLAYER_" & I2S (id) & "] Ho la palla vicina? " & Boolean'Image(current_generic_status.nearby));

	    if current_generic_status.holder then
	       -- Che bello ho la palla, se sono in pericolo la passo se no fanculo tutti!
	       declare
		  foundPlayer : Boolean := False;
	       begin
		  for i in current_read_result.players_in_my_zone.First_Index .. current_read_result.players_in_my_zone.Last_Index loop
		     if current_read_result.players_in_my_zone.Element(Index => i).team /= team and
		       current_read_result.players_in_my_zone.Element(Index => i).distance <= pass_range then
			foundPlayer := True;
		     end if;
		  end loop;

		  if foundPlayer then
		     declare
			playerTarget : Integer := -1;
		     begin
			for i in current_read_result.players_in_my_zone.First_Index .. current_read_result.players_in_my_zone.Last_Index loop
			   if current_read_result.players_in_my_zone.Element(Index => i).team = team and
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
			   Put_Line("[PLAYER_" & I2S (id) & "] Mi stanno per rubare palla, la passo al mio amico " & I2S(current_read_result.players_in_my_zone.Element(Index => playerTarget).id));
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
			      if current_read_result.players_in_my_zone.Element(Index => i).team /= team then
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

	    Put_Line ("[PLAYER_" & I2S (id) & "] Stato di gioco: Game_Ready");

	    -- controllo se sono ad un evento notevole della partita
	    Put_Line ("[PLAYER_" & I2S (id) & "] Controllo se il Match_Event e' settato");
	    if current_match_event /= null then
	       Put_Line ("[PLAYER_" & I2S (id) & "] Controllo se sono all'inizio del gioco");
	       if Get_Match_Event_Id (current_match_event) = Begin_Of_Match
		 or Get_Match_Event_Id (current_match_event) = Beginning_Of_Second_Half then
		  Put_Line ("[PLAYER_" & I2S (id) & "] Controllo se sono il giocatore che deve far ripartire il gioco");
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
			      if current_player_status.team = team then
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
			Put_Line ("[PLAYER_" & I2S (id) & "] Calcio d'inizio verso la cella " & Print_Coord (shot_target));
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
			if current_player_status.team = team then
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
	       if team = Get_Team (last_game_event) then
		  -- sono un compagno di squadra di chi deve battere, quindi al
		  -- massimo vado nella mia posizione di riferimeto, oppure sto fermo
		  if current_coord /= Get_Coordinate_For_Player (team, id) then
		     current_action.event := new Move_Event;
		     current_action.event.Initialize (id,
					current_coord,
					Get_Next_Coordinate (current_coord, Get_Coordinate_For_Player (team, id)));
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

	    Put_Line ("[PLAYER_" & I2S (id) & "] Stato di gioco: Game_Blocked");

	    -- controllo se sono ad un evento notevole della partita
	    Put_Line ("[PLAYER_" & I2S (id) & "] Controllo se il Match_Event e' settato");
	    if current_match_event /= null then
	       Put_Line ("[PLAYER_" & I2S (id) & "] Controllo se sono all'inizio del gioco");
	       if Get_Match_Event_Id (current_match_event) = Begin_Of_Match then
		  Put_Line ("[PLAYER_" & I2S (id) & "] Controllo se sono il giocatore che deve far ripartire il gioco");
		  -- controllo se sono il giocatore che deve far ripartire il gioco
		  if Get_Kick_Off_Player (current_match_event) = id then
		     Put_Line ("[PLAYER_" & I2S (id) & "] Sono quello che deve far riprendere il gioco");
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
			   Put_Line ("[PLAYER_" & I2S (id) & "] Mi sposto alla coordinata "
		& Print_Coord (Get_Next_Coordinate (current_coord, Ball.Get_Position)));
			end if;
		     end if;
		  else
		     Put_Line ("[PLAYER_" & I2S (id) & "] Non devo far riprendere il gioco");
		     -- controllo se sono nella mia posizione di riferimento
		     if not Compare_Coordinates (current_coord, TEMP_Get_Coordinate_For_Player (id)) then
			Put_Line ("[PLAYER_" & I2S (id) & "] Mi sposto nella cella "
	     & Print_Coord (Get_Next_Coordinate (current_coord, TEMP_Get_Coordinate_For_Player (id)))
	     & " verso la mia posizione di riferimento " & Print_Coord (TEMP_Get_Coordinate_For_Player (id)));
			-- mi sposto sulla mia posizione di riferimento
			current_action.event := new Move_Event;
			current_action.event.Initialize (id,
				    current_coord,
				    Get_Next_Coordinate (current_coord, TEMP_Get_Coordinate_For_Player (id)));
			current_action.utility := 3; -- TODO:: cambiare utilita'
		     else
			Put_Line ("[PLAYER_" & I2S (id) & "] Sono nella mia posizione di riferimento");
			current_action.event := null;
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
		     for i in current_read_result.players_in_my_zone.First_Index .. current_read_result.players_in_my_zone.Last_Index loop
			if current_read_result.players_in_my_zone.Element (i).id = id then
			   opponents_team := current_read_result.players_in_my_zone.Element (i).team;
			   exit;
			end if;
		     end loop;

		     if Distance (current_coord, Get_Coordinate (last_game_event)) < free_kick_area then
			current_action.event := new Move_Event;
			current_action.event.Initialize (nPlayer_Id => id,
				    nFrom      => current_coord,
				    nTo        => Back_Off (current_coord, Get_Coordinate_For_Player (opponents_team, id), Get_Coordinate (last_game_event)));
		     end if;
		  end;
	       end if;
	    end if;

	 when Game_Paused =>

	    --+---------------
     	    --+ GAME PAUSED
	    --+---------------

	    Put_Line ("[PLAYER_" & I2S (id) & "] Stato di gioco: Game_Paused");

	    if current_match_event /= null then
	       if Get_Match_Event_Id (current_match_event) = Begin_Of_Match then
		  Put_Line ("[PLAYER_" & I2S (id) & "] Gioco in pausa per inizio primo tempo");
		  target_coord := TEMP_Get_Coordinate_For_Player (0);

		  Put_Line ("initial_x = " & I2S (current_coord.coord_x) & " - initial_y = " & I2S (current_coord.coord_y));

		  current_action.event := new Move_Event;
		  current_action.event.Initialize(nPlayer_Id => id,
				    nFrom      => current_coord,
				    nTo        => target_coord);
		  current_action.utility := 10;
		  Put_Line ("[PLAYER_" & I2S (id) & "] Fine creazione Move_Event");
	       end if;
	    end if;

	    Put_Line ("[PLAYER_" & I2S (id) & "] Fine ramo Game_Paused");

	 end case;

	 if current_action.event /= null then
	    Put_Line ("[PLAYER_" & I2S (id) & "] Chiamo la Start");
	    Game_Entity.Start;
	    Put_Line ("[PLAYER_" & I2S (id) & "] Chiamo la Write");
	    ControllerPkg.Controller.Write(current_action);

	    current_action.event := null;
	 end if;

	 delay duration (1); -- TODO:: metterla proporzionale alle statistiche e all'iperperiodo
      end loop;

   end Player;



end Soccer.PlayersPkg;
