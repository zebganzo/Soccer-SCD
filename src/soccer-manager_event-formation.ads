with Soccer.Manager_Event;

package Soccer.Manager_Event.Formation is

   type Formation_Event is new Event with private;
   type Formation_Event_Ptr is access all Formation_Event'Class;

   procedure Deserialize (E : out Formation_Event; Serialized_Obj : in JSON_Value);

   function Get_Scheme (E : in Formation_Event) return Formation_Scheme;

private

   type Formation_Event is new Event with
      record
         Scheme : Formation_Scheme;
      end record;

end Soccer.Manager_Event.Formation;
