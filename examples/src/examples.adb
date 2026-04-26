--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Ada.Text_IO;
with SDF_Fonts.Roboto_Mono_20;

procedure Examples is
   Screen : array (1 .. 30) of String (1 .. 80) :=
     (others => (others => ' '));

   procedure Draw_Pixel (X, Y : Positive) is
   begin
      Screen (Y) (X) := '#';
   end Draw_Pixel;

   procedure Render_String is new SDF_Fonts.Roboto_Mono_20.Render_String
     (Positive, Draw_Pixel);

   X : Positive := 5;
begin
   Render_String (X => X, Y => 5, Scale => 24, Text => "Ada");
   for Line of reverse Screen loop
      Ada.Text_IO.Put_Line (Line);
   end loop;
end Examples;
