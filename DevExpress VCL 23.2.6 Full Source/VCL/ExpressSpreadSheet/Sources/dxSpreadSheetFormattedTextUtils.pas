{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressSpreadSheet                                       }
{                                                                    }
{           Copyright (c) 2001-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSSPREADSHEET CONTROL AND ALL    }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY. }
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

unit dxSpreadSheetFormattedTextUtils;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Windows, Messages, Math, Classes, Types, SysUtils, Graphics, Generics.Defaults, Generics.Collections,
  StrUtils, Variants,
  // CX
  cxClasses, dxCore, cxGraphics, dxCoreClasses, cxFormats, cxControls, cxGeometry, cxLookAndFeelPainters,
  dxGDIPlusClasses, cxDrawTextUtils, dxStringHelper,
  // FormatedTextUtils
  dxFormattedText, dxFormattedTextConverterRTF,
  // SpreadSheet
  dxSpreadSheetCore, dxSpreadSheetCoreStyles, dxSpreadSheetCoreHelpers, dxSpreadSheetTypes, dxSpreadSheetClasses,
  dxSpreadSheetUtils, dxSpreadSheetStrs, dxSpreadSheetGraphics, dxSpreadSheetNumberFormat, dxSpreadSheetPrinting,
  dxSpreadSheetHyperlinks, dxSpreadSheetProtection, dxSpreadSheetStyles;

type

  { TdxSpreadSheetFormattedText }

  TdxSpreadSheetFormattedText = class
  public
    class procedure AdjustFontSize(AText: TdxFormattedText; ACorrection: Integer);
    class function CreateFontHandle(AFontTable: TdxSpreadSheetFonts;
      const AStyle: TdxFormattedTextCharacterProperties): TdxSpreadSheetFontHandle;
    class function FromFormattedText(AText: TdxFormattedText;
      ADefaultFont: TdxSpreadSheetFontHandle; AFontTable: TdxSpreadSheetFonts): TdxSpreadSheetFormattedSharedString; overload;
    class function FromFormattedText(AText: TdxFormattedText;
      ADefaultFont: TFont; AFontTable: TdxSpreadSheetFonts): TdxSpreadSheetFormattedSharedString; overload;
    class function FromRtf(const ARtfString: string;
      ADefaultFont: TFont; AFontTable: TdxSpreadSheetFonts): TdxSpreadSheetFormattedSharedString;
    class procedure ToFormattedText(AText: TdxFormattedText;
      AString: TdxSpreadSheetFormattedSharedString; ADefaultFont: TdxSpreadSheetFontHandle);
  end;

  { TdxSpreadSheetFormattedTextShrinkToFitCalculator }

  TdxSpreadSheetFormattedTextShrinkToFitCalculator = class(TdxSpreadSheetShrinkToFitCalculator)
  strict private
    FFormattedText: TdxFormattedText;
    FPrevFontSize: Integer;

    function GetTextSize(AWidth: Integer): TSize;
  protected
    function GetTextHeight(const AText: string; AWidth: Integer; ALineSpacing: Single): Integer; override;
    function GetTextWidth(const AText: string): Integer; override;
  public
    constructor Create(ACell: TdxSpreadSheetCell; AStyle: TdxSpreadSheetCellDisplayStyle); override;
    destructor Destroy; override;
  end;

  { TdxSpreadSheetFormattedTextService }

  TdxSpreadSheetFormattedTextService = class(TdxSpreadSheetTextService)
  strict private
    class function CalculateTextSize(ACanvas: TcxCanvas; ACell: TdxSpreadSheetCell; ADisplayWidth: Integer): TSize;
    class function CreateFormattedText: TdxFormattedText;
    class function GetCache(ACell: TdxSpreadSheetCell): TdxSpreadSheetFormattedSharedStringCache;
    class function GetDisplayFontHandle(ACell: TdxSpreadSheetCell): TdxSpreadSheetFontHandle;
    class function GetFontTable(ACell: TdxSpreadSheetCell): TdxSpreadSheetFonts;
    class function GetFormattedText(ACell: TdxSpreadSheetCell): TdxFormattedText; overload;
    class function GetFormattedText(ACell: TdxSpreadSheetCell;
      ACanvas: TcxCanvas; const ASize: TSize; AFlags: Cardinal): TdxFormattedText; overload;
    class function HasFormatting(AString: TdxSpreadSheetFormattedSharedString): Boolean;
  protected
    class procedure CalculateTextBounds(ACanvas: TcxCanvas; ACell: TdxSpreadSheetTableViewCustomDataCellViewInfo; var ATextBounds: TRect); override;
    class procedure DrawValue(ACanvas: TcxCanvas; ACell: TdxSpreadSheetTableViewCustomDataCellViewInfo; ABounds: TRect); override;
  public
    class procedure CalculateSize(ACell: TdxSpreadSheetCell; ACanvas: TcxCanvas; const ABounds: TRect;
      AIsMerged: Boolean; AWidth, AHeight: PInteger; AStyle: TdxSpreadSheetCellStyleHandle = nil); override;
    class function CreateShrinkToFitCalculator(ACell: TdxSpreadSheetCell;
      AStyle: TdxSpreadSheetCellDisplayStyle): TdxSpreadSheetShrinkToFitCalculator; override;
    class function IsFormattedEditValue(const AEditValue: string): Boolean; override; 
    class function IsFormattedTextValue(ACell: TdxSpreadSheetCell): Boolean; override; 
    class function IsRTFSupported: Boolean; override;
    class function ForceSetAsRTF(ACell: TdxSpreadSheetCell; const AEditValue: string): Boolean; override; 
    class function GetAsRTF(ACell: TdxSpreadSheetCell; var AValue: string; ARichEditCompatibility: Boolean): Boolean; override; 
    class function SetAsRTF(ACell: TdxSpreadSheetCell; const AEditValue: string): Boolean; override; 
    class function SetAsRTFValue(ACell: TdxSpreadSheetCell; const AEditValue: string; AForce: Boolean): Boolean; // for internal use
  end;

implementation

uses
  dxDPIAwareUtils, dxCoreGraphics, dxDrawRichTextUtils;

const
  dxThisUnitName = 'dxSpreadSheetFormattedTextUtils';

type
  TdxCustomSpreadSheetAccess = class(TdxCustomSpreadSheet);
  TdxFormattedTextAccess = class(TdxFormattedText);
  TdxFormattedTextRunAccess = class(TdxFormattedTextRun);
  TdxFormattedTextSizeRunAccess = class(TdxFormattedTextSizeRun);
  TdxSpreadSheetCellAccess = class(TdxSpreadSheetCell);

{ TdxSpreadSheetFormattedText }

class procedure TdxSpreadSheetFormattedText.AdjustFontSize(AText: TdxFormattedText; ACorrection: Integer);
var
  ASizeRun: TdxFormattedTextSizeRunAccess;
  I: Integer;
begin
  if ACorrection <> 0 then
  begin
    for I := 0 to AText.Runs.Count - 1 do
    begin
      if Safe.Cast(AText.Runs[I], TdxFormattedTextSizeRun, ASizeRun) then
        Inc(ASizeRun.FSize, ACorrection);
    end;
    TdxFormattedTextAccess(AText).Changed;
  end;
end;

class function TdxSpreadSheetFormattedText.CreateFontHandle(
  AFontTable: TdxSpreadSheetFonts; const AStyle: TdxFormattedTextCharacterProperties): TdxSpreadSheetFontHandle;
begin
  Result := AFontTable.CreateFont;
  Result.Color := AStyle.FontColor;
  Result.Name := AStyle.FontName;
  Result.Size := AStyle.FontSize;
  Result.Style := AStyle.FontStyle;
  Result.Script := TdxSpreadSheetFontScript(AStyle.CharacterFormattingScript);
  Result := AFontTable.AddFont(Result);
end;

class procedure TdxSpreadSheetFormattedText.ToFormattedText(AText: TdxFormattedText;
  AString: TdxSpreadSheetFormattedSharedString; ADefaultFont: TdxSpreadSheetFontHandle);

  procedure AppendRun(ARun: TdxFormattedTextRun; APosition: Integer);
  var
    ARunPrev: TdxFormattedTextRunAccess;
  begin
    TdxFormattedTextRunAccess(ARun).FTextStart := PChar(AText.Text) + APosition - 1;
    if AText.Runs.Count > 0 then
    begin
      ARunPrev := TdxFormattedTextRunAccess(AText.Runs.Last);
      ARunPrev.FTextLength := dxGetStringLength(ARunPrev.FTextStart, TdxFormattedTextRunAccess(ARun).FTextStart);
    end;
    AText.Runs.Add(ARun);
  end;

  procedure AppendFont(AFont, ANextFont: TdxSpreadSheetFontHandle; APosition: Integer);
  const
    FontScriptToRunClass: array[TdxSpreadSheetFontScript] of TdxFormattedTextRunClass = (
      nil,
      TdxFormattedTextSupRun,
      TdxFormattedTextSubRun
    );
    FontStyleToRunClass: array[TFontStyle] of TdxFormattedTextRunClass = (
      TdxFormattedTextBoldRun,
      TdxFormattedTextItalicRun,
      TdxFormattedTextUnderlineRun,
      TdxFormattedTextStrikeoutRun
    );
  var
    AFontStyle: TFontStyle;
  begin
    if AFont.Name <> ANextFont.Name then
    begin
      if AFont.Name <> ADefaultFont.Name then
        AppendRun(TdxFormattedTextFontRun.Create(traClose, ''), APosition);
      if ANextFont.Name <> ADefaultFont.Name then
        AppendRun(TdxFormattedTextFontRun.Create(traOpen, ANextFont.Name), APosition);
    end;

    if AFont.Size <> ANextFont.Size then
    begin
      if AFont.Size <> ADefaultFont.Size then
        AppendRun(TdxFormattedTextSizeRun.Create(traClose, 0), APosition);
      if ANextFont.Size <> ADefaultFont.Size then
        AppendRun(TdxFormattedTextSizeRun.Create(traOpen, ANextFont.Size), APosition);
    end;

    if AFont.Script <> ANextFont.Script then
    begin
      if (AFont.Script <> ADefaultFont.Script) and (AFont.Script <> fsNone) then
        AppendRun(FontScriptToRunClass[AFont.Script].Create(traClose), APosition);
      if (ANextFont.Script <> ADefaultFont.Script) and (ANextFont.Script <> fsNone) then
        AppendRun(FontScriptToRunClass[ANextFont.Script].Create(traOpen), APosition);
    end;

    if AFont.Color <> ANextFont.Color then
    begin
      if AFont.Color <> ADefaultFont.Color then
        AppendRun(TdxFormattedTextColorRun.Create(traClose, 0), APosition);
      if ANextFont.Color <> ADefaultFont.Color then
        AppendRun(TdxFormattedTextColorRun.Create(traOpen, ANextFont.Color), APosition);
    end;

    if AFont.Style <> ANextFont.Style then
      for AFontStyle := Low(AFontStyle) to High(AFontStyle) do
      begin
        if (AFontStyle in AFont.Style) <> (AFontStyle in ANextFont.Style) then
        begin
          if AFontStyle in AFont.Style then
            AppendRun(FontStyleToRunClass[AFontStyle].Create(traClose), APosition);
          if AFontStyle in ANextFont.Style then
            AppendRun(FontStyleToRunClass[AFontStyle].Create(traOpen), APosition);
        end;
      end;
  end;

var
  AFontHandle: TdxSpreadSheetFontHandle;
  APrevFont: TdxSpreadSheetFontHandle;
  ARun: TdxSpreadSheetFormattedSharedStringRun;
  I: Integer;
begin
  AText.Runs.Clear;
  AText.Text := AString.Value;
  if AString.Runs.Count > 0 then
  begin
    APrevFont := ADefaultFont;
    AppendRun(TdxFormattedTextNoCodeRun.Create(traOpen), 1);
    for I := 0 to AString.Runs.Count - 1 do
    begin
      ARun := AString.Runs.Items[I];
      AFontHandle := ARun.FontHandle;
      if AFontHandle = nil then
        AFontHandle := ADefaultFont;
      AppendFont(APrevFont, AFontHandle, ARun.StartIndex);
      APrevFont := AFontHandle;
    end;
    AppendFont(APrevFont, ADefaultFont, Length(AText.Text) + 1);
    AppendRun(TdxFormattedTextNoCodeRun.Create(traClose), Length(AText.Text) + 1);
    TdxFormattedTextAccess(AText).CreateInternalRuns(ADefaultFont.GraphicObject);
  end;
end;

class function TdxSpreadSheetFormattedText.FromFormattedText(AText: TdxFormattedText;
  ADefaultFont: TdxSpreadSheetFontHandle; AFontTable: TdxSpreadSheetFonts): TdxSpreadSheetFormattedSharedString;
begin
  Result := FromFormattedText(AText, ADefaultFont.GraphicObject, AFontTable);
end;

class function TdxSpreadSheetFormattedText.FromFormattedText(AText: TdxFormattedText;
  ADefaultFont: TFont; AFontTable: TdxSpreadSheetFonts): TdxSpreadSheetFormattedSharedString;

  procedure AddRun(APosition: Integer; AString: TdxSpreadSheetFormattedSharedString; const AStyle: TdxFormattedTextCharacterProperties);
  var
    ARun: TdxSpreadSheetFormattedSharedStringRun;
  begin
    if AString.Runs.Count > 0 then
    begin
      ARun := TdxSpreadSheetFormattedSharedStringRun(AString.Runs.Last);
      if ARun.StartIndex = APosition then
      begin
        ARun.FontHandle := CreateFontHandle(AFontTable, AStyle);
        Exit;
      end;
    end;
    if APosition <= Length(AString.Value) then
      AString.Runs.Add(APosition, CreateFontHandle(AFontTable, AStyle));
  end;

var
  APosition: Integer;
  ARun: TdxFormattedTextRun;
  AStack: TdxFormattedTextRunStack;
  AStyle: TdxFormattedTextCharacterProperties;
  I: Integer;
begin
  Result := TdxSpreadSheetFormattedSharedString.CreateObject(AText.GetDisplayText);

  AStack := TdxFormattedTextRunStack.Create;
  try
    APosition := 1;
    for I := 0 to AText.Runs.Count - 1 do
    begin
      ARun := AText.Runs[I];
      AStyle.Initialize(ADefaultFont);
      AStack.ProcessRun(ARun);
      AStack.CalculateStyle(AStyle);
      AddRun(APosition, Result, AStyle);
      Inc(APosition, ARun.TextLength);
    end;
  finally
    AStack.Free;
  end;
end;

class function TdxSpreadSheetFormattedText.FromRtf(const ARtfString: string;
  ADefaultFont: TFont; AFontTable: TdxSpreadSheetFonts): TdxSpreadSheetFormattedSharedString;
var
  AFormattedText: TdxFormattedText;
begin
  AFormattedText := TdxFormattedText.Create;
  try
    TdxFormattedTextConverterRTF.Import(AFormattedText, ARtfString, ADefaultFont, True);
    Result := FromFormattedText(AFormattedText, ADefaultFont, AFontTable);
  finally
    AFormattedText.Free;
  end;
end;

{ TdxSpreadSheetFormattedTextShrinkToFitCalculator }

constructor TdxSpreadSheetFormattedTextShrinkToFitCalculator.Create(
  ACell: TdxSpreadSheetCell; AStyle: TdxSpreadSheetCellDisplayStyle);
begin
  inherited Create(ACell, AStyle);
  FPrevFontSize := ACell.StyleHandle.Font.Size;
  FFormattedText := TdxFormattedText.Create;
  TdxSpreadSheetFormattedText.ToFormattedText(FFormattedText,
    ACell.AsSharedString as TdxSpreadSheetFormattedSharedString,
    ACell.StyleHandle.Font);
end;

destructor TdxSpreadSheetFormattedTextShrinkToFitCalculator.Destroy;
begin
  FreeAndNil(FFormattedText);
  inherited;
end;

function TdxSpreadSheetFormattedTextShrinkToFitCalculator.GetTextHeight(
  const AText: string; AWidth: Integer; ALineSpacing: Single): Integer;
begin
  Result := GetTextSize(MaxInt).cy;
end;

function TdxSpreadSheetFormattedTextShrinkToFitCalculator.GetTextWidth(const AText: string): Integer;
begin
  Result := GetTextSize(MaxInt).cx;
end;

function TdxSpreadSheetFormattedTextShrinkToFitCalculator.GetTextSize(AWidth: Integer): TSize;
begin
  TdxSpreadSheetFormattedText.AdjustFontSize(FFormattedText, Font.Size - FPrevFontSize);
  FPrevFontSize := Font.Size;

  FFormattedText.CalculateLayout(cxMeasureCanvas.Canvas, Font, cxRect(0, 0, AWidth, MaxInt), 0, dxDefaultScaleFactor);
  Result := FFormattedText.TextSize;
end;

{ TdxSpreadSheetFormattedTextService }

class procedure TdxSpreadSheetFormattedTextService.CalculateSize(ACell: TdxSpreadSheetCell; ACanvas: TcxCanvas;
  const ABounds: TRect; AIsMerged: Boolean; AWidth, AHeight: PInteger; AStyle: TdxSpreadSheetCellStyleHandle = nil);
var
  ASize: TSize;
  AValueWidth: Integer;
begin
  if IsFormattedTextValue(ACell) then
  begin
    if (AHeight <> nil) and (AWidth = nil) then
      AValueWidth := cxRectWidth(ABounds)
    else
      AValueWidth := MaxInt;

    ASize := CalculateTextSize(ACanvas, ACell, AValueWidth);
    if AWidth <> nil then
      AWidth^ := ASize.cx;
    if AHeight <> nil then
      AHeight^ := ASize.cy;
  end
  else
  begin
    inherited;
    if AWidth <> nil then
      AWidth^ := AWidth^ + Round(AWidth^ * dxSpreadSheetBestFitWidthCorrectionPercentage / 100);
  end;
end;

class function TdxSpreadSheetFormattedTextService.CreateShrinkToFitCalculator(
  ACell: TdxSpreadSheetCell; AStyle: TdxSpreadSheetCellDisplayStyle): TdxSpreadSheetShrinkToFitCalculator;
begin
  if IsFormattedTextValue(ACell) then
    Result := TdxSpreadSheetFormattedTextShrinkToFitCalculator.Create(ACell, AStyle)
  else
    Result := inherited;
end;

class procedure TdxSpreadSheetFormattedTextService.CalculateTextBounds(
  ACanvas: TcxCanvas; ACell: TdxSpreadSheetTableViewCustomDataCellViewInfo; var ATextBounds: TRect);
var
  ASize: TSize;
begin
  if IsFormattedTextValue(ACell.Cell) then
  begin
    ASize := CalculateTextSize(ACanvas, ACell.Cell, cxRectWidth(ATextBounds));
    if ACell.AlignVert <> taTop then
    begin
      if ACell.AlignVert = taBottom then
        OffsetRect(ATextBounds, 0, (cxRectHeight(ATextBounds) - ASize.cy));
      if ACell.AlignVert = taCenterY then
        OffsetRect(ATextBounds, 0, (cxRectHeight(ATextBounds) - ASize.cy) div 2);
    end;
    ATextBounds := cxRectSetSize(ATextBounds, ASize);
  end
  else
    inherited;
end;

class procedure TdxSpreadSheetFormattedTextService.DrawValue(
  ACanvas: TcxCanvas; ACell: TdxSpreadSheetTableViewCustomDataCellViewInfo; ABounds: TRect);
begin
  if IsFormattedTextValue(ACell.Cell) then
    GetFormattedText(ACell.Cell, ACanvas, cxSize(ABounds), ACell.GetTextOutFormat).Draw(ACanvas.Canvas, ABounds.TopLeft)
  else
    inherited;
end;

class function TdxSpreadSheetFormattedTextService.ForceSetAsRTF(ACell: TdxSpreadSheetCell; const AEditValue: string): Boolean;
begin
  Result := SetAsRTFValue(ACell, AEditValue, True);
end;

class function TdxSpreadSheetFormattedTextService.GetAsRTF(
  ACell: TdxSpreadSheetCell; var AValue: string; ARichEditCompatibility: Boolean): Boolean;
begin
  Result := IsFormattedTextValue(ACell);
  if Result then
    AValue := TdxFormattedTextConverterRTF.Export(GetFormattedText(ACell),
      ACell.StyleHandle.Font.GraphicObject, ARichEditCompatibility);
end;

class function TdxSpreadSheetFormattedTextService.IsFormattedEditValue(const AEditValue: string): Boolean;
var
  AText: TdxFormattedText;
begin
  Result := dxIsRichText(AEditValue);
  if Result then
  begin
    AText := CreateFormattedText;
    try
      TdxFormattedTextConverterRTF.Import(AText, AEditValue, nil, True);
      Result := AText.HasFormatting;
    finally
      AText.Free;
    end;
  end;
end;

class function TdxSpreadSheetFormattedTextService.IsFormattedTextValue(ACell: TdxSpreadSheetCell): Boolean;
begin
  Result := (ACell <> nil) and (ACell.DataType = cdtString) and (ACell.AsSharedString is TdxSpreadSheetFormattedSharedString);
end;

class function TdxSpreadSheetFormattedTextService.IsRTFSupported: Boolean;
begin
  Result := True;
end;

class function TdxSpreadSheetFormattedTextService.SetAsRTF(ACell: TdxSpreadSheetCell; const AEditValue: string): Boolean;
begin
  Result := SetAsRTFValue(ACell, AEditValue, False);
end;

class function TdxSpreadSheetFormattedTextService.SetAsRTFValue(
  ACell: TdxSpreadSheetCell; const AEditValue: string; AForce: Boolean): Boolean;
var
  ACache: TdxSpreadSheetFormattedSharedStringCache;
  ADefaultFont: TFont;
  AFormattedSharedString: TdxSpreadSheetFormattedSharedString;
  AFormattedText: TdxFormattedText;
  ASharedString: TdxSpreadSheetSharedString;
begin
  Result := False;
  if dxIsRichText(AEditValue) then
  begin
    ACache := GetCache(ACell);
    ACache.RemoveItems(ACell.AsSharedString);

    ADefaultFont := TFont.Create;
    try
      ADefaultFont.Assign(ACell.StyleHandle.Font.GraphicObject);
      AFormattedText := CreateFormattedText;
      TdxFormattedTextConverterRTF.Import(AFormattedText, AEditValue, ADefaultFont, True);
      AFormattedSharedString := TdxSpreadSheetFormattedText.FromFormattedText(AFormattedText, ADefaultFont, GetFontTable(ACell));
      if AForce or HasFormatting(AFormattedSharedString) then
      begin
        ASharedString := TdxCustomSpreadSheetAccess(ACell.SpreadSheet).StringTable.Add(AFormattedSharedString);
        if not dxAreFontsEqual(ADefaultFont, ACell.StyleHandle.Font.GraphicObject) then
          ACell.Style.Font.Assign(ADefaultFont);
        ACache.AddRender(ASharedString, ACell.StyleHandle.Font, AFormattedText);
        ACell.AsSharedString := ASharedString; // must be last
        Result := True;
      end
      else
      begin
        if AFormattedSharedString.Runs.Count = 1 then
        begin
          TdxSpreadSheetCellAccess(ACell).Style.Font.Assign(AFormattedSharedString.Runs[0].FontHandle);
          TdxSpreadSheetCellAccess(ACell).SetTextCore(AFormattedSharedString.Value, False, False);
          Result := True;
        end;
        AFormattedSharedString.Free;
        AFormattedText.Free;
      end;
    finally
      ADefaultFont.Free;
    end;
  end;
end;

class function TdxSpreadSheetFormattedTextService.CalculateTextSize(
  ACanvas: TcxCanvas; ACell: TdxSpreadSheetCell; ADisplayWidth: Integer): TSize;
begin
  Result := GetFormattedText(ACell, ACanvas, cxSize(ADisplayWidth, MaxInt), IfThen(ACell.Style.WordWrap, CXTO_WORDBREAK)).TextSize;
end;

class function TdxSpreadSheetFormattedTextService.CreateFormattedText: TdxFormattedText;
begin
  Result := TdxFormattedText.Create;
  Result.UseOfficeFonts := True;
end;

class function TdxSpreadSheetFormattedTextService.GetCache(ACell: TdxSpreadSheetCell): TdxSpreadSheetFormattedSharedStringCache;
begin
  Result := TdxCustomSpreadSheetAccess(ACell.SpreadSheet).FormattedSharedStringCache;
end;

class function TdxSpreadSheetFormattedTextService.GetDisplayFontHandle(ACell: TdxSpreadSheetCell): TdxSpreadSheetFontHandle;
begin
  Result := nil;
  if TdxSpreadSheetCellAccess(ACell).FDisplayValue <> nil then
    Result := TdxSpreadSheetCellAccess(ACell).FDisplayValue.Font;
  if Result = nil then
    Result := ACell.StyleHandle.Font;
end;

class function TdxSpreadSheetFormattedTextService.GetFontTable(ACell: TdxSpreadSheetCell): TdxSpreadSheetFonts;
begin
  Result := TdxCustomSpreadSheetAccess(ACell.SpreadSheet).CellStyles.Fonts;
end;

class function TdxSpreadSheetFormattedTextService.GetFormattedText(ACell: TdxSpreadSheetCell): TdxFormattedText;
var
  ACache: TdxSpreadSheetFormattedSharedStringCache;
  ADefaultFontHandle: TdxSpreadSheetFontHandle;
  ADisplayFontHandle: TdxSpreadSheetFontHandle;
  AString: TdxSpreadSheetFormattedSharedString;
begin
  ACache := GetCache(ACell);
  AString := TdxSpreadSheetFormattedSharedString(ACell.AsSharedString);
  ADefaultFontHandle := ACell.StyleHandle.Font;
  ADisplayFontHandle := GetDisplayFontHandle(ACell);
  if not ACache.TryGetRender(AString, ADisplayFontHandle, TObject(Result)) then
  begin
    Result := CreateFormattedText;
    TdxSpreadSheetFormattedText.ToFormattedText(Result, AString, ADefaultFontHandle);
    TdxSpreadSheetFormattedText.AdjustFontSize(Result, ADisplayFontHandle.Size - ADefaultFontHandle.Size);
    ACache.AddRender(AString, ADisplayFontHandle, Result);
  end;
end;

class function TdxSpreadSheetFormattedTextService.GetFormattedText(
  ACell: TdxSpreadSheetCell; ACanvas: TcxCanvas; const ASize: TSize; AFlags: Cardinal): TdxFormattedText;
begin
  ACanvas.SaveState;
  try
    Result := GetFormattedText(ACell);
    Result.CalculateLayout(ACanvas.Canvas, GetDisplayFontHandle(ACell).GraphicObject, cxRect(ASize), AFlags, dxDefaultScaleFactor);
  finally
    ACanvas.RestoreState;
  end;
end;

class function TdxSpreadSheetFormattedTextService.HasFormatting(AString: TdxSpreadSheetFormattedSharedString): Boolean;
begin
  Result := (AString.Runs.Count > 1) or (AString.Runs.Count > 0) and (AString.Runs[0].StartIndex > 1);
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxSpreadSheetFormattedTextService.Register;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxSpreadSheetFormattedTextService.UnRegister;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
