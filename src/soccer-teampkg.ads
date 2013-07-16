package Soccer.TeamPkg is

   type Team_Players_List is array (Positive range <>) of Positive;

   type Team_Id is (Team_One, Team_Two);

   type Team is
      record
	 id : Team_Id;
	 players : Team_Players_List (1 .. 4);
	 formation : Formation_Scheme;
      end record;
   type Team_Ptr is access Team;

   function Get_Team_From_Id (id : Positive) return Team_Id;

   procedure Set_Teams (first_team : Team_Ptr; second_team : Team_Ptr);

   function Get_Team (team : Team_Id) return Team_Ptr;

   procedure Set_Formation (team : in Team_Ptr; formation : in Formation_Scheme);

   function To_String (team : in Team_Id) return String;

private
   team_1 : Team_Ptr;
   team_2 : Team_Ptr;

end Soccer.TeamPkg;
