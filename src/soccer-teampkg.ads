package Soccer.TeamPkg is

   type Team is
      record
         id : Integer;
      end record;

   type Team_Ptr is access Team;

   Team_One : Team_Ptr := new Team'(id => 1);
   Team_Two : Team_Ptr := new Team'(id => 2);

end Soccer.TeamPkg;
