with Ada.Text_IO; use Ada.Text_IO;
package body Soccer.TeamPkg is

   function Get_Number_From_formation (formation_id : Integer;
                                       team	    : Team_Id) return Integer is
      number : Integer;
   begin
      if team = Team_One then
         for i in team_1.number_id'Range loop
            if team_1.number_id(i).formation_id = formation_id then
               number := team_1.number_id(i).number;
            end if;
         end loop;
      else
         for i in team_2.number_id'Range loop
            if team_2.number_id(i).formation_id = formation_id then
               number := team_2.number_id(i).number;
            end if;
         end loop;
      end if;
      return number;
   end Get_Number_From_formation;

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

   function Get_Coordinate_For_Player (my_team : in Team_Id;
                                       holder_team    : in Team_Id;
                                       number  : in Integer) return Coordinate is
      index : Integer;
   begin
      if my_team = Team_One then
         for i in team_1.players'Range loop
            if team_1.number_id(i).number = number then
               index := team_1.number_id(i).formation_id;
            end if;
         end loop;
         if my_team = holder_team then
            if team_1.formation = O_352 then
               return t1_352_att_pos(index);
            elsif team_1.formation = B_442 then
               return t1_442_att_pos(index);
            else
               return t1_532_att_pos(index);
            end if;
         else
            if team_1.formation = O_352 then
               return t1_352_def_pos(index);
            elsif team_1.formation = B_442 then
               return t1_442_def_pos(index);
            else
               return t1_532_def_pos(index);
            end if;
         end if;
      else
         for i in team_2.players'Range loop
            if team_2.number_id(i).number = number then
               index := team_2.number_id(i).formation_id;
            end if;
         end loop;
         if my_team = holder_team then
            if team_2.formation = O_352 then
               return t1_352_att_pos(index);
            elsif team_2.formation = B_442 then
               return t2_442_att_pos(index);
            else
               return t2_532_att_pos(index);
            end if;
         else
            if team_2.formation = O_352 then
               return t2_352_def_pos(index);
            elsif team_2.formation = B_442 then
               return t2_442_def_pos(index);
            else
               return t2_532_def_pos(index);
            end if;
         end if;
      end if;

   end Get_Coordinate_For_Player;

   function Get_Goalkeeper_Number (team : in Team_Id) return Integer is
      keeper_number : Integer;
   begin
      if team = Team_One then
         for i in team_1.number_id'Range loop
            if team_1.number_id(i).formation_id = 1 then
               keeper_number := team_1.number_id(i).number;
            end if;
         end loop;
      else
	 for i in team_2.number_id'Range loop
            if team_2.number_id(i).formation_id = 1 then
               keeper_number := team_2.number_id(i).number;
            end if;
         end loop;
      end if;

      return keeper_number;
   end Get_Goalkeeper_Number;

   -- returns a player's statistics array
   function Get_Statistics(number : in Integer;
                           team   : in Team_Id) return Player_Statistics is
      stat     : Player_Statistics(1..7);
      position : Integer;
   begin
      if team = Team_One then
         for i in team_1.number_id'Range loop
            if number = team_1.number_id(i).number then
               position := team_1.number_id(i).statistics_id;
            end if;
         end loop;
         for i in 1..7 loop
            stat(i) := team_1.statistics(position,i);
         end loop;
      else
	 for i in team_2.number_id'Range loop
            if number = team_2.number_id(i).number then
               position := team_2.number_id(i).statistics_id;
            end if;
         end loop;
         for i in 1..7 loop
            stat(i) := team_2.statistics(position,i);
         end loop;
      end if;
      return stat;
   end Get_Statistics;

   -- returns a player starting position, given his id and his team
   function Get_Starting_Position(number : in Integer;
                                  team   : in Team_Id) return Coordinate is
      position : Integer;
   begin
      if team = Team_One then
         for i in team_1.number_id'Range loop
            if number = team_1.number_id(i).number then
               position := team_1.number_id(i).formation_id;
            end if;
         end loop;
         if team_1.formation = O_352 then
            return t1_352_start_pos(position);
         elsif team_1.formation = B_442 then
            return t1_442_start_pos(position);
         else
            return t1_532_start_pos(position);
         end if;
      else
         for i in team_2.number_id'Range loop
            if number = team_2.number_id(i).number then
               position := team_2.number_id(i).formation_id;
            end if;
         end loop;
         if team_2.formation = O_352 then
            return t2_352_start_pos(position);
         elsif team_2.formation = B_442 then
            return t2_442_start_pos(position);
         else
            return t2_532_start_pos(position);
         end if;
      end if;
   end Get_Starting_Position;

   -- returns player's defense position, given his id and his team
   function Get_Defense_Position(number : in Integer;
                                 team   : in Team_Id) return Coordinate is
      position : Integer;
   begin
      for i in team_1.number_id'Range loop
         if number = team_1.number_id(i).number then
            position := team_1.number_id(i).formation_id;
         end if;
      end loop;
      if team = Team_One then
         if team_1.formation = O_352 then
            return t1_352_def_pos(position);
         elsif team_1.formation = B_442 then
            return t1_442_def_pos(position);
         else
            return t1_532_def_pos(position);
         end if;
      else
         for i in team_2.number_id'Range loop
            if number = team_2.number_id(i).number then
               position := team_2.number_id(i).formation_id;
            end if;
         end loop;
         if team_2.formation = O_352 then
            return t2_352_def_pos(position);
         elsif team_2.formation = B_442 then
            return t2_442_def_pos(position);
         else
            return t2_532_def_pos(position);
         end if;
      end if;
   end Get_Defense_Position;

   -- returns a player attack position, given his id and his team
   function Get_Attack_Position(number : in Integer;
                                team   : in Team_Id) return Coordinate is
      position : Integer;
   begin
      if team = Team_One then
         for i in team_1.number_id'Range loop
            if number = team_1.number_id(i).number then
               position := team_1.number_id(i).formation_id;
            end if;
         end loop;
         if team_1.formation = O_352 then
            return t1_352_att_pos(position);
         elsif team_1.formation = B_442 then
            return t1_442_att_pos(position);
         else
            return t1_532_att_pos(position);
         end if;
      else
         for i in team_2.number_id'Range loop
            if number = team_2.number_id(i).number then
               position := team_2.number_id(i).formation_id;
            end if;
         end loop;
         if team_2.formation = O_352 then
            return t2_352_att_pos(position);
         elsif team_2.formation = B_442 then
            return t2_442_att_pos(position);
         else
            return t2_532_att_pos(position);
         end if;
      end if;
   end Get_Attack_Position;

   -- returns player's goal kick position, given his number and his team
   function Get_Goal_Kick_Position(number : in Integer;
                                   team   : in Team_Id) return Coordinate is
      position : Integer;
   begin
      if team = Team_One then
         for i in team_1.number_id'Range loop
            if number = team_1.number_id(i).number then
               position := team_1.number_id(i).formation_id;
            end if;
         end loop;
         if team_1.formation = O_352 then
            return t1_352_gkick_pos(position);
         elsif team_1.formation = B_442 then
            return t1_442_gkick_pos(position);
         else
            return t1_532_gkick_pos(position);
         end if;
      else
         for i in team_2.number_id'Range loop
            if number = team_2.number_id(i).number then
               position := team_2.number_id(i).formation_id;
            end if;
         end loop;
         if team_2.formation = O_352 then
            return t2_352_gkick_pos(position);
         elsif team_2.formation = B_442 then
            return t2_442_gkick_pos(position);
         else
            return t2_532_gkick_pos(position);
         end if;
      end if;
   end Get_Goal_Kick_Position;

   -- returns player's corner kick position, given his number and his team
   function Get_Corner_Kick_Position(number 	 : in Integer;
                                     team   	 : in Team_Id;
                                     holder_team : in Team_Id) return Coordinate is
      position : Integer;
   begin
      if team = Team_One then
         for i in team_1.number_id'Range loop
            if number = team_1.number_id(i).number then
               position := team_1.number_id(i).formation_id;
            end if;
         end loop;
         if team_1.formation = O_352 then
            if holder_team = Team_One then
               return t1_352_att_corner_pos(position);
            else
               return t1_352_def_corner_pos(position);
            end if;
         elsif team_1.formation = B_442 then
            if holder_team = Team_One then
               return t1_442_att_corner_pos(position);
            else
               return t1_442_def_corner_pos(position);
            end if;
         else
            if holder_team = Team_One then
               return t1_532_att_corner_pos(position);
            else
               return t1_532_def_corner_pos(position);
            end if;
         end if;
      else
         for i in team_2.number_id'Range loop
            if number = team_2.number_id(i).number then
               position := team_2.number_id(i).formation_id;
            end if;
         end loop;
         if team_2.formation = O_352 then
            if holder_team = Team_Two then
               return t2_352_att_corner_pos(position);
            else
               return t2_352_def_corner_pos(position);
            end if;
         elsif team_2.formation = B_442 then
            if holder_team = Team_Two then
               return t2_442_att_corner_pos(position);
            else
               return t2_442_def_corner_pos(position);
            end if;
         else
            if holder_team = Team_Two then
               return t2_532_att_corner_pos(position);
            else
               return t2_532_def_corner_pos(position);
            end if;
         end if;
      end if;
   end Get_Corner_Kick_Position;

   -- returns player's penalty kick position, given his number and his team
   function Get_Penalty_Kick_Position(number 	  : in Integer;
                                      team   	  : in Team_Id;
                                      holder_team : in Team_Id) return Coordinate is
      position : Integer;
   begin
      if team = Team_One then
         for i in team_1.number_id'Range loop
            if number = team_1.number_id(i).number then
               position := team_1.number_id(i).formation_id;
            end if;
         end loop;
         if team_1.formation = O_352 then
            if holder_team = Team_One then
               return t1_352_att_penalty_pos(position);
            else
               return t1_352_def_penalty_pos(position);
            end if;
         elsif team_1.formation = B_442 then
            if holder_team = Team_One then
               return t1_442_att_penalty_pos(position);
            else
               return t1_442_def_penalty_pos(position);
            end if;
         else
            if holder_team = Team_One then
               return t1_532_att_penalty_pos(position);
            else
               return t1_532_def_penalty_pos(position);
            end if;
         end if;
      else
         for i in team_2.number_id'Range loop
            if number = team_2.number_id(i).number then
               position := team_2.number_id(i).formation_id;
            end if;
         end loop;
         if team_2.formation = O_352 then
            if holder_team = Team_Two then
               return t2_352_att_penalty_pos(position);
            else
               return t2_352_def_penalty_pos(position);
            end if;
         elsif team_2.formation = B_442 then
            if holder_team = Team_Two then
               return t2_442_att_penalty_pos(position);
            else
               return t2_442_def_penalty_pos(position);
            end if;
         else
            if holder_team = Team_Two then
               return t2_532_att_penalty_pos(position);
            else
               return t2_532_def_penalty_pos(position);
            end if;
         end if;
      end if;
   end Get_Penalty_Kick_Position;

   -- returns player's attack statistic
   function Get_Attack(number : in Integer;
                       team   : Team_Id) return Integer is
      player_team : Team_Ptr;
      attack      : Integer;
   begin
      player_team := Get_Team(team);
      for i in player_team.number_id'Range loop
         if player_team.number_id(i).number = number then
            attack := player_team.statistics(player_team.number_id(i).statistics_id,1);
         end if;
      end loop;
      return attack;
   end Get_Attack;

   -- returns player's defense statistic
   function Get_Defense(number : in Integer;
                        team   : Team_Id) return Integer is
      player_team : Team_Ptr;
      defense     : Integer;
   begin
      player_team := Get_Team(team);
      for i in player_team.number_id'Range loop
         if player_team.number_id(i).number = number then
            defense := player_team.statistics(player_team.number_id(i).statistics_id,2);
         end if;
      end loop;
      return defense;
   end Get_Defense;

   -- returns player's goal keeping statistic
   function Get_Goal_Keeping(number : in Integer;
                             team   : Team_Id) return Integer is
      player_team  : Team_Ptr;
      goal_keeping : Integer;
   begin
      player_team := Get_Team(team);
      for i in player_team.number_id'Range loop
         if player_team.number_id(i).number = number then
            goal_keeping := player_team.statistics(player_team.number_id(i).statistics_id,3);
         end if;
      end loop;
      return goal_keeping;
   end Get_Goal_Keeping;

   -- returns player's power statistic
   function Get_Power(number : in Integer;
                      team   : Team_Id) return Integer is
      player_team : Team_Ptr;
      power       : Integer;
   begin
      player_team := Get_Team(team);
      for i in player_team.number_id'Range loop
         if player_team.number_id(i).number = number then
            power := player_team.statistics(player_team.number_id(i).statistics_id,4);
         end if;
      end loop;
      return power;
   end Get_Power;

   -- returns player's precision statistic
   function Get_Precision(number : in Integer;
                          team   : Team_Id) return Integer is
      player_team : Team_Ptr;
      precision   : Integer;
   begin
      player_team := Get_Team(team);
      for i in player_team.number_id'Range loop
         if player_team.number_id(i).number = number then
            precision := player_team.statistics(player_team.number_id(i).statistics_id,5);
         end if;
      end loop;
      return precision;
   end Get_Precision;

   -- returns player's speed statistic
   function Get_Speed(number : in Integer;
                      team   : Team_Id) return Integer is
      player_team : Team_Ptr;
      speed       : Integer;
   begin
      player_team := Get_Team(team);
      for i in player_team.number_id'Range loop
         if player_team.number_id(i).number = number then
            speed := player_team.statistics(player_team.number_id(i).statistics_id,6);
         end if;
      end loop;
      return speed;
   end Get_Speed;

   -- returns player's tackle statistic
   function Get_Tackle(number : in Integer;
                       team   : Team_Id) return Integer is
      player_team : Team_Ptr;
      tackle      : Integer;
   begin
      player_team := Get_Team(team);
      for i in player_team.number_id'Range loop
         if player_team.number_id(i).number = number then
            tackle := player_team.statistics(player_team.number_id(i).statistics_id,7);
         end if;
      end loop;
      return tackle;
   end Get_Tackle;

end Soccer.TeamPkg;
