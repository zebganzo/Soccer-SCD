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
   function Get_Generic_Status (id : in Integer) return Generic_Status_Ptr is
      coord_result  : Coordinate;
      holder_result : Boolean := False;
      nearby_result : Boolean := False;
      number_result : Integer;
      gen_stat      : Generic_Status_Ptr := new Generic_Status;
   begin
      for i in current_status'Range loop
         if current_status (i).id = id then
            coord_result := current_status (i).coord;
            number_result := current_status(i).number;
            if ball_holder_id = current_status (i).id then
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
      gen_stat.number := number_result;
      gen_stat.team := Get_Player_Team_From_Id (id);
      gen_stat.holder := holder_result;
      gen_stat.nearby := nearby_result;
      gen_stat.last_game_event := last_game_event;
      gen_stat.game_status := game_status;
      gen_stat.holder_team := Get_Player_Team_From_Id(ball_holder_id);
      gen_stat.last_ball_holder_id := Referee.Get_Last_Ball_Holder;

--        Print ("[CONTROLLER] Generic Status for Player " & I2S (id));
--          Print ("MAGLIA: " & I2S(gen_stat.number) &
--            " TEAM: " & Team_Id'Image(gen_stat.team));

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

   procedure Print (input : String) is
   begin
      if debug then
	 pragma Debug (Put_Line (input));
	 null;
      end if;
   end Print;

   -- Returns the player's team, given the player's id
   function Get_Player_Team_From_Id(id : in Integer) return Team_Id is
      player_team : Team_Id;
      m_event     : Match_Event_Ptr;
   begin
      if id = 0 then
         if last_game_event /= null then
	    -- Match Event
            if last_game_event.all in Match_Event'Class then
	       m_event := Match_Event_Ptr(last_game_event);
	       -- Match Event: Begin_Of_Match or Begin_Of_Second_Half
               if Get_Match_Event_Id(m_event) = Begin_Of_Match then
                  return Team_One;
               elsif Get_Match_Event_Id(m_event) = Begin_Of_Second_Half then
                  return Team_Two;
               end if;
            end if;
         else
            return Get_Player_Team_From_Id(Get_Last_Ball_Holder);
         end if;
      end if;

      for i in current_status'Range loop
         if id = current_status(i).id then
            player_team := current_status(i).team;
         end if;
      end loop;

      return player_team;
   end Get_Player_Team_From_Id;

   -- Returns the player's id, given his number
   function Get_Id_From_Number(number : in Integer) return Integer is
      player_id : Integer;
   begin
      for i in current_status'Range loop
         if number = current_status(i).number then
            player_id := current_status(i).id;
         end if;
      end loop;
      return player_id;
   end Get_Id_From_Number;

   -- Returns the player number from id
   function Get_Number_From_Id (id : in Integer) return Integer is
      player_number : Integer;
   begin
      for i in current_status'Range loop
         if id = current_status(i).id then
            player_number := current_status(i).number;
         end if;
      end loop;
      return player_number;
   end Get_Number_From_Id;


   --+ Ritorna un Vector di Coordinate (id, x, y) dei giocatori di distanza <= a r
   function Read_Status (x : in Integer; y : in Integer; r : in Integer) return Read_Result is
      result : Read_Result := new Read_Result_Type;
      dist   : Integer := 0;
   begin
      for i in current_status'Range loop
         dist := Distance(x1 => x,
                          x2 => current_status (i).coord.coord_x,
                          y1 => y,
                          y2 => current_status (i).coord.coord_y);
         if dist <= r and dist /= 0 and current_status (i).on_the_field then
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
         if current_status (i).coord.coord_x = x and current_status (i).coord.coord_y = y then
            if current_status (i).id = ball_holder_id then
               return -1 * current_status (i).number;
            else
               return current_status (i).number;
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
      team_one_ptr : Team_Ptr := Get_Team (Team_One);
      team_two_ptr : Team_Ptr := Get_Team (Team_Two);
      counter : Integer := 1;
   begin
  --    Print ("TEAM ONE:" & Boolean'Image(team_one_ptr = null));
  --    Print ("TEAM ONE:" & I2S(team_one_ptr.players'Length));
  --    Print ("TEAM ONE:" & Team_Id'Image(team_one_ptr.id));
      for i in team_one_ptr.players'Range loop
	 declare
	    current_player : Integer;
	 begin
            current_player := team_one_ptr.players (i);

            current_status (counter).id := counter;
--              Print ("ID: " & I2S(counter));
	    current_status (counter).number := current_player;
--              Print ("MAGLIA: " & I2S(current_player));
	    current_status (counter).coord := Coordinate'(counter,0);
	    current_status (counter).team := Team_One;
--              Print ("TEAM: " & "TEAM_ONE));

	    counter := counter + 1;
	 end;
      end loop;

      for i in team_two_ptr.players'Range loop
	 declare
	    current_player : Integer;
	 begin
	    current_player := team_two_ptr.players (i);

	    current_status (counter).id := counter;
--              Print ("ID: " & I2S(counter));
	    current_status (counter).number := current_player;
--              Print ("MAGLIA: " & I2S(current_player));
	    current_status (counter).coord := Coordinate'(counter,0);
	    current_status (counter).team := Team_Two;
--              Print ("TEAM: " & "TEAM_TWO");

	    counter := counter + 1;
	 end;
      end loop;

   end Initialize;

   init_players_count : Integer := 1;
   team_one_players_count : Integer := 1;
   team_two_players_count : Integer := 1;
   initialized : Boolean := False;

   procedure Get_Id (id : out Integer) is
      team_one_ptr : Team_Ptr := Get_Team (Team_One);
      team_two_ptr : Team_Ptr := Get_Team (Team_Two);
      result : Integer := 0;
   begin
      Print ("[CONTROLLER] Get_Id");

      if not initialized then
	 Print ("[CONTROLLER] Initializing status");
	 Initialize;
	 initialized := True;
      end if;

--        Print ("[CONTROLLER] Length is " & I2S (team_one_ptr.players'Length));

      if team_one_players_count <= team_one_ptr.players'Length then
	 result := team_one_ptr.players (team_one_players_count);
--  	 Print ("[CONTROLLER] Team 1 - ID " & I2S (result));

	 team_one_players_count := team_one_players_count + 1;
--  	 Print ("[CONTROLLER] New count " & I2S (team_one_players_count));
      else
	 if team_two_players_count <= team_two_ptr.players'Length then
	    result := team_two_ptr.players (team_two_players_count);
--  	    Print ("[CONTROLLER] Team 2 - ID " & I2S (result));

	    team_two_players_count := team_two_players_count + 1;
--  	    Print ("[CONTROLLER] New count " & I2S (team_one_players_count));
	 end if;
      end if;

      init_players_count := init_players_count + 1;
      id := result;
--       Print ("[CONTROLLER] Id = " & I2S (id));

--        Print ("[CONTROLLER] Fine Get_Id");

   end Get_Id;

   --+ Stampa del campo
   procedure Print_Field is
      cell : Integer;
   begin
      --Utils.CLS;

      for i in  1 .. field_max_x loop
         Put("---");
      end loop;
      Put_Line("");
      for y in reverse 1 .. field_max_y loop
         if y < 15 or y > 19 then
            Put("|");
         end if;
         for x in 1 .. field_max_x loop
            cell := Check_For_Player_In_Cell(x => x, y => y);
            if cell = 0 then
               Put("   ");
            elsif cell = 100 then
               Put (" * ");
            else
               if(cell < 0) then
                  if cell >= 10 then
                     Put ("*" & I2S (cell));
                  else
                     Put (" *" & I2S (cell));
                  end if;
               else
                  if cell >= 10 then
                     Put (" " & I2S (cell));
                  else
                     Put (" " & I2S (cell) & " ");
                  end if;
               end if;
            end if;
         end loop;
         if y < 15 or y > 19 then
            Put("|");
         end if;
         Put_Line("");
      end loop;
      for i in  1 .. field_max_x loop
         Put("---");
      end loop;
      Put_Line("");
   end Print_Field;

   task body Field_Printer is
   begin
      loop
         Print_Field;
         delay duration (print_delay);
      end loop;
   end Field_Printer;

   function Get_Ball_Holder return Integer is
   begin
      return ball_holder_id;
   end Get_Ball_Holder;

   function Get_Zone (coord : Coordinate) return Integer is
   begin
      if Compare_Coordinates (coord, oblivium) then
	 return 0;
      end if;

      return (Integer (Float'Floor (Float (coord.coord_x - 1) / (Float (field_max_x) / Float (number_of_zones)))) + 1);
   end Get_Zone;

   procedure Release (coord : Coordinate) is
   begin
--        released (Get_Zone (coord)) := True;
      null;
   end Release;

   function Occupy (coord : Coordinate) return Field_Zones is
--        Zone : Field_Zones;
   begin
--        Zone := Field_Zones (Get_Zone (coord => coord));
--        released (Integer (Zone)) := False;
--        return Zone;
      return 0;
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

   type Rand_Range is range -5 .. 5;
   package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);

   type Binary_Range is range 0 .. 1;
   package Rand_Bin is new Ada.Numerics.Discrete_Random(Binary_Range);


   procedure Calculate_Tackle (attacker_id : in Integer; ball_owner_id : in Integer; with_foul : out Boolean; success : out Boolean) is
      tackle_seed       : Rand_Int.Generator;
      attacker_defense  : Integer;
      attacker_tackle   : Integer;
      ball_owner_attack : Integer;
      ball_owner_speed  : Integer;
      first_parameter   : Integer;
      second_parameter  : Integer;
      outcome           : Integer;
      foul_outcome      : Integer;
   begin
      attacker_defense  := Get_Defense(Get_Number_From_Id(attacker_id), Get_Player_Team_From_Id(attacker_id));
      attacker_tackle   := Get_Tackle(Get_Number_From_Id(attacker_id), Get_Player_Team_From_Id(attacker_id));
      ball_owner_attack := Get_Attack(Get_Number_From_Id(ball_owner_id), Get_Player_Team_From_Id(ball_owner_id));
      ball_owner_speed  := Get_Speed(Get_Number_From_Id(ball_owner_id), Get_Player_Team_From_Id(ball_owner_id));

      first_parameter := ball_owner_attack - attacker_defense;
      if first_parameter <= -10 then
         first_parameter := -10;
      elsif first_parameter >= 10 then
         first_parameter := 10;
      end if;

      second_parameter := ball_owner_speed - attacker_tackle;
      if second_parameter <= -10 then
         second_parameter := -10;
      elsif second_parameter >= 10 then
         second_parameter := 10;
      end if;

      Rand_Int.Reset(tackle_seed);
      outcome := first_parameter + second_parameter + Integer(Rand_Int.Random(tackle_seed));
      if outcome > 0 then
         success := False;
      elsif outcome < 0 then
         success := True;
      else
         declare
            new_outcome : Integer;
            binary_seed : Rand_Bin.Generator;
         begin
            Rand_Bin.Reset(binary_seed);
            new_outcome := Integer(Rand_Bin.Random(binary_seed));
            if new_outcome = 0 then
               success := False;
            else
               success := True;
            end if;
         end;
      end if;

      Rand_Int.Reset(tackle_seed);
      foul_outcome := Integer(Rand_Int.Random(tackle_seed));
      if foul_outcome = 1 or foul_outcome = 5 or foul_outcome = 10 then
	 with_foul := True;
      else
	 with_foul := False;
      end if;

--        with_foul := True;

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
	 Print ("[COMPUTE] Il giocatore " & I2S (action.Get_Player_Id)
	    & " si e' spostato sulla cella " & Print_Coord (action.Get_To));
         current_status (action.Get_Player_Id).coord := action.Get_To;
         if ball_holder_id = action.Get_Player_Id then
            Ball.Move_Player(new_coord => action.Get_To);
         end if;
         Buffer_Wrapper.Put(new_event => Core_Event.Event_Ptr (action));

--  	 Print ("[COMPUTE] Il giocatore " & I2S (action.Get_Player_Id) & " sta per rilasciare la zona con coordinata " & Print_Coord (action.Get_From));
--  	 Print ("Zona di rilascio: " & I2S (Get_Zone (action.Get_From)));
--  	 Print ("Before release");
--  	 Print_Zones;
--  	 Release (action.Get_From);
--  	 Print ("After release");
--  	 Print_Zones;
         success := True;
      else
	 Print ("[COMPUTE] Il giocatore " & I2S (action.Get_Player_Id)
	    & " ha fallito lo spostamento (c'e' " & I2S (here_player_result)
	    & ") verso la cella " & Print_Coord (action.Get_To));
         success := False;
      end if;

--        Print_Status;

   end Compute;

   procedure Print_Status is
   begin
      for i in current_status'Range loop
	 Print (I2S(current_status (i).id) & ": [" & Print_Coord (current_status (i).coord) & "]");
	 null;
      end loop;
   end Print_Status;

   procedure Print_Zones is
   begin
--        for i in released'Range loop
--  	 Print ("Zone " & I2S (i) & " has value: " & Boolean'Image (released (i)));
--  	 null;
--        end loop;
      null;
   end Print_Zones;

   procedure Compute (action : in Shot_Event_Ptr; success : out Boolean) is
   begin
      Print ("[CONTROLLER] Shot_Event per Giocatore " & I2S (Get_Player_Id (action.all)));
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
      Print ("[CONTROLLER] Tackle_Event per Giocatore " & I2S (Get_Player_Id (action.all)));
      if Compare_Coordinates (coord1 => action.Get_To,
			      coord2 => current_status(action.Get_Other_Player_Id).coord) and
	ball_holder_id = action.Get_Other_Player_Id then
	    -- Tento di rubargli la palla!
	    Calculate_Tackle(attacker_id   => action.Get_Player_Id,
		      ball_owner_id => action.Get_Other_Player_Id,
		      with_foul => with_foul,
		      success => tackle_success);

         if tackle_success then
            -- Notifico l'arbitro se c'e' stato un contrasto con fallo
            declare
               foul_event : Binary_Event_Ptr := new Binary_Event;
            begin
               success := True;
               if with_foul then
                  Print ("[CONTROLLER] Giocatore " & I2S (action.Get_Player_Id) & " ha commesso un fallo su Giocatore " & I2S (action.Get_Other_Player_Id));
                  foul_event.Initialize(new_event_id    => Foul,
                                        new_player_1_id => action.Get_Player_Id,
                                        new_player_2_id => action.Get_Other_Player_Id,
					new_event_coord => action.Get_To);

		  ball_holder_id := 0;

		  Referee.Notify_Game_Event(event => Game_Event_Ptr (foul_event));
               else
                  -- hell yeah! Mi prendo la palla
                  Print ("[CONTROLLER] Giocatore " & I2S (action.Get_Player_Id) & " ha preso la palla");
                  ball.Move_Player(new_coord => action.Get_From);
                  ball_holder_id := action.Get_Player_Id;
                  Set_Last_Ball_Holder (holder => ball_holder_id);
               end if;
            end;
         else
            -- oh no :-(
            success := False;
         end if;
      else
	 declare
	    foul_event : Binary_Event_Ptr := new Binary_Event;
	 begin
	    Print ("[CONTROLLER] Giocatore " & I2S (action.Get_Player_Id) & " ha commesso un fallo su Giocatore " & I2S (action.Get_Other_Player_Id));
	    foul_event.Initialize(new_event_id    => Foul,
			   new_player_1_id => action.Get_Player_Id,
			   new_player_2_id => action.Get_Other_Player_Id,
			   new_event_coord => action.Get_To);

	    ball_holder_id := 0;

	    Referee.Notify_Game_Event(event => Game_Event_Ptr (foul_event));
	 end;
      end if;
   end Compute;

   procedure Compute (action : in Catch_Event_Ptr; success : out Boolean) is
   begin
      Print ("[CONTROLLER] Catch_Event per Giocatore " & I2S (Get_Player_Id (action.all)));
      Ball.Catch (catch_coord => action.Get_To,
                  player_coord => action.Get_From,
                  succeded     => success);
      if success then
         Print ("[CONTROLLER] Giocatore " & I2S (action.Get_Player_Id) & " ha preso la palla!");
         Motion_Enabler.Stop;
	 ball_holder_id := action.Get_Player_Id;
	 Set_Last_Ball_Holder (ball_holder_id);
      else
	 Print ("[CONTROLLER] Catch fallita");
	 null;
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

   protected body Guard is
      entry Update (zone : Field_Zones; occupy : Boolean) when True is
      begin
	 if occupy then
	    released (Integer (zone)) := True;
	 else
	    released (Integer (zone)) := False;
	 end if;
      end Update;

      entry Wait (for zone in Field_Zones) (current_action : in out Action) when not released (Integer (zone)) is
      begin
--  	 current_action.utility := current_action.utility - 1;
	 requeue Controller.Write;
      end Wait;

   end Guard;

   task body Controller is
      utility_constraint : Utility_Constraint_Type := 6;
      compute_result : Boolean;
      revaluate : Boolean;

      initial_match_event : Match_Event_Ptr;

      init_players_count : Integer;
      team_one_players_count : Integer;
      team_two_players_count : Integer;
      initialized : Boolean;

      first_time : Boolean := True;

   begin
--        Initialize;
--        Timer_Control.Start;

      init_players_count := 1;
      team_one_players_count := 1;
      team_two_players_count := 1;
      initialized := False;

      -- imposto l'evento d'inizio gioco
      initial_match_event := new Match_Event;
      initial_match_event.Initialize (Begin_Of_Match,
				      Get_Nearest_Player (Ball.Get_Position, Team_One));

      last_game_event := Game_Event_Ptr (initial_match_event);
      game_status := Game_Paused;

      -- metto la palla al centro del campo (circa)
      ball_holder_id := 0;

      Ball.Set_Controlled (False);
      Ball.Set_Position (middle_field_coord);

      loop
	 -- aggiungere controllo su flag del gioco (per pausa, fine_gioco, ecc)
	 select
	    accept Write (current_action : in out Action) do

	       -- simulating corner kick
	       if first_time then
		  if current_action.event.Get_Player_Id = 2
		    and current_action.event.all in Shot_Event'Class then
		     declare
			new_shot_event : Shot_Event_Ptr := new Shot_Event;
		     begin
			first_time := False;

			new_shot_event.Initialize(2,
			 current_status (2).coord,
			 Coordinate' (0,13));

			new_shot_event.Set_Shot_Power(15);

			current_action.event := Motion_Event_Ptr (new_shot_event);
			current_action.utility := 10;
		     end;
		  end if;
	       end if;

	       -- provo a soddisfare la richiesta del giocatore
	       Compute (current_action.event, compute_result, revaluate);

	       if compute_result then
		  if Compare_Coordinates (current_action.event.Get_From, oblivium) or current_action.event.Get_From.coord_y /= 0 then
		     Print ("[CONTROLLER] Giocatore " & I2S(current_action.event.Get_Player_Id) &
			 " rilascia la zona " & I2S (Integer (Get_Zone (current_action.event.Get_From))));
		     Guard.Update (Field_Zones (Get_Zone (current_action.event.Get_From)), False);
		  end if;

		  if current_action.event.all not in Move_Event'Class then
		     last_player_event := current_action.event;
		  end if;
	       end if;

	       if not compute_result and revaluate then
		  -- Devo distinguere tra i tipi di mosse
                  if current_action.utility > utility_constraint or current_action.event.Get_To = oblivium then
                     Print ("[CONTROLLER] Giocatore " & I2S(current_action.event.Get_Player_Id) & " riaccodato sulla zona " & I2S (Get_Zone (current_action.event.Get_To)));
                     if current_action.utility > 1 then
                        current_action.utility := current_action.utility - 1;
                     end if;
		     Guard.Update (Field_Zones (Get_Zone (current_action.event.Get_To)), True);
		     requeue Guard.Wait (Field_Zones (Get_Zone (current_action.event.Get_To)));
                  else
		     Print ("[CONTROLLER] Mossa da rivedere");
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
			Print ("[CONTROLLER] Mossa per il Giocatore " & I2S(current_action.event.Get_Player_Id)
			  & " rivalutata alla cella " & Print_Coord (alternative));

			Compute (new_move, compute_result, revaluate);

			Guard.Update (Field_Zones (Get_Zone (from)), False);

			Referee.Pre_Check (last_player_event);
			Referee.Post_Check;
		     end;
		  end if;
	       else
		  Referee.Pre_Check (last_player_event);
		  Referee.Post_Check;
	       end if;

	    end Write;
--  	 or
--  	    when released (Integer (Zone)) = True =>
--  	       accept Awaiting (Zone) (current_action : in out Action) do
--  		  Print ("[CONTROLLER] Giocatore " & I2S(current_action.event.Get_Player_Id) & " pescato dalla coda"));
--
--  		  Compute(current_action.event, compute_result, revaluate);
--  		  if compute_result then
--  		     last_player_event := current_action.event;
--  		  end if;
--
--  		  if not compute_result and revaluate then
--  		     Print ("[CONTROLLER] Giocatore " & I2S(current_action.event.Get_Player_Id)
--  		       & " bloccato dal giocatore " & I2S(Check_For_Player_In_Cell(x => current_action.event.Get_To.coord_x, y => current_action.event.Get_To.coord_y))
--  		       & " alle coordinate " & I2S(current_action.event.Get_To.coord_x) & " " & I2S(current_action.event.Get_To.coord_y)));
--  		     if(current_action.utility > utility_constraint or current_action.event.Get_To = oblivium) then
--  			current_action.utility := current_action.utility - 1;
--  			requeue Awaiting (Occupy (current_action.event.Get_To));
--  		     else
--  			Print ("[CONTROLLER] Mossa da rivedere (in riaccodamento)"));
--  			declare
--  			   old_move : Motion_Event_Ptr := current_action.event;
--  			   new_move : Motion_Event_Ptr := new Move_Event;
--  			   id : Integer := Get_Player_Id (old_move.all);
--  			   from : Coordinate := Get_From (old_move.all);
--  			   to : Coordinate := Get_to (old_move.all);
--  			   alternative : Coordinate := Get_Alternative_Coord (from, to);
--  			begin
--  			   revaluate := False;
--  			   new_move.Initialize (id, from, alternative);
--  			   Print ("[CONTROLLER] Mossa per il Giocatore " & I2S(current_action.event.Get_Player_Id)
--  			     & " rivalutata alla cella " & Print_Coord (alternative)));
--  			   Compute (new_move, compute_result, revaluate);
--  			end;
--  		     end if;
--  		  else
--  		     Referee.Pre_Check (last_player_event);
--  		     Referee.Post_Check;
--  		     null;
--  		  end if;
--  	       end Awaiting;
	 or
	    accept Get_Id (id : out Integer) do
	       declare
		  team_one_ptr : Team_Ptr := Get_Team (Team_One);
		  team_two_ptr : Team_Ptr := Get_Team (Team_Two);
		  result : Integer := 0;
	       begin
		  -- Print ("[CONTROLLER] Get_Id");

		  if not initialized then
--                       Print ("[CONTROLLER] Initializing status");
		     Initialize;
		     initialized := True;
		  end if;

--  		  Print ("[CONTROLLER] Length is " & I2S (team_one_ptr.players'Length));

		  if team_one_players_count <= num_of_players/2 then
                     result := current_status(team_one_players_count).id;
                     current_status(result).on_the_field := True;
--                       Print ("[CONTROLLER] Team 1 - ID " & I2S (result) & " - NUMBER "
--                                     & I2S(current_status(result).number));

		     team_one_players_count := team_one_players_count + 1;
--                       Print ("[CONTROLLER] New count " & I2S (team_one_players_count));
                  else
		     if team_two_players_count <= num_of_players/2 then
			result := current_status(team_one_players_count + team_two_players_count).id;
                        current_status(result).on_the_field := True;
--                          Print ("[CONTROLLER] Team 2 - ID " & I2S (result) & " - NUMBER "
--                                     & I2S(current_status(result).number));

			team_two_players_count := team_two_players_count + 1;
--                          Print ("[CONTROLLER] New count " & I2S (team_one_players_count));
		     end if;
		  end if;

		  init_players_count := init_players_count + 1;
		  id := result;
		  -- Print ("[CONTROLLER] Id = " & I2S (id));
		  -- Print ("[CONTROLLER] Fine Get_Id");
	       end;
	    end Get_Id;
	 end select;
      end loop;

   end Controller;

end Soccer.ControllerPkg;
