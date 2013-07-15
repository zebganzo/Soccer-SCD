package body Soccer.Manager_Event is

   --+ Return value : 0 =>
   function Get_Type (E : Event) return Manager_Event_Id is
   begin
      return E.type_id;
   end Get_Type;

   function Get_Team (E : Event) return Team_Id is
   begin
      return E.event_team;
   end Get_Team;

end Soccer.Manager_Event;
