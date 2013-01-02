package Soccer.BallPkg is

   protected Ball is

      function Get_Position return Coordinate;
      function Get_Controlled return Boolean;
      function Get_Moving return Boolean;

      procedure Set_Controlled (new_status : Boolean);
      procedure Set_Moving (new_status : Boolean);

      procedure Catch (player_coord : in Coordinate; succeed : out Boolean);
      procedure Move_Player (new_coord : Coordinate);
      entry Move_Agent (new_coord : Coordinate);

      procedure Release;

      private
      mCoord : Coordinate := Coordinate'(coordX => Field_Max_X / 2,
                                         coordY => Field_Max_Y / 2);
      controlled : Boolean := False;
      moving : Boolean := False;
   end Ball;

end Soccer.BallPkg;
