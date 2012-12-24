package Soccer is

   -- Global stuff for the Soccer packages

   function I2S (Num: in Integer) return String;

   Field_Max_X : Positive := 15;
   Field_Max_Y : Positive := 10;

   type rangePower is range 1 .. 10;

   --+ Utility di una mossa x/10
   subtype utilityRange is Integer range 1 .. 10;
   subtype utilityConstraint is utilityRange;

   Num_Of_Player : Positive := 6;

   agent_movement_id : Integer := 0;

   type Formation_Scheme is (O_352, B_442, D_532);

   type Coordinate is
      record
         coordX   : Integer range 0 .. Field_Max_X;
         coordY   : Integer range 0 .. Field_Max_Y;
      end record;
   type Coordinate_Ptr is access Coordinate;

end Soccer;
