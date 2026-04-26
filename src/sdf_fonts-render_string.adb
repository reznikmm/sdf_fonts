--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

procedure SDF_Fonts.Render_String
  (X     : in out Pixel_Coordinate;
   Y     : Pixel_Coordinate;
   Scale : Font_Scale;
   Text  : String) is
begin
   for Item of Text loop
      Render_Glyph (X, Y, Scale, Get_Glyph_Index (Item));
   end loop;
end SDF_Fonts.Render_String;