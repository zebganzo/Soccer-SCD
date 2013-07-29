with Soccer.Core_Event;
use Soccer.Core_Event;

package Soccer.Core_Event.Motion_Core_Event is

   type Motion_Event is new Event with private;
   type Motion_Event_Ptr is access all Motion_Event'Class;

   procedure Serialize (E : Motion_Event; Serialized_Obj : out JSON_Value);

   procedure Initialize (E : in out Motion_Event;
                         nPlayer_Id : in Integer;
                         nFrom : in Coordinate;
                         nTo : in Coordinate);

   function Get_Player_Id (E : in Motion_Event) return Integer;
   function Get_From (E : in Motion_Event) return Coordinate;
   function Get_To (E : in Motion_Event) return Coordinate;

private

   type Motion_Event is new Event with record
      Player_Id : Integer;
      From : Coordinate;
      To : Coordinate;
   end record;

end Soccer.Core_Event.Motion_Core_Event;
