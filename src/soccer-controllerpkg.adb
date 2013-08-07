with Ada.Text_IO; use Ada.Text_IO;

with Soccer.Utils;
use Soccer.Utils;

--  with Soccer.ControllerPkg.Referee;
--  use Soccer.ControllerPkg.Referee;

with Ada.Numerics.Generic_Elementary_Functions;
with Soccer.Bridge.Output; use Soccer.Bridge.Output;
with Soccer.Manager_Event; use Soccer.Manager_Event;
with Soccer.BallPkg; use Soccer.BallPkg;
with Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event;
use Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event;
with Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event;
use Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event;
with Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event;
use Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event;
with Soccer.Core_Event.Motion_Core_Event.Catch_Motion_Event;
use Soccer.Core_Event.Motion_Core_Event.Catch_Motion_Event;
with Soccer.Motion_AgentPkg; use Soccer.Motion_AgentPkg;
with Ada.Numerics.Discrete_Random;
with Soccer.ControllerPkg; use Soccer.ControllerPkg;
with Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
use Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
with Soccer.ControllerPkg.Referee; use Soccer.ControllerPkg.Referee;
with Soccer.Core_Event.Game_Core_Event; use Soccer.Core_Event.Game_Core_Event;
with Soccer.Core_Event.Game_Core_Event.Match_Game_Event; use Soccer.Core_Event.Game_Core_Event.Match_Game_Event;

package body Soccer.ControllerPkg is

   --+ Ritorna la posizione in base all'id
   function Get_Generic_Status(id : in Integer) return Generic_Status_Ptr is
      coord_result : Coordinate;
      holder_result : Boolean := False;
      nearby_result : Boolean := False;
      gen_stat : Generic_Status_Ptr := new Generic_Status;
   begin
      for i in current_status'Range loop
         if(current_status (i).id = id) then
            coord_result := current_status (i).coord;
            if(ball_holder_id = current_status (i).id) then
               holder_result := True;
            elsif Distance(From => Ball.Get_Position,
                           To   => current_status (i).coord) <= nearby_distance then
               nearby_result := True;
            else
               nearby_result := False;
            end if;
            exit;
         end if;
      end loop;

      gen_stat.coord := coord_result;
      gen_stat.team := Get_Team_From_Id (id);
      gen_stat.holder := holder_result;
      gen_stat.nearby := nearby_result;
      gen_stat.last_game_event := last_game_event;
      gen_stat.game_status := game_status;

      return gen_stat;

   end Get_Generic_Status;

   procedure Set_Last_Game_Event (event : Game_Event_Ptr) is begin
      last_game_event := event;
   end Set_Last_Game_Event;

   function Get_Last_Game_Event return Game_Event_Ptr is
   begin
      return last_game_event;
   end Get_Last_Game_Event;

   function Get_Game_Status return Game_State is
   begin
      return game_status;
   end Get_Game_Status;

   procedure Set_Game_Status (new_status : Game_State) is
   begin
      game_status := new_status;
   end Set_Game_Status;

   function Get_Players_Status return Status is
   begin
      return current_status;
   end Get_Players_Status;

   --+ Ritorna un Vector di Coordinate (id, x, y) dei giocatori di distanza <= a r
   function Read_Status (x : in Integer; y : in Integer; r : in Integer) return Read_Result is
      result : Read_Result := new Read_Result_Type;
      dist : Integer := 0;
   begin
      for i in current_status'Range loop
         dist := Distance(x1 => x,
                       x2 => current_status (i).coord.coord_x,
                       y1 => y,
                       y2 => current_status (i).coord.coord_y);
         if dist <= r and dist /= 0 then
            result.players_in_my_zone.Append (New_Item => current_status (i));
         end if;
      end loop;
      result.holder_id := ball_holder_id;
      return result;
   end Read_Status;

   --+ Controlla se in quella cella c'e' un giocatore
   function Check_For_Player_In_Cell (x : in Integer; y : in Integer) return Integer is
   begin
      for i in current_status'Range loop
         if (current_status(i).coord.coord_x = x and current_status(i).coord.coord_y = y) then
            if(current_status(i).id = ball_holder_id) then
               return -1 * current_status(i).id;
            else
               return current_status(i).id;
            end if;
         end if;
      end loop;
      if Ball.Get_Position.coord_x = x and Ball.Get_Position.coord_y = y then
         return 100;
      end if;
      return 0;
   end Check_For_Player_In_Cell;

   function Is_Cell_Free (coord : Coordinate) return Boolean is
      occupied : Boolean := False;
   begin
      for i in current_status'Range loop
	 if Compare_Coordinates (current_status (i).coord, coord) then
	    occupied := True;
	 end if;
	 exit when occupied;
      end loop;

      return occupied;
   end Is_Cell_Free;

   --+ Inizializza l'array Status con l'id di ogni giocatore
   -- TODO:: inizializzare con roba da json prima di avviare i giocatori
   procedure Initialize is
   begin
      for i in 1 .. num_of_players loop
	 current_status (i).id := i;
	 current_status (i).coord := Coordinate'(0,0);
         if i < 4 then
            current_status (i).team := Team_One;
         else
            current_status (i).team := Team_Two;
         end if;
      end loop;
   end Initialize;

   --+ Stampa del campo
   procedure Print_Field is
      cell : Integer;
   begin
      --Utils.CLS;

      for i in  1 .. field_max_x + 1 loop
         Put("-");
      end loop;
      Put_Line("");
      for y in reverse 1 .. field_max_y loop
         Put("|");
         for x in 1 .. field_max_x loop
            cell := Check_For_Player_In_Cell(x => x, y => y);
            if cell = 0 then
               Put(" ");
            elsif cell = 100 then
               Put ("*");
            else
               if(cell < 0) then
                  Put ("*" & I2S (cell));
               else
                  Put("" & I2S(cell));
               end if;
            end if;
         end loop;
         Put("|");
         Put_Line("");
      end loop;
      for i in  1 .. field_max_x + 1 loop
         Put("-");
      end loop;
      Put_Line("");
   end Print_Field;

   task body Field_Printer is
   begin
      loop
         Print_Field;
         delay duration (0.5);
      end loop;
   end Field_Printer;

   function Get_Ball_Holder return Integer is
   begin
      return ball_holder_id;
   end Get_Ball_Holder;

   function Get_Zone (coord : Coordinate) return Integer is
   begin
      if Compare_Coordinates (coord, TEMP_Get_Coordinate_For_Player (0)) then
	 return 0;
      end if;

      return (Integer (Float'Floor (Float (coord.coord_x - 1) / (Float (field_max_x) / Float (number_of_zones)))) + 1);
   end Get_Zone;

   procedure Release (coord : Coordinate) is
   begin
      Released(Get_Zone(coord => coord)) := True;
   end Release;

   function Occupy (coord : Coordinate) return Field_Zones is
      Zone : Field_Zones;
   begin
      Zone := Field_Zones(Get_Zone(coord => coord));
      Released(Integer(Zone)) := False;
      return Zone;
   end Occupy;

   type Alternative_Coord_Index_Range is range 1 .. 2;
   package Random_Index is new Ada.Numerics.Discrete_Random (Alternative_Coord_Index_Range);

   function Get_Alternative_Coord (coord : Coordinate; target : Coordinate) return Coordinate is
      seed : Random_Index.Generator;
      random_value : Integer;
      option_one : Coordinate;
      option_two : Coordinate;

      result : Coordinate;
   begin
--        around_array := (Coordinate'(coord.coord_x+1,coord.coord_y+1),	 	-- alto destra
--  			  Coordinate'(coord.coord_x+1,coord.coord_y), 		-- destra
--  			  Coordinate'(coord.coord_x+1,coord.coord_y-1), 	-- basso destra
--  			  Coordinate'(coord.coord_x,coord.coord_y-1), 		-- basso
--  			  Coordinate'(coord.coord_x-1,coord.coord_y-1), 	-- basso sinistra
--  			  Coordinate'(coord.coord_x-1,coord.coord_y), 		-- sinistra
--  			  Coordinate'(coord.coord_x-1,coord.coord_y+1), 	-- alto sinistra
--  			  Coordinate'(coord.coord_x,coord.coord_y+1)); 		-- alto

      Random_Index.Reset(seed);
      random_value := Integer(Random_Index.Random(seed));

      if coord.coord_x < target.coord_x and coord.coord_y < target.coord_y then
	 option_one := Coordinate'(coord.coord_x + 1, coord.coord_y);
	 option_two := Coordinate'(coord.coord_x, coord.coord_y + 1);

	 if random_value = 1 then
	    result := option_one;
	 else
	    result := option_two;
	 end if;
      elsif (coord.coord_x < target.coord_x and coord.coord_y = target.coord_y) then
	 option_one := Coordinate'(coord.coord_x + 1, coord.coord_y + 1);
	 option_two := Coordinate'(coord.coord_x + 1, coord.coord_y - 1);

	 if random_value = 1 then
	    result := option_one;
	 else
	    result := option_two;
	 end if;
      elsif (coord.coord_x < target.coord_x and coord.coord_y > target.coord_y) then
	 option_one := Coordinate'(coord.coord_x + 1, coord.coord_y);
	 option_two := Coordinate'(coord.coord_x, coord.coord_y - 1);

	 if random_value = 1 then
	    result := option_one;
	 else
	    result := option_two;
	 end if;
      elsif (coord.coord_x = target.coord_x and coord.coord_y > target.coord_y) then
	 option_one := Coordinate'(coord.coord_x - 1, coord.coord_y - 1);
	 option_two := Coordinate'(coord.coord_x + 1, coord.coord_y - 1);

	 if random_value = 1 then
	    result := option_one;
	 else
	    result := option_two;
	 end if;
      elsif (coord.coord_x > target.coord_x and coord.coord_y > target.coord_y) then
	 option_one := Coordinate'(coord.coord_x - 1, coord.coord_y);
	 option_two := Coordinate'(coord.coord_x, coord.coord_y - 1);

	 if random_value = 1 then
	    result := option_one;
	 else
	    result := option_two;
	 end if;
      elsif (coord.coord_x > target.coord_x and coord.coord_y = target.coord_y) then
	 option_one := Coordinate'(coord.coord_x - 1, coord.coord_y + 1);
	 option_two := Coordinate'(coord.coord_x - 1, coord.coord_y - 1);

	 if random_value = 1 then
	    result := option_one;
	 else
	    result := option_two;
	 end if;
      elsif (coord.coord_x > target.coord_x and coord.coord_y < target.coord_y) then
	 option_one := Coordinate'(coord.coord_x, coord.coord_y + 1);
	 option_two := Coordinate'(coord.coord_x - 1, coord.coord_y);

	 if random_value = 1 then
	    result := option_one;
	 else
	    result := option_two;
	 end if;
      else
	 option_one := Coordinate'(coord.coord_x + 1, coord.coord_y + 1);
	 option_two := Coordinate'(coord.coord_x - 1, coord.coord_y + 1);

	 if random_value = 1 then
	    result := option_one;
	 else
	    result := option_two;
	 end if;
      end if;

      return result;

   end Get_Alternative_Coord;

   type Rand_Range is range 1 .. 10;
   package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);

   procedure Calculate_Tackle (attacker_id : in Integer; ball_owner_id : in Integer; with_foul : out Boolean; success : out Boolean) is
      tackle_seed : Rand_Int.Generator;
   begin
      Rand_Int.Reset(tackle_seed);
      if Integer(Rand_Int.Random(tackle_seed)) > 5 then
         success := True;
      else
         success := False;
      end if;

      Rand_Int.Reset(tackle_seed);
      if Integer(Rand_Int.Random(tackle_seed)) > 1 then -- TODO::FIXME tackle sulla base delle caratteristiche del giocatore!
	 with_foul := True;
      else
	 with_foul := False;
      end if;
   end Calculate_Tackle;

   --+ Nel caso in cui il giocatore si sposti con la palla non cambia la mossa scritta nel buffer
   --+dovra' essere lato distribuzione interpolare se la palla e' ancora in possesso di un giocatore
   --+ o se si sta spostando con l'agente di movimento, ecc. ecc.
   procedure Compute (action : in Move_Event_Prt; success : out Boolean) is
      here_player_result : Integer;
   begin
      here_player_result := Check_For_Player_In_Cell(x => action.Get_To.coord_x,
						     y => action.Get_To.coord_y);

      if here_player_result = 0 or here_player_result = 100 then
	 -- il giocatore si sposta li'
	 Put_Line ("[COMPUTE] Il giocatore " & I2S (action.Get_Player_Id)
	    & " si e' spostato sulla cella " & Print_Coord (action.Get_To));
         current_status (action.Get_Player_Id).coord := action.Get_To;
         if ball_holder_id = action.Get_Player_Id then
            Ball.Move_Player(new_coord => action.Get_To);
         end if;
         Buffer_Wrapper.Put(new_event => Core_Event.Event_Ptr (action));

	 Put_Line ("[COMPUTE] Il giocatore " & I2S (action.Get_Player_Id) & " sta per rilasciare la zona con coordinata " & Print_Coord (action.Get_From));
         Release (action.Get_From);
         success := True;
      else
	 Put_Line ("[COMPUTE] Il giocatore " & I2S (action.Get_Player_Id)
	    & " ha fallito lo spostamento (val: " & I2S (here_player_result)
	    & ") verso la cella " & Print_Coord (action.Get_To));
         success := False;
      end if;
   end Compute;

   procedure Compute (action : in Shot_Event_Ptr; success : out Boolean) is
   begin
      Put_Line("[CONTROLLER] Shot_Event");
      if Utils.Compare_Coordinates(coord1 => Ball.Get_Position,
                                   coord2 => action.Get_From) then
         Ball.Set_Controlled(new_status => False);
         Ball.Set_Moving(new_status => True);

	 Referee.Set_Last_Ball_Holder (holder => ball_holder_id);
	 ball_holder_id := 0;

	 Motion_AgentPkg.Motion_Enabler.Move(source => action.Get_From,
                                             target => action.Get_To,
                                             power  => action.Get_Shot_Power);
         success := True;
      else
         success := False;
      end if;
   end Compute;

   procedure Compute (action : in Tackle_Event_Ptr; success : out Boolean) is
      with_foul : Boolean := False;
      tackle_success : Boolean;
   begin
      Put_Line("[CONTROLLER] Tackle_Event");
      if Utils.Compare_Coordinates(coord1 => action.Get_To,
				   coord2 => current_status(action.Get_Other_Player_Id).coord) then
	    -- Tento di rubargli la palla!
	    Calculate_Tackle(attacker_id   => action.Get_Player_Id,
		      ball_owner_id => action.Get_Other_Player_Id,
		      with_foul => with_foul,
		      success => tackle_success);

	 -- Notifico l'arbitro se c'e' stato un contrasto con fallo
	 declare
	    foul_event : Binary_Event_Ptr := new Binary_Event;
	 begin
	    if with_foul then
	       Put_Line("[CONTROLLER] Giocatore " & I2S (action.Get_Player_Id) & " ha commesso un fallo su Giocatore " & I2S (action.Get_Other_Player_Id));
	       foul_event.Initialize(new_event_id    => Foul,
			      new_player_1_id => action.Get_Player_Id,
			      new_player_2_id => action.Get_Other_Player_Id,
			      new_event_coord => action.Get_To);

	       Referee.Notify_Game_Event(event => Game_Event_Ptr (foul_event));
	    end if;
	 end;

	 if tackle_success then
	    -- hell yeah! Mi prendo la palla
	    Put_Line("[CONTROLLER] Giocatore " & I2S (action.Get_Player_Id) & " ha preso la palla");
	    ball.Move_Player(new_coord => action.Get_From);
	    ball_holder_id := action.Get_Player_Id;
	    Set_Last_Ball_Holder (holder => ball_holder_id);

            declare
               new_action : Motion_Event_Ptr := new Motion_Event;
            begin
               new_action.Initialize(nPlayer_Id => 0,
                                     nFrom      => action.Get_To,
                                     nTo        => action.Get_From);
               Buffer_Wrapper.Put(new_event => Core_Event.Event_Ptr (new_action));
               Buffer_Wrapper.Send;
            end;

            success := True;
         else
            -- oh no :-(
            success := False;
         end if;
      else
         success := False;
      end if;
   end Compute;

   procedure Compute (action : in Catch_Event_Ptr; success : out Boolean) is
   begin
      Put_Line("[CONTROLLER] Catch_Event");
      Ball.Catch(player_coord => action.Get_To,
                 succeded      => success);
      if success then
	 Put_Line("[CONTROLLER] Giocatore " & I2S (action.Get_Player_Id) & " ha preso la palla!");
	 ball_holder_id := action.Get_Player_Id;
	 Set_Last_Ball_Holder (ball_holder_id);
      else
	 Put_Line("[CONTROLLER] Catch fallita");
      end if;
   end Compute;

   procedure Compute (action : in Motion_Event_Ptr; success : out Boolean; revaluate : out Boolean) is
   begin
      success := False;
      revaluate := False;
      if action.all in Move_Event'Class then
         revaluate := True;
         Compute(action  => Move_Event_Prt(action),
                 success => success);
      elsif action.all in Shot_Event'Class then
         Compute(action  => Shot_Event_Ptr(action),
                 success => success);
      elsif action.all in Tackle_Event'Class then
         Compute(action  => Tackle_Event_Ptr(action),
                 success => success);
      elsif action.all in Catch_Event'Class then
         Compute(action  => Catch_Event_Ptr(action),
                 success => success);
      end if;
   end Compute;

   task body Controller is
      utility_constraint : Utility_Constraint_Type := 6;
      compute_result : Boolean;
      revaluate : Boolean;

      initial_match_event : Match_Event_Ptr;

   begin
      Initialize;
      --Timer_Control.Start;

      -- imposto l'evento d'inizio gioco
      initial_match_event := new Match_Event;
      initial_match_event.Initialize (Begin_Of_Match,
				      Get_Nearest_Player (Ball.Get_Position, Team_One));

      last_game_event := Game_Event_Ptr (initial_match_event);
      game_status := Game_Paused;

      -- metto la palla al centro del campo (circa)
      ball_holder_id := 0;
      Ball.Set_Controlled (False);
      Ball.Set_Position (Coordinate'(field_max_x / 2, field_max_y / 2));

      loop
	 -- aggiungere controllo su flag del gioco (per pausa, fine_gioco, ecc)
	 for Zone in Field_Zones'Range loop
	    select
	       accept Write (current_action : in out Action) do

		  -- provo a soddisfare la richiesta del giocatore
		  Compute(current_action.event, compute_result, revaluate);

		  if compute_result and current_action.event.all not in Move_Event'Class then
			last_player_event := current_action.event;
		  end if;

		  if not compute_result and revaluate then
		     -- Devo distinguere tra i tipi di mosse
		     Put_Line("[CONTROLLER] Giocatore " & I2S(current_action.event.Get_Player_Id) & " riaccodato");
		     if(current_action.utility > utility_constraint) then
			current_action.utility := current_action.utility - 1;
			requeue Awaiting(Occupy(current_action.event.Get_To));
		     else
			Put_Line("[CONTROLLER] Mossa da rivedere");
			declare
			   old_move : Motion_Event_Ptr := current_action.event;
			   new_move : Motion_Event_Ptr := new Move_Event;
			   id : Integer := Get_Player_Id (old_move.all);
			   from : Coordinate := Get_From (old_move.all);
			   to : Coordinate := Get_to (old_move.all);
			   alternative : Coordinate := Get_Alternative_Coord (from, to);
			begin
			   revaluate := False;
			   new_move.Initialize (id, from, alternative);
			   Put_Line("[CONTROLLER] Mossa per il Giocatore " & I2S(current_action.event.Get_Player_Id)
	       & " rivalutata alla cella " & Print_Coord (alternative));
			   Compute (new_move, compute_result, revaluate);
			end;
		     end if;
		  else
		     -- stampo il campo
--  		     Print_Field;
		     -- invocare l'arbitro per controllare lo stato del gioco dopo l'azione
		     Put_Line("[CONTROLLER] Sto per chiamare l'arbitro");
		     Referee.Pre_Check (last_player_event);
		     Referee.Post_Check;
		     null;
		  end if;
		  end Write;
            or
               when Released (Integer(Zone)) = True =>
                  accept Awaiting (Zone) (current_action : in out Action) do
                     Put_Line("[CONTROLLER] Giocatore " & I2S(current_action.event.Get_Player_Id) & "pescato dalla coda");

		     Compute(current_action.event, compute_result, revaluate);
		     if compute_result then
			last_player_event := current_action.event;
		     end if;

                     if not compute_result and revaluate then
			Put_Line("[CONTROLLER] Giocatore " & I2S(current_action.event.Get_Player_Id)
			  & " bloccato dal giocatore " & I2S(Check_For_Player_In_Cell(x => current_action.event.Get_To.coord_x, y => current_action.event.Get_To.coord_y))
			  & " alle coordinate " & I2S(current_action.event.Get_To.coord_x) & " " & I2S(current_action.event.Get_To.coord_y));
                        if(current_action.utility > utility_constraint) then
                           current_action.utility := current_action.utility - 1;
                           requeue Awaiting(Occupy(current_action.event.Get_To));
                        else
			   Put_Line("[CONTROLLER] Mossa da rivedere (in riaccodamento)");
			   declare
			      old_move : Motion_Event_Ptr := current_action.event;
			      new_move : Motion_Event_Ptr := new Move_Event;
			      id : Integer := Get_Player_Id (old_move.all);
			      from : Coordinate := Get_From (old_move.all);
			      to : Coordinate := Get_to (old_move.all);
			      alternative : Coordinate := Get_Alternative_Coord (from, to);
			   begin
			      revaluate := False;
			      new_move.Initialize (id, from, alternative);
			      Put_Line("[CONTROLLER] Mossa per il Giocatore " & I2S(current_action.event.Get_Player_Id)
		  & " rivalutata alla cella " & Print_Coord (alternative));
			      Compute (new_move, compute_result, revaluate);
			   end;
			end if;
		     else
--  			stampo il campo
			Print_Field;
			-- invocare l'arbitro per controllare lo stato del gioco dopo l'azione
			Referee.Pre_Check (last_player_event);
   			Referee.Post_Check;
			null;
		     end if;
		  end Awaiting;
            end select;
         end loop;
      end loop;

   end Controller;

end Soccer.ControllerPkg;
