package Soccer is

   -- Global stuff for the Soccer packages

   function I2S (Num: in Integer) return String;

   Field_Max_X : Positive := 30;
   Field_Max_Y : Positive := 20;

   Buffer_Dim : Positive := 10;

   Nearby_Distance : Integer := 3;

   Send_Buffer_Delay : Integer := 1;

   type Power_Range is range 0 .. 10;

   --+ Utility di una mossa x/10
   subtype Utility_Range is Integer range 1 .. 10;
   subtype Utility_Constraint is Utility_Range;
   mUtilityConstraint : Utility_Constraint := 2;

   Num_Of_Player : Positive := 7;

   agent_movement_id : Integer := 0;

   type Formation_Scheme is (O_352, B_442, D_532);

   -- Includo la coordinata 0,0 per simulare la panchina
   type Coordinate is
      record
         coordX   : Integer range 0 .. Field_Max_X;
         coordY   : Integer range 0 .. Field_Max_Y;
      end record;
   type Coordinate_Ptr is access Coordinate;

end Soccer;
