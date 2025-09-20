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

unit dxChartLegend;

{$I cxVer.inc}
{$SCOPEDENUMS ON}


interface

uses
  Types, Classes, SysUtils, Windows, Graphics, ImgList, Generics.Defaults, Generics.Collections, RTLConsts, Controls,
  dxCore, dxCoreClasses, dxGDIPlusClasses, cxGraphics, dxCoreGraphics, cxGeometry, cxCustomCanvas, dxDPIAwareUtils,
  dxCustomHint, cxControls, cxLookAndFeelPainters, cxClasses, dxTypeHelpers,
  dxChartCore, cxLookAndFeels;

type
  TdxChartLegendItem = class;
  TdxChartLegendViewData = class;
  TdxChartLegendViewInfo = class;

  { TdxChartLegendItemGlyph }

  TdxChartLegendItemGlyph = class(TPersistent) // for internal use
  strict private
    FImage: TdxSmartImage;
    FImageIndex: TcxImageIndex;
    FLegendItem: TdxChartLegendItem;
    FMode: TcxImageFitMode;

    procedure SetImage(AValue: TdxSmartImage);
    procedure SetImageIndex(AValue: TcxImageIndex);
    procedure SetMode(AValue: TcxImageFitMode);
  protected
    procedure Changed; virtual;
    procedure DoAssign(ASource: TPersistent); virtual;
    function GetImages: TCustomImageList; virtual;
    function GetSize(AScaleFactor: TdxScaleFactor): TdxSizeF;
    procedure ImageChanged(Sender: TObject);

    property Images: TCustomImageList read GetImages;
    property LegendItem: TdxChartLegendItem read FLegendItem;
  public
    constructor Create(AItem: TdxChartLegendItem); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function IsAssigned: Boolean;
  published
    property Image: TdxSmartImage read FImage write SetImage;
    property ImageIndex: TcxImageIndex read FImageIndex write SetImageIndex default -1;
    property Mode: TcxImageFitMode read FMode write SetMode default ifmNormal;
  end;

  { TdxChartLegendItemViewInfo }

  TdxChartLegendItemViewInfo = class(TdxChartCustomItemViewInfo)  // for internal use
  private const
    CheckBoxSubAreaCode = 1;
    CaptionSubAreaCode = 2;
  strict private
    FCheckBoxColor: TdxAlphaColor;
    FOwner: TdxChartLegendItem;
    FTextColor: TdxAlphaColor;

    FConstraintsBounds: TdxRectF;
    FCaptionBounds: TdxRectF;
    FCheckBoxBounds: TdxRectF;
    FImageBounds: TdxRectF;

    FGlyph: TdxFastDIB;
    FGlyphCache: TcxCanvasBasedImage;
    FTextLayout: TcxCanvasBasedTextLayout;

    function GetLegendViewInfo: TdxChartLegendViewInfo; inline;
    function GetScaleFactor: TdxScaleFactor;
  protected
    procedure DoCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DoCalculateCaption(ACanvas: TcxCustomCanvas; const R: TdxRectF);
    procedure DoCalculateColors;
    procedure DoCalculateImage(ACanvas: TcxCustomCanvas; const R: TdxRectF);
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
    procedure DoRightToLeftConversion(const AParentBounds: TdxRectF); virtual;
    procedure DrawCaption(ACanvas: TcxCustomCanvas);
    procedure DrawCheckBox(ACanvas: TcxCustomCanvas);
    procedure DrawImage(ACanvas: TcxCustomCanvas);
    function GetHitElement(const P: TdxPointF): IdxChartHitTestElement; override;
    procedure Initialize(const AVisibleBounds, AConstraintsBounds: TdxRectF); virtual;
    procedure UpdateTextColors; override;
    
    property Owner: TdxChartLegendItem read FOwner;
    property LegendViewInfo: TdxChartLegendViewInfo read GetLegendViewInfo;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
    property TextLayout: TcxCanvasBasedTextLayout read FTextLayout;
  public
    constructor Create(AOwner: TdxChartLegendItem); virtual;
    destructor Destroy; override;
    procedure Offset(const ADistance: TdxPointF); override;

    property CaptionBounds: TdxRectF read FCaptionBounds;
    property CheckBoxBounds: TdxRectF read FCheckBoxBounds;
    property CheckBoxColor: TdxAlphaColor read FCheckBoxColor;
    property ImageBounds: TdxRectF read FImageBounds;
    property TextColor: TdxAlphaColor read FTextColor;
  end;


  { TdxChartLegendItemHitCheckBox }

  TdxChartLegendItemHitCheckBox = class(TdxChartWeakReferenceHitElement,
                                        IdxChartHitTestClickableElement)  // for internal use
  strict private
    function GetItem: TdxChartLegendItem;
    property Item: TdxChartLegendItem read GetItem;
  protected
    // IdxChartHitTestClickableElement
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
  public
    constructor Create(ALegendItem: TdxChartLegendItem);
  end;

  { TdxChartLegendItemHitCaption }

  TdxChartLegendItemHitCaption = class(TdxChartHintableCaptionHitElement) // for internal use
  strict private
    FViewInfo: TdxChartLegendItemViewInfo;
  protected
    function GetAppearance: TdxChartVisualElementAppearance; override;
  public
    constructor Create(AViewInfo: TdxChartLegendItemViewInfo); reintroduce;
  end;

  { TdxChartLegendItem }

  TdxChartLegendItem = class
  strict private
    FGlyph: TdxChartLegendItemGlyph;
    FItem: IdxChartLegendItem;
    FItemViewInfo: TdxChartLegendItemViewInfo;
    FOwner: TdxChartLegendViewData;

    function GetCaption: string;
    function GetChecked: Boolean;
    function GetItemViewInfo: TdxChartLegendItemViewInfo;
    function GetLegend: TdxChartCustomLegend;
  protected
    function CanSetChecked: Boolean;
    procedure Changed;
    function CreateGlyph: TdxChartLegendItemGlyph; virtual;
    function HasItemViewInfo: Boolean;
    procedure SetChecked(AValue: Boolean);

    property Owner: TdxChartLegendViewData read FOwner;
    property Glyph: TdxChartLegendItemGlyph read FGlyph;
    property Item: IdxChartLegendItem read FItem;
    property ItemViewInfo: TdxChartLegendItemViewInfo read GetItemViewInfo;
  public
    constructor Create(AOwner: TdxChartLegendViewData; const AItem: IdxChartLegendItem); virtual;  //for internal use
    destructor Destroy; override;

    property Caption: string read GetCaption;
    property Checked: Boolean read GetChecked;
    property Legend: TdxChartCustomLegend read GetLegend;
  end;

  { TdxChartLegendViewData }

  TdxChartLegendViewData = class(TdxChartLegendCustomViewData) // for internal use
  strict private
    FItems: TdxFastObjectList;
    FLegend: TdxChartCustomLegend;

    function GetItemCount: Integer;
    function GetItem(AIndex: Integer): TdxChartLegendItem; inline;
    function GetViewInfo: TdxChartLegendViewInfo; 
  protected
    procedure AddItem(const AItem: IdxChartLegendItem); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;

    property ViewInfo: TdxChartLegendViewInfo read GetViewInfo;
  public
    constructor Create(AOwner: TdxChartCustomLegend); virtual;
    destructor Destroy; override;

    property ItemCount: Integer read GetItemCount;
    property Items[Index: Integer]: TdxChartLegendItem read GetItem;
    property Legend: TdxChartCustomLegend read FLegend;
  end;

  { TdxChartLegendViewInfo }

  TdxChartLegendViewInfo = class(TdxChartVisualElementCustomViewInfo) // for internal use
  strict private
    FLegend: TdxChartCustomLegend;
    FItems: TdxFastObjectList;

    FActualCaptionOffset: Single;
    FActualCheckBoxSize: TdxSizeF;
    FActualImageOffset: Single;
    FActualImageSize: TdxSizeF;
    FActualItemIndent: TdxSizeF;
    FActualLineHeight: Single;
    FItemBoxBounds: TdxRectF;

    FShowCaptions: Boolean;
    FShowCheckBoxes: Boolean;
    FShowImages: Boolean;

    procedure AdjustCalculatedContent(ACanvas: TcxCustomCanvas);
    function GetActualFont: TcxCanvasBasedFont; inline;
    function GetAppearance: TdxChartLegendAppearance; inline;
    function GetItem(AIndex: Integer): TdxChartLegendItemViewInfo; inline;
    function GetItemCount: Integer;
    function GetTitle: TdxChartVisualElementTitle;
    function GetViewData: TdxChartLegendViewData;
  protected
    function CalculateHitTest(AHitTest: TdxChartHitTestEngine; const P: TdxPointF): Boolean; override;
    procedure Clear;
    procedure DoCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DoCalculateMetrics(ACanvas: TcxCustomCanvas);
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
    procedure DoRightToLeftConversion;
    procedure FreeCanvasBasedResources; override;
    function GetHitElement(const P: TdxPointF): IdxChartHitTestElement; override;
    procedure UpdateTextColors; override;
    
    property ItemBoxBounds: TdxRectF read FItemBoxBounds;
    property ItemList: TdxFastObjectList read FItems;
  public
    constructor Create(AOwner: TdxChartCustomLegend); reintroduce; virtual;
    destructor Destroy; override;
    procedure UpdateBounds(const ABounds: TdxRectF); override;

    property ActualCaptionOffset: Single read FActualCaptionOffset;
    property ActualCheckBoxSize: TdxSizeF read FActualCheckBoxSize;
    property ActualFont: TcxCanvasBasedFont read GetActualFont;
    property ActualImageOffset: Single read FActualImageOffset;
    property ActualImageSize: TdxSizeF read FActualImageSize;
    property ActualItemIndent: TdxSizeF read FActualItemIndent;
    property Appearance: TdxChartLegendAppearance read GetAppearance;
    property ItemCount: Integer read GetItemCount;
    property Items[Index: Integer]: TdxChartLegendItemViewInfo read GetItem;
    property Legend: TdxChartCustomLegend read FLegend;
    property ShowCaptions: Boolean read FShowCaptions;
    property ShowCheckBoxes: Boolean read FShowCheckBoxes;
    property ShowImages: Boolean read FShowImages;
    property ActualLineHeight: Single read FActualLineHeight;
    property Title: TdxChartVisualElementTitle read GetTitle;
    property ViewData: TdxChartLegendViewData read GetViewData;
  end;

implementation

uses
  Math, cxDrawTextUtils;

const
  dxThisUnitName = 'dxChartLegend';

type
  TdxChartCustomLegendAccess = class(TdxChartCustomLegend);
  TdxChartLegendAppearanceAccess = class(TdxChartLegendAppearance);
  TdxChartTitleAccess = class(TdxChartVisualElementTitle);
  TdxChartTitleViewInfoAccess = class(TdxChartVisualElementTitleViewInfo);
  TdxChartTitleAppearanceAccess = class(TdxChartVisualElementTitleAppearance);

type

  { TdxChartLegendLayoutCalculatorItemsColumn }

  TdxChartLegendLayoutCalculatorItemsColumn = class
  private
    FItems: TdxFastObjectList;

    function GetItem(AIndex: Integer): TdxChartLegendItemViewInfo;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function Count: Integer;
    function GetLeft: Single;
    function GetWidth: Single;
    procedure Offset(ADistance: TdxPointF);
    procedure SetDirty;

    property ItemList: TdxFastObjectList read FItems;
    property Items[Index: Integer]: TdxChartLegendItemViewInfo read GetItem;
  end;

  {TdxChartLegendItemLayoutCalculator }

  TdxChartLegendItemLayoutCalculator = class
  private
    FCanvas: TcxCustomCanvas;
    FColumns: TObjectList<TdxChartLegendLayoutCalculatorItemsColumn>;
    FDirection: TdxChartLegendDirection;
    FEvaluatedRowCount: Integer;
    FHasItems: Boolean;
    FItemBoxBounds: TdxRectF;
    FMaxCaptionWidth: Single;
    FOwner: TdxChartLegendViewInfo;

    function GetCaptionOffset: Single;
    function GetCheckBoxSize: TdxSizeF;
    function GetImageOffset: Single;
    function GetImageSize: TdxSizeF;
    function GetLegend: TdxChartCustomLegend;
    function GetLegendItem(AIndex: Integer): TdxChartLegendItem; inline;
    function GetLegendItemCount: Integer;
    procedure SetCellsDirty(const AIndexFrom: Integer);
  protected
    function AddColumn: TdxChartLegendLayoutCalculatorItemsColumn;
    procedure CalculateAsHorizontal;
    procedure CalculateAsVertical;
    procedure DoCalculateAsHorizontal(AMaxColumnCount: Integer);
    procedure EvaluateLayout;
    function GetCalculatedCell(ALegendItem: TdxChartLegendItem; const AConstraints: TdxRectF): TdxChartLegendItemViewInfo;
    function IsReverse: Boolean;
    function IsVertical: Boolean;

    property Canvas: TcxCustomCanvas read FCanvas;
    property Columns: TObjectList<TdxChartLegendLayoutCalculatorItemsColumn> read FColumns;
    property ItemBoxBounds: TdxRectF read FItemBoxBounds;
    property Legend: TdxChartCustomLegend read GetLegend;
    property Owner: TdxChartLegendViewInfo read FOwner;
  public
    constructor Create(AOwner: TdxChartLegendViewInfo; ACanvas: TcxCustomCanvas;
     const AItemBoxBounds: TdxRectF; ADirection: TdxChartLegendDirection);
    destructor Destroy; override;
    procedure Calculate;

    property CaptionOffset: Single read GetCaptionOffset;
    property CheckBoxSize: TdxSizeF read GetCheckBoxSize;
    property ImageOffset: Single read GetImageOffset;
    property ImageSize: TdxSizeF read GetImageSize;
    property LegendItemCount: Integer read GetLegendItemCount;
  end;

{ TdxChartLegendLayoutCalculatorItemsColumn }

constructor TdxChartLegendLayoutCalculatorItemsColumn.Create;
begin
  inherited Create;
  FItems := TdxFastObjectList.Create(False);
end;

destructor TdxChartLegendLayoutCalculatorItemsColumn.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

function TdxChartLegendLayoutCalculatorItemsColumn.Count: Integer;
begin
  Result := FItems.Count;
end;

function TdxChartLegendLayoutCalculatorItemsColumn.GetItem(AIndex: Integer): TdxChartLegendItemViewInfo;
begin
  Result := TdxChartLegendItemViewInfo(FItems[AIndex])
end;

function TdxChartLegendLayoutCalculatorItemsColumn.GetLeft: Single;
begin
  Result := 0;
  if Count > 0 then
    Result := Items[0].Bounds.Left;
end;

function TdxChartLegendLayoutCalculatorItemsColumn.GetWidth: Single;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    Result := Max(Result, Items[I].Bounds.Width);
end;

procedure TdxChartLegendLayoutCalculatorItemsColumn.Offset(ADistance: TdxPointF);
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
    Items[I].Offset(ADistance);
end;

procedure TdxChartLegendLayoutCalculatorItemsColumn.SetDirty;
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
    Items[I].Dirty := True;
end;

{TdxChartLegendItemLayoutCalculator }

constructor TdxChartLegendItemLayoutCalculator.Create(AOwner: TdxChartLegendViewInfo; ACanvas: TcxCustomCanvas;
  const AItemBoxBounds: TdxRectF; ADirection: TdxChartLegendDirection);
begin
  inherited Create;
  FOwner := AOwner;
  FCanvas := ACanvas;
  FItemBoxBounds := AItemBoxBounds;
  FDirection := ADirection;
  FColumns := TObjectList<TdxChartLegendLayoutCalculatorItemsColumn>.Create;
  FMaxCaptionWidth := -1;  
end;

destructor TdxChartLegendItemLayoutCalculator.Destroy;
begin
  FreeAndNil(FColumns);
  inherited Destroy;
end;

function TdxChartLegendItemLayoutCalculator.AddColumn: TdxChartLegendLayoutCalculatorItemsColumn;
begin
  Result := TdxChartLegendLayoutCalculatorItemsColumn.Create;
  Columns.Add(Result);
end;

procedure TdxChartLegendItemLayoutCalculator.Calculate;
var
  I: Integer;
  ACell: TdxChartLegendItemViewInfo;
begin
  EvaluateLayout;
  if FHasItems then
    if IsVertical then
      CalculateAsVertical
    else
      CalculateAsHorizontal;

  for I := 0 to LegendItemCount - 1 do
  begin
    ACell := GetLegendItem(I).ItemViewInfo;
    if (ACell <> nil) and not ACell.Dirty and ACell.ActuallyVisible then
      Owner.ItemList.Add(ACell)
    else
      Break;
  end;
end;

procedure TdxChartLegendItemLayoutCalculator.CalculateAsHorizontal;

  function GetLastRowItemsCount: Integer;
  var
    I, AFirstColumnItemsCount: Integer;
  begin
    Result := 1;
    AFirstColumnItemsCount := Columns[0].Count;
    for I := 1 to Columns.Count - 1 do
      if Columns[I].Count = AFirstColumnItemsCount then
        Inc(Result)
      else
        Break;
  end;

var
  AColumnCount, ARowCount: Integer;
  APrevColumnCount, APrevRowCount: Integer;
  AIsReady, ATryToShrink: Boolean;
begin
  APrevColumnCount := LegendItemCount;
  APrevRowCount := 1;
  AColumnCount := APrevColumnCount;
  AIsReady := False;
  ATryToShrink := False;
  while not AIsReady do
  begin
    DoCalculateAsHorizontal(AColumnCount);
    ARowCount := Columns[0].Count;
    if ARowCount = 0 then
      Break;
    AIsReady := (ARowCount = 1) or (Columns.Count = APrevColumnCount);
    if not AIsReady then
    begin
      AIsReady := ATryToShrink and (ARowCount > APrevRowCount);
      if AIsReady then
        DoCalculateAsHorizontal(APrevColumnCount)
      else
      begin
        AIsReady := Columns.Count - GetLastRowItemsCount < ARowCount;
        if not AIsReady then
        begin
          APrevRowCount := ARowCount;
          APrevColumnCount := Columns.Count;
          AColumnCount := APrevColumnCount - 1;
        end;
      end;
    end;
    ATryToShrink := True;
  end;
end;

procedure TdxChartLegendItemLayoutCalculator.CalculateAsVertical;
var
  R: TdxRectF;
  I, ARowNum, AMaxRight: Integer;
  ACurrentColumn: TdxChartLegendLayoutCalculatorItemsColumn;
  ALegendItem: TdxChartLegendItem;
  ACell: TdxChartLegendItemViewInfo;
begin
  R := ItemBoxBounds;
  ACurrentColumn := AddColumn;
  ARowNum := 0;
  AMaxRight := Trunc(R.Left);
  for I := 0 to LegendItemCount - 1 do
  begin
    ALegendItem := GetLegendItem(I);
    Inc(ARowNum);
    If ARowNum > FEvaluatedRowCount then
    begin
      ARowNum := 1;
      ACurrentColumn := AddColumn;
    end;
    if (ARowNum = 1) and (FMaxCaptionWidth >= 0) then
    begin
      if Columns.Count > 1 then
      begin
        R.Left := AMaxRight + Owner.ActualItemIndent.Width;
        AMaxRight := Trunc(R.Left);
      end;
      R.Right := R.Left + CheckBoxSize.Width + ImageOffset + ImageSize.Width + CaptionOffset + FMaxCaptionWidth;
      R.Top := ItemBoxBounds.Top;
    end;

    ACell := GetCalculatedCell(ALegendItem, R);
    if ACell.Bounds.Right > ItemBoxBounds.Right then
    begin
      ACell.Dirty := True;
      ACurrentColumn.SetDirty;
      Columns.Remove(ACurrentColumn);
      SetCellsDirty(I + 1);
      Break;
    end;
    ACurrentColumn.ItemList.Add(ACell);

    R.Top := ACell.Bounds.Bottom + Owner.ActualItemIndent.cy;
    AMaxRight := Max(AMaxRight, Trunc(ACell.Bounds.Right));
  end;
end;

procedure TdxChartLegendItemLayoutCalculator.DoCalculateAsHorizontal(AMaxColumnCount: Integer);

  procedure OffsetColumns(AStartNum: Integer; DX: Single);
  var
    I: Integer;
  begin
    for I := AStartNum - 1 to Columns.Count - 1 do
      Columns[I].Offset(dxPointF(DX, 0));
  end;

  function IsContentOverBoundsWhenCellPlaceInColumn(AItem: TdxChartLegendItemViewInfo; AColumnNum: Integer): Boolean;
  var
    AColumn, ALastColumn: TdxChartLegendLayoutCalculatorItemsColumn;
    AColumnWidth, AItemWidth: Single;
  begin
    Result := False;
    AColumn := Columns[AColumnNum - 1];
    AColumnWidth := AColumn.GetWidth;
    AItemWidth := AItem.Bounds.Width;
    if AItemWidth > AColumnWidth then
    begin
      OffsetColumns(AColumnNum + 1, AItemWidth - AColumnWidth);
      Result := Trunc(AItem.Bounds.Right) > ItemBoxBounds.Right;
      if not Result then
      begin
        ALastColumn := Columns[Columns.Count - 1];
        Result := ALastColumn.GetLeft + ALastColumn.GetWidth > ItemBoxBounds.Right;
      end;
    end;
  end;

var
  R, R1: TdxRectF;
  I, AColumnNum: Integer;
  ALegendItem: TdxChartLegendItem;
  ACell: TdxChartLegendItemViewInfo;
  AColumn: TdxChartLegendLayoutCalculatorItemsColumn;
  AIsReady: Boolean;
begin
  AIsReady := False;
  ACell := nil;
  while not AIsReady do
  begin
    if ACell <> nil then
      ACell.Dirty := True;
    Columns.Clear;
    R := ItemBoxBounds;
    AColumnNum := 0;
    AColumn := nil;
    for I := 0 to LegendItemCount - 1 do
    begin
      ALegendItem := GetLegendItem(I);
      Inc(AColumnNum);
      if AColumnNum > AMaxColumnCount then
      begin
        AColumnNum := 1;
        AColumn := Columns[AColumnNum - 1];
        R.Left := AColumn.GetLeft;
        R.Top := ACell.Bounds.Bottom + Owner.ActualItemIndent.cy;
      end
      else
      begin
        if AColumnNum <= Columns.Count then
        begin
          AColumn := Columns[AColumnNum - 1];
          R.Left := AColumn.GetLeft;
        end
        else
        begin
          if Columns.Count > 0 then
            R.Left := AColumn.GetLeft + AColumn.GetWidth + Owner.ActualItemIndent.Width;
          AColumn := AddColumn;
        end
      end;
      if (R.Top > ItemBoxBounds.Bottom) or SameValue(R.Top, ItemBoxBounds.Bottom) then
      begin
        AIsReady := True;
        SetCellsDirty(I);
        Break;
      end;
      R1 := R;
      if AMaxColumnCount < LegendItemCount then
        R1.Right := R1.Left + CheckBoxSize.Width + ImageOffset + ImageSize.Width + CaptionOffset + FMaxCaptionWidth;
      ACell := GetCalculatedCell(ALegendItem, R1);
      if IsContentOverBoundsWhenCellPlaceInColumn(ACell, AColumnNum) and (AMaxColumnCount > 1) then
      begin
        AMaxColumnCount := Max(1, Columns.Count - 1);
        Break;
      end;
      AColumn.ItemList.Add(ACell);
      AIsReady := I = LegendItemCount - 1;
    end;
  end;
end;

procedure TdxChartLegendItemLayoutCalculator.EvaluateLayout;

  function GetColumnCount(const ATotalCount, ARowCount: Integer): Integer;
  begin
    Result := ATotalCount div ARowCount;
    Inc(Result, Integer(ATotalCount mod ARowCount > 0));
  end;

var
  AColumnCount: Integer;
begin
  FHasItems := (LegendItemCount > 0) and (Owner.Legend.ShowCheckBoxes or Owner.Legend.ShowImages or Owner.Legend.ShowCaptions);
  if FHasItems then
    if IsVertical then
    begin
      FEvaluatedRowCount := Max(1, Trunc((ItemBoxBounds.Bottom + Owner.ActualItemIndent.cy - ItemBoxBounds.Top) /
        (Owner.ActualLineHeight + Owner.ActualItemIndent.cy)));
      AColumnCount := GetColumnCount(LegendItemCount, FEvaluatedRowCount);
      if AColumnCount > 1 then
        FMaxCaptionWidth := Owner.Legend.MaxCaptionWidth;
      while (FEvaluatedRowCount > 1) and (AColumnCount = GetColumnCount(LegendItemCount, FEvaluatedRowCount - 1)) do
        Dec(FEvaluatedRowCount);
    end
    else
      FMaxCaptionWidth := Owner.Legend.MaxCaptionWidth
  else
    SetCellsDirty(0);
end;

function TdxChartLegendItemLayoutCalculator.GetCaptionOffset: Single;
begin
  Result := Owner.ActualCaptionOffset;
end;

function TdxChartLegendItemLayoutCalculator.GetCheckBoxSize: TdxSizeF;
begin
  Result := Owner.ActualCheckBoxSize;
end;

function TdxChartLegendItemLayoutCalculator.GetImageOffset: Single;
begin
  Result := Owner.ActualImageOffset;
end;

function TdxChartLegendItemLayoutCalculator.GetImageSize: TdxSizeF;
begin
  Result := Owner.ActualImageSize;
end;

function TdxChartLegendItemLayoutCalculator.GetCalculatedCell(ALegendItem: TdxChartLegendItem;
  const AConstraints: TdxRectF): TdxChartLegendItemViewInfo;
begin
  Result := ALegendItem.ItemViewInfo;
  Result.Initialize(ItemBoxBounds, AConstraints);
  Result.Calculate(Canvas);
end;

function TdxChartLegendItemLayoutCalculator.GetLegend: TdxChartCustomLegend;
begin
  Result := Owner.Legend;
end;

function TdxChartLegendItemLayoutCalculator.GetLegendItem(AIndex: Integer): TdxChartLegendItem;
begin
  if IsReverse then
    Result := Owner.ViewData.Items[LegendItemCount - 1 - AIndex]
  else
    Result := Owner.ViewData.Items[AIndex];
end;

function TdxChartLegendItemLayoutCalculator.GetLegendItemCount: Integer;
begin
  Result := Owner.ViewData.ItemCount;
end;

function TdxChartLegendItemLayoutCalculator.IsReverse: Boolean;
begin
  Result := FDirection in [TdxChartLegendDirection.BottomToTop, TdxChartLegendDirection.RightToLeft];
end;

function TdxChartLegendItemLayoutCalculator.IsVertical: Boolean;
begin
  Result := FDirection in [TdxChartLegendDirection.TopToBottom, TdxChartLegendDirection.BottomToTop];
end;

procedure TdxChartLegendItemLayoutCalculator.SetCellsDirty(const AIndexFrom: Integer);
var
  I: Integer;
  ALegendItem: TdxChartLegendItem;
begin
  for I := AIndexFrom to LegendItemCount - 1 do
  begin
    ALegendItem := GetLegendItem(I);
    if ALegendItem.HasItemViewInfo then
      ALegendItem.ItemViewInfo.Dirty := True
    else
      Break;
  end;
end;

{ TdxChartLegendItemGlyph }

constructor TdxChartLegendItemGlyph.Create(AItem: TdxChartLegendItem);
begin
  inherited Create;
  FLegendItem := AItem;
  FImage := TdxSmartImage.Create;
  FImage.OnChange := ImageChanged;
  FImageIndex := -1;
  FMode := ifmNormal;
end;

destructor TdxChartLegendItemGlyph.Destroy;
begin
  FreeAndNil(FImage);
  inherited Destroy;
end;

procedure TdxChartLegendItemGlyph.Assign(Source: TPersistent);
begin
  if Source is TdxChartLegendItemGlyph then
    DoAssign(Source)
  else
    inherited;
end;

function TdxChartLegendItemGlyph.IsAssigned: Boolean;
begin
  Result := IsImageAssigned(Image, Images, ImageIndex);
end;

procedure TdxChartLegendItemGlyph.DoAssign(ASource: TPersistent);
begin
  Image := TdxChartLegendItemGlyph(ASource).Image;
  ImageIndex := TdxChartLegendItemGlyph(ASource).ImageIndex;
  Mode := TdxChartLegendItemGlyph(ASource).Mode;
end;

procedure TdxChartLegendItemGlyph.Changed;
begin
  LegendItem.Changed;
end;

function TdxChartLegendItemGlyph.GetImages: TCustomImageList;
begin
  Result := TdxChartCustomLegendAccess(LegendItem.Legend).Images;
end;

function TdxChartLegendItemGlyph.GetSize(AScaleFactor: TdxScaleFactor): TdxSizeF;
begin
  Result := dxGetImageSize(Image, Images, ImageIndex, AScaleFactor);
end;

procedure TdxChartLegendItemGlyph.ImageChanged(Sender: TObject);
begin
  Changed;
end;

procedure TdxChartLegendItemGlyph.SetImage(AValue: TdxSmartImage);
begin
  if AValue <> nil then
    FImage.Assign(AValue)
  else
    FImage.Clear;
end;

procedure TdxChartLegendItemGlyph.SetImageIndex(AValue: TcxImageIndex);
begin
  if FImageIndex <> AValue then
  begin
    FImageIndex := AValue;
    Changed;
  end;
end;

procedure TdxChartLegendItemGlyph.SetMode(AValue: TcxImageFitMode);
begin
  if FMode <> AValue then
  begin
    FMode := AValue;
    Changed;
  end;
end;

{ TdxChartLegendItemViewInfo }

constructor TdxChartLegendItemViewInfo.Create(AOwner: TdxChartLegendItem);
begin
  inherited Create;
  FOwner := AOwner;
end;

destructor TdxChartLegendItemViewInfo.Destroy;
begin
  FreeAndNil(FTextLayout);
  inherited Destroy;
end;

procedure TdxChartLegendItemViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);
var
  AImageArea: TdxRectF;
  R: TdxRectF;
  P: TdxPointF;
  AActualCaptionOffset: Single;
begin
  DoCalculateColors;

  R := FConstraintsBounds;
  R.Bottom := R.Top + LegendViewInfo.ActualLineHeight;
  FCheckBoxBounds := cxRectSetSizeF(R, LegendViewInfo.ActualCheckBoxSize);
  R.Left := FCheckBoxBounds.Right + LegendViewInfo.ActualImageOffset;
  AImageArea := cxRectSetSizeF(R, LegendViewInfo.ActualImageSize);
  DoCalculateImage(ACanvas, AImageArea);
  AActualCaptionOffset := 0;
  if Owner.Caption <> '' then
    AActualCaptionOffset := LegendViewInfo.ActualCaptionOffset;
  R.Left := AImageArea.Right + AActualCaptionOffset;
  DoCalculateCaption(ACanvas, R);
  R.Right := FCaptionBounds.Right;
  R.Left := FConstraintsBounds.Left;
  SetBounds(R, VisibleBounds);

  P := Bounds.CenterPoint;
  FCheckBoxBounds.Offset(0, P.Y - FCheckBoxBounds.CenterPoint.Y);
  FImageBounds.Offset(0, P.Y - FImageBounds.CenterPoint.Y);
  FCaptionBounds.Offset(0, P.Y - FCaptionBounds.CenterPoint.Y);
end;

procedure TdxChartLegendItemViewInfo.DoCalculateCaption(ACanvas: TcxCustomCanvas; const R: TdxRectF);
const
  AlignmentMap: array[Boolean] of Integer = (CXTO_LEFT, CXTO_RIGHT or CXTO_RTLREADING);
var
  ACaptionWidth: Single;
  ATextFlags: Integer;
begin
  if LegendViewInfo.ShowCaptions and (Owner.Caption <> '') then
  begin
    ATextFlags := AlignmentMap[LegendViewInfo.UseRightToLeftReading] or CXTO_SINGLELINE;
    if not ACanvas.CheckIsValid(FTextLayout) then
    begin
      FreeAndNil(FTextLayout);
      FTextLayout := ACanvas.CreateTextLayout;
    end;
    FTextLayout.SetColor(TextColor);
    FTextLayout.SetFont(LegendViewInfo.ActualFont);
    FTextLayout.SetText(Owner.Caption);
    FTextLayout.SetFlags(ATextFlags);
    FTextLayout.SetLayoutConstraints(R);
    ACaptionWidth := Min(FTextLayout.MeasureSizeF.Width, R.Width);
    FTextLayout.SetFlags(ATextFlags or CXTO_END_ELLIPSIS);
  end
  else
  begin
    FreeAndNil(FTextLayout);
    ACaptionWidth := 0;
  end;
  FCaptionBounds := cxRectSetSizeF(R, dxSizeF(Max(ACaptionWidth, 0), LegendViewInfo.ActualFont.LineHeight));
end;

procedure TdxChartLegendItemViewInfo.DoCalculateColors;
begin
  FCheckBoxColor := Owner.Item.GetColor;
  FTextColor := LegendViewInfo.Appearance.ActualTextColor;
end;

procedure TdxChartLegendItemViewInfo.DoCalculateImage(ACanvas: TcxCustomCanvas; const R: TdxRectF);
var
  AGlyph: TdxChartLegendItemGlyph;
begin
  FreeAndNil(FGlyphCache);
  if LegendViewInfo.ShowImages then
  begin
    AGlyph := Owner.Glyph;
    if (AGlyph <> nil) and AGlyph.IsAssigned then
      FImageBounds := cxGetImageRect(R, AGlyph.GetSize(ScaleFactor), AGlyph.Mode)
    else
    begin
      FreeAndNil(FGlyph);
      FImageBounds := R;
    end;
  end
  else
  begin
    FreeAndNil(FGlyph);
    FImageBounds := TdxRectF.Null;
  end;
end;

procedure TdxChartLegendItemViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
begin
  if not CheckBoxBounds.IsEmpty then
    DrawCheckBox(ACanvas);
  if not ImageBounds.IsEmpty then
    DrawImage(ACanvas);
  if not CaptionBounds.IsEmpty then
    DrawCaption(ACanvas);
end;

procedure TdxChartLegendItemViewInfo.DoRightToLeftConversion(const AParentBounds: TdxRectF);
begin
  if Dirty then
    Exit;
  SetBounds(TdxRightToLeftLayoutConverter.ConvertRect(FBounds, AParentBounds), VisibleBounds);
  FCheckBoxBounds := TdxRightToLeftLayoutConverter.ConvertRect(FCheckBoxBounds, AParentBounds);
  FImageBounds := TdxRightToLeftLayoutConverter.ConvertRect(FImageBounds, AParentBounds);
  FCaptionBounds := TdxRightToLeftLayoutConverter.ConvertRect(FCaptionBounds, AParentBounds);
  Dirty := False;
end;

procedure TdxChartLegendItemViewInfo.DrawCaption(ACanvas: TcxCustomCanvas);
begin
  FTextLayout.Draw(CaptionBounds.DeflateToTRect);
end;

procedure TdxChartLegendItemViewInfo.DrawCheckBox(ACanvas: TcxCustomCanvas);
const
  StateMap: array[Boolean] of TcxButtonState = (cxbsNormal, cxbsDisabled);
var
  ABounds: TRect;
  APainter: TcxCustomLookAndFeelPainter;

  function GetPainter: TcxCustomLookAndFeelPainter;
  var
    ALookAndFeel: TcxLookAndFeel;
  begin
    ALookAndFeel := TdxChartLegendAppearanceAccess(LegendViewInfo.Appearance).Chart.LookAndFeel;
    if ALookAndFeel.NativeStyle then
      Result := cxLookAndFeelPaintersManager.GetPainter(lfsFlat)
    else
      Result := ALookAndFeel.Painter;
  end;

begin
  ABounds.InitSize(Round(CheckBoxBounds.Left), Round(CheckBoxBounds.Top), Round(CheckBoxBounds.Width), Round(CheckBoxBounds.Height));
  ACanvas.EnableAntialiasing(False);
  ACanvas.FrameRect(ABounds, CheckBoxColor, ScaleFactor.Apply(1));
  ACanvas.RestoreAntialiasing;
  APainter := GetPainter;
  if (ScaleFactor.TargetDPI <= dxDefaultDPI) or (APainter.LookAndFeelStyle = lfsSkin) or cxIsTouchModeEnabled then
    ABounds.Deflate(ScaleFactor.Apply(cxTextOffset))
  else
    ABounds.Deflate(ScaleFactor.Apply(1));
  ABounds.Offset(0, 1);
  APainter.DrawScaledCheck(ACanvas, ABounds, StateMap[Owner.CanSetChecked],
    Owner.Checked, dxAlphaColorToColor(CheckBoxColor), ScaleFactor, False);
end;

procedure TdxChartLegendItemViewInfo.DrawImage(ACanvas: TcxCustomCanvas);
begin
  if FGlyph <> nil then
    ACanvas.DrawBitmap(FGlyph, ImageBounds, afDefined, @FGlyphCache)
  else
    Owner.Item.DrawGlyph(ACanvas, ImageBounds);
end;

function TdxChartLegendItemViewInfo.GetHitElement(const P: TdxPointF): IdxChartHitTestElement;
begin
  if CheckBoxBounds.Contains(P) then
    Result := TdxChartLegendItemHitCheckBox.Create(Owner)
  else if CaptionBounds.Contains(P) then
    Result := TdxChartLegendItemHitCaption.Create(Self)
  else
    Result := TdxChartWeakReferenceHitElement.Create(Owner, TdxChartHitCode.LegendItem);
end;

function TdxChartLegendItemViewInfo.GetLegendViewInfo: TdxChartLegendViewInfo;
begin
  Result := Owner.Owner.ViewInfo;
end;

function TdxChartLegendItemViewInfo.GetScaleFactor: TdxScaleFactor;
begin
  Result := TdxChartLegendAppearanceAccess(LegendViewInfo.Appearance).ScaleFactor;
end;

procedure TdxChartLegendItemViewInfo.Initialize(const AVisibleBounds, AConstraintsBounds: TdxRectF);
begin
  SetBounds(Bounds, AVisibleBounds);
  FConstraintsBounds := AConstraintsBounds;
  Dirty := True;
end;

procedure TdxChartLegendItemViewInfo.Offset(const ADistance: TdxPointF);
begin
  inherited Offset(ADistance);
  FCheckBoxBounds.Offset(ADistance);
  FCaptionBounds.Offset(ADistance);
  FImageBounds.Offset(ADistance);
end;

procedure TdxChartLegendItemViewInfo.UpdateTextColors;
begin
  DoCalculateColors;
  if FTextLayout <> nil then
   FTextLayout.SetColor(FTextColor);
end;

{ TdxChartLegendItemHitCheckBox }

constructor TdxChartLegendItemHitCheckBox.Create(ALegendItem: TdxChartLegendItem);
begin
  inherited Create(ALegendItem, TdxChartHitCode.LegendItem, TdxChartLegendItemViewInfo.CheckBoxSubAreaCode);
end;

procedure TdxChartLegendItemHitCheckBox.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Item.SetChecked(not Item.Checked);
end;

procedure TdxChartLegendItemHitCheckBox.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
// do nothing
end;

function TdxChartLegendItemHitCheckBox.GetItem: TdxChartLegendItem;
begin
  Result := TdxChartLegendItem(GetChartElement);
end;

{ TdxChartLegendItemHitCaption }

constructor TdxChartLegendItemHitCaption.Create(AViewInfo: TdxChartLegendItemViewInfo);
var
  ALegendItem: TdxChartLegendItem;
  AEmbeddedHitElement: IdxChartHitTestElement;
begin
  FViewInfo := AViewInfo;
  ALegendItem := AViewInfo.Owner;
  AEmbeddedHitElement := TdxChartWeakReferenceHitElement.Create(ALegendItem, TdxChartHitCode.LegendItem, TdxChartLegendItemViewInfo.CaptionSubAreaCode);
  inherited Create(AEmbeddedHitElement, AViewInfo.CaptionBounds, AViewInfo.TextLayout.Text, AViewInfo.TextLayout.IsTruncated);
end;

function TdxChartLegendItemHitCaption.GetAppearance: TdxChartVisualElementAppearance;
begin
  Result := FViewInfo.Owner.Owner.Legend.Appearance;
end;

{ TdxChartLegendItem }

constructor TdxChartLegendItem.Create(AOwner: TdxChartLegendViewData; const AItem: IdxChartLegendItem);
begin
  inherited Create;
  FOwner := AOwner;
  FItem := AItem;
end;

destructor TdxChartLegendItem.Destroy;
begin
  cxClearObjectLinks(Self);
  FreeAndNil(FGlyph);
  FreeAndNil(FItemViewInfo);
  inherited Destroy;
end;

function TdxChartLegendItem.CanSetChecked: Boolean;
begin
  Result := Item.IsEnabled;
end;

procedure TdxChartLegendItem.Changed;
begin
  Owner.Dirty := True;
end;

function TdxChartLegendItem.CreateGlyph: TdxChartLegendItemGlyph;
begin
  Result := TdxChartLegendItemGlyph.Create(Self);
end;

function TdxChartLegendItem.HasItemViewInfo: Boolean;
begin
  Result := FItemViewInfo <> nil;
end;

procedure TdxChartLegendItem.SetChecked(AValue: Boolean);
begin
  if CanSetChecked then
    Item.SetChecked(AValue);
end;

function TdxChartLegendItem.GetCaption: string;
begin
  Result := Item.GetCaption;
end;

function TdxChartLegendItem.GetChecked: Boolean;
begin
  Result := Item.IsChecked;
end;

function TdxChartLegendItem.GetItemViewInfo: TdxChartLegendItemViewInfo;
begin
  if FItemViewInfo = nil then
    FItemViewInfo := TdxChartLegendItemViewInfo.Create(Self);
  Result := FItemViewInfo;
end;

function TdxChartLegendItem.GetLegend: TdxChartCustomLegend;
begin
  Result := Owner.Legend;
end;


{ TdxChartLegendViewData }

constructor TdxChartLegendViewData.Create(AOwner: TdxChartCustomLegend);
begin
  inherited Create();
  FLegend := TdxChartCustomLegend(AOwner);
  FItems := TdxFastObjectList.Create(True);
end;

destructor TdxChartLegendViewData.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TdxChartLegendViewData.AddItem(const AItem: IdxChartLegendItem);
begin
  FItems.Add(TdxChartLegendItem.Create(Self, AItem));
end;

procedure TdxChartLegendViewData.Clear;
begin
  FItems.Clear;
  Dirty := True;
end;

function TdxChartLegendViewData.IsEmpty: Boolean;
begin
  Result := ItemCount = 0;
end;

function TdxChartLegendViewData.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

function TdxChartLegendViewData.GetItem(AIndex: Integer): TdxChartLegendItem;
begin
  Result := TdxChartLegendItem(FItems.List[AIndex]);
end;

function TdxChartLegendViewData.GetViewInfo: TdxChartLegendViewInfo;
begin
  Result := TdxChartLegendViewInfo(TdxChartCustomLegendAccess(Legend).ViewInfo);
end;

{ TdxChartLegendViewInfo }

constructor TdxChartLegendViewInfo.Create(AOwner: TdxChartCustomLegend);
begin
  inherited Create(AOwner.Appearance);
  FLegend := AOwner;
  FItems := TdxFastObjectList.Create(False);
end;

destructor TdxChartLegendViewInfo.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

function TdxChartLegendViewInfo.CalculateHitTest(AHitTest: TdxChartHitTestEngine;
  const P: TdxPointF): Boolean;
var
  I: Integer;
begin
  Result := inherited CalculateHitTest(AHitTest, P);
  if not Result then
    Exit;
  if TdxChartTitleAccess(Title).ViewInfo <> nil then
    if TdxChartTitleViewInfoAccess(TdxChartTitleAccess(Title).ViewInfo).CalculateHitTest(AHitTest, P) then
      Exit;
  for I := 0 to ItemCount - 1 do
    if Items[I].CalculateHitTest(AHitTest, P) then
      Break;
end;

procedure TdxChartLegendViewInfo.Clear;
begin
  FItems.Clear;
end;

procedure TdxChartLegendViewInfo.AdjustCalculatedContent(ACanvas: TcxCustomCanvas);
var
  ABounds, R, AItemsContentWithPadding: TdxRectF;
  ATitle: TdxChartTitleAccess;
  ATitleViewInfo: TdxChartTitleViewInfoAccess;
  I: Integer;

  procedure AdjustWithTitle(var ABounds: TdxRectF);
  begin
    case ATitle.ActualDockPosition of
      TdxChartTitlePosition.Left:
      begin
        ABounds.Right := Min(Bounds.Right, ABounds.Right + Padding.Right + BorderThickness);
        ABounds.Bottom := Bounds.Bottom;
      end;
      TdxChartTitlePosition.Right:
        begin
          ABounds.Bottom := Bounds.Bottom;
          ABounds.Right := Min(Bounds.Right, ABounds.Right + ATitleViewInfo.Margins.Left +
            ATitleViewInfo.Bounds.Width + ATitleViewInfo.Margins.Right + Padding.Right + BorderThickness);
        end;
      TdxChartTitlePosition.Bottom:
      begin
        ABounds.Right := Bounds.Right;
        ABounds.Bottom := Min(Bounds.Bottom, ABounds.Bottom + ATitleViewInfo.Margins.Top +
            ATitleViewInfo.Bounds.Height + ATitleViewInfo.Margins.Bottom + Padding.Bottom + BorderThickness);
      end;
    else  
      begin
        ABounds.Right := Bounds.Right;
        ABounds.Bottom := Min(Bounds.Bottom, ABounds.Bottom + Padding.Bottom + BorderThickness);
      end;
    end;
  end;

  procedure UpdateTitleBounds(const ANewBounds: TdxRectF);
  var
    R: TdxRectF;
    ABorderThickness: Single;
  begin
    R := ANewBounds.Content(Padding);
    ABorderThickness := BorderThickness;
    R.SetMargins(dxRectF(-ABorderThickness, -ABorderThickness, ABorderThickness, ABorderThickness));
    ATitleViewInfo.UpdateBounds(R, ATitleViewInfo.VisibleBounds);
  end;

  procedure AdjustSize(var ABounds: TdxRectF);
  var
    ATitleMargins: TdxRectF;
    ATitleContentWithPadding: Single;
  begin
    ATitleMargins := cxMarginsCombine(ATitleViewInfo.Margins, ATitleViewInfo.Padding);
    ATitleMargins.SetMargins(dxRectF(-ATitleViewInfo.BorderThickness, -ATitleViewInfo.BorderThickness,
      -ATitleViewInfo.BorderThickness, -ATitleViewInfo.BorderThickness));
    if ATitle.ActualDockPosition in [TdxChartTitlePosition.Left, TdxChartTitlePosition.Right] then
    begin
      ATitleContentWithPadding := ATitleViewInfo.TextBounds.Height + ATitleMargins.Top + ATitleMargins.Bottom;
      if ATitleContentWithPadding > AItemsContentWithPadding.Height then
        ABounds.Bottom := Bounds.Bottom - (ContentBounds.Height - ATitleContentWithPadding)
      else
        ABounds.Bottom := AItemsContentWithPadding.Bottom + Padding.Bottom + BorderThickness;
    end
    else
    begin
      ATitleContentWithPadding := ATitleViewInfo.TextBounds.Width + ATitleMargins.Left + ATitleMargins.Right;
      if ATitleContentWithPadding > AItemsContentWithPadding.Width then
        ABounds.Right := Bounds.Right - (ContentBounds.Width - ATitleContentWithPadding)
      else
        ABounds.Right := AItemsContentWithPadding.Right + Padding.Right + BorderThickness;
    end;
    UpdateTitleBounds(ABounds);
  end;

  procedure AdjustWithoutItems(var ABounds: TdxRectF);
  var
    ATitleMargins: TdxRectF;
    ABorderThickness: Single;
  begin
    if ATitleViewInfo.ActuallyVisible then
    begin
      ATitleMargins := cxMarginsCombine(ATitleViewInfo.Margins, cxMarginsCombine(ATitleViewInfo.Padding, Padding));
      ABorderThickness := ATitleViewInfo.BorderThickness + BorderThickness;
      ATitleMargins.SetMargins(dxRectF(-ABorderThickness, -ABorderThickness, -ABorderThickness, -ABorderThickness));
      ABounds := cxRectInflate(ATitleViewInfo.TextBounds, ATitleMargins);
      UpdateTitleBounds(ABounds);
    end
    else
      ABounds := dxNullRectF;
  end;

begin
  ABounds := Bounds;
  ATitle := TdxChartTitleAccess(Title);
  ATitleViewInfo := TdxChartTitleViewInfoAccess(ATitle.ViewInfo);

  if ItemList.Count > 0 then
  begin
    R := Items[0].Bounds;
    ABounds.Right := R.Right;
    ABounds.Bottom := R.Bottom;
    for I := 1 to ItemList.Count - 1 do
    begin
      R := Items[I].Bounds;
      ABounds.Right := Max(ABounds.Right, R.Right);
      ABounds.Bottom := Max(ABounds.Bottom, R.Bottom);
    end;
    if not ATitleViewInfo.ActuallyVisible then
    begin
      ABounds.Right := Min(Bounds.Right, ABounds.Right + Appearance.ActualItemBoxPadding.Right + Padding.Right + BorderThickness);
      ABounds.Bottom := Min(Bounds.Bottom, ABounds.Bottom + Appearance.ActualItemBoxPadding.Bottom + Padding.Bottom + BorderThickness);
    end
    else
    begin
      ABounds.Right := Min(Bounds.Right, ABounds.Right + Appearance.ActualItemBoxPadding.Right);
      ABounds.Bottom := Min(Bounds.Bottom, ABounds.Bottom + Appearance.ActualItemBoxPadding.Bottom);
      AItemsContentWithPadding := ABounds;
      AItemsContentWithPadding.Top := Items[0].Bounds.Top - Appearance.ActualItemBoxPadding.Top;
      AItemsContentWithPadding.Left := Items[0].Bounds.Left - Appearance.ActualItemBoxPadding.Left;
      AdjustWithTitle(ABounds);
      AdjustSize(ABounds);
    end;
  end
  else  
    AdjustWithoutItems(ABounds);
  UpdateBounds(ABounds);
end;

procedure TdxChartLegendViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);
var
  R: TdxRectF;
  ACalculator: TdxChartLegendItemLayoutCalculator;
begin
  Clear;
  DoCalculateMetrics(ACanvas);

  R := ContentBounds;
  TdxChartTitleAccess(Title).CalculateAndAdjustContent(ACanvas, R);
  FItemBoxBounds := R.Content(Legend.Appearance.ActualItemBoxPadding);

  ACalculator := TdxChartLegendItemLayoutCalculator.Create(Self, ACanvas, ItemBoxBounds, Legend.Direction);
  try
    ACalculator.Calculate;
  finally
    ACalculator.Free;
  end;

  AdjustCalculatedContent(ACanvas);
  if UseRightToLeftAlignment then
    DoRightToLeftConversion;
end;

procedure TdxChartLegendViewInfo.DoCalculateMetrics(ACanvas: TcxCustomCanvas);
begin
  FShowCheckBoxes := Legend.ShowCheckBoxes;
  FShowCaptions := Legend.ShowCaptions;
  FShowImages := Legend.ShowImages;
  FActualImageSize := TdxSizeF.Null;
  FActualCheckBoxSize := cxNullSize;
  FActualItemIndent := Appearance.ItemIndent.Value;
  FActualImageOffset := 0;
  FActualCaptionOffset := 0;
  if ShowCheckBoxes then
    FActualCheckBoxSize := Appearance.ActualCheckBoxSize;
  if ShowImages then
    FActualImageSize := Appearance.ImageSize.Value;
  if ShowImages and ShowCheckBoxes then
    FActualImageOffset := Appearance.ImageOffset;
  if ShowCaptions and (ShowCheckBoxes or ShowImages) and ((ActualCheckBoxSize.Width > 0) or (ActualImageSize.Width > 0)) then
    FActualCaptionOffset := Appearance.CaptionOffset;
  FActualLineHeight := Max(Max(ActualCheckBoxSize.Height, ActualImageSize.Height), ActualFont.LineHeight);
end;

procedure TdxChartLegendViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
var
  ATitle: TdxChartTitleAccess;
  I: Integer;
begin
  inherited DoDraw(ACanvas);

  ATitle := TdxChartTitleAccess(Title);
  if ATitle.ActuallyVisible then
    ATitle.ViewInfo.Draw(ACanvas);

  for I := 0 to ItemList.Count - 1 do
    Items[I].Draw(ACanvas);
end;

procedure TdxChartLegendViewInfo.DoRightToLeftConversion;
var
  I: Integer;
begin
  for I := 0 to ItemList.Count - 1 do
    Items[I].DoRightToLeftConversion(ItemBoxBounds);
end;

procedure TdxChartLegendViewInfo.FreeCanvasBasedResources;
begin
  inherited FreeCanvasBasedResources;
  Clear;
end;

function TdxChartLegendViewInfo.GetHitElement(const P: TdxPointF): IdxChartHitTestElement;
begin
  Result := TdxChartComponentDependentHitElement.Create(Legend, False, TdxChartCustomLegendAccess(Legend).GetOwner as TComponent, TdxChartHitCode.Legend);
end;


function TdxChartLegendViewInfo.GetAppearance: TdxChartLegendAppearance;
begin
  Result := TdxChartLegendAppearance(inherited Appearance);
end;

function TdxChartLegendViewInfo.GetActualFont: TcxCanvasBasedFont;
begin
  Result := Appearance.ActualFont;
end;

function TdxChartLegendViewInfo.GetItem(AIndex: Integer): TdxChartLegendItemViewInfo;
begin
  Result := TdxChartLegendItemViewInfo(FItems.List[AIndex]);
end;

function TdxChartLegendViewInfo.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

function TdxChartLegendViewInfo.GetTitle: TdxChartVisualElementTitle;
begin
  Result := TdxChartVisualElementTitle(Legend.Title);
end;

function TdxChartLegendViewInfo.GetViewData: TdxChartLegendViewData;
begin
  Result := TdxChartLegendViewData(TdxChartCustomLegendAccess(Legend).ViewData);
end;

procedure TdxChartLegendViewInfo.UpdateBounds(const ABounds: TdxRectF);
var
  AOffset: TdxPointF;
  ANewTitleBounds: TdxRectF;
  AItem: TdxChartLegendItemViewInfo;
  ATitlePadding: TRect;
  I: Integer;
begin
  AOffset := Bounds.Distance(ABounds);
  Bounds.Offset(AOffset);
  inherited UpdateBounds(ABounds);

  FItemBoxBounds := ContentBounds;
  if TdxChartTitleAccess(Title).ViewInfo.ActuallyVisible then
  begin
    ATitlePadding := TdxChartTitleAppearanceAccess(Title.Appearance).ActualMargins;
    ANewTitleBounds := ContentBounds.Content(ATitlePadding);
    TdxChartTitleAccess(Title).ViewInfo.UpdateBounds(ANewTitleBounds, ANewTitleBounds);
    FItemBoxBounds.TruncBorder(TdxChartTitleAccess(Title).ViewInfo.Bounds,
      [Title.PositionToSide[TdxChartTitleAccess(Title).ActualDockPosition]], ATitlePadding);
  end;

  FItemBoxBounds := FItemBoxBounds.Content(Legend.Appearance.ActualItemBoxPadding);
  for I := 0 to ItemList.Count - 1 do
  begin
    AItem := Items[I];
    AItem.Offset(AOffset);
    AItem.UpdateBounds(AItem.Bounds, ItemBoxBounds);
  end;
end;

procedure TdxChartLegendViewInfo.UpdateTextColors;
var
  I: Integer;
begin
  inherited UpdateTextColors;
  for I := 0 to ItemList.Count - 1 do
   Items[I].UpdateTextColors;
end;


end.
