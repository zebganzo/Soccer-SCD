with Soccer.Utils;
with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;
use Ada.Text_IO;

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
      dx := float(From.coordX - To.coordX);
      dy := float(From.coordY - To.coordY);
      return Integer(Sqrt( dx*dx + dy*dy ));
   end Distance;

   function Get_Next_Coordinate (myCoord : Coordinate; targetCoord : Coordinate) return Coordinate is
      myX : Integer := myCoord.coordX;
      myY : Integer := myCoord.coordY;
      tarX : Integer := targetCoord.coordX;
      tarY : Integer := targetCoord.coordY;
   begin
      if (myX = tarX and myY = tarY) then return myCoord;    -- sovrapposti
      elsif (myX < tarX and myY < tarY) then return Coordinate'(coordX => myX+1,
                                                                coordY => myY+1); -- alto destra
      elsif (myX < tarX and myY = tarY) then return Coordinate'(coordX => myX+1,
                                                                coordY => myY); -- destra
      elsif (myX < tarX and myY > tarY) then return Coordinate'(coordX => myX+1,
                                                                coordY => myY-1); -- basso destra
      elsif (myX = tarX and myY > tarY) then return Coordinate'(coordX => myX,
                                                                coordY => myY-1); -- basso
      elsif (myX > tarX and myY > tarY) then return Coordinate'(coordX => myX-1,
                                                                coordY => myY-1); -- basso sinistra
      elsif (myX > tarX and myY = tarY) then return Coordinate'(coordX => myX-1,
                                                                coordY => myY); -- sinistra
      elsif (myX > tarX and myY < tarY) then return Coordinate'(coordX => myX-1,
                                                                coordY => myY+1); -- alto sinistra
      else return Coordinate'(coordX => myX,
                              coordY => myY+1); -- sopra (myX = tarX and myY < tarY)
      end if;
   end Get_Next_Coordinate;

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
         target := Coordinate'(coordX => coord.coordX+1, coordY => coord.coordY+1); -- alto destra
      elsif random_value = 2  then
         target := Coordinate'(coordX => coord.coordX+1, coordY => coord.coordY); -- destra
      elsif random_value = 3 then
         target := Coordinate'(coordX => coord.coordX+1, coordY => coord.coordY-1); -- basso destra
      elsif random_value = 4 then
         target := Coordinate'(coordX => coord.coordX, coordY => coord.coordY-1); -- basso
      elsif random_value = 5 then
         target := Coordinate'(coordX => coord.coordX-1, coordY => coord.coordY-1); -- basso sinistra
      elsif random_value = 6 then
         target := Coordinate'(coordX => coord.coordX-1, coordY => coord.coordY); -- sinistra
      elsif random_value = 7 then
         target := Coordinate'(coordX => coord.coordX-1, coordY => coord.coordY+1); -- alto sinistra
      else
         target := Coordinate'(coordX => coord.coordX, coordY => coord.coordY+1); -- alto
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
      if coord.coordX > Field_Max_X or coord.coordX < 1 or
        coord.coordY > Field_Max_Y or coord.coordY < 1 then
         Put_Line("Ma sei fuori?! " & I2S(coord.coordX) & " " & I2S(coord.coordY));
         return False;
      else
         return True;
      end if;
   end Check_Inside_Field;

end Soccer.Utils;
