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

unit dxSpreadSheetTextFileFormatCore;

{$I cxVer.Inc}

interface

uses
  Windows, Types, SysUtils, Classes, dxHashUtils, dxGenerics,
  dxSpreadSheetCore, dxSpreadSheetClasses, dxSpreadSheetTypes;

type

  { TdxSpreadSheetCustomTextFormatWriter }

  TdxSpreadSheetCustomTextFormatWriter = class(TdxSpreadSheetCustomWriter)
  strict private
    FBuffer: TBytes;
    FEncoding: TEncoding;
    FSkipHiddenCells: Boolean;

    function Prebuffer(const S: string): Integer; inline;
  protected
    FAlignColumns: Boolean;
    FColumnIndexRemap: TdxIntegersDictionary;
    FReduceMemoryUse: Boolean;
    FTableView: TdxSpreadSheetTableView;
    FTableViewArea: TRect;

    procedure CheckColumnIndexRemap;
    function CreateProgressHelper: TdxSpreadSheetCustomFilerProgressHelper; override;
    function GetActualAreaHeight(const AArea: TRect): Integer;
    function GetActualAreaWidth(const AArea: TRect): Integer;
    function GetActualCellIndex(ACellIndex: Integer; out AActualCellIndex: Integer): Boolean;
    function GetEncoding: TEncoding; virtual;
    //
    procedure Write(const S: string); overload; virtual;
    procedure Write(const S: string; ADupeCount: Integer); overload; virtual;
    procedure WriteLine(const S: string);
    procedure WriteDocumentContent; virtual;
    procedure WriteDocumentFooter; virtual;
    procedure WriteDocumentHeader; virtual;
    procedure WriteEncodingPreamble; virtual;
    procedure WriteTableView; virtual;
    procedure WriteTableViewCell(ARowIndex, AColumnIndex, AAbsoluteRowIndex, AAbsoluteColumnIndex: Integer; ACell: TdxSpreadSheetCell = nil); virtual; abstract;
    procedure WriteTableViewRow(ARowIndex, AAbsoluteRowIndex: Integer; ARow: TdxSpreadSheetTableRow = nil); virtual;
    procedure WriteTableViewRowFooter(ARowIndex, AAbsoluteRowIndex: Integer; ARow: TdxSpreadSheetTableRow = nil); virtual;
    procedure WriteTableViewRowHeader(ARowIndex, AAbsoluteRowIndex: Integer; ARow: TdxSpreadSheetTableRow = nil); virtual;
  public
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure Initialize(AView: TdxSpreadSheetTableView; const AArea: TRect); virtual;
    procedure WriteData; override;
    //
    property AlignColumns: Boolean read FAlignColumns;
    property Encoding: TEncoding read FEncoding;
    property ReduceMemoryUse: Boolean read FReduceMemoryUse;
    property SkipHiddenCells: Boolean read FSkipHiddenCells write FSkipHiddenCells;
    property TableView: TdxSpreadSheetTableView read FTableView;
    property TableViewArea: TRect read FTableViewArea;
  end;

implementation

uses
  Math, dxCore, dxSpreadSheetUtils;

const
  dxThisUnitName = 'dxSpreadSheetTextFileFormatCore';

type
  TdxSpreadSheetAccess = class(TdxCustomSpreadSheet);
  TdxSpreadSheetTableItemsAccess = class(TdxSpreadSheetTableItems);

{ TdxSpreadSheetCustomTextFormatWriter }

destructor TdxSpreadSheetCustomTextFormatWriter.Destroy;
begin
  FreeAndNil(FColumnIndexRemap);
  inherited;
end;

procedure TdxSpreadSheetCustomTextFormatWriter.AfterConstruction;
begin
  inherited;
  Initialize(SpreadSheet.ActiveSheetAsTable, dxSpreadSheetEntireSheetArea);
end;

procedure TdxSpreadSheetCustomTextFormatWriter.Initialize(AView: TdxSpreadSheetTableView; const AArea: TRect);
begin
  FEncoding := GetEncoding;
  FReduceMemoryUse := sssExporting in TdxSpreadSheetAccess(SpreadSheet).State;

  FTableView := AView;
  FTableViewArea := AArea;
  FTableViewArea.Right := Max(Min(FTableViewArea.Right, AView.Dimensions.Right), FTableViewArea.Left);
  FTableViewArea.Bottom := Max(Min(FTableViewArea.Bottom, AView.Dimensions.Bottom), FTableViewArea.Top);
  FreeAndNil(FColumnIndexRemap);
end;

procedure TdxSpreadSheetCustomTextFormatWriter.WriteData;
begin
  CheckColumnIndexRemap;
  WriteEncodingPreamble;
  WriteDocumentHeader;
  WriteDocumentContent;
  WriteDocumentFooter;
end;

procedure TdxSpreadSheetCustomTextFormatWriter.CheckColumnIndexRemap;
var
  AColumn: TdxSpreadSheetTableItem;
  AColumnIndex: Integer;
begin
  if SkipHiddenCells and (FColumnIndexRemap = nil) then
  begin
    FColumnIndexRemap := TdxIntegersDictionary.Create(dxSpreadSheetAreaWidth(TableViewArea));

    AColumnIndex := 0;
    AColumn := TableView.Columns.First;
    while (AColumn <> nil) and (AColumn.Index <  TableViewArea.Left) do
      AColumn := AColumn.Next;
    while (AColumn <> nil) and (AColumn.Index <= TableViewArea.Right) do
    begin
      if AColumn.Visible then
      begin
        FColumnIndexRemap.Add(AColumn.Index, AColumnIndex);
        Inc(AColumnIndex);
      end;
      AColumn := AColumn.Next;
    end;
  end;
end;

function TdxSpreadSheetCustomTextFormatWriter.CreateProgressHelper: TdxSpreadSheetCustomFilerProgressHelper;
begin
  Result := TdxSpreadSheetCustomFilerProgressHelper.Create(Self, 1);
end;

function TdxSpreadSheetCustomTextFormatWriter.GetActualAreaHeight(const AArea: TRect): Integer;
begin
  if SkipHiddenCells then
    Result := TdxSpreadSheetTableItemsAccess(TableView.Rows).GetItemVisibleCount(AArea.Top, AArea.Bottom)
  else
    Result := dxSpreadSheetAreaHeight(AArea);
end;

function TdxSpreadSheetCustomTextFormatWriter.GetActualAreaWidth(const AArea: TRect): Integer;
begin
  if SkipHiddenCells then
    Result := TdxSpreadSheetTableItemsAccess(TableView.Columns).GetItemVisibleCount(AArea.Left, AArea.Right)
  else
    Result := dxSpreadSheetAreaWidth(AArea);
end;

function TdxSpreadSheetCustomTextFormatWriter.GetActualCellIndex(ACellIndex: Integer; out AActualCellIndex: Integer): Boolean;
begin
  if SkipHiddenCells then
    Result := FColumnIndexRemap.TryGetValue(ACellIndex, AActualCellIndex)
  else
  begin
    AActualCellIndex := ACellIndex - TableViewArea.Left;
    Result := True;
  end;
end;

function TdxSpreadSheetCustomTextFormatWriter.GetEncoding: TEncoding;
begin
  Result := TEncoding.Default;
end;

procedure TdxSpreadSheetCustomTextFormatWriter.Write(const S: string);
var
  AByteCount: Integer;
begin
  if S <> '' then
  begin
    AByteCount := Prebuffer(S);
    Stream.Write(FBuffer[0], AByteCount);
  end;
end;

procedure TdxSpreadSheetCustomTextFormatWriter.Write(const S: string; ADupeCount: Integer);
var
  AByteCount: Integer;
begin
  if (ADupeCount > 0) and (S <> '') then
  begin
    AByteCount := Prebuffer(S);
    while ADupeCount > 0 do
    begin
      Stream.Write(FBuffer[0], AByteCount);
      Dec(ADupeCount);
    end;
  end;
end;

procedure TdxSpreadSheetCustomTextFormatWriter.WriteDocumentContent;
begin
  WriteTableView;
end;

procedure TdxSpreadSheetCustomTextFormatWriter.WriteDocumentFooter;
begin
  // do nothing
end;

procedure TdxSpreadSheetCustomTextFormatWriter.WriteDocumentHeader;
begin
  // do nothing
end;

procedure TdxSpreadSheetCustomTextFormatWriter.WriteEncodingPreamble;
var
  B: TBytes;
  L: Integer;
begin
  B := Encoding.GetPreamble;
  L := Length(B);
  if L > 0 then
    Stream.Write(B[0], L);
end;

procedure TdxSpreadSheetCustomTextFormatWriter.WriteLine(const S: string);
begin
  Write(S);
  Write(dxCRLF);
end;

procedure TdxSpreadSheetCustomTextFormatWriter.WriteTableView;
var
  ARow: TdxSpreadSheetTableItem;
  ARowIndex: Integer;
  ARowLocalIndex: Integer;
begin
  ProgressHelper.BeginStage(TableViewArea.Bottom);
  try
    ARowLocalIndex := 0;
    ARowIndex := TableViewArea.Top;
    ARow := TableView.Rows.First;
    while (ARow <> nil) and (ARow.Index < TableViewArea.Top) do
      ARow := ARow.Next;
    while (ARow <> nil) and (ARow.Index <= TableViewArea.Bottom) do
    begin
      while ARowIndex < ARow.Index do
      begin
        WriteTableViewRow(ARowLocalIndex, ARowIndex);
        Inc(ARowLocalIndex);
        Inc(ARowIndex);
      end;
      ProgressHelper.SetTaskNumber(ARow.Index);
      if not SkipHiddenCells or ARow.Visible then
      begin
        WriteTableViewRow(ARowLocalIndex, ARow.Index, TdxSpreadSheetTableRow(ARow));
        Inc(ARowLocalIndex);
      end;
      Inc(ARowIndex);
      ARow := ARow.Next;
    end;
  finally
    ProgressHelper.EndStage;
  end;
end;

procedure TdxSpreadSheetCustomTextFormatWriter.WriteTableViewRow(
  ARowIndex, AAbsoluteRowIndex: Integer; ARow: TdxSpreadSheetTableRow);
var
  ACell: TdxSpreadSheetCell;
  ACellIndex: Integer;
  AColumnIndex: Integer;
begin
  WriteTableViewRowHeader(ARowIndex, AAbsoluteRowIndex, ARow);

  ACellIndex := TableViewArea.Left;
  if ARow <> nil then
  begin
    ACell := ARow.FirstCell;
    while (ACell <> nil) and (ACell.Index < TableViewArea.Left) do
      ACell := ACell.Next;
    while (ACell <> nil) and (ACell.Index <= TableViewArea.Right) do
    begin
      while ACellIndex < ACell.Index do
      begin
        if GetActualCellIndex(ACellIndex, AColumnIndex) then
          WriteTableViewCell(ARowIndex, AColumnIndex, AAbsoluteRowIndex, ACellIndex);
        Inc(ACellIndex);
      end;
      if GetActualCellIndex(ACellIndex, AColumnIndex) then
      begin
        WriteTableViewCell(ARowIndex, AColumnIndex, AAbsoluteRowIndex, ACellIndex, ACell);
        if ReduceMemoryUse then
          ACell.Dormant;
      end;
      ACell := ACell.Next;
      Inc(ACellIndex);
    end;
  end;

  if AlignColumns then
  begin
    while ACellIndex <= TableViewArea.Right do
    begin
      if GetActualCellIndex(ACellIndex, AColumnIndex) then
        WriteTableViewCell(ARowIndex, AColumnIndex, AAbsoluteRowIndex, ACellIndex);
      Inc(ACellIndex);
    end;
  end;

  WriteTableViewRowFooter(ARowIndex, AAbsoluteRowIndex, ARow);
end;

procedure TdxSpreadSheetCustomTextFormatWriter.WriteTableViewRowFooter(
  ARowIndex, AAbsoluteRowIndex: Integer; ARow: TdxSpreadSheetTableRow);
begin
  Write(dxCRLF);
end;

procedure TdxSpreadSheetCustomTextFormatWriter.WriteTableViewRowHeader(
  ARowIndex, AAbsoluteRowIndex: Integer; ARow: TdxSpreadSheetTableRow);
begin
  // do nothing
end;

function TdxSpreadSheetCustomTextFormatWriter.Prebuffer(const S: string): Integer;
begin
  Result := Encoding.GetByteCount(S);
  if Result > Length(FBuffer) then
    SetLength(FBuffer, Result);
  Encoding.GetBytes(S, Low(S), Length(S), FBuffer, 0{$IFDEF DELPHI102TOKYO}, Low(S){$ENDIF});
end;

end.
