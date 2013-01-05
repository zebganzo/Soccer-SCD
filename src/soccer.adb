with Soccer;

package body Soccer is
   -- Integer'Image ...TRICK!
   function I2S (Num              : in Integer) return String is
      image : constant String := Integer'Image(Num);
   begin
      return image (2 .. image'Last);
   end I2S;
end Soccer;
