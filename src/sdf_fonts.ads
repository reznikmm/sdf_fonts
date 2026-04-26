--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

package SDF_Fonts is
   pragma Pure;

   --  Plane_Small : constant := 1.0 / 256.0;
   Plane_Small : constant := 1.0 / 4096.0;

   type Plane_Coordinate is delta Plane_Small range -2.0 .. 2.0 - Plane_Small;

   type Atlas_Coordinate is delta 0.5 range 0.0 .. 1023.0;

   type Glyph_Index is new Natural;

   type Plane_Bounds is record
      Left, Right : Plane_Coordinate;
      Top, Bottom : Plane_Coordinate;
   end record;

   type Atlas_Bounds is record
      Left, Right : Atlas_Coordinate;
      Top, Bottom : Atlas_Coordinate;
   end record;

   type Glyph is record
      --  Unicode
      Advance : Plane_Coordinate;
      Plane   : SDF_Fonts.Plane_Bounds;
      Atlas   : SDF_Fonts.Atlas_Bounds;
   end record;

   type Font_Scale is range 1 .. 1024;

end SDF_Fonts;
