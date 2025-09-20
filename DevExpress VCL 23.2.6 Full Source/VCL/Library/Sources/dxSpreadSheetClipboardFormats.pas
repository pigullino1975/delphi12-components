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

unit dxSpreadSheetClipboardFormats;

interface

{$I cxVer.Inc}

uses
  System.UITypes,
  Types, Windows, SysUtils, Classes, Graphics, ClipBrd, Generics.Defaults, Generics.Collections,
  dxXMLDoc, cxVariants, dxCoreClasses, cxClasses, dxGDIPlusClasses,
  dxSpreadSheetCore, dxSpreadSheetTypes, dxSpreadSheetClasses, dxSpreadSheetClipboard, dxSpreadSheetContainers,
  dxSpreadSheetFormatXLSX, dxSpreadSheetFormatXLS, dxSpreadSheetFormatCSV, dxSpreadSheetFormatXMLSS,
  dxSpreadSheetCoreStyles, dxSpreadSheetFormatHTML, dxXMLWriter, dxCore;

type

  { TdxSpreadSheetNativeClipboardFormatData }

  TdxSpreadSheetNativeClipboardFormatData = class(TdxSpreadSheetCustomClipboardData)
  protected
    FDataArea: TRect;

    procedure CopyCells(AView: TdxSpreadSheetTableView); virtual; abstract;
    procedure CopyContainer(AContainer: TdxSpreadSheetContainer); virtual; abstract;
    procedure MergeBordersForInsertedCells(AView: TdxSpreadSheetTableView; const AArea: TRect);
    procedure PasteCore(AView: TdxSpreadSheetTableView;
      const AActualDataArea: TRect; AOptions: TdxSpreadSheetClipboardPasteOptions); virtual; abstract;
    function GetClearCellsOptions(AOptions: TdxSpreadSheetClipboardPasteOptions): TdxSpreadSheetTableViewClearCellsOptions; virtual;
    procedure ValidatePasteOptions(var AOptions: TdxSpreadSheetClipboardPasteOptions);

    property DataArea: TRect read FDataArea;
  public
    constructor Create; virtual;
    procedure Copy(const AArea: TRect; AContainer: TdxSpreadSheetContainer;
      AMode: TdxSpreadSheetClipboardCopyMode; AView: TdxSpreadSheetTableView); virtual;
    procedure Paste(AView: TdxSpreadSheetTableView; const ADestPoint: TPoint;
      AOptions: TdxSpreadSheetClipboardPasteOptions); override;
  end;

  { TdxSpreadSheetNativeClipboardFormat }

  TdxSpreadSheetNativeClipboardFormatClass = class of TdxSpreadSheetNativeClipboardFormat;
  TdxSpreadSheetNativeClipboardFormat = class(TdxSpreadSheetCustomClipboardFormat)
  public
    class function IsPasteOptionsSupported: Boolean; override;
  end;

  { TdxSpreadSheetBinaryClipboardFormatArrayFormulasInfo }

  TdxSpreadSheetBinaryClipboardFormatArrayFormulaInfo = class
  strict private
    FAnchor: TPoint;
    FAreaSize: TSize;
    FColumnIndex: Integer;
    FFormulaStr: string;
    FRowIndex: Integer;

    function GetSize: Integer;
  public
    procedure Initialize(ARowIndex, AColumnIndex: Integer; const AAnchor: TPoint; const AFormulaStr: string; const AAreaSize: TSize);
    procedure ReadData(AReader: TcxReader);
    procedure WriteData(AWriter: TcxWriter);

    property Anchor: TPoint read FAnchor;
    property AreaSize: TSize read FAreaSize;
    property ColumnIndex: Integer read FColumnIndex;
    property FormulaStr: string read FFormulaStr;
    property RowIndex: Integer read FRowIndex;
    property Size: Integer read GetSize;
  end;

  { TdxSpreadSheetBinaryClipboardFormatArrayFormulasInfo }

  TdxSpreadSheetBinaryClipboardFormatArrayFormulasInfo = class(TcxObjectList)
  strict private
    function GetItem(AIndex: TdxListIndex): TdxSpreadSheetBinaryClipboardFormatArrayFormulaInfo;
    function GetSize: Integer;
  public
    procedure ReadData(AReader: TcxReader);
    procedure WriteData(AWriter: TcxWriter);

    property Items[Index: TdxListIndex]: TdxSpreadSheetBinaryClipboardFormatArrayFormulaInfo read GetItem; default;
    property Size: Integer read GetSize;
  end;

  { TdxSpreadSheetBinaryClipboardFormatData }

  TdxSpreadSheetBinaryClipboardFormatData = class(TdxSpreadSheetNativeClipboardFormatData)
  strict private
    FArrayFormulasInfo: TdxSpreadSheetBinaryClipboardFormatArrayFormulasInfo;
    FCells: TMemoryStream;
    FColumnWidths: TMemoryStream;
    FComments: TMemoryStream;
    FContainers: TMemoryStream;
    FHyperLinks: TMemoryStream;
    FMergedCells: TdxRectList;
    FStyles: TMemoryStream;
  protected
    FVersion: Integer;

    procedure CopyCells(AView: TdxSpreadSheetTableView); override;
    procedure CopyContainer(AContainer: TdxSpreadSheetContainer); override;
    procedure PasteCore(AView: TdxSpreadSheetTableView;
      const AActualDataArea: TRect; AOptions: TdxSpreadSheetClipboardPasteOptions); override;
    procedure RestoreArrayFormulas(AView: TdxSpreadSheetTableView;
      const AArea: TRect; AFormulasInfoList: TdxSpreadSheetFormulaAsTextInfoList);
    procedure RestoreCellArea(AView: TdxSpreadSheetTableView;
      const AArea: TRect; AOptions: TdxSpreadSheetClipboardPasteOptions);
    procedure RestoreCells(AView: TdxSpreadSheetTableView; AStyles: TdxSpreadSheetCellStyleHandleList;
      const AArea: TRect; AOptions: TdxSpreadSheetClipboardPasteOptions); virtual;
    procedure RestoreColumnWidths(AView: TdxSpreadSheetTableView; const AArea: TRect);
    procedure RestoreComments(AView: TdxSpreadSheetTableView; const AArea: TRect);
    procedure RestoreContainers(AView: TdxSpreadSheetTableView; const AArea: TRect);
    procedure RestoreHyperlinks(AView: TdxSpreadSheetTableView; const AArea: TRect);
    procedure StoreArrayFormulasInfo(AView: TdxSpreadSheetTableView; AArea: TRect);
    procedure StoreCells(AView: TdxSpreadSheetTableView; AArea: TRect);
    procedure StoreColumnWidths(AView: TdxSpreadSheetTableView; const AArea: TRect);
    procedure StoreComment(AWriter: TcxWriter; AComment: TdxSpreadSheetCommentContainer; const AAnchor: TPoint);
    procedure StoreComments(AView: TdxSpreadSheetTableView; AArea: TRect);
    procedure StoreHyperlinks(AView: TdxSpreadSheetTableView; const AArea: TRect);
  public
    constructor Create; override;
    destructor Destroy; override;
    //
    property ArrayFormulasInfo: TdxSpreadSheetBinaryClipboardFormatArrayFormulasInfo read FArrayFormulasInfo;
    property Cells: TMemoryStream read FCells;
    property ColumnWidths: TMemoryStream read FColumnWidths;
    property Comments: TMemoryStream read FComments;
    property Containers: TMemoryStream read FContainers;
    property HyperLinks: TMemoryStream read FHyperLinks;
    property MergedCells: TdxRectList read FMergedCells;
    property Styles: TMemoryStream read FStyles;
  end;

  { TdxSpreadSheetBinaryClipboardFormat }

  TdxSpreadSheetBinaryClipboardFormatClass = class of TdxSpreadSheetBinaryClipboardFormat;
  TdxSpreadSheetBinaryClipboardFormat = class(TdxSpreadSheetNativeClipboardFormat)
  strict private const
    CHUNK_ARRAY_FORMULAS = $46525241;
    CHUNK_CELLS          = $534C4543;
    CHUNK_COLUMN_WIDTHS  = $574C4F43;
    CHUNK_COMMENTS       = $4D4D4F43;
    CHUNK_CONTAINERS     = $534E4F43;
    CHUNK_INFO           = $4F464E49;
    CHUNK_MERGED_CELLS   = $4C45434D;
    CHUNK_HYPERLINKS     = $4B4E4C48;
  protected
    class procedure LoadChunk(AReader: TcxReader; AChunkID, AChunkSize: Integer; AData: TdxSpreadSheetBinaryClipboardFormatData);
    class procedure SaveChunk(AWriter: TcxWriter; AChunkID: Integer; AData: TdxSpreadSheetBinaryClipboardFormatData);
  public
    class function Build(const AArea: TRect; AContainer: TdxSpreadSheetContainer;
      AMode: TdxSpreadSheetClipboardCopyMode; AView: TdxSpreadSheetTableView): IdxSpreadSheetClipboardData; override;
    class function GetFormatID: Word; override;
    class function LoadFromStream(AStream: TStream): IdxSpreadSheetClipboardData; override;
    class procedure SaveToStream(AStream: TStream; AData: IdxSpreadSheetClipboardData); override;
  end;

  { TdxSpreadSheetHTMLClipboardFormat }

  TdxSpreadSheetHTMLClipboardFormat = class(TdxSpreadSheetCustomClipboardFormat)
  public
    class function Build(const AArea: TRect; AContainer: TdxSpreadSheetContainer;
      AMode: TdxSpreadSheetClipboardCopyMode; AView: TdxSpreadSheetTableView): IdxSpreadSheetClipboardData; override;
    class function CanLoadFromClipboard: Boolean; override;
    class function GetDescription: string; override;
    class function GetFormatID: Word; override;
    class procedure SaveToClipboard(AData: IdxSpreadSheetClipboardData); override;
  end;

  { TdxSpreadSheetHTMLClipboardFormatData }

  TdxSpreadSheetHTMLClipboardFormatData = class(TdxSpreadSheetCustomClipboardData)
  strict private
    FStream: TStream;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Paste(AView: TdxSpreadSheetTableView; const ADestPoint: TPoint; AOptions: TdxSpreadSheetClipboardPasteOptions); override;
    //
    property Stream: TStream read FStream;
  end;

  { TdxSpreadSheetHTMLClipboardFormatWriter }

  TdxSpreadSheetHTMLClipboardFormatWriter = class(TdxSpreadSheetHTMLWriter)
  public
    procedure Initialize(AView: TdxSpreadSheetTableView; const AArea: TRect); override;
  end;

  { TdxSpreadSheetImageClipboardFormat }

  TdxSpreadSheetImageClipboardFormat = class(TdxSpreadSheetCustomClipboardFormat)
  public
    class function Build(const AArea: TRect; AContainer: TdxSpreadSheetContainer;
      AMode: TdxSpreadSheetClipboardCopyMode; AView: TdxSpreadSheetTableView): IdxSpreadSheetClipboardData; override;
    class function CanLoadFromClipboard: Boolean; override;
    class function GetDescription: string; override;
    class function GetFormatID: Word; override;
    class function LoadFromClipboard: IdxSpreadSheetClipboardData; override;
    class procedure SaveToClipboard(AData: IdxSpreadSheetClipboardData); override;
  end;

  { TdxSpreadSheetImageClipboardFormatData }

  TdxSpreadSheetImageClipboardFormatData = class(TdxSpreadSheetCustomClipboardData)
  strict private
    FImage: TdxSmartImage;
  public
    constructor Create; overload;
    constructor Create(ABitmap: TBitmap); overload;
    constructor Create(AStream: TStream); overload;
    destructor Destroy; override;
    procedure Paste(AView: TdxSpreadSheetTableView; const ADestPoint: TPoint; AOptions: TdxSpreadSheetClipboardPasteOptions); override;
    //
    property Image: TdxSmartImage read FImage;
  end;

  { TdxSpreadSheetTextClipboardFormat }

  TdxSpreadSheetTextClipboardFormat = class(TdxSpreadSheetCustomClipboardFormat)
  strict private
    class function LoadFromString(const S: string): IdxSpreadSheetClipboardData; static;
  public
    class function Build(const AArea: TRect; AContainer: TdxSpreadSheetContainer;
      AMode: TdxSpreadSheetClipboardCopyMode; AView: TdxSpreadSheetTableView): IdxSpreadSheetClipboardData; override;
    class function CanLoadFromClipboard: Boolean; override;
    class function GetDescription: string; override;
    class function GetFormatID: Word; override;
    class function LoadFromClipboard: IdxSpreadSheetClipboardData; override;
    class procedure SaveToClipboard(AData: IdxSpreadSheetClipboardData); override;
  end;

  { TdxSpreadSheetTextClipboardFormatData }

  TdxSpreadSheetTextClipboardFormatData = class(TdxSpreadSheetCustomClipboardData)
  strict private
    FText: string;

    procedure SetupSettings(ASettings: TdxSpreadSheetCSVFormatSettings);
  public
    procedure Copy(const AArea: TRect; AView: TdxSpreadSheetTableView);
    procedure Paste(AView: TdxSpreadSheetTableView; const ADestPoint: TPoint; AOptions: TdxSpreadSheetClipboardPasteOptions); override;
    //
    property Text: string read FText write FText;
  end;

  { TdxSpreadSheetTextClipboardFormatDataReader }

  TdxSpreadSheetTextClipboardFormatDataReader = class(TdxSpreadSheetCSVReaderCustomParser)
  strict private
    FArea: TRect;
    FCalculateOnly: Boolean;
  protected
    function CreateFormatSettings: TdxSpreadSheetFormatSettings; override;
    procedure DoRowBegin; override;
    procedure DoValue(const AValue: string; AIsQuotedValue: Boolean); override;
  public
    constructor Create(AView: TdxSpreadSheetTableView; const S: string; const AArea: TRect);
    procedure Parse;
    //
    property Area: TRect read FArea;
    property CalculateOnly: Boolean read FCalculateOnly write FCalculateOnly;
  end;

  { TdxSpreadSheetTextClipboardFormatDataWriter }

  TdxSpreadSheetTextClipboardFormatDataWriter = class(TdxSpreadSheetCSVWriter)
  strict private
    FBuffer: TStringBuilder;
  protected
    procedure Write(const S: string); override;
    procedure Write(const S: string; ADupeCount: Integer); override;
    procedure WriteEncodingPreamble; override;
  public
    constructor Create(AOwner: TdxCustomSpreadSheet; ABuffer: TStringBuilder); reintroduce;
  end;

  { TdxSpreadSheetXMLSSClipboardData }

  TdxSpreadSheetXMLSSClipboardData = class(TdxSpreadSheetNativeClipboardFormatData)
  strict private
    FStream: TMemoryStream;
  protected
    procedure CopyCells(AView: TdxSpreadSheetTableView); override;
    procedure CopyContainer(AContainer: TdxSpreadSheetContainer); override;
    function GetClearCellsOptions(AOptions: TdxSpreadSheetClipboardPasteOptions): TdxSpreadSheetTableViewClearCellsOptions; override;
    procedure PasteCore(AView: TdxSpreadSheetTableView; const AActualDataArea: TRect; AOptions: TdxSpreadSheetClipboardPasteOptions); override;
    //
    property Stream: TMemoryStream read FStream;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadFromStream(AStream: TStream);
  end;

  { TdxSpreadSheetXMLSSClipboardFormat }

  TdxSpreadSheetXMLSSClipboardFormat = class(TdxSpreadSheetNativeClipboardFormat)
  protected
    class function LoadFromStream(AStream: TStream): IdxSpreadSheetClipboardData; override;
  public
    class function Build(const AArea: TRect; AContainer: TdxSpreadSheetContainer;
      AMode: TdxSpreadSheetClipboardCopyMode; AView: TdxSpreadSheetTableView): IdxSpreadSheetClipboardData; override;
    class function GetFormatID: Word; override;
    class function IsPasteOptionsSupported: Boolean; override;
    class procedure SaveToClipboard(AData: IdxSpreadSheetClipboardData); override;
  end;

  { TdxSpreadSheetXMLSSClipboardFormatReader }

  TdxSpreadSheetXMLSSClipboardFormatReader = class(TdxSpreadSheetXMLSSReader);

  { TdxSpreadSheetXMLSSClipboardFormatWriter }

  TdxSpreadSheetXMLSSClipboardFormatWriter = class(TdxSpreadSheetXMLSSWriter)
  strict private
    FArea: TRect;
    FView: TdxSpreadSheetTableView;
  protected
    function CanWriteFormula(AFormula: TdxSpreadSheetFormula): Boolean; override;
    procedure PopulateStyles; override;
    procedure WriteViews(AWriter: TdxXmlWriter); override;
  public
    procedure WriteData(AView: TdxSpreadSheetTableView; const AArea: TRect); reintroduce;
  end;

var
  CFSpreadSheet: Cardinal = 0;

implementation

uses
  cxGeometry, cxGraphics, dxSpreadSheetGraphics, Math, dxSpreadSheetHyperlinks,
  dxSpreadSheetUtils, dxSpreadSheetFormatBinary, StrUtils, dxHashUtils, dxSpreadSheetStrs, dxSmartImage,
  dxSpreadSheetStyles, dxSpreadSheetCoreStrs, dxSpreadSheetCoreFormulas, AnsiStrings, dxStringHelper;

const
  dxThisUnitName = 'dxSpreadSheetClipboardFormats';

type
  TdxCustomSpreadSheetAccess = class(TdxCustomSpreadSheet);
  TdxSpreadSheetCustomFormulaControllerAccess = class(TdxSpreadSheetCustomFormulaController);
  TdxSpreadSheetCellAccess = class(TdxSpreadSheetCell);
  TdxSpreadSheetCellDataFormatAccess = class(TdxSpreadSheetCellDataFormat);
  TdxSpreadSheetCommentContainerAccess = class(TdxSpreadSheetCommentContainer);
  TdxSpreadSheetContainerAccess = class(TdxSpreadSheetContainer);
  TdxSpreadSheetHyperlinkAccess = class(TdxSpreadSheetHyperlink);
  TdxSpreadSheetTableItemsAccess = class(TdxSpreadSheetTableItems);
  TdxSpreadSheetTableViewAccess = class(TdxSpreadSheetTableView);

function CalculateTargetOrigin(AView: TdxSpreadSheetTableView): TPoint;
const
  ContainerOffset = 10;
var
  AFocusedContainer: TdxSpreadSheetContainer;
begin
  AFocusedContainer := TdxSpreadSheetTableViewAccess(AView).Controller.FocusedContainer;
  if AFocusedContainer <> nil then
  begin
    Result := TdxSpreadSheetContainerAccess(AFocusedContainer).Calculator.CalculateBounds.TopLeft;
    Result := cxPointOffset(Result, ContainerOffset, ContainerOffset);
  end
  else
    if (AView.Selection.FocusedColumn > -1) and (AView.Selection.FocusedRow > -1) then
      Result := AView.CreateCell(AView.Selection.FocusedRow, AView.Selection.FocusedColumn).GetAbsoluteBounds.TopLeft
    else
      Result := cxNullPoint;
end;

procedure CheckDataAreaOrigin(AView: TdxSpreadSheetTableView; var ADataArea: TRect; const ADestPoint: TPoint);
var
  AColumn: Integer;
  ARow: Integer;
begin
  AColumn := Max(0, ADestPoint.X);
  ARow := Max(0, ADestPoint.Y);

  if AView.Selection.IsEntireRowSelected(ARow) then
    AColumn := 0;
  if AView.Selection.IsEntireColumnSelected(AColumn) then
    ARow := 0;

  OffsetRect(ADataArea, AColumn, ARow);
end;

{ TdxSpreadSheetNativeClipboardFormatData }

constructor TdxSpreadSheetNativeClipboardFormatData.Create;
begin
  inherited Create;
  FDataArea := cxInvalidRect;
end;

procedure TdxSpreadSheetNativeClipboardFormatData.Copy(const AArea: TRect;
  AContainer: TdxSpreadSheetContainer; AMode: TdxSpreadSheetClipboardCopyMode; AView: TdxSpreadSheetTableView);
begin
  FMode := AMode;
  FViewID := TdxSpreadSheetTableViewAccess(AView).GUID;
  if AContainer <> nil then
  begin
    FDataArea := cxNullRect;
    FOriginalArea := cxInvalidRect;
    CopyContainer(AContainer);
  end
  else
  begin
    FOriginalArea := AArea;
    FDataArea := AArea;
    FDataArea.Right := Min(FDataArea.Right, AView.Dimensions.Right);
    FDataArea.Bottom := Min(FDataArea.Bottom, AView.Dimensions.Bottom);
    CopyCells(AView);
    FDataArea := cxRectSetNullOrigin(FDataArea);
  end;
end;

procedure TdxSpreadSheetNativeClipboardFormatData.Paste(AView: TdxSpreadSheetTableView;
  const ADestPoint: TPoint; AOptions: TdxSpreadSheetClipboardPasteOptions);
var
  AActualDataArea: TRect;
  AActualOriginalArea: TRect;
begin
  AView.BeginUpdate;
  try
    AActualDataArea := DataArea;
    CheckDataAreaOrigin(AView, AActualDataArea, ADestPoint);
    ValidatePasteOptions(AOptions);

    if not cxRectIsEqual(OriginalArea, cxInvalidRect) then
    begin
      AActualOriginalArea := cxRectSetOrigin(OriginalArea, ADestPoint);
      AView.MergedCells.DeleteItemsInArea(AActualOriginalArea);
      if not (cpoSkipBlanks in AOptions) then
        TdxSpreadSheetTableViewAccess(AView).ClearCells(AActualOriginalArea, GetClearCellsOptions(AOptions));
    end;
    PasteCore(AView, AActualDataArea, AOptions);
  finally
    AView.EndUpdate;
  end;
end;

procedure TdxSpreadSheetNativeClipboardFormatData.MergeBordersForInsertedCells(
  AView: TdxSpreadSheetTableView; const AArea: TRect);
const
  ColumnOffset: array[TcxBorder] of Integer = (-1, 0, 1, 0);
  RowOffset: array[TcxBorder] of Integer = (0, -1, 0, 1);
  SideMap: array[TcxBorder] of TcxBorder = (bRight, bBottom, bLeft, bTop);
begin
  AView.ForEachCell(AArea,
    procedure (ACell: TdxSpreadSheetCell)
    var
      ANeighborCell: TdxSpreadSheetCell;
      ASide: TcxBorder;
    begin
      for ASide := Low(ASide) to High(ASide) do
        if ACell.Style.Borders[ASide].Style = sscbsDefault then
        begin
          ANeighborCell := AView.Cells[ACell.RowIndex + RowOffset[ASide], ACell.ColumnIndex + ColumnOffset[ASide]];
          if ANeighborCell <> nil then
            ACell.Style.Borders[ASide].Assign(ANeighborCell.Style.Borders[SideMap[ASide]]);
        end;
    end);
end;

function TdxSpreadSheetNativeClipboardFormatData.GetClearCellsOptions(
  AOptions: TdxSpreadSheetClipboardPasteOptions): TdxSpreadSheetTableViewClearCellsOptions;
begin
  Result := [];
  if cpoComments in AOptions then
    Include(Result, ccoComments);
  if cpoStyles in AOptions then
    Include(Result, ccoStyles);
  if [cpoValues, cpoFormulas] * AOptions <> [] then
  begin
    Include(Result, ccoValues);
    if cpoStyles in AOptions then
      Include(Result, ccoHyperlinks);
  end;
end;

procedure TdxSpreadSheetNativeClipboardFormatData.ValidatePasteOptions(var AOptions: TdxSpreadSheetClipboardPasteOptions);
begin
  if cpoFormulas in AOptions then
    Include(AOptions, cpoValues);
  if cpoStyles in AOptions then
    Include(AOptions, cpoNumberFormatting);
end;

{ TdxSpreadSheetNativeClipboardFormat }

class function TdxSpreadSheetNativeClipboardFormat.IsPasteOptionsSupported: Boolean;
begin
  Result := True;
end;

{ TdxSpreadSheetBinaryClipboardFormatArrayFormulaInfo }

procedure TdxSpreadSheetBinaryClipboardFormatArrayFormulaInfo.Initialize(ARowIndex, AColumnIndex: Integer;
  const AAnchor: TPoint; const AFormulaStr: string; const AAreaSize: TSize);
begin
  FRowIndex := ARowIndex;
  FColumnIndex := AColumnIndex;
  FAnchor := AAnchor;
  FFormulaStr := AFormulaStr;
  FAreaSize := AAreaSize;
end;

function TdxSpreadSheetBinaryClipboardFormatArrayFormulaInfo.GetSize: Integer;
begin
  Result := SizeOf(FColumnIndex) + SizeOf(FRowIndex) + SizeOf(FAnchor) +
    SizeOf(Integer) + Length(FFormulaStr) * 2 + SizeOf(FAreaSize);
end;

procedure TdxSpreadSheetBinaryClipboardFormatArrayFormulaInfo.ReadData(AReader: TcxReader);
var
  L: Integer;
begin
  FRowIndex := AReader.ReadInteger;
  FColumnIndex := AReader.ReadInteger;
  AReader.Stream.ReadBuffer(FAnchor, SizeOf(FAnchor));
  L := AReader.ReadInteger;
  SetLength(FFormulaStr, L);
  AReader.Stream.ReadBuffer(Pointer(FFormulaStr)^, L * 2);
  AReader.Stream.ReadBuffer(FAreaSize, SizeOf(FAreaSize));
end;

procedure TdxSpreadSheetBinaryClipboardFormatArrayFormulaInfo.WriteData(AWriter: TcxWriter);
var
  L: Integer;
begin
  L := Length(FFormulaStr);
  AWriter.WriteInteger(FRowIndex);
  AWriter.WriteInteger(FColumnIndex);
  AWriter.Stream.WriteBuffer(FAnchor, SizeOf(FAnchor));
  AWriter.WriteInteger(L);
  AWriter.Stream.WriteBuffer(Pointer(FFormulaStr)^, L * 2);
  AWriter.Stream.WriteBuffer(FAreaSize, SizeOf(FAreaSize));
end;

{ TdxSpreadSheetBinaryClipboardFormatArrayFormulasInfo }

function TdxSpreadSheetBinaryClipboardFormatArrayFormulasInfo.GetItem(AIndex: TdxListIndex): TdxSpreadSheetBinaryClipboardFormatArrayFormulaInfo;
begin
  Result := TdxSpreadSheetBinaryClipboardFormatArrayFormulaInfo(inherited Items[AIndex]);
end;

function TdxSpreadSheetBinaryClipboardFormatArrayFormulasInfo.GetSize: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    Inc(Result, Items[I].Size);
  if Result > 0 then
    Inc(Result, SizeOf(Integer));  
end;

procedure TdxSpreadSheetBinaryClipboardFormatArrayFormulasInfo.ReadData(AReader: TcxReader);
var
  AInfo: TdxSpreadSheetBinaryClipboardFormatArrayFormulaInfo;
  ASize: Integer;
  I: Integer;
begin
  ASize := AReader.ReadInteger;
  if ASize > 0 then
    for I := 0 to AReader.ReadInteger - 1 do
    begin
      AInfo := TdxSpreadSheetBinaryClipboardFormatArrayFormulaInfo.Create;
      AInfo.ReadData(AReader);
      Add(AInfo);
    end;
end;

procedure TdxSpreadSheetBinaryClipboardFormatArrayFormulasInfo.WriteData(AWriter: TcxWriter);
var
  ASize: Integer;
  I: Integer;
begin
  ASize := Size;
  AWriter.WriteInteger(ASize);
  if ASize > 0 then
  begin
    AWriter.WriteInteger(Count);
    for I := 0 to Count - 1 do
      Items[I].WriteData(AWriter);
  end;
end;

{ TdxSpreadSheetBinaryClipboardFormatData }

constructor TdxSpreadSheetBinaryClipboardFormatData.Create;
begin
  inherited Create;
  FCells := TMemoryStream.Create;
  FContainers := TMemoryStream.Create;
  FComments := TMemoryStream.Create;
  FColumnWidths := TMemoryStream.Create;
  FMergedCells := TdxRectList.Create;
  FHyperLinks := TMemoryStream.Create;
  FArrayFormulasInfo := TdxSpreadSheetBinaryClipboardFormatArrayFormulasInfo.Create;
  FVersion := dxSpreadSheetBinaryFormatVersion;
  FStyles := TMemoryStream.Create;
end;

destructor TdxSpreadSheetBinaryClipboardFormatData.Destroy;
begin
  FreeAndNil(FStyles);
  FreeAndNil(FMergedCells);
  FreeAndNil(FCells);
  FreeAndNil(FColumnWidths);
  FreeAndNil(FHyperLinks);
  FreeAndNil(FArrayFormulasInfo);
  FreeAndNil(FContainers);
  FreeAndNil(FComments);
  inherited Destroy;
end;

procedure TdxSpreadSheetBinaryClipboardFormatData.CopyCells(AView: TdxSpreadSheetTableView);
var
  I: Integer;
begin
  StoreColumnWidths(AView, DataArea);
  StoreCells(AView, DataArea);
  StoreComments(AView, DataArea);
  StoreHyperlinks(AView, DataArea);
  for I := 0 to MergedCells.Count - 1 do
    MergedCells[I] := cxRectOffset(MergedCells[I], DataArea.TopLeft, False);
end;

procedure TdxSpreadSheetBinaryClipboardFormatData.CopyContainer(AContainer: TdxSpreadSheetContainer);
var
  AWriter: TcxWriter;
begin
  if AContainer is TdxSpreadSheetCommentContainer then
  begin
    AWriter := TcxWriter.Create(Comments, FVersion);
    try
      StoreComment(AWriter, TdxSpreadSheetCommentContainer(AContainer), cxPoint(
        TdxSpreadSheetCommentContainer(AContainer).Cell.ColumnIndex,
        TdxSpreadSheetCommentContainer(AContainer).Cell.RowIndex));
    finally
      AWriter.Free;
    end;
  end
  else
  begin
    AWriter := TcxWriter.Create(Containers, FVersion);
    try
      AWriter.WriteAnsiString(dxStringToAnsiString(TdxSpreadSheetContainerAccess(AContainer).ClassName));
      TdxSpreadSheetContainerAccess(AContainer).SaveToStream(AWriter);
      AWriter.WriteRect(TdxSpreadSheetContainerAccess(AContainer).Calculator.CalculateBounds);
    finally
      AWriter.Free;
    end;
  end;
end;

procedure TdxSpreadSheetBinaryClipboardFormatData.PasteCore(AView: TdxSpreadSheetTableView;
  const AActualDataArea: TRect; AOptions: TdxSpreadSheetClipboardPasteOptions);
begin
  Cells.Position := 0;
  Comments.Position := 0;
  Containers.Position := 0;
  ColumnWidths.Position := 0;
  HyperLinks.Position := 0;
  Styles.Position := 0;

  RestoreCellArea(AView, AActualDataArea, AOptions);
  if (Containers.Size > 0) and AView.OptionsProtection.ActualAllowEditContainers then
    RestoreContainers(AView, AActualDataArea);
end;

procedure TdxSpreadSheetBinaryClipboardFormatData.RestoreArrayFormulas(
  AView: TdxSpreadSheetTableView; const AArea: TRect; AFormulasInfoList: TdxSpreadSheetFormulaAsTextInfoList);
var
  ACell: TPoint;
  AInfo: TdxSpreadSheetBinaryClipboardFormatArrayFormulaInfo;
  I: Integer;
begin
  for I := 0 to ArrayFormulasInfo.Count - 1 do
  begin
    AInfo := ArrayFormulasInfo.Items[I];
    ACell.X := AArea.Left + AInfo.ColumnIndex;
    ACell.Y := AArea.Top + AInfo.RowIndex;
    AFormulasInfoList.Add(AView.Cells[ACell.Y, ACell.X], AInfo.Anchor,
      AInfo.FormulaStr, True, False, dxSpreadSheetArea(ACell, AInfo.AreaSize));
  end;
end;

procedure TdxSpreadSheetBinaryClipboardFormatData.RestoreCellArea(
  AView: TdxSpreadSheetTableView; const AArea: TRect; AOptions: TdxSpreadSheetClipboardPasteOptions);
var
  AStyles: TdxSpreadSheetCellStyleHandleList;
  AStylesReader: TcxReader;
  I: Integer;
begin
  TdxSpreadSheetTableViewAccess(AView).CheckProtection(cmmClear, AArea);

  if [cpoValues, cpoNumberFormatting, cpoStyles] * AOptions <> [] then
  begin
    AStyles := TdxSpreadSheetCellStyleHandleList.Create;
    try
      AStylesReader := TcxReader.Create(Styles, FVersion);
      try
        while Styles.Position < Styles.Size do
          AStyles.Add(AView.SpreadSheet.CellStyles.CreateStyleFromStream(AStylesReader));
      finally
        AStylesReader.Free;
      end;
      if Cells.Size > 0 then
        RestoreCells(AView, AStyles, AArea, AOptions);
    finally
      AStyles.Free;
    end;
  end;

  if cpoValues in AOptions then
    RestoreHyperlinks(AView, AArea);
  if cpoColumnWidths in AOptions then
    RestoreColumnWidths(AView, AArea);
  if cpoComments in AOptions then
    RestoreComments(AView, AArea);

  if cpoStyles in AOptions then
  begin
    for I := 0 to MergedCells.Count - 1 do
      AView.MergedCells.Add(cxRectOffset(MergedCells[I], AArea.TopLeft));
  end;
end;

procedure TdxSpreadSheetBinaryClipboardFormatData.RestoreCells(
  AView: TdxSpreadSheetTableView; AStyles: TdxSpreadSheetCellStyleHandleList;
  const AArea: TRect; AOptions: TdxSpreadSheetClipboardPasteOptions);
var
  ACell: TdxSpreadSheetCellAccess;
  ACellSize: Cardinal;
  ACellsReader: TcxReader;
  ACellStyle: TdxSpreadSheetCellStyleHandle;
  AColumn: Integer;
  AFormulas: TdxSpreadSheetFormulaAsTextInfoList;
  ARow: Integer;
begin
  AFormulas := TdxSpreadSheetFormulaAsTextInfoList.Create(AView.SpreadSheet);
  try
    ACellsReader := TcxReader.Create(Cells, FVersion);
    try
      while Cells.Position < Cells.Size do
      begin
        ARow := ACellsReader.ReadInteger + AArea.Top;
        AColumn := ACellsReader.ReadInteger + AArea.Left;
        ACellStyle := AStyles[ACellsReader.ReadInteger];
        ACellSize := ACellsReader.ReadCardinal;
        ACell := nil;

        if cpoSkipBlanks in AOptions then
        begin
          if ACellsReader.ReadByte = Byte(Ord(cdtBlank)) then
          begin
            ACellsReader.Stream.Seek(ACellSize - 1, soCurrent);
            Continue;
          end;
          ACellsReader.Stream.Seek(-1, soCurrent);
        end;

        if [cpoStyles, cpoNumberFormatting] * AOptions <> [] then
        begin
          if ACell = nil then
            ACell := TdxSpreadSheetCellAccess(AView.CreateCell(ARow, AColumn));
          if cpoStyles in AOptions then
            ACell.StyleHandle := ACellStyle
          else
            TdxSpreadSheetCellDataFormatAccess(ACell.Style.DataFormat).Handle := ACellStyle.DataFormat;
        end;

        if cpoValues in AOptions then
        begin
          if ACell = nil then
            ACell := TdxSpreadSheetCellAccess(AView.CreateCell(ARow, AColumn));
          ACell.LoadFromStream(ACellsReader, AFormulas);
          if AView.Options.Protected then
            ACell.Style.Locked := False;
        end
        else
          ACellsReader.Stream.Seek(ACellSize, soCurrent);
      end;
    finally
      ACellsReader.Free;
    end;

    if cpoFormulas in AOptions then
    begin
      RestoreArrayFormulas(AView, AArea, AFormulas);
      AFormulas.ResolveReferences;
    end
    else
      AFormulas.ResolveValues;

    if cpoStyles in AOptions then
      MergeBordersForInsertedCells(AView, AArea);
  finally
    AFormulas.Free;
  end;
end;

procedure TdxSpreadSheetBinaryClipboardFormatData.RestoreColumnWidths(AView: TdxSpreadSheetTableView; const AArea: TRect);
var
  AIndex: Integer;
  ASize: Integer;
begin
  AIndex := AArea.Left;
  while ColumnWidths.Position < ColumnWidths.Size do
  begin
    ASize := ReadIntegerFunc(ColumnWidths);
    if TdxSpreadSheetTableItemsAccess(AView.Columns).GetItemSize(AIndex) <> ASize then
      AView.Columns.CreateItem(AIndex).Size := ASize;
    Inc(AIndex);
  end;
end;

procedure TdxSpreadSheetBinaryClipboardFormatData.RestoreComments(AView: TdxSpreadSheetTableView; const AArea: TRect);
var
  ABounds: TRect;
  AComment: TdxSpreadSheetCommentContainerAccess;
  ACommentReader: TcxReader;
begin
  ACommentReader := TcxReader.Create(Comments, FVersion);
  try
    while Comments.Position < Comments.Size do
    begin
      AView.Containers.FindCommentContainer(TdxSpreadSheetCellHelper.ReadRef(ACommentReader, AView, AArea.Top, AArea.Left)).Free;

      AView.Containers.Add(TdxSpreadSheetCommentContainer, AComment);
      try
        AComment.BeginChanging;
        try
          AComment.AnchorType := TdxSpreadSheetContainerAnchorType(ACommentReader.ReadWord);
          AComment.LoadFromStream(ACommentReader, ACommentReader.ReadWord, AArea.Top, AArea.Left);
          if AComment.Cell <> nil then
          begin
            ABounds := AComment.Calculator.CalculateBounds;
            ABounds := cxRectSetSize(TdxSpreadSheetCommentContainer.GetDefaultPosition(AComment.Cell), cxSize(ABounds));
            AComment.Calculator.UpdateAnchors(ABounds);
          end
        finally
          AComment.EndChanging;
        end;
        if AComment.Cell = nil then
          AComment.Free;
      except
        AComment.Free;
        raise;
      end;
    end;
  finally
    ACommentReader.Free;
  end;
end;

procedure TdxSpreadSheetBinaryClipboardFormatData.RestoreContainers(AView: TdxSpreadSheetTableView; const AArea: TRect);
var
  AClass: TClass;
  AContainer: TdxSpreadSheetContainerAccess;
  AContainersReader: TcxReader;
begin
  AContainersReader := TcxReader.Create(Containers, FVersion);
  try
    AClass := GetClass(dxAnsiStringToString(AContainersReader.ReadAnsiString));
    if (AClass <> nil) and AClass.InheritsFrom(TdxSpreadSheetContainer) then
    begin
      AContainer := TdxSpreadSheetContainerAccess(AView.Containers.Add(TdxSpreadSheetContainerClass(AClass)));
      AContainer.BeginChanging;
      try
        AContainer.LoadFromStream(AContainersReader);
        AContainer.Calculator.UpdateAnchors(cxRectSetOrigin(AContainersReader.ReadRect, CalculateTargetOrigin(AView)));
        AContainer.Focused := True;
      finally
        AContainer.EndChanging;
      end;
    end;
  finally
    AContainersReader.Free;
  end;
end;

procedure TdxSpreadSheetBinaryClipboardFormatData.RestoreHyperlinks(AView: TdxSpreadSheetTableView; const AArea: TRect);
var
  AHyperlink: TdxSpreadSheetHyperlinkAccess;
  AHyperlinkReader: TcxReader;
  ARow, AColumn: Integer;
begin
  AHyperlinkReader := TcxReader.Create(HyperLinks, FVersion);
  try
    while HyperLinks.Position < HyperLinks.Size do
    begin
      ARow := AHyperlinkReader.ReadInteger + AArea.Top;
      AColumn := AHyperlinkReader.ReadInteger + AArea.Left;
      AHyperlink := TdxSpreadSheetHyperlinkAccess(AView.Hyperlinks.Add(cxInvalidRect));
      AHyperlink.LoadFromStream(AHyperlinkReader);
      AHyperlink.ReplaceArea(Rect(AColumn, ARow, AColumn, ARow));
    end;
  finally
    AHyperlinkReader.Free;
  end;
end;

procedure TdxSpreadSheetBinaryClipboardFormatData.StoreArrayFormulasInfo(AView: TdxSpreadSheetTableView; AArea: TRect);
begin
  TdxSpreadSheetTableViewAccess(AView).FormulaController.EnumArrayFormulas(AView,
    function (AFormula: TdxSpreadSheetCustomFormula): Boolean
    var
      AInfo: TdxSpreadSheetBinaryClipboardFormatArrayFormulaInfo;
      ARect: TRect;
    begin
      if dxSpreadSheetIntersects(AArea, AFormula.ArrayFormulaArea, ARect) then
      begin
        AInfo := TdxSpreadSheetBinaryClipboardFormatArrayFormulaInfo.Create;
        AInfo.Initialize(ARect.Top - AArea.Top, ARect.Left - AArea.Left,
          AFormula.ArrayFormulaArea.TopLeft, AFormula.AsText, dxSpreadSheetAreaSize(ARect));
        ArrayFormulasInfo.Add(AInfo);
      end;
      Result := True;
    end);
end;

procedure TdxSpreadSheetBinaryClipboardFormatData.StoreCells(AView: TdxSpreadSheetTableView; AArea: TRect);
var
  ACellsWriter: TcxWriter;
  AStyles: TList;
  AStylesWriter: TcxWriter;
begin
  AView.MergedCells.EnumCells(AArea,
    procedure (ACell: TdxSpreadSheetMergedCell)
    var
      R: TRect;
    begin
      if dxSpreadSheetIntersects(AArea, ACell.Area, R) and cxRectIsEqual(R, ACell.Area) then
      begin
        if FMergedCells.IndexOf(ACell.Area) < 0 then
          FMergedCells.Add(ACell.Area);
      end;
    end);

  StoreArrayFormulasInfo(AView, AArea);

  AStyles := TList.Create;
  ACellsWriter := TcxWriter.Create(Cells, FVersion);
  AStylesWriter := TcxWriter.Create(Styles, FVersion);
  try
    AView.ForEachCell(AArea,
      procedure(AItem: TdxSpreadSheetCell)
      var
        ACell: TdxSpreadSheetCellAccess;
        ACellPosition: Int64;
        AStyleIndex: Integer;
      begin
        ACell := TdxSpreadSheetCellAccess(AItem);
        ACellsWriter.WriteInteger(ACell.RowIndex - AArea.Top);
        ACellsWriter.WriteInteger(ACell.ColumnIndex - AArea.Left);
        AStyleIndex := AStyles.IndexOf(ACell.StyleHandle);
        if AStyleIndex < 0 then
        begin
          AStyleIndex := AStyles.Add(ACell.StyleHandle);
          ACell.StyleHandle.SaveToStream(AStylesWriter);
        end;
        ACellsWriter.WriteInteger(AStyleIndex);
        ACellsWriter.BeginChunk(ACellPosition);
        try
          ACell.SaveToStream(ACellsWriter);
        finally
          ACellsWriter.EndChunk(ACellPosition);
        end;
      end);
  finally
    AStylesWriter.Free;
    ACellsWriter.Free;
    AStyles.Free;
  end;
end;

procedure TdxSpreadSheetBinaryClipboardFormatData.StoreColumnWidths(AView: TdxSpreadSheetTableView; const AArea: TRect);
var
  I: Integer;
begin
  for I := AArea.Left to AArea.Right do
    WriteIntegerProc(ColumnWidths, TdxSpreadSheetTableItemsAccess(AView.Columns).GetItemSize(I));
end;

procedure TdxSpreadSheetBinaryClipboardFormatData.StoreComment(
  AWriter: TcxWriter; AComment: TdxSpreadSheetCommentContainer; const AAnchor: TPoint);
begin
  TdxSpreadSheetCellHelper.WriteRef(AWriter, AComment.Cell, AAnchor.Y, AAnchor.X);
  TdxSpreadSheetCommentContainerAccess(AComment).SaveToStream(AWriter, AAnchor.Y, AAnchor.X);
end;

procedure TdxSpreadSheetBinaryClipboardFormatData.StoreComments(AView: TdxSpreadSheetTableView; AArea: TRect);
var
  ACommentsWriter: TcxWriter;
begin
  ACommentsWriter := TcxWriter.Create(Comments, FVersion);
  try
    AView.Containers.EnumCommentContainers(AArea,
      function (AContainer: TdxSpreadSheetContainer): Boolean
      begin
        StoreComment(ACommentsWriter, TdxSpreadSheetCommentContainer(AContainer), AArea.TopLeft);
        Result := True;
      end);
  finally
    ACommentsWriter.Free;
  end;
end;

procedure TdxSpreadSheetBinaryClipboardFormatData.StoreHyperlinks(AView: TdxSpreadSheetTableView; const AArea: TRect);
var
  AColumn: Integer;
  AHyperlink: TdxSpreadSheetHyperlinkAccess;
  AHyperlinksWriter: TcxWriter;
  ARow: Integer;
begin
  AHyperlinksWriter := TcxWriter.Create(HyperLinks, FVersion);
  try
    for ARow := AArea.Top to AArea.Bottom do
      for AColumn := AArea.Left to AArea.Right do
      begin
        AHyperlink := TdxSpreadSheetHyperlinkAccess(AView.Hyperlinks.FindItem(ARow, AColumn));
        if AHyperlink <> nil then
        begin
          AHyperlinksWriter.WriteInteger(ARow - AArea.Top);
          AHyperlinksWriter.WriteInteger(AColumn - AArea.Left);
          AHyperlink.SaveToStream(AHyperlinksWriter);
        end;
      end;
  finally
    AHyperlinksWriter.Free;
  end;
end;

{ TdxSpreadSheetBinaryClipboardFormat }

class function TdxSpreadSheetBinaryClipboardFormat.Build(const AArea: TRect; AContainer: TdxSpreadSheetContainer;
  AMode: TdxSpreadSheetClipboardCopyMode; AView: TdxSpreadSheetTableView): IdxSpreadSheetClipboardData;
var
  AData: TdxSpreadSheetBinaryClipboardFormatData;
begin
  AData := TdxSpreadSheetBinaryClipboardFormatData.Create;
  AData.Copy(AArea, AContainer, AMode, AView);
  Result := AData;
end;

class function TdxSpreadSheetBinaryClipboardFormat.GetFormatID: Word;
begin
  Result := CFSpreadSheet;
end;

class function TdxSpreadSheetBinaryClipboardFormat.LoadFromStream(AStream: TStream): IdxSpreadSheetClipboardData;
var
  AChunkID: Cardinal;
  AChunkSize: Cardinal;
  APosition: Int64;
  ARawData: TdxSpreadSheetBinaryClipboardFormatData;
  AReader: TcxReader;
begin
  AReader := TcxReader.Create(AStream);
  try
    ARawData := TdxSpreadSheetBinaryClipboardFormatData.Create;
    while AStream.Position < AStream.Size do
    begin
      AChunkID := AReader.ReadCardinal;
      AChunkSize := AReader.ReadCardinal;
      APosition := AReader.Stream.Position;
      LoadChunk(AReader, AChunkID, AChunkSize, ARawData);
      AReader.Stream.Position := APosition + AChunkSize;
    end;
    Result := ARawData;
  finally
    AReader.Free;
  end;
end;

class procedure TdxSpreadSheetBinaryClipboardFormat.SaveToStream(AStream: TStream; AData: IdxSpreadSheetClipboardData);
const
  Chunks: array[0..7] of Cardinal = (
    CHUNK_INFO, CHUNK_CELLS, CHUNK_MERGED_CELLS, CHUNK_COLUMN_WIDTHS,
    CHUNK_ARRAY_FORMULAS, CHUNK_CONTAINERS, CHUNK_COMMENTS, CHUNK_HYPERLINKS
  );
var
  AChunkID: Cardinal;
  AMarker: Int64;
  ARawData: TdxSpreadSheetBinaryClipboardFormatData;
  AWriter: TcxWriter;
  I: Integer;
begin
  AWriter := TcxWriter.Create(AStream);
  try
    ARawData := AData as TdxSpreadSheetBinaryClipboardFormatData;
    for I := 0 to Length(Chunks) - 1 do
    begin
      AChunkID := Chunks[I];
      AWriter.WriteCardinal(AChunkID);
      AWriter.BeginChunk(AMarker);
      try
        SaveChunk(AWriter, AChunkID, ARawData);
      finally
        AWriter.EndChunk(AMarker);
      end;
    end;
  finally
    AWriter.Free;
  end;
end;

class procedure TdxSpreadSheetBinaryClipboardFormat.LoadChunk(AReader: TcxReader;
  AChunkID, AChunkSize: Integer; AData: TdxSpreadSheetBinaryClipboardFormatData);
var
  I: Integer;
begin
  case AChunkID of
    CHUNK_HYPERLINKS:
      AReader.ReadMemoryStream(AData.Hyperlinks);

    CHUNK_ARRAY_FORMULAS:
      AData.ArrayFormulasInfo.ReadData(AReader);

    CHUNK_CONTAINERS:
      AReader.ReadMemoryStream(AData.Containers);

    CHUNK_COLUMN_WIDTHS:
      AReader.ReadMemoryStream(AData.ColumnWidths);

    CHUNK_COMMENTS:
      AReader.ReadMemoryStream(AData.Comments);

    CHUNK_MERGED_CELLS:
      for I := 0 to AReader.ReadInteger - 1 do
        AData.MergedCells.Add(AReader.ReadRect);

    CHUNK_CELLS:
      begin
        AData.FOriginalArea := AReader.ReadRect;
        AData.FDataArea := AReader.ReadRect;
        AReader.ReadMemoryStream(AData.Styles);
        AReader.ReadMemoryStream(AData.Cells);
        if AReader.Version >= 8 then
          AReader.ReadMemoryStream(AData.ColumnWidths);
      end;

    CHUNK_INFO:
      begin
        AData.FVersion := AReader.ReadInteger;
        AData.FMode := TdxSpreadSheetClipboardCopyMode(AReader.ReadByte);
        AData.FViewID := AReader.ReadWideString;
      end;
  end;
end;

class procedure TdxSpreadSheetBinaryClipboardFormat.SaveChunk(
  AWriter: TcxWriter; AChunkID: Integer; AData: TdxSpreadSheetBinaryClipboardFormatData);
var
  I: Integer;
begin
  case AChunkID of
    CHUNK_HYPERLINKS:
      AWriter.WriteMemoryStream(AData.Hyperlinks);

    CHUNK_ARRAY_FORMULAS:
      AData.ArrayFormulasInfo.WriteData(AWriter);

    CHUNK_CONTAINERS:
      AWriter.WriteMemoryStream(AData.Containers);

    CHUNK_COMMENTS:
      AWriter.WriteMemoryStream(AData.Comments);

    CHUNK_COLUMN_WIDTHS:
      AWriter.WriteMemoryStream(AData.ColumnWidths);

    CHUNK_MERGED_CELLS:
      begin
        AWriter.WriteInteger(AData.MergedCells.Count);
        for I := 0 to AData.MergedCells.Count - 1 do
          AWriter.WriteRect(AData.MergedCells[I]);
      end;

    CHUNK_CELLS:
      begin
        AWriter.WriteRect(AData.OriginalArea);
        AWriter.WriteRect(AData.DataArea);
        AWriter.WriteMemoryStream(AData.Styles);
        AWriter.WriteMemoryStream(AData.Cells);
      end;

    CHUNK_INFO:
      begin
        AWriter.WriteInteger(AData.FVersion);
        AWriter.WriteByte(Ord(AData.FMode));
        AWriter.WriteWideString(AData.FViewID);
      end;
  end;
end;

{ TdxSpreadSheetHTMLClipboardFormat }

class function TdxSpreadSheetHTMLClipboardFormat.Build(const AArea: TRect; AContainer: TdxSpreadSheetContainer;
  AMode: TdxSpreadSheetClipboardCopyMode; AView: TdxSpreadSheetTableView): IdxSpreadSheetClipboardData;
var
  AData: TdxSpreadSheetHTMLClipboardFormatData;
begin
  Result := nil;
  if AContainer = nil then
  begin
    AData := TdxSpreadSheetHTMLClipboardFormatData.Create;
    with TdxSpreadSheetHTMLClipboardFormatWriter.Create(AView.SpreadSheet, AData.Stream) do
    try
      Initialize(AView, AArea);
      WriteData;
    finally
      Free;
    end;
    Result := AData;
  end;
end;

class function TdxSpreadSheetHTMLClipboardFormat.CanLoadFromClipboard: Boolean;
begin
  Result := False;
end;

class function TdxSpreadSheetHTMLClipboardFormat.GetDescription: string;
begin
  Result := cxGetResourceString(@sdxClipboardFormatHTML);
end;

class function TdxSpreadSheetHTMLClipboardFormat.GetFormatID: Word;
begin
  Result := RegisterClipboardFormat('HTML Format');
end;

class procedure TdxSpreadSheetHTMLClipboardFormat.SaveToClipboard(AData: IdxSpreadSheetClipboardData);
const
  OffsetTemplate = '0000000000';
  HeaderTemplate: AnsiString =
    'Version:0.9' + #13#10 +
    'StartHTML:%0:s' + #13#10 +
    'EndHTML:%1:s' + #13#10 +
    'StartFragment:%0:s' + #13#10 +
    'EndFragment:%1:s' + #13#10#13#10;

  function BuildHeader(const AValue1, AValue2: AnsiString): AnsiString; overload;
  begin
    Result := AnsiStrings.Format(HeaderTemplate, [AValue1, AValue2]);
  end;

  function BuildHeader(AStream: TStream): AnsiString; overload;
  var
    AOffset: Integer;
  begin
    AOffset := Length(BuildHeader(OffsetTemplate, OffsetTemplate));
    Result := BuildHeader(
      AnsiString(FormatFloat(OffsetTemplate, AOffset)),
      AnsiString(FormatFloat(OffsetTemplate, AOffset + AStream.Size)));
  end;

var
  AInternalData: TdxSpreadSheetHTMLClipboardFormatData;
begin
  AInternalData := AData as TdxSpreadSheetHTMLClipboardFormatData;
  AInternalData.Stream.Position := 0;
  PutToClipboard(AInternalData.Stream, BuildHeader(AInternalData.Stream));
end;

{ TdxSpreadSheetHTMLClipboardFormatData }

constructor TdxSpreadSheetHTMLClipboardFormatData.Create;
begin
  FStream := TMemoryStream.Create;
end;

destructor TdxSpreadSheetHTMLClipboardFormatData.Destroy;
begin
  FreeAndNil(FStream);
  inherited;
end;

procedure TdxSpreadSheetHTMLClipboardFormatData.Paste(
  AView: TdxSpreadSheetTableView; const ADestPoint: TPoint; AOptions: TdxSpreadSheetClipboardPasteOptions);
begin
  raise EdxSpreadSheetError.Create('not supported');
end;

{ TdxSpreadSheetHTMLClipboardFormatWriter }

procedure TdxSpreadSheetHTMLClipboardFormatWriter.Initialize(AView: TdxSpreadSheetTableView; const AArea: TRect);
begin
  inherited;
  SkipHiddenCells := True;
  UseInlineStyles := True;
end;

{ TdxSpreadSheetImageClipboardFormat }

class function TdxSpreadSheetImageClipboardFormat.Build(const AArea: TRect; AContainer: TdxSpreadSheetContainer;
  AMode: TdxSpreadSheetClipboardCopyMode; AView: TdxSpreadSheetTableView): IdxSpreadSheetClipboardData;
var
  ABitmap: TcxBitmap32;
  ABounds: TRect;
  AViewInfo: TdxSpreadSheetContainerViewInfo;
begin
  Result := nil;
  if (AContainer <> nil) and not (AContainer is TdxSpreadSheetCommentContainer) then
  begin
    if TdxSpreadSheetTableViewAccess(AView).ViewInfo.Containers.Find(AContainer, AViewInfo) then
    begin
      ABounds := AViewInfo.RealDrawingBounds;
      ABitmap := TcxBitmap32.CreateSize(ABounds, True);
      try
        ABitmap.cxCanvas.WindowOrg := ABounds.TopLeft;
        AViewInfo.Draw(ABitmap.cxCanvas, dsFirst);
        Result := TdxSpreadSheetImageClipboardFormatData.Create(ABitmap);
      finally
        ABitmap.Free;
      end;
    end;
  end;
end;

class function TdxSpreadSheetImageClipboardFormat.CanLoadFromClipboard: Boolean;
begin
  Result := TdxSmartImage.HasClipboardFormat;
end;

class function TdxSpreadSheetImageClipboardFormat.GetDescription: string;
begin
  Result := cxGetResourceString(@sdxClipboardFormatImage);
end;

class function TdxSpreadSheetImageClipboardFormat.GetFormatID: Word;
begin
  Result := ImageClipboardFormats[dxImagePng];
end;

class function TdxSpreadSheetImageClipboardFormat.LoadFromClipboard: IdxSpreadSheetClipboardData;
var
  AData: TdxSpreadSheetImageClipboardFormatData;
begin
  if CanLoadFromClipboard then
  begin
    AData := TdxSpreadSheetImageClipboardFormatData.Create;
    AData.Image.PasteFromClipboard;
    Result := AData;
  end
  else
    Result := nil;
end;

class procedure TdxSpreadSheetImageClipboardFormat.SaveToClipboard(AData: IdxSpreadSheetClipboardData);
var
  AFormat: Word;
  APalette: HPALETTE;
  AStream: THandle;
begin
  TdxSpreadSheetImageClipboardFormatData(AData).Image.SaveToClipboardFormat(AFormat, AStream, APalette);
  Clipboard.SetAsHandle(AFormat, AStream);
end;

{ TdxSpreadSheetImageClipboardFormatData }

constructor TdxSpreadSheetImageClipboardFormatData.Create;
begin
  inherited Create;
  FImage := TdxSmartImage.Create;
end;

constructor TdxSpreadSheetImageClipboardFormatData.Create(ABitmap: TBitmap);
begin
  inherited Create;
  FImage := TdxSmartImage.CreateFromBitmap(ABitmap);
end;

constructor TdxSpreadSheetImageClipboardFormatData.Create(AStream: TStream);
begin
  Create;
  Image.LoadFromStream(AStream);
end;

destructor TdxSpreadSheetImageClipboardFormatData.Destroy;
begin
  FreeAndNil(FImage);
  inherited Destroy;
end;

procedure TdxSpreadSheetImageClipboardFormatData.Paste(AView: TdxSpreadSheetTableView;
  const ADestPoint: TPoint; AOptions: TdxSpreadSheetClipboardPasteOptions);
var
  AContainer: TdxSpreadSheetPictureContainer;
begin
  if not Image.Empty and AView.OptionsProtection.ActualAllowEditContainers then
  begin
    AView.Containers.Add(TdxSpreadSheetPictureContainer, AContainer);
    AContainer.BeginChanging;
    try
      AContainer.Picture.Image := Image;
      AContainer.AnchorType := catTwoCell;
      AContainer.AnchorPoint2.FixedToCell := False;
      TdxSpreadSheetContainerAccess(AContainer).Calculator.UpdateAnchors(
        cxRectBounds(CalculateTargetOrigin(AView), AContainer.Picture.Image.Width, AContainer.Picture.Image.Height));
      AContainer.Focused := True;
    finally
      AContainer.EndChanging;
    end;
  end;
end;

{ TdxSpreadSheetTextClipboardFormat }

class function TdxSpreadSheetTextClipboardFormat.Build(const AArea: TRect; AContainer: TdxSpreadSheetContainer;
  AMode: TdxSpreadSheetClipboardCopyMode; AView: TdxSpreadSheetTableView): IdxSpreadSheetClipboardData;
var
  AData: TdxSpreadSheetTextClipboardFormatData;
begin
  if AContainer = nil then
  begin
    AData := TdxSpreadSheetTextClipboardFormatData.Create;
    AData.Copy(AArea, AView);
    Result := AData;
  end
  else
    Result := nil;
end;

class function TdxSpreadSheetTextClipboardFormat.CanLoadFromClipboard: Boolean;
begin
  Result := inherited CanLoadFromClipboard or Clipboard.HasFormat(CF_TEXT);
end;

class function TdxSpreadSheetTextClipboardFormat.GetDescription: string;
begin
  Result := cxGetResourceString(@sdxClipboardFormatText);
end;

class function TdxSpreadSheetTextClipboardFormat.GetFormatID: Word;
begin
  Result := CF_UNICODETEXT;
end;

class function TdxSpreadSheetTextClipboardFormat.LoadFromClipboard: IdxSpreadSheetClipboardData;
var
  AData: HGLOBAL;
begin
  Result := nil;
  if Clipboard.HasFormat(CF_UNICODETEXT) then
    Result := LoadFromString(Clipboard.AsText)
  else
    if Clipboard.HasFormat(CF_TEXT) then
    begin
      AData := GetClipboardData(CF_TEXT);
      if AData <> 0 then
      try
        Result := LoadFromString(dxAnsiStringToString(PAnsiChar(GlobalLock(AData))));
      finally
        GlobalUnlock(AData);
      end;
    end;
end;

class function TdxSpreadSheetTextClipboardFormat.LoadFromString(const S: string): IdxSpreadSheetClipboardData;
var
  AData: TdxSpreadSheetTextClipboardFormatData;
begin
  AData := TdxSpreadSheetTextClipboardFormatData.Create;
  AData.Text := S;
  Result := AData;
end;

class procedure TdxSpreadSheetTextClipboardFormat.SaveToClipboard(AData: IdxSpreadSheetClipboardData);
var
  S: string;
begin
  S := TdxSpreadSheetTextClipboardFormatData(AData).Text;
  if S <> '' then
    Clipboard.AsText := S;
end;

{ TdxSpreadSheetTextClipboardFormatData }

procedure TdxSpreadSheetTextClipboardFormatData.Copy(const AArea: TRect; AView: TdxSpreadSheetTableView);
var
  ABuffer: TStringBuilder;
  AWriter: TdxSpreadSheetTextClipboardFormatDataWriter;
begin
  ABuffer := TStringBuilder.Create;
  try
    AWriter := TdxSpreadSheetTextClipboardFormatDataWriter.Create(AView.SpreadSheet, ABuffer);
    try
      SetupSettings(AWriter.Settings);
      AWriter.Initialize(AView, AArea);
      AWriter.WriteData;
    finally
      AWriter.Free;
    end;
    Text := Trim(ABuffer);
  finally
    ABuffer.Free;
  end;
end;

procedure TdxSpreadSheetTextClipboardFormatData.Paste(AView: TdxSpreadSheetTableView;
  const ADestPoint: TPoint; AOptions: TdxSpreadSheetClipboardPasteOptions);

  procedure ParseCore(var AArea: TRect; ACalculateOnly: Boolean);
  var
    AReader: TdxSpreadSheetTextClipboardFormatDataReader;
  begin
    AReader := TdxSpreadSheetTextClipboardFormatDataReader.Create(AView, Text, AArea);
    try
      SetupSettings(AReader.Settings);
      AReader.CalculateOnly := ACalculateOnly;
      AReader.Parse;
      AArea := AReader.Area;
    finally
      AReader.Free;
    end;
  end;

var
  AArea: TRect;
begin
  AArea := cxNullRect;
  CheckDataAreaOrigin(AView, AArea, ADestPoint);
  if AView.Options.Protected then
  begin
    ParseCore(AArea, True);
    TdxSpreadSheetTableViewAccess(AView).CheckProtection(cmmClear, AArea);
  end;
  ParseCore(AArea, False);
end;

procedure TdxSpreadSheetTextClipboardFormatData.SetupSettings(ASettings: TdxSpreadSheetCSVFormatSettings);
begin
  ASettings.Encoding := TEncoding.Unicode;
  ASettings.Export.QuoteStringValues := False;
  ASettings.Export.UseDisplayValues := True;
  ASettings.Quote := '"';
  ASettings.ValueSeparator := dxTAB;
end;

{ TdxSpreadSheetTextClipboardFormatDataReader }

constructor TdxSpreadSheetTextClipboardFormatDataReader.Create(
  AView: TdxSpreadSheetTableView; const S: string; const AArea: TRect);
begin
  inherited Create(AView, PChar(S), Length(S));
  FArea := AArea;
  FRowIndex := Area.Top - 1;
  KeepSourceNumberFormat := True;
end;

function TdxSpreadSheetTextClipboardFormatDataReader.CreateFormatSettings: TdxSpreadSheetFormatSettings;
begin
  Result := TdxSpreadSheetFormatSettings.Create;
end;

procedure TdxSpreadSheetTextClipboardFormatDataReader.DoRowBegin;
begin
  inherited;
  FColumnIndex := Area.Left - 1;
end;

procedure TdxSpreadSheetTextClipboardFormatDataReader.DoValue(const AValue: string; AIsQuotedValue: Boolean);
begin
  if CalculateOnly then
    Inc(FColumnIndex)
  else
    inherited;
end;

procedure TdxSpreadSheetTextClipboardFormatDataReader.Parse;
begin
  inherited Parse;
  FArea.Right := Max(Area.Right, FColumnIndex);
  FArea.Bottom := Max(Area.Bottom, FRowIndex);
end;

{ TdxSpreadSheetTextClipboardFormatDataWriter }

constructor TdxSpreadSheetTextClipboardFormatDataWriter.Create(AOwner: TdxCustomSpreadSheet; ABuffer: TStringBuilder);
begin
  FBuffer := ABuffer;
  inherited Create(AOwner, nil);
  SkipHiddenCells := True;
end;

procedure TdxSpreadSheetTextClipboardFormatDataWriter.Write(const S: string);
begin
  FBuffer.Append(S);
end;

procedure TdxSpreadSheetTextClipboardFormatDataWriter.Write(const S: string; ADupeCount: Integer);
begin
  while ADupeCount > 0 do
  begin
    FBuffer.Append(S);
    Dec(ADupeCount);
  end;
end;

procedure TdxSpreadSheetTextClipboardFormatDataWriter.WriteEncodingPreamble;
begin
  // do nothing
end;

{ TdxSpreadSheetXMLSSClipboardData }

constructor TdxSpreadSheetXMLSSClipboardData.Create;
begin
  inherited;
  FStream := TMemoryStream.Create;
end;

destructor TdxSpreadSheetXMLSSClipboardData.Destroy;
begin
  FreeAndNil(FStream);
  inherited Destroy;
end;

procedure TdxSpreadSheetXMLSSClipboardData.LoadFromStream(AStream: TStream);
var
  AScan: PByte;
  ASize: Int64;
begin
  ASize := AStream.Size;
  if (ASize > 0) and (AStream is TCustomMemoryStream) then
  begin
    AScan := TCustomMemoryStream(AStream).Memory;
    Inc(AScan, ASize - 1);
    while (AScan^ = 0) and (ASize > 0) do
    begin
      Dec(ASize);
      Dec(AScan);
    end;
  end;

  Stream.Size := 0;
  Stream.CopyFrom(AStream, ASize);
  Stream.Position := 0;
  FDataArea := TdxSpreadSheetXMLSSClipboardFormatReader.GetDataArea(Stream);
  Stream.Position := 0;
  FOriginalArea := DataArea;
end;

procedure TdxSpreadSheetXMLSSClipboardData.CopyCells(AView: TdxSpreadSheetTableView);
begin
  Stream.Size := 0;
  with TdxSpreadSheetXMLSSClipboardFormatWriter.Create(AView.SpreadSheet, Stream) do
  try
    WriteData(AView, DataArea);
  finally
    Free;
  end;
end;

procedure TdxSpreadSheetXMLSSClipboardData.CopyContainer(AContainer: TdxSpreadSheetContainer);
begin
  raise EdxSpreadSheetError.Create(cxGetResourceString(@sdxErrorInternal));
end;

function TdxSpreadSheetXMLSSClipboardData.GetClearCellsOptions(
  AOptions: TdxSpreadSheetClipboardPasteOptions): TdxSpreadSheetTableViewClearCellsOptions;
begin
  Result := inherited GetClearCellsOptions(AOptions) - [ccoStyles];
end;

procedure TdxSpreadSheetXMLSSClipboardData.PasteCore(AView: TdxSpreadSheetTableView;
  const AActualDataArea: TRect; AOptions: TdxSpreadSheetClipboardPasteOptions);
var
  AReader: TdxSpreadSheetXMLSSClipboardFormatReader;
  ASettings: TdxSpreadSheetXMLSSReaderSettings;
begin
  AReader := TdxSpreadSheetXMLSSClipboardFormatReader.Create(AView.SpreadSheet, Stream);
  try
    ASettings.Options := AOptions;
    ASettings.TargetAnchor := cxPoint(Max(AActualDataArea.Left, 0), Max(AActualDataArea.Top, 0));
    ASettings.TargetView := AView;
    AReader.Settings := ASettings;
    AReader.ReadData;
  finally
    AReader.Free;
  end;
  if cpoStyles in AOptions then
    MergeBordersForInsertedCells(AView, DataArea);
end;

{ TdxSpreadSheetXMLSSClipboardFormat }

class function TdxSpreadSheetXMLSSClipboardFormat.Build(const AArea: TRect; AContainer: TdxSpreadSheetContainer;
  AMode: TdxSpreadSheetClipboardCopyMode; AView: TdxSpreadSheetTableView): IdxSpreadSheetClipboardData;
var
  AData: TdxSpreadSheetXMLSSClipboardData;
begin
  if AContainer = nil then
  begin
    AData := TdxSpreadSheetXMLSSClipboardData.Create;
    AData.Copy(AArea, AContainer, AMode, AView);
    Result := AData;
  end
  else
    Result := nil;
end;

class function TdxSpreadSheetXMLSSClipboardFormat.GetFormatID: Word;
begin
  Result := RegisterClipboardFormat('XML Spreadsheet');
end;

class function TdxSpreadSheetXMLSSClipboardFormat.IsPasteOptionsSupported: Boolean;
begin
  Result := True;
end;

class procedure TdxSpreadSheetXMLSSClipboardFormat.SaveToClipboard(AData: IdxSpreadSheetClipboardData);
var
  AInternalData: TdxSpreadSheetXMLSSClipboardData;
begin
  AInternalData := AData as TdxSpreadSheetXMLSSClipboardData;
  if AInternalData.Stream <> nil then
    PutToClipboard(AInternalData.Stream);
end;

class function TdxSpreadSheetXMLSSClipboardFormat.LoadFromStream(AStream: TStream): IdxSpreadSheetClipboardData;
var
  AData: TdxSpreadSheetXMLSSClipboardData;
begin
  AData := TdxSpreadSheetXMLSSClipboardData.Create;
  AData.LoadFromStream(AStream);
  Result := AData;
end;

{ TdxSpreadSheetXMLSSClipboardFormatWriter }

procedure TdxSpreadSheetXMLSSClipboardFormatWriter.PopulateStyles;
begin
  PopulateStyles(FView, FArea);
end;

procedure TdxSpreadSheetXMLSSClipboardFormatWriter.WriteData(AView: TdxSpreadSheetTableView; const AArea: TRect);
begin
  FView := AView;
  FArea := AArea;
  FArea.Right := Max(Min(FArea.Right, AView.Dimensions.Right), FArea.Left);
  FArea.Bottom := Max(Min(FArea.Bottom, AView.Dimensions.Bottom), FArea.Top);
  inherited WriteData;
end;

function TdxSpreadSheetXMLSSClipboardFormatWriter.CanWriteFormula(AFormula: TdxSpreadSheetFormula): Boolean;
var
  AResult: Boolean;
begin
  AResult := True;
  AFormula.EnumReferences(
    procedure (const AArea: TRect; AView: TObject)
    var
      R: TRect;
    begin
      AResult := AResult and ((AView = nil) or (AView = FView)) and dxSpreadSheetIntersects(AArea, FArea, R) and cxRectIsEqual(R, AArea);
    end, True);
  Result := AResult;
end;

procedure TdxSpreadSheetXMLSSClipboardFormatWriter.WriteViews(AWriter: TdxXmlWriter);
begin
  WriteView(AWriter, FView, FArea);
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  CFSpreadsheet := RegisterClipboardFormat('DXSpreadSheet');
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.

