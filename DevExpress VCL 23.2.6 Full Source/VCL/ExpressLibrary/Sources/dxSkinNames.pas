{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           Express Cross Platform Library classes                   }
{                                                                    }
{           Copyright (c) 2000-2024 Developer Express Inc.           }
{           ALL RIGHTS RESERVED                                      }
{                                                                    }
{   The entire contents of this file is protected by U.S. and        }
{   International Copyright Laws. Unauthorized reproduction,         }
{   reverse-engineering, and distribution of all or any portion of   }
{   the code contained in this file is strictly prohibited and may   }
{   result in severe civil and criminal penalties and will be        }
{   prosecuted to the maximum extent possible under the law.         }
{                                                                    }
{   RESTRICTIONS                                                     }
{                                                                    }
{   THIS SOURCE CODE AND ALL RESULTING INTERMEDIATE FILES            }
{   (DCU, OBJ, DLL, ETC.) ARE CONFIDENTIAL AND PROPRIETARY TRADE     }
{   SECRETS OF DEVELOPER EXPRESS INC. THE REGISTERED DEVELOPER IS    }
{   LICENSED TO DISTRIBUTE THE EXPRESSCROSSPLATFORMLIBRARY AND ALL   }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM       }
{   ONLY.                                                            }
{                                                                    }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED       }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE         }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE        }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT   }
{   AND PERMISSION FROM DEVELOPER EXPRESS INC.                       }
{                                                                    }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON        }
{   ADDITIONAL RESTRICTIONS.                                         }
{                                                                    }
{********************************************************************}

unit dxSkinNames; // for internal use

{$I cxVer.inc}

interface

uses
  Types, Windows, Classes, Graphics, SysUtils, Generics.Collections,
  Generics.Defaults, dxCore;

type
{$SCOPEDENUMS ON}
  TdxSkinGroup = (Vector, LookAndFeelStyles, Office, Default, LatestOfficeSkins,
    VisualStudio, PreviousOfficeSkins, ThematicFlat, Seasonal, Thematic, RetroFlat,
    Retro3D, Custom, Common);
  TdxSkinGroups = set of TdxSkinGroup;
{$SCOPEDENUMS OFF}
  function dxStringToSkinGroup(const AName: string): TdxSkinGroup;
  procedure dxSkinGroupsToStrings(ANames: TdxSkinGroups; AList: TStrings);
  function dxStringsToSkinGroups(AList: TStrings): TdxSkinGroups;
type

{$REGION 'Consts'}

  TdxSkinNames = class // for internal use
  public const
    DefaultPaletteGroup = 'General';
    DefaultPalette = 'Default';
    DefaultSkinGroup = 'Common';
  type
    TGroups = class
    public const
      Vector = 'Vector';
      Standard = 'Standard';
      LookAndFeelStyles = 'Built-In Look && Feel Styles';
      Office = 'Office';

      Default = 'Default';
      LatestOfficeSkins = 'Latest Office skins';
      VisualStudio = 'Visual Studio';
      PreviousOfficeSkins = 'Previous Office skins';
      ThematicFlat = 'Thematic Flat';
      Seasonal = 'Seasonal';
      Thematic = 'Thematic';
      RetroFlat = 'Retro Flat';
      Retro3D = 'Retro 3D';
      Custom = 'Custom';
    end;

    TBezier = class
    public const
      ID = 'TheBezier';
      DisplayName = 'The Bezier';
      type TPalettes = class public const
        Default = 'Default';
        ArtHouse = 'Art House';
        LeafRustle = 'Leaf Rustle';
        NeonLollipop = 'Neon Lollipop';
        Tokyo = 'Tokyo';
        Fireball = 'Fireball';
        Crambe = 'Crambe';
        Grasshopper = 'Grasshopper';
        CherryInk = 'Cherry Ink';
        Starshine = 'Starshine';
        BW = 'BW';
        DarkTurquoise = 'Dark Turquoise';
        Prometheus = 'Prometheus';
        GhostShark = 'Ghost Shark';
        BlueVelvet = 'Blue Velvet';
        NorwegianWood = 'Norwegian Wood';
        DateFruit = 'Date Fruit';
        MilkSnake = 'Milk Snake';
        Dragonfly = 'Dragonfly';
        MercuryIce = 'Mercury Ice';
        PlasticSpace = 'Plastic Space';
        GloomGloom = 'Gloom Gloom';
        Volcano = 'Volcano';
        Aquarelle = 'Aquarelle';
        Oxygen3 = 'Oxygen 3';
        MorayEel = 'Moray Eel';
        WitchRave = 'Witch Rave';
        BlackberryShake = 'Blackberry Shake';
        Vacuum = 'Vacuum';
        Nebula = 'Nebula';
      end;
      type TPaletteGroups = class public const
        General = 'General';
        Inspired = 'Inspired';
        Light = 'Light';
        Dark = 'Dark';
        Accessibility = 'Accessibility';
        Office = 'Office';
      end;
    end;
    TOffice2019 = class public type
      TColorful = class public const
        ID = 'Office2019Colorful';
        DisplayName = 'Office Colorful';
      end;
      TBlack = class public const
        ID = 'Office2019Black';
        DisplayName = 'Office Black';
      end;
      TDarkGray = class public const
        ID = 'Office2019DarkGray';
        DisplayName = 'Office Dark Gray';
      end;
      TWhite = class public const
        ID = 'Office2019White';
        DisplayName = 'Office White';
      end;
      type TPalettes = class public const
        Default = 'Default';
        Yale = 'Yale';
        Forest = 'Forest';
        Pine = 'Pine';
        Plum = 'Plum';
        Amber = 'Amber';
        FireBrick = 'Fire Brick';
      end;
      type TPaletteGroups = class public const
        General = 'General';
      end;
    end;
    TWXI = class public const
      ID = 'WXI';
      DisplayName = 'WXI';
      type TPalettes = class public const
        Default = 'Default';
        Darkness = 'Darkness';
        Clearness = 'Clearness';
        Calmness = 'Calmness';
        Sharpness = 'Sharpness';
        OfficeDarkGray = 'Office Dark Gray';
        OfficeBlack = 'Office Black';
        OfficeColorful = 'Office Colorful';
        OfficeWhite = 'Office White';
      end;
      type TPaletteGroups = class public const
        General = 'General';
        Office = 'Office';
      end;
    end;
    TBasic = class public const
      ID = 'Basic';
      DisplayName = 'Basic';
      type TPalettes = class public const
        Default = 'Default';
        PineLight = 'Pine Light';
        VioletLight = 'Violet Light';
        BlueDark = 'Blue Dark';
        PineDark = 'Pine Dark';
        VioletDark = 'Violet Dark';
      end;
      type TPaletteGroups = class public const
        General = 'General';
      end;
    end;

    TOffice20072016 = class public
      type TPalettes = class public const
        Default = 'Default';
      end;
      type TPaletteGroups = class public const
        General = 'General';
      end;
    end;
    TOffice2007 = class public type
      TBlack = class public const
        ID = 'Office2007Black';
        DisplayName = 'Office 2007 Black';
      end;
      TBlue = class public const
        ID = 'Office2007Blue';
        DisplayName = 'Office 2007 Blue';
      end;
      TGreen = class public const
        ID = 'Office2007Green';
        DisplayName = 'Office 2007 Green';
      end;
      TPink = class public const
        ID = 'Office2007Pink';
        DisplayName = 'Office 2007 Pink';
      end;
      TSilver = class public const
        ID = 'Office2007Silver';
        DisplayName = 'Office 2007 Silver';
      end;
      TDarkGray = class public const
        ID = 'Office2007DarkGray';
        DisplayName = 'Office 2007 Dark Gray';
      end;
    end;
    TOffice2010 = class public type
      TBlack = class public const
        ID = 'Office2010Black';
        DisplayName = 'Office 2010 Black';
      end;
      TBlue = class public const
        ID = 'Office2010Blue';
        DisplayName = 'Office 2010 Blue';
      end;
      TSilver = class public const
        ID = 'Office2010Silver';
        DisplayName = 'Office 2010 Silver';
      end;
    end;
    TOffice2013 = class public type
      TDarkGray = class public const
        ID = 'Office2013DarkGray';
        DisplayName = 'Office 2013 Dark Gray';
      end;
      TLightGray = class public const
        ID = 'Office2013LightGray';
        DisplayName = 'Office 2013 Light Gray';
      end;
      TWhite = class public const
        ID = 'Office2013White';
        DisplayName = 'Office 2013 White';
      end;
    end;
    TOffice2016 = class public type
      TColorful = class public const
        ID = 'Office2016Colorful';
        DisplayName = 'Office 2016 Colorful';
      end;
      TDark = class public const
        ID = 'Office2016Dark';
        DisplayName = 'Office 2016 Dark';
      end;
    end;

    //
    TFlat = class public const
      ID = 'Flat';
      DisplayName = 'Flat';
    end;
    TNative = class public const
      ID = 'Native';
      DisplayName = 'Native';
    end;
    TOffice11 = class public const
      ID = 'Office11';
      DisplayName = 'Office11';
    end;
    TStandard = class public const
      ID = 'Standard';
      DisplayName = 'Standard';
    end;
    TUltraFlat = class public const
      ID = 'UltraFlat';
      DisplayName = 'UltraFlat';
    end;

    //
    TRasterPalettes = class public const
      PaletteDefault = 'Default';
      PaletteGroupGeneral = 'General';
    end;

    TBlack = class public const
      ID = 'Black';
      DisplayName = 'Black';
    end;
    TBlue = class public const
      ID = 'Blue';
      DisplayName = 'Blue';
    end;
    TBlueprint = class public const
      ID = 'Blueprint';
      DisplayName = 'Blueprint';
    end;
    TCaramel = class public const
      ID = 'Caramel';
      DisplayName = 'Caramel';
    end;
    TCoffee = class public const
      ID = 'Coffee';
      DisplayName = 'Coffee';
    end;
    TDarkroom = class public const
      ID = 'Darkroom';
      DisplayName = 'Darkroom';
    end;
    TDarkSide = class public const
      ID = 'DarkSide';
      DisplayName = 'Dark Side';
    end;
    TDevExpressDarkStyle = class public const
      ID = 'DevExpressDarkStyle';
      DisplayName = 'DevExpress Dark Style';
    end;
    TDevExpressStyle = class public const
      ID = 'DevExpressStyle';
      DisplayName = 'DevExpress Style';
    end;
    TFoggy = class public const
      ID = 'Foggy';
      DisplayName = 'Foggy';
    end;
    TGlassOceans = class public const
      ID = 'GlassOceans';
      DisplayName = 'Glass Oceans';
    end;
    THighContrast = class public const
      ID = 'HighContrast';
      DisplayName = 'High Contrast';
    end;
    TiMaginary = class public const
      ID = 'iMaginary';
      DisplayName = 'iMaginary';
    end;
    TLilian = class public const
      ID = 'Lilian';
      DisplayName = 'Lilian';
    end;
    TLiquidSky = class public const
      ID = 'LiquidSky';
      DisplayName = 'Liquid Sky';
    end;
    TLondonLiquidSky = class public const
      ID = 'LondonLiquidSky';
      DisplayName = 'London Liquid Sky';
    end;
    TMcSkin = class public const
      ID = 'McSkin';
      DisplayName = 'McSkin';
    end;
    TMetropolis = class public const
      ID = 'Metropolis';
      DisplayName = 'Metropolis';
    end;
    TMetropolisDark = class public const
      ID = 'MetropolisDark';
      DisplayName = 'Metropolis Dark';
    end;
    TMoneyTwins = class public const
      ID = 'MoneyTwins';
      DisplayName = 'Money Twins';
    end;
    TPumpkin = class public const
      ID = 'Pumpkin';
      DisplayName = 'Pumpkin';
    end;
    TSeven = class public const
      ID = 'Seven';
      DisplayName = 'Seven';
    end;
    TSevenClassic = class public const
      ID = 'SevenClassic';
      DisplayName = 'Seven Classic';
    end;
    TSharp = class public const
      ID = 'Sharp';
      DisplayName = 'Sharp';
    end;
    TSharpPlus = class public const
      ID = 'SharpPlus';
      DisplayName = 'Sharp Plus';
    end;
    TSilver = class public const
      ID = 'Silver';
      DisplayName = 'Silver';
    end;
    TSpringtime = class public const
      ID = 'Springtime';
      DisplayName = 'Springtime';
    end;
    TStardust = class public const
      ID = 'Stardust';
      DisplayName = 'Stardust';
    end;
    TSummer2008 = class public const
      ID = 'Summer2008';
      DisplayName = 'Summer';
    end;
    TTheAsphaltWorld = class public const
      ID = 'TheAsphaltWorld';
      DisplayName = 'The Asphalt World';
    end;
    TValentine = class public const
      ID = 'Valentine';
      DisplayName = 'Valentine';
    end;
    TWhiteprint = class public const
      ID = 'Whiteprint';
      DisplayName = 'Whiteprint';
    end;
    TXmas2008Blue = class public const
      ID = 'Xmas2008Blue';
      DisplayName = 'Xmas (Blue)';
    end;
    TVisualStudio = class public type
      T2013Blue = class public const
        ID = 'VisualStudio2013Blue';
        DisplayName = 'Visual Studio 2013 Blue';
      end;
      T2013Dark = class public const
        ID = 'VisualStudio2013Dark';
        DisplayName = 'Visual Studio 2013 Dark';
      end;
      T2013Light = class public const
        ID = 'VisualStudio2013Light';
        DisplayName = 'Visual Studio 2013 Light';
      end;
      TVS2010 = class public const
        ID = 'VS2010';
        DisplayName = 'Visual Studio 2010';
      end;
      TPalettes = class public const
        Default = 'Default';
      end;
      TPaletteGroups = class public const
        General = 'General';
      end;
    end;
  end;

{$ENDREGION}

{$REGION 'ResString'}

resourcestring

  scxSkinDefaultPaletteGroup = TdxSkinNames.DefaultPaletteGroup;
  scxSkinDefaultPalette = TdxSkinNames.DefaultPalette;
  scxSkinDefaultSkinGroup = TdxSkinNames.DefaultSkinGroup;

  scxSkinGroupVector = TdxSkinNames.TGroups.Vector;
  scxSkinGroupStandard = TdxSkinNames.TGroups.Standard;
  scxSkinGroupLookAndFeelStyles = TdxSkinNames.TGroups.LookAndFeelStyles;
  scxSkinGroupOffice = TdxSkinNames.TGroups.Office;
  scxSkinGroupDefault = TdxSkinNames.TGroups.Default;
  scxSkinGroupLatestOfficeSkins = TdxSkinNames.TGroups.LatestOfficeSkins;
  scxSkinGroupVisualStudio = TdxSkinNames.TGroups.VisualStudio;
  scxSkinGroupPreviousOfficeSkins = TdxSkinNames.TGroups.PreviousOfficeSkins;
  scxSkinGroupThematicFlat = TdxSkinNames.TGroups.ThematicFlat;
  scxSkinGroupSeasonal = TdxSkinNames.TGroups.Seasonal;
  scxSkinGroupThematic = TdxSkinNames.TGroups.Thematic;
  scxSkinGroupRetroFlat = TdxSkinNames.TGroups.RetroFlat;
  scxSkinGroupRetro3D = TdxSkinNames.TGroups.Retro3D;
  scxSkinGroupCustom = TdxSkinNames.TGroups.Custom;

  scxSkinBezierDisplayName = TdxSkinNames.TBezier.DisplayName;

  scxSkinBezierPaletteGroupGeneral = TdxSkinNames.TBezier.TPaletteGroups.General;
  scxSkinBezierPaletteGroupInspired = TdxSkinNames.TBezier.TPaletteGroups.Inspired;
  scxSkinBezierPaletteGroupLight = TdxSkinNames.TBezier.TPaletteGroups.Light;
  scxSkinBezierPaletteGroupDark = TdxSkinNames.TBezier.TPaletteGroups.Dark;
  scxSkinBezierPaletteGroupAccessibility = TdxSkinNames.TBezier.TPaletteGroups.Accessibility;
  scxSkinBezierPaletteGroupOffice = TdxSkinNames.TBezier.TPaletteGroups.Office;

  scxSkinBezierPaletteDefault = TdxSkinNames.TBezier.TPalettes.Default;
  scxSkinBezierPaletteArtHouse = TdxSkinNames.TBezier.TPalettes.ArtHouse;
  scxSkinBezierPaletteLeafRustle = TdxSkinNames.TBezier.TPalettes.LeafRustle;
  scxSkinBezierPaletteNeonLollipop = TdxSkinNames.TBezier.TPalettes.NeonLollipop;
  scxSkinBezierPaletteTokyo = TdxSkinNames.TBezier.TPalettes.Tokyo;
  scxSkinBezierPaletteFireball = TdxSkinNames.TBezier.TPalettes.Fireball;
  scxSkinBezierPaletteCrambe = TdxSkinNames.TBezier.TPalettes.Crambe;
  scxSkinBezierPaletteGrasshopper = TdxSkinNames.TBezier.TPalettes.Grasshopper;
  scxSkinBezierPaletteCherryInk = TdxSkinNames.TBezier.TPalettes.CherryInk;
  scxSkinBezierPaletteStarshine = TdxSkinNames.TBezier.TPalettes.Starshine;
  scxSkinBezierPaletteBW = TdxSkinNames.TBezier.TPalettes.BW;
  scxSkinBezierPaletteDarkTurquoise = TdxSkinNames.TBezier.TPalettes.DarkTurquoise;
  scxSkinBezierPalettePrometheus = TdxSkinNames.TBezier.TPalettes.Prometheus;
  scxSkinBezierPaletteGhostShark = TdxSkinNames.TBezier.TPalettes.GhostShark;
  scxSkinBezierPaletteBlueVelvet = TdxSkinNames.TBezier.TPalettes.BlueVelvet;
  scxSkinBezierPaletteNorwegianWood = TdxSkinNames.TBezier.TPalettes.NorwegianWood;
  scxSkinBezierPaletteDateFruit = TdxSkinNames.TBezier.TPalettes.DateFruit;
  scxSkinBezierPaletteMilkSnake = TdxSkinNames.TBezier.TPalettes.MilkSnake;
  scxSkinBezierPaletteDragonfly = TdxSkinNames.TBezier.TPalettes.Dragonfly;
  scxSkinBezierPaletteMercuryIce = TdxSkinNames.TBezier.TPalettes.MercuryIce;
  scxSkinBezierPalettePlasticSpace = TdxSkinNames.TBezier.TPalettes.PlasticSpace;
  scxSkinBezierPaletteGloomGloom = TdxSkinNames.TBezier.TPalettes.GloomGloom;
  scxSkinBezierPaletteVolcano = TdxSkinNames.TBezier.TPalettes.Volcano;
  scxSkinBezierPaletteAquarelle = TdxSkinNames.TBezier.TPalettes.Aquarelle;
  scxSkinBezierPaletteOxygen3= TdxSkinNames.TBezier.TPalettes.Oxygen3;
  scxSkinBezierPaletteMorayEel = TdxSkinNames.TBezier.TPalettes.MorayEel;
  scxSkinBezierPaletteWitchRave = TdxSkinNames.TBezier.TPalettes.WitchRave;
  scxSkinBezierPaletteBlackberryShake = TdxSkinNames.TBezier.TPalettes.BlackberryShake;
  scxSkinBezierPaletteVacuum = TdxSkinNames.TBezier.TPalettes.Vacuum;
  scxSkinBezierPaletteNebula = TdxSkinNames.TBezier.TPalettes.Nebula;

  scxSkinOffice2019PaletteGroupGeneral = TdxSkinNames.TOffice2019.TPaletteGroups.General;
  scxSkinOffice2019PaletteDefault = TdxSkinNames.TOffice2019.TPalettes.Default;
  scxSkinOffice2019PaletteYale = TdxSkinNames.TOffice2019.TPalettes.Yale;
  scxSkinOffice2019PaletteForest = TdxSkinNames.TOffice2019.TPalettes.Forest;
  scxSkinOffice2019PalettePine = TdxSkinNames.TOffice2019.TPalettes.Pine;
  scxSkinOffice2019PalettePlum = TdxSkinNames.TOffice2019.TPalettes.Plum;
  scxSkinOffice2019PaletteAmber = TdxSkinNames.TOffice2019.TPalettes.Amber;
  scxSkinOffice2019PaletteFireBrick = TdxSkinNames.TOffice2019.TPalettes.FireBrick;

  scxSkinOffice2019ColorfulDisplayName = TdxSkinNames.TOffice2019.TColorful.DisplayName;
  scxSkinOffice2019BlackDisplayName = TdxSkinNames.TOffice2019.TBlack.DisplayName;
  scxSkinOffice2019DarkGrayDisplayName = TdxSkinNames.TOffice2019.TDarkGray.DisplayName;
  scxSkinOffice2019WhiteDisplayName = TdxSkinNames.TOffice2019.TWhite.DisplayName;

  scxSkinWXIDisplayName = TdxSkinNames.TWXI.DisplayName;
  scxSkinWXIPaletteGroupGeneral = TdxSkinNames.TWXI.TPaletteGroups.General;
  scxSkinWXIPaletteGroupOffice = TdxSkinNames.TWXI.TPaletteGroups.Office;

  scxSkinWXIPaletteDefault = TdxSkinNames.TWXI.TPalettes.Default;
  scxSkinWXIPaletteDarkness = TdxSkinNames.TWXI.TPalettes.Darkness;
  scxSkinWXIPaletteClearness = TdxSkinNames.TWXI.TPalettes.Clearness;
  scxSkinWXIPaletteCalmness = TdxSkinNames.TWXI.TPalettes.Calmness;

  scxSkinWXIPaletteSharpness = TdxSkinNames.TWXI.TPalettes.Sharpness;
  scxSkinWXIPaletteOfficeDarkGray = TdxSkinNames.TWXI.TPalettes.OfficeDarkGray;
  scxSkinWXIPaletteOfficeBlack = TdxSkinNames.TWXI.TPalettes.OfficeBlack;
  scxSkinWXIPaletteOfficeColorful = TdxSkinNames.TWXI.TPalettes.OfficeColorful;
  scxSkinWXIPaletteOfficeWhite = TdxSkinNames.TWXI.TPalettes.OfficeWhite;

  scxSkinBasicDisplayName = TdxSkinNames.TBasic.DisplayName;
  scxSkinBasicPaletteGroupGeneral = TdxSkinNames.TBasic.TPaletteGroups.General;
  scxSkinBasicPaletteDefault = TdxSkinNames.TBasic.TPalettes.Default;
  scxSkinBasicPalettePineLight = TdxSkinNames.TBasic.TPalettes.PineLight;
  scxSkinBasicPaletteVioletLight = TdxSkinNames.TBasic.TPalettes.VioletLight;
  scxSkinBasicPaletteBlueDark = TdxSkinNames.TBasic.TPalettes.BlueDark;
  scxSkinBasicPalettePineDark = TdxSkinNames.TBasic.TPalettes.PineDark;
  scxSkinBasicPaletteVioletDark = TdxSkinNames.TBasic.TPalettes.VioletDark;

  scxSkinOfficeFrom2007To2016Palette = TdxSkinNames.TOffice20072016.TPalettes.Default;
  scxSkinOfficeFrom2007To2016PaletteGroup = TdxSkinNames.TOffice20072016.TPaletteGroups.General;

  scxSkinOffice2007BlackDisplayName = TdxSkinNames.TOffice2007.TBlack.DisplayName;
  scxSkinOffice2007BlueDisplayName = TdxSkinNames.TOffice2007.TBlue.DisplayName;
  scxSkinOffice2007GreenDisplayName = TdxSkinNames.TOffice2007.TGreen.DisplayName;
  scxSkinOffice2007PinkDisplayName = TdxSkinNames.TOffice2007.TPink.DisplayName;
  scxSkinOffice2007SilverDisplayName = TdxSkinNames.TOffice2007.TSilver.DisplayName;
  scxSkinOffice2007DarkGrayDisplayName = TdxSkinNames.TOffice2007.TDarkGray.DisplayName;

  scxSkinOffice2010BlackDisplayName = TdxSkinNames.TOffice2010.TBlack.DisplayName;
  scxSkinOffice2010BlueDisplayName = TdxSkinNames.TOffice2010.TBlue.DisplayName;
  scxSkinOffice2010SilverDisplayName = TdxSkinNames.TOffice2010.TSilver.DisplayName;

  scxSkinOffice2013DarkGrayDisplayName = TdxSkinNames.TOffice2013.TDarkGray.DisplayName;
  scxSkinOffice2013LightGrayDisplayName = TdxSkinNames.TOffice2013.TLightGray.DisplayName;
  scxSkinOffice2013WhiteDisplayName = TdxSkinNames.TOffice2013.TWhite.DisplayName;

  scxSkinOffice2016ColorfulDisplayName = TdxSkinNames.TOffice2016.TColorful.DisplayName;
  scxSkinOffice2016DarkDisplayName = TdxSkinNames.TOffice2016.TDark.DisplayName;

  scxSkinFlatDisplayName = TdxSkinNames.TFlat.DisplayName;
  scxSkinNativeDisplayName = TdxSkinNames.TNative.DisplayName;
  scxSkinOffice11DisplayName = TdxSkinNames.TOffice11.DisplayName;
  scxSkinStandardDisplayName = TdxSkinNames.TStandard.DisplayName;
  scxSkinUltraFlatDisplayName = TdxSkinNames.TUltraFlat.DisplayName;

  scxSkinRasterPalettesPaletteDefault = TdxSkinNames.TRasterPalettes.PaletteDefault;
  scxSkinRasterPalettesPaletteGroupGeneral = TdxSkinNames.TRasterPalettes.PaletteGroupGeneral;
  scxSkinBlackDisplayName = TdxSkinNames.TBlack.DisplayName;
  scxSkinBlueDisplayName = TdxSkinNames.TBlue.DisplayName;
  scxSkinBlueprintDisplayName = TdxSkinNames.TBlueprint.DisplayName;
  scxSkinCaramelDisplayName = TdxSkinNames.TCaramel.DisplayName;
  scxSkinCoffeeDisplayName = TdxSkinNames.TCoffee.DisplayName;
  scxSkinDarkroomDisplayName = TdxSkinNames.TDarkroom.DisplayName;
  scxSkinDarkSideDisplayName = TdxSkinNames.TDarkSide.DisplayName;
  scxSkinDevExpressDarkStyleDisplayName = TdxSkinNames.TDevExpressDarkStyle.DisplayName;
  scxSkinDevExpressStyleDisplayName = TdxSkinNames.TDevExpressStyle.DisplayName;
  scxSkinFoggyDisplayName = TdxSkinNames.TFoggy.DisplayName;
  scxSkinGlassOceansDisplayName = TdxSkinNames.TGlassOceans.DisplayName;
  scxSkinHighContrastDisplayName = TdxSkinNames.THighContrast.DisplayName;
  scxSkiniMaginaryDisplayName = TdxSkinNames.TiMaginary.DisplayName;
  scxSkinLilianDisplayName = TdxSkinNames.TLilian.DisplayName;
  scxSkinLiquidSkyDisplayName = TdxSkinNames.TLiquidSky.DisplayName;
  scxSkinLondonLiquidSkyDisplayName = TdxSkinNames.TLondonLiquidSky.DisplayName;
  scxSkinMcSkinDisplayName = TdxSkinNames.TMcSkin.DisplayName;
  scxSkinMetropolisDisplayName = TdxSkinNames.TMetropolis.DisplayName;
  scxSkinMetropolisDarkDisplayName = TdxSkinNames.TMetropolisDark.DisplayName;
  scxSkinMoneyTwinsDisplayName = TdxSkinNames.TMoneyTwins.DisplayName;
  scxSkinPumpkinDisplayName = TdxSkinNames.TPumpkin.DisplayName;
  scxSkinSevenDisplayName = TdxSkinNames.TSeven.DisplayName;
  scxSkinSevenClassicDisplayName = TdxSkinNames.TSevenClassic.DisplayName;
  scxSkinSharpDisplayName = TdxSkinNames.TSharp.DisplayName;
  scxSkinSharpPlusDisplayName = TdxSkinNames.TSharpPlus.DisplayName;
  scxSkinSilverDisplayName = TdxSkinNames.TSilver.DisplayName;
  scxSkinSpringtimeDisplayName = TdxSkinNames.TSpringtime.DisplayName;
  scxSkinStardustDisplayName = TdxSkinNames.TStardust.DisplayName;
  scxSkinSummer2008DisplayName = TdxSkinNames.TSummer2008.DisplayName;
  scxSkinTheAsphaltWorldDisplayName = TdxSkinNames.TTheAsphaltWorld.DisplayName;
  scxSkinValentineDisplayName = TdxSkinNames.TValentine.DisplayName;
  scxSkinWhiteprintDisplayName = TdxSkinNames.TWhiteprint.DisplayName;
  scxSkinXmas2008BlueDisplayName = TdxSkinNames.TXmas2008Blue.DisplayName;

  scxSkinVS2013BlueDisplayName = TdxSkinNames.TVisualStudio.T2013Blue.DisplayName;
  scxSkinVS2013DarkDisplayName = TdxSkinNames.TVisualStudio.T2013Dark.DisplayName;
  scxSkinVS2013LightDisplayName = TdxSkinNames.TVisualStudio.T2013Light.DisplayName;
  scxSkinVS2010DisplayName = TdxSkinNames.TVisualStudio.TVS2010.DisplayName;
  scxSkinVSPaletteDefault = TdxSkinNames.TVisualStudio.TPalettes.Default;
  scxSkinVSPaletteGroupGeneral = TdxSkinNames.TVisualStudio.TPaletteGroups.General;

{$ENDREGION}

{$REGION 'TdxSkinNameList'}
type

  TdxSkinResString = Pointer; // for internal use

  { TdxSkinNameList }

  TdxSkinNameList = class // for internal use
  protected type
    TSkin = class;
    TPalettes = class;
    TNamedObject = class
    strict private
      FOwner: TNamedObject;
      FName: string;
      FDisplayName: string;
      FGroupName: string;
      FResDisplayName: TdxSkinResString;
      FResGroupName: TdxSkinResString;
      function GetDisplayGroupName: string;
      function GetDisplayName: string;
    protected
      property Owner: TNamedObject read FOwner;
    public
      constructor Create(AOwner: TNamedObject; const AName, ADisplayName, AGroupName: string; AResDisplayName, AResGroupName: TdxSkinResString);
      property DisplayName: string read GetDisplayName;
      property DisplayGroupName: string read GetDisplayGroupName;
      property GroupName: string read FGroupName;
    end;

    TPalette = class(TNamedObject);

    TPalettes = class(TObjectDictionary<string, TPalette>);

    TSkin = class(TNamedObject)
    strict private
      FPalettes: TPalettes;
    public
      constructor Create(const AName, ADisplayName, AGroupName: string; AResDisplayName, AResGroupName: TdxSkinResString);
      destructor Destroy; override;
      procedure AddPalette(const APaletteID: string; AResName: TdxSkinResString; AGroupName: string; AResGroupName: TdxSkinResString);
      function TryGetPalette(const APaletteID: string; out APalette: TPalette): Boolean;
    end;

    TSkins = class(TObjectDictionary<string, TSkin>);

  strict private
    FSkins: TSkins;
  protected
    class var FInstance: TdxSkinNameList;
    class procedure Initialize;
    class procedure Finalize;
    function CreateSkin(const ASkinID, ADisplayName: string; AResDisplayName: TdxSkinResString; AGroupName: string; AResGroupName: TdxSkinResString): TSkin;
    function GetSkin(const ASkinID: string): TSkin;
    function GetPalette(const ASkinID, APaletteID: string): TPalette;
    procedure Populate;
  public
    constructor Create;
    destructor Destroy; override;
    class function GetLocalizedSkinInfo(const ASkinID: string; out ADisplaySkinName, ADisplayGroupName, AGroupName: string): Boolean;
    class function GetLocalizedPaletteInfo(const ASkinID, APaletteID: string; out APaletteName, AGroupName: string): Boolean;
  end;

{$ENDREGION}

implementation

const
  dxThisUnitName = 'dxSkinNames';

const
  SkinGroups: array [TdxSkinGroup] of string = (
    TdxSkinNames.TGroups.Vector,
    TdxSkinNames.TGroups.LookAndFeelStyles,
    TdxSkinNames.TGroups.Office,
    TdxSkinNames.TGroups.Default,
    TdxSkinNames.TGroups.LatestOfficeSkins,
    TdxSkinNames.TGroups.VisualStudio,
    TdxSkinNames.TGroups.PreviousOfficeSkins,
    TdxSkinNames.TGroups.ThematicFlat,
    TdxSkinNames.TGroups.Seasonal,
    TdxSkinNames.TGroups.Thematic,
    TdxSkinNames.TGroups.RetroFlat,
    TdxSkinNames.TGroups.Retro3D,
    TdxSkinNames.TGroups.Custom,
    TdxSkinNames.DefaultSkinGroup
    );

function dxStringToSkinGroup(const AName: string): TdxSkinGroup;
var
  I: TdxSkinGroup;
begin
  for I := Low(TdxSkinGroup) to High(TdxSkinGroup) do
    if SkinGroups[I] = AName then
      Exit(I);
  Result := TdxSkinGroup.Common;
end;

function dxStringsToSkinGroups(AList: TStrings): TdxSkinGroups;
var
  I: Integer;
begin
  Result := [];
  for I := 0 to AList.Count - 1 do
    if AList[I] <> '' then
      Include(Result, dxStringToSkinGroup(AList[I]));
end;

procedure dxSkinGroupsToStrings(ANames: TdxSkinGroups; AList: TStrings);
var
  I: TdxSkinGroup;
begin
  AList.BeginUpdate;
  try
    AList.Clear;
    for I := Low(TdxSkinGroup) to High(TdxSkinGroup) do
      if I in ANames then
        AList.Add(SkinGroups[I]);
    if AList.Count = 0 then
      AList.Add('');
  finally
    AList.EndUpdate;
  end;
end;

{$REGION 'TdxSkinNameList'}

{ TdxSkinNamesList.TSkin }

constructor TdxSkinNameList.TSkin.Create(const AName, ADisplayName, AGroupName: string; AResDisplayName, AResGroupName: TdxSkinResString);
begin
  inherited Create(nil, AName, ADisplayName, AGroupName, AResDisplayName, AResGroupName);
  FPalettes := TPalettes.Create([doOwnsValues], 32);
end;

destructor TdxSkinNameList.TSkin.Destroy;
begin
  FreeAndNil(FPalettes);
  inherited Destroy;
end;

procedure TdxSkinNameList.TSkin.AddPalette(const APaletteID: string; AResName: TdxSkinResString; AGroupName: string; AResGroupName: TdxSkinResString);
begin
  FPalettes.Add(APaletteID, TPalette.Create(Self, APaletteID, APaletteID, AGroupName, AResName, AResGroupName));
end;

function TdxSkinNameList.TSkin.TryGetPalette(const APaletteID: string; out APalette: TPalette): Boolean;
begin
  APalette := nil;
  Result := FPalettes.TryGetValue(APaletteID, APalette);
end;

{ TdxSkinNamesList.TBaseObject }

constructor TdxSkinNameList.TNamedObject.Create(AOwner: TNamedObject;
  const AName, ADisplayName, AGroupName: string; AResDisplayName, AResGroupName: TdxSkinResString);
begin
  inherited Create;
  FOwner := AOwner;
  FName := AName;
  FDisplayName := ADisplayName;
  FGroupName := AGroupName;
  FResDisplayName := AResDisplayName;
  FResGroupName := AResGroupName;
end;

function TdxSkinNameList.TNamedObject.GetDisplayGroupName: string;
begin
  if FResGroupName <> nil then
    Result := cxGetResourceString(FResGroupName)
  else
    Result := FGroupName;
end;

function TdxSkinNameList.TNamedObject.GetDisplayName: string;
begin
  if FResDisplayName <> nil then
    Result := cxGetResourceString(FResDisplayName)
  else
    Result := FDisplayName;
end;

{ TdxSkinNamesList }

constructor TdxSkinNameList.Create;
begin
  inherited Create;
  FSkins := TSkins.Create([doOwnsValues], 32);
  Populate;
end;

destructor TdxSkinNameList.Destroy;
begin
  FreeAndNil(FSkins);
  inherited Destroy;
end;

class procedure TdxSkinNameList.Initialize;
begin
  FInstance := TdxSkinNameList.Create;
end;

class procedure TdxSkinNameList.Finalize;
begin
  FreeAndNil(FInstance);
end;

function TdxSkinNameList.CreateSkin(const ASkinID, ADisplayName: string; AResDisplayName: TdxSkinResString; AGroupName: string; AResGroupName: TdxSkinResString): TSkin;
begin
  Assert(ASkinID <> '');
  Result := TSkin.Create(ASkinID, ADisplayName, AGroupName, AResDisplayName, AResGroupName);
  FSkins.Add(ASkinID, Result);
end;

class function TdxSkinNameList.GetLocalizedSkinInfo(const ASkinID: string; out ADisplaySkinName, ADisplayGroupName, AGroupName: string): Boolean;
var
  ASkin: TSkin;
begin
  ASkin := FInstance.GetSkin(ASkinID);
  Result := ASkin <> nil;
  if Result then
  begin
    ADisplaySkinName := ASkin.DisplayName;
    ADisplayGroupName := ASkin.DisplayGroupName;
    AGroupName := ASkin.GroupName;
  end
  else
  begin
    ADisplaySkinName := ASkinID;
    ADisplayGroupName := cxGetResourceString(@scxSkinDefaultSkinGroup);
    AGroupName := TdxSkinNames.DefaultSkinGroup;
  end;
end;

class function TdxSkinNameList.GetLocalizedPaletteInfo(const ASkinID, APaletteID: string; out APaletteName, AGroupName: string): Boolean;
var
  APalette: TPalette;
begin
  APalette := FInstance.GetPalette(ASkinID, APaletteID);
  Result := APalette <> nil;
  if Result then
  begin
    APaletteName := APalette.DisplayName;
    AGroupName := APalette.DisplayGroupName;
  end
  else
  begin
    APaletteName := APaletteID;
    AGroupName := cxGetResourceString(@scxSkinDefaultPaletteGroup);
  end;
end;

function TdxSkinNameList.GetPalette(const ASkinID, APaletteID: string): TPalette;
var
  ASkin: TSkin;
begin
  Result := nil;
  if FSkins.TryGetValue(ASkinID, ASkin) then
    ASkin.TryGetPalette(APaletteID, Result);
end;

function TdxSkinNameList.GetSkin(const ASkinID: string): TSkin;
begin
  if not FSkins.TryGetValue(ASkinID, Result) then
    Result := nil;
end;

{$ENDREGION}

{$REGION 'Populate'}

procedure TdxSkinNameList.Populate;

  procedure PopulateBezier;
  var
    ASkin: TSkin;
  begin
    ASkin := CreateSkin(TdxSkinNames.TBezier.ID, TdxSkinNames.TBezier.DisplayName, @scxSkinBezierDisplayName,
      TdxSkinNames.TGroups.Vector, @scxSkinGroupVector);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.Default, @scxSkinBezierPaletteDefault,
      TdxSkinNames.TBezier.TPaletteGroups.General, @scxSkinBezierPaletteGroupGeneral);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.ArtHouse, @scxSkinBezierPaletteArtHouse,
      TdxSkinNames.TBezier.TPaletteGroups.General, @scxSkinBezierPaletteGroupGeneral);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.LeafRustle, @scxSkinBezierPaletteLeafRustle,
      TdxSkinNames.TBezier.TPaletteGroups.Light, @scxSkinBezierPaletteGroupLight);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.NeonLollipop, @scxSkinBezierPaletteNeonLollipop,
      TdxSkinNames.TBezier.TPaletteGroups.Light, @scxSkinBezierPaletteGroupLight);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.Tokyo, @scxSkinBezierPaletteTokyo,
      TdxSkinNames.TBezier.TPaletteGroups.Light, @scxSkinBezierPaletteGroupLight);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.Fireball, @scxSkinBezierPaletteFireball,
      TdxSkinNames.TBezier.TPaletteGroups.Dark, @scxSkinBezierPaletteGroupDark);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.Crambe, @scxSkinBezierPaletteCrambe,
      TdxSkinNames.TBezier.TPaletteGroups.Dark, @scxSkinBezierPaletteGroupDark);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.Grasshopper, @scxSkinBezierPaletteGrasshopper,
      TdxSkinNames.TBezier.TPaletteGroups.Light, @scxSkinBezierPaletteGroupLight);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.CherryInk, @scxSkinBezierPaletteCherryInk,
      TdxSkinNames.TBezier.TPaletteGroups.Dark, @scxSkinBezierPaletteGroupDark);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.Starshine, @scxSkinBezierPaletteStarshine,
      TdxSkinNames.TBezier.TPaletteGroups.Dark, @scxSkinBezierPaletteGroupDark);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.BW, @scxSkinBezierPaletteBW,
      TdxSkinNames.TBezier.TPaletteGroups.Light, @scxSkinBezierPaletteGroupLight);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.DarkTurquoise, @scxSkinBezierPaletteDarkTurquoise,
      TdxSkinNames.TBezier.TPaletteGroups.Dark, @scxSkinBezierPaletteGroupDark);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.Prometheus, @scxSkinBezierPalettePrometheus,
      TdxSkinNames.TBezier.TPaletteGroups.Dark, @scxSkinBezierPaletteGroupDark);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.GhostShark, @scxSkinBezierPaletteGhostShark,
      TdxSkinNames.TBezier.TPaletteGroups.Dark, @scxSkinBezierPaletteGroupDark);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.BlueVelvet, @scxSkinBezierPaletteBlueVelvet,
      TdxSkinNames.TBezier.TPaletteGroups.Dark, @scxSkinBezierPaletteGroupDark);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.NorwegianWood, @scxSkinBezierPaletteNorwegianWood,
      TdxSkinNames.TBezier.TPaletteGroups.Light, @scxSkinBezierPaletteGroupLight);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.DateFruit, @scxSkinBezierPaletteDateFruit,
      TdxSkinNames.TBezier.TPaletteGroups.Light, @scxSkinBezierPaletteGroupLight);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.MilkSnake, @scxSkinBezierPaletteMilkSnake,
      TdxSkinNames.TBezier.TPaletteGroups.Dark, @scxSkinBezierPaletteGroupDark);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.Dragonfly, @scxSkinBezierPaletteDragonfly,
      TdxSkinNames.TBezier.TPaletteGroups.Light, @scxSkinBezierPaletteGroupLight);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.MercuryIce, @scxSkinBezierPaletteMercuryIce,
      TdxSkinNames.TBezier.TPaletteGroups.Dark, @scxSkinBezierPaletteGroupDark);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.PlasticSpace, @scxSkinBezierPalettePlasticSpace,
      TdxSkinNames.TBezier.TPaletteGroups.Light, @scxSkinBezierPaletteGroupLight);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.GloomGloom, @scxSkinBezierPaletteGloomGloom,
      TdxSkinNames.TBezier.TPaletteGroups.Light, @scxSkinBezierPaletteGroupLight);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.Volcano, @scxSkinBezierPaletteVolcano,
      TdxSkinNames.TBezier.TPaletteGroups.Dark, @scxSkinBezierPaletteGroupDark);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.Aquarelle, @scxSkinBezierPaletteAquarelle,
      TdxSkinNames.TBezier.TPaletteGroups.Light, @scxSkinBezierPaletteGroupLight);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.Oxygen3, @scxSkinBezierPaletteOxygen3,
      TdxSkinNames.TBezier.TPaletteGroups.Light, @scxSkinBezierPaletteGroupLight);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.MorayEel, @scxSkinBezierPaletteMorayEel,
      TdxSkinNames.TBezier.TPaletteGroups.Light, @scxSkinBezierPaletteGroupLight);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.WitchRave, @scxSkinBezierPaletteWitchRave,
      TdxSkinNames.TBezier.TPaletteGroups.Dark, @scxSkinBezierPaletteGroupDark);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.BlackberryShake, @scxSkinBezierPaletteBlackberryShake,
      TdxSkinNames.TBezier.TPaletteGroups.Light, @scxSkinBezierPaletteGroupLight);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.Vacuum, @scxSkinBezierPaletteVacuum,
      TdxSkinNames.TBezier.TPaletteGroups.Light, @scxSkinBezierPaletteGroupLight);

    ASkin.AddPalette(TdxSkinNames.TBezier.TPalettes.Nebula, @scxSkinBezierPaletteNebula,
      TdxSkinNames.TBezier.TPaletteGroups.Dark, @scxSkinBezierPaletteGroupDark);
  end;

  procedure PopulateOffice2019;

    procedure PopulatePalettes(ASkin: TSkin);
    begin
      ASkin.AddPalette(TdxSkinNames.TOffice2019.TPalettes.Default, @scxSkinOffice2019PaletteDefault,
        TdxSkinNames.TOffice2019.TPaletteGroups.General, @scxSkinOffice2019PaletteGroupGeneral);
      ASkin.AddPalette(TdxSkinNames.TOffice2019.TPalettes.Yale, @scxSkinOffice2019PaletteYale,
        TdxSkinNames.TOffice2019.TPaletteGroups.General, @scxSkinOffice2019PaletteGroupGeneral);
      ASkin.AddPalette(TdxSkinNames.TOffice2019.TPalettes.Forest, @scxSkinOffice2019PaletteForest,
        TdxSkinNames.TOffice2019.TPaletteGroups.General, @scxSkinOffice2019PaletteGroupGeneral);
      ASkin.AddPalette(TdxSkinNames.TOffice2019.TPalettes.Pine, @scxSkinOffice2019PalettePine,
        TdxSkinNames.TOffice2019.TPaletteGroups.General, @scxSkinOffice2019PaletteGroupGeneral);
      ASkin.AddPalette(TdxSkinNames.TOffice2019.TPalettes.Plum, @scxSkinOffice2019PalettePlum,
        TdxSkinNames.TOffice2019.TPaletteGroups.General, @scxSkinOffice2019PaletteGroupGeneral);
      ASkin.AddPalette(TdxSkinNames.TOffice2019.TPalettes.Amber, @scxSkinOffice2019PaletteAmber,
        TdxSkinNames.TOffice2019.TPaletteGroups.General, @scxSkinOffice2019PaletteGroupGeneral);
      ASkin.AddPalette(TdxSkinNames.TOffice2019.TPalettes.FireBrick, @scxSkinOffice2019PaletteFireBrick,
        TdxSkinNames.TOffice2019.TPaletteGroups.General, @scxSkinOffice2019PaletteGroupGeneral);
    end;
  var
    ASkin: TSkin;
  begin
    ASkin := CreateSkin(TdxSkinNames.TOffice2019.TColorful.ID,
      TdxSkinNames.TOffice2019.TColorful.DisplayName,
      @scxSkinOffice2019ColorfulDisplayName,
      TdxSkinNames.TGroups.Vector, @scxSkinGroupVector);
    PopulatePalettes(ASkin);

    ASkin := CreateSkin(TdxSkinNames.TOffice2019.TBlack.ID,
      TdxSkinNames.TOffice2019.TBlack.DisplayName,
      @scxSkinOffice2019BlackDisplayName,
      TdxSkinNames.TGroups.Vector, @scxSkinGroupVector);
    PopulatePalettes(ASkin);

    ASkin := CreateSkin(TdxSkinNames.TOffice2019.TDarkGray.ID,
      TdxSkinNames.TOffice2019.TDarkGray.DisplayName,
      @scxSkinOffice2019DarkGrayDisplayName,
      TdxSkinNames.TGroups.Vector, @scxSkinGroupVector);
    PopulatePalettes(ASkin);

    ASkin := CreateSkin(TdxSkinNames.TOffice2019.TWhite.ID,
      TdxSkinNames.TOffice2019.TWhite.DisplayName,
      @scxSkinOffice2019WhiteDisplayName,
      TdxSkinNames.TGroups.Vector, @scxSkinGroupVector);
    PopulatePalettes(ASkin);
  end;

  procedure PopulateWXI;
  var
    ASkin: TSkin;
  begin
    ASkin := CreateSkin(TdxSkinNames.TWXI.ID,
      TdxSkinNames.TWXI.DisplayName,
      @scxSkinWXIDisplayName,
      TdxSkinNames.TGroups.Vector, @scxSkinGroupVector);

    ASkin.AddPalette(TdxSkinNames.TWXI.TPalettes.Default, @scxSkinWXIPaletteDefault,
      TdxSkinNames.TWXI.TPaletteGroups.General, @scxSkinWXIPaletteGroupGeneral);
    ASkin.AddPalette(TdxSkinNames.TWXI.TPalettes.Darkness, @scxSkinWXIPaletteDarkness,
      TdxSkinNames.TWXI.TPaletteGroups.General, @scxSkinWXIPaletteGroupGeneral);
    ASkin.AddPalette(TdxSkinNames.TWXI.TPalettes.Clearness, @scxSkinWXIPaletteClearness,
      TdxSkinNames.TWXI.TPaletteGroups.General, @scxSkinWXIPaletteGroupGeneral);
    ASkin.AddPalette(TdxSkinNames.TWXI.TPalettes.Calmness, @scxSkinWXIPaletteCalmness,
      TdxSkinNames.TWXI.TPaletteGroups.General, @scxSkinWXIPaletteGroupGeneral);
    ASkin.AddPalette(TdxSkinNames.TWXI.TPalettes.Sharpness, @scxSkinWXIPaletteSharpness,
      TdxSkinNames.TWXI.TPaletteGroups.General, @scxSkinWXIPaletteGroupGeneral);

    ASkin.AddPalette(TdxSkinNames.TWXI.TPalettes.OfficeDarkGray, @scxSkinWXIPaletteOfficeDarkGray,
      TdxSkinNames.TWXI.TPaletteGroups.Office, @scxSkinWXIPaletteGroupOffice);
    ASkin.AddPalette(TdxSkinNames.TWXI.TPalettes.OfficeBlack, @scxSkinWXIPaletteOfficeBlack,
      TdxSkinNames.TWXI.TPaletteGroups.Office, @scxSkinWXIPaletteGroupOffice);
    ASkin.AddPalette(TdxSkinNames.TWXI.TPalettes.OfficeColorful, @scxSkinWXIPaletteOfficeColorful,
      TdxSkinNames.TWXI.TPaletteGroups.Office, @scxSkinWXIPaletteGroupOffice);
    ASkin.AddPalette(TdxSkinNames.TWXI.TPalettes.OfficeWhite, @scxSkinWXIPaletteOfficeWhite,
      TdxSkinNames.TWXI.TPaletteGroups.Office, @scxSkinWXIPaletteGroupOffice);
  end;

  procedure PopulateBasic;
  var
    ASkin: TSkin;
  begin
    ASkin := CreateSkin(TdxSkinNames.TBasic.ID,
      TdxSkinNames.TBasic.DisplayName,
      @scxSkinBasicDisplayName,
      TdxSkinNames.TGroups.Vector, @scxSkinGroupVector);

    ASkin.AddPalette(TdxSkinNames.TBasic.TPalettes.Default, @scxSkinBasicPaletteDefault,
      TdxSkinNames.TBasic.TPaletteGroups.General, @scxSkinBasicPaletteGroupGeneral);
    ASkin.AddPalette(TdxSkinNames.TBasic.TPalettes.PineLight, @scxSkinBasicPalettePineLight,
      TdxSkinNames.TBasic.TPaletteGroups.General, @scxSkinBasicPaletteGroupGeneral);
    ASkin.AddPalette(TdxSkinNames.TBasic.TPalettes.VioletLight, @scxSkinBasicPaletteVioletLight,
      TdxSkinNames.TBasic.TPaletteGroups.General, @scxSkinBasicPaletteGroupGeneral);
    ASkin.AddPalette(TdxSkinNames.TBasic.TPalettes.BlueDark, @scxSkinBasicPaletteBlueDark,
      TdxSkinNames.TBasic.TPaletteGroups.General, @scxSkinBasicPaletteGroupGeneral);
    ASkin.AddPalette(TdxSkinNames.TBasic.TPalettes.PineDark, @scxSkinBasicPalettePineDark,
      TdxSkinNames.TBasic.TPaletteGroups.General, @scxSkinBasicPaletteGroupGeneral);
    ASkin.AddPalette(TdxSkinNames.TBasic.TPalettes.VioletDark, @scxSkinBasicPaletteVioletDark,
      TdxSkinNames.TBasic.TPaletteGroups.General, @scxSkinBasicPaletteGroupGeneral);
  end;

  procedure PopulateOffice20072016;

    procedure PopulateOfPalettes(ASkin: TSkin);
    begin
      ASkin.AddPalette(TdxSkinNames.TOffice20072016.TPalettes.Default, @scxSkinOfficeFrom2007To2016Palette,
        TdxSkinNames.TOffice20072016.TPaletteGroups.General, @scxSkinOfficeFrom2007To2016PaletteGroup);
    end;

  var
    ASkin: TSkin;
  begin
    CreateSkin(TdxSkinNames.TOffice2007.TBlack.ID,
      TdxSkinNames.TOffice2007.TBlack.DisplayName,
      @scxSkinOffice2007BlackDisplayName,
      TdxSkinNames.TGroups.Office, @scxSkinGroupOffice);

    CreateSkin(TdxSkinNames.TOffice2007.TBlue.ID,
      TdxSkinNames.TOffice2007.TBlue.DisplayName,
      @scxSkinOffice2007BlueDisplayName,
      TdxSkinNames.TGroups.Office, @scxSkinGroupOffice);

    CreateSkin(TdxSkinNames.TOffice2007.TGreen.ID,
      TdxSkinNames.TOffice2007.TGreen.DisplayName,
      @scxSkinOffice2007GreenDisplayName,
      TdxSkinNames.TGroups.Office, @scxSkinGroupOffice);

    CreateSkin(TdxSkinNames.TOffice2007.TPink.ID,
      TdxSkinNames.TOffice2007.TPink.DisplayName,
      @scxSkinOffice2007PinkDisplayName,
      TdxSkinNames.TGroups.Office, @scxSkinGroupOffice);

    CreateSkin(TdxSkinNames.TOffice2007.TSilver.ID,
      TdxSkinNames.TOffice2007.TSilver.DisplayName,
      @scxSkinOffice2007SilverDisplayName,
      TdxSkinNames.TGroups.Office, @scxSkinGroupOffice);

    CreateSkin(TdxSkinNames.TOffice2007.TDarkGray.ID,
      TdxSkinNames.TOffice2007.TDarkGray.DisplayName,
      @scxSkinOffice2007DarkGrayDisplayName,
      TdxSkinNames.TGroups.Office, @scxSkinGroupOffice);

    ASkin := CreateSkin(TdxSkinNames.TOffice2010.TBlack.ID,
      TdxSkinNames.TOffice2010.TBlack.DisplayName,
      @scxSkinOffice2010BlackDisplayName,
      TdxSkinNames.TGroups.PreviousOfficeSkins, @scxSkinGroupPreviousOfficeSkins);
    PopulateOfPalettes(ASkin);

    ASkin := CreateSkin(TdxSkinNames.TOffice2010.TBlue.ID,
      TdxSkinNames.TOffice2010.TBlue.DisplayName,
      @scxSkinOffice2010BlueDisplayName,
      TdxSkinNames.TGroups.PreviousOfficeSkins, @scxSkinGroupPreviousOfficeSkins);
    PopulateOfPalettes(ASkin);

    ASkin := CreateSkin(TdxSkinNames.TOffice2010.TSilver.ID,
      TdxSkinNames.TOffice2010.TSilver.DisplayName,
      @scxSkinOffice2010SilverDisplayName,
      TdxSkinNames.TGroups.PreviousOfficeSkins, @scxSkinGroupPreviousOfficeSkins);
    PopulateOfPalettes(ASkin);

    ASkin := CreateSkin(TdxSkinNames.TOffice2013.TDarkGray.ID,
      TdxSkinNames.TOffice2013.TDarkGray.DisplayName,
      @scxSkinOffice2013DarkGrayDisplayName,
      TdxSkinNames.TGroups.LatestOfficeSkins, @scxSkinGroupLatestOfficeSkins);
    PopulateOfPalettes(ASkin);

    ASkin := CreateSkin(TdxSkinNames.TOffice2013.TLightGray.ID,
      TdxSkinNames.TOffice2013.TLightGray.DisplayName,
      @scxSkinOffice2013LightGrayDisplayName,
      TdxSkinNames.TGroups.LatestOfficeSkins, @scxSkinGroupLatestOfficeSkins);
    PopulateOfPalettes(ASkin);

    ASkin := CreateSkin(TdxSkinNames.TOffice2013.TWhite.ID,
      TdxSkinNames.TOffice2013.TWhite.DisplayName,
      @scxSkinOffice2013WhiteDisplayName,
      TdxSkinNames.TGroups.LatestOfficeSkins, @scxSkinGroupLatestOfficeSkins);
    PopulateOfPalettes(ASkin);

    ASkin := CreateSkin(TdxSkinNames.TOffice2016.TColorful.ID,
      TdxSkinNames.TOffice2016.TColorful.DisplayName,
      @scxSkinOffice2016ColorfulDisplayName,
      TdxSkinNames.TGroups.LatestOfficeSkins, @scxSkinGroupLatestOfficeSkins);
    PopulateOfPalettes(ASkin);

    ASkin := CreateSkin(TdxSkinNames.TOffice2016.TDark.ID,
      TdxSkinNames.TOffice2016.TDark.DisplayName,
      @scxSkinOffice2016DarkDisplayName,
      TdxSkinNames.TGroups.LatestOfficeSkins, @scxSkinGroupLatestOfficeSkins);
    PopulateOfPalettes(ASkin);
  end;

  procedure PopulateNative;
  begin
    CreateSkin(TdxSkinNames.TFlat.ID,
      TdxSkinNames.TFlat.DisplayName,
      @scxSkinFlatDisplayName,
      TdxSkinNames.TGroups.LookAndFeelStyles, @scxSkinGroupLookAndFeelStyles);

    CreateSkin(TdxSkinNames.TNative.ID,
      TdxSkinNames.TNative.DisplayName,
      @scxSkinNativeDisplayName,
      TdxSkinNames.TGroups.LookAndFeelStyles, @scxSkinGroupLookAndFeelStyles);

    CreateSkin(TdxSkinNames.TOffice11.ID,
      TdxSkinNames.TOffice11.DisplayName,
      @scxSkinOffice11DisplayName,
      TdxSkinNames.TGroups.LookAndFeelStyles, @scxSkinGroupLookAndFeelStyles);

    CreateSkin(TdxSkinNames.TStandard.ID,
      TdxSkinNames.TStandard.DisplayName,
      @scxSkinStandardDisplayName,
      TdxSkinNames.TGroups.LookAndFeelStyles, @scxSkinGroupLookAndFeelStyles);

    CreateSkin(TdxSkinNames.TUltraFlat.ID,
      TdxSkinNames.TUltraFlat.DisplayName,
      @scxSkinUltraFlatDisplayName,
      TdxSkinNames.TGroups.LookAndFeelStyles, @scxSkinGroupLookAndFeelStyles);
  end;

  procedure PopulateRaster;
  begin
    CreateSkin(TdxSkinNames.TBlack.ID,
      TdxSkinNames.TBlack.DisplayName,
      @scxSkinBlackDisplayName,
      TdxSkinNames.TGroups.Thematic, @scxSkinGroupThematic);

    CreateSkin(TdxSkinNames.TBlue.ID,
      TdxSkinNames.TBlue.DisplayName,
      @scxSkinBlueDisplayName,
      TdxSkinNames.TGroups.Thematic, @scxSkinGroupThematic);

    CreateSkin(TdxSkinNames.TBlueprint.ID,
      TdxSkinNames.TBlueprint.DisplayName,
      @scxSkinBlueprintDisplayName,
      TdxSkinNames.TGroups.ThematicFlat, @scxSkinGroupThematicFlat)
        .AddPalette(TdxSkinNames.TRasterPalettes.PaletteDefault, @scxSkinRasterPalettesPaletteDefault,
          TdxSkinNames.TRasterPalettes.PaletteGroupGeneral, @scxSkinRasterPalettesPaletteGroupGeneral);

    CreateSkin(TdxSkinNames.TCaramel.ID,
      TdxSkinNames.TCaramel.DisplayName,
      @scxSkinCaramelDisplayName,
      TdxSkinNames.TGroups.Retro3D, @scxSkinGroupRetro3D);

    CreateSkin(TdxSkinNames.TCoffee.ID,
      TdxSkinNames.TCoffee.DisplayName,
      @scxSkinCoffeeDisplayName,
      TdxSkinNames.TGroups.Retro3D, @scxSkinGroupRetro3D);

    CreateSkin(TdxSkinNames.TDarkroom.ID,
      TdxSkinNames.TDarkroom.DisplayName,
      @scxSkinDarkroomDisplayName,
      TdxSkinNames.TGroups.Thematic, @scxSkinGroupThematic);

    CreateSkin(TdxSkinNames.TDarkSide.ID,
      TdxSkinNames.TDarkSide.DisplayName,
      @scxSkinDarkSideDisplayName,
      TdxSkinNames.TGroups.Retro3D, @scxSkinGroupRetro3D);

    CreateSkin(TdxSkinNames.TDevExpressDarkStyle.ID,
      TdxSkinNames.TDevExpressDarkStyle.DisplayName,
      @scxSkinDevExpressDarkStyleDisplayName,
      TdxSkinNames.TGroups.Default, @scxSkinGroupDefault)
        .AddPalette(TdxSkinNames.TRasterPalettes.PaletteDefault, @scxSkinRasterPalettesPaletteDefault,
          TdxSkinNames.TRasterPalettes.PaletteGroupGeneral, @scxSkinRasterPalettesPaletteGroupGeneral);

    CreateSkin(TdxSkinNames.TDevExpressStyle.ID,
      TdxSkinNames.TDevExpressStyle.DisplayName,
      @scxSkinDevExpressStyleDisplayName,
      TdxSkinNames.TGroups.Default, @scxSkinGroupDefault)
        .AddPalette(TdxSkinNames.TRasterPalettes.PaletteDefault, @scxSkinRasterPalettesPaletteDefault,
          TdxSkinNames.TRasterPalettes.PaletteGroupGeneral, @scxSkinRasterPalettesPaletteGroupGeneral);

    CreateSkin(TdxSkinNames.TFoggy.ID,
      TdxSkinNames.TFoggy.DisplayName,
      @scxSkinFoggyDisplayName,
      TdxSkinNames.TGroups.RetroFlat, @scxSkinGroupRetroFlat);

    CreateSkin(TdxSkinNames.TGlassOceans.ID,
      TdxSkinNames.TGlassOceans.DisplayName,
      @scxSkinGlassOceansDisplayName,
      TdxSkinNames.TGroups.Retro3D, @scxSkinGroupRetro3D);

    CreateSkin(TdxSkinNames.THighContrast.ID,
      TdxSkinNames.THighContrast.DisplayName,
      @scxSkinHighContrastDisplayName,
      TdxSkinNames.TGroups.ThematicFlat, @scxSkinGroupThematicFlat);

    CreateSkin(TdxSkinNames.TiMaginary.ID,
      TdxSkinNames.TiMaginary.DisplayName,
      @scxSkiniMaginaryDisplayName,
      TdxSkinNames.TGroups.Retro3D, @scxSkinGroupRetro3D);

    CreateSkin(TdxSkinNames.TLilian.ID,
      TdxSkinNames.TLilian.DisplayName,
      @scxSkinLilianDisplayName,
      TdxSkinNames.TGroups.Retro3D, @scxSkinGroupRetro3D);

    CreateSkin(TdxSkinNames.TLiquidSky.ID,
      TdxSkinNames.TLiquidSky.DisplayName,
      @scxSkinLiquidSkyDisplayName,
      TdxSkinNames.TGroups.Retro3D, @scxSkinGroupRetro3D);

    CreateSkin(TdxSkinNames.TLondonLiquidSky.ID,
      TdxSkinNames.TLondonLiquidSky.DisplayName,
      @scxSkinLondonLiquidSkyDisplayName,
      TdxSkinNames.TGroups.Retro3D, @scxSkinGroupRetro3D);

    CreateSkin(TdxSkinNames.TMcSkin.ID,
      TdxSkinNames.TMcSkin.DisplayName,
      @scxSkinMcSkinDisplayName,
      TdxSkinNames.TGroups.Thematic, @scxSkinGroupThematic);

    CreateSkin(TdxSkinNames.TMetropolis.ID,
      TdxSkinNames.TMetropolis.DisplayName,
      @scxSkinMetropolisDisplayName,
      TdxSkinNames.TGroups.ThematicFlat, @scxSkinGroupThematicFlat);

    CreateSkin(TdxSkinNames.TMetropolisDark.ID,
      TdxSkinNames.TMetropolisDark.DisplayName,
      @scxSkinMetropolisDarkDisplayName,
      TdxSkinNames.TGroups.ThematicFlat, @scxSkinGroupThematicFlat);

    CreateSkin(TdxSkinNames.TMoneyTwins.ID,
      TdxSkinNames.TMoneyTwins.DisplayName,
      @scxSkinMoneyTwinsDisplayName,
      TdxSkinNames.TGroups.Thematic, @scxSkinGroupThematic);

    CreateSkin(TdxSkinNames.TPumpkin.ID,
      TdxSkinNames.TPumpkin.DisplayName,
      @scxSkinPumpkinDisplayName,
      TdxSkinNames.TGroups.Seasonal, @scxSkinGroupSeasonal);

    CreateSkin(TdxSkinNames.TSeven.ID,
      TdxSkinNames.TSeven.DisplayName,
      @scxSkinSevenDisplayName,
      TdxSkinNames.TGroups.Thematic, @scxSkinGroupThematic);

    CreateSkin(TdxSkinNames.TSevenClassic.ID,
      TdxSkinNames.TSevenClassic.DisplayName,
      @scxSkinSevenClassicDisplayName,
      TdxSkinNames.TGroups.Thematic, @scxSkinGroupThematic)
        .AddPalette(TdxSkinNames.TRasterPalettes.PaletteDefault, @scxSkinRasterPalettesPaletteDefault,
          TdxSkinNames.TRasterPalettes.PaletteGroupGeneral, @scxSkinRasterPalettesPaletteGroupGeneral);

    CreateSkin(TdxSkinNames.TSharp.ID,
      TdxSkinNames.TSharp.DisplayName,
      @scxSkinSharpDisplayName,
      TdxSkinNames.TGroups.RetroFlat, @scxSkinGroupRetroFlat);

    CreateSkin(TdxSkinNames.TSharpPlus.ID,
      TdxSkinNames.TSharpPlus.DisplayName,
      @scxSkinSharpPlusDisplayName,
      TdxSkinNames.TGroups.RetroFlat, @scxSkinGroupRetroFlat);

    CreateSkin(TdxSkinNames.TSilver.ID,
      TdxSkinNames.TSilver.DisplayName,
      @scxSkinSilverDisplayName,
      TdxSkinNames.TGroups.Thematic, @scxSkinGroupThematic);

    CreateSkin(TdxSkinNames.TSpringtime.ID,
      TdxSkinNames.TSpringtime.DisplayName,
      @scxSkinSpringtimeDisplayName,
      TdxSkinNames.TGroups.Seasonal, @scxSkinGroupSeasonal)
        .AddPalette(TdxSkinNames.TRasterPalettes.PaletteDefault, @scxSkinRasterPalettesPaletteDefault,
          TdxSkinNames.TRasterPalettes.PaletteGroupGeneral, @scxSkinRasterPalettesPaletteGroupGeneral);

    CreateSkin(TdxSkinNames.TStardust.ID,
      TdxSkinNames.TStardust.DisplayName,
      @scxSkinStardustDisplayName,
      TdxSkinNames.TGroups.Retro3D, @scxSkinGroupRetro3D);

    CreateSkin(TdxSkinNames.TSummer2008.ID,
      TdxSkinNames.TSummer2008.DisplayName,
      @scxSkinSummer2008DisplayName,
      TdxSkinNames.TGroups.Seasonal, @scxSkinGroupSeasonal)
        .AddPalette(TdxSkinNames.TRasterPalettes.PaletteDefault, @scxSkinRasterPalettesPaletteDefault,
          TdxSkinNames.TRasterPalettes.PaletteGroupGeneral, @scxSkinRasterPalettesPaletteGroupGeneral);

    CreateSkin(TdxSkinNames.TTheAsphaltWorld.ID,
      TdxSkinNames.TTheAsphaltWorld.DisplayName,
      @scxSkinTheAsphaltWorldDisplayName,
      TdxSkinNames.TGroups.Retro3D, @scxSkinGroupRetro3D);

    CreateSkin(TdxSkinNames.TValentine.ID,
      TdxSkinNames.TValentine.DisplayName,
      @scxSkinValentineDisplayName,
      TdxSkinNames.TGroups.Seasonal, @scxSkinGroupSeasonal)
        .AddPalette(TdxSkinNames.TRasterPalettes.PaletteDefault, @scxSkinRasterPalettesPaletteDefault,
          TdxSkinNames.TRasterPalettes.PaletteGroupGeneral, @scxSkinRasterPalettesPaletteGroupGeneral);

    CreateSkin(TdxSkinNames.TWhiteprint.ID,
      TdxSkinNames.TWhiteprint.DisplayName,
      @scxSkinWhiteprintDisplayName,
      TdxSkinNames.TGroups.ThematicFlat, @scxSkinGroupThematicFlat);

    CreateSkin(TdxSkinNames.TXmas2008Blue.ID,
      TdxSkinNames.TXmas2008Blue.DisplayName,
      @scxSkinXmas2008BlueDisplayName,
      TdxSkinNames.TGroups.Seasonal, @scxSkinGroupSeasonal)
        .AddPalette(TdxSkinNames.TRasterPalettes.PaletteDefault, @scxSkinRasterPalettesPaletteDefault,
          TdxSkinNames.TRasterPalettes.PaletteGroupGeneral, @scxSkinRasterPalettesPaletteGroupGeneral);
  end;

  procedure PopulateVS;
  type
    VS = TdxSkinNames.TVisualStudio;

    procedure AddPalette(ASkin: TSkin);
    begin
      ASkin.AddPalette(VS.TPalettes.Default, @scxSkinVSPaletteDefault,
        VS.TPaletteGroups.General, @scxSkinVSPaletteGroupGeneral);
    end;

  begin
    AddPalette(CreateSkin(VS.T2013Blue.ID,
      VS.T2013Blue.DisplayName,
      @scxSkinVS2013BlueDisplayName,
      TdxSkinNames.TGroups.VisualStudio, @scxSkinGroupVisualStudio));

    AddPalette(CreateSkin(VS.T2013Dark.ID,
      VS.T2013Dark.DisplayName,
      @scxSkinVS2013DarkDisplayName,
      TdxSkinNames.TGroups.VisualStudio, @scxSkinGroupVisualStudio));

    AddPalette(CreateSkin(VS.T2013Light.ID,
      VS.T2013Light.DisplayName,
      @scxSkinVS2013LightDisplayName,
      TdxSkinNames.TGroups.VisualStudio, @scxSkinGroupVisualStudio));

    AddPalette(CreateSkin(VS.TVS2010.ID,
      VS.TVS2010.DisplayName,
      @scxSkinVS2010DisplayName,
      TdxSkinNames.TGroups.VisualStudio, @scxSkinGroupVisualStudio));
  end;

begin
  PopulateBezier;
  PopulateOffice2019;
  PopulateWXI;
  PopulateBasic;

  PopulateOffice20072016;
  PopulateNative;
  PopulateRaster;
  PopulateVS;
end;

{$ENDREGION}

{$REGION 'Localize'}

procedure AddSkinResourceStringNames(AProduct: TdxProductResourceStrings);

  procedure InternalAdd(const AResourceStringName: string; AAddress: Pointer);
  begin
    AProduct.Add(AResourceStringName, AAddress);
  end;

begin
  InternalAdd('scxSkinDefaultPaletteGroup', @scxSkinDefaultPaletteGroup);
  InternalAdd('scxSkinDefaultPalette', @scxSkinDefaultPalette);
  InternalAdd('scxSkinDefaultSkinGroup', @scxSkinDefaultSkinGroup);

  InternalAdd('scxSkinGroupVector', @scxSkinGroupVector);
  InternalAdd('scxSkinGroupStandard', @scxSkinGroupStandard);
  InternalAdd('scxSkinGroupLookAndFeelStyles', @scxSkinGroupLookAndFeelStyles);
  InternalAdd('scxSkinGroupOffice', @scxSkinGroupOffice);
  InternalAdd('scxSkinGroupDefault', @scxSkinGroupDefault);
  InternalAdd('scxSkinGroupLatestOfficeSkins', @scxSkinGroupLatestOfficeSkins);
  InternalAdd('scxSkinGroupVisualStudio', @scxSkinGroupVisualStudio);
  InternalAdd('scxSkinGroupPreviousOfficeSkins', @scxSkinGroupPreviousOfficeSkins);
  InternalAdd('scxSkinGroupThematicFlat', @scxSkinGroupThematicFlat);
  InternalAdd('scxSkinGroupSeasonal', @scxSkinGroupSeasonal);
  InternalAdd('scxSkinGroupThematic', @scxSkinGroupThematic);
  InternalAdd('scxSkinGroupRetroFlat', @scxSkinGroupRetroFlat);
  InternalAdd('scxSkinGroupRetro3D', @scxSkinGroupRetro3D);
  InternalAdd('scxSkinGroupCustom', @scxSkinGroupCustom);

  InternalAdd('scxSkinBezierDisplayName', @scxSkinBezierDisplayName);

  InternalAdd('scxSkinBezierPaletteGroupGeneral', @scxSkinBezierPaletteGroupGeneral);
  InternalAdd('scxSkinBezierPaletteGroupInspired', @scxSkinBezierPaletteGroupInspired);
  InternalAdd('scxSkinBezierPaletteGroupLight', @scxSkinBezierPaletteGroupLight);
  InternalAdd('scxSkinBezierPaletteGroupDark', @scxSkinBezierPaletteGroupDark);
  InternalAdd('scxSkinBezierPaletteGroupAccessibility', @scxSkinBezierPaletteGroupAccessibility);
  InternalAdd('scxSkinBezierPaletteGroupOffice', @scxSkinBezierPaletteGroupOffice);

  InternalAdd('scxSkinBezierPaletteDefault', @scxSkinBezierPaletteDefault);
  InternalAdd('scxSkinBezierPaletteArtHouse', @scxSkinBezierPaletteArtHouse);
  InternalAdd('scxSkinBezierPaletteLeafRustle', @scxSkinBezierPaletteLeafRustle);
  InternalAdd('scxSkinBezierPaletteNeonLollipop', @scxSkinBezierPaletteNeonLollipop);
  InternalAdd('scxSkinBezierPaletteTokyo', @scxSkinBezierPaletteTokyo);
  InternalAdd('scxSkinBezierPaletteFireball', @scxSkinBezierPaletteFireball);
  InternalAdd('scxSkinBezierPaletteCrambe', @scxSkinBezierPaletteCrambe);
  InternalAdd('scxSkinBezierPaletteGrasshopper', @scxSkinBezierPaletteGrasshopper);
  InternalAdd('scxSkinBezierPaletteCherryInk', @scxSkinBezierPaletteCherryInk);
  InternalAdd('scxSkinBezierPaletteStarshine', @scxSkinBezierPaletteStarshine);
  InternalAdd('scxSkinBezierPaletteBW', @scxSkinBezierPaletteBW);
  InternalAdd('scxSkinBezierPaletteDarkTurquoise', @scxSkinBezierPaletteDarkTurquoise);
  InternalAdd('scxSkinBezierPalettePrometheus', @scxSkinBezierPalettePrometheus);
  InternalAdd('scxSkinBezierPaletteGhostShark', @scxSkinBezierPaletteGhostShark);
  InternalAdd('scxSkinBezierPaletteBlueVelvet', @scxSkinBezierPaletteBlueVelvet);
  InternalAdd('scxSkinBezierPaletteNorwegianWood', @scxSkinBezierPaletteNorwegianWood);
  InternalAdd('scxSkinBezierPaletteDateFruit', @scxSkinBezierPaletteDateFruit);
  InternalAdd('scxSkinBezierPaletteMilkSnake', @scxSkinBezierPaletteMilkSnake);
  InternalAdd('scxSkinBezierPaletteDragonfly', @scxSkinBezierPaletteDragonfly);
  InternalAdd('scxSkinBezierPaletteMercuryIce', @scxSkinBezierPaletteMercuryIce);
  InternalAdd('scxSkinBezierPalettePlasticSpace', @scxSkinBezierPalettePlasticSpace);
  InternalAdd('scxSkinBezierPaletteGloomGloom', @scxSkinBezierPaletteGloomGloom);
  InternalAdd('scxSkinBezierPaletteVolcano', @scxSkinBezierPaletteVolcano);
  InternalAdd('scxSkinBezierPaletteAquarelle', @scxSkinBezierPaletteAquarelle);
  InternalAdd('scxSkinBezierPaletteOxygen3', @scxSkinBezierPaletteOxygen3);
  InternalAdd('scxSkinBezierPaletteMorayEel', @scxSkinBezierPaletteMorayEel);
  InternalAdd('scxSkinBezierPaletteWitchRave', @scxSkinBezierPaletteWitchRave);
  InternalAdd('scxSkinBezierPaletteBlackberryShake', @scxSkinBezierPaletteBlackberryShake);
  InternalAdd('scxSkinBezierPaletteVacuum', @scxSkinBezierPaletteVacuum);
  InternalAdd('scxSkinBezierPaletteNebula', @scxSkinBezierPaletteNebula);

  InternalAdd('scxSkinOffice2019PaletteGroupGeneral', @scxSkinOffice2019PaletteGroupGeneral);
  InternalAdd('scxSkinOffice2019PaletteDefault', @scxSkinOffice2019PaletteDefault);
  InternalAdd('scxSkinOffice2019PaletteYale', @scxSkinOffice2019PaletteYale);
  InternalAdd('scxSkinOffice2019PaletteForest', @scxSkinOffice2019PaletteForest);
  InternalAdd('scxSkinOffice2019PalettePine', @scxSkinOffice2019PalettePine);
  InternalAdd('scxSkinOffice2019PalettePlum', @scxSkinOffice2019PalettePlum);
  InternalAdd('scxSkinOffice2019PaletteAmber', @scxSkinOffice2019PaletteAmber);
  InternalAdd('scxSkinOffice2019PaletteFireBrick', @scxSkinOffice2019PaletteFireBrick);

  InternalAdd('scxSkinOffice2019ColorfulDisplayName', @scxSkinOffice2019ColorfulDisplayName);
  InternalAdd('scxSkinOffice2019BlackDisplayName', @scxSkinOffice2019BlackDisplayName);
  InternalAdd('scxSkinOffice2019DarkGrayDisplayName', @scxSkinOffice2019DarkGrayDisplayName);
  InternalAdd('scxSkinOffice2019WhiteDisplayName', @scxSkinOffice2019WhiteDisplayName);

  InternalAdd('scxSkinWXIDisplayName', @scxSkinWXIDisplayName);
  InternalAdd('scxSkinWXIPaletteGroupGeneral', @scxSkinWXIPaletteGroupGeneral);
  InternalAdd('scxSkinWXIPaletteGroupOffice', @scxSkinWXIPaletteGroupOffice);

  InternalAdd('scxSkinWXIPaletteDefault', @scxSkinWXIPaletteDefault);
  InternalAdd('scxSkinWXIPaletteDarkness', @scxSkinWXIPaletteDarkness);
  InternalAdd('scxSkinWXIPaletteClearness', @scxSkinWXIPaletteClearness);
  InternalAdd('scxSkinWXIPaletteCalmness', @scxSkinWXIPaletteCalmness);

  InternalAdd('scxSkinWXIPaletteSharpness', @scxSkinWXIPaletteSharpness);
  InternalAdd('scxSkinWXIPaletteOfficeDarkGray', @scxSkinWXIPaletteOfficeDarkGray);
  InternalAdd('scxSkinWXIPaletteOfficeBlack', @scxSkinWXIPaletteOfficeBlack);
  InternalAdd('scxSkinWXIPaletteOfficeColorful', @scxSkinWXIPaletteOfficeColorful);
  InternalAdd('scxSkinWXIPaletteOfficeWhite', @scxSkinWXIPaletteOfficeWhite);

  InternalAdd('scxSkinBasicDisplayName', @scxSkinBasicDisplayName);
  InternalAdd('scxSkinBasicPaletteGroupGeneral', @scxSkinBasicPaletteGroupGeneral);
  InternalAdd('scxSkinBasicPaletteDefault', @scxSkinBasicPaletteDefault);
  InternalAdd('scxSkinBasicPalettePineLight', @scxSkinBasicPalettePineLight);
  InternalAdd('scxSkinBasicPaletteVioletLight', @scxSkinBasicPaletteVioletLight);
  InternalAdd('scxSkinBasicPaletteBlueDark', @scxSkinBasicPaletteBlueDark);
  InternalAdd('scxSkinBasicPalettePineDark', @scxSkinBasicPalettePineDark);
  InternalAdd('scxSkinBasicPaletteVioletDark', @scxSkinBasicPaletteVioletDark);

  InternalAdd('scxSkinOfficeFrom2007To2016Palette', @scxSkinOfficeFrom2007To2016Palette);
  InternalAdd('scxSkinOfficeFrom2007To2016PaletteGroup', @scxSkinOfficeFrom2007To2016PaletteGroup);

  InternalAdd('scxSkinOffice2007BlackDisplayName', @scxSkinOffice2007BlackDisplayName);
  InternalAdd('scxSkinOffice2007BlueDisplayName', @scxSkinOffice2007BlueDisplayName);
  InternalAdd('scxSkinOffice2007GreenDisplayName', @scxSkinOffice2007GreenDisplayName);
  InternalAdd('scxSkinOffice2007PinkDisplayName', @scxSkinOffice2007PinkDisplayName);
  InternalAdd('scxSkinOffice2007SilverDisplayName', @scxSkinOffice2007SilverDisplayName);
  InternalAdd('scxSkinOffice2007DarkGrayDisplayName', @scxSkinOffice2007DarkGrayDisplayName);

  InternalAdd('scxSkinOffice2010BlackDisplayName', @scxSkinOffice2010BlackDisplayName);
  InternalAdd('scxSkinOffice2010BlueDisplayName', @scxSkinOffice2010BlueDisplayName);
  InternalAdd('scxSkinOffice2010SilverDisplayName', @scxSkinOffice2010SilverDisplayName);

  InternalAdd('scxSkinOffice2013DarkGrayDisplayName', @scxSkinOffice2013DarkGrayDisplayName);
  InternalAdd('scxSkinOffice2013LightGrayDisplayName', @scxSkinOffice2013LightGrayDisplayName);
  InternalAdd('scxSkinOffice2013WhiteDisplayName', @scxSkinOffice2013WhiteDisplayName);

  InternalAdd('scxSkinOffice2016ColorfulDisplayName', @scxSkinOffice2016ColorfulDisplayName);
  InternalAdd('scxSkinOffice2016DarkDisplayName', @scxSkinOffice2016DarkDisplayName);

  InternalAdd('scxSkinFlatDisplayName', @scxSkinFlatDisplayName);
  InternalAdd('scxSkinNativeDisplayName', @scxSkinNativeDisplayName);
  InternalAdd('scxSkinOffice11DisplayName', @scxSkinOffice11DisplayName);
  InternalAdd('scxSkinStandardDisplayName', @scxSkinStandardDisplayName);
  InternalAdd('scxSkinUltraFlatDisplayName', @scxSkinUltraFlatDisplayName);

  InternalAdd('scxSkinRasterPalettesPaletteDefault', @scxSkinRasterPalettesPaletteDefault);
  InternalAdd('scxSkinRasterPalettesPaletteGroupGeneral', @scxSkinRasterPalettesPaletteGroupGeneral);
  InternalAdd('scxSkinBlackDisplayName', @scxSkinBlackDisplayName);
  InternalAdd('scxSkinBlueDisplayName', @scxSkinBlueDisplayName);
  InternalAdd('scxSkinBlueprintDisplayName', @scxSkinBlueprintDisplayName);
  InternalAdd('scxSkinCaramelDisplayName', @scxSkinCaramelDisplayName);
  InternalAdd('scxSkinCoffeeDisplayName', @scxSkinCoffeeDisplayName);
  InternalAdd('scxSkinDarkroomDisplayName', @scxSkinDarkroomDisplayName);
  InternalAdd('scxSkinDarkSideDisplayName', @scxSkinDarkSideDisplayName);
  InternalAdd('scxSkinDevExpressDarkStyleDisplayName', @scxSkinDevExpressDarkStyleDisplayName);
  InternalAdd('scxSkinDevExpressStyleDisplayName', @scxSkinDevExpressStyleDisplayName);
  InternalAdd('scxSkinFoggyDisplayName', @scxSkinFoggyDisplayName);
  InternalAdd('scxSkinGlassOceansDisplayName', @scxSkinGlassOceansDisplayName);
  InternalAdd('scxSkinHighContrastDisplayName', @scxSkinHighContrastDisplayName);
  InternalAdd('scxSkiniMaginaryDisplayName', @scxSkiniMaginaryDisplayName);
  InternalAdd('scxSkinLilianDisplayName', @scxSkinLilianDisplayName);
  InternalAdd('scxSkinLiquidSkyDisplayName', @scxSkinLiquidSkyDisplayName);
  InternalAdd('scxSkinLondonLiquidSkyDisplayName', @scxSkinLondonLiquidSkyDisplayName);
  InternalAdd('scxSkinMcSkinDisplayName', @scxSkinMcSkinDisplayName);
  InternalAdd('scxSkinMetropolisDisplayName', @scxSkinMetropolisDisplayName);
  InternalAdd('scxSkinMetropolisDarkDisplayName', @scxSkinMetropolisDarkDisplayName);
  InternalAdd('scxSkinMoneyTwinsDisplayName', @scxSkinMoneyTwinsDisplayName);
  InternalAdd('scxSkinPumpkinDisplayName', @scxSkinPumpkinDisplayName);
  InternalAdd('scxSkinSevenDisplayName', @scxSkinSevenDisplayName);
  InternalAdd('scxSkinSevenClassicDisplayName', @scxSkinSevenClassicDisplayName);
  InternalAdd('scxSkinSharpDisplayName', @scxSkinSharpDisplayName);
  InternalAdd('scxSkinSharpPlusDisplayName', @scxSkinSharpPlusDisplayName);
  InternalAdd('scxSkinSilverDisplayName', @scxSkinSilverDisplayName);
  InternalAdd('scxSkinSpringtimeDisplayName', @scxSkinSpringtimeDisplayName);
  InternalAdd('scxSkinStardustDisplayName', @scxSkinStardustDisplayName);
  InternalAdd('scxSkinSummer2008DisplayName', @scxSkinSummer2008DisplayName);
  InternalAdd('scxSkinTheAsphaltWorldDisplayName', @scxSkinTheAsphaltWorldDisplayName);
  InternalAdd('scxSkinValentineDisplayName', @scxSkinValentineDisplayName);
  InternalAdd('scxSkinWhiteprintDisplayName', @scxSkinWhiteprintDisplayName);
  InternalAdd('scxSkinXmas2008BlueDisplayName', @scxSkinXmas2008BlueDisplayName);

  InternalAdd('scxSkinVS2013BlueDisplayName', @scxSkinVS2013BlueDisplayName);
  InternalAdd('scxSkinVS2013DarkDisplayName', @scxSkinVS2013DarkDisplayName);
  InternalAdd('scxSkinVS2013LightDisplayName', @scxSkinVS2013LightDisplayName);
  InternalAdd('scxSkinVS2010DisplayName', @scxSkinVS2010DisplayName);
  InternalAdd('scxSkinVSPaletteDefault', @scxSkinVSPaletteDefault);
  InternalAdd('scxSkinVSPaletteGroupGeneral', @scxSkinVSPaletteGroupGeneral);
end;

{$ENDREGION}

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxSkinNameList.Initialize;
  dxResourceStringsRepository.RegisterProduct('ExpressSkins', @AddSkinResourceStringNames);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxResourceStringsRepository.UnRegisterProduct('ExpressSkins');
  TdxSkinNameList.Finalize;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
