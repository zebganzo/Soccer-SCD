with Soccer.PlayersPkg;
use Soccer.PlayersPkg;

with Soccer.ControllerPkg;
use Soccer.ControllerPkg;

with Soccer.BallPkg;
with Soccer.Motion_AgentPkg;

with Soccer.Bridge.Output;
use Soccer.Bridge.Output;

with Soccer.Server;
with Soccer.Server.WebServer;

with Ada.Text_IO; use Ada.Text_IO;
with Soccer.Core_Event.Game_Core_Event.Binary_Game_Event; use Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
with Soccer.Core_Event.Game_Core_Event.Unary_Game_Event; use Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
with Soccer.Core_Event.Game_Core_Event.Match_Game_Event; use Soccer.Core_Event.Game_Core_Event.Match_Game_Event;
with Soccer.Core_Event; use Soccer.Core_Event;
with Soccer.TeamPkg; use Soccer.TeamPkg;
with Soccer.Game; use Soccer.Game;
with Soccer.ControllerPkg.Referee; use Soccer.ControllerPkg.Referee;


procedure Soccer.Main is

   players_team_one : Team_Players_List := (12, 2, 7, 10, 60);
   players_team_two : Team_Players_List := (6, 56, 1, 4, 10);

   type Pos_Id is array (Positive range <>) of Integer;
   t1_pos_id : Pos_Id(1 .. total_players/2) := (2,3,4,5,1);
   t2_pos_id : Pos_Id(1 .. total_players/2) := (4,5,6,7,1);

   t1_stat_id : Pos_Id(1 .. total_players/2) := (1,2,3,4,5);
   t2_stat_id : Pos_Id(1 .. total_players/2) := (1,2,3,4,5);

   formation_id_t1 : Team_Number_Map(1 .. total_players/2);
   formation_id_t2 : Team_Number_Map(1 .. total_players/2);

   -- players statistics for team 1
   -- (attack, defense, goal_keeping, power, precision, speed, tackle)
   players_stats_team_1 : Team_Players_Statistics :=
     (1   => (30, 80, 0, 75, 60, 60, 80),
      2   => (30, 80, 0, 75, 60, 60, 80),
      3   => (30, 80, 0, 75, 60, 60, 80),
      4   => (30, 80, 0, 75, 60, 60, 80),
      5   => (30, 80, 0, 75, 60, 60, 80));

   -- players statistics for team 2
   -- (attack, defense, goal_keeping, power, precision, speed, tackle)
   players_stats_team_2 : Team_Players_Statistics :=
     (1   => (40, 70, 0, 85, 50, 70, 70),
      2   => (40, 70, 0, 85, 50, 70, 70),
      3   => (40, 70, 0, 85, 50, 70, 70),
      4   => (40, 70, 0, 85, 50, 70, 70),
      5   => (40, 70, 0, 85, 50, 70, 70));

   t1 : Team_Ptr;
   t2 : Team_Ptr;

begin
   for i in 1..total_players/2 loop
         formation_id_t1(i).number        := players_team_one(i);
     --    pragma Debug (Put_Line ("NUMBER:" & I2S(players_team_one(i))));
         formation_id_t1(i).formation_id  := t1_pos_id(i);
     --   pragma Debug (Put_Line ("FORMATION ID:" & I2S(t1_pos_id(i))));
         formation_id_t1(i).statistics_id := t1_stat_id(i);
     --    pragma Debug (Put_Line ("STAT ID:" & I2S(t1_stat_id(i))));
         formation_id_t2(i).number        := players_team_two(i);
     --    pragma Debug (Put_Line ("NUMBER:" & I2S(players_team_two(i))));
         formation_id_t2(i).formation_id  := t2_pos_id(i);
     --    pragma Debug (Put_Line ("FORMATION ID:" & I2S(t2_pos_id(i))));
	 formation_id_t2(i).statistics_id := t2_stat_id(i);
     --    pragma Debug (Put_Line ("STAT ID:" & I2S(t2_stat_id(i))));
      end loop;
   t1 := new Team'(id         => Team_One,
                   players    => players_team_one,
                   statistics => players_stats_team_1,
                   number_id  => formation_id_t1,
                   formation  => O_352);
   t2 := new Team'(id         => Team_Two,
                   players    => players_team_two,
                   statistics => players_stats_team_2,
                   number_id  => formation_id_t2,
                   formation  => B_442);
   Set_Teams (first_team  => t1,
              second_team => t2);

-- pragma Debug (Put_Line ("LENGTH:" & I2S(t2.players'Length)));

   declare
      task1  : Player;
      task2  : Player;
      task3  : Player;
      task4  : Player;
      task5  : Player;
      task6  : Player;
      task7  : Player;
      task8  : Player;
      task9  : Player;
      task10 : Player;

      char : Character;
   begin

      loop
	 Get (Item => char);

	 if char = 'p' then
	    -- metti in pausa il gioco
	    if Get_Game_Status = Game_Paused then
	       Set_Game_Status (Game_Blocked);
	       pragma Debug (Put_Line ("[MAIN] New status is " & Game_State'Image (Get_Game_Status)));
	    else
	       Set_Game_Status (Game_Paused);
	       pragma Debug (Put_Line ("[MAIN] New status is " & Game_State'Image (Get_Game_Status)));
	    end if;
	 elsif char = 'n' then
	    -- chiama notify
	    Set_Game_Status (Game_Paused);
	    Game_Entity.Notify;
	 elsif char = '1' then
	    pragma Debug (Put_Line ("[MAIN] Simulating end of 1st half"));
	    Referee.Simulate_End_Of_1T;
	 elsif char = '2' then
	    pragma Debug (Put_Line ("[MAIN] Simulating start of 2nd half"));
	    Referee.Simulate_Begin_Of_2T;
	    Game_Entity.Notify;
	 elsif char = 'e' then
	    pragma Debug (Put_Line ("[MAIN] Simulating end of 2nd half"));
	    Referee.Simulate_End_Of_Match;
	 elsif char = 's' then
	    pragma Debug (Put_Line ("[MAIN] Substitution"));
	    Referee.Simulate_Substitution;
	 end if;


      end loop;


   end;

--     Soccer.Server.WebServer.Start;

--     delay 10.0;
--     Soccer.Server.WebServer.PublishFieldUpdate;

end Soccer.Main;

