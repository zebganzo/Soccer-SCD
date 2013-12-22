with Soccer.Core_Event.Motion_Core_Event;

package Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event is

   type Tackle_Event is new Motion_Event with private;
   type Tackle_Event_Ptr is access all Tackle_Event;

   procedure Set_Other_Player_Id (E : in out Tackle_Event; id : in Integer);

   function Get_Other_Player_Id (E : in Tackle_Event) return Integer;

   procedure Update_Serialized_Object (E : Tackle_Event; Serialized_Obj : in out JSON_Value);

private

   type Tackle_Event is new Motion_Event with
      record
	Other_Player_Id : Integer;
      end record;

end Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event;
