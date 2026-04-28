--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Ada.Command_Line;
with Ada.Text_IO;
with SDF_Fonts;
with SDF_Fonts.Roboto_Mono_20;

procedure Stdout is
   Screen : array (1 .. 30) of String (1 .. 80) :=
     (others => (others => ' '));

   procedure Draw_Pixel (X, Y : Positive) is
   begin
      if Y in Screen'Range and then X in Screen (Y)'Range then
         Screen (Y) (X) := '#';
      end if;
   end Draw_Pixel;

   procedure Render_String is new SDF_Fonts.Roboto_Mono_20.Render_String
     (Positive, Draw_Pixel);

   Text : constant String :=
     (if Ada.Command_Line.Argument_Count > 0 then Ada.Command_Line.Argument (1)
      else "Ada");

   Scale : constant SDF_Fonts.Font_Scale :=
     (if Ada.Command_Line.Argument_Count > 1
      then SDF_Fonts.Font_Scale'Value (Ada.Command_Line.Argument (2))
      else 24);

   X : Positive := 5;
begin
   Render_String (X => X, Y => 5, Scale => Scale, Text => Text);

   for Line of reverse Screen loop
      Ada.Text_IO.Put_Line (Line);
   end loop;
end Stdout;
