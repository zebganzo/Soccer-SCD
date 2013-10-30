
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

   procedure Update_Map (subbed_player : Integer; new_player : Integer; team : Team_Id);

   function Get_Formation_Id (number : Integer; team : Team_Id) return Integer;

   function Get_Number_From_Formation (formation_id : Integer;
                                       team         : Team_Id) return Integer;

   procedure Set_Teams (first_team : Team_Ptr; second_team : Team_Ptr);

   function Get_Team (team : Team_Id) return Team_Ptr;

   procedure Set_Formation (team : in Team_Ptr; formation : in Formation_Scheme_Id);

   function To_String (team : in Team_Id) return String;

   function Get_Coordinate_For_Player (my_team     : in Team_Id;
                                       holder_team : in Team_Id;
                                       number      : in Integer) return Coordinate;

   function Get_Goalkeeper_Number (team : in Team_Id) return Integer;

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

   -- returns player's goal kick position, given his number and his team
   function Get_Goal_Kick_Position(number : in Integer;
                                   team   : in Team_Id) return Coordinate;

    -- returns player's corner kick position, given his number and his team
   function Get_Corner_Kick_Position(number 	 : in Integer;
                                     team   	 : in Team_Id;
                                     holder_team : in Team_Id) return Coordinate;

   -- returns player's penalty kick position, given his number and his team
   function Get_Penalty_Kick_Position(number 	  : in Integer;
                                      team   	  : in Team_Id;
                                      holder_team : in Team_Id) return Coordinate;

   -- returns player's attack statistic
   function Get_Attack(number : in Integer;
                       team   : Team_Id) return Integer;

   -- returns player's defense statistic
   function Get_Defense(number : in Integer;
                        team   : Team_Id) return Integer;

   -- returns player's goal_keeping statistic
   function Get_Goal_Keeping(number : in Integer;
                             team   : Team_Id) return Integer;

   -- returns player's power statistic
   function Get_Power(number : in Integer;
                      team   : Team_Id) return Integer;

   -- returns player's precision statistic
   function Get_Precision(number : in Integer;
                          team   : Team_Id) return Integer;

   -- returns player's speed statistic
   function Get_Speed(number : in Integer;
                      team   : Team_Id) return Integer;

   -- returns player's tackle statistic
   function Get_Tackle(number : in Integer;
                       team   : Team_Id) return Integer;

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
     (1  => Coordinate'(8,17),				-- goal keeper
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
     (1  => Coordinate'(44,17),				-- goal keeper
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

   -- Formation Scheme 3-5-2: team 1 players' reference positions
   -- during a goal kick event
   t1_352_gkick_pos : Positions_Array :=
     (1  => Coordinate'(1,17),				-- goal keeper
      2  => Coordinate'(10,8),				-- back 1
      3  => Coordinate'(10,17),				-- back 2
      4  => Coordinate'(10,26),				-- back 3
      5  => Coordinate'(18,17),				-- midfielder 1
      6  => Coordinate'(23,11),				-- midfielder 2
      7  => Coordinate'(23,23),				-- midfielder 3
      8  => Coordinate'(28,6),				-- midfielder 4
      9  => Coordinate'(28,28),				-- midfielder 5
      10 => Coordinate'(36,11),				-- forward 1
      11 => Coordinate'(36,23));			-- forward 2

   -- Formation Scheme 3-5-2: team 2 players' reference positions
   -- during a goal kick event
   t2_352_gkick_pos : Positions_Array :=
     (1  => Coordinate'(51,17),				-- goal keeper
      2  => Coordinate'(42,26),				-- back 1
      3  => Coordinate'(42,17),				-- back 2
      4  => Coordinate'(42,8),				-- back 3
      5  => Coordinate'(34,17),				-- midfielder 1
      6  => Coordinate'(29,23),				-- midfielder 2
      7  => Coordinate'(29,11),				-- midfielder 3
      8  => Coordinate'(24,28),				-- midfielder 4
      9  => Coordinate'(24,6),				-- midfielder 5
      10 => Coordinate'(16,23),				-- forward 1
      11 => Coordinate'(16,11));			-- forward 2

   -- Formation Scheme 3-5-2: team 1 players' reference positions
   -- during a corner kick event assigned to team 1
   t1_352_att_corner_pos : Positions_Array :=
     (1  => Coordinate'(8,17),				-- goal keeper
      2  => Coordinate'(31,6),				-- back 1
      3  => Coordinate'(31,17),				-- back 2
      4  => Coordinate'(31,28),				-- back 3
      5  => Coordinate'(43,7),				-- midfielder 1
      6  => Coordinate'(43,27),				-- midfielder 2
      7  => Coordinate'(46,21),				-- midfielder 3
      8  => Coordinate'(47,15),				-- midfielder 4
      9  => Coordinate'(48,19),				-- midfielder 5
      10 => Coordinate'(50,13),				-- forward 1
      11 => Coordinate'(50,20));			-- forward 2

   -- Formation Scheme 3-5-2: team 2 players' reference positions
   -- during a corner kick event assigned to team 2
   t2_352_att_corner_pos : Positions_Array :=
     (1  => Coordinate'(44,17),				-- goal keeper
      2  => Coordinate'(21,28),				-- back 1
      3  => Coordinate'(21,17),				-- back 2
      4  => Coordinate'(21,6),				-- back 3
      5  => Coordinate'(9,27),				-- midfielder 1
      6  => Coordinate'(9,7),				-- midfielder 2
      7  => Coordinate'(6,21),				-- midfielder 3
      8  => Coordinate'(5,15),				-- midfielder 4
      9  => Coordinate'(4,19),				-- midfielder 5
      10 => Coordinate'(2,20),				-- forward 1
      11 => Coordinate'(2,13));				-- forward 2

   -- Formation Scheme 3-5-2: team 1 players' reference positions
   -- during a corner kick event assigned to team 2
   t1_352_def_corner_pos : Positions_Array :=
     (1  => Coordinate'(1,17),				-- goal keeper
      2  => Coordinate'(2,15),				-- back 1
      3  => Coordinate'(2,19),				-- back 2
      4  => Coordinate'(3,23),				-- back 3
      5  => Coordinate'(4,11),				-- midfielder 1
      6  => Coordinate'(4,17),				-- midfielder 2
      7  => Coordinate'(6,20),				-- midfielder 3
      8  => Coordinate'(7,13),				-- midfielder 4
      9  => Coordinate'(9,17),				-- midfielder 5
      10 => Coordinate'(18,13),				-- forward 1
      11 => Coordinate'(18,21));			-- forward 2

   -- Formation Scheme 3-5-2: team 2 players' reference positions
   -- during a corner kick event assigned to team 1
   t2_352_def_corner_pos : Positions_Array :=
     (1  => Coordinate'(51,17),				-- goal keeper
      2  => Coordinate'(50,19),				-- back 1
      3  => Coordinate'(50,15),				-- back 2
      4  => Coordinate'(49,23),				-- back 3
      5  => Coordinate'(48,17),				-- midfielder 1
      6  => Coordinate'(48,11),				-- midfielder 2
      7  => Coordinate'(46,20),				-- midfielder 3
      8  => Coordinate'(45,13),				-- midfielder 4
      9  => Coordinate'(43,17),				-- midfielder 5
      10 => Coordinate'(34,21),				-- forward 1
      11 => Coordinate'(34,13));			-- forward 2

   -- Formation Scheme 3-5-2: team 1 players' reference positions
   -- during a penalty kick event assigned to team 1
   t1_352_att_penalty_pos : Positions_Array :=
     (1  => Coordinate'(8,17),				-- goal keeper
      2  => Coordinate'(31,17),				-- back 1
      3  => Coordinate'(33,10),				-- back 2
      4  => Coordinate'(33,24),				-- back 3
      5  => Coordinate'(41,16),				-- midfielder 1
      6  => Coordinate'(43,12),				-- midfielder 2
      7  => Coordinate'(43,14),				-- midfielder 3
      8  => Coordinate'(43,20),				-- midfielder 4
      9  => Coordinate'(43,22),				-- midfielder 5
      10 => Coordinate'(43,16),				-- forward 1
      11 => Coordinate'(43,18));			-- forward 2

   -- Formation Scheme 3-5-2: team 2 players' reference positions
   -- during a penalty kick event assigned to team 2
   t2_352_att_penalty_pos : Positions_Array :=
     (1  => Coordinate'(44,17),				-- goal keeper
      2  => Coordinate'(21,17),				-- back 1
      3  => Coordinate'(19,24),				-- back 2
      4  => Coordinate'(19,10),				-- back 3
      5  => Coordinate'(11,16),				-- midfielder 1
      6  => Coordinate'(9,20),				-- midfielder 2
      7  => Coordinate'(9,14),				-- midfielder 3
      8  => Coordinate'(9,22),				-- midfielder 4
      9  => Coordinate'(9,12),				-- midfielder 5
      10 => Coordinate'(9,18),				-- forward 1
      11 => Coordinate'(9,16));				-- forward 2

   -- Formation Scheme 3-5-2: team 1 players' reference positions
   -- during a penalty kick event assigned to team 2
   t1_352_def_penalty_pos : Positions_Array :=
     (1  => Coordinate'(1,17),				-- goal keeper
      2  => Coordinate'(9,17),				-- back 1
      3  => Coordinate'(9,15),				-- back 2
      4  => Coordinate'(9,19),				-- back 3
      5  => Coordinate'(9,13),				-- midfielder 1
      6  => Coordinate'(9,21),				-- midfielder 2
      7  => Coordinate'(9,11),				-- midfielder 3
      8  => Coordinate'(9,23),				-- midfielder 4
      9  => Coordinate'(11,17),				-- midfielder 5
      10 => Coordinate'(14,15),				-- forward 1
      11 => Coordinate'(14,19));			-- forward 2

   -- Formation Scheme 3-5-2: team 2 players' reference positions
   -- during a penalty kick event assigned to team 1
   t2_352_def_penalty_pos : Positions_Array :=
     (1  => Coordinate'(51,17),				-- goal keeper
      2  => Coordinate'(43,19),				-- back 1
      3  => Coordinate'(43,17),				-- back 2
      4  => Coordinate'(43,15),				-- back 3
      5  => Coordinate'(41,17),				-- midfielder 1
      6  => Coordinate'(43,21),				-- midfielder 2
      7  => Coordinate'(43,13),				-- midfielder 3
      8  => Coordinate'(43,23),				-- midfielder 4
      9  => Coordinate'(43,11),				-- midfielder 5
      10 => Coordinate'(38,19),				-- forward 1
      11 => Coordinate'(38,15));			-- forward 2

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
     (1  => Coordinate'(8,17),				-- goal keeper
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
     (1  => Coordinate'(44,17),				-- goal keeper
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

   -- Formation Scheme 4-4-2: team 1 players' reference positions
   -- during a goal kick event
   t1_442_gkick_pos : Positions_Array :=
     (1  => Coordinate'(1,17),				-- goal keeper
      2  => Coordinate'(9,11),				-- back 1
      3  => Coordinate'(9,23),				-- back 2
      4  => Coordinate'(12,4),				-- back 3
      5  => Coordinate'(12,30),				-- back 4
      6  => Coordinate'(16,17),				-- midfielder 1
      7  => Coordinate'(24,8),				-- midfielder 2
      8  => Coordinate'(24,26),				-- midfielder 3
      9  => Coordinate'(27,17),				-- midfielder 4
      10 => Coordinate'(34,13),				-- forward 1
      11 => Coordinate'(34,21));			-- forward 2

   -- Formation Scheme 4-4-2: team 2 players' reference positions
   -- during a goal kick event
   t2_442_gkick_pos : Positions_Array :=
     (1  => Coordinate'(51,17),				-- goal keeper
      2  => Coordinate'(43,23),				-- back 1
      3  => Coordinate'(43,11),				-- back 2
      4  => Coordinate'(40,30),				-- back 3
      5  => Coordinate'(40,4),				-- back 4
      6  => Coordinate'(36,17),				-- midfielder 1
      7  => Coordinate'(28,26),				-- midfielder 2
      8  => Coordinate'(28,8),				-- midfielder 3
      9  => Coordinate'(25,17),				-- midfielder 4
      10 => Coordinate'(18,21),				-- forward 1
      11 => Coordinate'(18,13));			-- forward 2

   -- Formation Scheme 4-4-2: team 1 players' reference positions
   -- during a corner kick event assigned to team 1
   t1_442_att_corner_pos : Positions_Array :=
     (1  => Coordinate'(8,17),				-- goal keeper
      2  => Coordinate'(28,14),				-- back 1
      3  => Coordinate'(28,20),				-- back 2
      4  => Coordinate'(31,6),				-- back 3
      5  => Coordinate'(31,28),				-- back 4
      6  => Coordinate'(44,14),				-- midfielder 1
      7  => Coordinate'(44,19),				-- midfielder 2
      8  => Coordinate'(46,11),				-- midfielder 3
      9  => Coordinate'(46,22),				-- midfielder 4
      10 => Coordinate'(49,15),				-- forward 1
      11 => Coordinate'(49,19));			-- forward 2

   -- Formation Scheme 4-4-2: team 2 players' reference positions
   -- during a corner kick event assigned to team 2
   t2_442_att_corner_pos : Positions_Array :=
     (1  => Coordinate'(44,17),				-- goal keeper
      2  => Coordinate'(24,20),				-- back 1
      3  => Coordinate'(24,14),				-- back 2
      4  => Coordinate'(21,28),				-- back 3
      5  => Coordinate'(21,6),				-- back 4
      6  => Coordinate'(8,19),				-- midfielder 1
      7  => Coordinate'(8,14),				-- midfielder 2
      8  => Coordinate'(6,22),				-- midfielder 3
      9  => Coordinate'(6,11),				-- midfielder 4
      10 => Coordinate'(3,19),				-- forward 1
      11 => Coordinate'(3,15));				-- forward 2

   -- Formation Scheme 4-4-2: team 1 players' reference positions
   -- during a corner kick event assigned to team 2
   t1_442_def_corner_pos : Positions_Array :=
     (1  => Coordinate'(1,17),				-- goal keeper
      2  => Coordinate'(2,15),				-- back 1
      3  => Coordinate'(2,19),				-- back 2
      4  => Coordinate'(3,12),				-- back 3
      5  => Coordinate'(3,22),				-- back 4
      6  => Coordinate'(5,18),				-- midfielder 1
      7  => Coordinate'(6,15),				-- midfielder 2
      8  => Coordinate'(10,10),				-- midfielder 3
      9  => Coordinate'(10,24),				-- midfielder 4
      10 => Coordinate'(18,13),				-- forward 1
      11 => Coordinate'(18,21));			-- forward 2

   -- Formation Scheme 4-4-2: team 2 players' reference positions
   -- during a corner kick event assigned to team 1
   t2_442_def_corner_pos : Positions_Array :=
     (1  => Coordinate'(51,17),				-- goal keeper
      2  => Coordinate'(50,19),				-- back 1
      3  => Coordinate'(50,15),				-- back 2
      4  => Coordinate'(49,22),				-- back 3
      5  => Coordinate'(49,12),				-- back 4
      6  => Coordinate'(47,18),				-- midfielder 1
      7  => Coordinate'(46,15),				-- midfielder 2
      8  => Coordinate'(42,24),				-- midfielder 3
      9  => Coordinate'(42,10),				-- midfielder 4
      10 => Coordinate'(34,21),				-- forward 1
      11 => Coordinate'(34,13));			-- forward 2

   -- Formation Scheme 4-4-2: team 1 players' reference positions
   -- during a penalty kick event assigned to team 1
   t1_442_att_penalty_pos : Positions_Array :=
     (1  => Coordinate'(8,17),				-- goal keeper
      2  => Coordinate'(34,14),				-- back 1
      3  => Coordinate'(34,20),				-- back 2
      4  => Coordinate'(35,11),				-- back 3
      5  => Coordinate'(35,23),				-- back 4
      6  => Coordinate'(43,14),				-- midfielder 1
      7  => Coordinate'(43,20),				-- midfielder 2
      8  => Coordinate'(43,12),				-- midfielder 3
      9  => Coordinate'(43,22),				-- midfielder 4
      10 => Coordinate'(43,16),				-- forward 1
      11 => Coordinate'(43,18));			-- forward 2

   -- Formation Scheme 4-4-2: team 2 players' reference positions
   -- during a penalty kick event assigned to team 2
   t2_442_att_penalty_pos : Positions_Array :=
     (1  => Coordinate'(44,17),				-- goal keeper
      2  => Coordinate'(18,20),				-- back 1
      3  => Coordinate'(18,14),				-- back 2
      4  => Coordinate'(17,23),				-- back 3
      5  => Coordinate'(17,11),				-- back 4
      6  => Coordinate'(9,20),				-- midfielder 1
      7  => Coordinate'(9,14),				-- midfielder 2
      8  => Coordinate'(9,22),				-- midfielder 3
      9  => Coordinate'(9,12),				-- midfielder 4
      10 => Coordinate'(9,18),				-- forward 1
      11 => Coordinate'(9,16));				-- forward 2

   -- Formation Scheme 4-4-2: team 1 players' reference positions
   -- during a penalty kick event assigned to team 2
   t1_442_def_penalty_pos : Positions_Array :=
     (1  => Coordinate'(1,17),				-- goal keeper
      2  => Coordinate'(9,15),				-- back 1
      3  => Coordinate'(9,19),				-- back 2
      4  => Coordinate'(11,17),				-- back 3
      5  => Coordinate'(9,17),				-- back 4
      6  => Coordinate'(9,13),				-- midfielder 1
      7  => Coordinate'(9,21),				-- midfielder 2
      8  => Coordinate'(9,11),				-- midfielder 3
      9  => Coordinate'(9,23),				-- midfielder 4
      10 => Coordinate'(15,13),				-- forward 1
      11 => Coordinate'(15,21));			-- forward 2

   -- Formation Scheme 4-4-2: team 2 players' reference positions
   -- during a penalty kick event assigned to team 1
   t2_442_def_penalty_pos : Positions_Array :=
     (1  => Coordinate'(51,17),				-- goal keeper
      2  => Coordinate'(43,19),				-- back 1
      3  => Coordinate'(43,15),				-- back 2
      4  => Coordinate'(43,17),				-- back 3
      5  => Coordinate'(41,17),				-- back 4
      6  => Coordinate'(43,21),				-- midfielder 1
      7  => Coordinate'(43,13),				-- midfielder 2
      8  => Coordinate'(43,23),				-- midfielder 3
      9  => Coordinate'(43,11),				-- midfielder 4
      10 => Coordinate'(37,21),				-- forward 1
      11 => Coordinate'(37,13));			-- forward 2

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
      5  => Coordinate'(37,28),				-- back 4
      6  => Coordinate'(37,7),				-- back 5
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
     (1  => Coordinate'(8,17),				-- goal keeper
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
     (1  => Coordinate'(44,17),				-- goal keeper
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

   -- Formation Scheme 5-3-2: team 1 players' reference positions
   -- during a goal kick event
   t1_532_gkick_pos : Positions_Array :=
     (1  => Coordinate'(1,17),				-- goal keeper
      2  => Coordinate'(9,11),				-- back 1
      3  => Coordinate'(9,17),				-- back 2
      4  => Coordinate'(9,23),				-- back 3
      5  => Coordinate'(12,4),				-- back 4
      6  => Coordinate'(12,30),				-- back 5
      7  => Coordinate'(20,17),				-- midfielder 1
      8  => Coordinate'(24,8),				-- midfielder 2
      9  => Coordinate'(24,26),				-- midfielder 3
      10 => Coordinate'(34,13),				-- forward 1
      11 => Coordinate'(34,21));			-- forward 2

   -- Formation Scheme 5-3-2: team 2 players' reference positions
   -- during a goal kick event
   t2_532_gkick_pos : Positions_Array :=
     (1  => Coordinate'(51,17),				-- goal keeper
      2  => Coordinate'(43,23),				-- back 1
      3  => Coordinate'(43,17),				-- back 2
      4  => Coordinate'(43,11),				-- back 3
      5  => Coordinate'(40,30),				-- back 4
      6  => Coordinate'(40,4),				-- back 5
      7  => Coordinate'(32,17),				-- midfielder 1
      8  => Coordinate'(28,26),				-- midfielder 2
      9  => Coordinate'(28,8),				-- midfielder 3
      10 => Coordinate'(18,21),				-- forward 1
      11 => Coordinate'(18,13));			-- forward 2

   -- Formation Scheme 5-3-2: team 1 players' reference positions
   -- during a corner kick event assigned to team 1
   t1_532_att_corner_pos : Positions_Array :=
     (1  => Coordinate'(8,17),				-- goal keeper
      2  => Coordinate'(30,17),				-- back 1
      3  => Coordinate'(33,10),				-- back 2
      4  => Coordinate'(33,24),				-- back 3
      5  => Coordinate'(35,4),				-- back 4
      6  => Coordinate'(35,30),				-- back 5
      7  => Coordinate'(44,16),				-- midfielder 1
      8  => Coordinate'(47,12),				-- midfielder 2
      9  => Coordinate'(47,22),				-- midfielder 3
      10 => Coordinate'(49,15),				-- forward 1
      11 => Coordinate'(49,19));			-- forward 2

   -- Formation Scheme 5-3-2: team 2 players' reference positions
   -- during a corner kick event assigned to team 2
   t2_532_att_corner_pos : Positions_Array :=
     (1  => Coordinate'(44,17),				-- goal keeper
      2  => Coordinate'(22,17),				-- back 1
      3  => Coordinate'(19,24),				-- back 2
      4  => Coordinate'(19,10),				-- back 3
      5  => Coordinate'(17,30),				-- back 4
      6  => Coordinate'(17,4),				-- back 5
      7  => Coordinate'(8,16),				-- midfielder 1
      8  => Coordinate'(5,22),				-- midfielder 2
      9  => Coordinate'(5,12),				-- midfielder 3
      10 => Coordinate'(3,19),				-- forward 1
      11 => Coordinate'(3,15));				-- forward 2

   -- Formation Scheme 5-3-2: team 1 players' reference positions
   -- during a corner kick event assigned to team 2
   t1_532_def_corner_pos : Positions_Array :=
     (1  => Coordinate'(1,17),				-- goal keeper
      2  => Coordinate'(3,17),				-- back 1
      3  => Coordinate'(5,14),				-- back 2
      4  => Coordinate'(5,19),				-- back 3
      5  => Coordinate'(7,22),				-- back 4
      6  => Coordinate'(8,10),				-- back 5
      7  => Coordinate'(8,17),				-- midfielder 1
      8  => Coordinate'(12,13),				-- midfielder 2
      9  => Coordinate'(12,21),				-- midfielder 3
      10 => Coordinate'(18,14),				-- forward 1
      11 => Coordinate'(18,20));			-- forward 2

   -- Formation Scheme 5-3-2: team 2 players' reference positions
   -- during a corner kick event assigned to team 1
   t2_532_def_corner_pos : Positions_Array :=
     (1  => Coordinate'(51,17),				-- goal keeper
      2  => Coordinate'(49,17),				-- back 1
      3  => Coordinate'(47,19),				-- back 2
      4  => Coordinate'(47,14),				-- back 3
      5  => Coordinate'(45,22),				-- back 4
      6  => Coordinate'(44,17),				-- back 5
      7  => Coordinate'(44,10),				-- midfielder 1
      8  => Coordinate'(40,21),				-- midfielder 2
      9  => Coordinate'(40,13),				-- midfielder 3
      10 => Coordinate'(34,20),				-- forward 1
      11 => Coordinate'(34,14));			-- forward 2

   -- Formation Scheme 5-3-2: team 1 players' reference positions
   -- during a penalty kick event assigned to team 1
   t1_532_att_penalty_pos : Positions_Array :=
     (1  => Coordinate'(8,17),				-- goal keeper
      2  => Coordinate'(31,17),				-- back 1
      3  => Coordinate'(33,12),				-- back 2
      4  => Coordinate'(33,22),				-- back 3
      5  => Coordinate'(36,9),				-- back 4
      6  => Coordinate'(36,25),				-- back 5
      7  => Coordinate'(41,17),				-- midfielder 1
      8  => Coordinate'(43,14),				-- midfielder 2
      9  => Coordinate'(43,20),				-- midfielder 3
      10 => Coordinate'(43,16),				-- forward 1
      11 => Coordinate'(43,18));			-- forward 2

   -- Formation Scheme 5-3-2: team 2 players' reference positions
   -- during a penalty kick event assigned to team 2
   t2_532_att_penalty_pos : Positions_Array :=
     (1  => Coordinate'(44,17),				-- goal keeper
      2  => Coordinate'(21,17),				-- back 1
      3  => Coordinate'(19,22),				-- back 2
      4  => Coordinate'(19,12),				-- back 3
      5  => Coordinate'(16,25),				-- back 4
      6  => Coordinate'(16,9),				-- back 5
      7  => Coordinate'(11,17),				-- midfielder 1
      8  => Coordinate'(9,20),				-- midfielder 2
      9  => Coordinate'(9,14),				-- midfielder 3
      10 => Coordinate'(9,18),				-- forward 1
      11 => Coordinate'(9,16));				-- forward 2

   -- Formation Scheme 5-3-2: team 1 players' reference positions
   -- during a penalty kick event assigned to team 2
   t1_532_def_penalty_pos : Positions_Array :=
     (1  => Coordinate'(1,17),				-- goal keeper
      2  => Coordinate'(9,13),				-- back 1
      3  => Coordinate'(9,15),				-- back 2
      4  => Coordinate'(9,17),				-- back 3
      5  => Coordinate'(9,19),				-- back 4
      6  => Coordinate'(9,21),				-- back 5
      7  => Coordinate'(9,12),				-- midfielder 1
      8  => Coordinate'(9,22),				-- midfielder 2
      9  => Coordinate'(11,16),				-- midfielder 3
      10 => Coordinate'(16,16),				-- forward 1
      11 => Coordinate'(16,19));			-- forward 2

   -- Formation Scheme 5-3-2: team 2 players' reference positions
   -- during a penalty kick event assigned to team 1
   t2_532_def_penalty_pos : Positions_Array :=
     (1  => Coordinate'(51,17),				-- goal keeper
      2  => Coordinate'(43,21),				-- back 1
      3  => Coordinate'(43,19),				-- back 2
      4  => Coordinate'(43,17),				-- back 3
      5  => Coordinate'(43,15),				-- back 4
      6  => Coordinate'(43,13),				-- back 5
      7  => Coordinate'(43,22),				-- midfielder 1
      8  => Coordinate'(43,12),				-- midfielder 2
      9  => Coordinate'(41,16),				-- midfielder 3
      10 => Coordinate'(36,19),				-- forward 1
      11 => Coordinate'(36,16));			-- forward 2
end Soccer.TeamPkg;
