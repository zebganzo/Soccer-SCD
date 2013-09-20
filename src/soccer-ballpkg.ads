package Soccer.BallPkg is

   protected Ball is

      procedure Print (input : String);

      function Get_Position return Coordinate;
      function Get_Controlled return Boolean;
      function Get_Moving return Boolean;

      procedure Set_Controlled (new_status : Boolean);
      procedure Set_Moving (new_status : Boolean);

      procedure Catch (catch_coord : Coordinate; player_coord : Coordinate; succeded : out Boolean);
      procedure Move_Player (new_coord : Coordinate);
      entry Move_Agent (new_coord : Coordinate);

      procedure Set_Position (new_position : in Coordinate);

      procedure Release;

   private
      --+-------------
      debug : Boolean := False;
      --+-------------
      current_position : Coordinate;
      controlled : Boolean := False;
      moving : Boolean := False;

   end Ball;

end Soccer.BallPkg;
