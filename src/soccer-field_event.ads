with GNATCOLL.JSON; use GNATCOLL.JSON;
package Soccer.Field_Event is

   type Field_Type_Id is (a,b);

   type Field_Event is
      record
         Type_Id : Field_Type_Id;
      end record;
   type Field_Event_Ptr is access all Field_Event;

   procedure Deserialize (E : out Field_Event; Serialized_Obj : in JSON_Value);

end Soccer.Field_Event;
