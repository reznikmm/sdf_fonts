--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

generic
   type Pixel_Coordinate is (<>);
   --  Type for pixel coordinates (any discrete type)

   with function Get_Glyph_Index (Value : Character) return Glyph_Index;
   --  Function to map a character to a glyph index

   with procedure Render_Glyph
     (X     : in out Pixel_Coordinate;
      Y     : Pixel_Coordinate;
      Scale : Font_Scale;
      Index : Glyph_Index);
   --  Drawing routine for a single glyph

procedure SDF_Fonts.Render_String
  (X     : in out Pixel_Coordinate;
   Y     : Pixel_Coordinate;
   Scale : Font_Scale;
   Text  : String);
--  Renders a string at the given position and scale.
--  * @param X, Y: Position of the glyph's origin in pixel coordinates.
--  * @param Scale: Scaling factor for the glyph size (1.0 = normal size).
--  * @param Text: Text to render.
