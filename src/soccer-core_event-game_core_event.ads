with Soccer.Core_Event;
use Soccer.Core_Event;

package Soccer.Core_Event.Game_Core_Event is

   type Game_Event is abstract new Event with private;
   type Game_Event_Ptr is access all Game_Event'Class;

   procedure Serialize (E : Game_Event; Serialized_Obj : out JSON_Value) is abstract;

   procedure Update_Serialized_Object (E : Game_Event; Serialized_Obj : in out JSON_Value);


private

   type Game_Event is abstract new Event with record
      null;
   end record;

end Soccer.Core_Event.Game_Core_Event;
