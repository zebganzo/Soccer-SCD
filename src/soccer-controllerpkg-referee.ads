with Soccer.Core_Event.Game_Core_Event; use Soccer.Core_Event.Game_Core_Event;
with Ada.Containers.Vectors;     use Ada.Containers;
with Soccer.Manager_Event; use Soccer.Manager_Event;

package Soccer.ControllerPkg.Referee is

   procedure Notify_Game_Event (event : Game_Event_Prt);

   procedure Check;

   procedure Notify_Manager_Event (event : Manager_Event.Event_Ptr);

   procedure Set_Last_Ball_Holder (holder : Integer);

private
   game_event : Game_Event_Prt;
   package Manager_Events_Container is new Vectors (Natural, Manager_Event.Event_Ptr);
   manager_events : Manager_Events_Container.Vector;
   last_ball_holder : Integer;

end Soccer.ControllerPkg.Referee;
