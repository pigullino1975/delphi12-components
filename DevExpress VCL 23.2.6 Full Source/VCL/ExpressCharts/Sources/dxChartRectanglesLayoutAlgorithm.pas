{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressCharts                                            }
{                                                                    }
{           Copyright (c) 2020-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCHARTS AND ALL ACCOMPANYING    }
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

unit dxChartRectanglesLayoutAlgorithm;

{$I cxVer.inc}
{$SCOPEDENUMS ON}

interface

uses
  Windows, Types, Classes, Contnrs, Generics.Collections, Generics.Defaults, cxGeometry, dxCore;

type

  { TdxChartRectanglesCustomLayout }

  TdxChartRectanglesCustomLayout = class // for internal use
  public
    procedure AddOccupiedRectangle(const ARect: TRect); virtual; abstract;
    function ArrangeRectangle(const ARect: TRect; AOverlappingIndent: Integer;
      const AValidRect, ATempExcludedRect: TRect): TRect; virtual; abstract;
    function IsEmptyRegion(const ARect: TRect): Boolean; overload; virtual; abstract;
    function IsEmptyRegion(const ARect, AValidRect: TRect): Boolean; overload; virtual; abstract;
    function IsEmptyRegionByList(const ARect: TRect): Boolean; virtual; abstract;
  end;

  { TdxChartRectanglesLayoutAlgorithm }

  TdxChartRectanglesLayoutAlgorithm = class // for internal use
  strict private
    FLayouts: array[Boolean] of TdxChartRectanglesCustomLayout;
    FOverlappingIndent: Integer;
  public
    constructor Create(ABounds: TRect; AOverlappingIndent: Integer); overload;
    constructor Create(AOverlappingIndent: Integer); overload;
    destructor Destroy; override;
    procedure AddExcludedRectangle(const ARect: TRect);
    procedure AddOccupiedRectangle(const ARect: TRect);
    function ArrangeRectangle(const ARect, AValidRect: TRect; AUseExcludedRegions: Boolean): TRect; overload;
    function ArrangeRectangle(const ARect, AValidRect, ATempExcludedRect: TRect; AUseExcludedRegions: Boolean): TRect; overload;
    function IsEmptyRegion(const ARect: TRect; AUseExlcludedRegions: Boolean): Boolean;
    function IsEmptyRegionByList(const ARect: TRect; AUseExlcludedRegions: Boolean): Boolean;
  end;


implementation

uses
  SysUtils, Math, dxTypeHelpers;

const
  dxThisUnitName = 'dxChartRectanglesLayoutAlgorithm';

type
  TdxChartRectanglesLayout = class;

  { TdxChartRectanglesLayoutCell }

  TdxChartRectanglesLayoutCell = class
  strict private
    FBounds: TRect;
    FInfillCount: Integer;
  public
    constructor Create(const ABounds: TRect; AInfillCount: Integer = 0);
    procedure Clear;
    procedure Infill;
    function IsEmpty: Boolean;
    //
    property Bounds: TRect read FBounds;
    property InfillCount: Integer read FInfillCount;
  end;

  { TdxChartRectanglesLayoutRow }

  TdxChartRectanglesLayoutRow = class(TObjectList)
  strict private
    FBounds: TRect;

    function GetItem(Index: TdxListIndex): TdxChartRectanglesLayoutCell; inline;
    procedure SetItem(Index: TdxListIndex; const Value: TdxChartRectanglesLayoutCell);
  public
    constructor Create(const ABounds: TRect; AAddCell: Boolean = False);
    function FindCell(X: Integer; out AColumnIndex: Integer): TdxChartRectanglesLayoutCell;
    procedure SeparateByVertical(ASeparator: Integer; AColumnIndex: Integer);

    property Bounds: TRect read FBounds;
    property Items[Index: TdxListIndex]: TdxChartRectanglesLayoutCell read GetItem write SetItem; default;
  end;

  { TdxChartRectanglesLayoutRows }

  TdxChartRectanglesLayoutRows = class(TObjectList)
  strict private
    FBounds: TRect;

    function GetColumnCount: Integer;
    function GetItem(Index: TdxListIndex): TdxChartRectanglesLayoutRow; inline;
  public type
    TEnumCellProc = reference to procedure (ACell: TdxChartRectanglesLayoutCell);
  public
    constructor Create(const ABounds: TRect);
    procedure AddRectangle(const ARect: TRect);
    procedure DeleteRectangle(const ARect: TRect);
    procedure EnumIntersectedCells(const ARect: TRect; AEnumProc: TEnumCellProc);
    function FindCell(X, Y: Integer; out ARowIndex, AColumnIndex: Integer): TdxChartRectanglesLayoutCell;
    function FindNearCell(const P: TPoint; out ARowIndex, AColumnIndex: Integer): TdxChartRectanglesLayoutCell; overload;
    function FindNearCell(X, Y: Integer; out ARowIndex, AColumnIndex: Integer): TdxChartRectanglesLayoutCell; overload;
    function FindRow(Y: Integer; out ARowIndex: Integer): TdxChartRectanglesLayoutRow;
    function GetCell(ARowIndex, AColumnIndex: Integer): TdxChartRectanglesLayoutCell; inline;
    function IsEmptyRegion(const ARect: TRect): Boolean;
    procedure SeparateByHorizontal(ASeparator: Integer);
    procedure SeparateByVertical(ASeparator: Integer);

    property Bounds: TRect read FBounds;
    property ColumnCount: Integer read GetColumnCount;
    property Items[Index: TdxListIndex]: TdxChartRectanglesLayoutRow read GetItem; default;
  end;

  { TdxChartRectanglesLayoutTestPosition }

  TdxChartRectanglesLayoutTestPosition = class
  public
    Check: Boolean;
    Distance: Double;
    Position: TPoint;

    constructor Create(const APosition: TPoint; ADistance: Double);
  end;

  { TdxChartRectanglesLayoutStep }

  TdxChartRectanglesLayoutStep = class
  strict private
    FAllocationRect: TRect;
    FCenterX: Double;
    FCenterY: Double;
    FLayout: TdxChartRectanglesLayout;
    FMaxDistance: Double;
    FPosition: Integer;
    FPrimaryTestPositions: TList;
    FRadiusX: Double;
    FRadiusY: Double;
    FTestPositions: TObjectList;
  protected
    FIsEnd: Boolean;

    procedure AddPrimaryTestPosition(const P: TPoint);
    procedure AddSecondaryTestPosition(const P: TPoint);
    function CalculateDistance(const P: TPoint): Double;
    function GetIncrement: Integer; virtual; abstract;
    function GetPosition(ARowIndex, AColumnIndex: Integer): Integer; virtual; abstract;
    function IsEndPosition(APosition: Integer): Boolean; virtual; abstract;
    function IsUpdateEnd(ADistance: Double): Boolean;
    procedure UpdatePrimaryTestPositions; virtual; abstract;
    procedure UpdateSecondaryTestPositions; virtual; abstract;
  public
    constructor Create(ALayout: TdxChartRectanglesLayout);
    destructor Destroy; override;
    procedure Initialize(ARowIndex, AColumnIndex: Integer; const AAllocationRect: TRect); virtual;
    function IsTestingEnd: Boolean;
    procedure Next;
    procedure Update;

    property AllocationRect: TRect read FAllocationRect;
    property IsEnd: Boolean read FIsEnd;
    property Layout: TdxChartRectanglesLayout read FLayout;
    property Position: Integer read FPosition;
    property TestPositions: TObjectList read FTestPositions;
  end;

  { TdxChartRectanglesLayoutHorizontalStep }

  TdxChartRectanglesLayoutHorizontalStep = class(TdxChartRectanglesLayoutStep)
  strict private
    FStartRowIndex: Integer;
  protected
    procedure CalculateFarPositions(ACell: TdxChartRectanglesLayoutCell; out APoint1, APoint2: TPoint); virtual; abstract;
    function CalculateNearPosition(ACell: TdxChartRectanglesLayoutCell): TPoint; virtual; abstract;
    function GetPosition(ARowIndex, AColumnIndex: Integer): Integer; override;
    function IsEndPosition(APosition: Integer): Boolean; override;
    procedure UpdatePrimaryTestPositions; override;
    procedure UpdateSecondaryTestPositions; override;
  public
    procedure Initialize(ARowIndex, AColumnIndex: Integer; const ARect: TRect); override;

    property StartRowIndex: Integer read FStartRowIndex;
  end;

  { TdxChartRectanglesLayoutVerticalStep }

  TdxChartRectanglesLayoutVerticalStep = class(TdxChartRectanglesLayoutStep)
  strict private
    FStartColumnIndex: Integer;
  protected
    procedure CalculateFarPositions(ACell: TdxChartRectanglesLayoutCell; out APoint1, APoint2: TPoint); virtual; abstract;
    function CalculateNearPosition(ACell: TdxChartRectanglesLayoutCell): TPoint; virtual; abstract;
    function GetPosition(ARowIndex, AColumnIndex: Integer): Integer; override;
    function IsEndPosition(APosition: Integer): Boolean; override;
    procedure UpdatePrimaryTestPositions; override;
    procedure UpdateSecondaryTestPositions; override;
  public
    procedure Initialize(ARowIndex, AColumnIndex: Integer; const ARect: TRect); override;

    property StartColumnIndex: Integer read FStartColumnIndex;
  end;

  { TdxChartRectanglesLayoutStepToLeft }

  TdxChartRectanglesLayoutStepToLeft = class(TdxChartRectanglesLayoutHorizontalStep)
  protected
    procedure CalculateFarPositions(ACell: TdxChartRectanglesLayoutCell; out APoint1, APoint2: TPoint); override;
    function CalculateNearPosition(ACell: TdxChartRectanglesLayoutCell): TPoint; override;
    function GetIncrement: Integer; override;
    function IsEndPosition(APosition: Integer): Boolean; override;
  end;

  { TdxChartRectanglesLayoutStepToRight }

  TdxChartRectanglesLayoutStepToRight = class(TdxChartRectanglesLayoutHorizontalStep)
  protected
    procedure CalculateFarPositions(ACell: TdxChartRectanglesLayoutCell; out APoint1, APoint2: TPoint); override;
    function CalculateNearPosition(ACell: TdxChartRectanglesLayoutCell): TPoint; override;
    function GetIncrement: Integer; override;
    function IsEndPosition(APosition: Integer): Boolean; override;
  end;

  { TdxChartRectanglesLayoutStepToBottom }

  TdxChartRectanglesLayoutStepToBottom = class(TdxChartRectanglesLayoutVerticalStep)
  protected
    procedure CalculateFarPositions(ACell: TdxChartRectanglesLayoutCell; out APoint1, APoint2: TPoint); override;
    function CalculateNearPosition(ACell: TdxChartRectanglesLayoutCell): TPoint; override;
    function GetIncrement: Integer; override;
    function IsEndPosition(APosition: Integer): Boolean; override;
  end;

  { TdxChartRectanglesLayoutStepToTop }

  TdxChartRectanglesLayoutStepToTop = class(TdxChartRectanglesLayoutVerticalStep)
  protected
    procedure CalculateFarPositions(ACell: TdxChartRectanglesLayoutCell; out APoint1, APoint2: TPoint); override;
    function CalculateNearPosition(ACell: TdxChartRectanglesLayoutCell): TPoint; override;
    function GetIncrement: Integer; override;
    function IsEndPosition(APosition: Integer): Boolean; override;
  end;

  { TdxChartRectanglesLayout }

  TdxChartRectanglesLayout = class(TdxChartRectanglesCustomLayout)
  strict private const
    StepToBottomIndex = 2;
    StepToLeftIndex = 0;
    StepToRightIndex = 1;
    StepToTopIndex = 3;
  strict private
    FBounds: TRect;
    FLastValidRect: TRect;
    FOccupiedRectList: TList<TRect>;
    FRows: TdxChartRectanglesLayoutRows;
    FSteps: array[0..3] of TdxChartRectanglesLayoutStep;
    FTestContainer: TList;
    FUnallocatableHeight: Integer;
    FUnallocatableWidth: Integer;
    FValidRect: TRect;

    function GetStep(const Index: Integer): TdxChartRectanglesLayoutStep; inline;
  protected
    procedure Arrange(var ARect: TRect);
    function IsAlgorithmEnd: Boolean;
    function RunAlgorithm(const AAllocationRect: TRect): TRect;
    procedure UpdateSteps(const ARect: TRect);
    procedure UpdateTestContainer;
    procedure UpdateValidRect(const ARect: TRect);
  public
    constructor Create(const ABounds: TRect);
    destructor Destroy; override;
    procedure AddOccupiedRectangle(const ARect: TRect); override;
    function ArrangeRectangle(const ARect: TRect; AOverlappingIndent: Integer;
      const AValidRect, ATempExcludedRect: TRect): TRect; override;
    function IsEmptyRegion(const ARect: TRect): Boolean; overload; override;
    function IsEmptyRegion(const ARect, AValidRect: TRect): Boolean; overload; override;
    function IsEmptyRegionByList(const ARect: TRect): Boolean; override;
    //
    property StepToBottom: TdxChartRectanglesLayoutStep index StepToBottomIndex read GetStep;
    property StepToLeft: TdxChartRectanglesLayoutStep index StepToLeftIndex read GetStep;
    property StepToRight: TdxChartRectanglesLayoutStep index StepToRightIndex read GetStep;
    property StepToTop: TdxChartRectanglesLayoutStep index StepToTopIndex read GetStep;
    property Rows: TdxChartRectanglesLayoutRows read FRows;
    property ValidRect: TRect read FValidRect;
  end;

{ TdxChartRectanglesLayoutAlgorithm }

constructor TdxChartRectanglesLayoutAlgorithm.Create(AOverlappingIndent: Integer);
begin
  Create(cxNullRect, AOverlappingIndent);
end;

constructor TdxChartRectanglesLayoutAlgorithm.Create(ABounds: TRect; AOverlappingIndent: Integer);
begin
  if ABounds.IsEmpty then
    ABounds.Init(-MaxWord, -MaxWord, MaxWord, MaxWord)
  else
    ABounds.Inflate(AOverlappingIndent);

  FOverlappingIndent := AOverlappingIndent;
  FLayouts[False] := TdxChartRectanglesLayout.Create(ABounds);
  FLayouts[True] := TdxChartRectanglesLayout.Create(ABounds);
end;

destructor TdxChartRectanglesLayoutAlgorithm.Destroy;
begin
  FLayouts[False].Free;
  FLayouts[True].Free;
  inherited Destroy;
end;

procedure TdxChartRectanglesLayoutAlgorithm.AddExcludedRectangle(const ARect: TRect);
begin
  FLayouts[True].AddOccupiedRectangle(cxRectInflate(ARect, -FOverlappingIndent));
end;

procedure TdxChartRectanglesLayoutAlgorithm.AddOccupiedRectangle(const ARect: TRect);
begin
  FLayouts[True].AddOccupiedRectangle(ARect);
  FLayouts[False].AddOccupiedRectangle(ARect);
end;

function TdxChartRectanglesLayoutAlgorithm.ArrangeRectangle(
  const ARect, AValidRect, ATempExcludedRect: TRect; AUseExcludedRegions: Boolean): TRect;
begin
  if not AValidRect.IsEmpty then
    AValidRect.Inflate(Round(ARect.Width / 2 + FOverlappingIndent), Round(ARect.Height / 2 + FOverlappingIndent));
  if not ATempExcludedRect.IsEmpty then
    ATempExcludedRect.Inflate(-FOverlappingIndent);
  Result := FLayouts[AUseExcludedRegions].ArrangeRectangle(ARect, FOverlappingIndent, AValidRect, ATempExcludedRect);
  FLayouts[not AUseExcludedRegions].AddOccupiedRectangle(Result);
end;

function TdxChartRectanglesLayoutAlgorithm.ArrangeRectangle(
  const ARect, AValidRect: TRect; AUseExcludedRegions: Boolean): TRect;
begin
  Result := ArrangeRectangle(ARect, AValidRect, cxNullRect, AUseExcludedRegions);
end;

function TdxChartRectanglesLayoutAlgorithm.IsEmptyRegion(const ARect: TRect; AUseExlcludedRegions: Boolean): Boolean;
begin
  Result := FLayouts[AUseExlcludedRegions].IsEmptyRegion(cxRectInflate(ARect, FOverlappingIndent), TRect.Null);
end;

function TdxChartRectanglesLayoutAlgorithm.IsEmptyRegionByList(const ARect: TRect; AUseExlcludedRegions: Boolean): Boolean;
begin
  Result := FLayouts[AUseExlcludedRegions].IsEmptyRegionByList(cxRectInflate(ARect, FOverlappingIndent));
end;

{ TdxChartRectanglesLayoutCell }

constructor TdxChartRectanglesLayoutCell.Create(const ABounds: TRect; AInfillCount: Integer);
begin
  FBounds := ABounds;
  FInfillCount := AInfillCount;
end;

procedure TdxChartRectanglesLayoutCell.Clear;
begin
  FInfillCount := Max(FInfillCount - 1, 0);
end;

procedure TdxChartRectanglesLayoutCell.Infill;
begin
  Inc(FInfillCount);
end;

function TdxChartRectanglesLayoutCell.IsEmpty: Boolean;
begin
  Result := InfillCount = 0;
end;

{ TdxChartRectanglesLayoutRow }

function TdxChartRectanglesLayoutRow.GetItem(Index: TdxListIndex): TdxChartRectanglesLayoutCell;
begin
  Result := TdxChartRectanglesLayoutCell(List[Index]);
end;

constructor TdxChartRectanglesLayoutRow.Create(const ABounds: TRect; AAddCell: Boolean);
begin
  inherited Create(True);
  FBounds := ABounds;
  if AAddCell then
    Add(TdxChartRectanglesLayoutCell.Create(ABounds))
end;

function TdxChartRectanglesLayoutRow.FindCell(X: Integer; out AColumnIndex: Integer): TdxChartRectanglesLayoutCell;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    Result := TdxChartRectanglesLayoutCell(List[I]);
    if (Result.Bounds.Left <= X) and (X < Result.Bounds.Right) then
    begin
      AColumnIndex := I;
      Exit;
    end;
  end;
  AColumnIndex := -1;
  Result := nil;
end;

procedure TdxChartRectanglesLayoutRow.SeparateByVertical(ASeparator: Integer; AColumnIndex: Integer);
var
  ABounds: TRect;
  ACell: TdxChartRectanglesLayoutCell;
  ACellLeft: TdxChartRectanglesLayoutCell;
  ACellRight: TdxChartRectanglesLayoutCell;
begin
  ACell := Items[AColumnIndex];
  if (ASeparator > ACell.Bounds.Left) and (ASeparator < ACell.Bounds.Right) then
  begin
    ABounds := ACell.Bounds;
    ABounds.Right := ASeparator;
    ACellLeft := TdxChartRectanglesLayoutCell.Create(ABounds, ACell.InfillCount);

    ABounds := ACell.Bounds;
    ABounds.Left := ASeparator;
    ACellRight := TdxChartRectanglesLayoutCell.Create(ABounds, ACell.InfillCount);

    Insert(AColumnIndex, ACellRight);
    Insert(AColumnIndex, ACellLeft);
    Remove(ACell);
  end;
end;

procedure TdxChartRectanglesLayoutRow.SetItem(Index: TdxListIndex; const Value: TdxChartRectanglesLayoutCell);
begin
  inherited Items[Index] := Value;
end;

{ TdxChartRectanglesLayoutRows }

function TdxChartRectanglesLayoutRows.GetItem(Index: TdxListIndex): TdxChartRectanglesLayoutRow;
begin
  Result := TdxChartRectanglesLayoutRow(List[Index]);
end;

constructor TdxChartRectanglesLayoutRows.Create(const ABounds: TRect);
begin
  inherited Create(True);
  FBounds := ABounds;
  Add(TdxChartRectanglesLayoutRow.Create(ABounds, True));
end;

procedure TdxChartRectanglesLayoutRows.AddRectangle(const ARect: TRect);
begin
  if not ARect.IsEmpty then
  begin
    SeparateByHorizontal(ARect.Top);
    SeparateByHorizontal(ARect.Bottom);
    SeparateByVertical(ARect.Left);
    SeparateByVertical(ARect.Right);
    EnumIntersectedCells(ARect,
      procedure (ACell: TdxChartRectanglesLayoutCell)
      begin
        ACell.Infill;
      end);
  end;
end;

procedure TdxChartRectanglesLayoutRows.DeleteRectangle(const ARect: TRect);
begin
  EnumIntersectedCells(ARect,
    procedure (ACell: TdxChartRectanglesLayoutCell)
    begin
      ACell.Clear;
    end);
end;

procedure TdxChartRectanglesLayoutRows.EnumIntersectedCells(const ARect: TRect; AEnumProc: TEnumCellProc);
var
  ACell: TdxChartRectanglesLayoutCell;
  ARow: TdxChartRectanglesLayoutRow;
  I, J: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    ARow := Items[I];
    if ARow.Bounds.Bottom < ARect.Top then
      Continue;
    if ARow.Bounds.Top > ARect.Bottom then
      Break;
    for J := 0 to ARow.Count - 1 do
    begin
      ACell := ARow[J];
      if ACell.Bounds.Left > ARect.Right then
        Break;
      if cxRectIntersect(ACell.Bounds, ARect) then
        AEnumProc(ACell);
    end;
  end;
end;

function TdxChartRectanglesLayoutRows.FindCell(
  X, Y: Integer; out ARowIndex, AColumnIndex: Integer): TdxChartRectanglesLayoutCell;
var
  ARow: TdxChartRectanglesLayoutRow;
begin
  ARow := FindRow(Y, ARowIndex);
  if ARow <> nil then
    Result := ARow.FindCell(X, AColumnIndex)
  else
  begin
    AColumnIndex := -1;
    Result := nil;
  end;
end;

function TdxChartRectanglesLayoutRows.FindNearCell(
  const P: TPoint; out ARowIndex, AColumnIndex: Integer): TdxChartRectanglesLayoutCell;
begin
  Result := FindNearCell(P.X, P.Y, ARowIndex, AColumnIndex);
end;

function TdxChartRectanglesLayoutRows.FindNearCell(
  X, Y: Integer; out ARowIndex, AColumnIndex: Integer): TdxChartRectanglesLayoutCell;
var
  ARow: TdxChartRectanglesLayoutRow;
begin
  if Y <= Bounds.Top then
  begin
    ARowIndex := 0;
    ARow := Items[0];
  end
  else
    if Y > Bounds.Bottom then
    begin
      ARowIndex := Count - 1;
      ARow := Items[ARowIndex];
    end
    else
    begin
      ARow := FindRow(Y, ARowIndex);
      if ARow = nil then
        Exit(nil);
    end;

  if X <= Bounds.Left then
  begin
    AColumnIndex := 0;
    Result := ARow[AColumnIndex];
  end
  else
    if X > Bounds.Right then
    begin
      AColumnIndex := ColumnCount - 1;
      Result := ARow[AColumnIndex];
    end
    else
      Result := ARow.FindCell(X, AColumnIndex);
end;

function TdxChartRectanglesLayoutRows.FindRow(Y: Integer; out ARowIndex: Integer): TdxChartRectanglesLayoutRow;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    Result := TdxChartRectanglesLayoutRow(List[I]);
    if (Result.Bounds.Top <= Y) and (Y < Result.Bounds.Bottom) then
    begin
      ARowIndex := I;
      Exit;
    end;
  end;
  ARowIndex := -1;
  Result := nil;
end;

function TdxChartRectanglesLayoutRows.IsEmptyRegion(const ARect: TRect): Boolean;
var
  ACell: TdxChartRectanglesLayoutCell;
  AColumnIndex: Integer;
  ARow: TdxChartRectanglesLayoutRow;
  ARowIndex: Integer;
  I, J: Integer;
begin
  if FindCell(ARect.Left, ARect.Top, ARowIndex, AColumnIndex) = nil then
    Exit(True);
  for I := ARowIndex to Count - 1 do
  begin
    ARow := Items[I];
    if ARow.Bounds.Top > ARect.Bottom then
      Exit(True);
    for J := AColumnIndex to ARow.Count - 1 do
    begin
      ACell := ARow[J];
      if ACell.Bounds.Left > ARect.Right then
        Break;
      if not ACell.IsEmpty and cxRectIntersect(ARect, ACell.Bounds) then
        Exit(False);
    end;
  end;
  Result := True;
end;

procedure TdxChartRectanglesLayoutRows.SeparateByHorizontal(ASeparator: Integer);
var
  ABounds: TRect;
  ACell: TdxChartRectanglesLayoutCell;
  ARow: TdxChartRectanglesLayoutRow;
  ARowBottom: TdxChartRectanglesLayoutRow;
  ARowIndex: Integer;
  ARowTop: TdxChartRectanglesLayoutRow;
  I: Integer;
begin
  ARow := FindRow(ASeparator, ARowIndex);
  if (ARow <> nil) and (ASeparator > ARow.Bounds.Top) and (ASeparator < ARow.Bounds.Bottom) then
  begin
    ABounds := ARow.Bounds;
    ABounds.Bottom := ASeparator;
    ARowTop := TdxChartRectanglesLayoutRow.Create(ABounds);

    ABounds := ARow.Bounds;
    ABounds.Top := ASeparator;
    ARowBottom := TdxChartRectanglesLayoutRow.Create(ABounds);

    for I := 0 to ARow.Count - 1 do
    begin
      ACell := ARow.Items[I];

      ABounds := ACell.Bounds;
      ABounds.Bottom := ASeparator;
      ARowTop.Add(TdxChartRectanglesLayoutCell.Create(ABounds, ACell.InfillCount));

      ABounds := ACell.Bounds;
      ABounds.Top := ASeparator;
      ARowBottom.Add(TdxChartRectanglesLayoutCell.Create(ABounds, ACell.InfillCount));
    end;

    Insert(ARowIndex, ARowBottom);
    Insert(ARowIndex, ARowTop);
    Remove(ARow);
  end;
end;

procedure TdxChartRectanglesLayoutRows.SeparateByVertical(ASeparator: Integer);
var
  AColumnIndex: Integer;
  I: Integer;
begin
  if (Count > 0) and Assigned(Items[0].FindCell(ASeparator, AColumnIndex)) then
    for I := 0 to Count - 1 do
      Items[I].SeparateByVertical(ASeparator, AColumnIndex);
end;

function TdxChartRectanglesLayoutRows.GetCell(ARowIndex, AColumnIndex: Integer): TdxChartRectanglesLayoutCell;
begin
  Result := Items[ARowIndex].Items[AColumnIndex];
end;

function TdxChartRectanglesLayoutRows.GetColumnCount: Integer;
begin
  if Count > 0 then
    Result := Items[0].Count
  else
    Result := 0;
end;

{ TdxChartRectanglesLayoutTestPosition }

constructor TdxChartRectanglesLayoutTestPosition.Create(const APosition: TPoint; ADistance: Double);
begin
  Position := APosition;
  Distance := ADistance;
  Check := False;
end;

{ TdxChartRectanglesLayoutStep }

constructor TdxChartRectanglesLayoutStep.Create(ALayout: TdxChartRectanglesLayout);
begin
  FLayout := ALayout;
  FTestPositions := TObjectList.Create(True);
  FPrimaryTestPositions := TList.Create;
end;

destructor TdxChartRectanglesLayoutStep.Destroy;
begin
  FPrimaryTestPositions.Free;
  FTestPositions.Free;
  inherited Destroy;
end;

procedure TdxChartRectanglesLayoutStep.Initialize(ARowIndex, AColumnIndex: Integer; const AAllocationRect: TRect);
begin
  FAllocationRect := AAllocationRect;
  FPosition := GetPosition(ARowIndex, AColumnIndex);
  FRadiusX := AllocationRect.Width / 2;
  FRadiusY := AllocationRect.Height / 2;
  FCenterX := AllocationRect.Left + FRadiusX;
  FCenterY := AllocationRect.Top + FRadiusY;
  FPrimaryTestPositions.Clear;
  FTestPositions.Clear;
  FMaxDistance := 0;
  FIsEnd := False;
end;

procedure TdxChartRectanglesLayoutStep.Next;
var
  APosition: Integer;
begin
  if not IsEnd then
  begin
    APosition := FPosition + GetIncrement;
    if IsEndPosition(APosition) then
      FIsEnd := True
    else
      FPosition := APosition;
  end;
end;

procedure TdxChartRectanglesLayoutStep.Update;
begin
  FMaxDistance := 0;
  FPrimaryTestPositions.Clear;
  FTestPositions.Clear;
  if not IsEnd then
  begin
    UpdatePrimaryTestPositions;
    UpdateSecondaryTestPositions;
  end;
end;

function TdxChartRectanglesLayoutStep.IsTestingEnd: Boolean;
var
  I: Integer;
begin
  for I := 0 to FPrimaryTestPositions.Count - 1 do
    if not TdxChartRectanglesLayoutTestPosition(FPrimaryTestPositions.List[I]).Check then
      Exit(False);
  Result := True;
end;

procedure TdxChartRectanglesLayoutStep.AddPrimaryTestPosition(const P: TPoint);
var
  ADistance: Double;
  APosition: TdxChartRectanglesLayoutTestPosition;
begin
  ADistance := CalculateDistance(P);
  FMaxDistance := Max(FMaxDistance, ADistance);
  APosition := TdxChartRectanglesLayoutTestPosition.Create(P, ADistance);
  FPrimaryTestPositions.Add(APosition);
  FTestPositions.Add(APosition);
end;

procedure TdxChartRectanglesLayoutStep.AddSecondaryTestPosition(const P: TPoint);
var
  ADistance: Double;
begin
  ADistance := CalculateDistance(P);
  if ADistance < FMaxDistance then
    FTestPositions.Add(TdxChartRectanglesLayoutTestPosition.Create(P, ADistance));
end;

function TdxChartRectanglesLayoutStep.CalculateDistance(const P: TPoint): Double;
begin
  Result := Sqr(P.X + FRadiusX - FCenterX) + Sqr(P.Y + FRadiusY - FCenterY);
end;

function TdxChartRectanglesLayoutStep.IsUpdateEnd(ADistance: Double): Boolean;
begin
  Result := ADistance > FMaxDistance;
end;

{ TdxChartRectanglesLayoutHorizontalStep }

procedure TdxChartRectanglesLayoutHorizontalStep.Initialize(ARowIndex, AColumnIndex: Integer; const ARect: TRect);
begin
  inherited Initialize(ARowIndex, AColumnIndex, ARect);
  FStartRowIndex := ARowIndex;
end;

function TdxChartRectanglesLayoutHorizontalStep.IsEndPosition(APosition: Integer): Boolean;
begin
  Result := not cxRectIntersect(Layout.ValidRect, Layout.Rows.GetCell(StartRowIndex, APosition).Bounds);
end;

function TdxChartRectanglesLayoutHorizontalStep.GetPosition(ARowIndex, AColumnIndex: Integer): Integer;
begin
  Result := AColumnIndex;
end;

procedure TdxChartRectanglesLayoutHorizontalStep.UpdatePrimaryTestPositions;
var
  ACell: TdxChartRectanglesLayoutCell;
  APoint1: TPoint;
  APoint2: TPoint;
  I: Integer;
begin
  ACell := Layout.Rows.GetCell(StartRowIndex, Position);
  if ACell.IsEmpty then
    AddPrimaryTestPosition(CalculateNearPosition(ACell));
  for I := Layout.StepToBottom.Position to Layout.StepToTop.Position do
  begin
    ACell := Layout.Rows.GetCell(I, Position);
    if ACell.IsEmpty then
    begin
      CalculateFarPositions(ACell, APoint1, APoint2);
      AddPrimaryTestPosition(APoint1);
      AddPrimaryTestPosition(APoint2);
    end;
  end;
end;

procedure TdxChartRectanglesLayoutHorizontalStep.UpdateSecondaryTestPositions;
var
  ACell: TdxChartRectanglesLayoutCell;
  AIncrement: Integer;
  AIndex: Integer;
  APoint: TPoint;
  APoint2: TPoint;
  I: Integer;
begin
  AIncrement := GetIncrement;
  AIndex := Position + AIncrement;
  while not IsEndPosition(AIndex) do
  begin
    ACell := Layout.Rows.GetCell(StartRowIndex, AIndex);
    if ACell = nil then
      Exit;
    APoint := CalculateNearPosition(ACell);
    if IsUpdateEnd(CalculateDistance(APoint)) then
      Break;
    if ACell.IsEmpty then
      AddSecondaryTestPosition(APoint);
    for I := Layout.StepToBottom.Position to Layout.StepToTop.Position do
    begin
      ACell := Layout.Rows.GetCell(I, AIndex);
      if ACell.IsEmpty then
      begin
        CalculateFarPositions(ACell, APoint, APoint2);
        AddSecondaryTestPosition(APoint);
        AddSecondaryTestPosition(APoint2);
      end;
    end;
    Inc(AIndex, AIncrement);
  end;
end;

{ TdxChartRectanglesLayoutVerticalStep }

function TdxChartRectanglesLayoutVerticalStep.GetPosition(ARowIndex, AColumnIndex: Integer): Integer;
begin
  Result := ARowIndex;
end;

procedure TdxChartRectanglesLayoutVerticalStep.Initialize(ARowIndex, AColumnIndex: Integer; const ARect: TRect);
begin
  inherited Initialize(ARowIndex, AColumnIndex, ARect);
  FStartColumnIndex := AColumnIndex;
end;

function TdxChartRectanglesLayoutVerticalStep.IsEndPosition(APosition: Integer): Boolean;
var
  ACell: TdxChartRectanglesLayoutCell;
begin
  ACell := Layout.Rows.GetCell(APosition, FStartColumnIndex);
  Result := (ACell <> nil) and not cxRectIntersect(Layout.ValidRect, ACell.Bounds);
end;

procedure TdxChartRectanglesLayoutVerticalStep.UpdatePrimaryTestPositions;
var
  ACell: TdxChartRectanglesLayoutCell;
  APoint1: TPoint;
  APoint2: TPoint;
  I: Integer;
begin
  ACell := Layout.Rows.GetCell(Position, StartColumnIndex);
  if (ACell <> nil) and ACell.IsEmpty then
    AddPrimaryTestPosition(CalculateNearPosition(ACell));
  for I := Layout.StepToLeft.Position to Layout.StepToRight.Position do
  begin
    ACell := Layout.Rows.GetCell(Position, I);
    if (ACell <> nil) and ACell.IsEmpty then
    begin
      CalculateFarPositions(ACell, APoint1, APoint2);
      AddPrimaryTestPosition(APoint1);
      AddPrimaryTestPosition(APoint2);
    end;
  end;
end;

procedure TdxChartRectanglesLayoutVerticalStep.UpdateSecondaryTestPositions;
var
  ACell: TdxChartRectanglesLayoutCell;
  AIncrement: Integer;
  AIndex: Integer;
  APoint: TPoint;
  APoint2: TPoint;
  I: Integer;
begin
  AIncrement := GetIncrement;
  AIndex := Position + AIncrement;
  while not IsEndPosition(AIndex) do
  begin
    ACell := Layout.Rows.GetCell(AIndex, StartColumnIndex);
    if ACell = nil then
      Exit;
    APoint := CalculateNearPosition(ACell);
    if IsUpdateEnd(CalculateDistance(APoint)) then
      Break;
    if ACell.IsEmpty then
      AddSecondaryTestPosition(APoint);
    for I := Layout.StepToLeft.Position to Layout.StepToRight.Position do
    begin
      ACell := Layout.Rows.GetCell(AIndex, I);
      if (ACell <> nil) and ACell.IsEmpty then
      begin
        CalculateFarPositions(ACell, APoint, APoint2);
        AddSecondaryTestPosition(APoint);
        AddSecondaryTestPosition(APoint2);
      end;
    end;
    Inc(AIndex, AIncrement);
  end;
end;

{ TdxChartRectanglesLayoutStepToLeft }

procedure TdxChartRectanglesLayoutStepToLeft.CalculateFarPositions(ACell: TdxChartRectanglesLayoutCell;
  out APoint1, APoint2: TPoint);
begin
  APoint1.Init(ACell.Bounds.Right - AllocationRect.Width, ACell.Bounds.Top);
  APoint2.Init(APoint1.X, ACell.Bounds.Bottom - AllocationRect.Height);
end;

function TdxChartRectanglesLayoutStepToLeft.CalculateNearPosition(ACell: TdxChartRectanglesLayoutCell): TPoint;
begin
  Result.Init(ACell.Bounds.Right - AllocationRect.Width, AllocationRect.Top);
end;

function TdxChartRectanglesLayoutStepToLeft.GetIncrement: Integer;
begin
  Result := -1;
end;

function TdxChartRectanglesLayoutStepToLeft.IsEndPosition(APosition: Integer): Boolean;
begin
  Result := (APosition < 0) or inherited IsEndPosition(APosition);
end;

{ TdxChartRectanglesLayoutStepToRight }

procedure TdxChartRectanglesLayoutStepToRight.CalculateFarPositions(ACell: TdxChartRectanglesLayoutCell;
  out APoint1, APoint2: TPoint);
begin
  APoint1.Init(ACell.Bounds.Left, ACell.Bounds.Top);
  APoint2.Init(ACell.Bounds.Left, ACell.Bounds.Bottom - AllocationRect.Height);
end;

function TdxChartRectanglesLayoutStepToRight.CalculateNearPosition(ACell: TdxChartRectanglesLayoutCell): TPoint;
begin
  Result := cxPoint(ACell.Bounds.Left, AllocationRect.Top);
end;

function TdxChartRectanglesLayoutStepToRight.GetIncrement: Integer;
begin
  Result := 1;
end;

function TdxChartRectanglesLayoutStepToRight.IsEndPosition(APosition: Integer): Boolean;
begin
  Result := (APosition >= Layout.Rows.ColumnCount) or inherited IsEndPosition(APosition);
end;

{ TdxChartRectanglesLayoutStepToBottom }

procedure TdxChartRectanglesLayoutStepToBottom.CalculateFarPositions(ACell: TdxChartRectanglesLayoutCell;
  out APoint1, APoint2: TPoint);
begin
  APoint1.Init(ACell.Bounds.Left, ACell.Bounds.Bottom - AllocationRect.Height);
  APoint2.Init(ACell.Bounds.Right - AllocationRect.Width, APoint1.Y);
end;

function TdxChartRectanglesLayoutStepToBottom.CalculateNearPosition(ACell: TdxChartRectanglesLayoutCell): TPoint;
begin
  Result := cxPoint(AllocationRect.Left, ACell.Bounds.Bottom - AllocationRect.Height)
end;

function TdxChartRectanglesLayoutStepToBottom.GetIncrement: Integer;
begin
  Result := -1;
end;

function TdxChartRectanglesLayoutStepToBottom.IsEndPosition(APosition: Integer): Boolean;
begin
  Result := (APosition < 0) or inherited IsEndPosition(APosition);
end;

{ TdxChartRectanglesLayoutStepToTop }

procedure TdxChartRectanglesLayoutStepToTop.CalculateFarPositions(ACell: TdxChartRectanglesLayoutCell;
  out APoint1, APoint2: TPoint);
begin
  APoint1.Init(ACell.Bounds.Left, ACell.Bounds.Top);
  APoint2.Init(ACell.Bounds.Right - AllocationRect.Width, ACell.Bounds.Top);
end;

function TdxChartRectanglesLayoutStepToTop.CalculateNearPosition(ACell: TdxChartRectanglesLayoutCell): TPoint;
begin
  Result.Init(AllocationRect.Left, ACell.Bounds.Top);
end;

function TdxChartRectanglesLayoutStepToTop.GetIncrement: Integer;
begin
  Result := 1;
end;

function TdxChartRectanglesLayoutStepToTop.IsEndPosition(APosition: Integer): Boolean;
begin
  Result := (APosition >= Layout.Rows.Count) or inherited IsEndPosition(APosition);
end;

{ TdxChartRectanglesLayout }

constructor TdxChartRectanglesLayout.Create(const ABounds: TRect);
begin
  FBounds := ABounds;
  FRows := TdxChartRectanglesLayoutRows.Create(ABounds);
  FTestContainer := TList.Create;
  FOccupiedRectList := TList<TRect>.Create;
  FSteps[StepToBottomIndex] := TdxChartRectanglesLayoutStepToBottom.Create(Self);
  FSteps[StepToLeftIndex] := TdxChartRectanglesLayoutStepToLeft.Create(Self);
  FSteps[StepToRightIndex] := TdxChartRectanglesLayoutStepToRight.Create(Self);
  FSteps[StepToTopIndex] := TdxChartRectanglesLayoutStepToTop.Create(Self);
  FUnallocatableHeight := MaxInt;
  FUnallocatableWidth := MaxInt;
end;

destructor TdxChartRectanglesLayout.Destroy;
var
  I: Integer;
begin
  for I := Low(FSteps) to High(FSteps) do
    FSteps[I].Free;
  FOccupiedRectList.Free;
  FTestContainer.Free;
  FRows.Free;
  inherited Destroy;
end;

procedure TdxChartRectanglesLayout.AddOccupiedRectangle(const ARect: TRect);
begin
  FOccupiedRectList.Add(ARect);
  FRows.AddRectangle(ARect);
end;

function TdxChartRectanglesLayout.ArrangeRectangle(const ARect: TRect;
  AOverlappingIndent: Integer; const AValidRect, ATempExcludedRect: TRect): TRect;
begin
  if ARect.IsEmpty then
    Exit(ARect);

  Result := cxRectInflate(ARect, AOverlappingIndent);
  UpdateValidRect(AValidRect);
  if not ATempExcludedRect.IsEmpty then
    FRows.AddRectangle(ATempExcludedRect);
  if not IsEmptyRegion(Result) then
    Arrange(Result);
  if not ATempExcludedRect.IsEmpty then
    FRows.DeleteRectangle(ATempExcludedRect);
  Result.Inflate(-AOverlappingIndent);
  AddOccupiedRectangle(Result);
end;

function TdxChartRectanglesLayout.IsAlgorithmEnd: Boolean;
var
  I: Integer;
begin
  for I := Low(FSteps) to High(FSteps) do
    if not FSteps[I].IsEnd then
      Exit(False);
  Result := True;
end;

function TdxChartRectanglesLayout.IsEmptyRegion(const ARect: TRect): Boolean;
begin
  if FValidRect.Contains(ARect) then
    Result := FRows.IsEmptyRegion(ARect)
  else
    Result := False;
end;

function TdxChartRectanglesLayout.IsEmptyRegion(const ARect, AValidRect: TRect): Boolean;
begin
  UpdateValidRect(AValidRect);
  Result := IsEmptyRegion(ARect);
end;

function TdxChartRectanglesLayout.IsEmptyRegionByList(const ARect: TRect): Boolean;
var
  I: Integer;
begin
  for I := 0 to FOccupiedRectList.Count - 1 do
    if cxRectIntersect(FOccupiedRectList[I], ARect) then
      Exit(False);
  Result := True;
end;

procedure TdxChartRectanglesLayout.Arrange(var ARect: TRect);
begin
  if (ARect.Width < FUnallocatableWidth) or (ARect.Height < FUnallocatableHeight) then
  begin
    UpdateSteps(ARect);
    UpdateTestContainer;
    ARect := RunAlgorithm(ARect);
  end;
end;

function TdxChartRectanglesLayout.RunAlgorithm(const AAllocationRect: TRect): TRect;
var
  AIndex: Integer;
  AStep: TdxChartRectanglesLayoutStep;
  AStepIndex: Integer;
  ATest: TdxChartRectanglesLayoutTestPosition;
  ATestRect: TRect;
  AUpdateFlag: Boolean;
begin
  AIndex := 0;
  while True do
  begin
    if IsAlgorithmEnd and (FTestContainer.Count = 0) then
    begin
      FUnallocatableWidth := Min(FUnallocatableWidth, AAllocationRect.Width);
      FUnallocatableHeight := Min(FUnallocatableHeight, AAllocationRect.Height);
      Exit(AAllocationRect);
    end;

    if AIndex >= FTestContainer.Count then
    begin
      for AStepIndex := Low(FSteps) to High(FSteps) do
        FSteps[AStepIndex].Next;
      for AStepIndex := Low(FSteps) to High(FSteps) do
        FSteps[AStepIndex].Update;
      UpdateTestContainer;
      AIndex := 0;
      Continue;
    end;

    ATest := FTestContainer.List[AIndex];
    ATestRect.InitSize(ATest.Position.X, ATest.Position.Y, AAllocationRect.Width, AAllocationRect.Height);
    if IsEmptyRegion(ATestRect) then
      Exit(ATestRect);

    AUpdateFlag := False;
    ATest.Check := True;
    for AStepIndex := Low(FSteps) to High(FSteps) do
    begin
      AStep := FSteps[AStepIndex];
      if AStep.IsTestingEnd and not AStep.IsEnd then
      begin
        AStep.Next;
        AStep.Update;
        AUpdateFlag := True;
      end;
    end;

    if AUpdateFlag then
    begin
      UpdateTestContainer;
      AIndex := 0;
      Continue;
    end;

    Inc(AIndex);
  end;
end;

procedure TdxChartRectanglesLayout.UpdateSteps(const ARect: TRect);
var
  ACell: TdxChartRectanglesLayoutCell;
  AColumnIndex: Integer;
  ARowIndex: Integer;
  I: Integer;
begin
  ACell := FRows.FindNearCell(ARect.CenterPoint, ARowIndex, AColumnIndex);
  if ACell = nil then
    Exit;
  if not cxRectIntersect(FValidRect, ACell.Bounds) then
    if FRows.FindNearCell(FValidRect.CenterPoint, ARowIndex, AColumnIndex) = nil then
      Exit;
  for I := Low(FSteps) to High(FSteps) do
    FSteps[I].Initialize(ARowIndex, AColumnIndex, ARect);
  for I := Low(FSteps) to High(FSteps) do
    FSteps[I].Update;
end;

procedure TdxChartRectanglesLayout.UpdateTestContainer;
var
  ACapacity: Integer;
  ATestPositions: TList;
  I, L: Integer;
begin
  ACapacity := 0;
  for I := Low(FSteps) to High(FSteps) do
    Inc(ACapacity, FSteps[I].TestPositions.Count);

  FTestContainer.Count := 0;
  FTestContainer.Capacity := ACapacity;
  for I := Low(FSteps) to High(FSteps) do
  begin
    ATestPositions := FSteps[I].TestPositions;
    for L := 0 to ATestPositions.Count - 1 do
      FTestContainer.Add(ATestPositions[L]);
  end;

  FTestContainer.SortList(
    function (AItem1, AItem2: Pointer): Integer
    begin
      Result := CompareValue(
        TdxChartRectanglesLayoutTestPosition(AItem1).Distance,
        TdxChartRectanglesLayoutTestPosition(AItem2).Distance);
      if Result = 0 then
        Result := CompareValue(
          TdxChartRectanglesLayoutTestPosition(AItem1).Position.X,
          TdxChartRectanglesLayoutTestPosition(AItem2).Position.X);
      if Result = 0 then
        Result := CompareValue(
          TdxChartRectanglesLayoutTestPosition(AItem1).Position.Y,
          TdxChartRectanglesLayoutTestPosition(AItem2).Position.Y);
    end);
end;

procedure TdxChartRectanglesLayout.UpdateValidRect(const ARect: TRect);
begin
  if ARect.IsEmpty then
    FValidRect := FBounds
  else
  begin
    cxRectIntersect(FValidRect, FBounds, ARect);

    FRows.SeparateByHorizontal(FValidRect.Top);
    FRows.SeparateByHorizontal(FValidRect.Bottom);
    FRows.SeparateByVertical(FValidRect.Left);
    FRows.SeparateByVertical(FValidRect.Right);
  end;

  if FLastValidRect <> FValidRect then
  begin
    FUnallocatableWidth := MaxInt;
    FUnallocatableWidth := MaxInt;
    FLastValidRect := FValidRect;
  end;
end;

function TdxChartRectanglesLayout.GetStep(const Index: Integer): TdxChartRectanglesLayoutStep;
begin
  Result := FSteps[Index];
end;

end.
