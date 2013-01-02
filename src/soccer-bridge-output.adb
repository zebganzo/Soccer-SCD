with Soccer.Server.WebServer;
use Soccer.Server.WebServer;
with GNATCOLL.JSON; use GNATCOLL.JSON;
with Soccer.Core_Event.Game_Core_Event; use Soccer.Core_Event.Game_Core_Event;

package body Soccer.Bridge.Output is

   On : Boolean := False;

   protected body Timer_Control is

      procedure Start is
      begin
         On := True;
      end Start;

      procedure Stop is
      begin
         On := False;
      end Stop;

      entry Is_On when On is
      begin
         null;
      end Is_On;
   end Timer_Control;

   task body Timer is
   begin
      loop
         Timer_Control.Is_On;
         delay duration (Send_Buffer_Delay);
         if On then
            Buffer_Wrapper.Send;
         end if;
      end loop;
   end Timer;

   protected body Buffer_Wrapper is
      procedure Put (new_event : Soccer.Core_Event.Event_Ptr) is
      begin
         size := size + 1;
         event_buffer(size) := new_event;
         if size = Event_Buffer_Type'Last then
            Send;
         end if;
      end Put;

      procedure Send is
         j_value : JSON_Value;
         field_events : JSON_Array;
         manager_events : JSON_Array;
      begin

         for event in 1 .. size loop
            event_buffer(event).Serialize(j_value);
            GNATCOLL.JSON.Append(Arr => field_events,
                                 Val => j_value);
            if event_buffer(event).all in Game_Event'Class then
               GNATCOLL.JSON.Append(Arr => manager_events,
                                    Val => j_value);
            end if;
	 end loop;

         size := 0;

         -- Server
         Soccer.Server.WebServer.PublishManagersUpdate (manager_events); -- TODO aggiornare
         Soccer.Server.WebServer.PublishFieldUpdate (field_events); -- TODO aggiornare

      end Send;
   end Buffer_Wrapper;

end Soccer.Bridge.Output;
