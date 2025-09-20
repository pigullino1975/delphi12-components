{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressRichEditControl                                   }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSRICHEDITCONTROL AND ALL        }
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

unit dxRichEdit.DocumentModel.Boxes.Core;

{$I cxVer.inc}
{$I dxRichEditControl.inc}
{.$DEFINE DXLOGGING}

interface

uses
  Types, SysUtils, Classes, Generics.Defaults, Generics.Collections,
  dxCore, dxCoreClasses, dxCoreGraphics, cxGeometry,
  dxRichEdit.Utils.Types,
  dxGenerics,
  dxFontHelpers,
  dxTextViewInfoCache,
  dxRichEdit.DocumentModel.Core;

type
  TdxBoxInfo = class;

  { IdxObjectMeasurer }

  IdxObjectMeasurer = interface // for internal use
    procedure MeasureText(ABoxInfo: TdxBoxInfo; const AText: string; AFontInfo: TdxFontInfo);
    function MeasureRectangularObject(const AObject: IdxRectangularObject): TSize;
    procedure BeginTextMeasure;
    procedure EndTextMeasure;
    function TryAdjustEndPositionToFit(ABoxInfo: TdxBoxInfo; const AText: string; AFontInfo: TdxFontInfo; AMaxWidth: Integer): Boolean;
  end;

  { TdxBoxBase }

  TdxBoxBase = class(TdxReferencedObject)
  strict protected
    FBounds: TRect;
    function GetActualSizeBounds: TRect; virtual;
    function GetDetailsLevel: TdxDocumentLayoutDetailsLevel; virtual; abstract;
    function GetEndPos: TdxFormatterPosition; virtual; abstract;
    function GetHitTestAccuracy: TdxHitTestAccuracy; virtual; abstract;
    function GetStartPos: TdxFormatterPosition; virtual; abstract;
    procedure SetEndPos(const Value: TdxFormatterPosition); virtual; abstract;
    procedure SetStartPos(const Value: TdxFormatterPosition); virtual; abstract;
  public
    function GetFirstFormatterPosition: TdxFormatterPosition; virtual; abstract;
    function GetFirstPosition(APieceTable: TdxCustomPieceTable): TdxDocumentModelPosition; virtual; abstract;
    function GetLastFormatterPosition: TdxFormatterPosition; virtual; abstract;
    function GetLastPosition(APieceTable: TdxCustomPieceTable): TdxDocumentModelPosition; virtual; abstract;
    procedure MoveVertically(ADeltaY: Integer); virtual;

    function GetFontInfo(APieceTable: TdxCustomPieceTable): TdxFontInfo; virtual;
    function GetRun(APieceTable: TdxCustomPieceTable): TdxRunBase; virtual; abstract;

    function IsLineBreak: Boolean; virtual; abstract;
    function IsSpaceBox: Boolean; virtual; abstract;
    function IsNotWhiteSpaceBox: Boolean; virtual; abstract;
    function IsVisible: Boolean; virtual; abstract;
    function IsInlinePicture: Boolean; virtual;
    function IsHyperlinkSupported: Boolean; virtual;

    property ActualSizeBounds: TRect read GetActualSizeBounds;
    property Bounds: TRect read FBounds write FBounds;
    property DetailsLevel: TdxDocumentLayoutDetailsLevel read GetDetailsLevel;
    property EndPos: TdxFormatterPosition read GetEndPos write SetEndPos;
    property HitTestAccuracy: TdxHitTestAccuracy read GetHitTestAccuracy;
    property StartPos: TdxFormatterPosition read GetStartPos write SetStartPos;
  end;

  TdxBoxListBase = class(TdxReferencedObjectList<TdxBoxBase>); // for internal use

  { TdxBoxBaseComparer }

  TdxBoxBaseComparer = class abstract(TdxComparer<TdxBoxBase>);

  { TdxHighlightArea }

  TdxHighlightArea = record // for internal use
  strict private
    FBounds: TRect;
    FColor: TdxAlphaColor;
    FIsNull: Boolean;
  private
    function GetBounds: TRect;
    class function GetNull: TdxHighlightArea; static;
  public
    constructor Create(AColor: TdxAlphaColor; const ABounds: TRect);

    procedure MoveVertically(ADeltaY: Integer);

    property Bounds: TRect read GetBounds;
    property Color: TdxAlphaColor read FColor;
    property IsNull: Boolean read FIsNull;
    class property Null: TdxHighlightArea read GetNull;
  end;

  { TdxHighlightAreaCollection }

  TdxHighlightAreaCollection = class(TList<TdxHighlightArea>) // for internal use
  public
    procedure MoveVertically(ADeltaY: Integer);
  end;

  { TdxRowBoxRange }

  TdxRowBoxRange = class // for internal use
  strict private
    FFirstBoxIndex: Integer;
    FLastBoxIndex: Integer;
    FBounds: TRect;
  public
    constructor Create(AFirstBoxIndex, ALastBoxIndex: Integer; const ABounds: TRect);

    property FirstBoxIndex: Integer read FFirstBoxIndex write FFirstBoxIndex;
    property LastBoxIndex: Integer read FLastBoxIndex write FLastBoxIndex;
    property Bounds: TRect read FBounds write FBounds;
  end;
  TdxRowBoxRangeCollection = class sealed(TdxObjectList<TdxRowBoxRange>);

  { TdxBoxInfo }

  TdxBoxInfo = class // for internal use
  strict private
    FIteratorResult: TdxParagraphIteratorResult;
    FStartPos: TdxFormatterPosition;
    FEndPos: TdxFormatterPosition;
    FSize: TSize;
    FBox: TdxBoxBase;
  protected
    function GetForceUpdateCurrentRowHeight: Boolean; virtual;

  public
    function GetRun(APieceTable: TdxCustomPieceTable): TdxRunBase;
    function GetFontInfo(APieceTable: TdxCustomPieceTable): TdxFontInfo; virtual;

    property StartPos: TdxFormatterPosition read FStartPos write FStartPos;
    property EndPos: TdxFormatterPosition read FEndPos write FEndPos;
    property IteratorResult: TdxParagraphIteratorResult read FIteratorResult write FIteratorResult;
    property Size: TSize read FSize write FSize;
    property ForceUpdateCurrentRowHeight: Boolean read GetForceUpdateCurrentRowHeight;
    property Box: TdxBoxBase read FBox write FBox;
  end;

  TdxBoxComparableFunc = TdxComparableFunc<TdxBoxBase>;

  { TdxBoxAndPointXComparable }

  TdxBoxAndPointXComparable = record // for internal use
  strict private
    FX: Integer;
  public
    constructor Create(const P: TPoint);
    function CompareTo(const Value: TdxBoxBase): Integer;

    property X: Integer read FX;
  end;

  { TdxBoxAndPointYComparable }

  TdxBoxAndPointYComparable = record // for internal use
  strict private
    FY: Integer;
  public
    constructor Create(const P: TPoint);
    function CompareTo(const Value: TdxBoxBase): Integer;

    property Y: Integer read FY;
  end;

  { TdxBoxLogPositionComparable }

  TdxBoxLogPositionComparable = record // for internal use
  strict private
    FPieceTable: TdxCustomPieceTable;
    FLogPosition: TdxDocumentLogPosition;
  public
    constructor Create(APieceTable: TdxCustomPieceTable; ALogPosition: TdxDocumentLogPosition);
    function BoxAndLogPositionCompare(const Value: TdxBoxBase): Integer;
    function BoxStartAndLogPositionCompare(const Value: TdxBoxBase): Integer;

    property PieceTable: TdxCustomPieceTable read FPieceTable;
    property LogPosition: TdxDocumentLogPosition read FLogPosition;
  end;

  { TdxBoxAndFormatterPositionComparable }

  TdxBoxAndFormatterPositionComparable = record // for internal use
  strict private
    FFormatterPosition: TdxFormatterPosition;
  public
    constructor Create(const AFormatterPosition: TdxFormatterPosition);
    function CompareTo(const Value: TdxBoxBase): Integer;

    property FormatterPosition: TdxFormatterPosition read FFormatterPosition;
  end;

implementation

uses
  Math, RTLConsts,
  dxTypeHelpers,
  dxRichEdit.DocumentModel.UnitToLayoutUnitConverter,
  dxDocumentLayoutUnitConverter;

const
  dxThisUnitName = 'dxRichEdit.DocumentModel.Boxes.Core';

{ TdxBoxBase }

function TdxBoxBase.GetFontInfo(APieceTable: TdxCustomPieceTable): TdxFontInfo;
begin
  Result := APieceTable.DocumentModel.FontCache[GetRun(APieceTable).FontCacheIndex];
end;

function TdxBoxBase.IsHyperlinkSupported: Boolean;
begin
  Result := True;
end;

function TdxBoxBase.IsInlinePicture: Boolean;
begin
  Result := False;
end;

procedure TdxBoxBase.MoveVertically(ADeltaY: Integer);
begin
  FBounds.Offset(0, ADeltaY);
end;

function TdxBoxBase.GetActualSizeBounds: TRect;
begin
  Result := FBounds;
end;


{ TdxHighlightArea }

constructor TdxHighlightArea.Create(AColor: TdxAlphaColor; const ABounds: TRect);
begin
  FBounds := ABounds;
  FColor := AColor;
  FIsNull := False;
end;

function TdxHighlightArea.GetBounds: TRect;
begin
  Result := FBounds;
end;

class function TdxHighlightArea.GetNull: TdxHighlightArea;
begin
  Result.FIsNull := True;
end;

procedure TdxHighlightArea.MoveVertically(ADeltaY: Integer);
begin
  FBounds.Offset(0, ADeltaY);
end;

{ TdxHighlightAreaCollection }

procedure TdxHighlightAreaCollection.MoveVertically(ADeltaY: Integer);
var
  I: Integer;
  AItem: TdxHighlightArea;
begin
  for I := 0 to Count - 1 do
  begin
    AItem := Items[I];
    AItem.MoveVertically(ADeltaY);
    Items[I] := AItem;
  end;
end;

{ TdxRowBoxRange }

constructor TdxRowBoxRange.Create(AFirstBoxIndex, ALastBoxIndex: Integer; const ABounds: TRect);
begin
  inherited Create;
  FFirstBoxIndex := AFirstBoxIndex;
  FLastBoxIndex := ALastBoxIndex;
  FBounds := ABounds;
end;

{ TdxBoxInfo }

function TdxBoxInfo.GetFontInfo(APieceTable: TdxCustomPieceTable): TdxFontInfo;
begin
  Result := APieceTable.DocumentModel.FontCache[GetRun(APieceTable).FontCacheIndex];
end;

function TdxBoxInfo.GetForceUpdateCurrentRowHeight: Boolean;
begin
  Result := False;
end;

function TdxBoxInfo.GetRun(APieceTable: TdxCustomPieceTable): TdxRunBase;
begin
  Result := APieceTable.Runs[StartPos.RunIndex];
end;

{ TdxBoxAndPointXComparable }

constructor TdxBoxAndPointXComparable.Create(const P: TPoint);
begin
  FX := P.X;
end;

function TdxBoxAndPointXComparable.CompareTo(const Value: TdxBoxBase): Integer;
var
  R: TRect;
begin
  R := Value.Bounds;
  if X < R.Left then
    Result := 1
  else
    if X >= R.Right then
      Result := -1
    else
      Result := 0;
end;

{ TdxBoxAndPointYComparable }

constructor TdxBoxAndPointYComparable.Create(const P: TPoint);
begin
  FY := P.Y;
end;

function TdxBoxAndPointYComparable.CompareTo(const Value: TdxBoxBase): Integer;
var
  R: TRect;
begin
  R := Value.Bounds;
  if Y < R.Top then
    Result := 1
  else
    if Y >= R.Bottom then
      Result := -1
    else
      Result := 0;
end;

{ TdxBoxLogPositionComparable }

constructor TdxBoxLogPositionComparable.Create(APieceTable: TdxCustomPieceTable; ALogPosition: TdxDocumentLogPosition);
begin
  FPieceTable := APieceTable;
  FLogPosition := ALogPosition;
end;

function TdxBoxLogPositionComparable.BoxStartAndLogPositionCompare(const Value: TdxBoxBase): Integer;
var
  AFirstPos: TdxDocumentModelPosition;
begin
  AFirstPos := Value.GetFirstPosition(PieceTable);
  Result := AFirstPos.LogPosition - LogPosition;
end;

function TdxBoxLogPositionComparable.BoxAndLogPositionCompare(const Value: TdxBoxBase): Integer;
var
  AFirstPos, ALastPos: TdxDocumentModelPosition;
begin
  AFirstPos := Value.GetFirstPosition(PieceTable);
  if LogPosition < AFirstPos.LogPosition then
    Result := 1
  else
  begin
    if LogPosition > AFirstPos.LogPosition then
    begin
      ALastPos := Value.GetLastPosition(PieceTable);
      if LogPosition <= ALastPos.LogPosition then
        Result := 0
      else
        Result := -1;
    end
    else
      Result := 0;
  end;
end;

{ TdxBoxAndFormatterPositionComparable }

constructor TdxBoxAndFormatterPositionComparable.Create(const AFormatterPosition: TdxFormatterPosition);
begin
  FFormatterPosition := AFormatterPosition;
end;

function TdxBoxAndFormatterPositionComparable.CompareTo(const Value: TdxBoxBase): Integer;
var
  AFirstPos, ALastPos: TdxFormatterPosition;
begin
  AFirstPos := Value.GetFirstFormatterPosition;
  if FFormatterPosition < AFirstPos then
    Result := 1
  else
    if FFormatterPosition > AFirstPos then
    begin
      ALastPos := Value.GetLastFormatterPosition;
      if FFormatterPosition <= ALastPos then
        Result := 0
      else
        Result := -1;
    end
    else
      Result := 0;
end;

end.
