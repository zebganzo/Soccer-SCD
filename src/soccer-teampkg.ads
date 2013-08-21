package Soccer.TeamPkg is

   type Team_Players_List is array (Positive range <>) of Integer;

   type Team_Id is (Team_One, Team_Two);

   type Team is
      record
	 id : Team_Id;
	 players : Team_Players_List (1 .. total_players / 2);
	 formation : Formation_Scheme_Id;
      end record;
   type Team_Ptr is access Team;

   function Get_Team_From_Id (id : Integer) return Team_Id;

   procedure Set_Teams (first_team : Team_Ptr; second_team : Team_Ptr);

   function Get_Team (team : Team_Id) return Team_Ptr;

   procedure Set_Formation (team : in Team_Ptr; formation : in Formation_Scheme_Id);

   function To_String (team : in Team_Id) return String;

   function Get_Coordinate_For_Player (team : in Team_Id; id : in Integer) return Coordinate;

   function Get_Goalkeeper_Id (team : in Team_Id) return Integer;

   function Check_For_Initial_Position_Of_Players (team : in Team_Id) return Boolean;

   function TEMP_Get_Coordinate_For_Player (id : in Integer) return Coordinate;

private
   --+ contengono TUTTI i giocatori di una squadra, non solo quelli in campo
   team_1 : Team_Ptr;
   team_2 : Team_Ptr;

   team_one_offensive_positions : Positions_Array;
   team_one_balanced_positions : Positions_Array;
   team_one_defensive_positions : Positions_Array;

   --+ contengono SOLO i giocatori che sono in campo
   team_one_offensive_formation : Formation_Scheme := Formation_Scheme'(id        => O_352,
							       positions => team_one_offensive_positions);
   team_one_balanced_formation : Formation_Scheme := Formation_Scheme'(id        => B_442,
							       positions => team_one_balanced_positions);
   team_one_defensive_formation : Formation_Scheme := Formation_Scheme'(id        => D_532,
							       positions => team_one_defensive_positions);

   players_coord : array (0 .. num_of_players) of Coordinate := (Coordinate'(0,5),
							       Coordinate'(5,5),--);
							       Coordinate'(25,13),
							       Coordinate'(17,9),
							       Coordinate'(10,18),
							       Coordinate'(28,2),
							       Coordinate'(6,6),
							       Coordinate'(14,15),
							       Coordinate'(20,10));

end Soccer.TeamPkg;
