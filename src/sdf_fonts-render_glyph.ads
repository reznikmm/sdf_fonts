--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

generic
   type Pixel_Coordinate is (<>);
   --  Type for pixel coordinates (any discrete type)

   with procedure Draw_Pixel (X, Y : Pixel_Coordinate);
   --  Drawing routine for a single pixel

   with function Get_Glyph (Index : Glyph_Index) return Glyph;
   --  Font access function

   type Distance is delta <>;
   --  Type for distance values in the SDF atlas

   with function Get_Atlas_Pixel (X, Y : Atlas_Coordinate) return Distance;
   --  Function to retrieve the distance value for a given pixel in the atlas

procedure SDF_Fonts.Render_Glyph
  (X     : in out Pixel_Coordinate;
   Y     : Pixel_Coordinate;
   Scale : Font_Scale;
   Index : Glyph_Index);
--  Renders a single glyph at the given position and scale.
--  * @param X, Y: Position of the glyph's origin in pixel coordinates.
--  * @param Scale: Scaling factor for the glyph size (1.0 = normal size).
--  * @param Index: Index of the glyph to render according to the font's glyph
--    indexing scheme.
