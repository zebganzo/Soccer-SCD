with Ada.Real_Time.Timing_Events;

generic
   One_Shot : Boolean := True;
   Timer_Name : String := "Generic_Timers";
   with procedure Action is <>;

package Soccer.Generic_Timers is

   Timer_Error : exception;

   procedure Start (time : Integer; is_millis : Boolean);
   procedure Stop;
   procedure Cancel;

private

   int_duration : Integer;
   using_millis : Boolean;
   The_Event : Ada.Real_Time.Timing_Events.Timing_Event;

end Soccer.Generic_Timers;
