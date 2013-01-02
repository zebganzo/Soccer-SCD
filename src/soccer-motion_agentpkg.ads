package Soccer.Motion_AgentPkg is

   task Motion_Agent is
      entry Move (source : Coordinate; target : Coordinate; power : Power_Range);
   end Motion_Agent;

end Soccer.Motion_AgentPkg;
