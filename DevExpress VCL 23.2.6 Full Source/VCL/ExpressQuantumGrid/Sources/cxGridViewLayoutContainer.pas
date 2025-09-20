{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressQuantumGrid                                       }
{                                                                    }
{           Copyright (c) 1998-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSQUANTUMGRID AND ALL            }
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

unit cxGridViewLayoutContainer;

{$I cxVer.inc}

interface

uses
  Variants, Windows, Classes, Graphics, Controls, Contnrs, ImgList, StdCtrls,
  dxCore, cxClasses, cxGraphics, cxControls, cxStyles, cxLookAndFeelPainters,
  cxGridCommon, cxGrid, dxCoreClasses, dxGDIPlusClasses,
  cxGridCustomView, cxGridCustomTableView, dxLayoutLookAndFeels, cxDataStorage,
  cxCustomData, cxEdit, dxLayoutContainer, dxLayoutSelection,
  dxLayoutCommon, Forms, cxNavigator, cxLookAndFeels, SysUtils, cxGeometry;

const
  cxGridLayoutCustomizationFormDefaultWidth = 800;
  cxGridLayoutCustomizationFormDefaultHeight = 500;
  cxGridLayoutItemCellBorderWidth = 1; //for internal use only

type
  TcxGridCustomLayoutItemEditViewInfo = class;
  TcxGridCustomLayoutItemViewInfo = class;
  TcxGridCustomLayoutItem = class;
  TcxGridViewLayoutItemDataCellViewInfo = class;
  TcxGridLayoutContainerViewInfo = class;
  TcxGridCustomLayoutController = class;

  TcxGridCustomLayoutItemClass = class of TcxGridCustomLayoutItem;

  { TcxGridCustomLayoutLookAndFeel }

  TcxLayoutViewLookAndFeelItemPadding = class(TdxLayoutLookAndFeelPadding)
  protected
    function GetDefaultValue(Index: Integer): Integer; override;
  end;

  TcxLayoutLayoutViewLookAndFeelItemOptions = class(TdxLayoutLookAndFeelItemOptions)
  protected
    function GetPaddingClass: TdxLayoutLookAndFeelPaddingClass; override;
  end;

  TcxGridCustomLayoutLookAndFeel = class(TdxLayoutCxLookAndFeel)
  private
    FLockCount: Integer;
    FGridView: TcxCustomGridTableView;
  protected
    procedure Changed; override;
    function GetItemOptionsClass: TdxLayoutLookAndFeelItemOptionsClass; override;
  public
    constructor Create(AGridView: TcxCustomGridTableView); reintroduce; virtual;
    procedure BeginUpdate;
    procedure EndUpdate;

    property GridView: TcxCustomGridTableView read FGridView;
  end;

  { TcxGridCustomLayoutItemCaptionPainter }

  TcxGridCustomLayoutItemCaptionPainter = class(TdxCustomLayoutItemCaptionPainter)
  protected
    procedure DrawBackground(ACanvas: TcxCanvas); override;
  end;

  { TcxGridCustomLayoutItemEditPainter }

  TcxGridCustomLayoutItemEditPainter = class(TdxLayoutControlItemControlPainter)
  private
    function GetViewInfo: TcxGridCustomLayoutItemEditViewInfo;
  protected
    procedure DrawEdit(ACanvas: TcxCanvas); virtual;
    function GetGridViewItem: TcxCustomGridTableItem; virtual;
    function GetLookAndFeel: TcxLookAndFeel; virtual;
  public
    procedure Paint(ACanvas: TcxCanvas); override;
    property ViewInfo: TcxGridCustomLayoutItemEditViewInfo read GetViewInfo;
  end;

  { TcxGridCustomLayoutItemPainter }

  TcxGridCustomLayoutItemPainter = class(TdxLayoutControlItemPainter)
  private
    function GetViewInfo: TcxGridCustomLayoutItemViewInfo;
  protected
    function CanPaint: Boolean; override;
    function GetCaptionPainterClass: TdxCustomLayoutItemCaptionPainterClass; override;
    function GetControlPainterClass: TdxLayoutControlItemControlPainterClass; override;

    property ViewInfo: TcxGridCustomLayoutItemViewInfo read GetViewInfo;
  end;

  { TcxGridCustomLayoutItemCaptionViewInfo }

  TcxGridCustomLayoutItemCaptionViewInfo = class(TdxLayoutControlItemCaptionViewInfo)
  private
    function GetItemViewInfo: TcxGridCustomLayoutItemViewInfo;inline;
  protected
    function CalculatePadding: TRect; override;
    function GetTextColor: TColor; override;

    property ItemViewInfo: TcxGridCustomLayoutItemViewInfo read GetItemViewInfo;
  public
    function CalculateHeight: Integer; override;
  end;

  { TcxGridCustomLayoutItemEditViewInfo }

  TcxGridCustomLayoutItemEditViewInfo = class(TdxLayoutControlItemControlViewInfo)
  private
    FDataHeight: Integer;
    function GetDataViewInfo: TcxGridViewLayoutItemDataCellViewInfo;inline;
    function GetItem: TcxGridCustomLayoutItem;inline;
    function GetItemViewInfo: TcxGridCustomLayoutItemViewInfo;inline;
    function GetGridView: TcxCustomGridTableView;inline;
  protected
    function GetDefaultValueHeight: Integer; virtual;
    procedure GetDefaultValueParams(out AParams: TcxViewParams); virtual;
    function GetGridRecord: TcxCustomGridRecord; virtual;
    function GetMinValueWidth: Integer; virtual;
    function GetOriginalControlSize: TSize; override;
    function GetValueHeight: Integer;
    function HasBorder: Boolean; override;
    function IsValueHeightDependOnData: Boolean; virtual;

    property DataViewInfo: TcxGridViewLayoutItemDataCellViewInfo read GetDataViewInfo;
    property GridView: TcxCustomGridTableView read GetGridView;
    property ItemViewInfo: TcxGridCustomLayoutItemViewInfo read GetItemViewInfo;
    property Item: TcxGridCustomLayoutItem read GetItem;
  public
    procedure CalculateInternalTabOrder(var AAvailableTabOrder: Integer); override;
    function CalculateMinHeight: Integer; override;
    function CalculateMinWidth: Integer; override;
  end;

  { TcxGridCustomLayoutItemViewInfo }

  TcxGridCustomLayoutItemViewInfo = class(TdxLayoutControlItemViewInfo)
  private
    FGridItemViewInfo: TcxGridViewLayoutItemDataCellViewInfo;

    function GetControlViewInfo: TcxGridCustomLayoutItemEditViewInfo;inline;
    function GetItem: TcxGridCustomLayoutItem;inline;
    function GetGridItemViewInfo: TcxGridViewLayoutItemDataCellViewInfo;inline;
  protected
    function GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass; override;
    function GetControlViewInfoClass: TdxLayoutControlItemControlViewInfoClass; override;
    function GetCurrentGridItemViewInfo: TcxGridViewLayoutItemDataCellViewInfo; virtual;
    function GetEnabled: Boolean; override;
    function GetPainterClass: TdxCustomLayoutItemPainterClass; override;
  public
    property ControlViewInfo: TcxGridCustomLayoutItemEditViewInfo read GetControlViewInfo;
    property GridItemViewInfo: TcxGridViewLayoutItemDataCellViewInfo read GetGridItemViewInfo;

    property Item: TcxGridCustomLayoutItem read GetItem;
  end;

  { TcxGridCustomLayoutItemCaptionOptions }

  TcxGridCustomLayoutItemCaptionOptions = class(TdxLayoutLabeledItemCustomCaptionOptions)
  private
    FGridItemCaption: string;
    function GetItem: TcxGridCustomLayoutItem;inline;
  protected
    function GetText: string; override;
    function IsTextStored: Boolean; override;
    procedure SetText(const Value: string); override;

    property GridItemCaption: string read FGridItemCaption write FGridItemCaption;
  public
    property Item: TcxGridCustomLayoutItem read GetItem;
  end;

  { TcxGridLayoutCustomItem }

  TcxGridCustomLayoutItem = class(TdxLayoutControlItem)
  private
    FGridViewItem: TcxCustomGridTableItem;
    FLoadedGridViewItemName: string;

    function GetCaptionOptions: TcxGridCustomLayoutItemCaptionOptions; inline;
    function GetViewInfo: TcxGridCustomLayoutItemViewInfo;
    procedure SetCaptionOptions(Value: TcxGridCustomLayoutItemCaptionOptions); inline;
    procedure SetGridViewItem(const AValue: TcxCustomGridTableItem);
  protected
    // IcxStoredObject
    function GetStoredProperties(AProperties: TStrings): Boolean; override;
    procedure GetStoredPropertyValue(const AName: string; var AValue: Variant); override;
    procedure SetStoredPropertyValue(const AName: string; const AValue: Variant); override;

    function CanDelete: Boolean; override;
    procedure CustomizationChanged; override;
    function GetBaseName: string; override;
    class function GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass; override;
    function GetInplaceRenameCaption: string; override;
    function GetObjectForSelect: TcxGridCustomLayoutItem; virtual;
    function GetViewInfoClass: TdxCustomLayoutItemViewInfoClass; override;
    function HasControl: Boolean; override;
    function IsVisibleForCustomization: Boolean; override;
    procedure SetInplaceRenameCaption(const ACaption: string); override;

    function CaptionToDisplayCaption(AValue: string): string; virtual;
    function DisplayCaptionToCaption(AValue: string): string; virtual;

    property LoadedGridViewItemName: string read FLoadedGridViewItemName;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;

    property CaptionOptions: TcxGridCustomLayoutItemCaptionOptions read GetCaptionOptions write SetCaptionOptions;
    property GridViewItem: TcxCustomGridTableItem read FGridViewItem write SetGridViewItem;
    property ViewInfo: TcxGridCustomLayoutItemViewInfo read GetViewInfo;
  end;

  { TcxGridViewLayoutItemDataCellPainter }

  TcxGridViewLayoutItemDataCellPainter = class(TcxGridTableDataCellPainter)
  private
    function GetViewInfo: TcxGridViewLayoutItemDataCellViewInfo;
  protected
    procedure DrawBackground; override;
    procedure DrawBorders; override;
    procedure DrawContent; override;
    procedure DrawText; override;
    function GetFocusRect: TRect; override;
    procedure Paint; override;

    property ViewInfo: TcxGridViewLayoutItemDataCellViewInfo read GetViewInfo;
  end;

  { TcxGridViewLayoutItemDataCellViewInfo }

  TcxGridViewLayoutItemDataCellViewInfo = class(TcxGridTableDataCellViewInfo)
  private
    function GetLayoutItemViewInfo: TcxGridCustomLayoutItemViewInfo;
    function GetLayoutItemViewInfoBounds: TRect;
    function GetVisibleBounds: TRect;
  protected
    procedure CalculateEditViewInfo(AEditViewInfo: TcxCustomEditViewInfo; const AMousePos: TPoint); override;
    function CanFocus: Boolean; virtual;
    procedure DoCalculateParams; override;
    function GetActualState: TcxGridCellState; override;
    function GetButtonState: TcxButtonState; override;
    procedure GetCaptionParams(var AParams: TcxViewParams); virtual;
    function GetEditViewDataBounds: TRect; override;
    function GetFocusRect: TRect; virtual;
    function GetLayoutItemViewInfoInstance: TcxGridCustomLayoutItemViewInfo; virtual; abstract;
    function GetMultiLine: Boolean; override;
    function GetPainterClass: TcxCustomGridCellPainterClass; override;
    function GetRealEditViewDataBounds: TRect; override;
    function GetTransparent: Boolean; override;
    procedure GetViewParams(var AParams: TcxViewParams); override;
    function GetVisible: Boolean; override;
    function HasBackground: Boolean; override;
    function HasBorders: Boolean; virtual;
    function HasFocusRect: Boolean; override;
    function HasHotTrackBackground: Boolean; virtual;
    function HasSelectionBackground: Boolean; virtual;
    function IsValueTransparent: Boolean; virtual;
    procedure StateChanged(APrevState: TcxGridCellState); override;

    property LayoutItemViewInfo: TcxGridCustomLayoutItemViewInfo read GetLayoutItemViewInfo;
    property VisibleBounds: TRect read GetVisibleBounds;
  public
    CaptionParams: TcxViewParams;

    procedure Calculate(const ABounds: TRect); override;
    procedure Calculate(ALeftBound, ATopBound: Integer; AWidth: Integer = -1; AHeight: Integer = -1); override;

    property LayoutItemViewInfoBounds: TRect read GetLayoutItemViewInfoBounds;
  end;

  { TcxGridLayoutCustomizationController }

  TcxGridLayoutCustomizationController = class(TcxCustomGridCustomizationController)
  protected
    function CanCustomize: Boolean; override;
    procedure CheckFormBounds(var R: TRect); override;
    procedure CustomizationChanged; override;
    procedure DoCreateForm; override;
    function GetFormBounds(AScaleFactor: TdxScaleFactor): TRect; override;
  end;

  { TcxGridCustomLayoutController }

  TcxGridCustomLayoutController = class(TcxCustomGridTableController);

  { TdxGridLayoutRootViewInfo }

  TdxGridLayoutRootViewInfo = class(TdxLayoutRootViewInfo)
  protected
    function CanDrawBackground: Boolean; override;
  end;

  { TcxGridLayoutContainerTabOrderHelper }

  TcxGridLayoutContainerTabOrderHelper = class
  strict private
    FContainer: TcxGridLayoutContainerViewInfo;

    procedure PopulateGroup(AOrderList: TList; AValue: TdxLayoutGroupViewInfo);
    procedure PopulateItem(AOrderList: TList; AItem: TdxCustomLayoutItemViewInfo);
  protected
    procedure PopulateGridItem(AOrderList: TList; AItem: TcxGridCustomLayoutItemViewInfo); virtual;

    property Container: TcxGridLayoutContainerViewInfo read FContainer;
  public
    constructor Create(AContainer: TcxGridLayoutContainerViewInfo); virtual;

    procedure PopulateOrder(AOrderList: TList); virtual;
  end;

  { TcxGridLayoutContainerSmartOrderHelper }

  TcxGridLayoutContainerSmartOrderHelper = class(TcxGridLayoutContainerTabOrderHelper)
  strict private
    FContainerBounds: TRect;
    FDirection: TcxNeighbor;
    FFocusedItem: TdxCustomLayoutItemViewInfo;
    FFocusedItemBounds: TRect;
    FStartNewCycle: Boolean;

    function CompareItems(AItem1, AItem2: Pointer): Integer;
    function GetActualFocusedItemBounds: TRect;
    procedure DeleteItemsNonMatchesWithDirection(AList: TList);
    function IsItemMatchedWithDirection(AViewInfo: TdxCustomLayoutItemViewInfo): Boolean;
  protected
    procedure PopulateGridItem(AOrderList: TList; AItem: TcxGridCustomLayoutItemViewInfo); override;

    property ContainerBounds: TRect read FContainerBounds;
    property Direction: TcxNeighbor read FDirection;
    property FocusedItem: TdxCustomLayoutItemViewInfo read FFocusedItem;
    property FocusedItemBounds: TRect read FFocusedItemBounds;
    property StartNewCycle: Boolean read FStartNewCycle;
  public
    constructor Create(AContainer: TcxGridLayoutContainerViewInfo); override;

    procedure Init(AFocusedItem: TdxCustomLayoutItemViewInfo; ADirection: TcxNeighbor; AStartNewCycle: Boolean);
    procedure PopulateOrder(AOrderList: TList); override;
  end;

  { TcxGridLayoutContainerViewInfo }

  TcxGridLayoutContainerViewInfo = class(TdxLayoutContainerViewInfo)
  strict private
    function GetGridRecord: TcxCustomGridRecord;
    function GetRecordViewInfo: TcxCustomGridRecordViewInfo;
  protected
    function CanDrawRoot: Boolean; virtual;
    function CanShowGroupScrollBars: Boolean; override;
    function CanUseCachedInfo: Boolean; override;
    function GetGridRecordInstance: TcxCustomGridRecord; virtual;
    function GetRecordViewInfoInstance: TcxCustomGridRecordViewInfo; virtual;
    function GetRootViewInfoClass: TdxLayoutRootViewInfoClass; override;
    procedure RecreateViewData; override;
  public
    function CanItemValueAutoHeight: Boolean; virtual;
    function GetGridItemViewInfo(AViewInfo: TcxGridCustomLayoutItemViewInfo): TcxGridViewLayoutItemDataCellViewInfo; virtual;
    procedure PopulateSmartOrderList(AList: TList; AFocusedItem: TdxCustomLayoutItemViewInfo;
      ADirection: TcxNeighbor; AStartNewCycle: Boolean);
    procedure PopulateTabOrderList(AList: TList);

    property GridRecord: TcxCustomGridRecord read GetGridRecord;
    property RecordViewInfo: TcxCustomGridRecordViewInfo read GetRecordViewInfo;
  end;

  { TdxLayoutCloneGroupViewData }

  TdxLayoutCloneGroupViewData = class(TdxLayoutGroupViewData)
  private
    FExpanded: Boolean;
    FItemIndex: Integer;
  protected
    procedure Changed; override;
    function GetSize: Integer; override;

    function GetExpanded: Boolean; override;
    function GetItemIndex: Integer; override;
    procedure SetExpanded(Value: Boolean); override;
    procedure SetItemIndex(Value: Integer); override;
    procedure SetTabIndex(Value: Integer); override;
  public
    procedure Assign(Source: TdxCustomLayoutItemViewData); override;
    procedure Calculate; override;
    procedure Load(AStream: TStream); override;
    procedure Save(AStream: TStream); override;
  end;

  { TcxGridRecordLayoutContainerViewInfo }

  TcxGridRecordLayoutContainerViewInfo = class(TcxGridLayoutContainerViewInfo)
  private
    FRecordViewInfo: TcxCustomGridRecordViewInfo;
  protected
    function GetRecordViewInfoInstance: TcxCustomGridRecordViewInfo; override;
    function FindGridItemViewInfo(AViewInfo: TcxGridCustomLayoutItemViewInfo): TcxGridViewLayoutItemDataCellViewInfo; virtual; abstract;
    function GetLayoutItem(AViewInfo: TcxGridCustomLayoutItemViewInfo): TdxLayoutControlItem; virtual;
    function GetItemOptions(AViewInfo: TdxCustomLayoutItemViewInfo): TdxCustomLayoutLookAndFeelOptions; override;
    function GetItemLayoutLookAndFeel(AViewInfo: TdxCustomLayoutItemViewInfo): TdxCustomLayoutLookAndFeel; override;
    function GetViewDataClass(AItem: TdxCustomLayoutItem): TdxCustomLayoutItemViewDataClass; override;
  public
    constructor Create(AContainer: TdxLayoutContainer; ARecordViewInfo: TcxCustomGridRecordViewInfo); reintroduce; virtual;

    function GetGridItemViewInfo(AViewInfo: TcxGridCustomLayoutItemViewInfo): TcxGridViewLayoutItemDataCellViewInfo; override;
  end;

  TcxGridLayoutContainerAssignLayoutMode = (almNone, almToParent, almFromParent);

  TcxGridLayoutContainerCustomizationHelper = class(TdxLayoutContainerCustomizationHelper)
  private
    FAssignLayoutMode: TcxGridLayoutContainerAssignLayoutMode;
    FPattern: TdxLayoutContainer;

    procedure AssignStructureFromPattern;
    procedure AssignStructureToPattern;
  protected
    property AssignLayoutMode: TcxGridLayoutContainerAssignLayoutMode read FAssignLayoutMode;
    property Pattern: TdxLayoutContainer read FPattern;
  public
    procedure CopyStructure(AContainer: TdxLayoutContainer); override;
    procedure ResetPattern;
  end;

  { TcxGridCustomLayoutContainer }

  TcxGridCustomLayoutContainer = class(TdxLayoutContainer)
  private
    function GetCustomizationHelper: TcxGridLayoutContainerCustomizationHelper;
    function GetGridView: TcxCustomGridTableView;
  protected
    procedure DoInitialize; override;
    procedure DoUpdateRootOptions; virtual;
    function GetCanvas: TcxCanvas; override;
    function GetCustomizationHelperClass: TdxLayoutContainerCustomizationHelperClass; override;
    function GetImages: TCustomImageList; override;
    function GetItemsOwner: TComponent; override;
    function GetItemsParentComponent: TComponent; override;
    function GetItemsParentControl: TcxControl; override;
    function IsRootStored: Boolean; override;
    procedure LayoutChanged(ANeedPack: Boolean = True); override;
    function NeedStretchRecordHeight: Boolean; virtual;
    function NeedStretchRecordWidth: Boolean; virtual;
    procedure UnregisterControlFont; virtual;
    procedure UnregisterFonts; override;
    procedure UnregisterSiteFont; virtual;
    procedure UpdateRootOptions;

    property CustomizationHelper: TcxGridLayoutContainerCustomizationHelper read GetCustomizationHelper;
    property GridView: TcxCustomGridTableView read GetGridView;
  end;

implementation

uses
  Types, Math, dxTypeHelpers, cxContainer, cxTextEdit, cxGridViewLayoutCustomizationForm;

const
  dxThisUnitName = 'cxGridViewLayoutContainer';

type
  TcxControlAccess = class(TcxControl);
  TcxCustomGridTableItemAccess = class(TcxCustomGridTableItem);
  TcxCustomGridTableViewAccess = class(TcxCustomGridTableView);
  TdxCustomLayoutItemAccess = class(TdxCustomLayoutItem);
  TdxCustomLayoutItemViewInfoAccess = class(TdxCustomLayoutItemViewInfo);
  TdxLayoutContainerAccess = class(TdxLayoutContainer);
  TdxLayoutControlItemAccess = class(TdxLayoutControlItem);
  TdxLayoutItemViewDataListAccess = class(TdxLayoutItemViewDataList);

{ TcxLayoutViewLookAndFeelItemPadding }

function TcxLayoutViewLookAndFeelItemPadding.GetDefaultValue(Index: Integer): Integer;
begin
  Result := ScaleFactor.Apply(2);
end;

{ TcxLayoutLayoutViewLookAndFeelItemOptions }

function TcxLayoutLayoutViewLookAndFeelItemOptions.GetPaddingClass: TdxLayoutLookAndFeelPaddingClass;
begin
  Result := TcxLayoutViewLookAndFeelItemPadding;
end;

{ TcxGridCustomLayoutLookAndFeel }

procedure TcxGridCustomLayoutLookAndFeel.BeginUpdate;
begin
  Inc(FLockCount);
end;

procedure TcxGridCustomLayoutLookAndFeel.Changed;
begin
  if FLockCount = 0 then
    inherited Changed;
end;

constructor TcxGridCustomLayoutLookAndFeel.Create(
  AGridView: TcxCustomGridTableView);
begin
  inherited Create(nil);
  FGridView := AGridView;
end;

procedure TcxGridCustomLayoutLookAndFeel.EndUpdate;
begin
  Dec(FLockCount);
  Changed;
end;

function TcxGridCustomLayoutLookAndFeel.GetItemOptionsClass: TdxLayoutLookAndFeelItemOptionsClass;
begin
  Result := TcxLayoutLayoutViewLookAndFeelItemOptions;
end;

{ TcxGridCustomLayoutItemCaptionPainter }

procedure TcxGridCustomLayoutItemCaptionPainter.DrawBackground(ACanvas: TcxCanvas);
begin
//do nothing
end;

{ TcxGridLayoutItemEditPainter }

procedure TcxGridCustomLayoutItemEditPainter.Paint(ACanvas: TcxCanvas);
begin
  inherited Paint(ACanvas);
  DrawEdit(ACanvas);
end;

procedure TcxGridCustomLayoutItemEditPainter.DrawEdit(ACanvas: TcxCanvas);
var
  AGridViewItem: TcxCustomGridTableItem;
  AProperties: TcxCustomEditProperties;
  AEditViewData: TcxCustomEditViewData;
  AEditViewInfo: TcxCustomEditViewInfo;
  AEditStyle: TcxEditStyle;
  AEditDrawBounds: TRect;
  AAlphaBitmap, AOpaqueBitmap: TcxBitmap32;
begin
  AGridViewItem := GetGridViewItem;
  AProperties := AGridViewItem.GetProperties;
  AEditStyle := TcxEditStyle.Create(nil, False);
  try
    AEditStyle.LookAndFeel := GetLookAndFeel;
    AEditStyle.ButtonTransparency := ebtNone;
    AEditStyle.BorderStyle := ebsNone;
    AEditViewData := AProperties.CreateViewData(AEditStyle, True, TcxCustomGridTableViewAccess(AGridViewItem.GridView).ScaleFactor, True);
    try
      AEditViewInfo := AProperties.GetViewInfoClass.Create as TcxCustomEditViewInfo;
      try
        AEditViewData.EditValueToDrawValue(Null, AEditViewInfo);
        AEditDrawBounds := ViewInfo.Bounds;
        InflateRect(AEditDrawBounds, 1, 1);
        AAlphaBitmap := TcxBitmap32.CreateSize(AEditDrawBounds);
        AOpaqueBitmap := TcxBitmap32.CreateSize(AEditDrawBounds);
        try
          AEditViewData.Calculate(ACanvas, AEditDrawBounds, cxNullPoint, cxmbNone, [], AEditViewInfo, False);
          AOpaqueBitmap.cxCanvas.WindowOrg := AEditDrawBounds.TopLeft;
          AEditViewInfo.Paint(AOpaqueBitmap.cxCanvas);
          AOpaqueBitmap.MakeOpaque;
          AAlphaBitmap.cxCanvas.FillRect(AAlphaBitmap.ClientRect, $100005);
          AAlphaBitmap.SetAlphaChannel(32);
          AOpaqueBitmap.cxCanvas.WindowOrg := cxNullPoint;
          cxAlphaBlend(AOpaqueBitmap.Canvas.Handle, AAlphaBitmap, AOpaqueBitmap.ClientRect, AAlphaBitmap.ClientRect);
          cxBitBlt(ACanvas.Handle, AOpaqueBitmap.Canvas.Handle, ViewInfo.Bounds, cxSimplePoint, SRCCOPY);
        finally
          AAlphaBitmap.Free;
          AOpaqueBitmap.Free;
        end;
      finally
        AEditViewInfo.Free;
      end;
    finally
      AEditViewData.Free;
    end;
  finally
    AEditStyle.Free;
  end;
end;

function TcxGridCustomLayoutItemEditPainter.GetGridViewItem: TcxCustomGridTableItem;
begin
  Result := ViewInfo.Item.GridViewItem;
end;

function TcxGridCustomLayoutItemEditPainter.GetLookAndFeel: TcxLookAndFeel;
begin
  Result := TcxCustomGridTableItemAccess(GetGridViewItem).GetCellStyle.LookAndFeel;
end;

function TcxGridCustomLayoutItemEditPainter.GetViewInfo: TcxGridCustomLayoutItemEditViewInfo;
begin
  Result := TcxGridCustomLayoutItemEditViewInfo(inherited ViewInfo);
end;

{ TcxGridLayoutItemPainter }

function TcxGridCustomLayoutItemPainter.CanPaint: Boolean;
begin
  Result := ViewInfo.Item.Container.Customization;
end;

function TcxGridCustomLayoutItemPainter.GetCaptionPainterClass: TdxCustomLayoutItemCaptionPainterClass;
begin
  Result := TcxGridCustomLayoutItemCaptionPainter;
end;

function TcxGridCustomLayoutItemPainter.GetControlPainterClass: TdxLayoutControlItemControlPainterClass;
begin
  Result := TcxGridCustomLayoutItemEditPainter;
end;

function TcxGridCustomLayoutItemPainter.GetViewInfo: TcxGridCustomLayoutItemViewInfo;
begin
  Result := TcxGridCustomLayoutItemViewInfo(inherited ViewInfo);
end;

{ TcxGridCustomLayoutItemCaptionViewInfo }

function TcxGridCustomLayoutItemCaptionViewInfo.CalculateHeight: Integer;
begin
  Result := inherited CalculateHeight;
  dxAdjustToTouchableSize(Result, ItemViewInfo.Item.ScaleFactor);
end;

function TcxGridCustomLayoutItemCaptionViewInfo.CalculatePadding: TRect;
begin
  Result := cxRectInflate(inherited CalculatePadding, -1);
end;

function TcxGridCustomLayoutItemCaptionViewInfo.GetItemViewInfo: TcxGridCustomLayoutItemViewInfo;
begin
  Result := TcxGridCustomLayoutItemViewInfo(inherited ItemViewInfo);
end;

function TcxGridCustomLayoutItemCaptionViewInfo.GetTextColor: TColor;
var
  AGridItemViewInfo: TcxGridViewLayoutItemDataCellViewInfo;
begin
  AGridItemViewInfo := TcxGridViewLayoutItemDataCellViewInfo(ItemViewInfo.GridItemViewInfo);
  if AGridItemViewInfo <> nil then
    Result := AGridItemViewInfo.CaptionParams.TextColor
  else
    Result := inherited GetTextColor;
end;

{ TcxGridCustomLayoutItemEditViewInfo }

procedure TcxGridCustomLayoutItemEditViewInfo.CalculateInternalTabOrder(var AAvailableTabOrder: Integer);
begin
  ItemViewInfo.TabOrder := AAvailableTabOrder;
  Inc(AAvailableTabOrder);
end;

function TcxGridCustomLayoutItemEditViewInfo.CalculateMinHeight: Integer;
begin
  if Item.ControlOptions.IsHeightUsual then
    Result := CalculateHeight
  else
    if Visible then
      Result := GetDefaultValueHeight
    else
      Result := 0;
end;

function TcxGridCustomLayoutItemEditViewInfo.CalculateMinWidth: Integer;
begin
  if Item.ControlOptions.IsWidthUsual then
    Result := CalculateWidth
  else
    if Visible then
      Result := GetControlAreaWidth(GetMinValueWidth)
    else
      Result := 0;
end;

function TcxGridCustomLayoutItemEditViewInfo.HasBorder: Boolean;
begin
  Result := False;
end;

function TcxGridCustomLayoutItemEditViewInfo.IsValueHeightDependOnData: Boolean;
begin
  Result := DataViewInfo <> nil;
end;

function TcxGridCustomLayoutItemEditViewInfo.GetMinValueWidth: Integer;
begin
  Result := 0;
end;

function TcxGridCustomLayoutItemEditViewInfo.GetOriginalControlSize: TSize;
begin
  Result := cxSize(GetMinValueWidth, GetValueHeight);
end;

function TcxGridCustomLayoutItemEditViewInfo.GetValueHeight: Integer;
begin
  if FDataHeight = 0 then
    FDataHeight := GetDefaultValueHeight;
  dxAdjustToTouchableSize(FDataHeight);
  Result := FDataHeight;
end;

function TcxGridCustomLayoutItemEditViewInfo.GetDefaultValueHeight: Integer;
var
  AParams: TcxViewParams;
begin
  if IsValueHeightDependOnData then
    Result := DataViewInfo.CalculateHeight
  else
  begin
    GetDefaultValueParams(AParams);
    Result := Item.GridViewItem.CalculateDefaultCellHeight(cxMeasureCanvas, AParams.Font);
  end;
end;

procedure TcxGridCustomLayoutItemEditViewInfo.GetDefaultValueParams(out AParams: TcxViewParams);
begin
  GridView.Styles.GetContentParams(GetGridRecord, Item.GridViewItem, AParams);
end;

function TcxGridCustomLayoutItemEditViewInfo.GetDataViewInfo: TcxGridViewLayoutItemDataCellViewInfo;
begin
  Result := ItemViewInfo.GridItemViewInfo;
end;

function TcxGridCustomLayoutItemEditViewInfo.GetGridRecord: TcxCustomGridRecord;
begin
  Result := nil;
end;

function TcxGridCustomLayoutItemEditViewInfo.GetItem: TcxGridCustomLayoutItem;
begin
  Result := TcxGridCustomLayoutItem(inherited Item);
end;

function TcxGridCustomLayoutItemEditViewInfo.GetItemViewInfo: TcxGridCustomLayoutItemViewInfo;
begin
  Result := TcxGridCustomLayoutItemViewInfo(inherited ItemViewInfo);
end;

function TcxGridCustomLayoutItemEditViewInfo.GetGridView: TcxCustomGridTableView;
begin
  Result := Item.GridViewItem.GridView;
end;

{ TcxGridLayoutItemViewInfo }

function TcxGridCustomLayoutItemViewInfo.GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass;
begin
  Result := TcxGridCustomLayoutItemCaptionViewInfo;
end;

function TcxGridCustomLayoutItemViewInfo.GetControlViewInfoClass: TdxLayoutControlItemControlViewInfoClass;
begin
  Result := TcxGridCustomLayoutItemEditViewInfo;
end;

function TcxGridCustomLayoutItemViewInfo.GetCurrentGridItemViewInfo: TcxGridViewLayoutItemDataCellViewInfo;
begin
  Result := nil;
end;

function TcxGridCustomLayoutItemViewInfo.GetEnabled: Boolean;
begin
  Result := inherited GetEnabled and (Item.GridViewItem <> nil) and Item.GridViewItem.Options.Focusing;
end;

function TcxGridCustomLayoutItemViewInfo.GetPainterClass: TdxCustomLayoutItemPainterClass;
begin
  Result := TcxGridCustomLayoutItemPainter;
end;

function TcxGridCustomLayoutItemViewInfo.GetControlViewInfo: TcxGridCustomLayoutItemEditViewInfo;
begin
  Result := TcxGridCustomLayoutItemEditViewInfo(inherited ControlViewInfo);
end;

function TcxGridCustomLayoutItemViewInfo.GetGridItemViewInfo: TcxGridViewLayoutItemDataCellViewInfo;
begin
  if FGridItemViewInfo = nil then
    FGridItemViewInfo := GetCurrentGridItemViewInfo;
  Result := FGridItemViewInfo;
end;

function TcxGridCustomLayoutItemViewInfo.GetItem: TcxGridCustomLayoutItem;
begin
  Result := TcxGridCustomLayoutItem(inherited Item);
end;

{ TcxGridCustomLayoutItemCaptionOptions }

function TcxGridCustomLayoutItemCaptionOptions.GetText: string;
var
  AText: string;
begin
  Result := inherited GetText;
  if Item.Customization then
    Exit;
  if Item.GridViewItem <> nil then
    AText := Item.GridViewItem.VisibleCaption
  else
    AText := '';
  if Result <> AText then
  begin
    Result := AText;
    Text := Result;
  end;
end;

function TcxGridCustomLayoutItemCaptionOptions.IsTextStored: Boolean;
begin
  Result := False;
end;

procedure TcxGridCustomLayoutItemCaptionOptions.SetText(const Value: string);
begin
  inherited SetText(Value);
  if IsRestoring and (Item.GridViewItem <> nil) then
    GridItemCaption := Item.DisplayCaptionToCaption(Value);
end;

function TcxGridCustomLayoutItemCaptionOptions.GetItem: TcxGridCustomLayoutItem;
begin
  Result := TcxGridCustomLayoutItem(inherited Item);
end;


{ TcxGridLayoutCustomItem }

constructor TcxGridCustomLayoutItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  IsUserDefined := False;
end;

procedure TcxGridCustomLayoutItem.Assign(Source: TPersistent);
var
  ASource: TcxGridCustomLayoutItem;
begin
  inherited Assign(Source);
  if Source is TcxGridCustomLayoutItem then
  begin
    ASource := TcxGridCustomLayoutItem(Source);
    case (TdxLayoutContainerAccess(Container).CustomizationHelper as TcxGridLayoutContainerCustomizationHelper).AssignLayoutMode of
      almFromParent:
        GridViewItem := ASource.GridViewItem;
      almToParent:
        if GridViewItem = nil then
          GridViewItem := ASource.GridViewItem
        else
          GridViewItem.Caption := ASource.CaptionOptions.GridItemCaption;
    end;
  end;
end;

function TcxGridCustomLayoutItem.GetStoredProperties(AProperties: TStrings): Boolean;
begin
  Result := inherited GetStoredProperties(AProperties);
  AProperties.Add('GridViewItem');
end;

procedure TcxGridCustomLayoutItem.GetStoredPropertyValue(const AName: string; var AValue: Variant);
begin
  if AName = 'GridViewItem' then
    AValue := TcxCustomGridTableItemAccess(GridViewItem).GetObjectName
  else
    inherited GetStoredPropertyValue(AName, AValue);
end;

procedure TcxGridCustomLayoutItem.SetStoredPropertyValue(const AName: string; const AValue: Variant);
begin
  if AName = 'GridViewItem' then
    FLoadedGridViewItemName := AValue
  else
    inherited SetStoredPropertyValue(AName, AValue);
end;

function TcxGridCustomLayoutItem.CanDelete: Boolean;
begin
  Result := False;
end;

procedure TcxGridCustomLayoutItem.CustomizationChanged;
begin
  inherited CustomizationChanged;
  if Customization and not IsDestroying and (GridViewItem <> nil) then
  begin
    CaptionOptions.GridItemCaption := GridViewItem.Caption;
    Caption := GridViewItem.VisibleCaption;
  end;
end;

function TcxGridCustomLayoutItem.GetBaseName: string;
begin
  Result := inherited GetBaseName + 'LayoutItem';
end;

class function TcxGridCustomLayoutItem.GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass;
begin
  Result := TcxGridCustomLayoutItemCaptionOptions;
end;

function TcxGridCustomLayoutItem.GetInplaceRenameCaption: string;
begin
  Result := CaptionOptions.GridItemCaption;
end;

function TcxGridCustomLayoutItem.GetObjectForSelect: TcxGridCustomLayoutItem;
begin
  if Data <> nil then
    Result := TcxGridCustomLayoutItem(Data).GetObjectForSelect
  else
    Result := Self;
end;

function TcxGridCustomLayoutItem.GetViewInfoClass: TdxCustomLayoutItemViewInfoClass;
begin
  Result := TcxGridCustomLayoutItemViewInfo;
end;

function TcxGridCustomLayoutItem.HasControl: Boolean;
begin
  Result := GridViewItem <> nil;
end;

function TcxGridCustomLayoutItem.IsVisibleForCustomization: Boolean;
begin
  Result := inherited IsVisibleForCustomization and (GridViewItem <> nil);
end;

procedure TcxGridCustomLayoutItem.SetInplaceRenameCaption(const ACaption: string);
begin
  CaptionOptions.GridItemCaption := ACaption;
  inherited SetInplaceRenameCaption(CaptionToDisplayCaption(ACaption));
end;

function TcxGridCustomLayoutItem.CaptionToDisplayCaption(AValue: string): string;
begin
  Result := AValue;
end;

function TcxGridCustomLayoutItem.DisplayCaptionToCaption(AValue: string): string;
begin
  Result := AValue;
end;

function TcxGridCustomLayoutItem.GetCaptionOptions: TcxGridCustomLayoutItemCaptionOptions;
begin
  Result := TcxGridCustomLayoutItemCaptionOptions(inherited CaptionOptions);
end;

function TcxGridCustomLayoutItem.GetViewInfo: TcxGridCustomLayoutItemViewInfo;
begin
  Result := TcxGridCustomLayoutItemViewInfo(inherited ViewInfo);
end;

procedure TcxGridCustomLayoutItem.SetCaptionOptions(Value: TcxGridCustomLayoutItemCaptionOptions);
begin
  inherited CaptionOptions := Value;
end;

procedure TcxGridCustomLayoutItem.SetGridViewItem(const AValue: TcxCustomGridTableItem);
begin
  if GridViewItem <> AValue then
  begin
    FGridViewItem := AValue;
    Changed;
  end;
end;

{ TcxGridViewLayoutItemDataCellPainter }

procedure TcxGridViewLayoutItemDataCellPainter.DrawBackground;
begin
//do nothing
end;

procedure TcxGridViewLayoutItemDataCellPainter.DrawBorders;
var
  ABounds: TRect;
begin
  if ViewInfo.HasBorders then
  begin
    ABounds := cxRectInflate(ViewInfo.EditViewInfo.Bounds, cxGridLayoutItemCellBorderWidth);
    ViewInfo.LookAndFeelPainter.DrawBorder(Canvas, ABounds);
  end;
end;

procedure TcxGridViewLayoutItemDataCellPainter.DrawContent;
begin
  if ViewInfo.HasBackground then
    DrawBackground;
  DrawText;
  ViewInfo.EditViewInfo.Paint(Canvas);
end;

procedure TcxGridViewLayoutItemDataCellPainter.DrawText;
begin
  with TdxCustomLayoutItemCaptionPainter.Create(ViewInfo.LayoutItemViewInfo.CaptionViewInfo) do
  try
    Paint(Canvas);
  finally
    Free;
  end;
end;

function TcxGridViewLayoutItemDataCellPainter.GetFocusRect: TRect;
begin
  Result := ViewInfo.GetFocusRect;
end;

procedure TcxGridViewLayoutItemDataCellPainter.Paint;
begin
  Canvas.SaveClipRegion;
  try
    Canvas.IntersectClipRect(ViewInfo.VisibleBounds);
    inherited Paint;
  finally
    Canvas.RestoreClipRegion;
  end;
end;

function TcxGridViewLayoutItemDataCellPainter.GetViewInfo: TcxGridViewLayoutItemDataCellViewInfo;
begin
  Result := TcxGridViewLayoutItemDataCellViewInfo(inherited ViewInfo);
end;

{ TcxGridViewLayoutItemDataCellViewInfo }

procedure TcxGridViewLayoutItemDataCellViewInfo.Calculate(ALeftBound, ATopBound,
  AWidth, AHeight: Integer);
begin
  if LayoutItemViewInfo = nil then Exit;
  inherited Calculate(ALeftBound, ATopBound, AWidth, AHeight);
end;

procedure TcxGridViewLayoutItemDataCellViewInfo.Calculate(const ABounds: TRect);
begin
  if LayoutItemViewInfo = nil then Exit;
  inherited Calculate(LayoutItemViewInfo.OriginalBounds);
end;

procedure TcxGridViewLayoutItemDataCellViewInfo.CalculateEditViewInfo(
  AEditViewInfo: TcxCustomEditViewInfo; const AMousePos: TPoint);
begin
  inherited CalculateEditViewInfo(AEditViewInfo, AMousePos);
  EditViewInfo.Transparent := IsValueTransparent;
  EditViewInfo.TextColor := AEditViewInfo.TextColor;
  EditViewInfo.IsSelected := AEditViewInfo.IsSelected and not GridView.OptionsSelection.InvertSelect;
end;

function TcxGridViewLayoutItemDataCellViewInfo.CanFocus: Boolean;
begin
  Result := Visible and LayoutItemViewInfo.Item.CanFocusControl;
end;

procedure TcxGridViewLayoutItemDataCellViewInfo.DoCalculateParams;
begin
  inherited DoCalculateParams;
  GetCaptionParams(CaptionParams);
  if IsValueTransparent then
    Params.TextColor := CaptionParams.TextColor;
end;

function TcxGridViewLayoutItemDataCellViewInfo.GetActualState: TcxGridCellState;
begin
  if HasSelectionBackground then
    Result := gcsPressed
  else
    if HasHotTrackBackground then
      Result := gcsSelected
    else
      Result := gcsNone;
end;

function TcxGridViewLayoutItemDataCellViewInfo.GetButtonState: TcxButtonState;
begin
  Result := inherited GetButtonState;
  if (Result = cxbsPressed) and not GridView.IsControlFocused then
    Result := cxbsDisabled;
end;

procedure TcxGridViewLayoutItemDataCellViewInfo.GetCaptionParams(
  var AParams: TcxViewParams);
begin
//do nothing
end;

function TcxGridViewLayoutItemDataCellViewInfo.GetEditViewDataBounds: TRect;
begin
  if LayoutItemViewInfo <> nil then
    Result := LayoutItemViewInfo.ControlViewInfo.Bounds
  else
    Result := inherited GetEditViewDataBounds;
end;

function TcxGridViewLayoutItemDataCellViewInfo.GetFocusRect: TRect;
begin
  if HasBackground then
    Result := cxRectInflate(ContentBounds, -2, -2)
  else
    Result := cxRectInflate(EditViewInfo.Bounds, -1, -1);
end;

function TcxGridViewLayoutItemDataCellViewInfo.GetMultiLine: Boolean;
begin
  Result := False;
end;

function TcxGridViewLayoutItemDataCellViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridViewLayoutItemDataCellPainter;
end;

function TcxGridViewLayoutItemDataCellViewInfo.GetRealEditViewDataBounds: TRect;
begin
  Result := GetEditViewDataBounds;
end;

function TcxGridViewLayoutItemDataCellViewInfo.GetTransparent: Boolean;
begin
  Result := False; //inherited GetTransparent or (Params.Color = clDefault);
end;

procedure TcxGridViewLayoutItemDataCellViewInfo.GetViewParams(var AParams: TcxViewParams);
begin
  GridView.Styles.GetDataCellParams(GridRecord, Item, Params, True, Self, True, True);
end;

function TcxGridViewLayoutItemDataCellViewInfo.GetVisible: Boolean;
begin
  Result := inherited GetVisible and (LayoutItemViewInfo <> nil) and
    LayoutItemViewInfo.ActuallyVisible;
end;

function TcxGridViewLayoutItemDataCellViewInfo.HasBackground: Boolean;
begin
  Result := HasSelectionBackground or HasHotTrackBackground;
end;

function TcxGridViewLayoutItemDataCellViewInfo.HasBorders: Boolean;
begin
  Result := True;
end;

function TcxGridViewLayoutItemDataCellViewInfo.HasFocusRect: Boolean;
begin
  Result := True;
end;

function TcxGridViewLayoutItemDataCellViewInfo.HasHotTrackBackground: Boolean;
begin
  Result := HotTracked;
end;

function TcxGridViewLayoutItemDataCellViewInfo.HasSelectionBackground: Boolean;
begin
  Result := Selected;
end;

function TcxGridViewLayoutItemDataCellViewInfo.IsValueTransparent: Boolean;
begin
  Result := HasHotTrackBackground and not (Focused and GridView.Controller.IsEditing);
end;

procedure TcxGridViewLayoutItemDataCellViewInfo.StateChanged(APrevState: TcxGridCellState);
begin
  CalculateParamsNeeded;
  inherited StateChanged(APrevState);
end;

function TcxGridViewLayoutItemDataCellViewInfo.GetLayoutItemViewInfo: TcxGridCustomLayoutItemViewInfo;
begin
  Result := GetLayoutItemViewInfoInstance;
end;

function TcxGridViewLayoutItemDataCellViewInfo.GetLayoutItemViewInfoBounds: TRect;
begin
  if LayoutItemViewInfo <> nil then
    Result := LayoutItemViewInfo.Bounds
  else
    Result := cxEmptyRect;
end;

function TcxGridViewLayoutItemDataCellViewInfo.GetVisibleBounds: TRect;
begin
  if LayoutItemViewInfo <> nil then
    Result := LayoutItemViewInfo.GetVisibleBounds
  else
    Result := Bounds;
end;

{ TcxGridLayoutCustomizationController }

function TcxGridLayoutCustomizationController.CanCustomize: Boolean;
begin
  Result := True;
end;

procedure TcxGridLayoutCustomizationController.CheckFormBounds(var R: TRect);
begin
  R := cxRectCenter(Screen.WorkAreaRect, R.Right - R.Left, R.Bottom - R.Top);
end;

procedure TcxGridLayoutCustomizationController.CustomizationChanged;
begin
  if Customization then
  begin
    DoCreateForm;
    DoCustomization;
    if Form.ShowModal = mrOk then
      TcxGridViewLayoutCustomizationForm(Form).ApplyChanges
    else
      TcxGridViewLayoutCustomizationForm(Form).CancelChanges;
    Customization := False;
  end
  else
  begin
    HideForm;
    DoCustomization;
  end;
end;

procedure TcxGridLayoutCustomizationController.DoCreateForm;
begin
  inherited DoCreateForm;
  InitializeForm(Form);
  TcxGridViewLayoutCustomizationForm(Form).Initialize(GridView);
end;

function TcxGridLayoutCustomizationController.GetFormBounds(AScaleFactor: TdxScaleFactor): TRect;
begin
  if IsRectEmpty(FormBounds) then
  begin
    Result := AScaleFactor.Apply(Rect(0, 0, GetFormDefaultWidth, GetFormDefaultHeight));
    CheckFormBounds(Result);
  end
  else
    Result := FormBounds;
end;

{ TdxGridLayoutRootViewInfo }

function TdxGridLayoutRootViewInfo.CanDrawBackground: Boolean;
begin
  Result := inherited CanDrawBackground and TcxGridLayoutContainerViewInfo(ContainerViewInfo).CanDrawRoot;
end;

{ TcxGridLayoutContainerTabOrderHelper }

constructor TcxGridLayoutContainerTabOrderHelper.Create(AContainer: TcxGridLayoutContainerViewInfo);
begin
  inherited Create;
  FContainer := AContainer;
end;

procedure TcxGridLayoutContainerTabOrderHelper.PopulateOrder(AOrderList: TList);
begin
  PopulateItem(AOrderList, Container.ItemsViewInfo);
end;

procedure TcxGridLayoutContainerTabOrderHelper.PopulateGridItem(AOrderList: TList; AItem: TcxGridCustomLayoutItemViewInfo);
begin
  AOrderList.Add(AItem.Item.GridViewItem);
end;

procedure TcxGridLayoutContainerTabOrderHelper.PopulateGroup(AOrderList: TList; AValue: TdxLayoutGroupViewInfo);
var
  I: Integer;
  AGroupViewInfo: TdxLayoutGroupViewInfo;
begin
  AGroupViewInfo := TdxLayoutGroupViewInfo(AValue);
  for I := 0 to AGroupViewInfo.ItemViewInfoCount - 1 do
    PopulateItem(AOrderList, AGroupViewInfo.ItemViewInfos[I]);
end;

procedure TcxGridLayoutContainerTabOrderHelper.PopulateItem(AOrderList: TList; AItem: TdxCustomLayoutItemViewInfo);
var
  AGroupItem: TdxLayoutGroupViewInfo absolute AItem;
  AGridItem: TcxGridCustomLayoutItemViewInfo absolute AItem;
begin
  if AItem is TdxLayoutGroupViewInfo then
    PopulateGroup(AOrderList, AGroupItem)
  else
    if (AItem is TcxGridCustomLayoutItemViewInfo) and AGridItem.ActuallyVisible and AGridItem.Enabled then
      PopulateGridItem(AOrderList, AGridItem);
end;

{ TcxGridLayoutContainerSmartOrderHelper }

constructor TcxGridLayoutContainerSmartOrderHelper.Create(AContainer: TcxGridLayoutContainerViewInfo);
begin
  inherited Create(AContainer);
  FContainerBounds := Container.ItemsViewInfo.Bounds;
end;

procedure TcxGridLayoutContainerSmartOrderHelper.Init(AFocusedItem: TdxCustomLayoutItemViewInfo;
  ADirection: TcxNeighbor; AStartNewCycle: Boolean);
begin
  FDirection := ADirection;
  FStartNewCycle := AStartNewCycle;
  FFocusedItem := AFocusedItem;
  FFocusedItemBounds := GetActualFocusedItemBounds;
end;

procedure TcxGridLayoutContainerSmartOrderHelper.PopulateOrder(AOrderList: TList);
var
  I: Integer;
  AList: TList;
begin
  AList := TList.Create;
  try
    inherited PopulateOrder(AList);
    DeleteItemsNonMatchesWithDirection(AList);
    AList.SortList(CompareItems);
    for I := 0 to AList.Count - 1 do
      AOrderList.Add(TcxGridCustomLayoutItemViewInfo(AList[I]).Item.GridViewItem);
  finally
    AList.Free;
  end;
end;

procedure TcxGridLayoutContainerSmartOrderHelper.PopulateGridItem(AOrderList: TList; AItem: TcxGridCustomLayoutItemViewInfo);
begin
  AOrderList.Add(AItem);
end;

function TcxGridLayoutContainerSmartOrderHelper.CompareItems(AItem1, AItem2: Pointer): Integer;
var
  ABounds1, ABounds2: TRect;
  AInRange1, AInRange2: Boolean;
begin
  ABounds1 := TcxGridCustomLayoutItemViewInfo(AItem1).Bounds;
  ABounds2 := TcxGridCustomLayoutItemViewInfo(AItem2).Bounds;
  if Direction in [nTop, nBottom] then
  begin
    Result := IfThen(Direction = nTop, CompareValue(ABounds2.Bottom, ABounds1.Bottom),
      CompareValue(ABounds1.Top, ABounds2.Top));
    if Result <> 0 then
      Exit;
    Result := CompareValue(ABounds1.Left, ABounds2.Left);
  end
  else
  begin
    Result := IfThen(Direction = nLeft, CompareValue(ABounds2.Right, ABounds1.Right),
      CompareValue(ABounds1.Left, ABounds2.Left));
    if Result <> 0 then
      Exit;
    AInRange1 := InRange(ABounds1.Top, FocusedItemBounds.Top, FocusedItemBounds.Bottom) or
       InRange(ABounds1.Bottom, FocusedItemBounds.Top, FocusedItemBounds.Bottom);
    AInRange2 := InRange(ABounds2.Top, FocusedItemBounds.Top, FocusedItemBounds.Bottom) or
       InRange(ABounds2.Bottom, FocusedItemBounds.Top, FocusedItemBounds.Bottom);
    Result := CompareValue(Integer(AInRange2), Integer(AInRange1));
    if Result <> 0 then
      Exit;
    if not AInRange1 and not AInRange2 then
    begin
      Result := CompareValue(Abs(ABounds1.Bottom - FocusedItemBounds.CenterPoint.Y),
          Abs(ABounds2.Bottom - FocusedItemBounds.CenterPoint.Y));
      if Result <> 0 then
        Exit;
    end;
    Result := CompareValue(ABounds1.Top, ABounds2.Top);
  end;
end;

function TcxGridLayoutContainerSmartOrderHelper.GetActualFocusedItemBounds: TRect;
begin
  Result := FocusedItem.Bounds;
  if StartNewCycle then
    case Direction of
      nTop:
        Result := cxRectOffset(Result, 0, ContainerBounds.Bottom - Result.Top);
      nBottom:
        Result := cxRectOffset(Result, 0, ContainerBounds.Top - Result.Bottom);
      nLeft:
        Result := cxRectOffset(Result, ContainerBounds.Right - Result.Left, 0);
      else
        Result := cxRectOffset(Result, ContainerBounds.Left - Result.Right, 0);
    end;
end;

procedure TcxGridLayoutContainerSmartOrderHelper.DeleteItemsNonMatchesWithDirection(AList: TList);
var
  I: Integer;
  AViewInfo: TcxGridCustomLayoutItemViewInfo;
begin
  for I := AList.Count - 1 downto 0 do
  begin
    AViewInfo := TcxGridCustomLayoutItemViewInfo(AList[I]);
    if (AViewInfo = FocusedItem) and not StartNewCycle or not IsItemMatchedWithDirection(AViewInfo) then
      AList.Delete(I);
  end;
end;

function TcxGridLayoutContainerSmartOrderHelper.IsItemMatchedWithDirection(
  AViewInfo: TdxCustomLayoutItemViewInfo): Boolean;
begin
  case Direction of
    nLeft:
      Result := AViewInfo.Bounds.Right < FocusedItemBounds.Left;
    nRight:
      Result := AViewInfo.Bounds.Left > FocusedItemBounds.Right;
    else
      Result := ((Direction = nTop) and (AViewInfo.Bounds.Bottom < FocusedItemBounds.Top) or
        (FDirection = nBottom) and (AViewInfo.Bounds.Top > FocusedItemBounds.Bottom)) and
        (InRange(AViewInfo.Bounds.Right, FocusedItemBounds.Left, FocusedItemBounds.Right) or
        InRange(AViewInfo.Bounds.Left, FocusedItemBounds.Left, FocusedItemBounds.Right));
  end;
end;


{ TcxGridCustomLayoutContainerViewInfo }

function TcxGridLayoutContainerViewInfo.CanItemValueAutoHeight: Boolean;
begin
  Result := False;
end;

function TcxGridLayoutContainerViewInfo.GetGridItemViewInfo(
  AViewInfo: TcxGridCustomLayoutItemViewInfo): TcxGridViewLayoutItemDataCellViewInfo;
begin
  Result := nil;
end;

procedure TcxGridLayoutContainerViewInfo.PopulateSmartOrderList(AList: TList;
  AFocusedItem: TdxCustomLayoutItemViewInfo; ADirection: TcxNeighbor; AStartNewCycle: Boolean);
var
  AHelper: TcxGridLayoutContainerSmartOrderHelper;
begin
  AHelper := TcxGridLayoutContainerSmartOrderHelper.Create(Self);
  try
    AHelper.Init(AFocusedItem, ADirection, AStartNewCycle);
    AHelper.PopulateOrder(AList);
  finally
    AHelper.Free;
  end;
end;

procedure TcxGridLayoutContainerViewInfo.PopulateTabOrderList(AList: TList);
var
  AOrderHelper: TcxGridLayoutContainerTabOrderHelper;
begin
  AOrderHelper := TcxGridLayoutContainerTabOrderHelper.Create(Self);
  try
    AOrderHelper.PopulateOrder(AList);
  finally
    AOrderHelper.Free;
  end;
end;

function TcxGridLayoutContainerViewInfo.CanDrawRoot: Boolean;
begin
  Result := True;
end;

function TcxGridLayoutContainerViewInfo.CanShowGroupScrollBars: Boolean;
begin
  Result := False;
end;

function TcxGridLayoutContainerViewInfo.CanUseCachedInfo: Boolean;
begin
  Result := False;
end;

function TcxGridLayoutContainerViewInfo.GetGridRecordInstance: TcxCustomGridRecord;
begin
  if RecordViewInfo <> nil then
    Result := RecordViewInfo.GridRecord
  else
    Result := nil;
end;

function TcxGridLayoutContainerViewInfo.GetRecordViewInfoInstance: TcxCustomGridRecordViewInfo;
begin
  Result := nil;
end;

function TcxGridLayoutContainerViewInfo.GetRootViewInfoClass: TdxLayoutRootViewInfoClass;
begin
  Result := TdxGridLayoutRootViewInfo;
end;

procedure TcxGridLayoutContainerViewInfo.RecreateViewData;
begin
  ItemViewDataList.Clear;
end;

function TcxGridLayoutContainerViewInfo.GetGridRecord: TcxCustomGridRecord;
begin
  Result := GetGridRecordInstance;
end;

function TcxGridLayoutContainerViewInfo.GetRecordViewInfo: TcxCustomGridRecordViewInfo;
begin
  Result := GetRecordViewInfoInstance;
end;

{ TdxLayoutCloneGroupViewData }

procedure TdxLayoutCloneGroupViewData.Assign(Source: TdxCustomLayoutItemViewData);
begin
  if Source is TdxLayoutCloneGroupViewData then
  begin
    FExpanded := TdxLayoutGroupViewData(Source).Expanded;
    FItemIndex := TdxLayoutGroupViewData(Source).ItemIndex;
  end;
  inherited Assign(Source);
end;

procedure TdxLayoutCloneGroupViewData.Calculate;
begin
  inherited;
  FExpanded := TdxLayoutControlItemAccess(Item).AsGroup.Expanded;
  FItemIndex := TdxLayoutControlItemAccess(Item).AsGroup.ItemIndex;
end;

procedure TdxLayoutCloneGroupViewData.Load(AStream: TStream);
begin
  inherited;
  AStream.Read(FExpanded, SizeOf(FExpanded));
  AStream.Read(FItemIndex, SizeOf(FItemIndex));
end;

procedure TdxLayoutCloneGroupViewData.Save(AStream: TStream);
begin
  inherited;
  AStream.Write(FExpanded, SizeOf(FExpanded));
  AStream.Write(FItemIndex, SizeOf(FItemIndex));
end;

procedure TdxLayoutCloneGroupViewData.Changed;
begin
  if not Item.Container.IsUpdateLocked then
    TdxLayoutItemViewDataListAccess(Owner).Changed;
end;

function TdxLayoutCloneGroupViewData.GetSize: Integer;
begin
  Result := inherited GetSize + SizeOf(FExpanded) + SizeOf(FItemIndex);
end;

function TdxLayoutCloneGroupViewData.GetExpanded: Boolean;
begin
  Result := FExpanded;
end;

function TdxLayoutCloneGroupViewData.GetItemIndex: Integer;
begin
  Result := FItemIndex;
end;

procedure TdxLayoutCloneGroupViewData.SetExpanded(Value: Boolean);
begin
  if FExpanded <> Value then
  begin
    FExpanded := Value;
    Changed;
  end;
end;

procedure TdxLayoutCloneGroupViewData.SetItemIndex(Value: Integer);
begin
  if FItemIndex <> Value then
  begin
    FItemIndex := Value;
    Changed;
  end;
end;

procedure TdxLayoutCloneGroupViewData.SetTabIndex(Value: Integer);
begin
  ItemIndex := Value;
end;

{ TcxGridRecordLayoutContainerViewInfo }

constructor TcxGridRecordLayoutContainerViewInfo.Create(
  AContainer: TdxLayoutContainer; ARecordViewInfo: TcxCustomGridRecordViewInfo);
begin
  inherited Create(AContainer);
  FRecordViewInfo := ARecordViewInfo;
end;

function TcxGridRecordLayoutContainerViewInfo.GetGridItemViewInfo(AViewInfo: TcxGridCustomLayoutItemViewInfo): TcxGridViewLayoutItemDataCellViewInfo;
begin
  if RecordViewInfo = nil then
    Result := inherited GetGridItemViewInfo(AViewInfo)
  else
  begin
    Result := FindGridItemViewInfo(AViewInfo);
  end;
end;

function TcxGridRecordLayoutContainerViewInfo.GetRecordViewInfoInstance: TcxCustomGridRecordViewInfo;
begin
  Result := FRecordViewInfo;
end;

function TcxGridRecordLayoutContainerViewInfo.GetLayoutItem(
  AViewInfo: TcxGridCustomLayoutItemViewInfo): TdxLayoutControlItem;
begin
  Result := AViewInfo.Item;
end;

function TcxGridRecordLayoutContainerViewInfo.GetItemOptions(AViewInfo: TdxCustomLayoutItemViewInfo): TdxCustomLayoutLookAndFeelOptions;
begin
  if AViewInfo is TdxLayoutGroupViewInfo then
    Result := GetLayoutLookAndFeel.GroupOptions
  else
    Result := GetLayoutLookAndFeel.ItemOptions;
end;

function TcxGridRecordLayoutContainerViewInfo.GetItemLayoutLookAndFeel(
  AViewInfo: TdxCustomLayoutItemViewInfo): TdxCustomLayoutLookAndFeel;
begin
  Result := GetLayoutLookAndFeel;
end;

function TcxGridRecordLayoutContainerViewInfo.GetViewDataClass(AItem: TdxCustomLayoutItem): TdxCustomLayoutItemViewDataClass;
begin
  if AItem is TdxCustomLayoutGroup then
    Result := TdxLayoutCloneGroupViewData
  else
    Result := inherited GetViewDataClass(AItem);
end;

{ TcxGridLayoutContainerCustomizationHelper }

function FindItemByData(AContainer: TdxLayoutContainer; AData: Pointer): TdxCustomLayoutItem;
var
  I: Integer;
  ASourceItem: TdxCustomLayoutItem;
begin
  Result := nil;
  for I := 0 to AContainer.AbsoluteItemCount - 1 do
  begin
    ASourceItem := AContainer.AbsoluteItems[I];
    if ASourceItem.Data = AData then
    begin
      Result := ASourceItem;
      Break;
    end;
  end;
end;

procedure TcxGridLayoutContainerCustomizationHelper.AssignStructureFromPattern;
var
  I: Integer;
  AItem: TdxCustomLayoutItem;
  AParent: TdxCustomLayoutGroup;
begin
  Container.BeginUpdate;
  try
    Container.Clear;
    for I := 0 to FPattern.AbsoluteItemCount - 1 do
    begin
      AItem := Container.CloneItem(FPattern.AbsoluteItems[I]);
      AItem.Data := FPattern.AbsoluteItems[I];
    end;
    for I := 0 to Container.AbsoluteItemCount - 1 do
    begin
      AItem := Container.AbsoluteItems[I];
      AParent := TdxCustomLayoutItem(AItem.Data).Parent;
      if AParent <> nil then
        if AParent.IsRoot then
          AItem.Parent := Container.Root
        else
          AItem.Parent := FindItemByData(Container, AParent) as TdxCustomLayoutGroup;
    end;
    for I := 0 to Container.AbsoluteItemCount - 1 do
      TdxCustomLayoutItemAccess(Container.AbsoluteItems[I]).LoadedIndex := FPattern.AbsoluteItems[I].Index;
    TdxLayoutContainerAccess(Container).CheckIndexes;

    Container.Root.Assign(FPattern.Root);
  finally
    Container.EndUpdate;
  end;
end;

procedure TcxGridLayoutContainerCustomizationHelper.AssignStructureToPattern;

  function FindDestinationItem(AItem: TdxCustomLayoutItem): TdxCustomLayoutItem;
  begin
    Result := nil;
    if TdxLayoutContainerAccess(FPattern).AbsoluteItemList.IndexOf(AItem.Data) > -1 then
      Result := TObject(AItem.Data) as TdxCustomLayoutItem;
  end;

var
  I: Integer;
  AItem: TdxCustomLayoutItem;
begin
  FPattern.BeginUpdate;
  try
    for I := 0 to FPattern.AbsoluteItemCount - 1 do
      FPattern.AbsoluteItems[I].Parent := nil;

    for I := 0 to Container.AbsoluteItemCount - 1 do
    begin
      AItem := Container.AbsoluteItems[I];
      if AItem.Data = nil then
      begin
        AItem := FPattern.CloneItem(Container.AbsoluteItems[I]);
        Container.AbsoluteItems[I].Data := AItem;
      end;
    end;

    for I := FPattern.AbsoluteItemCount - 1 downto 0 do
    begin
      AItem := FPattern.AbsoluteItems[I];
      if FindItemByData(Container, AItem) = nil then
      begin
        if csAncestor in AItem.ComponentState then 
        begin
          AItem.Data   := nil;
          AItem.Parent := nil;
        end
        else
          AItem.Free;
      end;
    end;

    for I := 0 to Container.AbsoluteItemCount - 1 do
    begin
      AItem := FindDestinationItem(Container.AbsoluteItems[I]);
      if Container.AbsoluteItems[I].Parent <> nil then
      begin
        if Container.AbsoluteItems[I].Parent.IsRoot then
          AItem.Parent := FPattern.Root
        else
          AItem.Parent := TdxCustomLayoutItemAccess(FindDestinationItem(Container.AbsoluteItems[I].Parent)).AsGroup;
      end;
    end;
    for I := 0 to Container.AbsoluteItemCount - 1 do
    begin
      AItem := FindDestinationItem(Container.AbsoluteItems[I]);
      AItem.Assign(Container.AbsoluteItems[I]);
      TdxCustomLayoutItemAccess(AItem).LoadedIndex := Container.AbsoluteItems[I].Index;
    end;
    TdxLayoutContainerAccess(FPattern).CheckIndexes;
    FPattern.Root.Assign(Container.Root);
  finally
    FPattern.EndUpdate;
  end;
end;

procedure TcxGridLayoutContainerCustomizationHelper.CopyStructure(AContainer: TdxLayoutContainer);
var
  AGridHelper: TcxGridLayoutContainerCustomizationHelper;
begin
  AGridHelper := TdxLayoutContainerAccess(AContainer).CustomizationHelper as TcxGridLayoutContainerCustomizationHelper;
  try
    if Container = AGridHelper.FPattern then
    begin
      FAssignLayoutMode := almToParent;
      AGridHelper.AssignStructureToPattern;
    end
    else
    begin
      FAssignLayoutMode := almFromParent;
      FPattern := AGridHelper.Container;
      AssignStructureFromPattern;
    end;
  finally
    FAssignLayoutMode := almNone;
  end;
end;

procedure TcxGridLayoutContainerCustomizationHelper.ResetPattern;
var
  I: Integer;
begin
  if FPattern <> nil then
  begin
    FPattern := nil;
    for I := 0 to Container.AbsoluteItemCount - 1 do
      Container.AbsoluteItems[I].Data := nil;
  end;
end;

{ TcxGridCustomLayoutContainer }

procedure TcxGridCustomLayoutContainer.DoInitialize;
begin
  inherited DoInitialize;
  HighlightRoot := False;
end;

procedure TcxGridCustomLayoutContainer.DoUpdateRootOptions;
const
  AlignHorzMap: array[Boolean] of TdxLayoutAlignHorz = (ahLeft, ahClient);
  AlignVertMap: array[Boolean] of TdxLayoutAlignVert = (avTop, avClient);
begin
  Root.AlignHorz := AlignHorzMap[NeedStretchRecordWidth];
  Root.AlignVert := AlignVertMap[NeedStretchRecordHeight];
end;

function TcxGridCustomLayoutContainer.GetCanvas: TcxCanvas;
begin
  Result := GridView.ViewInfo.Canvas;
end;

function TcxGridCustomLayoutContainer.GetCustomizationHelperClass: TdxLayoutContainerCustomizationHelperClass;
begin
  Result := TcxGridLayoutContainerCustomizationHelper;
end;

function TcxGridCustomLayoutContainer.GetCustomizationHelper: TcxGridLayoutContainerCustomizationHelper;
begin
  Result := inherited CustomizationHelper as TcxGridLayoutContainerCustomizationHelper;
end;

function TcxGridCustomLayoutContainer.GetGridView: TcxCustomGridTableView;
begin
  Result := TcxCustomGridTableView(Owner);
end;

function TcxGridCustomLayoutContainer.GetImages: TCustomImageList;
begin
  Result := GridView.GetImages;
end;

function TcxGridCustomLayoutContainer.GetItemsOwner: TComponent;
begin
  Result := GridView.Owner;
end;

function TcxGridCustomLayoutContainer.GetItemsParentComponent: TComponent;
begin
  Result := GridView;
end;

function TcxGridCustomLayoutContainer.GetItemsParentControl: TcxControl;
begin
  Result := GridView.Site;
end;

function TcxGridCustomLayoutContainer.IsRootStored: Boolean;
begin
  Result := False;
end;

procedure TcxGridCustomLayoutContainer.LayoutChanged(ANeedPack: Boolean = True);
begin
  if IsContainerReady and (Root.Count > 0) or FCalculationDireNeeded then
  begin
    FCalculationDireNeeded := False;
    DoCalculateRoot(ANeedPack);
    DoChanged;
  end;
end;

function TcxGridCustomLayoutContainer.NeedStretchRecordHeight: Boolean;
begin
  Result := False;
end;

function TcxGridCustomLayoutContainer.NeedStretchRecordWidth: Boolean;
begin
  Result := False;
end;

procedure TcxGridCustomLayoutContainer.UnregisterControlFont;
begin
  if GridView.Control <> nil then
    dxLayoutTextMetrics.Unregister(TcxGrid(GridView.Control).Font);
end;

procedure TcxGridCustomLayoutContainer.UnregisterFonts;
begin
  inherited UnregisterFonts;
  UnregisterControlFont;
  UnregisterSiteFont;
end;

procedure TcxGridCustomLayoutContainer.UnregisterSiteFont;
begin
  if GridView.Site <> nil then
    dxLayoutTextMetrics.Unregister(TcxControlAccess(GridView.Site).Font);
end;

procedure TcxGridCustomLayoutContainer.UpdateRootOptions;
begin
  BeginUpdate;
  try
    DoUpdateRootOptions;
  finally
    EndUpdate(False);
  end;
end;

end.
