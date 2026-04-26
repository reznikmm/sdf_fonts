--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

procedure SDF_Fonts.Render_Glyph
  (X     : in out Pixel_Coordinate;
   Y     : Pixel_Coordinate;
   Scale : Font_Scale;
   Index : Glyph_Index)
is
   type Int is delta 1.0 range -2.0**11 .. 2.0**11 - 1.0;
   type Atlas_Offset is delta Plane_Coordinate'Small --  1.0 / 256.0
     range -Atlas_Coordinate'Last .. Atlas_Coordinate'Last;

   function Floor (Value : Atlas_Offset) return Atlas_Offset is
     (Atlas_Offset (Integer (Value - 0.5 + Atlas_Offset'Small)));

   type Pixel_Offset is new Atlas_Offset;

   function Floor (Value : Pixel_Offset) return Pixel_Offset is
     (Pixel_Offset (Integer (Value - 0.5 + Pixel_Offset'Small)));
   --  Why this is not inherited from Atlas_Offset?

   function Ceiling (Value : Pixel_Offset) return Pixel_Offset is
     (Pixel_Offset (Integer (Value + 0.5 - Pixel_Offset'Small)));

   function Sample
     (Glyph : SDF_Fonts.Glyph; X, Y : Atlas_Coordinate) return Distance is
       (if X + 0.5 in Glyph.Atlas.Left .. Glyph.Atlas.Right
          and Y + 0.5 in Glyph.Atlas.Bottom .. Glyph.Atlas.Top
        then Get_Atlas_Pixel (X, Y)
        else Distance'First);

   Glyph : constant SDF_Fonts.Glyph := Get_Glyph (Index);
   Unit  : constant Int := Int (Scale);

   Left   : constant Pixel_Offset := Floor (Unit * Glyph.Plane.Left);
   Right  : constant Pixel_Offset := Ceiling (Unit * Glyph.Plane.Right);
   Bottom : constant Pixel_Offset := Floor (Unit * Glyph.Plane.Bottom);
   Top    : constant Pixel_Offset := Ceiling (Unit * Glyph.Plane.Top);

   Advance : constant Pixel_Offset := Ceiling (Unit * Glyph.Advance);

   function To_Atlas_Offset (Value : Plane_Coordinate) return Atlas_Offset is
      (Atlas_Offset'
        (Value * Atlas_Offset (Glyph.Atlas.Right - Glyph.Atlas.Left))
        / (Glyph.Plane.Right - Glyph.Plane.Left));

   Start  : Pixel_Coordinate := X;
   Column : Pixel_Coordinate;
   Row    : Pixel_Coordinate := Y;
begin
   if Left >= 0.0 then
      for J in 1 .. Natural (Left) loop
         Start := Pixel_Coordinate'Succ (Start);
      end loop;
   else
      for J in 1 .. Natural (-Left) loop
         Start := Pixel_Coordinate'Pred (Start);
      end loop;
   end if;

   if Bottom >= 0.0 then
      for J in 1 .. Natural (Bottom) loop
         Row := Pixel_Coordinate'Succ (Row);
      end loop;
   else
      for J in 1 .. Natural (-Bottom) loop
         Row := Pixel_Coordinate'Pred (Row);
      end loop;
   end if;

   for Pixel_Y in Integer (Bottom) .. Integer (Top) loop
      Column := Start;

      for Pixel_X in Integer (Left) .. Integer (Right) loop
         declare
            Plane_X : constant SDF_Fonts.Plane_Coordinate :=
              Int (Pixel_X) / Unit - Glyph.Plane.Left;

            Plane_Y : constant SDF_Fonts.Plane_Coordinate :=
              Int (Pixel_Y) / Unit - Glyph.Plane.Bottom;

            Atlas_X : constant Atlas_Offset :=
              Atlas_Offset (Glyph.Atlas.Left) + To_Atlas_Offset (Plane_X);

            Atlas_Y : constant Atlas_Offset :=
              Atlas_Offset (Glyph.Atlas.Bottom) + To_Atlas_Offset (Plane_Y);

            Trunc_X : constant Atlas_Offset := Floor (Atlas_X);
            Trunc_Y : constant Atlas_Offset := Floor (Atlas_Y);

            Rest_X : constant Atlas_Offset := Atlas_X - Trunc_X;
            Rest_Y : constant Atlas_Offset := Atlas_Y - Trunc_Y;

            Shift_X : constant Atlas_Coordinate :=
              (if Trunc_X < 0.0 then 0.0 else Atlas_Coordinate (Trunc_X));

            Shift_Y : constant Atlas_Coordinate :=
              (if Trunc_Y < 0.0 then 0.0 else Atlas_Coordinate (Trunc_Y));

            Pixel : constant array (1 .. 2, 1 .. 2) of Distance :=
             ((Sample (Glyph, Shift_X, Shift_Y),
               Sample (Glyph, Shift_X + 1.0, Shift_Y)),
              (Sample (Glyph, Shift_X, Shift_Y + 1.0),
               Sample (Glyph, Shift_X + 1.0, Shift_Y + 1.0)));

            Weight : constant array (1 .. 2, 1 .. 2) of Atlas_Offset :=
              ((1 => (1.0 - Rest_X) * (1.0 - Rest_Y),
                2 => Rest_X * (1.0 - Rest_Y)),
               (1 => (1.0 - Rest_X) * Rest_Y,
                2 => Rest_X * Rest_Y));

            Dist : constant Distance :=
               Pixel (1, 1) * Weight (1, 1) +
               Pixel (1, 2) * Weight (1, 2) +
               Pixel (2, 1) * Weight (2, 1) +
               Pixel (2, 2) * Weight (2, 2);
         begin
            if Dist >= 0.0 then
               Draw_Pixel (Column, Row);
            end if;
            Column := Pixel_Coordinate'Succ (Column);
         end;
      end loop;

      Row := Pixel_Coordinate'Succ (Row);
   end loop;

   for J in 1 .. Natural (Advance) loop
      X := Pixel_Coordinate'Succ (X);
   end loop;
end SDF_Fonts.Render_Glyph;
