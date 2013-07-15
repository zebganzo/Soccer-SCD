with Soccer.TeamPkg; use Soccer.TeamPkg;
package Soccer.PlayersPkg is

   -- Il package Players contiene il task Player...non credo vi sia bisogno di descriverlo

   -- Entità attiva    : Player
   task type Player (id : Integer; ability : Integer; initial_coord_x : Positive; initial_coord_y : Positive; team : Team_Id);

end Soccer.PlayersPkg;
