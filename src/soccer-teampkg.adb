with Ada.Text_IO; use Ada.Text_IO;
with GNATCOLL.JSON; use GNATCOLL.JSON;
with Soccer.Manager_Event.Substitution; use Soccer.Manager_Event.Substitution;

package body Soccer.TeamPkg is

   procedure Update_Map (subbed_player : Integer; new_player : Integer; team : Team_Id) is
      subbed_index : Integer;
      new_index    : Integer;
      swap         : Integer;
   begin
      if team = Team_One then
         for i in team_1.number_id'Range loop
            if team_1.number_id(i).number = subbed_player then
               subbed_index := i;
            end if;
            if team_1.number_id(i).number = new_player then
               new_index := i;
            end if;
         end loop;
         swap := team_1.number_id(subbed_index).number;
         team_1.number_id(subbed_index).number := new_player;
         team_1.number_id(new_player).number := swap;
      else
         for i in team_2.number_id'Range loop
            if team_2.number_id(i).number = subbed_player then
               subbed_index := i;
            end if;
            if team_2.number_id(i).number = new_player then
               new_index := i;
            end if;
         end loop;
         swap := team_2.number_id(subbed_index).number;
         team_2.number_id(subbed_index).number := new_player;
         team_2.number_id(new_player).number := swap;
      end if;
   end Update_Map;

   function Get_Formation_Id (number : Integer; team : Team_Id) return Integer is
      formation_id : Integer;
   begin
      if team = Team_One then
         for i in team_1.number_id'Range loop
            if team_1.number_id(i).number = number then
               formation_id := team_1.number_id(i).formation_id;
            end if;
         end loop;
      else
         for i in team_2.number_id'Range loop
            if team_2.number_id(i).number = number then
               formation_id := team_2.number_id(i).formation_id;
            end if;
         end loop;
      end if;

      return formation_id;
   end Get_Formation_Id;

   function Get_Role (formation_id : Integer; formation_scheme : Formation_Scheme_Id) return String is
      player_role : Integer range 1..18;
   begin
      player_role := formation_id;
      case formation_scheme is
         when O_352 =>
            case player_role is
               when 1	    => return "Goal Keeper";
               when 2..4    => return "Defender";
               when 5..9    => return "Midfielder";
               when 10 | 11 => return "Forward";
               when others  => return "Backup";
            end case;
         when B_442 =>
            case player_role is
               when 1	    => return "Goal Keeper";
               when 2..5    => return "Defender";
               when 6..9    => return "Midfielder";
               when 10 | 11 => return "Forward";
               when others  => return "Backup";
            end case;
         when D_532 =>
            case player_role is
               when 1	    => return "Goal Keeper";
               when 2..6    => return "Defender";
               when 7..9    => return "Midfielder";
               when 10 | 11 => return "Forward";
               when others  => return "Backup";
            end case;
      end case;
   end Get_Role;

   function Get_Number_From_Formation (formation_id : Integer;
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

   function Get_Formation (team : in Team_Id) return Formation_Scheme_Id is
   begin
      if team = Team_One then
         return team_1.formation;
      else
         return team_2.formation;
      end if;
   end Get_Formation;

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
            attack := player_team.statistics(player_team.number_id(i).statistics_id, attack_index);
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
            defense := player_team.statistics(player_team.number_id(i).statistics_id, defense_index);
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
            goal_keeping := player_team.statistics(player_team.number_id(i).statistics_id, goal_keeping_index);
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
            power := player_team.statistics(player_team.number_id(i).statistics_id, power_index);
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
            precision := player_team.statistics(player_team.number_id(i).statistics_id, precision_index);
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
            speed := player_team.statistics(player_team.number_id(i).statistics_id, speed_index);
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
            tackle := player_team.statistics(player_team.number_id(i).statistics_id, tackle_index);
         end if;
      end loop;
      return tackle;
   end Get_Tackle;

   procedure Update_Teams_Configuration (data : String) is
      team_one_players     : Team_Players_List(1 .. total_players/2);
      team_two_players 	   : Team_Players_List(1 .. total_players/2);
      team_one_raw_players : JSON_Array;
      team_two_raw_players : JSON_Array;

      team_one_formation_string : Unbounded_String;
      team_two_formation_string : Unbounded_String;
      team_one_formation        : Formation_Scheme_Id;
      team_two_formation        : Formation_Scheme_Id;

      team_one_stats_id : Team_Players_List(1 .. total_players/2);
      team_two_stats_id : Team_Players_List(1 .. total_players/2);
      team_one_stats    : Team_Players_Statistics(1..total_players/2, 1..players_stats);
      team_two_stats    : Team_Players_Statistics(1..total_players/2, 1..players_stats);

      team_one_formation_id : Team_Number_Map(1 .. total_players/2);
      team_two_formation_id : Team_Number_Map(1 .. total_players/2);

      json_team : JSON_Value := Read(data,"");
      one 	: JSON_Value := Get (json_team, "one");
      two 	: JSON_Value := Get (json_team, "two");
   begin
      Put_Line ("Received data: " & data);
--        Put_Line("****** INIZIO UPDATE CONFIGURATION **********");
      if To_String(Get (one, "team")) = "Team_One" then
	 team_one_raw_players := Get (one, "players");
	 team_two_raw_players := Get (two, "players");

	 team_one_formation_string := Get (one, "formation");
	 team_two_formation_string := Get (two, "formation");
      else
	 team_one_raw_players := Get (two, "players");
	 team_two_raw_players := Get (one, "players");

	 team_one_formation_string := Get (two, "formation");
	 team_two_formation_string := Get (one, "formation");
      end if;

      for i in 1 .. total_players/2 loop
         team_one_players(i) := Get( Get(team_one_raw_players, i), "number");
         team_two_players(i) := Get( Get(team_two_raw_players, i), "number");
         team_one_stats_id(i) := i;
         team_two_stats_id(i) := i;
         for stat in 1 .. players_stats loop
            case stat is
               when attack_index =>
                  team_one_stats(i,stat) := Get( Get(team_one_raw_players, i), "attack");
                  team_two_stats(i,stat) := Get( Get(team_two_raw_players, i), "attack");
               when defense_index =>
                  team_one_stats(i,stat) := Get( Get(team_one_raw_players, i), "defense");
                  team_two_stats(i,stat) := Get( Get(team_two_raw_players, i), "defense");
               when power_index =>
                  team_one_stats(i,stat) := Get( Get(team_one_raw_players, i), "power");
                  team_two_stats(i,stat) := Get( Get(team_two_raw_players, i), "power");
               when precision_index =>
                  team_one_stats(i,stat) := Get( Get(team_one_raw_players, i), "precision");
                  team_two_stats(i,stat) := Get( Get(team_two_raw_players, i), "precision");
               when speed_index =>
                  team_one_stats(i,stat) := Get( Get(team_one_raw_players, i), "speed");
                  team_two_stats(i,stat) := Get( Get(team_two_raw_players, i), "speed");
               when tackle_index =>
                  team_one_stats(i,stat) := Get( Get(team_one_raw_players, i), "tackle");
                  team_two_stats(i,stat) := Get( Get(team_two_raw_players, i), "tackle");
               when goal_keeping_index =>
                  team_one_stats(i,stat) := Get( Get(team_one_raw_players, i), "goal_keeping");
                  team_two_stats(i,stat) := Get( Get(team_two_raw_players, i), "goal_keeping");
               when others => null;
            end case;
         end loop;

         team_one_formation_id(i).number := team_one_players(i);
         team_one_formation_id(i).statistics_id := team_one_stats_id(i);
         if team_one_stats(i,goal_keeping_index) > 0 then
            team_one_formation_id(i).formation_id := 1;
         else
            team_one_formation_id(i).formation_id := i;
         end if;
         team_two_formation_id(i).number := team_two_players(i);
         team_two_formation_id(i).statistics_id := team_two_stats_id(i);
         if team_two_stats(i,goal_keeping_index) > 0 then
            team_two_formation_id(i).formation_id := 1;
         else
            team_two_formation_id(i).formation_id := i;
         end if;
      end loop;

      if team_one_formation_string = "3-5-2" then
	 team_one_formation := O_352;
      elsif team_one_formation_string = "4-4-2" then
	 team_one_formation := B_442;
      else
	 team_one_formation := D_532;
      end if;

      if team_two_formation_string = "3-5-2" then

	 team_two_formation := O_352;
      elsif team_two_formation_string = "4-4-2" then
	 team_two_formation := B_442;
      else
	 team_two_formation := D_532;
      end if;

      team_1 := new Team'(id         => Team_One,
                          players    => team_one_players,
                          statistics => team_one_stats,
                          number_id  => team_one_formation_id,
                          formation  => team_one_formation);

      team_2 := new Team'(id         => Team_Two,
                          players    => team_two_players,
                          statistics => team_two_stats,
                          number_id  => team_two_formation_id,
                          formation  => team_two_formation);

--        for i in team_2.players'Range loop
--           Put_Line (Integer'Image(team_2.players(i)));
--        end loop;
--
--        Put_Line("****** FINE UPDATE CONFIGURATION **********");
   end Update_Teams_Configuration;
end Soccer.TeamPkg;
