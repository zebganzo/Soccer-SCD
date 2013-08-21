with Soccer.Manager_Event;

package Soccer.Manager_Event.Substitution is

   type Substitution_Event is new Event with private;
   type Substitution_Event_Ptr is access all Substitution_Event'Class;

   procedure Deserialize (E : out Substitution_Event; Serialized_Obj : in JSON_Value);

   procedure Initialize (e : in out Substitution_Event_Ptr; id_1 : Integer; id_2 : Integer);

   package Substitutions_Container is new Vectors (Index_Type   => Natural,
						   Element_Type => Substitution_Event_Ptr);

private

   type Substitution_Event is new Event with
      record
         player_1_id : Integer;
         player_2_id : Integer;
      end record;

end Soccer.Manager_Event.Substitution;
