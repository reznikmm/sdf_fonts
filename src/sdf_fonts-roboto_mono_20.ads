--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------

package SDF_Fonts.Roboto_Mono_20 is

   function Get_Glyph (Index : Glyph_Index) return Glyph;

   type Distance is delta 1.0 / 128.0 range -128.0 .. 127.0;

   function Get_Atlas_Pixel (X, Y : Atlas_Coordinate) return Distance
     with Inline;

   generic
      type Pixel_Coordinate is (<>);
      --  Type for pixel coordinates (any discrete type)

      with procedure Draw_Pixel (X, Y : Pixel_Coordinate);
      --  Drawing routine for a single pixel
   procedure Render_Glyph
     (X     : in out Pixel_Coordinate;
      Y     : Pixel_Coordinate;
      Scale : Font_Scale;
      Index : Glyph_Index);

end SDF_Fonts.Roboto_Mono_20;
