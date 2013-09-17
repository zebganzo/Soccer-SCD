with Soccer;

package body Soccer is

   -- Integer'Image ...TRICK!
   function I2S (Num : in Integer) return String is
      image : constant String := Integer'Image(Num);
   begin
      return image (2 .. image'Last);
   end I2S;

   function Serialize_Coordinate (coord : in Coordinate) return Unbounded_String is
      result : Unbounded_String;
   begin
      result := To_Unbounded_String("(" & I2S (coord.coord_x) & "," & I2S (coord.coord_y) & ")");
      return result;
   end Serialize_Coordinate;

   procedure Set_Coord_X (coord : in out Coordinate; value : in Integer) is
   begin
      coord.coord_x := value;
   end Set_Coord_X;

   procedure Set_Coord_Y (coord : in out Coordinate; value : in Integer) is
   begin
      coord.coord_y := value;
   end Set_Coord_Y;

end Soccer;
