with Ada.Real_Time; use Ada.Real_Time;
with Soccer.Generic_Timers;

package Soccer.Bridge.Output is

   type Event_Buffer_Element is
      record
         event : Soccer.Core_Event.Event_Ptr;
         time_start : Duration := 0.0;
         time_stop : Duration := 0.0;
      end record;

   type Event_Buffer_Type is array (1 .. buffer_dim) of Event_Buffer_Element;

   protected Buffer_Wrapper is

      procedure Put (new_event : Soccer.Core_Event.Event_Ptr);
      procedure Send;

   private

      size : Integer := 0;
      event_buffer : Event_Buffer_Type;

   end Buffer_Wrapper;

private
   -- Timer
   buffer_time_span : constant Time_Span := Seconds (send_buffer_delay);
   id : constant String := "[TIMER] Buffer timer";
   package Buffer_Timer is new Generic_Timers (True, id, buffer_time_span, Buffer_Wrapper.Send);

end Soccer.Bridge.Output;
