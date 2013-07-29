with Soccer.Core_Event.Game_Core_Event; use Soccer.Core_Event.Game_Core_Event;
with Ada.Containers.Vectors;     use Ada.Containers;
with Soccer.Manager_Event; use Soccer.Manager_Event;

package Soccer.ControllerPkg.Referee is

   procedure Notify_Game_Event (event : Game_Event_Ptr);

   procedure Pre_Check (e : in Motion_Event_Ptr);

   procedure Post_Check;

   procedure Notify_Manager_Event (event : Manager_Event.Event_Ptr);

   procedure Set_Last_Ball_Holder (holder : Integer);

   function Get_Nearest_Player (event_coord : in Coordinate; team : in Team_Id) return Integer;

private
   game_event : Game_Event_Ptr;
   package Manager_Events_Container is new Vectors (Natural, Manager_Event.Event_Ptr);
   manager_events : Manager_Events_Container.Vector;
   last_ball_holder : Integer;

   pending_substitutions : Substitutions_Container.Vector;

end Soccer.ControllerPkg.Referee;
