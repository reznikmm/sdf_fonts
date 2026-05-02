--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Ada_2022;

with Interfaces;
with System.Storage_Elements;

with STM32.GPIO;
with STM32.FSMC;

with ILI9341.Bus_16_II;

with SDF_Fonts;
with SDF_Fonts.Roboto_Mono_20;

procedure Stm32f4ve is
   use type System.Storage_Elements.Storage_Offset;

   Data : Interfaces.Unsigned_16
     with
       Import,
       Address => STM32.FSMC.Bank_1_Start (Subbank => 1) + 2**19,
       --  Address => System'To_Address (16#6C00_0080#),
       Volatile;

   package TFT is new ILI9341.Bus_16_II
     (Command => STM32.FSMC.Bank_1_Start (Subbank => 1),
      Data    => Data'Address);

   LED : constant STM32.Pin := (STM32.PA, 6);
   LCD_Back_Light : constant STM32.Pin := (STM32.PB, 1);

   FSMC : constant STM32.Pin_Array :=
     ((STM32.PD, 14), (STM32.PD, 15), (STM32.PD, 0), (STM32.PD, 1),
      (STM32.PE, 7), (STM32.PE, 8),  (STM32.PE, 9), (STM32.PE, 10),
      (STM32.PE, 11), (STM32.PE, 12), (STM32.PE, 13), (STM32.PE, 14),
      (STM32.PE, 15), (STM32.PD, 8),  (STM32.PD, 9), (STM32.PD, 10),
      --  Data pins (D0 .. D15)
      (STM32.PD, 13),  --  A18
      --  Only one address pin is connected to the TFT header
      (STM32.PD, 7),   --  NE1, Chip select pin for TFT LCD
      (STM32.PD, 4),   --  NOE, Output enable pin
      (STM32.PD, 5));  --  NWE, Write enable pin

   procedure Draw_Pixel (X, Y : Positive) is
      Column : Interfaces.Unsigned_16;
      Row : Interfaces.Unsigned_16;
   begin
      if Y in 1 .. 320 and then X in 1 .. 240 then
         Row := Interfaces.Unsigned_16 (Y - 1);
         Column := Interfaces.Unsigned_16 (X - 1);
         TFT.Column_Address_Set (SC => Column, EC => Column);
         TFT.Page_Address_Set (SP => Row, EP => Row);
         TFT.Write_Memory;
         Data := 16#FFFF#;
      end if;
   end Draw_Pixel;

   procedure Render_String is new SDF_Fonts.Roboto_Mono_20.Render_String
     (Positive, Draw_Pixel);

   function Image (J : Integer) return String is
     (case J is
      when 14 => "14",
      when 15 => "15",
      when 16 => "16",
      when 17 => "17",
      when 18 => "18",
      when 19 => "19",
      when 20 => "20",
      when 21 => "21",
      when 22 => "22",
      when 23 => "23",
      when 24 => "24",
      when 25 => "25",
      when 26 => "26",
      when 27 => "27",
      when 28 => "28",
      --  when 29 => "29",
      when others => "?");

   X : Positive := 10;
begin
   STM32.FSMC.Initialize (FSMC);

   STM32.FSMC.Configure
     (Bank_1 =>
        (1 =>  --  TFT is connected to sub-bank 1
           (Is_Set => True,
            Value  =>
              (Write_Enable  => True,
               Bus_Width     => STM32.FSMC.Half_Word,
               Memory_Type   => STM32.FSMC.SRAM,
               Bus_Turn      => 15,  --  90ns
               Data_Setup    => 57, --  342ns
               Address_Setup => 0,
               Extended      =>
                 (STM32.FSMC.Mode_A,
                  Write_Bus_Turn      => 3,  --  18ns
                  Write_Data_Setup    => 2,  --  12ns
                  Write_Address_Setup => 0),
               others        => <>)),
         others => <>));

   STM32.GPIO.Configure_Output (LED);
   STM32.GPIO.Configure_Output (LCD_Back_Light);
   STM32.GPIO.Set_Output (LCD_Back_Light, 1);

   TFT.Pixel_Format_Set (DBI => 16);

   TFT.Sleep_Out;
   delay 0.005;
   delay 0.005;
   delay 0.005;
   TFT.Display_On;
   TFT.Write_Memory;

   for J in 1 .. 240 * 320 loop
      Data := 0;
   end loop;

   for Scale in 14 .. 28 loop
      X := 10;
      Render_String
        (X     => X,
         Y     => 5 + (Scale - 14) * 21,
         Scale => SDF_Fonts.Font_Scale (Scale),
         Text  => "Scale:_" & Image (Scale));
   end loop;

   for J in 1 .. 1E9 loop
      STM32.GPIO.Set_Output (LED, STM32.Bit (J mod 2));
      delay 1.0;
   end loop;
end Stm32f4ve;
