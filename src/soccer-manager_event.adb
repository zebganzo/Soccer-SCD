package body Soccer.Manager_Event is

   --+ Return value : 0 =>
   function Get_Type (E : Event) return Manager_Event_Id is
   begin
      return E.Type_Id;
   end Get_Type;

end Soccer.Manager_Event;
