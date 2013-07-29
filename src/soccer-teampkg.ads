package Soccer.TeamPkg is

   type Team_Players_List is array (Positive range <>) of Positive;

   type Team_Id is (Team_One, Team_Two);

   type Team is
      record
	 id : Team_Id;
	 players : Team_Players_List (1 .. 4);
	 formation : Formation_Scheme_Id;
      end record;
   type Team_Ptr is access Team;

   function Get_Team_From_Id (id : Positive) return Team_Id;

   procedure Set_Teams (first_team : Team_Ptr; second_team : Team_Ptr);

   function Get_Team (team : Team_Id) return Team_Ptr;

   procedure Set_Formation (team : in Team_Ptr; formation : in Formation_Scheme_Id);

   function To_String (team : in Team_Id) return String;

   function Get_Position_For_Player (team : in Team_Id; id : in Integer) return Coordinate;

private
   team_1 : Team_Ptr;
   team_2 : Team_Ptr;

   team_one_offensive_positions : Positions_Array;
   team_one_balanced_positions : Positions_Array;
   team_one_defensive_positions : Positions_Array;

   team_one_offensive_formation : Formation_Scheme := Formation_Scheme'(id        => O_352,
							       positions => team_one_offensive_positions);
   team_one_balanced_formation : Formation_Scheme := Formation_Scheme'(id        => B_442,
							       positions => team_one_balanced_positions);
   team_one_defensive_formation : Formation_Scheme := Formation_Scheme'(id        => D_532,
							       positions => team_one_defensive_positions);

end Soccer.TeamPkg;
