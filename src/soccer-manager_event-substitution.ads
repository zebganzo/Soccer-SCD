with Soccer.Manager_Event;

package Soccer.Manager_Event.Substitution is

   type Substitution_Event is new Event with private;
   type Substitution_Event_Ptr is access all Substitution_Event'Class;

   procedure Deserialize (E : out Substitution_Event; Serialized_Obj : in JSON_Value);

private

   type Substitution_Event is new Event with
      record
         player_1_id : Integer;
         player_2_id : Integer;
      end record;

end Soccer.Manager_Event.Substitution;
