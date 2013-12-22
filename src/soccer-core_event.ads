with GNATCOLL.JSON; use GNATCOLL.JSON;
package Soccer.Core_Event is

   type Event is abstract tagged private;
   type Event_Ptr is access all Event'Class;

   procedure Serialize (E : Event; Serialized_Obj : out JSON_Value) is abstract;

   procedure Update_Serialized_Object (E : Event; Serialized_Obj : in out JSON_Value) is abstract;

private

   type Event is abstract tagged
      record
         null;
      end record;

end Soccer.Core_Event;
