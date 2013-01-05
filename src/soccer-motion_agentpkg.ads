package Soccer.Motion_AgentPkg is

   protected Motion_Enabler is
      procedure Move (source : Coordinate; target : Coordinate; power : Power_Range);
      entry Enabled;
   end Motion_Enabler;

   task Motion_Agent;

end Soccer.Motion_AgentPkg;
