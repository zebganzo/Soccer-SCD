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
with GNATCOLL; use GNATCOLL;
with GNATCOLL.JSON; use GNATCOLL.JSON;
with Ada.Calendar.Formatting;
with Ada.Unchecked_Conversion;
with GNAT.OS_Lib; use GNAT.OS_Lib;

with Util.Processes;
with Util.Streams.Pipes;
with Util.Streams.Buffered;

with GNAT.String_Split; use GNAT.String_Split;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

procedure Soccer.Main is

--     players_team_one : Team_Players_List := (12, 2, 7, 8, 60);
--     players_team_two : Team_Players_List := (6, 56, 1, 4, 10);
--     players_team_one : Team_Players_List := (12, 2, 7);
--     players_team_two : Team_Players_List := (6, 56, 1);
   players_team_one : Team_Players_List := (12, 2, 7, 8, 60, 88, 13, 5, 91, 37, 15);
   players_team_two : Team_Players_List := (6, 56, 1, 4, 10, 32, 59, 9, 19, 72, 20);

   type Pos_Id is array (Positive range <>) of Integer;
--        t1_pos_id : Pos_Id(1 .. total_players/2) := (2,6,1,10,5);
   t1_pos_id : Pos_Id(1 .. total_players/2) := (2,6,1,10,5,3,4,7,8,9,11);
--        t1_pos_id : Pos_Id(1 .. total_players/2) := (2,6,1);
--     t2_pos_id : Pos_Id(1 .. total_players/2) := (4,6,1,10,3);
   t2_pos_id : Pos_Id(1 .. total_players/2) := (4,6,1,10,3,2,5,7,8,9,11);
--        t2_pos_id : Pos_Id(1 .. total_players/2) := (4,6,1);

--        t1_stat_id : Pos_Id(1 .. total_players/2) := (1,2,3,4,5);
   t1_stat_id : Pos_Id(1 .. total_players/2) := (1,2,3,4,5,6,7,8,9,10,11);
--     t1_stat_id : Pos_Id(1 .. total_players/2) := (1,2,3);
--        t2_stat_id : Pos_Id(1 .. total_players/2) := (1,2,3,4,5);
   t2_stat_id : Pos_Id(1 .. total_players/2) := (1,2,3,4,5,6,7,8,9,10,11);
--     t2_stat_id : Pos_Id(1 .. total_players/2) := (1,2,3);

   formation_id_t1 : Team_Number_Map(1 .. total_players/2);
   formation_id_t2 : Team_Number_Map(1 .. total_players/2);

   -- players statistics for team 1
   -- (attack, defense, power, precision, speed, tackle, goal_keeping)
   players_stats_team_1 : Team_Players_Statistics :=
     (1  => (30, 10, 20, 60, 60, 80, 0),
      2  => (30, 80, 75, 60, 60, 80, 0),
      3  => (30, 80, 75, 60, 60, 80, 90),
      4  => (30, 80, 75, 60, 60, 80, 0),
      5  => (30, 80, 75, 60, 60, 80, 0),
      6  => (30, 80, 75, 60, 60, 80, 0),
      7  => (30, 80, 75, 60, 60, 80, 0),
      8  => (30, 80, 75, 60, 60, 80, 0),
      9  => (30, 80, 75, 60, 60, 80, 0),
      10 => (30, 80, 75, 60, 60, 80, 0),
      11 => (30, 80, 75, 60, 60, 80, 0));

   -- players statistics for team 2
   -- (attack, defense, power, precision, speed, tackle, goal_keeping)
   players_stats_team_2 : Team_Players_Statistics :=
     (1  => (40, 70, 85, 50, 70, 70, 0),
      2  => (40, 70, 85, 50, 70, 70, 0),
      3  => (40, 70, 85, 50, 70, 70, 50),
      4  => (40, 10, 20, 50, 70, 70, 0),
      5  => (40, 10, 20, 50, 70, 70, 0),
      6  => (40, 10, 20, 50, 70, 70, 0),
      7  => (40, 10, 20, 50, 70, 70, 0),
      8  => (40, 10, 20, 50, 70, 70, 0),
      9  => (40, 10, 20, 50, 70, 70, 0),
      10 => (40, 10, 20, 50, 70, 70, 0),
      11 => (40, 70, 85, 50, 70, 70, 0));

   t1 : Team_Ptr;
   t2 : Team_Ptr;

begin
   for i in 1..total_players/2 loop
         formation_id_t1(i).number        := players_team_one(i);
         formation_id_t1(i).formation_id  := t1_pos_id(i);
         formation_id_t1(i).statistics_id := t1_stat_id(i);
         formation_id_t2(i).number        := players_team_two(i);
         formation_id_t2(i).formation_id  := t2_pos_id(i);
	 formation_id_t2(i).statistics_id := t2_stat_id(i);
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
      task11 : Player;
      task12 : Player;
      task13 : Player;
      task14 : Player;
      task15 : Player;
      task16 : Player;
      task17 : Player;
      task18 : Player;
      task19 : Player;
      task20 : Player;
      task21 : Player;
      task22 : Player;

      --        char : Character;

--        command : Unbounded_String;
--        arguments : Argument_List_Access;
--        exit_status : Integer;
--        Standard_Output : constant File_Descriptor := -1;

--        status_string : Unbounded_String := To_Unbounded_String ("player(position(8,17),has_not,team1,not_last_holder),player_number(7),starting_position(1,17),defense_position(1,17),attack_position(8,17),ball(position(21,17),team1),game(running),goal_position(position(51,15),position(51,19)),radius(8)");

--        BufferSize : constant := 5;
--        Retval     : Unbounded_String := Null_Unbounded_String;
--        Item       : String (1 .. BufferSize);
--        Last       : Natural;

--        Pipe    : aliased Util.Streams.Pipes.Pipe_Stream;
--        Buffer  : Util.Streams.Buffered.Buffered_Stream;
--
--        Content : Unbounded_String;
--
--        Subs : Slice_Set;
--        Seps : constant String := "" & Comma;
--
--        t_start : Time;
--        t_end : Time;
   begin

      Server.WebServer.Start;

--        t_start := Clock;
--
--        Buffer.Initialize (null, Pipe'Unchecked_Access, 1024);
--        Pipe.Open ("./launch_player.sh " & To_String(status_string), Util.Processes.READ);
--
--        Buffer.Read (Content);
--        Pipe.Close;
--
--        t_end := Clock;
--
--        Put_Line ("Elapsed: " & Duration'Image (t_end - t_start));
--
--        Create (S          => Subs,
--  	      From       => To_String (Content),
--  	      Separators => Seps,
--  	      Mode       => Multiple);
--
--        Put_Line ("Got" & Slice_Number'Image (Slice_Count (Subs)) & " substrings:");
--        --  Report results, starting with the count of substrings created.
--
--        for I in 1 .. Slice_Count (Subs) loop
--  	 --  Loop though the substrings.
--  	 declare
--  	    Sub : constant String := Slice (Subs, I);
--  	    --  Pull the next substring out into a string object for easy handling.
--  	 begin
--  	    Put_Line (Slice_Number'Image (I) &
--  		 " -> " &
--  		 Sub &
--  		 " (length" & Positive'Image (Sub'Length) &
--  		 ")");
--  	    --  Output the individual substrings, and their length.
--
--  	 end;
--        end loop;


   end;

end Soccer.Main;

