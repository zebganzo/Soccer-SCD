with Soccer.Core_Event.Game_Core_Event; use Soccer.Core_Event.Game_Core_Event;
with Ada.Containers.Vectors;     use Ada.Containers;
with Soccer.Manager_Event; use Soccer.Manager_Event;
with Soccer.Core_Event.Game_Core_Event.Binary_Game_Event; use Soccer.Core_Event.Game_Core_Event.Binary_Game_Event;
with Soccer.BallPkg; use Soccer.BallPkg;
with Soccer.Manager_Event.Formation; use Soccer.Manager_Event.Formation;
with Soccer.Manager_Event.Substitution; use Soccer.Manager_Event.Substitution;
with Soccer.Core_Event.Game_Core_Event.Unary_Game_Event; use Soccer.Core_Event.Game_Core_Event.Unary_Game_Event;
with Soccer.Utils; use Soccer.Utils;
with Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event; use Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with Soccer.Generic_Timers;

package Soccer.ControllerPkg.Referee is

   --+-------------
   debug : Boolean := True;
   --+-------------

   pragma Suppress (Elaboration_Check);

   procedure Notify_Game_Event (event : Game_Event_Ptr);

   procedure Pre_Check (e : in Motion_Event_Ptr);

   procedure Post_Check;

   procedure Notify_Manager_Event (event : Manager_Event.Event_Ptr);

   procedure Set_Last_Ball_Holder (holder : Integer);

   function Get_Last_Ball_Holder return Integer;

   function Get_Nearest_Player (event_coord : in Coordinate; team : in Team_Id) return Integer;

   function Get_Nearest_Field_Player (event_coord : in Coordinate; team : in Team_Id) return Integer;

   function Get_Opposing_Team (current_team : Team_Id) return Team_Id;

   function TEMP_Get_Substitutions return Substitutions_Container.Vector;

   procedure Simulate_End_Of_1T;
   procedure Simulate_Begin_Of_2T;
   procedure Simulate_End_Of_Match;
   procedure Simulate_Substitution;

   procedure End_Of_First_Half;
   procedure End_Of_Second_Half;

private
   game_event : Game_Event_Ptr;
   package Manager_Events_Container is new Vectors (Natural, Manager_Event.Event_Ptr);
   manager_events : Manager_Events_Container.Vector;
   last_ball_holder : Integer;

   pending_substitutions : Substitutions_Container.Vector;

   -- Timer
   half_time_span : constant Time_Span := Seconds (half_game_duration);
   id : constant String := "[TIMER] Half game timer";
   package Game_Timer_First_Half is new Generic_Timers (True, id, half_time_span, End_Of_First_Half);
   package Game_Timer_Second_Half is new Generic_Timers (True, id, half_time_span, End_Of_Second_Half);

end Soccer.ControllerPkg.Referee;
