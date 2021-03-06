
with AWS.Response;
with AWS.Status;
with GNATCOLL.JSON; use GNATCOLL.JSON;

package Soccer.Server.Callbacks is

   use AWS;

   function Services (Request : in Status.Data) return Response.Data;

   procedure Handler (Name  : in UTF8_String; Value : in JSON_Value);

   function Load_File (Filename : in String) return String;

end Soccer.Server.Callbacks;
