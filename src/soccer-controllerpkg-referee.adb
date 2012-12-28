package body Soccer.ControllerPkg.Referee is

   procedure Referee_Check (m : Motion_Event) is abstract;

   procedure Referee_Check (m : Tackle_Event) is begin
      null;
   end Referee_Check;

end Soccer.ControllerPkg.Referee;
