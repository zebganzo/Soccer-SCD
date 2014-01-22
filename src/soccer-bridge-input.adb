with Soccer.ControllerPkg; use Soccer.ControllerPkg;
with Soccer.Game; use Soccer.Game;
with Soccer.ControllerPkg.Referee; use Soccer.ControllerPkg.Referee;

package body Soccer.Bridge.Input is

   procedure New_Game is
   begin
      -- start new game
      ControllerPkg.Reset_Game;
      ControllerPkg.Set_Game_Status (Game_Paused);
      Game_Entity.Notify;
      ControllerPkg.Referee.Simulate_Begin_Of_1T;
      Game_Entity.Notify;
   end New_Game;

   procedure Pause_Game (new_status : out Unbounded_String) is
   begin
      -- pause the current game
      Game_Entity.Set_Paused;
      Game_Entity.Notify;
      ControllerPkg.Controller.Notify;
      new_status := To_Unbounded_String (Get_Game_Status_For_Bridge);
   end Pause_Game;

   procedure Second_Half is
   begin
      -- continue with second half
      ControllerPkg.Referee.Simulate_Begin_Of_2T;
      Game_Entity.Notify;
   end Second_Half;

   procedure Quit is
   begin
      -- quit everything!
      ControllerPkg.Set_Must_Exit;
   end Quit;

   procedure Update_Teams_Configuration (data : String) is
   begin
      TeamPkg.Update_Teams_Configuration (data);
   end Update_Teams_Configuration;

   procedure Get_Players_Params (result_params : out Unbounded_String) is
      result : JSON_Array;
      current : JSON_Value;
      container : JSON_Value;
   begin
      for player in 1 .. total_players loop
	 current := Create_Object;
	 Set_Field (current, "id", player);
	 Set_Field (current, "number", ControllerPkg.Get_Number_From_Id (player));
	 Set_Field (current, "on_the_field", ControllerPkg.Is_On_The_Field (player));
	 Set_Field (current, "team", Team_Id'Image (ControllerPkg.Get_Player_Team_From_Id (player)));
	 Append (result, current);
      end loop;

      container := Create_Object;
      Set_Field (container, "players", result);
      result_params := To_Unbounded_String (Write (container));

   end Get_Players_Params;

   procedure Get_Players_Stats (manager : String; result : out Unbounded_String) is
      json_obj     : JSON_Value;
      player       : JSON_Value;
      team     	   : JSON_Array;
      player_team  : Team_Id;
   begin
      for i in 1 .. total_players loop
         player_team := ControllerPkg.Get_Player_Team_From_Id (i);
         if manager = Team_Id'Image (player_team) then
            declare
               number : Integer := ControllerPkg.Get_Number_From_Id (i);
            begin
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
   end Get_Players_Stats;

   procedure Apply_Manager_Updates (updates : String) is
      json_update : JSON_Value := Read (updates,"");
      json_team	  : JSON_Value := Get (json_update, "TEAM");
      team_name   : Unbounded_String := Get (json_team, "name");
   begin
      if To_String (team_name) = "TEAM_ONE" then
         if Has_Field (json_team, "formation") then
            declare
               formation : Unbounded_String := Get (json_team, "formation");
            begin
               TeamPkg.Set_Formation (TeamPkg.Get_Team (Team_One), Formation_Scheme_Id'Value (To_String (formation)));
            end;
         end if;
         if Has_Field (json_team, "substitution") then
            declare
               sub_players : JSON_Array := Get (json_team, "substitution");
               in_player   : Integer := Integer'Value (Get (sub_players, 1).Write);
               out_player  : Integer := Integer'Value (Get (sub_players, 2).Write);
            begin
               Queue_Substitution (Team_One, out_player, in_player);
            end;
         end if;
      else
         if Has_Field (json_team, "formation") then
            declare
               formation : Unbounded_String := Get (json_team, "formation");
            begin
               TeamPkg.Set_Formation (TeamPkg.Get_Team (Team_Two), Formation_Scheme_Id'Value (To_String (formation)));
            end;
         end if;
         if Has_Field (json_team, "substitution") then
            declare
               sub_players : JSON_Array := Get (json_team, "substitution");
               in_player   : Integer := Integer'Value (Get (sub_players, 1).Write);
               out_player  : Integer := Integer'Value (Get (sub_players, 2).Write);
            begin
               Queue_Substitution (Team_One, out_player, in_player);
            end;
         end if;
      end if;
   end Apply_Manager_Updates;

   function Get_Game_Status_For_Bridge return String is
      is_controller_paused : Boolean;
      state_string : Unbounded_String;
      response : JSON_Value;
   begin
      is_controller_paused := Game_Entity.Is_Paused;
      if is_controller_paused then
	 state_string := To_Unbounded_String ("paused");
      else
	 state_string := To_Unbounded_String ("playing");
      end if;

      response := Create_Object;
      response.Set_Field ("status", state_string);
      return Write (response);
   end Get_Game_Status_For_Bridge;

end Soccer.Bridge.Input;
