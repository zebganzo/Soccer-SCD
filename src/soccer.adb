with Soccer;

package body Soccer is
   -- Integer'Image ...TRICK!
   function I2S (Num              : in Integer) return String is
   begin
      return Integer'Image(Num);
   end I2S;
end Soccer;
