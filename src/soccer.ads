package Soccer is

   -- Integer'Image ...TRICK!
   function I2S (Num: in Integer) return String;

   fieldMaxX : Integer := 15;
   fieldMaxY : Integer := 10;

   type Coordinate is
      record
         coordX   : Integer range 1 .. fieldMaxX;
         coordY   : Integer range 1 .. fieldMaxY;
      end record;

end Soccer;
