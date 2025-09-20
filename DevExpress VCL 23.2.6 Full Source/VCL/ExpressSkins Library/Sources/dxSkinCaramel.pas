{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressSkins Library                                     }
{                                                                    }
{           Copyright (c) 2006-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSSKINS AND ALL ACCOMPANYING     }
{   VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY.              }
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

unit dxSkinCaramel;

{$I cxVer.inc}

interface

uses
  Classes, dxCore, dxCoreGraphics, dxGDIPlusApi, cxLookAndFeelPainters, dxSkinsCore, dxSkinsLookAndFeelPainter;

{$HPPEMIT '#ifdef USEPACKAGES'}

{$IF DEFINED(VER210)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS14.bpi"'}
{$ELSEIF DEFINED(VER220)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS15.bpi"'}
{$ELSEIF DEFINED(VER230)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS16.bpi"'}
{$ELSEIF DEFINED(VER240)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS17.bpi"'}
{$ELSEIF DEFINED(VER250)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS18.bpi"'}
{$ELSEIF DEFINED(VER260)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS19.bpi"'}
{$ELSEIF DEFINED(VER270)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS20.bpi"'}
{$ELSEIF DEFINED(VER280)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS21.bpi"'}
{$ELSEIF DEFINED(VER290)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS22.bpi"'}
{$ELSEIF DEFINED(VER300)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS23.bpi"'}
{$ELSEIF DEFINED(VER310)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS24.bpi"'}
{$ELSEIF DEFINED(VER320)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS25.bpi"'}
{$ELSEIF DEFINED(VER330)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS26.bpi"'}
{$ELSEIF DEFINED(VER340)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS27.bpi"'}
{$ELSEIF DEFINED(VER350)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS28.bpi"'}
{$ELSEIF DEFINED(VER360)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS29.bpi"'}
{$ELSE}
  Unsupported
{$IFEND}

{$HPPEMIT '#else'}
{$IFDEF WIN64}

{$IF DEFINED(VER210)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS14.a"'}
{$ELSEIF DEFINED(VER220)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS15.a"'}
{$ELSEIF DEFINED(VER230)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS16.a"'}
{$ELSEIF DEFINED(VER240)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS17.a"'}
{$ELSEIF DEFINED(VER250)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS18.a"'}
{$ELSEIF DEFINED(VER260)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS19.a"'}
{$ELSEIF DEFINED(VER270)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS20.a"'}
{$ELSEIF DEFINED(VER280)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS21.a"'}
{$ELSEIF DEFINED(VER290)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS22.a"'}
{$ELSEIF DEFINED(VER300)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS23.a"'}
{$ELSEIF DEFINED(VER310)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS24.a"'}
{$ELSEIF DEFINED(VER320)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS25.a"'}
{$ELSEIF DEFINED(VER330)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS26.a"'}
{$ELSEIF DEFINED(VER340)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS27.a"'}
{$ELSEIF DEFINED(VER350)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS28.a"'}
{$ELSEIF DEFINED(VER360)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS29.a"'}
{$ELSE}
  Unsupported
{$IFEND}

{$ELSE}

{$IF DEFINED(VER210)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS14.lib"'}
{$ELSEIF DEFINED(VER220)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS15.lib"'}
{$ELSEIF DEFINED(VER230)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS16.lib"'}
{$ELSEIF DEFINED(VER240)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS17.lib"'}
{$ELSEIF DEFINED(VER250)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS18.lib"'}
{$ELSEIF DEFINED(VER260)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS19.lib"'}
{$ELSEIF DEFINED(VER270)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS20.lib"'}
{$ELSEIF DEFINED(VER280)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS21.lib"'}
{$ELSEIF DEFINED(VER290)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS22.lib"'}
{$ELSEIF DEFINED(VER300)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS23.lib"'}
{$ELSEIF DEFINED(VER310)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS24.lib"'}
{$ELSEIF DEFINED(VER320)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS25.lib"'}
{$ELSEIF DEFINED(VER330)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS26.lib"'}
{$ELSEIF DEFINED(VER340)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS27.lib"'}
{$ELSEIF DEFINED(VER350)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS28.lib"'}
{$ELSEIF DEFINED(VER360)}
  {$HPPEMIT '#pragma link "dxSkinCaramelRS29.lib"'}
{$ELSE}
  Unsupported
{$IFEND}

{$ENDIF}
{$HPPEMIT '#endif}

type

  { TdxSkinCaramelPainter }

  TdxSkinCaramelPainter = class(TdxSkinLookAndFeelPainter)
  public
    function LookAndFeelName: string; override;
  end;

implementation

const
  dxThisUnitName = 'dxSkinCaramel';

{$R dxSkinCaramel.res}

const
  SkinsCount = 1;
  SkinNames: array[0..SkinsCount - 1] of string = (
    'Caramel'
  );
  SkinPainters: array[0..SkinsCount - 1] of TdxSkinLookAndFeelPainterClass = (
    TdxSkinCaramelPainter
  );


{ TdxSkinCaramelPainter }

function TdxSkinCaramelPainter.LookAndFeelName: string;
begin
  Result := 'Caramel';
end;

//

procedure RegisterPainters;
var
  I: Integer;
begin
  if CheckGdiPlus then
  begin
    for I := 0 to SkinsCount - 1 do
      cxLookAndFeelPaintersManager.Register(SkinPainters[I].Create(SkinNames[I], HInstance));
  end;
end;

procedure UnregisterPainters;
var
  I: Integer;
begin
  if cxLookAndFeelPaintersManager <> nil then
  begin
    for I := 0 to SkinsCount - 1 do
      cxLookAndFeelPaintersManager.Unregister(SkinNames[I]);
  end;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
{$IFNDEF DXSKINDYNAMICLOADING}
  dxUnitsLoader.AddUnit(SysInit.HInstance, dxThisUnitName, RegisterPainters, UnregisterPainters);
{$ENDIF}
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
{$IFNDEF DXSKINDYNAMICLOADING}
  dxUnitsLoader.RemoveUnit(SysInit.HInstance, dxThisUnitName, UnregisterPainters);
{$ENDIF}
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
