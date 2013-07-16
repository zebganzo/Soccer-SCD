with Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
use Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
with Soccer.BallPkg; use Soccer.BallPkg;
with Soccer.Manager_Event.Formation; use Soccer.Manager_Event.Formation;
with Soccer.Manager_Event.Substitution; use Soccer.Manager_Event.Substitution;
with Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
use Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;

package body Soccer.ControllerPkg.Referee is

   procedure Notify_Game_Event (event : Game_Event_Prt) is begin
      game_event := event;
   end Notify_Game_Event;

   procedure Check is begin
      -- controllare se c'e' un evento "core" in pending
      -- controllare se il gioco e' fermo
      -- -- se il gioco e' fermo, controllare se ci sono eventi "dist"
      -- -- -- se ci sono eventi "dist", consumarli
      -- controllare se la palla e' uscita, stabilire se e' un goal,
      -- - una rimessa, un rinvio, un calcio d'angolo, ..

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
		  begin
		     -- controllo se il fallo e' stato fatto nell'area di rigore

		     foul_event.Initialize (new_event_id    => Foul,
			      new_player_id   => null,
			      new_team_id     => assigned_team,
			      new_event_coord => evt.Get_Event_Coord);
		     null;
		  end;
	       end if;
	    end;
	 end if;
      end if;

      -- controllo eventi della distribuzione, se il gioco e' fermo
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

      -- controllo delle coordinate della palla
      declare
	 ball_coord : Coordinate := Ball.Get_Position;
	 field_x : Positive := field_max_x;
	 field_y : Positive := field_max_y;
	 last_team_possession : Team_Id;
      begin

	 -- controllo se la palla e' uscita dal campo
	 if ball_coord.coordX < 1 or ball_coord.coordX > field_x or ball_coord.coordY < 1 or ball_coord.coordY > field_y then
	    last_team_possession := Get_Team_From_Id (id => last_ball_holder);

	    -- controllo se e' stato fatto un goal
	    if last_team_possession = Team_One then
	       if ball_coord.coordX < team_one_goal_starting_coord.coordX + goal_length and ball_coord.coordX > team_one_goal_starting_coord.coordX
		 and ball_coord.coordY = team_one_goal_starting_coord.coordY then
		  -- team 1 ha segnato!
		  null;
	       end if;
	    else
	       if ball_coord.coordX < team_two_goal_starting_coord.coordX + goal_length and ball_coord.coordX > team_two_goal_starting_coord.coordX
		 and ball_coord.coordY = team_two_goal_starting_coord.coordY then
		  -- team 2 ha segnato!
		  null;
	       end if;
	    end if;

	    -- controllo se va assegnata una rimessa
	    if (ball_coord.coordX = 0 or ball_coord.coordX = field_max_x + 1) and ball_coord.coordY > 0 and ball_coord.coordY < field_max_y then
	       -- assegna una rimessa a last_team_possession
	       null;
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

      -- TODO:: settare sul controller l'evento

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
