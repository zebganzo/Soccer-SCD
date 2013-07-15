with Soccer.Server.WebServer;
use Soccer.Server.WebServer;
with GNATCOLL.JSON; use GNATCOLL.JSON;
with Soccer.Core_Event.Game_Core_Event; use Soccer.Core_Event.Game_Core_Event;
with Ada.Text_IO; use Ada.Text_IO;

with Soccer.Core_Event.Motion_Core_Event; use Soccer.Core_Event.Motion_Core_Event;
with Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event;
use Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event;
with Soccer.Core_Event.Game_Core_Event.Match_Game_Event;
use Soccer.Core_Event.Game_Core_Event.Match_Game_Event;

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
         delay duration (send_buffer_delay);
         if On then
            Buffer_Wrapper.Send;
         end if;
      end loop;
   end Timer;

   -- Ogni mossa che viene inserita tramite Put e' formata da:
   -- id
   -- coord From
   -- coord To
   -- Timestamp inizio
   -- Timestamp fine
   -- Il buffer quindi dovra' unificare gli eventi (di tipo motion) appartenenti
   -- allo stesso id tenendo fissa la coord From e timestamp inizio ed aggiornando i campi
   -- to e timestamp fine!
   --
   -- Lato distribuzione ci si aspetta che ogni movimento venga preso in consegna
   -- da un task che parte in modo consono al timestamp di inizio e gestisce lo
   -- spostamento in base alla coordinata di destinazione ed al timestamp che indica
   -- l'istante di arrivo.
   --
   -- Esempio pratico: ho 5 mosse da gestire, attribuite a 5 task che partiranno in
   -- ordine in base al timestamp di inizio. Ognuno di essi spostera' il giocatore
   -- indicato dall'id da From a To impiegando un tempo pari a (fine - inizio)
   -- avendo cura di evitare che i giocatori si incaprettino fra di loro!

   protected body Buffer_Wrapper is
      procedure Put (new_event : Soccer.Core_Event.Event_Ptr) is
         new_element : Event_Buffer_Element;
         now : Time := Clock;
      begin

         if new_event.all in Game_Event'Class then
            new_element.event := new_event;
            new_element.time_start := t0 - now;
            size := size + 1;
            event_buffer(size) := new_element;

	    -- Se è un evento del Match (es. fine primo tempo) forzo la send
     	    -- cambiare Match Event in Game Event: questo perche' se sono eventi
            -- tipo goal, sostituzione va notificato
            if new_event.all in Match_Event'Class then
               Send;
            end if;
         else
            -- motion event, devo gestire i vari casi!
            if new_event.all in Move_Event'Class then
               declare
                  found : Boolean := False;
               begin
                  for event in reverse 1 .. size loop
                     if event_buffer(event).event.all in Move_Event'Class then
                        if Motion_Event(event_buffer(event).event.all).Get_Player_Id = Motion_Event(new_event.all).Get_Player_Id then
                           Move_Event(event_buffer(event).event.all).Update_To_Coordinate(new_coord => Motion_Event(new_event.all).Get_To);
                           event_buffer(event).time_stop := t0 - now;
                           found := True;
                           exit;
                        end if;
                     else
                        found := False;
                        exit;
                     end if;
                  end loop;
               end;
            else
               -- Codice uguale a sopra, lo tengo separato per problematiche future
               -- attualmente non considerate!
               new_element.event := new_event;
               new_element.time_start := t0 - now;
               size := size + 1;
               event_buffer(size) := new_element;
            end if;
         end if;

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
            event_buffer(event).event.Serialize(j_value);
            GNATCOLL.JSON.Append(Arr => field_events,
                                 Val => j_value);
            if event_buffer(event).event.all in Game_Event'Class then
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
