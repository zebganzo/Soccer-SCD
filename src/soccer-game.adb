with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.Game is

   protected body Game_Entity is
      entry Start
	when (Start'Count = num_of_players or Get_Game_Status /= Game_Paused) is
      begin
	 -- se il gioco e' appena stato fatto partire (dopo una pausa richiesta
	 -- dall'utente o dopo una fine di un tempo di gioco) allora Game_Status
	 -- sara' Game_Paused, quindi l'unico modo per entrare qui dentro e' che
	 -- tutti i giocatori si accodino
	 -- viceversa, se siamo durante uno degli altri stati di gioco, la
	 -- seconda condizione sara' sempre vera e l'if sottostante non
	 -- cambiera' lo stato di gioco

	 Put_Line ("[GAME_ENTITY] Aperta!");

	 if Get_Game_Status = Game_Paused then
	    Set_Game_Status (Game_Blocked);
	 end if;
      end Start;

   end Game_Entity;

end Soccer.Game;
