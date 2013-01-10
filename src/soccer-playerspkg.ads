with Soccer.TeamPkg; use Soccer.TeamPkg;
package Soccer.PlayersPkg is

   -- Il package Players contiene il task Player...non credo vi sia bisogno di descriverlo

   -- Entità attiva    : Player
   task type Player (Id : Integer; Ability : Integer; Initial_Coord_X : Positive; Initial_Coord_Y : Positive; team : Team_Ptr);

end Soccer.PlayersPkg;
