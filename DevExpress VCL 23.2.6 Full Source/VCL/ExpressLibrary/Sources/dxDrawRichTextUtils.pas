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

unit dxDrawRichTextUtils;

{$I cxVer.inc}

interface

uses
  Windows, Controls, Messages, Types, Classes, Math, SysUtils, Graphics, RichEdit, ComCtrls, cxGeometry;

const
  {$EXTERNALSYM EM_GETZOOM}
  EM_GETZOOM = WM_USER + 224;
  {$EXTERNALSYM EM_SETZOOM}
  EM_SETZOOM = WM_USER + 225;

type

  { TdxRichTextHelper }

  TdxRichTextHelper = class
  strict private
    FRichEdit: TRichEdit;
    FScaleFactor: TdxScaleFactor;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure CalculateTextHeight(ACanvas: TCanvas; var ARect: TRect); virtual;
    procedure DrawText(ACanvas: TCanvas; const ARect: TRect); virtual;
    procedure Init(ACanvas: TCanvas; const AText: string; AScaleFactor: TdxScaleFactor); virtual;
  end;

function GetZoomRichEdit(ARichHandle: HWND; out ANumerator, ADenominator: Cardinal): Boolean;
procedure dxDrawRichEdit(ADC: HDC; ARect: TRect; ARichHandle: HWND; AScaleFactor: TdxScaleFactor;
  AMinCharIndex, AMaxCharIndex: Integer; ACalculateHeight: Boolean; out AHeight: Integer); overload;
function dxDrawRichEdit(ADC: HDC; ARect: TRect; ARichHandle: HWND; AScaleFactor: TdxScaleFactor;
  AMinCharIndex, AMaxCharIndex: Integer; ACalculateHeight: Boolean; AOneLine: Boolean = False): Integer; overload;

function dxIsRichText(const AText: string): Boolean;
function dxPixelsToTwips(AValue: Integer): Integer; overload;
function dxPixelsToTwips(AValue: Integer; AScaleFactor: TdxScaleFactor): Integer; overload;
function dxTwipsToPixels(AValue: Integer): Integer; overload;
function dxTwipsToPixels(AValue: Integer; AScaleFactor: TdxScaleFactor): Integer; overload;

procedure dxRichLoadFromString(ALines: TStrings; const S: string);

implementation

uses
  dxCore, cxClasses, cxGraphics, cxControls, dxDPIAwareUtils, StrUtils;

const
  dxThisUnitName = 'dxDrawRichTextUtils';

const
  TwipsPerInch = 1440;

procedure dxInternalDrawRichEdit(ADC: HDC; ARect: TRect; ARichHandle: HWND; AZoomFactor, AScaleFactor: TdxScaleFactor;
  AMinCharIndex, AMaxCharIndex: Integer; ACalculateHeight: Boolean; out AHeight: Integer);
type
  TState = record
    Assigned: Boolean;
    MapMode: Integer;
    ViewPortExt: TSize;
    ViewPortOrg: TPoint;
    WindowExt: TSize;
  end;

  procedure PrepareCanvas(out AState: TState);
  const
    CanvasSize = TwipsPerInch;
  begin
    AState.Assigned := AZoomFactor.Assigned;
    if AState.Assigned then
    begin
      AState.MapMode := SetMapMode(ADC, MM_ANISOTROPIC);
      SetWindowExtEx(ADC, CanvasSize, CanvasSize, @AState.WindowExt);
      SetViewportExtEx(ADC, AZoomFactor.Apply(CanvasSize), AZoomFactor.Apply(CanvasSize), @AState.ViewPortExt);
      SetViewportOrgEx(ADC, ARect.Left, ARect.Top, @AState.ViewPortOrg);
      ARect := cxRectSetNullOrigin(ARect);
    end;
  end;

  procedure RestoreCanvas(const AState: TState);
  begin
    if AState.Assigned then
    begin
      SetViewportOrgEx(ADC, AState.ViewPortOrg.X, AState.ViewPortOrg.Y, nil);
      SetViewportExtEx(ADC, AState.ViewPortExt.cx, AState.ViewPortExt.cy, nil);
      SetWindowExtEx(ADC, AState.WindowExt.cx, AState.WindowExt.cy, nil);
      SetMapMode(ADC, AState.MapMode);
    end;
  end;

  function PrepareRect(const R: TRect): TRect;
  begin
    Result.Top := dxPixelsToTwips(R.Top, AScaleFactor);
    Result.Left := dxPixelsToTwips(R.Left, AScaleFactor);
    Result.Right := Result.Left + dxPixelsToTwips(R.Right - R.Left, AScaleFactor);
    if ACalculateHeight then
      Result.Bottom := Result.Top + TwipsPerInch
    else
      Result.Bottom := Result.Top + dxPixelsToTwips(R.Bottom - R.Top, AScaleFactor);
  end;

var
  AFormatRange: TFormatRange;
  AStartIndex: Integer;
  AState: TState;
begin
  if not ACalculateHeight then
    PrepareCanvas(AState);
  try
    SendMessage(ARichHandle, EM_FORMATRANGE, 0, 0);
    try
      AHeight := 0;
      ZeroMemory(@AFormatRange, SizeOf(AFormatRange));
      AFormatRange.hdc := ADC;
      AFormatRange.hdcTarget := ADC;
      AFormatRange.chrg.cpMin := AMinCharIndex;
      AFormatRange.chrg.cpMax := AMaxCharIndex;
      repeat
        AFormatRange.rc := PrepareRect(AZoomFactor.Apply(ARect));
        AFormatRange.rcPage := cxRectSetNullOrigin(AFormatRange.rc);
        AStartIndex := AFormatRange.chrg.cpMin;
        AFormatRange.chrg.cpMin := cxSendStructMessage(ARichHandle, EM_FORMATRANGE, WPARAM(not ACalculateHeight), AFormatRange);
        if AFormatRange.chrg.cpMin <= AStartIndex then
          Break;
        if ACalculateHeight then
          Inc(AHeight, cxRectHeight(AFormatRange.rc));
      until not ACalculateHeight;

      if ACalculateHeight then
      begin
        AHeight := dxTwipsToPixels(AHeight, AScaleFactor);
        AHeight := AZoomFactor.Apply(AHeight);
      end;
    finally
      SendMessage(ARichHandle, EM_FORMATRANGE, 0, 0);
    end;
  finally
    if not ACalculateHeight then
      RestoreCanvas(AState);
  end;
end;

function GetZoomRichEdit(ARichHandle: HWND; out ANumerator, ADenominator: Cardinal): Boolean;
var
  AWParam: TdxNativeInt;
  ALParam: TdxNativeInt;
  N: Cardinal absolute AWParam;
  D: Cardinal absolute ALParam;
begin
  ANumerator := 0;
  ADenominator := 0;
  Result := Boolean(SendMessage(ARichHandle, EM_GETZOOM, WPARAM(@AWParam), LPARAM(@ALParam)));
  if Result then
  begin
    ANumerator := N;
    ADenominator := D;
  end;
end;

procedure dxDrawRichEdit(ADC: HDC; ARect: TRect; ARichHandle: HWND; AScaleFactor: TdxScaleFactor;
  AMinCharIndex, AMaxCharIndex: Integer; ACalculateHeight: Boolean; out AHeight: Integer);
var
  ANumerator: Cardinal;
  ADenominator: Cardinal;
  AZoomFactor: TdxScaleFactor;
begin
  AZoomFactor := TdxScaleFactor.Create;
  try
    if GetZoomRichEdit(ARichHandle, ANumerator, ADenominator) and (ADenominator > 0) and (ANumerator <> ADenominator) then
      AZoomFactor.Assign(ANumerator, ADenominator)
    else
      AZoomFactor.Assign(AScaleFactor.TargetDPI, dxSystemScaleFactor.TargetDPI);
    dxInternalDrawRichEdit(ADC, ARect, ARichHandle, AZoomFactor, nil, AMinCharIndex, AMaxCharIndex, ACalculateHeight, AHeight);
  finally
    AZoomFactor.Free;
  end;
end;

function dxDrawRichEdit(ADC: HDC; ARect: TRect; ARichHandle: HWND; AScaleFactor: TdxScaleFactor;
  AMinCharIndex, AMaxCharIndex: Integer; ACalculateHeight: Boolean; AOneLine: Boolean = False): Integer;
const
  ARoundingRemainder = 100;
var
  ANumerator: Cardinal;
  ADenominator: Cardinal;
  AZoomFactor: TdxScaleFactor;
begin
  AZoomFactor := TdxScaleFactor.Create;
  try
    if GetZoomRichEdit(ARichHandle, ANumerator, ADenominator) and (ADenominator > 0) and (ANumerator <> ADenominator) then
      AZoomFactor.Assign(ANumerator, ADenominator);

    if AOneLine then
    begin
      ARect.Right := dxTwipsToPixels(MaxInt, AScaleFactor) - ARoundingRemainder;
      ARect.Right := AZoomFactor.Revert(ARect.Right);
      ARect.Right := AScaleFactor.Revert(ARect.Right);
    end;

    dxInternalDrawRichEdit(ADC, ARect, ARichHandle, AZoomFactor, AScaleFactor, AMinCharIndex, AMaxCharIndex, ACalculateHeight, Result);
  finally
    AZoomFactor.Free;
  end;
end;

function dxIsRichText(const AText: string): Boolean;
const
  RichPrefix = '{\rtf';
begin
  Result := StartsStr(RichPrefix, AText);
end;

function dxPixelsToTwips(AValue: Integer): Integer;
begin
  Result := MulDiv(AValue, TwipsPerInch, dxSystemScaleFactor.TargetDPI);
end;

function dxPixelsToTwips(AValue: Integer; AScaleFactor: TdxScaleFactor): Integer;
begin
  if AScaleFactor = nil then
    Result := dxPixelsToTwips(AValue)
  else
    Result := MulDiv(AValue, TwipsPerInch, AScaleFactor.TargetDPI);
end;

function dxTwipsToPixels(AValue: Integer): Integer;
begin
  Result := MulDiv(AValue, dxSystemScaleFactor.TargetDPI, TwipsPerInch);
end;

function dxTwipsToPixels(AValue: Integer; AScaleFactor: TdxScaleFactor): Integer;
begin
  if AScaleFactor = nil then
    Result := dxTwipsToPixels(AValue)
  else
    Result := MulDiv(AValue, AScaleFactor.TargetDPI, TwipsPerInch);
end;

procedure dxRichLoadFromString(ALines: TStrings; const S: string);
var
  AStream: TStringStream;
  AEncoding: TEncoding;
begin
  if dxIsRichText(S) then
    AEncoding := TEncoding.Default
  else
    AEncoding := TEncoding.Unicode;

  AStream := TStringStream.Create(S, AEncoding);
  try
    ALines.LoadFromStream(AStream, AEncoding);
  finally
    AStream.Free;
  end;
end;

{ TdxRichTextHelper }

constructor TdxRichTextHelper.Create;
begin
  inherited Create;
  FRichEdit := TRichEdit.Create(nil);
  FRichEdit.ParentWindow := cxMessageWindow.Handle;
  FScaleFactor := TdxScaleFactor.Create;
  SendMessage(FRichEdit.Handle, EM_SETEVENTMASK, 0, 0);
end;

destructor TdxRichTextHelper.Destroy;
begin
  FreeAndNil(FScaleFactor);
  FreeAndNil(FRichEdit);
  inherited Destroy;
end;

procedure TdxRichTextHelper.CalculateTextHeight(ACanvas: TCanvas; var ARect: TRect);
var
  AHeight: Integer;
begin
  ACanvas.Lock;
  try
    dxDrawRichEdit(ACanvas.Handle, ARect, FRichEdit.Handle, FScaleFactor, 0, -1, True, AHeight);
    ARect.Bottom := ARect.Top + AHeight;
  finally
    ACanvas.Unlock;
  end;
end;

procedure TdxRichTextHelper.DrawText(ACanvas: TCanvas; const ARect: TRect);
var
  AHeight: Integer;
begin
  ACanvas.Lock;
  try
    dxDrawRichEdit(ACanvas.Handle, ARect, FRichEdit.Handle, FScaleFactor, 0, -1, False, AHeight);
  finally
    ACanvas.Unlock;
  end;
end;

procedure TdxRichTextHelper.Init(ACanvas: TCanvas; const AText: string; AScaleFactor: TdxScaleFactor);
var
  AFont: TFont;
begin
  AFont := TFont.Create;
  try
    AFont.PixelsPerInch := dxDefaultDPI;
    AFont.Assign(ACanvas.Font);

    FRichEdit.HandleNeeded;
    FScaleFactor.Assign(AScaleFactor);
    SetWindowLong(FRichEdit.Handle, GWL_EXSTYLE, GetWindowLong(FRichEdit.Handle, GWL_EXSTYLE) or WS_EX_TRANSPARENT);
    FRichEdit.DefAttributes.Assign(AFont);
    FRichEdit.DefAttributes.Color := AFont.Color;
    dxRichLoadFromString(FRichEdit.Lines, AText);
  finally
    AFont.Free;
  end;
end;

end.
