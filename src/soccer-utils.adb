with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;
use Ada.Text_IO;
with Soccer.Core_Event.Game_Core_Event.Match_Game_Event; use Soccer.Core_Event.Game_Core_Event.Match_Game_Event;

package body Soccer.Utils is

   package Value_Functions is new Ada.Numerics.Generic_Elementary_Functions (Float);
   use Value_Functions;

   --+ Distanza tra due punti
   function Distance(x1 : in Integer; x2 : in Integer; y1 : in Integer; y2 : in Integer) return Integer is
      dx, dy : float;
   begin
      dx := float(x1 - x2);
      dy := float(y1 - y2);
      return Integer(Sqrt( dx*dx + dy*dy ));
   end Distance;

   function Distance(From : in Coordinate; To : in Coordinate) return Integer is
      dx, dy : float;
   begin
      dx := float(From.coord_x - To.coord_x);
      dy := float(From.coord_y - To.coord_y);
      return Integer(Sqrt( dx*dx + dy*dy ));
   end Distance;

   function NEW_Get_Next_Coordinate (start_coord : Coordinate; target_coord : Coordinate) return Coordinate is
      delta_x : Integer;
      delta_y : Integer;
      reminder : Integer;
      result : Coordinate;
   begin
      delta_x := target_coord.coord_x - start_coord.coord_x;
      delta_y := target_coord.coord_y - start_coord.coord_y;

      if abs (delta_x) > abs (delta_y) then
	 if delta_y = 0 then
	    reminder := 42;
	 else
	    reminder := delta_x rem delta_y;
	 end if;

	 if reminder = 0 then
	    if delta_x > 0 and delta_y > 0 then
	       result.coord_x := start_coord.coord_x + 1;
	       result.coord_y := start_coord.coord_y + 1;
	    elsif delta_x > 0 and delta_y < 0 then
	       result.coord_x := start_coord.coord_x + 1;
	       result.coord_y := start_coord.coord_y - 1;
	    elsif delta_x < 0 and delta_y > 0 then
	       result.coord_x := start_coord.coord_x - 1;
	       result.coord_y := start_coord.coord_y + 1;
	    else
	       result.coord_x := start_coord.coord_x - 1;
	       result.coord_y := start_coord.coord_y - 1;
	    end if;
	 else
	    if delta_x > 0 then
	       result.coord_x := start_coord.coord_x + 1;
	    else
	       result.coord_x := start_coord.coord_x - 1;
	    end if;

	    result.coord_y := start_coord.coord_y;

	 end if;
      elsif abs (delta_x) < abs (delta_y) then
	 if delta_x = 0 then
	    reminder := 42;
	 else
	    reminder := delta_y rem delta_x;
	 end if;

	 if reminder = 0 then
	    if delta_x > 0 and delta_y > 0 then
	       result.coord_x := start_coord.coord_x + 1;
	       result.coord_y := start_coord.coord_y + 1;
	    elsif delta_x > 0 and delta_y < 0 then
	       result.coord_x := start_coord.coord_x + 1;
	       result.coord_y := start_coord.coord_y - 1;
	    elsif delta_x < 0 and delta_y > 0 then
	       result.coord_x := start_coord.coord_x - 1;
	       result.coord_y := start_coord.coord_y + 1;
	    else
	       result.coord_x := start_coord.coord_x - 1;
	       result.coord_y := start_coord.coord_y - 1;
	    end if;
	 else
	    if delta_y > 0 then
	       result.coord_y := start_coord.coord_y + 1;
	    else
	       result.coord_y := start_coord.coord_y - 1;
	    end if;

	    result.coord_x := start_coord.coord_x;

	 end if;
      else
	 if delta_x > 0 and delta_y > 0 then
	    result.coord_x := start_coord.coord_x + 1;
	    result.coord_y := start_coord.coord_y + 1;
	 elsif delta_x > 0 and delta_y < 0 then
	    result.coord_x := start_coord.coord_x + 1;
	    result.coord_y := start_coord.coord_y - 1;
	 elsif delta_x < 0 and delta_y > 0 then
	    result.coord_x := start_coord.coord_x - 1;
	    result.coord_y := start_coord.coord_y + 1;
	 else
	    result.coord_x := start_coord.coord_x - 1;
	    result.coord_y := start_coord.coord_y - 1;
	 end if;
      end if;

      return result;
   end NEW_Get_Next_Coordinate;

   function Get_Next_Coordinate (myCoord : Coordinate; targetCoord : Coordinate) return Coordinate is
      myX : Integer := myCoord.coord_x;
      myY : Integer := myCoord.coord_y;
      tarX : Integer := targetCoord.coord_x;
      tarY : Integer := targetCoord.coord_y;
      next_to_oblivium : Coordinate;
   begin

--        if targetCoord = oblivium then
--  	 if myX = 1 and myY = 1 then
--  	    return oblivium;
--  	 end if;
--
--  	 if myX = 1 then
--  	    return Coordinate'(1, myY -1);
--  	 end if;
--
--  	 if myY = 1 then
--  	    return Coordinate'(myX - 1, 1);
--  	 end if;
--        end if;


      if targetCoord = oblivium then
	 next_to_oblivium := oblivium;
	 next_to_oblivium.coord_y := 1;

	 if myCoord = next_to_oblivium then
	    return oblivium;
	 end if;

	 return Get_Next_Coordinate (myCoord, next_to_oblivium);
      end if;

      if (myX = tarX and myY = tarY) then return myCoord;    -- sovrapposti
      elsif (myX < tarX and myY < tarY) then return Coordinate'(coord_x => myX+1,
                                                                coord_y => myY+1); -- alto destra
      elsif (myX < tarX and myY = tarY) then return Coordinate'(coord_x => myX+1,
                                                                coord_y => myY); -- destra
      elsif (myX < tarX and myY > tarY) then return Coordinate'(coord_x => myX+1,
                                                                coord_y => myY-1); -- basso destra
      elsif (myX = tarX and myY > tarY) then return Coordinate'(coord_x => myX,
                                                                coord_y => myY-1); -- basso
      elsif (myX > tarX and myY > tarY) then return Coordinate'(coord_x => myX-1,
                                                                coord_y => myY-1); -- basso sinistra
      elsif (myX > tarX and myY = tarY) then return Coordinate'(coord_x => myX-1,
                                                                coord_y => myY); -- sinistra
      elsif (myX > tarX and myY < tarY) then return Coordinate'(coord_x => myX-1,
                                                                coord_y => myY+1); -- alto sinistra
      else return Coordinate'(coord_x => myX,
                              coord_y => myY+1); -- sopra (myX = tarX and myY < tarY)
      end if;
   end Get_Next_Coordinate;

   function Back_Off (current_coord : Coordinate; reference_coord : Coordinate; event_coord : Coordinate) return Coordinate is
      delta_x : Positive;
      delta_y : Positive;
      new_x : Integer;
      new_y : Integer;
      result : Coordinate;
   begin
      if Distance (reference_coord, event_coord) < free_kick_area then
	 delta_x := abs (reference_coord.coord_x - event_coord.coord_x);
	 delta_y := abs (reference_coord.coord_y - event_coord.coord_y);

	 if event_coord.coord_x > reference_coord.coord_x then
	    new_x := reference_coord.coord_x + delta_x;
	 else
	    new_x := reference_coord.coord_x - delta_x;
	 end if;

	 if event_coord.coord_y > reference_coord.coord_y then
	    new_y := reference_coord.coord_y + delta_y;
	 else
	    new_y := reference_coord.coord_y - delta_y;
	 end if;

	 result := Coordinate'(new_x, new_y);
	 return result;
      else
	 return reference_coord;
      end if;
   end Back_Off;

   function Get_Ball_Delay (power : Power_Range) return duration is
   begin
      return duration(Power_Range'Last - power);
   end Get_Ball_Delay;

   function Compare_Coordinates (coord1 : Coordinate; coord2 : Coordinate) return Boolean is
   begin
      if Distance(coord1, coord2) = 0 then
         return True;
      else
         return False;
      end if;
   end Compare_Coordinates;

   type Rand_Range is range 1 .. 8;
   package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);

   function Get_Random_Target (coord : Coordinate) return Coordinate is
      seed : Rand_Int.Generator;
      random_value : Integer;
      target : Coordinate;
   begin
      Rand_Int.Reset(seed);
      random_value := Integer(Rand_Int.Random(seed));
      if random_value = 1 then
         target := Coordinate'(coord_x => coord.coord_x+1, coord_y => coord.coord_y+1); -- alto destra
      elsif random_value = 2  then
         target := Coordinate'(coord_x => coord.coord_x+1, coord_y => coord.coord_y); -- destra
      elsif random_value = 3 then
         target := Coordinate'(coord_x => coord.coord_x+1, coord_y => coord.coord_y-1); -- basso destra
      elsif random_value = 4 then
         target := Coordinate'(coord_x => coord.coord_x, coord_y => coord.coord_y-1); -- basso
      elsif random_value = 5 then
         target := Coordinate'(coord_x => coord.coord_x-1, coord_y => coord.coord_y-1); -- basso sinistra
      elsif random_value = 6 then
         target := Coordinate'(coord_x => coord.coord_x-1, coord_y => coord.coord_y); -- sinistra
      elsif random_value = 7 then
         target := Coordinate'(coord_x => coord.coord_x-1, coord_y => coord.coord_y+1); -- alto sinistra
      else
         target := Coordinate'(coord_x => coord.coord_x, coord_y => coord.coord_y+1); -- alto
      end if;
      if not Check_Inside_Field(coord => target) then
         return Get_Random_Target(coord => coord);
      end if;
      return target;
   end Get_Random_Target;

   procedure CLS is
   begin
      Ada.Text_IO.Put(ASCII.ESC & "[2J");
   end CLS;

   function Check_Inside_Field (coord: Coordinate) return Boolean is
   begin
      if coord.coord_x > field_max_x or coord.coord_x < 1 or
        coord.coord_y > field_max_y or coord.coord_y < 1 then
         Put_Line("Ma sei fuori?! " & I2S(coord.coord_x) & " " & I2S(coord.coord_y));
         return False;
      else
         return True;
      end if;
   end Check_Inside_Field;

   function Is_In_Penalty_Area (team : Team_Id; coord : Coordinate) return Boolean is
   begin

      if team = Team_One then
	 if coord.coord_x >= team_one_penalty_lower_left_coord.coord_x
	   and coord.coord_x <= team_one_penalty_lower_right_coord.coord_x
	   and coord.coord_y >= team_one_penalty_lower_left_coord.coord_y
	   and coord.coord_y <= team_one_penalty_upper_left_coord.coord_y then
	    return true;
	 end if;
      else
	 if coord.coord_x >= team_two_penalty_lower_left_coord.coord_x
	   and coord.coord_x <= team_two_penalty_lower_right_coord.coord_x
	   and coord.coord_y >= team_two_penalty_lower_left_coord.coord_y
	   and coord.coord_y <= team_two_penalty_upper_left_coord.coord_y then
	    return true;
	 end if;
      end if;

      return false;
   end Is_In_Penalty_Area;

   function Print_Coord (coord : Coordinate) return String is
   begin
      return "(" & I2S (coord.coord_x) & "," & I2S (coord.coord_y) & ")";
   end Print_Coord;

   function Is_Match_Event (event : Game_Event_Ptr) return Boolean is
   begin
      if event.all in Match_Event'Class then
	 return True;
      end if;

      return False;
   end Is_Match_Event;


--     function Get_Nearest_Player (point_coord : Coordinate; team : Team_Id) return Integer is
--        current_status : Status := Get_Players_Status;
--        nearest_player : Integer := -1;
--        shortest_distance : Integer := 100;
--     begin
--        for i in current_status'Range loop
--  	 if current_status (i).team = team then
--  	    if Distance (current_status (i).coord, point_coord) < shortest_distance then
--  	       shortest_distance := Distance (current_status (i).coord, point_coord);
--  	       nearest_player := i;
--  	    end if;
--  	 end if;
--        end loop;
--     end Get_Nearest_Player;

end Soccer.Utils;
