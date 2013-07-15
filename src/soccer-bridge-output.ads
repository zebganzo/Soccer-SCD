package Soccer.Bridge.Output is

   protected Timer_Control is
      procedure Start;
      procedure Stop;
      entry Is_On;
   end Timer_Control;

   task Timer;

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


end Soccer.Bridge.Output;
