with GNATCOLL.JSON; use GNATCOLL.JSON;
package Soccer.Field_Event is

   type Field_Type_Id is (a,b);

   type Event is
      record
         Type_Id : Field_Type_Id;
      end record;
   type Field_Event_Ptr is access all Event;

   procedure Deserialize (E : out Event; Serialized_Obj : in JSON_Value);

end Soccer.Field_Event;
