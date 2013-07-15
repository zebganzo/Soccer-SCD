with Soccer;

package body Soccer is

   -- Integer'Image ...TRICK!
   function I2S (Num              : in Integer) return String is
      image : constant String := Integer'Image(Num);
   begin
      return image (2 .. image'Last);
   end I2S;

   function Serialize_Coordinate (coord : in Coordinate) return Unbounded_String is
      result : Unbounded_String;
   begin
      result := To_Unbounded_String("(" & I2S (coord.coordX) & "," & I2S (coord.coordY) & ")");
      return result;
   end Serialize_Coordinate;

end Soccer;
