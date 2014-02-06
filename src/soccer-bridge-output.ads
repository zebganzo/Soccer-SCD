with Ada.Real_Time; use Ada.Real_Time;
with Soccer.Generic_Timers;

package Soccer.Bridge.Output is

   --+-------------
   debug : Boolean := False;
   --+-------------

   pragma Suppress (Elaboration_Check);

   type Event_Buffer_Element is
      record
         event : Soccer.Core_Event.Event_Ptr;
         time_start : Duration := 0.0;
         time_stop : Duration := 0.0;
      end record;

   type Event_Buffer_Type is array (1 .. buffer_dim) of Event_Buffer_Element;

   protected Buffer_Wrapper is

      procedure Put (new_event : Soccer.Core_Event.Event_Ptr);
      procedure Buffer_Timer_Handler;
      procedure Send;

   private

      size : Integer := 0;
      event_buffer : Event_Buffer_Type;

   end Buffer_Wrapper;

   procedure Start_Timer_First_Half (time : Integer);
   procedure Reset_Timer_First_Half;

   procedure Start_Timer_Second_Half (time : Integer);
   procedure Reset_Timer_Second_Half;

   procedure Set_Is_First_Half (first_half : Boolean);

   procedure Print (input : String);

   procedure Get_Players_Stats (manager : String; result : out Unbounded_String);

   procedure Set_Teams_Ready (ready : in Boolean);

private
   -- Timer
   buffer_time_span : constant Time_Span := Milliseconds (send_buffer_delay);
   id : constant String := "[TIMER] Buffer timer";
   package Buffer_Timer_First_Half is new Generic_Timers (True, id, Buffer_Wrapper.Buffer_Timer_Handler);
   package Buffer_Timer_Second_Half is new Generic_Timers (True, id, Buffer_Wrapper.Buffer_Timer_Handler);

   is_first_half : Boolean;
   sent_teams : Boolean := False;
   teams_ready : Boolean := False;

end Soccer.Bridge.Output;
