with Soccer.Utils;
with Ada.Numerics.Generic_Elementary_Functions;

package body Soccer.Utils is

   package Value_Functions is new Ada.Numerics.Generic_Elementary_Functions (Float);
   use Value_Functions;

   --+ Distanza tra due punti
   function distance(x1 : in Integer; x2 : in Integer; y1 : in Integer; y2 : in Integer) return Integer is
      dx, dy : float;
   begin
      dx := float(x1 - x2);
      dy := float(y1 - y2);
      return Integer(Sqrt( dx*dx + dy*dy ));
   end distance;

   function getNextCoordinate (myCoord : Coordinate; targetCoord : Coordinate_Ptr) return Coordinate is
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
   end getNextCoordinate;

end Soccer.Utils;
