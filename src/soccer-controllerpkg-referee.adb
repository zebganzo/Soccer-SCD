with Soccer.Core_Event.Game_Core_Event.Match_Game_Event;
use Soccer.Core_Event.Game_Core_Event.Match_Game_Event;
with Soccer.Motion_AgentPkg; use Soccer.Motion_AgentPkg;
with Soccer.Bridge.Output; use Soccer.Bridge.Output;
with Soccer.Server.WebServer;

package body Soccer.ControllerPkg.Referee is

   procedure Print (input : String) is
   begin
      if debug then
	 pragma Debug (Put_Line (input));
	 null;
      end if;
   end Print;

   function TEMP_Get_Substitutions return Substitutions_Container.Vector is
   begin
      return pending_substitutions;
   end TEMP_Get_Substitutions;

   procedure Notify_Game_Event (event : Game_Event_Ptr) is begin
      game_event := event;
   end Notify_Game_Event;

   procedure Simulate_Begin_Of_1T is
      new_event : Match_Event_Ptr;
   begin
      new_event := new Match_Event;
      new_event.Initialize (Begin_Of_Match,
			    Get_Nearest_Player(Ball.Get_Position, Team_One));
      Set_Game_Status (Game_Blocked);
      Set_Last_Game_Event (Game_Event_Ptr (new_event));
      Soccer.Bridge.Output.Start_Timer;
      Buffer_Wrapper.Put (Core_Event.Event_Ptr (new_event));
   end Simulate_Begin_Of_1T;

   procedure Simulate_End_Of_1T is
      new_event : Match_Event_Ptr;
   begin
      new_event := new Match_Event;
      new_event.Initialize (End_Of_First_Half, 0);
      Set_Game_Status (Game_Blocked);
      Set_Last_Game_Event (Game_Event_Ptr (new_event));
      Soccer.Bridge.Output.Reset_Timer;
      Buffer_Wrapper.Put (Core_Event.Event_Ptr (new_event));
   end Simulate_End_Of_1T;

   procedure Simulate_Begin_Of_2T is
      new_event : Match_Event_Ptr;
   begin
      new_event := new Match_Event;
      new_event.Initialize (Begin_Of_Second_Half,
			    Get_Nearest_Player (Ball.Get_Position, Team_One));
      Set_Game_Status (Game_Blocked);
      Set_Last_Game_Event (Game_Event_Ptr (new_event));
      Ball.Set_Position (middle_field_coord);
      Soccer.Bridge.Output.Start_Timer;
      Buffer_Wrapper.Put (Core_Event.Event_Ptr (new_event));
   end Simulate_Begin_Of_2T;

   procedure Simulate_End_Of_Match is
      new_event : Match_Event_Ptr;
   begin
      new_event := new Match_Event;
      new_event.Initialize (End_Of_Match, 0);
      Set_Game_Status (Game_Blocked);
      Set_Last_Game_Event (Game_Event_Ptr (new_event));
      Soccer.Bridge.Output.Reset_Timer;
      Buffer_Wrapper.Put (Core_Event.Event_Ptr (new_event));
   end Simulate_End_Of_Match;

   procedure Simulate_Substitution is
      new_event : Substitution_Event_Ptr;
--        id1 : Integer;
--        id2 : Integer;
   begin
      new_event := new Substitution_Event;
      Initialize (new_event, Team_One, 12, 60);
--        Get_Numbers (new_event, id1, id2);
--        Print("[MAGIMAGIADIOBOIA]:" & I2S(id1) & " " & I2S(id2));
      manager_events.Append (Manager_Event.Event_Ptr (new_event));
   end Simulate_Substitution;

   procedure End_Of_First_Half is
      new_event : Match_Event_Ptr;
   begin
      new_event := new Match_Event;
      new_event.Initialize (End_Of_First_Half, 0);
      Set_Game_Status (Game_Blocked);
      Set_Last_Game_Event (Game_Event_Ptr (new_event));
   end End_Of_First_Half;

   procedure End_Of_Second_Half is
      new_event : Match_Event_Ptr;
   begin
      new_event := new Match_Event;
      new_event.Initialize (End_Of_Match, 0);
      Set_Game_Status (Game_Blocked);
      Set_Last_Game_Event (Game_Event_Ptr (new_event));
   end End_Of_Second_Half;

   --+-----------------------------------
   -- PRE CHECK
   --+-----------------------------------

   procedure Pre_Check (e : in Motion_Event_Ptr) is
      current_game_status : Unary_Event_Ptr;
      current_match_status : Match_Event_Ptr;
      game_status_id : Unary_Event_Id;
      assigned_team : Team_Id;
      assigned_player : Integer;
      current_event_coord : Coordinate;
   begin

      if Get_Last_Game_Event /= null then
	 if Get_Last_Game_Event.all in Match_Event'Class then
	    current_match_status := Match_Event_Ptr (Get_Last_Game_Event);
	    current_game_status := null;
	 else
	    current_match_status := null;
	    current_game_status := Unary_Event_Ptr (Get_Last_Game_Event);
	 end if;
      end if;

      -- controllo se ci sono sostituzioni in atto
      if Get_Game_Status = Game_Blocked then
	 declare
	    current_substitution : Substitution_Event_Ptr;
	    length : Integer;
	    id_1 : Integer;
	    id_2 : Integer;
	 begin

	    length := Integer (pending_substitutions.Length);

	    -- controllo se i giocatori che devono entrare.. sono entrati
	    if length > 0 then
	       for i in pending_substitutions.Last_Index .. pending_substitutions.First_Index loop
		  current_substitution := pending_substitutions.Element (i);
		  Get_Numbers (current_substitution, id_1, id_2);

		  if Get_Player_Position (id_2).coord_y >= 1 then
		     current_status (id_1).on_the_field := False;
		     current_status (id_2).on_the_field := True;
		     pending_substitutions.Delete (i, 1);

		  end if;
	       end loop;
	    end if;

	    -- controllo se posso procedere con gli altri controlli (solo se
	    -- non ci sono piu' sosituzioni in pending)
	    length := Integer (pending_substitutions.Length);
	    if length > 0 then
	       -- non posso fare gli altri controlli
--  	       Print ("[PRE_CHECK] Still substituting");
	       return;
	    else
	       null;
--  	       Print ("[PRE_CHECK] Substitution ended");
	    end if;

	 end;
      end if;

      -- controllo lo stato della partita
      if current_match_status /= null then
         if Get_Match_Event_Id (current_match_status) = Begin_Of_Match then

            -- controllo se il gioco puo' partire
            Print ("[PRE_CHECK] Controllo se il gioco puo' ripartire");
            if Get_Game_Status = Game_Ready then
               if e /= null then
                  if e.all in Shot_Event'Class then
                     -- ha battuto, il gioco puo' partire
                     Set_Last_Game_Event (null);
                     Set_Game_Status (Game_Running);
                     Print ("[PRE_CHECK] Inizio primo tempo!");
		     -- faccio partire i timer del primo tempo
		     -- (tempo partita e buffer eventi)
		     Game_Timer_First_Half.Start;
		     -- mando l'evento alla distribuzione
		     Buffer_Wrapper.Put (Core_Event.Event_Ptr(e));
                     return; -- TODO:: controlla se serve!
                  end if;
               end if;
            end if;

            -- inizio del gioco, tutti i giocatori devono essere nella propria
            -- posizione di riferimento e qualcuno ha battuto il calcio d'inizio
            declare
               first_condition : Boolean := False;
               second_condition : Boolean := False;
            begin
               -- controllo che tutti i giocatori siano in posizione, tranne quello che
               -- deve sbloccare il gioco
               Print ("[PRE_CHECK] Controllo che tutti siano in posizione, tranne chi batte");
               for i in current_status'Range loop
                  if current_status(i).on_the_field then
                     declare
                        kickoff_player : Integer := Get_Kick_Off_Player (current_match_status);
                        current_coord  : Coordinate := current_status (i).coord;
                        ref_coord      : Coordinate := Get_Starting_Position (current_status(i).number, current_status(i).team);
                     begin
--                            Print("[REFEREE]: KICKOFF ID: " & I2S(kickoff_player));
                        if i /= kickoff_player then
                           first_condition := False;
                           if Compare_Coordinates (current_coord, ref_coord) then
                              first_condition := True;
                           end if;
                           exit when not first_condition;
                        else
                           -- FIXME:: solo per quando si testa con un solo giocatore in campo!
                           first_condition := True;
                        end if;
                     end;
                  end if;
               end loop;

               -- controllo che giocatore X abbia la palla
               if ball_holder_id = Get_Kick_Off_Player (current_match_status) then
                  second_condition := True;
               end if;

               -- controlla che entrambe le condizioni siano soddisfatte
               if first_condition and second_condition then
                  Set_Game_Status (Game_Ready);
               end if;
            end;
         elsif Get_Match_Event_Id (current_match_status) = End_Of_First_Half then
            --
            null;
         elsif Get_Match_Event_Id (current_match_status) = Begin_Of_Second_Half then
            -- controllo se il gioco puo' partire
            Print ("[PRE_CHECK] Controllo se il gioco puo' ripartire");
            if Get_Game_Status = Game_Ready then
               if e /= null then
                  if e.all in Shot_Event'Class then
                     -- ha battuto, il gioco puo' partire
                     Set_Last_Game_Event (null);
                     Set_Game_Status (Game_Running);
                     Print ("[PRE_CHECK] Inizio secondo tempo!");
		     -- faccio partire i timer del secondo tempo
		     -- (tempo partita e buffer eventi)
		     Game_Timer_Second_Half.Start;
		     Soccer.Bridge.Output.Start_Timer;
		     -- mando l'evento alla distribuzione
		     Buffer_Wrapper.Put (Core_Event.Event_Ptr (e));
                     return; -- TODO:: controlla se serve!
                  end if;
               end if;
            end if;

            -- inizio secondo tempo, tutti i giocatori devono essere nella propria
            -- posizione di riferimento e qualcuno ha battuto il calcio d'inizio
            declare
               first_condition : Boolean := False;
               second_condition : Boolean := False;
            begin
               -- controllo che tutti i giocatori siano in posizione, tranne quello che
               -- deve sbloccare il gioco
               Print ("[PRE_CHECK] Controllo che tutti siano in posizione, tranne chi batte");
               for i in current_status'Range loop
                  if current_status (i).on_the_field then
                     declare
                        kickoff_player : Integer := Get_Kick_Off_Player (current_match_status);
                        current_coord : Coordinate := current_status (i).coord;
                        -- ref_coord : Coordinate := TEMP_Get_Coordinate_For_Player (current_status (i).id);
                        ref_coord : Coordinate := Get_Starting_Position (current_status(i).number, current_status(i).team);
                     begin
                        if i /= kickoff_player then
                           first_condition := False;
                           if Compare_Coordinates (current_coord, ref_coord) then
                              first_condition := True;
                           end if;
                           exit when not first_condition;
                        else
                           -- FIXME:: solo per quando si testa con un solo giocatore in campo!
                           first_condition := True;
                        end if;
                     end;
                  end if;
               end loop;

               -- controllo che giocatore X abbia la palla
               if ball_holder_id = Get_Kick_Off_Player (current_match_status) then
                  second_condition := True;
               end if;

               -- controlla che entrambe le condizioni siano soddisfatte
               if first_condition and second_condition then
                  Set_Game_Status (Game_Ready);
               end if;
            end;
         end if;
         -- controllo il game event (dovrebbe essere settato)
      elsif current_game_status /= null then
         -- inizializzo i valori
         game_status_id := Get_Type (current_game_status);
         assigned_team := Get_Team (current_game_status);
         assigned_player := Get_Player_Id (current_game_status);
         current_event_coord := Get_Coordinate (current_game_status);

         case game_status_id is

            when Goal =>
               -- goal
               declare
                  opposite_team : Team_Id;
                  first_condition : Boolean := False;
                  second_condition : Boolean := False;
               begin
                  if assigned_team = Team_One then
                     opposite_team := Team_Two;
                  else
                     opposite_team := Team_One;
                  end if;
                  -- controllo se il gioco puo' riprendere
                  if Get_Game_Status = Game_Ready
                    and e.all in Shot_Event'Class
                    and e.Get_Player_Id = assigned_player then
                     -- ha iniziato, quindi il gioco puo' riprendere
                     Set_Last_Game_Event (null);
                     Set_Game_Status (Game_Running);
                  else
                     -- controllo che tutti i giocatori siano in posizione, tranne quello che
                     -- deve sbloccare il gioco
                     Print ("[PRE_CHECK] Controllo che tutti siano in posizione, tranne chi batte");
                     for i in current_status'Range loop
                        if current_status(i).on_the_field then
                           declare
                              kickoff_player : Integer := assigned_player;
                              current_coord : Coordinate := current_status (i).coord;
                              ref_coord : Coordinate := Get_Starting_Position (current_status(i).number, current_status(i).team);
                           begin
                              if i /= kickoff_player then
                                 first_condition := False;
                                 if Compare_Coordinates (current_coord, ref_coord) then
                                    first_condition := True;
                                 end if;
                                 exit when not first_condition;
                              else
                                 -- FIXME:: solo per quando si testa con un solo giocatore in campo!
                                 first_condition := True;
                              end if;
                           end;
                        end if;
                     end loop;

                     -- controllo che giocatore X abbia la palla
                     if ball_holder_id = assigned_player then
                        second_condition := True;
                     end if;

                     -- controlla che entrambe le condizioni siano soddisfatte
                     if first_condition and second_condition then
                        Set_Game_Status (Game_Ready);
                     end if;
                  end if;
               end;

            when Goal_Kick =>
               -- rimessa dal fondo

               declare
                  current_player_status : Player_Status := current_status (assigned_player);
                  assigned_player_position : Coordinate := current_player_status.coord;
                  first_condition : Boolean := False;
                  second_condition : Boolean := True;
               begin
                  -- controllo se il gioco puo' riprendere
                  if Get_Game_Status = Game_Ready and e.all in Shot_Event'Class then
                     -- ha lanciato, quindi il gioco puo' riprendere
                     Set_Last_Game_Event (null);
                     Set_Game_Status (Game_Running);
                  else
                     -- controllo che chi deve fare la rimessa dal fondo sia in
                     -- posizione, se non lo e' esco
                     if Compare_Coordinates (coord1 => current_status (assigned_player).coord,
                                             coord2 => current_event_coord) then
                        first_condition := True;
                     end if;

                     -- controllo che non ci siano giocatori attorno alla posizione
                     -- di chi deve fare la rimessa dal fondo
		     for i in current_status'Range loop
                        if current_status(i).id /= current_player_status.id
			  and current_status(i).on_the_field
			  and not Compare_Coordinates (current_status (i).coord,
			    Get_Goal_Kick_Position (current_status (i).number,
			      current_status (i).team)) then
				  second_condition := False;
			end if;
                        exit when not second_condition;
		     end loop;

		     if first_condition and second_condition then
			Set_Game_Status (Game_Ready);
		     end if;

                  end if;
               end;

            when Free_Kick =>
               -- calcio di punizione
               declare
                  current_player_status : Player_Status := current_status (assigned_player);
                  assigned_player_position : Coordinate := current_player_status.coord;
                  first_condition : Boolean := False;
                  second_condition : Boolean := True;
               begin
                  -- controllo se il gioco puo' riprendere
                  if Get_Game_Status = Game_Ready and e.all in Shot_Event'Class then
                     -- ha tirato, quindi il gioco puo' riprendere
                     Set_Last_Game_Event (null);
                     Set_Game_Status (Game_Running);
                  else
                     -- controllo che chi deve battere sia in posizione, se non lo e' esco
                     if current_player_status.id = ball_holder_id then
                        first_condition := True;
                     end if;

                     -- controllo che non ci siano giocatori attorno alla posizione
                     -- di chi deve battere (della squadra avversaria)
                     for i in current_status'Range loop
--                          Print("CHECKING PLAYER: " & I2S(current_status(i).id) & " (" & I2S(current_status(i).number) & ") " &
--                                  "DISTANCE: " & Boolean'Image(Distance (From => assigned_player_position,
--                                                                         To => current_status (i).coord) > free_kick_area) &
--                              " ON THE FIELD: " & Boolean'Image(current_status(i).on_the_field));

                        if current_status(i).id /= current_player_status.id
                          and current_player_status.team /= current_status(i).team
                          and current_status(i).on_the_field then
                           if Distance (From => assigned_player_position,
                                        To => current_status (i).coord) <= free_kick_area then
                           second_condition := False;
                           end if;
                        end if;

                        exit when not second_condition;
                     end loop;
                  end if;
--                    Print("FIRST CONDITION: " & Boolean'Image(first_condition) & " SECOND CONDITION: " & Boolean'Image(second_condition));
                  if first_condition and second_condition then
                     Set_Game_Status (Game_Ready);
                  end if;
               end;

            when Penalty_Kick =>
               -- calcio di rigore
               declare
                  current_player_status : Player_Status := current_status (assigned_player);
                  assigned_player_position : Coordinate := current_player_status.coord;
                  assigned_team : Team_Id := current_player_status.team;
                  first_condition : Boolean := False;
                  second_condition : Boolean := True;
               begin
                  -- controllo se il gioco puo' riprendere
                  if Get_Game_Status = Game_Ready and e.all in Shot_Event'Class then
                     -- ha lanciato, quindi il gioco puo' riprendere
                     Set_Last_Game_Event (null);
                     Set_Game_Status (Game_Running);
                  else
                     -- controllo che chi deve battere il calcio di rigore sia in
                     -- posizione, se non lo e' esco
                     if ball_holder_id = assigned_player then
                        first_condition := True;
                     end if;
                     -- controllo che non ci siano giocatori attorno alla posizione
                     -- di chi deve fare la rimessa dal fondo
		     for i in current_status'Range loop
                        if current_status(i).id /= current_player_status.id
			  and current_status(i).on_the_field
			  and not Compare_Coordinates (current_status (i).coord,
			    Get_Penalty_Kick_Position (current_status (i).number,
			      current_status (i).team,
			      assigned_team)) then
				  second_condition := False;
			end if;
                        exit when not second_condition;
		     end loop;

		     if first_condition and second_condition then
			Set_Game_Status (Game_Ready);
		     end if;
                  end if;
               end;

            when Throw_In =>
               -- rimessa
               declare
                  current_player_status : Player_Status := current_status (assigned_player);
                  assigned_player_position : Coordinate := current_player_status.coord;
                  first_condition : Boolean := False;
                  second_condition : Boolean := True;
               begin
                  -- controllo se il gioco puo' riprendere
                  if Get_Game_Status = Game_Ready and e.all in Shot_Event'Class then
                     -- ha lanciato, quindi il gioco puo' riprendere
                     Set_Last_Game_Event (null);
                     Set_Game_Status (Game_Running);
                  else
                     if current_event_coord.coord_y = 0 then
                        current_event_coord.coord_y := 1;
                        Set_Coordinate (current_game_status,current_event_coord);
                        Ball.Set_Position(current_event_coord);
                     elsif current_event_coord.coord_y = field_max_y + 1 then
                        current_event_coord.coord_y := field_max_y;
                        Set_Coordinate (current_game_status,current_event_coord);
                        Ball.Set_Position(current_event_coord);
                     end if;
                     -- controllo che chi deve fare la rimessa sia in posizione,
                     -- se non lo e' esco
                     if ball_holder_id = assigned_player then
                        first_condition := True;
                     end if;

                     -- controllo che ci siano giocatori attorno alla posizione
                     -- di chi deve fare la rimessa
                     for i in current_status'Range loop
                        if current_status(i).id /= current_player_status.id
                          and current_player_status.team /= current_status(i).team
                          and current_status(i).on_the_field then
                           if Distance (From => assigned_player_position,
                                        To => current_status (i).coord) <= free_kick_area then
                              second_condition := False;
                           end if;
                        end if;
                        exit when not second_condition;
                     end loop;
                  end if;

                  if first_condition and second_condition then
                     Set_Game_Status (Game_Ready);
                  end if;
               end;

            when Corner_Kick =>
               -- calcio d'angolo

               declare
                  current_player_status : Player_Status := current_status (assigned_player);
                  assigned_player_position : Coordinate := current_player_status.coord;
                  first_condition : Boolean := False;
                  second_condition : Boolean := True;
               begin
                  -- controllo se il gioco puo' riprendere
                  if Get_Game_Status = Game_Ready and e.all in Shot_Event'Class then
                     -- ha battuto, quindi il gioco puo' riprendere
                     Set_Last_Game_Event (null);
                     Set_Game_Status (Game_Running);
                  else
                     -- controllo che chi deve battere il calcio d'angolo sia in
                     -- posizione, se non lo e' esco
--                       if Compare_Coordinates (coord1 => current_status (assigned_player).coord,
--                                               coord2 => current_event_coord) then
                     if ball_holder_id = assigned_player then
                        first_condition := True;
                     end if;

                     -- controllo che tutti i giocatori siano nelle loro posizioni
		     for i in current_status'Range loop
                        if current_status(i).id /= current_player_status.id
			  and current_status(i).on_the_field
			  and not Compare_Coordinates (current_status (i).coord,
			    			       Get_Corner_Kick_Position (current_status (i).number,
                              							 current_status (i).team,
			      							 assigned_team)) then
                           second_condition := False;
			end if;

                        exit when not second_condition;
		     end loop;

		     if first_condition and second_condition then
			Set_Game_Status (Game_Ready);
		     end if;
		  end if;
               end;
         end case;
      end if;

      -- mando l'evento alla distribuzione
      Buffer_Wrapper.Put (Core_Event.Event_Ptr (e));

   end Pre_Check;


   --+-----------------------------------
   -- POST CHECK
   --+-----------------------------------
   procedure Post_Check is
      last_team_possession : Team_Id := Get_Player_Team_From_Id (id => last_ball_holder);
      new_game_status : Unary_Event_Ptr;
   begin

      -- controllare se c'e' un evento "core" in pending
      -- controllare se il gioco e' fermo
      -- -- controllare se ci sono eventi "dist"
      -- -- -- consumare eventi "dist"
      -- controllare se la palla e' uscita, stabilire se e' un goal,
      -- - una rimessa, un rinvio, un calcio d'angolo, ..

      --

      -- controllo il game event (dovrebbe essere un fallo)
      Print ("[POST_CHECK] Controllo se c'e' stato un fallo");
      if game_event /= null then
	 Print ("[POST_CHECK] C'e' stato un fallo!");
	 if game_event.all in Binary_Event'Class then
	    declare
	       evt : Binary_Event_Ptr := Binary_Event_Ptr (game_event);
	    begin
	       if evt.Get_Event_Id = Foul then
		  declare
		     evt_coord : Coordinate := evt.Get_Coordinate;
		     offender_team : Team_Id := Get_Player_Team_From_Id (evt.Get_Id_Player_1);
		     victim_team : Team_Id := Get_Player_Team_From_Id (evt.Get_Id_Player_2);
		     foul_event : Unary_Event_Ptr := new Unary_Event;
		     is_penalty : Boolean := Is_In_Penalty_Area (offender_team,
						   		 current_status (evt.Get_Id_Player_2).coord);
		     foul_type : Unary_Event_Id;
		  begin
		     -- controllo se il fallo e' stato fatto nell'area di rigore
		     if is_penalty then
			foul_type := Penalty_Kick;
			if offender_team = Team_One then
			   evt_coord := team_one_penalty_coord;
			else
			   evt_coord := team_two_penalty_coord;
			end if;
		     else
			foul_type := Free_Kick;
		     end if;

		     -- inizializzo l'evento di fallo
		     foul_event.Initialize (foul_type,
			      Get_Nearest_Player (evt_coord, victim_team),
			      victim_team,
			      evt_coord);

		     -- setto il risultato (stato di gioco)
                     game_event := null;
		     new_game_status := foul_event;
		  end;
	       end if;
	    end;
	 end if;
      end if;

      -- SE IL GIOCO E' FERMO, controllo eventi della distribuzione
      Print ("[POST_CHECK] Controllo se ci sono eventi dalla distribuzione");
      if Get_Game_Status = Game_Blocked then
	 if manager_events.Length > 0 then
	    Print ("[POST_CHECK] Ci sono eventi dalla distribuzione!");
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
		     number_to_id_1 : Integer;
		     number_to_id_2 : Integer;
                     substitution_team : Team_Id;
                     id1 : Integer;
                     id2 : Integer;
		  begin
		     new_substitution_event := Substitution_Event_Ptr (base_event);
		     Get_Numbers (new_substitution_event, number_to_id_1, number_to_id_2);
		     substitution_team := Get_Team(new_substitution_event);
--                       Print("[MAGIMAGIADIOBOIA]:" & I2S(number_to_id_1) & " " & I2S(number_to_id_2));

		     -- sostituisco i numeri di maglia con i rispettivi ID
                     id1 := ControllerPkg.Get_Id_From_Number (number_to_id_1, substitution_team);
                     id2 := ControllerPkg.Get_Id_From_Number (number_to_id_2, substitution_team);
--                       Print("[MAGIMAGIADIOBOIA]:" & I2S(id1) & " " & I2S(id2));
		     Set_Correct_Ids (new_substitution_event, id1, id2);

		     -- aggiungo in coda la sostituzione
		     pending_substitutions.Append (new_substitution_event);
		  end;
	       end if;
            end loop;
            manager_events.Clear;
	 end if;
      end if;

      Print ("[POST_CHECK] Controllo se la palla e' uscita e ne determino la causa");
      if Get_Game_Status = Game_Running then
         -- controllo delle coordinate della palla
         declare
            ball_coord : Coordinate := Ball.Get_Position;
         begin
            -- controllo se la palla e' uscita dal campo
            if ball_coord.coord_x < 1 or ball_coord.coord_x > field_max_x
              or ball_coord.coord_y < 1 or ball_coord.coord_y > field_max_y then

               Print ("[POST_CHECK] La palla e' uscita dal campo");

               -- controllo se e' stato fatto un goal

	       if ball_coord.coord_y >= team_one_goal_lower_coord.coord_y and
		 ball_coord.coord_y <= team_one_goal_upper_coord.coord_y then
		  declare
		     goal_event : Unary_Event_Ptr := new Unary_Event;
		     scoring_team : Team_Id;
		     opposing_team : Team_Id;
		  begin
		     if last_team_possession = Team_One then
			scoring_team := Team_One;
			Print ("[POST_CHECK] Team_One ha segnato!");
		     else
			scoring_team := Team_Two;
			Print ("[POST_CHECK] Team_Two ha segnato!");
		     end if;

		     if scoring_team = Team_One then
			opposing_team := Team_Two;
		     else
			opposing_team := Team_One;
		     end if;

		     goal_event.Initialize (new_event_id    => Goal,
			      new_player_id   => Get_Id_From_Number (Get_Number_From_Formation (10, opposing_team), opposing_team),
			      new_team_id     => scoring_team,
			      new_event_coord => middle_field_coord);
		     new_game_status := goal_event;
		  end;

		-- controllo se va assegnata una rimessa laterale
               elsif ball_coord.coord_x > 0 and ball_coord.coord_x < field_max_x + 1 then
                  Print ("[POST_CHECK] Rimessa laterale");

                  new_game_status := new Unary_Event;
                  new_game_status.Initialize (
                                              new_event_id    => Throw_In,
                                              new_player_id   => Get_Nearest_Field_Player (ball_coord, Get_Opposing_Team (last_team_possession)),
                                              new_team_id     => Get_Opposing_Team (last_team_possession),
                                              new_event_coord => ball_coord);
                  Print("[RIMESSA LATERALE]: BALL COORDINATE: " & Print_Coord(ball_coord));
                  Print("[RIMESSA LATERALE]: OPPOSING TEAM: " & Team_Id'Image(Get_Opposing_Team (last_team_possession)));
                  Print("[RIMESSA LATERALE]: NEAREST PLAYER: " & I2S(Get_Nearest_Field_Player (ball_coord, Get_Opposing_Team (last_team_possession))));
	       elsif ball_coord.coord_x = 0 or ball_coord.coord_x = field_max_x + 1 then
		  -- controllo se va assegnato un calcio d'angolo o un rinvio dal
		  -- fondo (non controllo la y perche' ho gia' controllato il gol)
		  Print ("[POST_CHECK] Controllo se va assegnato un calcio d'angolo o un rinvio dal fondo");
		  declare
		     new_event : Unary_Event_Ptr := new Unary_Event;
		     new_evt_coord : Coordinate := Coordinate'(0,0);
		  begin
		     if ball_coord.coord_y < field_max_y / 2 then
			Set_Coord_Y (coord => new_evt_coord, value => 1);
		     else
			Set_Coord_Y (coord => new_evt_coord, value => field_max_y);
		     end if;

		     if last_team_possession = Team_One then
			if ball_coord.coord_x = 0 then
			   -- assegna un calcio d'angolo a Team_Two
			   Print ("[POST_CHECK] Calcio d'angolo per Team_Two");

			   Set_Coord_X (coord => new_evt_coord, value => 1);

			   new_event.Initialize (new_event_id    => Corner_Kick,
			    			 new_player_id   => Get_Id_From_Number(Get_Number_From_Formation(6, Team_Two),Team_Two),
                            			 new_team_id     => Team_Two,
                            new_event_coord => new_evt_coord);
			elsif ball_coord.coord_x = field_max_x + 1 then
			   -- assegna una rimessa dal fondo a Team_Two
			   Print ("[POST_CHECK] Rimessa dal fondo per Team_Two");

			   Set_Coord_X (coord => new_evt_coord, value => field_max_x - 3);
			   Set_Coord_Y (new_evt_coord, field_max_y / 2);

			   new_event.Initialize (new_event_id    => Goal_Kick,
			    new_player_id   => Get_Id_From_Number (Get_Goalkeeper_Number (Team_Two),Team_Two),
			    new_team_id     => Team_Two,
			    new_event_coord => new_evt_coord);
			end if;
		     else
			if ball_coord.coord_x = 0 then
			   -- assegna una rimessa dal fondo a Team_One
			   Print ("[POST_CHECK] Rimessa dal fondo per Team_One");

			   Set_Coord_X (coord => new_evt_coord, value => 3);
			   Set_Coord_Y (new_evt_coord, field_max_y / 2);

			   new_event.Initialize (new_event_id    => Goal_Kick,
			    new_player_id   => Get_Id_From_Number (Get_Goalkeeper_Number (Team_One),Team_One), -- portiere
			    new_team_id     => Team_One,
			    new_event_coord => new_evt_coord);
			elsif ball_coord.coord_x = field_max_x + 1 then
			   -- assegna un calcio d'angolo a Team_One

			   Print ("[POST_CHECK] Calcio d'angolo per Team_One");

			   Set_Coord_X (coord => new_evt_coord, value => field_max_x);

			   new_event.Initialize (new_event_id    => Corner_Kick,
			    new_player_id   => Get_Id_From_Number(Get_Number_From_Formation(6, Team_One),Team_One),
			    new_team_id     => Team_One,
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
      Print ("[POST_CHECK] Se c'e' un nuovo stato di gioco, lo setto");
      if new_game_status /= null then
	 Print ("[POST_CHECK] Imposto il nuovo stato di gioco");
	 Set_Last_Game_Event (event => Game_Event_Ptr (new_game_status));
         Set_Game_Status (Game_Blocked);

	 -- mando l'evento alla distribuzione
	 Buffer_Wrapper.Put (Core_Event.Event_Ptr (new_game_status));

         -- setto la nuova posizione della palla E STOPPO IL MOTION AGENT, SE ATTIVO
         if Ball.Get_Moving then
            Motion_Enabler.Stop;
         end if;

         Ball.Set_Position (new_position => Get_Coordinate (new_game_status));
         Ball.Set_Controlled (False);
         Ball.Set_Moving (False);
      end if;

      Print ("[POST_CHECK] Fine controlli");

   end Post_Check;

   function Get_Nearest_Player (event_coord : in Coordinate; team : in Team_Id) return Integer is
      smallest_distance : Integer := Integer'Last;
      player : Integer;
   begin
      for i in current_status'Range loop
         declare
            current_distance : Integer := Distance (From => event_coord,
                                                    To => current_status (i).coord);
         begin
	    if current_status (i).team = team and current_distance < smallest_distance
	      and current_status (i).on_the_field then
               smallest_distance := current_distance;
               player := i;
            end if;
         end;
      end loop;

      return player;
   end Get_Nearest_Player;

   function Get_Nearest_Field_Player (event_coord : in Coordinate; team : in Team_Id) return Integer is
      smallest_distance : Integer := Integer'Last;
      player : Integer;
   begin
      for i in current_status'Range loop
         if current_status(i).on_the_field then
            declare
               current_distance : Integer := Distance (From => event_coord,
                                                       To => current_status (i).coord);
            begin
               if current_status(i).team = team and current_distance < smallest_distance then
                  smallest_distance := current_distance;
                  player := i;
               end if;
            end;
         end if;
      end loop;

      return player;
   end Get_Nearest_Field_Player;

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

   function Get_Last_Ball_Holder return Integer is
   begin
      return last_ball_holder;
   end Get_Last_Ball_Holder;

   function Get_Opposing_Team (current_team : Team_Id) return Team_Id is
   begin
      if current_team = Team_One then
	 return Team_Two;
      end if;

      return Team_One;
   end Get_Opposing_Team;

end Soccer.ControllerPkg.Referee;
