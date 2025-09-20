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

unit dxSpreadSheetFormatTXT;

{$I cxVer.Inc}

interface

uses
  Types, SysUtils, Classes, dxHashUtils,
  dxSpreadSheetCore, dxSpreadSheetClasses, dxSpreadSheetUtils, dxSpreadSheetTextFileFormatCore;

type

  { TdxSpreadSheetTXTFormat }

  TdxSpreadSheetTXTFormat = class(TdxSpreadSheetCustomFormat)
  public
    class function CanReadFromStream(AStream: TStream): Boolean; override;
    class function GetDescription: string; override;
    class function GetExt: string; override;
    class function GetReader: TdxSpreadSheetCustomReaderClass; override;
    class function GetWriter: TdxSpreadSheetCustomWriterClass; override;
  end;

  { TdxSpreadSheetTXTFormatSettings }

  TdxSpreadSheetTXTFormatSettings = record
    Encoding: TEncoding;
    BeginString: string;
    EndString: string;
    Separator: string;
  end;

  { TdxSpreadSheetTXTWriter }

  TdxSpreadSheetTXTWriter = class(TdxSpreadSheetCustomTextFormatWriter)
  strict private
    FAlignCells: Boolean;
    FColumnWidths: array of Integer;
    FSettings: TdxSpreadSheetTXTFormatSettings;

    procedure CalculateColumnWidths;
  protected
    function GetEncoding: TEncoding; override;
    procedure WriteTableView; override;
    procedure WriteTableViewCell(ARowIndex, AColumnIndex, AAbsoluteRowIndex, AAbsoluteColumnIndex: Integer; ACell: TdxSpreadSheetCell); override;
  public
    constructor Create(AOwner: TdxCustomSpreadSheet; AStream: TStream); override;
    procedure Initialize(AView: TdxSpreadSheetTableView; const AArea: TRect); override;
    //
    property Settings: TdxSpreadSheetTXTFormatSettings read FSettings;
  end;

var
  dxSpreadSheetTXTFormatSettings: TdxSpreadSheetTXTFormatSettings;

implementation

uses
  Math, StrUtils, dxCore;

const
  dxThisUnitName = 'dxSpreadSheetFormatTXT';

{ TdxSpreadSheetTXTFormat }

class function TdxSpreadSheetTXTFormat.CanReadFromStream(AStream: TStream): Boolean;
begin
  Result := False;
end;

class function TdxSpreadSheetTXTFormat.GetDescription: string;
begin
  Result := 'Text Document';
end;

class function TdxSpreadSheetTXTFormat.GetExt: string;
begin
  Result := '.txt';
end;

class function TdxSpreadSheetTXTFormat.GetReader: TdxSpreadSheetCustomReaderClass;
begin
  Result := nil;
end;

class function TdxSpreadSheetTXTFormat.GetWriter: TdxSpreadSheetCustomWriterClass;
begin
  Result := TdxSpreadSheetTXTWriter;
end;

{ TdxSpreadSheetTXTWriter }

constructor TdxSpreadSheetTXTWriter.Create(AOwner: TdxCustomSpreadSheet; AStream: TStream);
begin
  inherited;
  FSettings := dxSpreadSheetTXTFormatSettings;
end;

function TdxSpreadSheetTXTWriter.GetEncoding: TEncoding;
begin
  Result := Settings.Encoding;
  if Result = nil then
    Result := TEncoding.Unicode;
end;

procedure TdxSpreadSheetTXTWriter.Initialize(AView: TdxSpreadSheetTableView; const AArea: TRect);
begin
  inherited;
  FAlignCells := Settings.Separator = '';
  FAlignColumns := True;
end;

procedure TdxSpreadSheetTXTWriter.WriteTableView;
begin
  if FAlignCells then
    CalculateColumnWidths;
  inherited;
end;

procedure TdxSpreadSheetTXTWriter.WriteTableViewCell(
  ARowIndex, AColumnIndex, AAbsoluteRowIndex, AAbsoluteColumnIndex: Integer; ACell: TdxSpreadSheetCell);

  function GetCellDataLength(ACell: TdxSpreadSheetCell): Integer;
  begin
    if ACell <> nil then
      Result := Length(ACell.DisplayText)
    else
      Result := 0;
  end;

begin
  if Settings.BeginString <> '' then
    Write(Settings.BeginString);
  if ACell <> nil then
    Write(ACell.DisplayText);
  if Settings.EndString <> '' then
    Write(Settings.EndString);
  if AAbsoluteColumnIndex < TableViewArea.Right then
    Write(Settings.Separator);
  if FAlignCells then
    Write(' ', 2 + FColumnWidths[AColumnIndex] - GetCellDataLength(ACell));
end;

procedure TdxSpreadSheetTXTWriter.CalculateColumnWidths;
var
  ACell: TdxSpreadSheetCell;
  ACellIndex: Integer;
  ACellWidth: Integer;
  AMergedCell: TdxSpreadSheetMergedCell;
  ARow: TdxSpreadSheetTableItem;
  I: Integer;
begin
  SetLength(FColumnWidths, GetActualAreaWidth(TableViewArea) + 1);

  ARow := TableView.Rows.First;
  while (ARow <> nil) and (ARow.Index < TableViewArea.Top) do
    ARow := ARow.Next;
  while (ARow <> nil) and (ARow.Index <= TableViewArea.Bottom) do
  begin
    if not SkipHiddenCells or ARow.Visible then
    begin
      ACell := TdxSpreadSheetTableRow(ARow).FirstCell;
      while (ACell <> nil) and (ACell.Index < TableViewArea.Left) do
        ACell := ACell.Next;
      while (ACell <> nil) and (ACell.Index <= TableViewArea.Right) do
      begin
        if GetActualCellIndex(ACell.Index, ACellIndex) then
        begin
          AMergedCell := TableView.MergedCells.FindCell(ACell.RowIndex, ACell.ColumnIndex);
          if AMergedCell <> nil then
          begin
            if AMergedCell.ActiveCell = ACell then
            begin
              ACellWidth := Length(ACell.DisplayText) div GetActualAreaWidth(AMergedCell.Area);
              for I := AMergedCell.Area.Left to AMergedCell.Area.Right do
              begin
                if GetActualCellIndex(I, ACellIndex) then
                  FColumnWidths[ACellIndex] := Max(FColumnWidths[ACellIndex], ACellWidth);
              end;
            end;
          end
          else
            FColumnWidths[ACellIndex] := Max(FColumnWidths[ACellIndex], Length(ACell.DisplayText));

          if ReduceMemoryUse then
            ACell.Dormant;
        end;
        ACell := ACell.Next;
      end;
    end;
    ARow := ARow.Next;
  end;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxSpreadSheetTXTFormat.Register;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxSpreadSheetTXTFormat.Unregister;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
