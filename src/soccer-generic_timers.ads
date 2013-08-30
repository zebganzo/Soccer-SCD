with Ada.Real_Time.Timing_Events;

generic
   One_Shot : Boolean := True;
   Timer_Name : String := "Generic_Timers";
   For_Duration : in Ada.Real_Time.Time_Span;
   with procedure Action is <>;

package Soccer.Generic_Timers is

   Timer_Error : exception;

   procedure Start;
   procedure Stop;
   procedure Cancel;

private

   The_Event : Ada.Real_Time.Timing_Events.Timing_Event;

end Soccer.Generic_Timers;
