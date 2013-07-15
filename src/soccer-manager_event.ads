with GNATCOLL.JSON; use GNATCOLL.JSON;
with Soccer.TeamPkg; use Soccer.TeamPkg;

package Soccer.Manager_Event is

   type Event is abstract tagged private;
   type Event_Ptr is access all Event'Class;

   type Manager_Event_Id is (Formation_Id, Substitution_Id);

   procedure Deserialize (E : out Event; Serialized_Obj : in JSON_Value) is abstract;
   function Get_Type (E : Event) return Manager_Event_Id;

   function Get_Team (E : Event) return Team_Id;

private

   type Event is abstract tagged
      record
	 type_id : Manager_Event_Id;
	 event_team : Team_Id;
      end record;

end Soccer.Manager_Event;
