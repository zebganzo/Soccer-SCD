
package body Soccer.ControllerPkg.Referee is

   procedure Notify_Game_Event (event : Game_Event_Ptr) is begin
      game_event := event;
   end Notify_Game_Event;

   --+-----------------------------------
   -- PRE CHECK
   --+-----------------------------------

   procedure Pre_Check (e : in Motion_Event_Ptr) is
      current_game_status : Unary_Event_Ptr := Unary_Event_Ptr (Get_Game_Status);
      game_status_id : Unary_Event_Id := Get_Type (current_game_status);
      assigned_team : Team_Id := Get_Team (current_game_status);
      assigned_player : Integer := Get_Player_Id (current_game_status);
      current_event_coord : Coordinate := Get_Coordinate (current_game_status);
   begin
      -- controlla lo stato di gioco
      -- -- se running, non fa nulla
      -- -- se c'e' un evento in pending, controlla se le condizioni per la ripresa del gioco sono soddisfatte

      if current_game_status = null then
	 -- game is in progress
	 return;
      end if;

      if game_status_id = Goal then

	 -- goal

	 declare
	    opposite_team : Team_Id;
	 begin
	    if assigned_team = Team_One then
	       opposite_team := Team_Two;
	    else
	       opposite_team := Team_One;
	    end if;

	    -- controllo se il gioco puo' riprendere
	    if is_game_ready
	      and e.all in Shot_Event'Class
	      and Get_Team_From_Id (e.Get_Player_Id) = opposite_team then
	       -- ha iniziato, quindi il gioco puo' riprendere
	       Set_Game_Status (null);
	    end if;

	 end;
      elsif game_status_id = Goal_Kick then

	 -- rimessa dal fondo

	 declare
	    current_player_status : Player_Status := current_status (assigned_player);
	    assigned_player_position : Coordinate := current_player_status.player_coord;
	    first_condition : Boolean := False;
	    second_condition : Boolean := False;
	 begin
	    -- controllo se il gioco puo' riprendere
	    if is_game_ready and e.all in Shot_Event'Class then
	       -- ha lanciato, quindi il gioco puo' riprendere
	       Set_Game_Status (null);
	    end if;

	    if not is_game_ready then
	       -- controllo che chi deve fare la rimessa dal fondo sia in
	       -- posizione, se non lo e' esco
	       if Compare_Coordinates (coord1 => current_status (assigned_player).player_coord,
				coord2 => current_event_coord) then
		  first_condition := True;
	       end if;

	       -- controllo che non ci siano giocatori attorno alla posizione
	       -- di chi deve fare la rimessa dal fondo
	       for i in current_status'Range loop
		  if i /= current_player_status.id
		    and current_player_status.team /= current_status(i).team
		    and Distance (From => assigned_player_position, To => current_status (i).player_coord) < free_kick_area then
		     second_condition := True;
		  end if;
		  exit when not second_condition;
	       end loop;
	    end if;

	    if first_condition and second_condition then
	       is_game_ready := True;
	    end if;
	 end;

      elsif game_status_id = Free_Kick then

	 -- calcio di punizione

	 declare
	    current_player_status : Player_Status := current_status (assigned_player);
	    assigned_player_position : Coordinate := current_player_status.player_coord;
	    first_condition : Boolean := False;
	    second_condition : Boolean := False;
	 begin
	    -- controllo se il gioco puo' riprendere
	    if is_game_ready and e.all in Shot_Event'Class then
	       -- ha tirato, quindi il gioco puo' riprendere
	       Set_Game_Status (null);
	    end if;

	    if not is_game_ready then
	       -- controllo che chi deve battere sia in posizione, se non lo e' esco
	       if Compare_Coordinates (coord1 => current_status (assigned_player).player_coord,
				coord2 => current_event_coord) then
		  first_condition := True;
	       end if;

	       -- controllo che non ci siano giocatori attorno alla posizione
	       -- di chi deve battere (della squadra avversaria)
	       for i in current_status'Range loop
		  if i /= current_player_status.id
		    and current_player_status.team /= current_status(i).team
		    and Distance (From => assigned_player_position,
		    To => current_status (i).player_coord) < free_kick_area then
		     second_condition := True;
		  end if;
		  exit when not second_condition;
	       end loop;
	    end if;
	 end;
      elsif game_status_id = Penalty_Kick then

	 -- calcio di rigore

	 declare
	    current_player_status : Player_Status := current_status (assigned_player);
	    assigned_player_position : Coordinate := current_player_status.player_coord;
	    opponent_team : Team_Id;
	    first_condition : Boolean := False;
	    second_condition : Boolean := False;
	 begin
	    -- controllo se il gioco puo' riprendere
	    if is_game_ready and e.all in Shot_Event'Class then
	       -- ha battuto, quindi il gioco puo' riprendere
	       Set_Game_Status (null);
	    end if;

	    if not is_game_ready then
	       -- controllo che chi deve battere il calcio di rigore sia in
	       -- posizione, se non lo e' esco
	       if Compare_Coordinates (coord1 => current_status (assigned_player).player_coord,
				coord2 => current_event_coord) then
		  first_condition := True;
	       end if;

	       if current_player_status.team = Team_One then
		  opponent_team := Team_Two;
	       else
		  opponent_team := Team_One;
	       end if;

	       -- controllo che non ci siano giocatori attorno alla posizione
	       -- di chi deve battere il calcio di rigore
	       for i in current_status'Range loop
		  if i /= current_player_status.id
		    and i /= Get_Goalkeeper_Id (team => opponent_team)
		    and Distance (From => assigned_player_position, To => current_status (i).player_coord) < free_kick_area then
		     second_condition := True;
		  end if;
		  exit when not second_condition;
	       end loop;
	    end if;

	    if first_condition and second_condition then
	       is_game_ready := True;
	    end if;
	 end;
      elsif game_status_id = Throw_In then

	 -- rimessa

	 declare
	    current_player_status : Player_Status := current_status (assigned_player);
	    assigned_player_position : Coordinate := current_player_status.player_coord;
	    first_condition : Boolean := False;
	    second_condition : Boolean := False;
	 begin
	    -- controllo se il gioco puo' riprendere
	    if is_game_ready and e.all in Shot_Event'Class then
	       -- ha lanciato, quindi il gioco puo' riprendere
	       Set_Game_Status (null);
	    end if;

	    if not is_game_ready then
	       -- controllo che chi deve fare la rimessa sia in posizione,
	       -- se non lo e' esco
	       if Compare_Coordinates (coord1 => current_status (assigned_player).player_coord,
				coord2 => current_event_coord) then
		  first_condition := True;
	       end if;

	       -- controllo che non ci siano giocatori attorno alla posizione
	       -- di chi deve fare la rimessa
	       for i in current_status'Range loop
		  if i /= current_player_status.id
		    and current_player_status.team /= current_status(i).team
		    and Distance (From => assigned_player_position, To => current_status (i).player_coord) < free_kick_area then
		     second_condition := True;
		  end if;
		  exit when not second_condition;
	       end loop;
	    end if;

	    if first_condition and second_condition then
	       is_game_ready := True;
	    end if;
	 end;
      elsif game_status_id = Corner_Kick then

	 -- calcio d'angolo

	 declare
	    current_player_status : Player_Status := current_status (assigned_player);
	    assigned_player_position : Coordinate := current_player_status.player_coord;
	    first_condition : Boolean := False;
	    second_condition : Boolean := False;
	 begin
	    -- controllo se il gioco puo' riprendere
	    if is_game_ready and e.all in Shot_Event'Class then
	       -- ha battuto, quindi il gioco puo' riprendere
	       Set_Game_Status (null);
	    end if;

	    if not is_game_ready then
	       -- controllo che chi deve battere il calcio d'angolo sia in
	       -- posizione, se non lo e' esco
	       if Compare_Coordinates (coord1 => current_status (assigned_player).player_coord,
				coord2 => current_event_coord) then
		  first_condition := True;
	       end if;

	       -- controllo che non ci siano giocatori attorno alla posizione
	       -- di chi deve battere il calcio d'angolo
	       for i in current_status'Range loop
		  if i /= current_player_status.id and Distance (From => assigned_player_position,
						   To => current_status (i).player_coord) < free_kick_area then
		     second_condition := True;
		  end if;
		  exit when not second_condition;
	       end loop;
	    end if;

	    if first_condition and second_condition then
	       is_game_ready := True;
	    end if;
	 end;
      end if;
   end Pre_Check;


   --+-----------------------------------
   -- POST CHECK
   --+-----------------------------------
   procedure Post_Check is
      last_team_possession : Team_Id := Get_Team_From_Id (id => last_ball_holder);
      new_game_status : Unary_Event_Ptr;
   begin
      Put_Line("[POST_CHECK] Controllo se c'e' stato un fallo");
      -- controllare se c'e' un evento "core" in pending
      -- controllare se il gioco e' fermo
      -- -- controllare se ci sono eventi "dist"
      -- -- -- consumare eventi "dist"
      -- controllare se la palla e' uscita, stabilire se e' un goal,
      -- - una rimessa, un rinvio, un calcio d'angolo, ..

      --

      -- controllo il game event (dovrebbe essere un fallo)
      Put_Line("[POST_CHECK] Controllo se c'e' stato un fallo");
      if game_event /= null then
	 Ada.Text_IO.Put_Line("[POST_CHECK] fallo!");
	 if game_event.all in Binary_Event'Class then
	    declare
	       evt : Binary_Event_Ptr := Binary_Event_Ptr (game_event);
	    begin
	       if evt.Get_Event_Id = Foul then
		  declare
		     evt_coord : Coordinate := evt.Get_Coordinate;
		     assigned_team : Team_Id := Get_Team_From_Id (evt.Get_Id_Player_2);
		     foul_event : Unary_Event_Ptr := new Unary_Event;
		     is_penalty : Boolean := Is_In_Penalty_Area (team  => assigned_team,
						   coord => evt_coord);
		  begin
		     -- controllo se il fallo e' stato fatto nell'area di rigore
		     if is_penalty then
			if assigned_team = Team_One then
			   evt_coord := team_one_penalty_coord;
			else
			   evt_coord := team_two_penalty_coord;
			end if;
		     end if;

		     -- inizializzo l'evento di fallo
		     foul_event.Initialize (new_event_id    => Foul,
			      new_player_id   => Get_Nearest_Player (evt_coord, assigned_team),
			      new_team_id     => assigned_team,
			      new_event_coord => evt_coord);

		     -- setto il risultato (stato di gioco)
		     new_game_status := foul_event;
		     -- notifico il nuovo stato di gioco (e lo fermo)
		     Set_Game_Status (Game_Event_Ptr (new_game_status));
		     -- setto la nuova posizione della palla
		     Ball.Set_Position (new_position => Get_Coordinate (new_game_status));
		  end;
	       end if;
	    end;
	 end if;
      end if;

      -- SE IL GIOCO E' FERMO, controllo eventi della distribuzione
      Put_Line("[POST_CHECK] Controllo se ci sono eventi dalla distribuzione");
      if not Is_Game_Running then
	 if manager_events'Size > 0 then
	    Put_Line("[POST_CHECK] Ci sono eventi dalla distribuzione!");
	    for i in manager_events.First_Index .. manager_events.Last_Index loop
	       -- controllo se l'evento e' un cambio di formazione o una sostituzione
	       if manager_events(i).all in Formation_Event'Class then
		  -- cambio di formazione
		  declare
		     base_event : Manager_Event.Event_Ptr := manager_events(i);
		     new_formation_event : Formation_Event_Ptr;
		     new_formation_scheme : Formation_Scheme_Id;
		     team : Team_Ptr;
		  begin
		     new_formation_event := Formation_Event_Ptr (base_event);
		     new_formation_scheme := new_formation_event.Get_Scheme;
		     team := Get_Team (new_formation_event.Get_Team);
		     Set_Formation (team => team, formation => new_formation_scheme);
		  end;
	       elsif manager_events(i).all in Substitution_Event'Class then
		  -- sostituzione di giocatore
		  declare
		     base_event : Manager_Event.Event_Ptr := manager_events(i);
		     new_substitution_event : Substitution_Event_Ptr;
		  begin
		     new_substitution_event := Substitution_Event_Ptr (base_event);
		     pending_substitutions.Append (new_substitution_event);
		  end;
	       end if;
	    end loop;
	 end if;
      end if;

      Put_Line("[POST_CHECK] Controllo se la palla e' uscita e ne determino la causa");
      if Is_Game_Running then
	 -- controllo delle coordinate della palla
	 declare
	    ball_coord : Coordinate := Ball.Get_Position;
	    field_x : Positive := field_max_x;
	    field_y : Positive := field_max_y;
	 begin

	    -- controllo se la palla e' uscita dal campo

	    if ball_coord.coord_x < 1 or ball_coord.coord_x > field_x or ball_coord.coord_y < 1 or ball_coord.coord_y > field_y then

	       Put_Line("[POST_CHECK] La palla e' uscita dal campo");

	       -- controllo se e' stato fatto un goal

	       declare
		  goal_event : Unary_Event_Ptr := new Unary_Event;
		  scoring_team : Team_Id;
	       begin
		  if last_team_possession = Team_One then
		     if ball_coord.coord_x < team_one_goal_starting_coord.coord_x + goal_length and ball_coord.coord_x > team_one_goal_starting_coord.coord_x
		       and ball_coord.coord_y = team_one_goal_starting_coord.coord_y then
			scoring_team := Team_One;
			Put_Line("[POST_CHECK] Team_One ha segnato!");
		     end if;
		  else
		     if ball_coord.coord_x < team_two_goal_starting_coord.coord_x + goal_length and ball_coord.coord_x > team_two_goal_starting_coord.coord_x
		       and ball_coord.coord_y = team_two_goal_starting_coord.coord_y then
			scoring_team := Team_Two;
			Put_Line("[POST_CHECK] Team_Two ha segnato!");
		     end if;
		  end if;

		  goal_event.Initialize (new_event_id    => Goal,
			   new_player_id   => last_event.Get_Player_Id,
			   new_team_id     => scoring_team,
			   new_event_coord => middle_field_coord);
	       end;

	       -- controllo se va assegnata una rimessa laterale
	       if (ball_coord.coord_y = 0 or ball_coord.coord_y = field_max_y + 1) and ball_coord.coord_x > 0 and ball_coord.coord_x < field_max_x then
		  Put_Line("[POST_CHECK] rimessa laterale");
		  new_game_status := new Unary_Event;
		  new_game_status.Initialize (new_event_id    => Throw_In,
				new_player_id   => Get_Nearest_Player (ball_coord, last_team_possession),
				new_team_id     => last_team_possession,
				new_event_coord => ball_coord);
	       end if;

	       -- controllo se va assegnato un calcio d'angolo o un rinvio dal
	       -- fondo (non controllo la x perche' ho gia' controllato il gol)
	       Put_Line("[POST_CHECK] Controllo se va assegnato un calcio d'angolo o un rinvio dal fondo");
	       if ball_coord.coord_y = 0 or ball_coord.coord_y = field_max_y then
		  declare
		     new_event : Unary_Event_Ptr := new Unary_Event;
		     new_evt_coord : Coordinate := Coordinate'(0,0);
		  begin
		     if ball_coord.coord_y < field_max_y / 2 then
			Set_Coord_Y (coord => new_evt_coord, value => 0);
		     else
			Set_Coord_Y (coord => new_evt_coord, value => field_max_y + 1);
		     end if;

		     if last_team_possession = Team_One then
			if ball_coord.coord_x = 0 then
			   -- assegna un calcio d'angolo a Team_Two
			   Put_Line("[POST_CHECK] calcio d'angolo per Team_Two");
			   Set_Coord_X (coord => new_evt_coord, value => 0);
			   new_event.Initialize (new_event_id    => Corner_Kick,
			    new_player_id   => Get_Nearest_Player (new_evt_coord, last_team_possession),
			    new_team_id     => last_team_possession,
			    new_event_coord => new_evt_coord);
			elsif ball_coord.coord_x = field_max_x + 1 then
			   -- assegna una rimessa dal fondo a Team_Two
			   Put_Line("[POST_CHECK] rimessa dal fondo per Team_Two");
			   Set_Coord_X (coord => new_evt_coord, value => field_max_x + 1);
			   new_event.Initialize (new_event_id    => Goal_Kick,
			    new_player_id   => 1, -- portiere
			    new_team_id     => last_team_possession,
			    new_event_coord => new_evt_coord);
			end if;
		     else
			if ball_coord.coord_x = 0 then
			   -- assegna una rimessa dal fondo a Team_One
			   Put_Line("[POST_CHECK] rimessa dal fondo per Team_One");
			   Set_Coord_X (coord => new_evt_coord, value => 0);
			   new_event.Initialize (new_event_id    => Goal_Kick,
			    new_player_id   => 1, -- portiere
			    new_team_id     => last_team_possession,
			    new_event_coord => new_evt_coord);
			elsif ball_coord.coord_x = field_max_x + 1 then
			   -- assegna un calcio d'angolo a Team_One
			   Put_Line("[POST_CHECK] calcio d'angolo per Team_One");
			   Set_Coord_X (coord => new_evt_coord, value => field_max_x + 1);
			   new_event.Initialize (new_event_id    => Corner_Kick,
			    new_player_id   => Get_Nearest_Player (new_evt_coord, last_team_possession),
			    new_team_id     => last_team_possession,
			    new_event_coord => new_evt_coord);
			end if;
		     end if;

		     -- imposto l'evento appena calcolato
		     new_game_status := new_event;
		  end;
	       end if;
	    end if;
	 end;
      end if;

      -- setto il nuovo stato di gioco, se c'e'
      Put_Line("[POST_CHECK] Se c'e' un nuovo stato di gioco, lo setto");
      if new_game_status /= null then
	 Put_Line("[POST_CHECK] nuovo stato di gioco");
	 Set_Game_Status (event => Game_Event_Ptr (new_game_status));

	 -- setto la nuova posizione della palla
	 Ball.Set_Position (new_position => Get_Coordinate (new_game_status));
      end if;

      Put_Line("[POST_CHECK] Fine controlli");

   end Post_Check;

   function Get_Nearest_Player (event_coord : in Coordinate; team : in Team_Id) return Integer is
      smallest_distance : Integer := Integer'Last;
      player : Integer;
   begin
      for i in current_status'Range loop
	 declare
	    current_distance : Integer := Distance (From => event_coord,
					     To => current_status (i).player_coord);
	 begin
	    if current_status(i).team = team and current_distance < smallest_distance then
	       smallest_distance := current_distance;
	       player := i;
	    end if;
	 end;
      end loop;

      return player;
   end Get_Nearest_Player;

   procedure Notify_Manager_Event (event : Manager_Event.Event_Ptr) is begin
      manager_events.Append(New_Item => event);
   end Notify_Manager_Event;

   procedure Get_Manager_Events is begin
      -- get events from webserver
      null;
   end Get_Manager_Events;

   procedure Set_Last_Ball_Holder (holder : Integer) is begin
      last_ball_holder := holder;
   end Set_Last_Ball_Holder;

end Soccer.ControllerPkg.Referee;
