with Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
use Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
with Soccer.BallPkg; use Soccer.BallPkg;
with Soccer.Manager_Event.Formation; use Soccer.Manager_Event.Formation;
with Soccer.Manager_Event.Substitution; use Soccer.Manager_Event.Substitution;
with Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
use Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
with Soccer.Utils; use Soccer.Utils;

package body Soccer.ControllerPkg.Referee is

   procedure Notify_Game_Event (event : Game_Event_Ptr) is begin
      game_event := event;
   end Notify_Game_Event;

   procedure Check is
      last_team_possession : Team_Id := Get_Team_From_Id (id => last_ball_holder);
      new_game_status : Unary_Event_Prt;
   begin
      -- controllare se c'e' un evento "core" in pending
      -- controllare se il gioco e' fermo
      -- -- controllare se ci sono eventi "dist"
      -- -- -- consumare eventi "dist"
      -- controllare se la palla e' uscita, stabilire se e' un goal,
      -- - una rimessa, un rinvio, un calcio d'angolo, ..

      --

      -- controllo il game event (dovrebbe essere un fallo)
      if game_event /= null then
	 if game_event.all in Binary_Event'Class then
	    declare
	       evt : Binary_Event_Prt := Binary_Event_Prt(game_event);
	    begin
	       if evt.Get_Event_Id = Foul then
		  declare
		     evt_coord : Coordinate := evt.Get_Event_Coord;
		     assigned_team : Team_Id := Get_Team_From_Id (evt.Get_Id_Player_2);
		     foul_event : Unary_Event_Prt := new Unary_Event;
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
			      new_player_id   => -1,
			      new_team_id     => assigned_team,
			      new_event_coord => evt_coord);

		     -- setto il risultato (stato di gioco)
		     new_game_status := foul_event;
		  end;
	       end if;
	    end;
	 end if;
      end if;

      -- SE IL GIOCO E' FERMO, controllo eventi della distribuzione
      if not Is_Game_Running then
	 if manager_events'Size > 0 then
	    for i in manager_events.First_Index .. manager_events.Last_Index loop
	       -- controllo se l'evento e' un cambio di formazione o una sostituzione
	       if manager_events(i).all in Formation_Event'Class then
		  -- cambio di formazione
		  declare
		     base_event : Manager_Event.Event_Ptr := manager_events(i);
		     new_formation_event : Formation_Event_Ptr;
		     new_formation_scheme : Formation_Scheme;
		     team : Team_Ptr;
		  begin
		     new_formation_event := Formation_Event_Ptr (base_event);
		     new_formation_scheme := new_formation_event.Get_Scheme;
		     team := Get_Team (new_formation_event.Get_Team);
		     Set_Formation (team => team, formation => new_formation_scheme);
		  end;
	       elsif manager_events(i).all in Substitution_Event'Class then
		  -- sostituzione di giocatore
		  null; -- TODO:: cambiare giocatore
	       end if;
	    end loop;
	 end if;
      end if;

      -- controllo delle coordinate della palla
      declare
	 ball_coord : Coordinate := Ball.Get_Position;
	 field_x : Positive := field_max_x;
	 field_y : Positive := field_max_y;
      begin
	 -- controllo se la palla e' uscita dal campo
	 if ball_coord.coordX < 1 or ball_coord.coordX > field_x or ball_coord.coordY < 1 or ball_coord.coordY > field_y then
	    -- controllo se e' stato fatto un goal
	    declare
	       goal_event : Unary_Event_Prt := new Unary_Event;
	       scoring_team : Team_Id;
	    begin
	       if last_team_possession = Team_One then
		  if ball_coord.coordX < team_one_goal_starting_coord.coordX + goal_length and ball_coord.coordX > team_one_goal_starting_coord.coordX
		    and ball_coord.coordY = team_one_goal_starting_coord.coordY then
		     scoring_team := Team_One;
		  end if;
	       else
		  if ball_coord.coordX < team_two_goal_starting_coord.coordX + goal_length and ball_coord.coordX > team_two_goal_starting_coord.coordX
		    and ball_coord.coordY = team_two_goal_starting_coord.coordY then
		     scoring_team := Team_Two;
		  end if;
	       end if;

	       goal_event.Initialize (new_event_id    => Goal,
			       new_player_id   => -1,
			       new_team_id     => scoring_team,
			       new_event_coord => middle_field_coord);
	    end;

	    -- controllo se va assegnata una rimessa
	    if (ball_coord.coordX = 0 or ball_coord.coordX = field_max_x + 1) and ball_coord.coordY > 0 and ball_coord.coordY < field_max_y then
	       new_game_status.Initialize (new_event_id    => Throw_In,
				    new_player_id   => -1,
				    new_team_id     => last_team_possession,
				    new_event_coord => ball_coord);
	    end if;

	    -- controllo se va assegnato un calcio d'angolo o un rinvio dal
            -- fondo (non controllo la x perche' ho gia' controllato il gol)
	    if ball_coord.coordY = 0 or ball_coord.coordY = field_max_y then
	       if last_team_possession = Team_One then
		  if ball_coord.coordY = 0 then
		     -- assegna un calcio d'angolo a Team_Two
		     null;
		  elsif ball_coord.coordY = field_max_y then
		     -- assegna una rimessa dal fondo a Team_Two
		     null;
		  end if;
	       else
		  if ball_coord.coordY = 0 then
		     -- assegna una rimessa dal fondo a Team_One
		     null;
		  elsif ball_coord.coordY = field_max_y then
		     -- assegna un calcio d'angolo a Team_One
		     null;
		  end if;
	       end if;
	    end if;
	 end if;
      end;

      -- setto il nuovo stato di gioco
      Set_Game_Status (event => Game_Event_Ptr (new_game_status));

   end Check;

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
