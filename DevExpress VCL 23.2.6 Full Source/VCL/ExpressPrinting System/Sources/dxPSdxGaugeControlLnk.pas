{*******************************************************************}
{                                                                   }
{       Developer Express Visual Component Library                  }
{       ExpressPrinting System COMPONENT SUITE                      }
{                                                                   }
{       Copyright (c) 1998-2024 Developer Express Inc.              }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{   The entire contents of this file is protected by U.S. and       }
{   International Copyright Laws. Unauthorized reproduction,        }
{   reverse-engineering, and distribution of all or any portion of  }
{   the code contained in this file is strictly prohibited and may  }
{   result in severe civil and criminal penalties and will be       }
{   prosecuted to the maximum extent possible under the law.        }
{                                                                   }
{   RESTRICTIONS                                                    }
{                                                                   }
{   THIS SOURCE CODE AND ALL RESULTING INTERMEDIATE FILES           }
{   (DCU, OBJ, DLL, ETC.) ARE CONFIDENTIAL AND PROPRIETARY TRADE    }
{   SECRETS OF DEVELOPER EXPRESS INC. THE REGISTERED DEVELOPER IS   }
{   LICENSED TO DISTRIBUTE THE EXPRESSPRINTINGSYSTEM AND            }
{   ALL ACCOMPANYING VCL CONTROLS AS PART OF AN                     }
{   EXECUTABLE PROGRAM ONLY.                                        }
{                                                                   }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED      }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE        }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE       }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT  }
{   AND PERMISSION FROM DEVELOPER EXPRESS INC.                      }
{                                                                   }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON       }
{   ADDITIONAL RESTRICTIONS.                                        }
{                                                                   }
{*******************************************************************}

unit dxPSdxGaugeControlLnk;

{$I cxVer.inc}

interface

uses
  Classes, Windows, Graphics, dxPSCore, dxPSGraphicLnk, dxGaugeControl;

type
  { TdxGaugeControlCustomReportLink }

  TdxGaugeControlCustomReportLink = class(TCustomdxGraphicReportLink)
  private
    function GetGaugeControl: TdxCustomGaugeControl;
  protected
    function GetGraphic: TGraphic; override;
    function GetGraphicClass: TGraphicClass; override;
    function GetGraphicHeight: Integer; override;
    function GetGraphicWidth: Integer; override;

    property GaugeControl: TdxCustomGaugeControl read GetGaugeControl;
  end;

  { TdxGaugeControlReportLink }

  TdxGaugeControlReportLink = class(TdxGaugeControlCustomReportLink)
  published
    property BorderColor;
    property DrawBorder;
    property Transparent;
    property TransparentColor;
  end;

implementation

uses
  SysUtils, Types, Controls, dxPrnPg, cxGraphics, dxCore;

const
  dxThisUnitName = 'dxPSdxGaugeControlLnk';

type
  TdxCustomGaugeControlAccess = class(TdxCustomGaugeControl);

{ TdxGaugeControlCustomReportLink }

function TdxGaugeControlCustomReportLink.GetGraphic: TGraphic;
begin
  Result := TBitmap.Create;
  TBitmap(Result).SetSize(GaugeControl.Width, GaugeControl.Height);
  TBitmap(Result).PixelFormat := pf32bit;
  cxPaintCanvas.BeginPaint(TBitmap(Result).Canvas);
  try
    if Transparent then
    begin
      cxPaintCanvas.Brush.Color := TransparentColor;
      cxPaintCanvas.FillRect(Rect(0, 0, Result.Width, Result.Height));
    end;
    TdxCustomGaugeControlAccess(GaugeControl).DrawPreview(cxPaintCanvas, not Transparent);
  finally
    cxPaintCanvas.EndPaint;
  end;
end;

function TdxGaugeControlCustomReportLink.GetGraphicClass: TGraphicClass;
begin
  Result := TBitmap;
end;

function TdxGaugeControlCustomReportLink.GetGraphicHeight: Integer;
begin
  if GaugeControl <> nil then
    Result := GaugeControl.Height
  else
    Result := inherited GetGraphicHeight;
end;

function TdxGaugeControlCustomReportLink.GetGraphicWidth: Integer;
begin
  if GaugeControl <> nil then
    Result := GaugeControl.Width
  else
    Result := inherited GetGraphicWidth;
end;

function TdxGaugeControlCustomReportLink.GetGaugeControl: TdxCustomGaugeControl;
begin
  Result := inherited Component as TdxCustomGaugeControl;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPSRegisterReportLink(TdxGaugeControlReportLink, TdxGaugeControl, nil);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPSUnregisterReportLink(TdxGaugeControlReportLink, TdxGaugeControl, nil);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.

