with Soccer.Utils;
use Soccer.Utils;
with Ada.Text_IO; use Ada.Text_IO;

package body Soccer.BallPkg is

   protected body Ball is

      function Get_Position return Coordinate is
      begin
         return current_position;
      end Get_Position;

      function Get_Controlled return Boolean is
      begin
         return controlled;
      end Get_Controlled;

      function Get_Moving return Boolean is
      begin
         return moving;
      end Get_Moving;

      procedure Set_Controlled (new_status : Boolean) is
      begin
         controlled := new_status;
      end Set_Controlled;

      procedure Set_Moving (new_status : Boolean) is
      begin
         moving := new_status;
      end Set_Moving;

      procedure Catch (player_coord : Coordinate; succeded : out Boolean) is
      begin
         if(Utils.distance(x1 => player_coord.coord_x,
                           x2 => current_position.coord_x,
                           y1 => player_coord.coord_y,
                           y2 => current_position.coord_y) <= 1) then
            current_position := player_coord;
            controlled := True;
            moving := False;
            succeded := True;
         else
            succeded := False;
         end if;
      end Catch;

      procedure Move_Player (new_coord : Coordinate) is
      begin
         current_position := new_coord;
         Put_Line ("mCoord " & I2S(current_position.coord_x) & " " & I2S(current_position.coord_y));
      end Move_Player;

      entry Move_Agent (new_coord : Coordinate)
        when controlled = False is
      begin
         Put_Line("Move_Agent_Hell_yeah!!!");
         current_position := new_coord;
      end Move_Agent;

      --+ potenzialmente inutile
      procedure Release is
      begin
         controlled := False;
      end Release;

      procedure Set_Position (new_position : in Coordinate) is
      begin
	 current_position := new_position;
      end Set_Position;

   end Ball;

end Soccer.BallPkg;
