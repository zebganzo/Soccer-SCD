
package Soccer.TeamPkg is

   type Team_Players_List is array (Positive range <>) of Integer;

   -- 2 dimension array used to store a team's players' statistics
   -- A generic row looks like this:
   -- (attack, defense, goal_keeping, power, precision, speed, tackle)
   type Team_Players_Statistics is
     array(Positive range <>, Positive range <>) of Integer;

   -- array which stores a single player's statistics
   type Player_Statistics is array (Positive range <>) of Integer;

   type Player_Number_Map is
      record
         number        : Integer;
         formation_id  : Integer;
         statistics_id : Integer;
      end record;

   type Team_Number_Map is array (Positive range <>) of Player_Number_Map;

   type Team_Id is (Team_One, Team_Two);

   type Team is
      record
	 id 	    : Team_Id;
	 players    : Team_Players_List(1 .. total_players/2);
         statistics : Team_Players_Statistics(1..total_players/2, 1..7);
         number_id  : Team_Number_Map(1..total_players/2);
	 formation  : Formation_Scheme_Id;
      end record;
   type Team_Ptr is access Team;

   function Get_Team_From_Id (id : Integer) return Team_Id;

   -- Get Team Id from the player's number
   function Get_Team_From_Number (number : Integer) return Team_Id;

   procedure Set_Teams (first_team : Team_Ptr; second_team : Team_Ptr);

   function Get_Team (team : Team_Id) return Team_Ptr;

   procedure Set_Formation (team : in Team_Ptr; formation : in Formation_Scheme_Id);

   function To_String (team : in Team_Id) return String;

   function Get_Coordinate_For_Player (my_team : in Team_Id;
                                       holder_team : in Team_Id;
                                       number : in Integer) return Coordinate;

   function Get_Goalkeeper_Id (team : in Team_Id) return Integer;

   function Check_For_Initial_Position_Of_Players (team : in Team_Id) return Boolean;

   function TEMP_Get_Coordinate_For_Player (id : in Integer) return Coordinate;

   -- returns a player's statistics array, given his number and his team
   function Get_Statistics(number : in Integer;
                           team   : in Team_Id) return Player_Statistics;

   -- returns player's starting position, given his number and his team
   function Get_Starting_Position(number : in Integer;
                                  team   : in Team_Id) return Coordinate;

   -- returns player's defense position, given his number and his team
   function Get_Defense_Position(number : in Integer;
                                 team   : in Team_Id) return Coordinate;

   -- returns player's attack position, given his number and his team
   function Get_Attack_Position(number : in Integer;
                                team   : in Team_Id) return Coordinate;

private
   --+ contengono TUTTI i giocatori di una squadra, non solo quelli in campo
   team_1 : Team_Ptr;
   team_2 : Team_Ptr;

   -- Formation Scheme 3-5-2: team 1 players' starting positions
   t1_352_start_pos : Positions_Array :=
     (1  => Coordinate'(1,17),				-- goal keeper
      2  => Coordinate'(13,10),				-- back 1
      3  => Coordinate'(13,17),				-- back 2
      4  => Coordinate'(13,24),				-- back 3
      5  => Coordinate'(19,17),				-- midfielder 1
      6  => Coordinate'(21,9),				-- midfielder 2
      7  => Coordinate'(21,25),				-- midfielder 3
      8  => Coordinate'(25,5),				-- midfielder 4
      9  => Coordinate'(25,29),				-- midfielder 5
      10 => Coordinate'(25,11),				-- forward 1
      11 => Coordinate'(25,23));			-- forward 2

   -- Formation Scheme 3-5-2: team 2 players' starting positions
   t2_352_start_pos : Positions_Array :=
     (1  => Coordinate'(51,17),				-- goal keeper
      2  => Coordinate'(39,24),				-- back 1
      3  => Coordinate'(39,17),				-- back 2
      4  => Coordinate'(39,10),				-- back 3
      5  => Coordinate'(33,17),				-- midfielder 1
      6  => Coordinate'(31,25),				-- midfielder 2
      7  => Coordinate'(31,9),				-- midfielder 3
      8  => Coordinate'(27,29),				-- midfielder 4
      9  => Coordinate'(27,5),				-- midfielder 5
      10 => Coordinate'(27,23),				-- forward 1
      11 => Coordinate'(27,11));			-- forward 2

   -- Formation Scheme 3-5-2: team 1 players' reference positions
   -- during a defense phase
   t1_352_def_pos : Positions_Array :=
     (1  => Coordinate'(1,17),				-- goal keeper
      2  => Coordinate'(7,10),				-- back 1
      3  => Coordinate'(7,17),				-- back 2
      4  => Coordinate'(7,24),				-- back 3
      5  => Coordinate'(16,17),				-- midfielder 1
      6  => Coordinate'(14,9),				-- midfielder 2
      7  => Coordinate'(14,25),				-- midfielder 3
      8  => Coordinate'(19,5),				-- midfielder 4
      9  => Coordinate'(19,29),				-- midfielder 5
      10 => Coordinate'(25,11),				-- forward 1
      11 => Coordinate'(25,23));			-- forward 2

   -- Formation Scheme 3-5-2: team 2 players' reference positions
   -- during a defense phase
   t2_352_def_pos : Positions_Array :=
     (1  => Coordinate'(51,17),				-- goal keeper
      2  => Coordinate'(45,24),				-- back 1
      3  => Coordinate'(45,17),				-- back 2
      4  => Coordinate'(45,10),				-- back 3
      5  => Coordinate'(36,17),				-- midfielder 1
      6  => Coordinate'(38,25),				-- midfielder 2
      7  => Coordinate'(38,9),				-- midfielder 3
      8  => Coordinate'(33,29),				-- midfielder 4
      9  => Coordinate'(33,5),				-- midfielder 5
      10 => Coordinate'(27,23),				-- forward 1
      11 => Coordinate'(27,11));			-- forward 2

   -- Formation Scheme 3-5-2: team 1 players' reference positions
   -- during an attack phase
   t1_352_att_pos : Positions_Array :=
     (1  => Coordinate'(1,17),				-- goal keeper
      2  => Coordinate'(25,17),				-- back 1
      3  => Coordinate'(28,9),				-- back 2
      4  => Coordinate'(28,25),				-- back 3
      5  => Coordinate'(36,17),				-- midfielder 1
      6  => Coordinate'(41,10),				-- midfielder 2
      7  => Coordinate'(41,24),				-- midfielder 3
      8  => Coordinate'(44,4),				-- midfielder 4
      9  => Coordinate'(44,30),				-- midfielder 5
      10 => Coordinate'(47,12),				-- forward 1
      11 => Coordinate'(47,22));			-- forward 2

   -- Formation Scheme 3-5-2: team 2 players' reference positions
   -- during an attack phase
   t2_352_att_pos : Positions_Array :=
     (1  => Coordinate'(51,17),				-- goal keeper
      2  => Coordinate'(27,17),				-- back 1
      3  => Coordinate'(24,25),				-- back 2
      4  => Coordinate'(24,9),				-- back 3
      5  => Coordinate'(16,17),				-- midfielder 1
      6  => Coordinate'(11,24),				-- midfielder 2
      7  => Coordinate'(11,10),				-- midfielder 3
      8  => Coordinate'(8,30),				-- midfielder 4
      9  => Coordinate'(8,4),				-- midfielder 5
      10 => Coordinate'(5,22),				-- forward 1
      11 => Coordinate'(5,12)); 			-- forward 2

   -- Formation Scheme 4-4-2: team 1 players' starting position
   t1_442_start_pos : Positions_Array :=
     (1  => Coordinate'(1,17),				-- goal keeper
      2  => Coordinate'(12,13),				-- back 1
      3  => Coordinate'(12,21),				-- back 2
      4  => Coordinate'(15,7),				-- back 3
      5  => Coordinate'(15,28),				-- back 4
      6  => Coordinate'(16,17),				-- midfielder 1
      7  => Coordinate'(20,11),				-- midfielder 2
      8  => Coordinate'(20,23),				-- midfielder 3
      9  => Coordinate'(22,17),				-- midfielder 4
      10 => Coordinate'(25,13),				-- forward 1
      11 => Coordinate'(25,21));			-- forward 2

   -- Formation Scheme 4-4-2: team 2 players' starting position
   t2_442_start_pos : Positions_Array :=
     (1  => Coordinate'(51,17),				-- goal keeper
      2  => Coordinate'(40,21),				-- back 1
      3  => Coordinate'(40,13),				-- back 2
      4  => Coordinate'(37,28),				-- back 3
      5  => Coordinate'(37,7),				-- back 4
      6  => Coordinate'(36,17),				-- midfielder 1
      7  => Coordinate'(32,23),				-- midfielder 2
      8  => Coordinate'(32,11),				-- midfielder 3
      9  => Coordinate'(30,17),				-- midfielder 4
      10 => Coordinate'(27,21),				-- forward 1
      11 => Coordinate'(27,13));			-- forward 2

   -- Formation Scheme 4-4-2: team 1 players' reference positions
   -- during a defense phase
   t1_442_def_pos : Positions_Array :=
     (1  => Coordinate'(1,17),				-- goal keeper
      2  => Coordinate'(6,13),				-- back 1
      3  => Coordinate'(6,21),				-- back 2
      4  => Coordinate'(9,7),				-- back 3
      5  => Coordinate'(9,27),				-- back 4
      6  => Coordinate'(11,17),				-- midfielder 1
      7  => Coordinate'(16,10),				-- midfielder 2
      8  => Coordinate'(16,24),				-- midfielder 3
      9  => Coordinate'(19,17),				-- midfielder 4
      10 => Coordinate'(25,13),				-- forward 1
      11 => Coordinate'(25,21));			-- forward 2

   -- Formation Scheme 4-4-2: team 2 players' reference positions
   -- during a defense phase
   t2_442_def_pos : Positions_Array :=
     (1  => Coordinate'(51,17),				-- goal keeper
      2  => Coordinate'(45,21),				-- back 1
      3  => Coordinate'(45,13),				-- back 2
      4  => Coordinate'(43,27),				-- back 3
      5  => Coordinate'(43,7),				-- back 4
      6  => Coordinate'(41,17),				-- midfielder 1
      7  => Coordinate'(36,24),				-- midfielder 2
      8  => Coordinate'(36,10),				-- midfielder 3
      9  => Coordinate'(33,17),				-- midfielder 4
      10 => Coordinate'(27,12),				-- forward 1
      11 => Coordinate'(27,13));			-- forward 2

   -- Formation Scheme 4-4-2: team 1 players' reference positions
   -- during an attack phase
   t1_442_att_pos : Positions_Array :=
     (1  => Coordinate'(1,17),				-- goal keeper
      2  => Coordinate'(28,13),				-- back 1
      3  => Coordinate'(28,21),				-- back 2
      4  => Coordinate'(31,5),				-- back 3
      5  => Coordinate'(31,29),				-- back 4
      6  => Coordinate'(33,17),				-- midfielder 1
      7  => Coordinate'(38,9),				-- midfielder 2
      8  => Coordinate'(38,25),				-- midfielder 3
      9  => Coordinate'(43,17),				-- midfielder 4
      10 => Coordinate'(47,15),				-- forward 1
      11 => Coordinate'(47,19));			-- forward 2

   -- Formation Scheme 4-4-2: team 2 players' reference positions
   -- during an attack phase
   t2_442_att_pos : Positions_Array :=
     (1  => Coordinate'(51,17),				-- goal keeper
      2  => Coordinate'(24,21),				-- back 1
      3  => Coordinate'(24,13),				-- back 2
      4  => Coordinate'(21,29),				-- back 3
      5  => Coordinate'(21,5),				-- back 4
      6  => Coordinate'(19,17),				-- midfielder 1
      7  => Coordinate'(14,25),				-- midfielder 2
      8  => Coordinate'(14,9),				-- midfielder 3
      9  => Coordinate'(9,17),				-- midfielder 4
      10 => Coordinate'(5,19),				-- forward 1
      11 => Coordinate'(5,15));				-- forward 2

   -- Formation Scheme 5-3-2: team 1 players' starting position
   t1_532_start_pos : Positions_Array :=
     (1  => Coordinate'(1,17),				-- goal keeper
      2  => Coordinate'(13,10),				-- back 1
      3  => Coordinate'(13,17),				-- back 2
      4  => Coordinate'(13,24),				-- back 3
      5  => Coordinate'(15,7),				-- back 4
      6  => Coordinate'(15,28),				-- back 5
      7  => Coordinate'(19,17),				-- midfielder 1
      8  => Coordinate'(21,9),				-- midfielder 2
      9  => Coordinate'(21,25),				-- midfielder 3
      10 => Coordinate'(25,13),				-- forward 1
      11 => Coordinate'(25,21));			-- forward 2

   -- Formation Scheme 5-3-2: team 2 players' starting position
   t2_532_start_pos : Positions_Array :=
     (1  => Coordinate'(51,17),				-- goal keeper
      2  => Coordinate'(39,24),				-- back 1
      3  => Coordinate'(39,17),				-- back 2
      4  => Coordinate'(39,10),				-- back 3
      5  => Coordinate'(37,28),				-- back 3
      6  => Coordinate'(37,7),				-- back 4
      7  => Coordinate'(33,17),			        -- midfielder 1
      8  => Coordinate'(31,25),				-- midfielder 2
      9  => Coordinate'(31,9),				-- midfielder 3
      10 => Coordinate'(27,21),				-- forward 1
      11 => Coordinate'(27,13));			-- forward 2

   -- Formation Scheme 5-3-2: team 1 players' reference positions
   -- during a defense phase
   t1_532_def_pos : Positions_Array :=
     (1  => Coordinate'(1,17),				-- goal keeper
      2  => Coordinate'(7,10),				-- back 1
      3  => Coordinate'(7,24),				-- back 2
      4  => Coordinate'(8,17),				-- back 3
      5  => Coordinate'(9,7),				-- back 4
      6  => Coordinate'(9,27),				-- back 5
      7  => Coordinate'(16,10),				-- midfielder 1
      8  => Coordinate'(16,17),				-- midfielder 2
      9  => Coordinate'(16,24),				-- midfielder 3
      10 => Coordinate'(23,14),				-- forward 1
      11 => Coordinate'(23,20));			-- forward 2

   -- Formation Scheme 5-3-2: team 2 players' reference positions
   -- during a defense phase
   t2_532_def_pos : Positions_Array :=
     (1  => Coordinate'(51,17),				-- goal keeper
      2  => Coordinate'(45,24),				-- back 1
      3  => Coordinate'(45,10),				-- back 2
      4  => Coordinate'(44,17),				-- back 3
      5  => Coordinate'(43,27),				-- back 4
      6  => Coordinate'(43,7),				-- back 5
      7  => Coordinate'(36,24),				-- midfielder 1
      8  => Coordinate'(36,17),				-- midfielder 2
      9  => Coordinate'(36,10),				-- midfielder 3
      10 => Coordinate'(29,20),				-- forward 1
      11 => Coordinate'(29,14));			-- forward 2

   -- Formation Scheme 5-3-2: team 1 players' reference positions
   -- during an attack phase
   t1_532_att_pos : Positions_Array :=
     (1  => Coordinate'(1,17),				-- goal keeper
      2  => Coordinate'(28,11),				-- back 1
      3  => Coordinate'(28,23),				-- back 2
      4  => Coordinate'(31,5),				-- back 3
      5  => Coordinate'(31,17),				-- back 4
      6  => Coordinate'(31,29),				-- back 5
      7  => Coordinate'(38,17),				-- midfielder 1
      8  => Coordinate'(41,10),				-- midfielder 2
      9  => Coordinate'(41,24),				-- midfielder 3
      10 => Coordinate'(47,14),				-- forward 1
      11 => Coordinate'(47,20));			-- forward 2

   -- Formation Scheme 5-3-2: team 2 players' reference positions
   -- during an attack phase
   t2_532_att_pos : Positions_Array :=
     (1  => Coordinate'(51,17),				-- goal keeper
      2  => Coordinate'(24,23),				-- back 1
      3  => Coordinate'(24,11),				-- back 2
      4  => Coordinate'(21,29),				-- back 3
      5  => Coordinate'(21,17),				-- back 4
      6  => Coordinate'(21,5),				-- back 5
      7  => Coordinate'(14,17),				-- midfielder 1
      8  => Coordinate'(11,24),				-- midfielder 2
      9  => Coordinate'(11,10),				-- midfielder 3
      10 => Coordinate'(5,20),				-- forward 1
      11 => Coordinate'(5,14));				-- forward 2

   team_one_balanced_positions : Positions_Array;
   team_one_defensive_positions : Positions_Array;

   --+ contengono SOLO i giocatori che sono in campo
   -- Formation Scheme : 3-5-2. Team 1 starting positions
   team_one_offensive_formation : Formation_Scheme :=
     Formation_Scheme'(id        => O_352,
                       positions => t1_352_start_pos);

    -- Formation Scheme : 3-5-2. Team 2 starting positions
   team_two_offensive_formation : Formation_Scheme :=
     Formation_Scheme'(id        => O_352,
                       positions => t2_352_start_pos);

   team_one_balanced_formation : Formation_Scheme :=
     Formation_Scheme'(id        => B_442,
                       positions => team_one_balanced_positions);

   team_one_defensive_formation : Formation_Scheme :=
     Formation_Scheme'(id        => D_532,
		       positions => team_one_defensive_positions);

   players_coord : array (0 .. total_players) of Coordinate := (Coordinate'(0,5),
								Coordinate'(5,5),--);
								Coordinate'(25,13),
								Coordinate'(17,9),
								Coordinate'(10,18),
								Coordinate'(28,2),
								Coordinate'(6,6),
								Coordinate'(14,15),
								Coordinate'(20,10),
								Coordinate'(12,12),
								Coordinate'(15,8));

end Soccer.TeamPkg;
