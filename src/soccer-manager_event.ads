with GNATCOLL.JSON; use GNATCOLL.JSON;

package Soccer.Manager_Event is

   type Event is abstract tagged private;
   type Event_Ptr is access all Event'Class;

   type Manager_Event_Id is (Formation_Id, Substitution_Id);

   procedure Deserialize (E : out Event; Serialized_Obj : in JSON_Value) is abstract;
   function Get_Type (E : Event) return Manager_Event_Id;

private

   type Event is abstract tagged
      record
         Type_Id : Manager_Event_Id;
      end record;

end Soccer.Manager_Event;
