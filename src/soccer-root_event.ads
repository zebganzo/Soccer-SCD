package Soccer.Root_Event is

   type Event is abstract tagged private;
   type Event_Ptr is access all Event'Class;

   procedure Print (E : Event) is abstract;

private

   type Event is abstract tagged
      record
	 i : Integer := 10;
      end record;

end Soccer.Root_Event;
