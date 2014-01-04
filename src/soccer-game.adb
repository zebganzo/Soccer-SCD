with Ada.Text_IO; use Ada.Text_IO;
with Soccer.Core_Event.Game_Core_Event.Match_Game_Event; use Soccer.Core_Event.Game_Core_Event.Match_Game_Event;
with Soccer.Utils; use Soccer.Utils;

package body Soccer.Game is

   function Calculate_Open (count : Integer; status : Game_State) return Boolean is
      result : Boolean := False;
   begin
      if status /= Game_Paused then
	 if count <= num_of_players then
	    result := True;
	 end if;
      end if;

      return result;
   end Calculate_Open;

   protected body Game_Entity is
      entry Start
	when Start'Count = num_of_players or Get_Game_Status /= Game_Paused is
      begin
	 -- se il gioco e' appena stato fatto partire (dopo una pausa richiesta
	 -- dall'utente o dopo una fine di un tempo di gioco) allora Game_Status
	 -- sara' Game_Paused, quindi l'unico modo per entrare qui dentro e' che
	 -- tutti i giocatori si accodino
	 -- viceversa, se siamo durante uno degli altri stati di gioco, la
	 -- seconda condizione sara' sempre vera e l'if sottostante non
	 -- cambiera' lo stato di gioco

	 pragma Debug (Put_Line ("[GAME_ENTITY] Aperta!"));

	 if Get_Game_Status = Game_Paused then
	    Set_Game_Status (Game_Blocked);
	 end if;
      end Start;

      entry Start_1T when Start_1T'Count = num_of_players or open_1T is
      begin
	 open_1T := True;
	 Set_Game_Status (Game_Blocked);
	 -- manca sincronizzazione dei giocatori
      end Start_1T;

      entry Start_2T when Start_2T'Count = num_of_players or open_2T is
      begin
	 open_2T := True;
	 -- manca sincronizzazione dei giocatori
      end Start_2T;

      function Evaluate_Rest return Boolean is
	 event : Match_Event_Ptr;
      begin
	 if Is_Match_Event (Get_Last_Game_Event) then
	    event := Match_Event_Ptr (Get_Last_Game_Event);
	    if Get_Match_Event_Id (event) = Begin_Of_Match or
	      Get_Match_Event_Id (event) = Begin_Of_Second_Half then
	       return True;
	    end if;
	 end if;

	 return False;
      end Evaluate_Rest;

      entry Rest when Evaluate_Rest is
      begin
	 null;
      end Rest;

      function Evaluate_End_Match return Boolean is
      begin
	 if Get_Game_Status = Game_Paused then
	    return True;
	 end if;

	 return False;
      end Evaluate_End_Match;

      entry End_Match when Evaluate_End_Match is
      begin
	 null;
      end End_Match;

      procedure Notify is
      begin
	 null;
      end Notify;

      procedure Set_Paused is
      begin
	 paused := not paused;
      end Set_Paused;

      function Is_Paused return Boolean is
      begin
	 return paused;
      end Is_Paused;

   end Game_Entity;

end Soccer.Game;
