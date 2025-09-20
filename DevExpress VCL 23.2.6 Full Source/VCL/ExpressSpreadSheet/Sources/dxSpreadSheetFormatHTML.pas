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

unit dxSpreadSheetFormatHTML;

{$I cxVer.Inc}

interface

uses
  System.UITypes,
  Windows, Types, SysUtils, Classes, Graphics, Generics.Defaults, Generics.Collections,
  dxCore, dxCoreGraphics, dxHashUtils, cxGraphics, dxGDIPlusClasses, cxClasses, cxVariants,
  dxSpreadSheetCore, dxSpreadSheetClasses, dxSpreadSheetUtils, dxSpreadSheetTextFileFormatCore, dxSpreadSheetGraphics,
  dxSpreadSheetTypes, dxSpreadSheetHyperlinks, dxSpreadSheetCoreStyles, dxSpreadSheetStyles;

type

  { TdxSpreadSheetHTMLFormat }

  TdxSpreadSheetHTMLFormat = class(TdxSpreadSheetCustomFormat)
  strict private
    class var FCellAutoHeight: Boolean;
  public
    class function CanReadFromStream(AStream: TStream): Boolean; override;
    class function GetDescription: string; override;
    class function GetExt: string; override;
    class function GetReader: TdxSpreadSheetCustomReaderClass; override;
    class function GetWriter: TdxSpreadSheetCustomWriterClass; override;
    //
    class property CellAutoHeight: Boolean read FCellAutoHeight write FCellAutoHeight;
  end;

  { TdxSpreadSheetHTMFormat }

  TdxSpreadSheetHTMFormat = class(TdxSpreadSheetHTMLFormat)
  public
    class function GetExt: string; override;
  end;

  { TdxSpreadSheetHTMLWriterDisplayStyleCache }

  TdxSpreadSheetHTMLWriterDisplayStyleCache = class(TdxValueCacheManager<Int64, TdxSpreadSheetCellStyleHandle>)
  protected
    procedure DoRemove(const Value: TdxSpreadSheetCellStyleHandle); override;
  public
    function Add(ARowIndex, AColumnIndex: Integer; AStyle: TdxSpreadSheetCellStyleHandle): TdxSpreadSheetCellStyleHandle;
    function Find(ARowIndex, AColumnIndex: Integer; out AStyle: TdxSpreadSheetCellStyleHandle): Boolean;
  end;

  { TdxSpreadSheetHTMLWriterStyleData }

  TdxSpreadSheetHTMLWriterStyleData = class
  public
    Data: TBytes;
    Name: string;
  end;

  { TdxSpreadSheetHTMLWriterStyleCollection }

  TdxSpreadSheetHTMLWriterStyleCollection = class(TObjectDictionary<TdxHashTableItem, TdxSpreadSheetHTMLWriterStyleData>)
  protected
    procedure KeyNotify(const Key: TdxHashTableItem; Action: TCollectionNotification); override;
  public
    constructor Create;
  end;

  { TdxSpreadSheetHTMLWriter }

  TdxSpreadSheetHTMLWriter = class(TdxSpreadSheetCustomTextFormatWriter)
  public type
    TWriteProc = procedure (const S: string) of object;
    TWriteStyleProc = procedure (AWriteProc: TWriteProc; AHandle: TdxHashTableItem) of object;
  strict private
    FCellAutoHeight: Boolean;
    FDisplayStyleBuffer: TdxSpreadSheetCellDisplayStyle;
    FDisplayStyleCache: TdxSpreadSheetHTMLWriterDisplayStyleCache;
    FFloatContainers: TList<TPair<TdxSpreadSheetContainer, TRect>>;
    FGraphicCount: Integer;
    FHyperlinkCells: TDictionary<TdxSpreadSheetCell, TdxSpreadSheetHyperlink>;
    FInscribedContainers: TDictionary<TdxSpreadSheetCell, TdxSpreadSheetContainer>;
    FStyleCollection: TdxSpreadSheetHTMLWriterStyleCollection;
    FUseInlineStyles: Boolean;
  protected
    FCurrentRowSize: Integer;
    FDefaultBackgroundColor: TColor;
    FDefaultBorderColor: TColor;
    FDefaultBorders: TdxSpreadSheetBordersHandle;
    FDefaultFontCharset: Integer;
    FDefaultFontColor: TColor;
    FDefaultFontName: string;
    FDefaultFontSize: Integer;
    FStylesPositionInStream: Int64;
    FTargetPath: string;
    FTargetPathImages: string;

    procedure CalculateActualCellStyle(ARowIndex, AColumnIndex: Integer; ACell: TdxSpreadSheetCell; AStyle: TdxSpreadSheetCellStyle);
    procedure ExtendDimensionsByContainers(var R: TRect);
    procedure PrepareContainerImage(const AFileName: string; var AContainerBounds: TRect; AContainer: TdxSpreadSheetContainer);
    procedure PrepareContainers; virtual;
    procedure PrepareHyperlinks; virtual;

    procedure WriteContainer(AContainer: TdxSpreadSheetContainer; AContainerBounds: TRect); virtual;
    procedure WriteContainers; virtual;
    procedure WriteFormattedText(AText: TdxSpreadSheetFormattedSharedString);
    procedure WriteHyperlink(AHyperlink: TdxSpreadSheetHyperlink; const ABody: string = '');
    procedure WriteInlineCellStyle(ABuffer: TStringBuilder; ACellStyle: TdxSpreadSheetCellStyle);
    procedure WriteInlineFontStyle(ABuffer: TStringBuilder; AStyle: TdxSpreadSheetFontHandle); overload;
    function WriteInlineFontStyle(AStyle: TdxSpreadSheetFontHandle): string; overload;
    procedure WriteTableView; override;
    procedure WriteTableViewCell(ARowIndex, AColumnIndex, AAbsoluteRowIndex, AAbsoluteColumnIndex: Integer; ACell: TdxSpreadSheetCell); override;
    procedure WriteTableViewCellContent(ACell: TdxSpreadSheetCell);
    procedure WriteTableViewCellTagBody(ACell: TdxSpreadSheetCell; AMergedCell: TdxSpreadSheetMergedCell);
    procedure WriteTableViewCellTagFooter;
    procedure WriteTableViewCellTagHeader(AAbsoluteRowIndex, AAbsoluteColumnIndex: Integer;
      ACell: TdxSpreadSheetCell; AMergedCell: TdxSpreadSheetMergedCell);
    procedure WriteTableViewDefaultStyleAttributes;
    procedure WriteTableViewFooter; virtual;
    procedure WriteTableViewHeader; virtual;
    procedure WriteTableViewRow(ARowIndex, AAbsoluteRowIndex: Integer; ARow: TdxSpreadSheetTableRow); override;
    procedure WriteTableViewRowFooter(ARowIndex, AAbsoluteRowIndex: Integer; ARow: TdxSpreadSheetTableRow); override;
    procedure WriteTableViewRowHeader(ARowIndex, AAbsoluteRowIndex: Integer; ARow: TdxSpreadSheetTableRow); override;

    // style attributes
    procedure WriteBorders(AWriteProc: TWriteProc; ABorders: TdxSpreadSheetBordersHandle); virtual;
    procedure WriteCellStyle(AWriteProc: TWriteProc; AHandle: TdxHashTableItem); overload;
    procedure WriteCellStyle(AWriteProc: TWriteProc; AStyle: TdxSpreadSheetCellStyleHandle); overload; virtual;
    procedure WriteFont(AWriteProc: TWriteProc; AFont: TdxSpreadSheetFontHandle); overload; virtual;
    procedure WriteFont(AWriteProc: TWriteProc; AHandle: TdxHashTableItem); overload;
    procedure WritePair(AWriteProc: TWriteProc; const AKey, AValue: string);

    // text data
    procedure WriteText(const S: string); overload;
    procedure WriteText(const S: string; AIndex, ALength: Integer); overload;

    function CreateProgressHelper: TdxSpreadSheetCustomFilerProgressHelper; override;
    function CreateStyleData(AHandle: TdxHashTableItem; AStyleSheet: TdxSpreadSheetHTMLWriterStyleCollection;
      const ANameSuffix: string; AProc: TWriteStyleProc): TdxSpreadSheetHTMLWriterStyleData;
    function GetCellStyle(ARowIndex, AColumnIndex: Integer;
      ACell: TdxSpreadSheetCell; ACellIsAssigned: Boolean): TdxSpreadSheetCellStyleHandle;
    function GetEncoding: TEncoding; override;
    function GetImageReference(out AFileName, AReference: string): Boolean;
    function GetTargetFileName(out AFileName: string): Boolean;
    function IsInscribedContainer(AContainer: TdxSpreadSheetContainer): Boolean;

    procedure WriteDocumentFooter; override;
    procedure WriteDocumentHeader; override;
    procedure WriteEncodingPreamble; override;
    procedure WriteStandardStyles; virtual;

    property DisplayStyleBuffer: TdxSpreadSheetCellDisplayStyle read FDisplayStyleBuffer;
    property DisplayStyleCache: TdxSpreadSheetHTMLWriterDisplayStyleCache read FDisplayStyleCache;
    property FloatContainers: TList<TPair<TdxSpreadSheetContainer, TRect>> read FFloatContainers;
    property HyperlinkCells: TDictionary<TdxSpreadSheetCell, TdxSpreadSheetHyperlink> read FHyperlinkCells;
    property InscribedContainers: TDictionary<TdxSpreadSheetCell, TdxSpreadSheetContainer> read FInscribedContainers;
    property StyleCollection: TdxSpreadSheetHTMLWriterStyleCollection read FStyleCollection;
  public
    constructor Create(AOwner: TdxCustomSpreadSheet; AStream: TStream); override;
    destructor Destroy; override;
    procedure Initialize(AView: TdxSpreadSheetTableView; const AArea: TRect); override;
    function RegisterCellStyle(AStyle: TdxSpreadSheetCellStyle): string; virtual;
    function RegisterFont(AFont: TdxSpreadSheetFontHandle): string; virtual;
    procedure WriteData; override;
    //
    property CellAutoHeight: Boolean read FCellAutoHeight write FCellAutoHeight;
    property UseInlineStyles: Boolean read FUseInlineStyles write FUseInlineStyles;
  end;

implementation

uses
  Math, StrUtils, RTLConsts, dxColorPicker, dxCoreClasses, cxGeometry, dxSpreadSheetCoreHelpers,
  dxSpreadSheetStrs, dxStringHelper;

const
  dxThisUnitName = 'dxSpreadSheetFormatHTML';

const
  dxBodyMargin = 8;

type
  TdxSpreadSheetCellStylesAccess = class(TdxSpreadSheetCellStyles);
  TdxSpreadSheetContainerAccess = class(TdxSpreadSheetContainer);
  TdxSpreadSheetTableColumnsAccess = class(TdxSpreadSheetTableColumns);
  TdxSpreadSheetTableViewAccess = class(TdxSpreadSheetTableView);
  TdxSpreadSheetTableViewInfoAccess = class(TdxSpreadSheetTableViewInfo);
  TdxBufferedStreamAccess = class(TdxBufferedStream);

  { TdxSpreadSheetStringBuilderHelper }

  TdxSpreadSheetStringBuilderHelper = class helper for TStringBuilder
  public
    procedure Write(const S: string);
  end;

function GetHTMLColor(AColor: TColor): string;
begin
  if AColor = clNone then
    Result := 'transparent'
  else
    Result := TdxAlphaColors.ToHexCode(dxColorToAlphaColor(AColor), False, '#');
end;

{ TdxSpreadSheetStringBuilderHelper }

procedure TdxSpreadSheetStringBuilderHelper.Write(const S: string);
begin
  Append(S);
end;

{ TdxSpreadSheetHTMLFormat }

class function TdxSpreadSheetHTMLFormat.CanReadFromStream(AStream: TStream): Boolean;
begin
  Result := False;
end;

class function TdxSpreadSheetHTMLFormat.GetDescription: string;
begin
  Result := 'Web Page';
end;

class function TdxSpreadSheetHTMLFormat.GetExt: string;
begin
  Result := '.html';
end;

class function TdxSpreadSheetHTMLFormat.GetReader: TdxSpreadSheetCustomReaderClass;
begin
  Result := nil;
end;

class function TdxSpreadSheetHTMLFormat.GetWriter: TdxSpreadSheetCustomWriterClass;
begin
  Result := TdxSpreadSheetHTMLWriter;
end;

{ TdxSpreadSheetHTMFormat }

class function TdxSpreadSheetHTMFormat.GetExt: string;
begin
  Result := '.htm';
end;

{ TdxSpreadSheetHTMLWriterDisplayStyleCache }

procedure TdxSpreadSheetHTMLWriterDisplayStyleCache.DoRemove(const Value: TdxSpreadSheetCellStyleHandle);
begin
  Value.Release;
end;

function TdxSpreadSheetHTMLWriterDisplayStyleCache.Add(
  ARowIndex, AColumnIndex: Integer; AStyle: TdxSpreadSheetCellStyleHandle): TdxSpreadSheetCellStyleHandle;
begin
  AStyle.AddRef;
  inherited Add(dxMakeInt64(ARowIndex, AColumnIndex), AStyle);
  Result := AStyle;
end;

function TdxSpreadSheetHTMLWriterDisplayStyleCache.Find(
  ARowIndex, AColumnIndex: Integer; out AStyle: TdxSpreadSheetCellStyleHandle): Boolean;
begin
  Result := Get(dxMakeInt64(ARowIndex, AColumnIndex), AStyle);
end;

{ TdxSpreadSheetHTMLWriterStyleCollection }

constructor TdxSpreadSheetHTMLWriterStyleCollection.Create;
begin
  inherited Create([doOwnsValues], 4096);
end;

procedure TdxSpreadSheetHTMLWriterStyleCollection.KeyNotify(const Key: TdxHashTableItem; Action: TCollectionNotification);
begin
  case Action of
    cnAdded:
      Key.AddRef;
    cnRemoved, cnExtracted:
      Key.Release;
  end;
end;

{ TdxSpreadSheetHTMLWriter }

constructor TdxSpreadSheetHTMLWriter.Create(AOwner: TdxCustomSpreadSheet; AStream: TStream);
begin
  inherited Create(AOwner, AStream);
  FStyleCollection := TdxSpreadSheetHTMLWriterStyleCollection.Create;
  FFloatContainers := TList<TPair<TdxSpreadSheetContainer, TRect>>.Create;
  FHyperlinkCells := TDictionary<TdxSpreadSheetCell, TdxSpreadSheetHyperlink>.Create;
  FInscribedContainers := TDictionary<TdxSpreadSheetCell, TdxSpreadSheetContainer>.Create;
end;

destructor TdxSpreadSheetHTMLWriter.Destroy;
begin
  FreeAndNil(FInscribedContainers);
  FreeAndNil(FDisplayStyleBuffer);
  FreeAndNil(FDisplayStyleCache);
  FreeAndNil(FFloatContainers);
  FreeAndNil(FHyperlinkCells);
  FreeAndNil(FStyleCollection);
  inherited Destroy;
end;

procedure TdxSpreadSheetHTMLWriter.Initialize(AView: TdxSpreadSheetTableView; const AArea: TRect);
var
  AContentStyle: TcxViewParams;
  AFileName: string;
begin
  inherited;

  FreeAndNil(FDisplayStyleBuffer);
  FreeAndNil(FDisplayStyleCache);
  FDisplayStyleBuffer := TdxSpreadSheetCellDisplayStyle.Create(TableView);
  FDisplayStyleCache := TdxSpreadSheetHTMLWriterDisplayStyleCache.Create(dxSpreadSheetAreaWidth(TableViewArea) * 3);

  FAlignColumns := True;
  FCellAutoHeight := TdxSpreadSheetHTMLFormat.CellAutoHeight;

  FDefaultFontName  := SpreadSheet.DefaultCellStyle.Font.Name;
  FDefaultFontSize  := SpreadSheet.DefaultCellStyle.Font.Size;
  FDefaultFontColor := SpreadSheet.DefaultCellStyle.Font.Color;
  FDefaultFontCharset := SpreadSheet.DefaultCellStyle.Font.Charset;
  FDefaultBackgroundColor := SpreadSheet.DefaultCellStyle.Brush.BackgroundColor;
  FDefaultBorders := SpreadSheet.DefaultCellStyle.Handle.Borders;

  AContentStyle := SpreadSheet.Styles.GetContentStyle(nil);
  FDefaultBackgroundColor := cxGetActualColor(FDefaultBackgroundColor, AContentStyle.Color);
  FDefaultFontColor := cxGetActualColor(FDefaultFontColor, AContentStyle.TextColor);

  if TableView.Options.ActualGridLines then
    FDefaultBorderColor := cxGetActualColor(SpreadSheet.OptionsView.GridLineColor, clBtnShadow)
  else
    FDefaultBorderColor := clNone;

  if GetTargetFileName(AFileName) then
  begin
    FTargetPath := ExtractFilePath(AFileName);
    if FTargetPath = '' then
      FTargetPath := IncludeTrailingPathDelimiter(GetCurrentDir);
    FTargetPathImages := FTargetPath + ChangeFileExt(ExtractFileName(AFileName), '.images') + PathDelim;
  end;
end;

function TdxSpreadSheetHTMLWriter.GetImageReference(out AFileName, AReference: string): Boolean;
begin
  Result := FTargetPathImages <> '';
  if Result then
  begin
    AFileName := FTargetPathImages + IntToStr(FGraphicCount) + '.png';
    AReference := Copy(AFileName, Length(FTargetPath) + 1, MaxInt);
    Inc(FGraphicCount);
  end;
end;

procedure TdxSpreadSheetHTMLWriter.WriteData;
var
  ACapacity: Integer;
  AStyleData: TdxSpreadSheetHTMLWriterStyleData;
  AStyleStream: TMemoryStream;
begin
  inherited WriteData;

  if StyleCollection.Count > 0 then
  begin
    ACapacity := 0;
    for AStyleData in StyleCollection.Values do
      Inc(ACapacity, Length(AStyleData.Data) + 1 {size of short line break});

    AStyleStream := TMemoryStream.Create;
    try
      AStyleStream.Size := ACapacity;
      for AStyleData in StyleCollection.Values do
      begin
        WriteBytesProc(AStyleStream, AStyleData.Data);
        WriteByteProc(AStyleStream, 13);
      end;
      dxStreamInsertData(Stream, AStyleStream, FStylesPositionInStream, ProgressHelper);
    finally
      AStyleStream.Free;
    end;
  end;
end;

function TdxSpreadSheetHTMLWriter.CreateProgressHelper: TdxSpreadSheetCustomFilerProgressHelper;
begin
  Result := TdxSpreadSheetCustomFilerProgressHelper.Create(Self, 3);
end;

function TdxSpreadSheetHTMLWriter.CreateStyleData(AHandle: TdxHashTableItem;
  AStyleSheet: TdxSpreadSheetHTMLWriterStyleCollection; const ANameSuffix: string;
  AProc: TWriteStyleProc): TdxSpreadSheetHTMLWriterStyleData;
var
  ABuffer: TStringBuilder;
begin
  Result := TdxSpreadSheetHTMLWriterStyleData.Create;
  Result.Name := ANameSuffix + IntToStr(AStyleSheet.Count);

  ABuffer := TdxStringBuilderManager.Get;
  try
    ABuffer.Append('.' + Result.Name + '{ ');
    AProc(ABuffer.Write, AHandle);
    ABuffer.Append('}');
    Result.Data := Encoding.GetBytes(ABuffer.ToString);
  finally
    TdxStringBuilderManager.Release(ABuffer);
  end;

  AStyleSheet.Add(AHandle, Result);
end;

function TdxSpreadSheetHTMLWriter.GetEncoding: TEncoding;
begin
  Result := TEncoding.UTF8;
end;

function TdxSpreadSheetHTMLWriter.GetTargetFileName(out AFileName: string): Boolean;
var
  AStream: TStream;
begin
  AStream := Stream;
  while AStream is TdxBufferedStream do
    AStream := TdxBufferedStreamAccess(AStream).SourceStream;
  Result := AStream is TFileStream;
  if Result then
    AFileName := TFileStream(AStream).FileName;
end;

function TdxSpreadSheetHTMLWriter.RegisterCellStyle(AStyle: TdxSpreadSheetCellStyle): string;
var
  AData: TdxSpreadSheetHTMLWriterStyleData;
begin
  if not StyleCollection.TryGetValue(AStyle.Handle, AData) then
    AData := CreateStyleData(AStyle.Handle, StyleCollection, 'cs', WriteCellStyle);
  Result := AData.Name;
end;

function TdxSpreadSheetHTMLWriter.RegisterFont(AFont: TdxSpreadSheetFontHandle): string;
var
  AData: TdxSpreadSheetHTMLWriterStyleData;
begin
  if not StyleCollection.TryGetValue(AFont, AData) then
    AData := CreateStyleData(AFont, StyleCollection, 'f', WriteFont);
  Result := AData.Name;
end;

procedure TdxSpreadSheetHTMLWriter.WriteDocumentFooter;
begin
  WriteLine('</body>');
  WriteLine('</html>');
end;

procedure TdxSpreadSheetHTMLWriter.WriteDocumentHeader;
begin
  WriteLine('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">');
  WriteLine('<html>');
  WriteLine('<head>');
  WriteLine('<meta http-equiv="content-type" content="text/html" charset="utf-8">');

  Write('<title>');
  Write(SpreadSheet.ActiveSheetAsTable.Caption);
  WriteLine('</title>');

  WriteLine('<style type="text/css"><!--');
  WriteStandardStyles;
  FStylesPositionInStream := Stream.Position;
  WriteLine('--></style>');

  WriteLine('</head>');
  WriteLine('<body>');
end;

procedure TdxSpreadSheetHTMLWriter.WriteEncodingPreamble;
begin
  // do nothing
end;

procedure TdxSpreadSheetHTMLWriter.WriteStandardStyles;
begin
  WriteLine('body { margin: ' + IntToStr(dxBodyMargin) + 'px;}');

  WriteLine('table { border-collapse: collapse; table-layout: fixed; }');

  Write('table td {');
  Write(' overflow: hidden;');
  Write(' padding: 0px;');
  if not UseInlineStyles then
  begin
    WriteTableViewDefaultStyleAttributes;
    Write(' vertical-align: bottom;');
    WriteBorders(Write, FDefaultBorders);
  end;
  WriteLine('}');

  WriteLine('div.cell { width: 100%; overflow: hidden; position: relative;}');
end;

procedure TdxSpreadSheetHTMLWriter.ExtendDimensionsByContainers(var R: TRect);
var
  AColumnIndex: Integer;
  ARowIndex: Integer;
  ATableView: IdxSpreadSheetTableView;
  I: Integer;
begin
  if Supports(TableView, IdxSpreadSheetTableView, ATableView) then
    for I := 0 to FloatContainers.Count - 1 do
      if ATableView.GetCellAtAbsolutePoint(FloatContainers[I].Value.BottomRight, ARowIndex, AColumnIndex) then
      begin
        R.Right := Max(R.Right, AColumnIndex);
        R.Bottom := Max(R.Bottom, ARowIndex);
      end;
end;

procedure TdxSpreadSheetHTMLWriter.CalculateActualCellStyle(
  ARowIndex, AColumnIndex: Integer; ACell: TdxSpreadSheetCell; AStyle: TdxSpreadSheetCellStyle);
var
  ABorder: TcxBorder;
  ABorderColor: TColor;
  ABorderStyle: TdxSpreadSheetCellBorderStyle;
  ANeighborCol: Integer;
  ANeighborRow: Integer;
begin
  AStyle.Handle := GetCellStyle(ARowIndex, AColumnIndex, ACell, True);
  AStyle.BeginUpdate;
  try
    for ABorder := Low(TcxBorder) to High(TcxBorder) do
      if dxSpreadSheetGetNeighbor(ARowIndex, AColumnIndex, ABorder, ANeighborRow, ANeighborCol) then
      begin
        dxSpreadSheetMergeBorderStyle(ABorder, AStyle.Handle,
          GetCellStyle(ANeighborRow, ANeighborCol, nil, False), ABorderColor, ABorderStyle);
        AStyle.Borders[ABorder].Assign(ABorderStyle, ABorderColor);
      end;
  finally
    AStyle.EndUpdate;
  end;
end;

function TdxSpreadSheetHTMLWriter.GetCellStyle(ARowIndex, AColumnIndex: Integer;
  ACell: TdxSpreadSheetCell; ACellIsAssigned: Boolean): TdxSpreadSheetCellStyleHandle;
begin
  if not DisplayStyleCache.Find(ARowIndex, AColumnIndex, Result) then
  begin
    if not ACellIsAssigned then
      ACell := TableView.Cells[ARowIndex, AColumnIndex];

    Result := TdxSpreadSheetTableViewAccess(TableView).GetCellStyleHandle(ARowIndex, AColumnIndex, ACell);

    if TableView.ConditionalFormatting.RuleCount > 0 then
    begin
      DisplayStyleBuffer.Reset;
      DisplayStyleBuffer.Handle := Result.Clone;
      if TableView.ConditionalFormatting.CalculateStyle(DisplayStyleBuffer, ARowIndex, AColumnIndex, ACell) then
        Exit(DisplayStyleCache.Add(ARowIndex, AColumnIndex, DisplayStyleBuffer.Handle));
    end;

    Result := DisplayStyleCache.Add(ARowIndex, AColumnIndex, Result);
  end;
end;

procedure TdxSpreadSheetHTMLWriter.PrepareContainerImage(
  const AFileName: string; var AContainerBounds: TRect; AContainer: TdxSpreadSheetContainer);

  function CreateContainerImage(var AContainerBounds: TRect): TdxPNGImage;
  var
    ABitmap: TcxBitmap32;
    ACanDrawSelection: Boolean;
    AViewInfo: TdxSpreadSheetContainerViewInfo;
  begin
    AViewInfo := TdxSpreadSheetContainerAccess(AContainer).CreateViewInfo;
    try
      AViewInfo.SetBounds(AContainerBounds, AContainerBounds);
      AViewInfo.Calculate;

      ABitmap := TcxBitmap32.CreateSize(AViewInfo.RealDrawingBounds, True);
      try
        ACanDrawSelection := AViewInfo.CanDrawSelection;
        try
          AViewInfo.CanDrawSelection := False;
          ABitmap.cxCanvas.WindowOrg := AViewInfo.RealDrawingBounds.TopLeft;
          AViewInfo.Draw(ABitmap.cxCanvas, dsFirst);
          AViewInfo.Draw(ABitmap.cxCanvas, dsSecond);
        finally
          AViewInfo.CanDrawSelection := ACanDrawSelection;
        end;

        Result := TdxPNGImage.CreateFromBitmap(ABitmap);
      finally
        ABitmap.Free;
      end;

      AContainerBounds := AViewInfo.RealDrawingBounds;
    finally
      AViewInfo.Free;
    end;
  end;

var
  AImage: TdxPNGImage;
begin
  AImage := CreateContainerImage(AContainerBounds);
  try
    ForceDirectories(ExtractFilePath(AFileName));
    AImage.SaveToFile(AFileName);
  finally
    AImage.Free;
  end;
end;

procedure TdxSpreadSheetHTMLWriter.PrepareContainers;
var
  AContainer: TdxSpreadSheetContainerAccess;
  I: Integer;
begin
  if Stream is TFileStream then
  begin
    for I := 0 to TableView.Containers.Count - 1 do
    begin
      AContainer := TdxSpreadSheetContainerAccess(TableView.Containers[I]);
      if AContainer.Visible then
      begin
        if IsInscribedContainer(AContainer) then
          InscribedContainers.AddOrSetValue(AContainer.AnchorPoint1.Cell, AContainer)
        else
          FloatContainers.Add(TPair<TdxSpreadSheetContainer, TRect>.Create(AContainer, AContainer.Calculator.CalculateBounds));
      end;
    end;
    ExtendDimensionsByContainers(FTableViewArea);
  end;
end;

procedure TdxSpreadSheetHTMLWriter.PrepareHyperlinks;
var
  ACell: TdxSpreadSheetCell;
  AHyperlink: TdxSpreadSheetHyperlink;
  I: Integer;
begin
  for I := 0 to TableView.Hyperlinks.Count - 1 do
  begin
    AHyperlink := TableView.Hyperlinks[I];
    if AHyperlink.IsAreaCorrect and (AHyperlink.ValueType <> hvtReference) then
    begin
      ACell := TableView.CreateCell(AHyperlink.Area.Top, AHyperlink.Area.Left);
      if not HyperlinkCells.ContainsKey(ACell) then
        HyperlinkCells.Add(ACell, AHyperlink);
    end;
  end;
end;

procedure TdxSpreadSheetHTMLWriter.WriteContainer(AContainer: TdxSpreadSheetContainer; AContainerBounds: TRect);
var
  AFileName: string;
  AReference: string;
begin
  if GetImageReference(AFileName, AReference) then
  begin
    PrepareContainerImage(AFileName, AContainerBounds, AContainer);
    WriteHyperlink(AContainer.Hyperlink,
      Format('<img src="%s" style="position: absolute; left: %dpx; top: %dpx">',
      [dxReplacePathDelimiter(AReference, PathDelim, '/'), AContainerBounds.Left, AContainerBounds.Top]));
  end;
end;

procedure TdxSpreadSheetHTMLWriter.WriteContainers;
var
  I: Integer;
begin
  ProgressHelper.BeginStage(FloatContainers.Count);
  try
    for I := 0 to FloatContainers.Count - 1 do
    begin
      with FloatContainers[I] do
        WriteContainer(Key, cxRectOffset(Value, dxBodyMargin, dxBodyMargin));
      ProgressHelper.NextTask;
    end;
  finally
    ProgressHelper.EndStage;
  end;
end;

procedure TdxSpreadSheetHTMLWriter.WriteFormattedText(AText: TdxSpreadSheetFormattedSharedString);

  function GetRunLength(AStartIndex, ARunIndex: Integer): Integer;
  begin
    if ARunIndex + 1 < AText.Runs.Count then
      Result := AText.Runs[ARunIndex + 1].StartIndex - AStartIndex
    else
      Result := Length(AText.Value) - AStartIndex + 1;
  end;

var
  ALength: Integer;
  ARun: TdxSpreadSheetFormattedSharedStringRun;
  I: Integer;
begin
  ALength := GetRunLength(1, -1);
  if ALength > 0 then
    WriteText(AText.Value, 1, ALength);

  for I := 0 to AText.Runs.Count - 1 do
  begin
    ARun := AText.Runs[I];
    ALength := GetRunLength(ARun.StartIndex, I);
    if ALength > 0 then
    begin
      Write('<span');

      if UseInlineStyles then
      begin
        Write(' style="');
        Write(WriteInlineFontStyle(ARun.FontHandle));
        Write('"');
      end
      else
      begin
        Write(' class="');
        Write(RegisterFont(ARun.FontHandle));
        Write('"');
      end;

      Write('>');
      WriteText(AText.Value, ARun.StartIndex, ALength);
      Write('</span>');
    end;
  end;
end;

procedure TdxSpreadSheetHTMLWriter.WriteHyperlink(AHyperlink: TdxSpreadSheetHyperlink; const ABody: string = '');
var
  AHint: string;
begin
  if (AHyperlink = nil) or (AHyperlink.ValueType = hvtReference) then
  begin
    Write(ABody);
    Exit;
  end;

  if havScreenTip in AHyperlink.AssignedValues then
    AHint := AHyperlink.ScreenTip
  else
    AHint := Format(cxGetResourceString(@sdxDefaultHyperlinkShortScreenTip), [AHyperlink.Value]);

  Write('<a href="');
  Write(AHyperlink.Value);
  Write('" target="_blank" title="');
  WriteText(AHint);
  Write('">');
  if ABody <> '' then
    Write(ABody)
  else
    WriteText(AHyperlink.DisplayText);
  Write('</a>');
end;

procedure TdxSpreadSheetHTMLWriter.WriteInlineCellStyle(ABuffer: TStringBuilder; ACellStyle: TdxSpreadSheetCellStyle);
begin
  WriteCellStyle(ABuffer.Write, ACellStyle.Handle);
end;

procedure TdxSpreadSheetHTMLWriter.WriteInlineFontStyle(ABuffer: TStringBuilder; AStyle: TdxSpreadSheetFontHandle);
begin
  WriteFont(ABuffer.Write, AStyle);
end;

function TdxSpreadSheetHTMLWriter.WriteInlineFontStyle(AStyle: TdxSpreadSheetFontHandle): string;
var
  ABuffer: TStringBuilder;
begin
  ABuffer := TdxStringBuilderManager.Get;
  try
    WriteInlineFontStyle(ABuffer, AStyle);
    Result := ABuffer.ToString;
  finally
    TdxStringBuilderManager.Release(ABuffer);
  end;
end;

procedure TdxSpreadSheetHTMLWriter.WriteTableView;
begin
  PrepareContainers;
  PrepareHyperlinks;
  WriteTableViewHeader;
  inherited;
  WriteTableViewFooter;
  WriteContainers;
end;

procedure TdxSpreadSheetHTMLWriter.WriteTableViewCell(
  ARowIndex, AColumnIndex, AAbsoluteRowIndex, AAbsoluteColumnIndex: Integer; ACell: TdxSpreadSheetCell);
var
  AMergedCell: TdxSpreadSheetMergedCell;
begin
  AMergedCell := TableView.MergedCells.FindCell(AAbsoluteRowIndex, AAbsoluteColumnIndex);
  if (AMergedCell = nil) or (AMergedCell.Area.Left = AAbsoluteColumnIndex) and (AMergedCell.Area.Top = AAbsoluteRowIndex) then
  begin
    WriteTableViewCellTagHeader(AAbsoluteRowIndex, AAbsoluteColumnIndex, ACell, AMergedCell);
    WriteTableViewCellTagBody(ACell, AMergedCell);
    WriteTableViewCellTagFooter;
  end;
end;

procedure TdxSpreadSheetHTMLWriter.WriteTableViewCellTagBody(ACell: TdxSpreadSheetCell; AMergedCell: TdxSpreadSheetMergedCell);

  function GetInscribedContainer: TdxSpreadSheetContainer;
  begin
    if not InscribedContainers.TryGetValue(ACell, Result) then
      Result := nil;
  end;

  function IsSingeLineCell(AMergedCell: TdxSpreadSheetMergedCell): Boolean;
  begin
    Result := (AMergedCell = nil) or (GetActualAreaHeight(AMergedCell.Area) = 1);
  end;

  procedure WriteDivHeader(AInscribedContainer: TdxSpreadSheetContainer);
  var
    AInlineStyles: TStringBuilder;
  begin
    AInlineStyles := TdxStringBuilderManager.Get;
    try
      if ACell.Style.AlignHorzIndent > 0 then
      begin
        if ACell.Style.AlignHorz in [ssahLeft, ssahDistributed] then
          AInlineStyles.AppendFormat('padding-left: %dpx; ', [ACell.Style.AlignHorzIndent]);
        if ACell.Style.AlignHorz in [ssahRight, ssahDistributed] then
          AInlineStyles.AppendFormat('padding-right: %dpx; ', [ACell.Style.AlignHorzIndent]);
      end;

      if AInscribedContainer <> nil then
        AInlineStyles.AppendFormat('min-height: %dpx; ', [FCurrentRowSize]);

      if not FCellAutoHeight and IsSingeLineCell(AMergedCell) then
        AInlineStyles.AppendFormat('max-height: %dpx; ', [FCurrentRowSize]);

      Write('<div class="cell"');
      if AInlineStyles.Length > 0 then
      begin
        Write(' style="');
        Write(AInlineStyles.ToString);
        Write('"');
      end;
      Write('>');
    finally
      TdxStringBuilderManager.Release(AInlineStyles);
    end;
  end;

  procedure WriteDivFooter;
  begin
    Write('</div>');
  end;

var
  AContainer: TdxSpreadSheetContainerAccess;
begin
  if ACell <> nil then
  begin
    AContainer := TdxSpreadSheetContainerAccess(GetInscribedContainer);
    if not ACell.IsEmpty or (AContainer <> nil) then
    begin
      WriteDivHeader(AContainer);

      if ACell.Style.WordWrap then
        WriteTableViewCellContent(ACell)
      else
      begin
        Write('<nobr>');
        WriteTableViewCellContent(ACell);
        Write('</nobr>');
      end;

      if AContainer <> nil then
        WriteContainer(AContainer, cxRectSetOrigin(AContainer.Calculator.CalculateBounds, AContainer.AnchorPoint1.Offset));

      WriteDivFooter;
    end;
  end;
end;

procedure TdxSpreadSheetHTMLWriter.WriteTableViewCellTagFooter;
begin
  WriteLine('</td>');
end;

procedure TdxSpreadSheetHTMLWriter.WriteTableViewCellTagHeader(
  AAbsoluteRowIndex, AAbsoluteColumnIndex: Integer; ACell: TdxSpreadSheetCell; AMergedCell: TdxSpreadSheetMergedCell);
var
  AAreaSize: Integer;
  AInlineStyles: TStringBuilder;
begin
  Write('<td');

  AInlineStyles := TdxStringBuilderManager.Get;
  try
    CalculateActualCellStyle(AAbsoluteRowIndex, AAbsoluteColumnIndex, ACell, DisplayStyleBuffer);
    if UseInlineStyles then
      WriteInlineCellStyle(AInlineStyles, DisplayStyleBuffer)
    else
    begin
      Write(' class="');
      Write(RegisterCellStyle(DisplayStyleBuffer));
      Write('"');
    end;

    if AMergedCell <> nil then
    begin
      AAreaSize := GetActualAreaWidth(AMergedCell.Area);
      if AAreaSize > 1 then
        Write(Format(' colspan="%d"', [AAreaSize]));

      AAreaSize := GetActualAreaHeight(AMergedCell.Area);
      if AAreaSize > 1 then
        Write(Format(' rowspan="%d"', [AAreaSize]));
    end;

    if (ACell <> nil) and (ACell.Style.AlignHorz = ssahGeneral) and ACell.IsNumericValue then
      AInlineStyles.Append('text-align: right;');

    if AInlineStyles.Length > 0 then
    begin
      Write(' style="');
      Write(AInlineStyles.ToString);
      Write('"');
    end;
  finally
    TdxStringBuilderManager.Release(AInlineStyles);
  end;

  Write('>');
end;

procedure TdxSpreadSheetHTMLWriter.WriteTableViewCellContent(ACell: TdxSpreadSheetCell);
var
  AHyperlink: TdxSpreadSheetHyperlink;
begin
  if HyperlinkCells.TryGetValue(ACell, AHyperlink) then
    WriteHyperlink(AHyperlink)
  else
    if ACell.AsSharedString is TdxSpreadSheetFormattedSharedString then
      WriteFormattedText(TdxSpreadSheetFormattedSharedString(ACell.AsSharedString))
    else
      WriteText(ACell.DisplayText);
end;

procedure TdxSpreadSheetHTMLWriter.WriteTableViewDefaultStyleAttributes;
begin
  Write(' background-color: ' + GetHTMLColor(FDefaultBackgroundColor) + ';');
  Write(' color: ' + GetHTMLColor(FDefaultFontColor) + ';');
  Write(' font-family: ' + FDefaultFontName + ';');
  Write(' font-size: ' + IntToStr(FDefaultFontSize) + 'pt;');
  Write(' mso-font-charset: ' + IntToStr(FDefaultFontCharset) + ';');
end;

procedure TdxSpreadSheetHTMLWriter.WriteTableViewFooter;
begin
  WriteLine('</table>');
end;

procedure TdxSpreadSheetHTMLWriter.WriteTableViewHeader;

  function GetTotalWidth(const AColumnWidths: array of Integer): Integer;
  var
    I: Integer;
  begin
    Result := 0;
    for I := 0 to Length(AColumnWidths) - 1 do
      Inc(Result, AColumnWidths[I]);
  end;

  procedure DoWriteTableHeader(const AColumnWidths: array of Integer);
  var
    I: Integer;
  begin
    Write('<table border="0" cellspacing="0"');
    Write(' width="' + IntToStr(GetTotalWidth(AColumnWidths)) + '"');
    Write(' bgcolor="' + GetHTMLColor(FDefaultBackgroundColor) + '"');
    if UseInlineStyles then
    begin
      Write(' style="');
      WriteTableViewDefaultStyleAttributes;
      Write('"');
    end;
    WriteLine('>');
    for I := 0 to Length(AColumnWidths) - 1 do
      WriteLine(Format('<col width="%dpx"/>', [AColumnWidths[I]]));
  end;

var
  AColumn: TdxSpreadSheetTableColumn;
  AColumnIndex: Integer;
  AColumnWidths: array of Integer;
  I: Integer;
begin
  AColumnIndex := 0;
  SetLength(AColumnWidths, GetActualAreaWidth(TableViewArea));
  for I := TableViewArea.Left to TableViewArea.Right do
  begin
    AColumn := TableView.Columns.Items[I];
    if not SkipHiddenCells or (AColumn = nil) or AColumn.Visible then
    begin
      if AColumn <> nil then
        AColumnWidths[AColumnIndex] := AColumn.Size
      else
        AColumnWidths[AColumnIndex] := TableView.Columns.DefaultSize;

      Inc(AColumnIndex);
    end;
  end;
  DoWriteTableHeader(AColumnWidths);
  SetLength(AColumnWidths, 0);
end;

procedure TdxSpreadSheetHTMLWriter.WriteTableViewRow(ARowIndex, AAbsoluteRowIndex: Integer; ARow: TdxSpreadSheetTableRow);
begin
  if ARow <> nil then
    FCurrentRowSize := ARow.Size
  else
    FCurrentRowSize := TableView.Rows.DefaultSize;

  inherited;
end;

procedure TdxSpreadSheetHTMLWriter.WriteTableViewRowFooter(ARowIndex, AAbsoluteRowIndex: Integer; ARow: TdxSpreadSheetTableRow);
begin
  Write('</tr>');
end;

procedure TdxSpreadSheetHTMLWriter.WriteTableViewRowHeader(ARowIndex, AAbsoluteRowIndex: Integer; ARow: TdxSpreadSheetTableRow);
begin
  WriteLine(Format('<tr height="%dpx">', [FCurrentRowSize]));
end;

procedure TdxSpreadSheetHTMLWriter.WriteBorders(AWriteProc: TWriteProc; ABorders: TdxSpreadSheetBordersHandle);
const
  BorderStyle: array[TdxSpreadSheetCellBorderStyle] of string = (
    'solid', 'dotted', 'dotted', 'dashed', 'dashed', 'dashed', 'solid',
    'dashed', 'solid', 'dashed', 'dashed', 'solid', 'solid', 'double', 'solid'
  );
  SideName: array[TcxBorder] of string = (
    'left', 'top', 'right', 'bottom'
  );
var
  ABorderColor: TColor;
  ABorderSize: Integer;
  ABorderStyle: TdxSpreadSheetCellBorderStyle;
  ASide: TcxBorder;
begin
  for ASide := Low(TcxBorder) to High(TcxBorder) do
  begin
    if (FDefaultBorders = ABorders) or UseInlineStyles or not FDefaultBorders.IsEqual(ABorders, ASide) then
    begin
      ABorderStyle := ABorders.BorderStyle[ASide];
      ABorderColor := ABorders.BorderColor[ASide];
      ABorderSize := dxSpreadSheetBorderStyleThickness[ABorderStyle];

      AWriteProc(' border-');
      AWriteProc(SideName[ASide]);
      AWriteProc(': ');

      if ABorderColor = clDefault then
      begin
        if ABorderStyle = sscbsDefault then
          ABorderColor := FDefaultBorderColor
        else
          ABorderColor := clBlack;
      end;

      if (ABorderColor <> clNone) and (ABorderSize > 0) and (ABorderStyle <> sscbsNone) then
      begin
        AWriteProc(IntToStr(ABorderSize));
        AWriteProc('px');
        AWriteProc(' ');
        AWriteProc(BorderStyle[ABorderStyle]);
        AWriteProc(' ');
        AWriteProc(GetHTMLColor(ABorderColor));
        AWriteProc(';');
      end
      else
        AWriteProc('0px;');
    end;
  end;
end;

procedure TdxSpreadSheetHTMLWriter.WriteCellStyle(AWriteProc: TWriteProc; AHandle: TdxHashTableItem);
begin
  WriteCellStyle(AWriteProc, TdxSpreadSheetCellStyleHandle(AHandle));
end;

procedure TdxSpreadSheetHTMLWriter.WriteCellStyle(AWriteProc: TWriteProc; AStyle: TdxSpreadSheetCellStyleHandle);
const
  AlignHorzMap: array[TdxSpreadSheetDataAlignHorz] of string = (
    'left', 'left', 'center', 'right', 'justify', 'justify', 'justify'
  );
  AlignVertMap: array[TdxSpreadSheetDataAlignVert] of string = (
    'top', 'middle', 'bottom', 'middle', 'middle'
  );
var
  AColor: TColor;
begin
  WriteFont(AWriteProc, AStyle.Font);

  if AStyle.Borders <> FDefaultBorders then
    WriteBorders(AWriteProc, AStyle.Borders);

  if AStyle.Brush.Style = sscfsSolid then
  begin
    AColor := AStyle.Brush.BackgroundColor;
    if cxColorIsValid(AColor) and (AColor <> FDefaultBackgroundColor) then
      WritePair(AWriteProc, 'background-color', GetHTMLColor(AColor));
  end;

  if not (AStyle.AlignHorz in [ssahLeft, ssahGeneral]) then
    WritePair(AWriteProc, 'text-align', AlignHorzMap[AStyle.AlignHorz]);

  if AStyle.AlignHorzIndent > 0 then
  begin
    if AStyle.AlignHorz in [ssahLeft, ssahDistributed] then
      WritePair(AWriteProc, 'padding-left', IntToStr(AStyle.AlignHorzIndent) + 'px');
    if AStyle.AlignHorz in [ssahRight, ssahDistributed] then
      WritePair(AWriteProc, 'padding-right', IntToStr(AStyle.AlignHorzIndent) + 'px');
  end;

  if UseInlineStyles or (AStyle.AlignVert <> ssavBottom) then
    WritePair(AWriteProc, 'vertical-align', AlignVertMap[AStyle.AlignVert]);
end;

procedure TdxSpreadSheetHTMLWriter.WriteFont(AWriteProc: TWriteProc; AHandle: TdxHashTableItem);
begin
  WriteFont(AWriteProc, TdxSpreadSheetFontHandle(AHandle));
end;

procedure TdxSpreadSheetHTMLWriter.WriteFont(AWriteProc: TWriteProc; AFont: TdxSpreadSheetFontHandle);
const
  VertAlign: array[TdxSpreadSheetFontScript] of string = ('baseline', 'super', 'sub');
var
  ASize: Integer;
begin
  ASize := AFont.Size;
  if AFont.Script <> fsNone then
  begin
    WritePair(AWriteProc, 'vertical-align', VertAlign[AFont.Script]);
    ASize := MulDiv(ASize, 50, 100);
  end;

  if cxColorIsValid(AFont.Color) and (AFont.Color <> FDefaultFontColor) then
    WritePair(AWriteProc, 'color', GetHTMLColor(AFont.Color));
  if AFont.Name <> FDefaultFontName then
    WritePair(AWriteProc, 'font-family', AFont.Name);
  if ASize <> FDefaultFontSize then
    WritePair(AWriteProc, 'font-size', IntToStr(ASize) + 'pt');

  if AFont.Charset <> FDefaultFontCharset then
    WritePair(AWriteProc, 'mso-font-charset', IntToStr(AFont.Charset));
  if fsBold in AFont.Style then
    AWriteProc('font-weight: bold;');
  if fsItalic in AFont.Style then
    AWriteProc('font-style: italic;');
  if fsUnderline in AFont.Style then
    AWriteProc('text-decoration: underline;')
  else
    if fsStrikeOut in AFont.Style then
      AWriteProc('text-decoration: line-through;');
end;

procedure TdxSpreadSheetHTMLWriter.WritePair(AWriteProc: TWriteProc; const AKey, AValue: string);
begin
  AWriteProc(AKey);
  AWriteProc(': ');
  AWriteProc(AValue);
  AWriteProc(';');
end;

procedure TdxSpreadSheetHTMLWriter.WriteText(const S: string);
begin
  WriteText(S, 1, Length(S));
end;

procedure TdxSpreadSheetHTMLWriter.WriteText(const S: string; AIndex, ALength: Integer);
var
  AFinishIndex: Integer;
  AStartIndex: Integer;
  ATrailingSpaceCount: Integer;
begin
  AStartIndex := AIndex;
  AFinishIndex := AIndex + ALength - 1;

  ATrailingSpaceCount := 0;
  while (AStartIndex <= AFinishIndex) and (S[AStartIndex] = ' ') do
  begin
    Inc(ATrailingSpaceCount);
    Inc(AStartIndex);
  end;
  Write('&nbsp;', ATrailingSpaceCount);

  ATrailingSpaceCount := 0;
  while (AStartIndex <= AFinishIndex) and (S[AFinishIndex] = ' ') do
  begin
    Inc(ATrailingSpaceCount);
    Dec(AFinishIndex);
  end;

  while AStartIndex <= AFinishIndex do
  begin
    case S[AStartIndex] of
      '<':
        Write('&lt;');
      '>':
        Write('&gt;');
      '&':
        Write('&amp;');
      '"':
        Write('&quot;');
      #10:
        Write('<br/>');
      #13:
        begin
          Write('<br/>');
          if (AStartIndex + 1 <= AFinishIndex) and (S[AStartIndex + 1] = #10) then
            Inc(AStartIndex);
        end;
    else
      Write(S[AStartIndex]);
    end;
    Inc(AStartIndex);
  end;

  Write('&nbsp;', ATrailingSpaceCount);
end;

function TdxSpreadSheetHTMLWriter.IsInscribedContainer(AContainer: TdxSpreadSheetContainer): Boolean;

  function Check(AItem1, AItem2: TdxSpreadSheetTableItem; AOffset: Integer): Boolean;
  begin
    Result := (AItem1 = AItem2) or (AOffset = 0) and (AItem1.Index + 1 = AItem2.Index);
  end;

begin
  Result := (AContainer.AnchorPoint1.Cell <> nil) and (AContainer.AnchorPoint2.Cell <> nil) and
    Check(AContainer.AnchorPoint1.Cell.Column, AContainer.AnchorPoint2.Cell.Column, AContainer.AnchorPoint2.Offset.X) and
    Check(AContainer.AnchorPoint1.Cell.Row, AContainer.AnchorPoint2.Cell.Row, AContainer.AnchorPoint2.Offset.Y);
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxSpreadSheetHTMFormat.Register;
  TdxSpreadSheetHTMLFormat.Register;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxSpreadSheetHTMLFormat.Unregister;
  TdxSpreadSheetHTMFormat.Unregister;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
