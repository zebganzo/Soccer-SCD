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
with Soccer.Utils; use Soccer.Utils;
with Soccer.ControllerPkg; use Soccer.ControllerPkg;
with Soccer.TeamPkg; use Soccer.TeamPkg;


package body Soccer.Bridge.Output is

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
         now : Ada.Calendar.Time := Clock;
      begin

         if new_event.all in Game_Event'Class then
            new_element.event := new_event;
	    new_element.time_start := now - t0;
	    new_element.time_stop := new_element.time_start;
            size := size + 1;
            event_buffer(size) := new_element;

            Send;
         else
            -- motion event, devo gestire i vari casi!
            if new_event.all in Move_Event'Class then
               declare
                  found : Boolean := False;
               begin
                  for event in reverse 1 .. size loop
                     if event_buffer(event).event.all in Move_Event'Class then
			if Motion_Event(event_buffer(event).event.all).Get_Player_Id = Motion_Event(new_event.all).Get_Player_Id then
			   Print ("[BRIDGE] Merging moves - From " & Print_Coord (Motion_Event(event_buffer(event).event.all).Get_From) & " / To " & Print_Coord (Motion_Event(event_buffer(event).event.all).Get_To));
                           Move_Event(event_buffer(event).event.all).Update_To_Coordinate(new_coord => Motion_Event(new_event.all).Get_To);
                           event_buffer(event).time_stop := now - t0;
                           found := True;
                           exit;
                        end if;
--                       else
--                          found := False;
--                          exit;
                     end if;
		  end loop;

		  if not found then
		     new_element.event := new_event;
		     new_element.time_start := now - t0;
		     new_element.time_stop := new_element.time_start;
		     size := size + 1;
		     event_buffer(size) := new_element;
		  end if;
               end;
            else
               -- Codice uguale a sopra, lo tengo separato per problematiche future
               -- attualmente non considerate!
               new_element.event := new_event;
	       new_element.time_start := now - t0;
	       new_element.time_stop := new_element.time_start;
               size := size + 1;
               event_buffer(size) := new_element;
            end if;
         end if;

         if size = Event_Buffer_Type'Last then
            Send;
         end if;
      end Put;

      procedure Buffer_Timer_Handler is
      begin
--  	 Put_Line ("Buffer Timer expired!");
	 Send;
      end;

      procedure Send is
         j_value : JSON_Value;
         field_events : JSON_Array;
         manager_events : JSON_Array;
      begin

	 if is_first_half then
	    Reset_Timer_First_Half;
	 else
	    Reset_Timer_Second_Half;
	 end if;

	 if size > 0 then
	    for event in 1 .. size loop
	       event_buffer(event).event.Serialize(j_value);
	       event_buffer(event).event.Update_Serialized_Object (j_value);
	       j_value.Set_Field ("start_time",
			   Duration'Image (event_buffer(event).time_start));
	       j_value.Set_Field ("end_time",
			   Duration'Image (event_buffer(event).time_stop));
	       GNATCOLL.JSON.Append(Arr => field_events,
			     Val => j_value);
	       if event_buffer(event).event.all in Game_Event'Class then
		  GNATCOLL.JSON.Append(Arr => manager_events,
                         Val => j_value);
	       end if;
	    end loop;

	    size := 0;

--  	    for i in 1 .. Length (field_events) loop
--  	       declare
--  		  value : JSON_Value;
--  	       begin
--  		  value := Get (field_events, i);
--  		  Put_Line ("Value (" & I2S (i) & ") : " & Get (value));
--  	       end;
--  	    end loop;

            if not sent_teams and teams_ready  then
               declare
                  team1 : Unbounded_String;
                  team2 : Unbounded_String;
               begin
                  sent_teams := True;
                  Get_Players_Stats("TEAM_ONE", team1);
                  Get_Players_Stats("TEAM_TWO", team2);
                  Soccer.Server.WebServer.PublishManagerTeams(To_String(team1), To_String(team2));
               end;
            end if;

	    -- Server
  	    Soccer.Server.WebServer.PublishManagersUpdate (field_events); -- TODO aggiornare
	    Soccer.Server.WebServer.PublishFieldUpdate (field_events); -- TODO aggiornare
	 end if;

	 if is_first_half then
	    Start_Timer_First_Half (send_buffer_delay);
	 else
	    Start_Timer_Second_Half (send_buffer_delay);
	 end if;

      end Send;

   end Buffer_Wrapper;

   procedure Notify_Field (payload : String) is
   begin
      Soccer.Server.WebServer.Notify_Field_With_Params (payload);
   end Notify_Field;

   procedure Start_Timer_First_Half (time : Integer) is
   begin
      Buffer_Timer_First_Half.Start (time, true);
   end Start_Timer_First_Half;

   procedure Reset_Timer_First_Half is
   begin
      Buffer_Timer_First_Half.Cancel;
   end Reset_Timer_First_Half;

   procedure Start_Timer_Second_Half (time : Integer) is
   begin
      Buffer_Timer_Second_Half.Start (time, true);
   end Start_Timer_Second_Half;

   procedure Reset_Timer_Second_Half is
   begin
      Buffer_Timer_Second_Half.Cancel;
   end Reset_Timer_Second_Half;

   procedure Set_Is_First_Half (first_half : Boolean) is
   begin
      is_first_half := first_half;
   end Set_Is_First_Half;

   procedure Print (input : String) is
   begin
      if debug then
	 pragma Debug (Put_Line (input));
	 null;
      end if;
   end Print;

   procedure Get_Players_Stats (manager : String; result : out Unbounded_String) is
      json_obj     : JSON_Value;
      player       : JSON_Value;
      team     	   : JSON_Array;
      player_team  : Team_Id;
   begin
--        Put_Line ("Get_Players_Stats BRIDGE: " & manager);
      for i in 1 .. total_players loop
         player_team := ControllerPkg.Get_Player_Team_From_Id (i);
         if manager = Team_Id'Image (player_team) then
            declare
               number : Integer := ControllerPkg.Get_Number_From_Id (i);
            begin
--                 Put_Line ("Get_Players_Stats BRIDGE: dentro If");
               player := Create_Object;
               player.Set_Field ("number", number);
               player.Set_Field ("attack", TeamPkg.Get_Attack (number, player_team));
               player.Set_Field ("defense", TeamPkg.Get_Defense (number, player_team));
               player.Set_Field ("goal_keeping" , TeamPkg.Get_Goal_Keeping (number, player_team));
               player.Set_Field ("power" , TeamPkg.Get_Power (number, player_team));
               player.Set_Field ("precision" , TeamPkg.Get_Precision (number, player_team));
               player.Set_Field ("speed" , TeamPkg.Get_Speed (number, player_team));
               player.Set_Field ("tackle" , TeamPkg.Get_Tackle (number, player_team));
               player.Set_Field ("role" , TeamPkg.Get_Role (TeamPkg.Get_Formation_Id (number, player_team),
               						    TeamPkg.Get_Formation (player_team)));
               Append (team, player);
            end;
         end if;
      end loop;

      json_obj := Create_Object;
      json_obj.Set_Field("formation",Formation_Scheme_Id'Image(TeamPkg.Get_Formation(Team_Id'Value(manager))));
      json_obj.Set_Field ("stats", Create(team));
      --json_obj.Set_Field ("in", manager);
      result := To_Unbounded_String (Write (json_obj));
--        Put_Line ("Get_Players_Stats BRIDGE: " & To_String(result));
   end Get_Players_Stats;

   procedure Set_Teams_Ready (ready : in Boolean) is
   begin
      teams_ready := ready;
   end Set_Teams_Ready;

   function Get_Teams_Ready return Boolean is
   begin
      return teams_ready;
   end Get_Teams_Ready;
end Soccer.Bridge.Output;
