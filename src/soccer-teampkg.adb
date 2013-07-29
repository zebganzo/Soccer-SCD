package body Soccer.TeamPkg is

   function Get_Team_From_Id (id : Positive) return Team_Id is begin

      -- controllare se e' giusto!
      for i in team_1.players'First .. team_1.players'Last loop
	 if team_1.players(i) = id then
	    return Team_One;
	 end if;
      end loop;

      return Team_Two;

   end Get_Team_From_Id;

   procedure Set_Teams (first_team : Team_Ptr; second_team : Team_Ptr) is
   begin
      team_1 := first_team;
      team_2 := second_team;
   end Set_Teams;

   function Get_Team (team : Team_Id) return Team_Ptr is begin
      if team = Team_One then
	 return team_1;
      else
	 return team_2;
      end if;
   end Get_Team;

   procedure Set_Formation (team : in Team_Ptr; formation : in Formation_Scheme_Id) is
   begin
      team.formation := formation;
   end Set_Formation;

   function To_String (team : in Team_Id) return String is
   begin
      if team = Team_One then
	 return "Team_One";
      else
	 return "Team_Two";
      end if;
   end To_String;

   function Get_Position_For_Player (team : in Team_Id; id : in Integer) return Coordinate is
   begin
      if team = Team_One then
	 if team_1.formation = O_352 then
	    return team_one_offensive_formation.positions(id);
	 elsif team_1.formation = B_442 then
	    return team_one_balanced_formation.positions(id);
	 else
	    return team_one_defensive_formation.positions(id);
	 end if;
      else
	 -- TODO:: add team 2
	 return Coordinate'(coord_x => -1,
		     coord_y => -1);
      end if;
   end Get_Position_For_Player;

end Soccer.TeamPkg;
