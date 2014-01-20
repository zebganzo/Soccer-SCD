with Soccer.TeamPkg; use Soccer.TeamPkg;
package Soccer.Bridge.Input is

   procedure New_Game;

   procedure Pause_Game (new_status : out Unbounded_String);

   procedure Second_Half;

   procedure Quit;

   procedure Update_Teams_Configuration (data : String);

   procedure Get_Players_Params (result_params : out Unbounded_String);

   procedure Get_Players_Stats (manager : String; result : out Unbounded_String);

   procedure Apply_Manager_Updates (updates : String);

   function Get_Game_Status_For_Bridge return String;

end Soccer.Bridge.Input;
