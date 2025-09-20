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

unit cxGridRowLayout;

{$I cxVer.inc}

interface

uses
  Variants, Windows, Classes, Graphics, Controls, Contnrs, ImgList, StdCtrls,
  dxCore, cxClasses, cxGraphics, cxControls, cxStyles, cxLookAndFeelPainters,
  cxGridCommon, cxGrid, dxCoreClasses, dxGDIPlusClasses,
  cxGridCustomView, cxGridCustomTableView, dxLayoutLookAndFeels, cxDataStorage,
  cxCustomData, cxEdit, dxLayoutContainer, dxLayoutSelection,
  dxLayoutCommon, Forms, cxNavigator, cxLookAndFeels, SysUtils,
  cxGridViewLayoutContainer, cxMaskEdit, dxForms;

const
  cxGridRowLayoutMinValueWidth = 80; //for internal use only

type
  TcxGridRowLayoutDataCellViewInfo = class;
  TcxGridRowLayoutItem = class;
  TcxGridRowBaseLayoutItemViewInfo = class;
  TcxGridRowBaseLayoutItem = class;
  TcxGridRowLayoutItemEditViewInfo = class;
  TcxGridRowLayoutItemViewInfo = class;
  TcxGridRowLayoutContainerViewInfo = class;
  TcxGridRowLayoutContainer = class;
  TcxGridRowLayoutController = class;

  TcxGridRowLayoutStretch = (fsNone, fsHorizontal, fsVertical, fsClient);

  { TcxGridRowLayoutLookAndFeel }

  TcxGridRowLayoutLookAndFeel = class(TcxGridCustomLayoutLookAndFeel)
  public
    constructor Create(AGridView: TcxCustomGridTableView); override;
  end;

  { TcxGridRowLayoutItemDataCellPainter }

  TcxGridRowLayoutItemDataCellPainter = class(TcxGridViewLayoutItemDataCellPainter)
  protected
    procedure DrawBackground; override;
  end;

  { TcxGridRowLayoutItemEditPainter }

  TcxGridRowLayoutItemEditPainter = class(TcxGridCustomLayoutItemEditPainter)
  private
    function GetViewInfo: TcxGridRowLayoutItemEditViewInfo;
  protected
    procedure DrawEdit(ACanvas: TcxCanvas); override;
  public
    property ViewInfo: TcxGridRowLayoutItemEditViewInfo read GetViewInfo;
  end;

  { TcxGridRowLayoutItemPainter }

  TcxGridRowLayoutItemPainter = class(TcxGridCustomLayoutItemPainter)
  protected
    function GetControlPainterClass: TdxLayoutControlItemControlPainterClass; override;
  end;

  { TcxGridRowLayoutContainerPainter }

  TcxGridRowLayoutContainerPainter = class
  private
    FCanvas: TcxCanvas;
    FViewInfo: TcxGridRowLayoutContainerViewInfo;
  protected
    procedure DrawLayoutGroups; virtual;

    property Canvas: TcxCanvas read FCanvas;
    property ViewInfo: TcxGridRowLayoutContainerViewInfo read FViewInfo;
  public
    constructor Create(ACanvas: TcxCanvas; AViewInfo: TcxGridRowLayoutContainerViewInfo); virtual;

    procedure Paint; virtual;
  end;
  TcxGridRowLayoutContainerPainterClass = class of TcxGridRowLayoutContainerPainter;

  { TcxGridRowBaseLayoutItemCaptionViewInfo }

  TcxGridRowBaseLayoutItemCaptionViewInfo = class(TcxGridCustomLayoutItemCaptionViewInfo)
  strict private
    function GetItemViewInfo: TcxGridRowBaseLayoutItemViewInfo;
  protected
    function GetText: string; override;

    property ItemViewInfo: TcxGridRowBaseLayoutItemViewInfo read GetItemViewInfo;
  end;

  { TcxGridRowBaseLayoutItemEditViewInfo }

  TcxGridRowBaseLayoutItemEditViewInfo = class(TcxGridCustomLayoutItemEditViewInfo)
  private
    function GetItem: TcxGridRowBaseLayoutItem;inline;
  protected
    procedure GetDefaultValueParams(out AParams: TcxViewParams); override;
    function GetMinValueWidth: Integer; override;

    property Item: TcxGridRowBaseLayoutItem read GetItem;
  end;

  { TcxGridRowLayoutItemEditViewInfo }

  TcxGridRowLayoutItemEditViewInfo = class(TcxGridRowBaseLayoutItemEditViewInfo)
  private
    function GetItemViewInfo: TcxGridRowLayoutItemViewInfo;inline;
  protected
    function GetGridRecord: TcxCustomGridRecord; override;
    function IsValueHeightDependOnData: Boolean; override;

    property ItemViewInfo: TcxGridRowLayoutItemViewInfo read GetItemViewInfo;
  end;

  { TcxGridRowBaseLayoutItemViewInfo }

  TcxGridRowBaseLayoutItemViewInfo = class(TcxGridCustomLayoutItemViewInfo)
  private
    function GetItem: TcxGridRowBaseLayoutItem;inline;
  protected
    procedure DoAssignBounds(ASource: TdxCustomLayoutElementViewInfo); override;
    procedure DoRightToLeftConversion(const AClientBounds: TRect); override;
    procedure DoSetOffset(const AValue: TPoint; const ADiff: TPoint); override;
    function GetActuallyVisible: Boolean; override;
    function GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass; override;
    function GetControlViewInfoClass: TdxLayoutControlItemControlViewInfoClass; override;

    property Item: TcxGridRowBaseLayoutItem read GetItem;
  public
    procedure Calculate(const ABounds: TRect); override;
  end;

  { TcxGridRowLayoutItemViewInfo }

  TcxGridRowLayoutItemViewInfo = class(TcxGridRowBaseLayoutItemViewInfo)
  private
    function GetContainerViewInfo: TcxGridLayoutContainerViewInfo;inline;
    function GetControlViewInfo: TcxGridRowLayoutItemEditViewInfo;inline;
    function GetGridItemViewInfo: TcxGridRowLayoutDataCellViewInfo;inline;
    function GetItem: TcxGridRowLayoutItem;inline;
  protected
    function GetCurrentGridItemViewInfo: TcxGridViewLayoutItemDataCellViewInfo; override;
    function GetControlViewInfoClass: TdxLayoutControlItemControlViewInfoClass; override;
    function GetPainterClass: TdxCustomLayoutItemPainterClass; override;
  public
    property ContainerViewInfo: TcxGridLayoutContainerViewInfo read GetContainerViewInfo;
    property ControlViewInfo: TcxGridRowLayoutItemEditViewInfo read GetControlViewInfo;
    property GridItemViewInfo: TcxGridRowLayoutDataCellViewInfo read GetGridItemViewInfo;
    property Item: TcxGridRowLayoutItem read GetItem;
  end;

  { TcxGridRowLayoutItemCaptionOptions }

  TcxGridRowLayoutItemCaptionOptions = class(TcxGridCustomLayoutItemCaptionOptions)
  published
    property AlignHorz;
    property AlignVert;
    property Glyph;
    property ImageIndex;
    property Layout default clLeft;
    property Visible;
    property VisibleElements;
    property Width;
  end;

  { TcxGridRowBaseLayoutItem }

  TcxGridRowBaseLayoutItem = class(TcxGridCustomLayoutItem)
  private
    FCaptionSuffix: string;
    FMinValueWidth: Integer;
  protected
    function GetCaptionSuffix: string; virtual;
    function GetMinValueWidth: Integer; virtual;
    function GetViewInfoClass: TdxCustomLayoutItemViewInfoClass; override;

    property CaptionSuffix: string read GetCaptionSuffix;
  public
    procedure Assign(Source: TPersistent); override;

    property MinValueWidth: Integer read GetMinValueWidth;
  end;

  { TcxGridRowLayoutItem }

  TcxGridRowLayoutItem = class(TcxGridRowBaseLayoutItem)
  private
    function GetCaptionOptions: TcxGridRowLayoutItemCaptionOptions; inline;
    function GetLayoutController: TcxGridRowLayoutController;
    procedure SetCaptionOptions(Value: TcxGridRowLayoutItemCaptionOptions); inline;
  protected
    class function GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass; override;
    function GetCaptionSuffix: string; override;
    function GetMinValueWidth: Integer; override;
    function GetViewInfoClass: TdxCustomLayoutItemViewInfoClass; override;

    property LayoutController: TcxGridRowLayoutController read GetLayoutController;
  public
    function IsContainerRestoring: Boolean; virtual; //for internal use only
  published
    property CaptionOptions: TcxGridRowLayoutItemCaptionOptions read GetCaptionOptions write SetCaptionOptions;
  end;
  TcxGridRowLayoutItemClass = class of TcxGridRowLayoutItem;

  { TcxGridRowLayoutDataCellViewInfo }

  TcxGridRowLayoutDataCellViewInfo = class(TcxGridViewLayoutItemDataCellViewInfo)
  strict private
    function GetLayoutItemViewInfo: TcxGridRowLayoutItemViewInfo;
  protected
    function GetPainterClass: TcxCustomGridCellPainterClass; override;

    property LayoutItemViewInfo: TcxGridRowLayoutItemViewInfo read GetLayoutItemViewInfo;
  end;

  { TcxGridRowLayoutGridItemViewInfos }

  TcxGridRowLayoutGridItemViewInfos = class(TcxObjectList)
  private
    function GetItem(Index: TdxListIndex): TcxGridRowLayoutDataCellViewInfo;
  public
    function FindCellViewInfo(AItem: TcxCustomGridTableItem): TcxGridViewLayoutItemDataCellViewInfo; virtual;
    function GetHitTest(const P: TPoint): TcxCustomGridHitTest; virtual;
    function IsHotTracked: Boolean; virtual;
    procedure ResetStates; virtual;

    property Items[Index: TdxListIndex]: TcxGridRowLayoutDataCellViewInfo read GetItem; default;
  end;

  { TcxGridRowLayoutContainerViewInfo }

  TcxGridRowLayoutContainerViewInfo = class(TcxGridRecordLayoutContainerViewInfo)
  private
    function GetContainer: TcxGridRowLayoutContainer;
    function GetGridView: TcxCustomGridTableView;
    function GetRootMinHeight: Integer;
  protected
    function GetPainterClass: TcxGridRowLayoutContainerPainterClass; virtual;
    function GetViewDataClass(AItem: TdxCustomLayoutItem): TdxCustomLayoutItemViewDataClass; override;

    property GridView: TcxCustomGridTableView read GetGridView;
  public
    procedure Paint(ACanvas: TcxCanvas); virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;

    procedure Calculate(ARecreateViewData: Boolean); override;
    function CanItemValueAutoHeight: Boolean; override;

    property Container: TcxGridRowLayoutContainer read GetContainer;
    property RootMinHeight: Integer read GetRootMinHeight;
  end;

  { TcxGridRowLayoutContainer }

  TcxGridRowLayoutContainer = class(TcxGridCustomLayoutContainer)
  private
    FIsLayoutCreated: Boolean;
    FLayoutController: TcxGridRowLayoutController;

    function GetRootMinHeight: Integer;
    function GetViewInfo: TcxGridLayoutContainerViewInfo;
  protected
    procedure AfterRestoring; override;
    procedure DoInitialize; override;
    function GetClientBounds: TRect; override;
    function GetDefaultFont: TFont; override;
    function GetItemClass: TcxGridRowLayoutItemClass; virtual;
    function GetItemsOwner: TComponent; override;
    function GetViewInfoClass: TdxLayoutContainerViewInfoClass; override;
    procedure SetDefaultItemName(AItem: TdxCustomLayoutItem); override;
    procedure UpdateRootName; override;

    function CanCreateLayoutItem(AGridItem: TcxCustomGridTableItem): Boolean; virtual;
    function CanSetItemName(AItem: TdxCustomLayoutItem): Boolean; override;
    procedure CheckItemAlignment(AItem: TdxCustomLayoutItem);
    procedure CheckItemsAlignment;
    procedure CreateLayoutItem(AGridItem: TcxCustomGridTableItem);
    procedure CreateLayoutItems;
    procedure CheckRootGroupLayoutDirection; virtual;
    procedure CopyCustomizationSettings(AContainer: TdxLayoutContainer); virtual;
    procedure DoChanged; override;
    procedure InitLayout; virtual;
    function NeedStretchRecordHeight: Boolean; override;
    function NeedStretchRecordWidth: Boolean; override;
    procedure SetItemForGridItem(AGridItem: TcxCustomGridTableItem; AItem: TcxGridRowLayoutItem); virtual; abstract;

    function CanPlaceItem(AItem: TcxGridRowLayoutItem): Boolean; virtual;
    procedure CreateColumnGroup;
    procedure CreateGroups; virtual;
    procedure FixUpItemsOwnership;
    function GetGroupForPlacing: TdxCustomLayoutGroup;
    function GetValidItemName(const AName: TComponentName; ACheckExisting: Boolean): TComponentName;
    procedure PlaceItems; virtual;
    procedure Reset; virtual;

    property LayoutController: TcxGridRowLayoutController read FLayoutController;
    property RootMinHeight: Integer read GetRootMinHeight;
  public
    constructor Create(ALayoutController: TcxGridRowLayoutController); reintroduce; virtual;

    procedure CreateLayout; virtual;
    procedure DestroyLayout; virtual;
    procedure RecreateLayout; virtual;

    procedure CheckItemNames(const AOldName, ANewName: string); override;

    property IsLayoutCreated: Boolean read FIsLayoutCreated;
    property ViewInfo: TcxGridLayoutContainerViewInfo read GetViewInfo;
  end;
  TcxGridRowLayoutContainerClass = class of TcxGridRowLayoutContainer;

  { TcxGridRowLayoutCustomizationController }

  TcxGridRowLayoutCustomizationController = class(TcxGridLayoutCustomizationController)
  protected
    procedure DoCustomization; override;
    function GetFormDefaultHeight: Integer; override;
    function GetFormDefaultWidth: Integer; override;
  end;

  { TcxGridCustomRowLayoutOptions }

  TcxGridCustomRowLayoutOptions = class(TcxCustomGridOptions)
  strict private
    FActive: Boolean;
    FCaptionSuffix: string;
    FCellBorders: Boolean;
    FDefaultColumnCount: Integer;
    FDefaultStretch: TcxGridRowLayoutStretch;
    FIsAssigning: Boolean;
    FMinValueWidth: Integer;
    FUseDefaultLayout: Boolean;

    procedure SetActive(AValue: Boolean);
    procedure SetCaptionSuffix(const AValue: string);
    procedure SetCellBorders(const AValue: Boolean);
    procedure SetDefaultColumnCount(AValue: Integer);
    procedure SetDefaultStretch(const AValue: TcxGridRowLayoutStretch);
    procedure SetMinValueWidth(AValue: Integer);
    procedure SetUseDefaultLayout(AValue: Boolean);
  protected
    procedure ActiveChanged; virtual;
    procedure ChangeScale(M, D: Integer); override;
    procedure DoAssign(Source: TPersistent); virtual;
    function GetLayoutLocationName: string; virtual;
    function GetLayoutController: TcxGridRowLayoutController; virtual; abstract;
    function GetResetCustomSettingLayoutQuery: string; virtual;
    function NeedStretchRecordHeight: Boolean; virtual;
    function NeedStretchRecordWidth: Boolean; virtual;
    procedure UseDefaultLayoutChanged; virtual;

    property Active: Boolean read FActive write SetActive default False;
    property CaptionSuffix: string read FCaptionSuffix write SetCaptionSuffix;
    property MinValueWidth: Integer read FMinValueWidth write SetMinValueWidth default cxGridRowLayoutMinValueWidth;
    property LayoutController: TcxGridRowLayoutController read GetLayoutController;
  public
    constructor Create(AGridView: TcxCustomGridView); override;

    procedure Assign(Source: TPersistent); override;

    property CellBorders: Boolean read FCellBorders write SetCellBorders default True;
    property DefaultColumnCount: Integer read FDefaultColumnCount write SetDefaultColumnCount default 2;
    property DefaultStretch: TcxGridRowLayoutStretch read FDefaultStretch write SetDefaultStretch default fsNone;
    property UseDefaultLayout: Boolean read FUseDefaultLayout write SetUseDefaultLayout default True;
  end;

  { TcxGridRowLayoutController }

  TcxGridRowLayoutController = class
  strict private
    FContainer: TcxGridRowLayoutContainer;
    FCustomizationController: TcxGridRowLayoutCustomizationController;
    FGridView: TcxCustomGridTableView;
    FLayoutLookAndFeel: TcxGridRowLayoutLookAndFeel;

    function GetOptions: TcxGridCustomRowLayoutOptions;
  protected
    function CanDataCellAutoHeight: Boolean; virtual;
    procedure ChangeScale(M, D: Integer); virtual;
    function CreateCustomizationController: TcxGridRowLayoutCustomizationController; virtual; abstract;
    function CreateLayoutLookAndFeel:  TcxGridRowLayoutLookAndFeel; virtual;
    function GetContainerClass: TcxGridRowLayoutContainerClass; virtual;
    function GetOptionsInstance: TcxGridCustomRowLayoutOptions; virtual; abstract;
    procedure InitializeContainer; virtual;
    function IsContainerRestoring: Boolean; virtual;
    procedure Store(Proc: TGetChildProc); virtual;
    procedure UpdateLayoutLookAndFeel; virtual;

    property CustomizationController: TcxGridRowLayoutCustomizationController read FCustomizationController;
  public
    constructor Create(AGridView: TcxCustomGridTableView); reintroduce; virtual;
    destructor Destroy; override;

    procedure AfterRestoring; virtual;
    procedure AssignStructure(ASource: TcxGridRowLayoutController); virtual;
    procedure BeforeRestoring; virtual;
    procedure CheckContainerName(const AOldName, ANewName: string); virtual;
    procedure CopyCustomizationSetting(AContainer: TdxLayoutContainer); virtual;
    procedure Init; virtual;
    procedure ShowCustomizationForm; virtual;

    property Container: TcxGridRowLayoutContainer read FContainer;
    property GridView: TcxCustomGridTableView read FGridView;
    property Options: TcxGridCustomRowLayoutOptions read GetOptions;
    property LayoutLookAndFeel: TcxGridRowLayoutLookAndFeel read FLayoutLookAndFeel;
  end;

implementation

uses
  System.UITypes,
  RTLConsts, cxGeometry, cxContainer, Dialogs, cxGridStrs, dxThreading, Math, dxMessageDialog;

const
  dxThisUnitName = 'cxGridRowLayout';

const
  ResetCustomSettingLayoutQuery = 'This operation will revert the %s layout settings to the default settings. Do you wish to continue?';

type
  TdxCustomLayoutItemViewInfoAccess = class(TdxCustomLayoutItemViewInfo);
  TcxControlAccess = class(TcxControl);
  TdxCustomLayoutItemAccess = class(TdxCustomLayoutItem);
  TcxCustomGridTableViewAccess = class(TcxCustomGridTableView);
  TcxCustomGridCellViewInfoAccess = class(TcxCustomGridCellViewInfo);

{ TcxGridRowLayoutLookAndFeel }

constructor TcxGridRowLayoutLookAndFeel.Create(AGridView: TcxCustomGridTableView);
begin
  inherited Create(AGridView);
  LookAndFeel.MasterLookAndFeel := GridView.LookAndFeel;
  Offsets.RootItemsAreaOffsetVert := 10;
  Offsets.RootItemsAreaOffsetHorz := 13;
end;

{ TcxGridRowLayoutItemDataCellPainter }

procedure TcxGridRowLayoutItemDataCellPainter.DrawBackground;
begin
  ViewInfo.LookAndFeelPainter.DrawDataRowLayoutItemScaled(Canvas, ViewInfo.Bounds, ViewInfo.ButtonState, ViewInfo.ScaleFactor);
end;

{ TcxGridRowLayoutItemEditPainter }

procedure TcxGridRowLayoutItemEditPainter.DrawEdit(ACanvas: TcxCanvas);
begin
// do nothing
end;

function TcxGridRowLayoutItemEditPainter.GetViewInfo: TcxGridRowLayoutItemEditViewInfo;
begin
  Result := (inherited ViewInfo as TcxGridRowLayoutItemEditViewInfo);
end;

{ TcxGridRowLayoutItemPainter }

function TcxGridRowLayoutItemPainter.GetControlPainterClass: TdxLayoutControlItemControlPainterClass;
begin
  Result := TcxGridRowLayoutItemEditPainter;
end;

{ TcxGridRowLayoutContainerPainter }

constructor TcxGridRowLayoutContainerPainter.Create(ACanvas: TcxCanvas; AViewInfo: TcxGridRowLayoutContainerViewInfo);
begin
  inherited Create;
  FCanvas := ACanvas;
  FViewInfo := AViewInfo;
end;

procedure TcxGridRowLayoutContainerPainter.DrawLayoutGroups;
var
  APainter: TdxCustomLayoutItemPainter;
  AItemsViewInfo: TdxCustomLayoutItemViewInfoAccess;
begin
  AItemsViewInfo := TdxCustomLayoutItemViewInfoAccess(ViewInfo.ItemsViewInfo);
  APainter := AItemsViewInfo.GetPainterClass.Create(ViewInfo.ItemsViewInfo);
  try
    APainter.Paint(Canvas);
  finally
    APainter.Free;
  end;
end;

procedure TcxGridRowLayoutContainerPainter.Paint;
begin
  DrawLayoutGroups;
end;

{ TcxGridRowBaseLayoutItemCaptionViewInfo }

function TcxGridRowBaseLayoutItemCaptionViewInfo.GetText: string;
begin
  Result := inherited GetText + ItemViewInfo.Item.CaptionSuffix;
end;

function TcxGridRowBaseLayoutItemCaptionViewInfo.GetItemViewInfo: TcxGridRowBaseLayoutItemViewInfo;
begin
  Result := TcxGridRowBaseLayoutItemViewInfo(inherited ItemViewInfo);
end;

{ TcxGridRowBaseLayoutItemEditViewInfo }

procedure TcxGridRowBaseLayoutItemEditViewInfo.GetDefaultValueParams(
  out AParams: TcxViewParams);
begin
  GridView.Styles.GetDataCellParams(GetGridRecord, Item.GridViewItem, AParams);
end;

function TcxGridRowBaseLayoutItemEditViewInfo.GetItem: TcxGridRowBaseLayoutItem;
begin
  Result := TcxGridRowBaseLayoutItem(inherited Item);
end;

function TcxGridRowBaseLayoutItemEditViewInfo.GetMinValueWidth: Integer;
begin
  Result := Item.MinValueWidth;
end;

{ TcxGridRowLayoutItemEditViewInfo }

function TcxGridRowLayoutItemEditViewInfo.GetGridRecord: TcxCustomGridRecord;
begin
  Result := ItemViewInfo.ContainerViewInfo.GridRecord;
end;

function TcxGridRowLayoutItemEditViewInfo.IsValueHeightDependOnData: Boolean;
begin
  Result := inherited IsValueHeightDependOnData and ItemViewInfo.ContainerViewInfo.CanItemValueAutoHeight;
end;

function TcxGridRowLayoutItemEditViewInfo.GetItemViewInfo: TcxGridRowLayoutItemViewInfo;
begin
  Result := TcxGridRowLayoutItemViewInfo(inherited ItemViewInfo);
end;

{ TcxGridRowBaseLayoutItemViewInfo }

procedure TcxGridRowBaseLayoutItemViewInfo.Calculate(const ABounds: TRect);
begin
  inherited Calculate(ABounds);
  if GridItemViewInfo <> nil then
    GridItemViewInfo.Calculate(ABounds);
end;

procedure TcxGridRowBaseLayoutItemViewInfo.DoAssignBounds(ASource: TdxCustomLayoutElementViewInfo);
begin
  inherited DoAssignBounds(ASource);
  if GridItemViewInfo <> nil then
    GridItemViewInfo.Calculate(Bounds);
end;

procedure TcxGridRowBaseLayoutItemViewInfo.DoRightToLeftConversion(const AClientBounds: TRect);
begin
  inherited DoRightToLeftConversion(AClientBounds);
  if GridItemViewInfo <> nil then
    GridItemViewInfo.Calculate(Bounds);
end;

procedure TcxGridRowBaseLayoutItemViewInfo.DoSetOffset(const AValue: TPoint; const ADiff: TPoint);
begin
  inherited DoSetOffset(AValue, ADiff);
  if GridItemViewInfo <> nil then
    TcxCustomGridCellViewInfoAccess(GridItemViewInfo).Offset(ADiff.X, ADiff.Y);
end;

function TcxGridRowBaseLayoutItemViewInfo.GetActuallyVisible: Boolean;
begin
  Result := Assigned(Item) and
    Assigned(Item.GridViewItem) and
    inherited GetActuallyVisible;
end;

function TcxGridRowBaseLayoutItemViewInfo.GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass;
begin
  Result := TcxGridRowBaseLayoutItemCaptionViewInfo;
end;

function TcxGridRowBaseLayoutItemViewInfo.GetControlViewInfoClass: TdxLayoutControlItemControlViewInfoClass;
begin
  Result := TcxGridRowBaseLayoutItemEditViewInfo;
end;

function TcxGridRowBaseLayoutItemViewInfo.GetItem: TcxGridRowBaseLayoutItem;
begin
  Result:= TcxGridRowBaseLayoutItem(inherited Item);
end;

{ TcxGridRowLayoutItemViewInfo }

function TcxGridRowLayoutItemViewInfo.GetContainerViewInfo: TcxGridLayoutContainerViewInfo;
begin
  Result := TcxGridLayoutContainerViewInfo(inherited ContainerViewInfo);
end;

function TcxGridRowLayoutItemViewInfo.GetControlViewInfo: TcxGridRowLayoutItemEditViewInfo;
begin
  Result := TcxGridRowLayoutItemEditViewInfo(inherited ControlViewInfo);
end;

function TcxGridRowLayoutItemViewInfo.GetGridItemViewInfo: TcxGridRowLayoutDataCellViewInfo;
begin
  Result := TcxGridRowLayoutDataCellViewInfo(inherited GridItemViewInfo);
end;

function TcxGridRowLayoutItemViewInfo.GetItem: TcxGridRowLayoutItem;
begin
  Result := TcxGridRowLayoutItem(inherited Item);
end;

function TcxGridRowLayoutItemViewInfo.GetCurrentGridItemViewInfo: TcxGridViewLayoutItemDataCellViewInfo;
begin
  Result := ContainerViewInfo.GetGridItemViewInfo(Self);
end;

function TcxGridRowLayoutItemViewInfo.GetControlViewInfoClass: TdxLayoutControlItemControlViewInfoClass;
begin
  Result := TcxGridRowLayoutItemEditViewInfo;
end;

function TcxGridRowLayoutItemViewInfo.GetPainterClass: TdxCustomLayoutItemPainterClass;
begin
  Result := TcxGridRowLayoutItemPainter;
end;

{ TcxGridRowBaseLayoutItem }

procedure TcxGridRowBaseLayoutItem.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if Source is TcxGridRowBaseLayoutItem then
  begin
    FCaptionSuffix := TcxGridRowBaseLayoutItem(Source).CaptionSuffix;
    FMinValueWidth := TcxGridRowBaseLayoutItem(Source).MinValueWidth;
  end;
end;

function TcxGridRowBaseLayoutItem.GetCaptionSuffix: string;
begin
  Result := FCaptionSuffix;
end;

function TcxGridRowBaseLayoutItem.GetMinValueWidth: Integer;
begin
  Result := FMinValueWidth;
end;

function TcxGridRowBaseLayoutItem.GetViewInfoClass: TdxCustomLayoutItemViewInfoClass;
begin
  Result := TcxGridRowBaseLayoutItemViewInfo;
end;

{ TcxGridRowLayoutItem }

function TcxGridRowLayoutItem.IsContainerRestoring: Boolean;
begin
  Result := LayoutController.IsContainerRestoring;
end;

class function TcxGridRowLayoutItem.GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass;
begin
  Result := TcxGridRowLayoutItemCaptionOptions;
end;

function TcxGridRowLayoutItem.GetCaptionSuffix: string;
begin
  Result := LayoutController.Options.CaptionSuffix;
end;

function TcxGridRowLayoutItem.GetMinValueWidth: Integer;
begin
  Result := LayoutController.Options.MinValueWidth;
end;

function TcxGridRowLayoutItem.GetViewInfoClass: TdxCustomLayoutItemViewInfoClass;
begin
  Result := TcxGridRowLayoutItemViewInfo;
end;

function TcxGridRowLayoutItem.GetCaptionOptions: TcxGridRowLayoutItemCaptionOptions;
begin
  Result := TcxGridRowLayoutItemCaptionOptions(inherited CaptionOptions);
end;

function TcxGridRowLayoutItem.GetLayoutController: TcxGridRowLayoutController;
begin
  Result := TcxGridRowLayoutContainer(Container).LayoutController; 
end;

procedure TcxGridRowLayoutItem.SetCaptionOptions(Value: TcxGridRowLayoutItemCaptionOptions);
begin
  inherited CaptionOptions := Value;
end;

{ TcxGridRowLayoutDataCellViewInfo }

function TcxGridRowLayoutDataCellViewInfo.GetLayoutItemViewInfo: TcxGridRowLayoutItemViewInfo;
begin
  Result := TcxGridRowLayoutItemViewInfo(inherited LayoutItemViewInfo);
end;

function TcxGridRowLayoutDataCellViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridRowLayoutItemDataCellPainter;
end;

{ TcxGridRowLayoutGridItemViewInfos }

function TcxGridRowLayoutGridItemViewInfos.FindCellViewInfo(
  AItem: TcxCustomGridTableItem): TcxGridViewLayoutItemDataCellViewInfo;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    if Items[I].Item = AItem then
    begin
      Result := Items[I];
      Exit;
    end;
end;

function TcxGridRowLayoutGridItemViewInfos.GetHitTest(const P: TPoint): TcxCustomGridHitTest;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if (Items[I].LayoutItemViewInfo <> nil) and
      Items[I].LayoutItemViewInfo.ActuallyVisible then
      Result := Items[I].GetHitTest(P);
    if Result <> nil then
      Exit;
  end;
end;

function TcxGridRowLayoutGridItemViewInfos.IsHotTracked: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
  begin
    Result := Items[I].IsHotTracked;
    if Result then
      Exit;
  end;
end;

procedure TcxGridRowLayoutGridItemViewInfos.ResetStates;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].ResetState;
end;

function TcxGridRowLayoutGridItemViewInfos.GetItem(Index: TdxListIndex): TcxGridRowLayoutDataCellViewInfo;
begin
  Result := TcxGridRowLayoutDataCellViewInfo(inherited Items[Index]);
end;

{ TcxGridRowLayoutContainerViewInfo }

procedure TcxGridRowLayoutContainerViewInfo.Paint(ACanvas: TcxCanvas);
var
  APainter: TcxGridRowLayoutContainerPainter;
begin
  APainter := GetPainterClass.Create(ACanvas, Self);
  try
    APainter.Paint;
  finally
    APainter.Free;
  end;
end;

procedure TcxGridRowLayoutContainerViewInfo.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X: Integer; Y: Integer);
begin
  MouseMove(Shift, X, Y);
  inherited MouseDown(Button, Shift, X, Y);
end;

function TcxGridRowLayoutContainerViewInfo.GetPainterClass: TcxGridRowLayoutContainerPainterClass;
begin
  Result := TcxGridRowLayoutContainerPainter;
end;

function TcxGridRowLayoutContainerViewInfo.GetViewDataClass(AItem: TdxCustomLayoutItem): TdxCustomLayoutItemViewDataClass;
begin
  if AItem is TdxCustomLayoutGroup then
    Result := TdxLayoutGroupViewData
  else
    Result := inherited GetViewDataClass(AItem);
end;

procedure TcxGridRowLayoutContainerViewInfo.Calculate(ARecreateViewData: Boolean);
begin
  if GridView.ComponentState * [csReading, csLoading] = [] then
    inherited Calculate(ARecreateViewData);
end;

function TcxGridRowLayoutContainerViewInfo.CanItemValueAutoHeight: Boolean;
begin
  Result := Container.LayoutController.CanDataCellAutoHeight;
end;

function TcxGridRowLayoutContainerViewInfo.GetContainer: TcxGridRowLayoutContainer;
begin
  Result := TcxGridRowLayoutContainer(inherited Container);
end;

function TcxGridRowLayoutContainerViewInfo.GetGridView: TcxCustomGridTableView;
begin
  Result := Container.GridView;
end;

function TcxGridRowLayoutContainerViewInfo.GetRootMinHeight: Integer;
begin
  Result := Container.RootMinHeight;
end;

{ TcxGridRowLayoutContainer }

procedure TcxGridRowLayoutContainer.CopyCustomizationSettings(AContainer: TdxLayoutContainer);
begin
  GridView.BeginUpdate;
  try
    CustomizationHelper.CopyStructure(AContainer);
  finally
    GridView.EndUpdate;
  end;
end;

procedure TcxGridRowLayoutContainer.DoChanged;
begin
  inherited DoChanged;
  GridView.Changed(vcSize);
end;

procedure TcxGridRowLayoutContainer.Reset;
begin
  BeginUpdate;
  try
    DestroyItems;
    CreateItems;
  finally
    EndUpdate;
  end;
end;

procedure TcxGridRowLayoutContainer.AfterRestoring;
var
  I: Integer;
  AName: string;
  AItem: TdxCustomLayoutItem;
  AGridItem: TcxCustomGridTableItem;
  AGridView: TcxCustomGridTableViewAccess;
  AGridLayoutItem: TcxGridRowLayoutItem;
begin
  BeginUpdate;
  try
    for I := AbsoluteItemCount - 1 downto 0 do
    begin
      AItem := AbsoluteItems[I];
      if AItem is TcxGridRowLayoutItem then
      begin
        AGridLayoutItem := TcxGridRowLayoutItem(AItem);
        AGridView := TcxCustomGridTableViewAccess(GridView);
        AName := AGridLayoutItem.LoadedGridViewItemName;
        AGridItem := AGridView.FindItemByObjectName(AName);
        if AGridItem <> nil then
        begin
          AGridLayoutItem.GridViewItem := AGridItem;
          if AGridLayoutItem.CaptionOptions.IsCaptionAssigned then
            AGridItem.Caption := AGridLayoutItem.CaptionOptions.GridItemCaption;
        end
        else
          if AGridLayoutItem.GridViewItem = nil then
            FreeAndNil(AGridLayoutItem);
      end;
    end;
    inherited AfterRestoring;
    if LayoutController.Options.UseDefaultLayout then
      RecreateLayout;
  finally
    EndUpdate;
  end;
end;

procedure TcxGridRowLayoutContainer.DoInitialize;
begin
  inherited DoInitialize;
  MenuItems := MenuItems - [cfmiExpandButton];
end;

function TcxGridRowLayoutContainer.GetClientBounds: TRect;
begin
  Result := ClientRect;
end;

function TcxGridRowLayoutContainer.GetDefaultFont: TFont;
begin
  if GridView.Control <> nil then
    Result := TcxGrid(GridView.Control).Font
  else
    Result := TcxControlAccess(GridView.Site).Font;
end;

function TcxGridRowLayoutContainer.GetItemClass: TcxGridRowLayoutItemClass;
begin
  Result := TcxGridRowLayoutItem;
end;

function TcxGridRowLayoutContainer.GetItemsOwner: TComponent;
begin
  Result := Self;
end;

function TcxGridRowLayoutContainer.GetViewInfoClass: TdxLayoutContainerViewInfoClass;
begin
  Result := TcxGridLayoutContainerViewInfo;
end;

procedure TcxGridRowLayoutContainer.CheckItemAlignment(AItem: TdxCustomLayoutItem);
begin
  if AItem.Parent <> nil then
  begin
    AItem.AlignHorz := Root.AlignHorz;
    AItem.AlignVert := Root.AlignVert;
  end;
end;

procedure TcxGridRowLayoutContainer.CheckItemsAlignment;
var
  I: Integer;
begin
  for I := 0 to AbsoluteItemCount - 1 do
    CheckItemAlignment(AbsoluteItems[I]);
end;

procedure TcxGridRowLayoutContainer.CreateLayoutItem(AGridItem: TcxCustomGridTableItem);
var
  AItem: TcxGridRowLayoutItem;
begin
  AItem := TcxGridRowLayoutItem(CreateItem(GetItemClass));
  AItem.GridViewItem := AGridItem;
  SetItemForGridItem(AGridItem, AItem);
end;

procedure TcxGridRowLayoutContainer.CreateLayoutItems;
var
  I: Integer;
begin
  for I := 0 to GridView.ItemCount - 1 do
    if CanCreateLayoutItem(GridView.Items[I]) then
      CreateLayoutItem(GridView.Items[I]);
end;

procedure TcxGridRowLayoutContainer.CheckRootGroupLayoutDirection;
begin
  if LayoutController.Options.DefaultColumnCount > 1 then
    Root.LayoutDirection := ldHorizontal
  else
    Root.LayoutDirection := ldVertical;
end;

procedure TcxGridRowLayoutContainer.InitLayout;
begin
  FIsLayoutCreated := True;
  CreateLayoutItems;
  CheckIndexes;
  FixUpItemsOwnership;
  LayoutChanged;
end;

function TcxGridRowLayoutContainer.NeedStretchRecordHeight: Boolean;
begin
  Result := LayoutController.Options.NeedStretchRecordHeight;
end;

function TcxGridRowLayoutContainer.NeedStretchRecordWidth: Boolean;
begin
  Result := LayoutController.Options.NeedStretchRecordWidth;
end;

function TcxGridRowLayoutContainer.CanCreateLayoutItem(AGridItem: TcxCustomGridTableItem): Boolean;
begin
  Result := IsLayoutCreated and not IsDestroying and not GridView.IsDestroying and not AGridItem.IsDestroying;
end;

function TcxGridRowLayoutContainer.CanSetItemName(AItem: TdxCustomLayoutItem): Boolean;
begin
  Result := (ItemsParentComponent <> nil) and not (csAncestor in AItem.ComponentState) and SelectionHelper.CanModify;
end;

function TcxGridRowLayoutContainer.CanPlaceItem(AItem: TcxGridRowLayoutItem): Boolean;
begin
  Result := AItem.Visible;
end;

procedure TcxGridRowLayoutContainer.CreateColumnGroup;
var
  AGroup: TdxCustomLayoutGroup;
begin
  AGroup := GetAutoCreatedGroup;
  AGroup.Parent := Root;
  AGroup.LayoutDirection := ldVertical;
end;

procedure TcxGridRowLayoutContainer.CreateGroups;
var
  I: Integer;
begin
  for I := 0 to LayoutController.Options.DefaultColumnCount - 1 do
    CreateColumnGroup;
end;

constructor TcxGridRowLayoutContainer.Create(ALayoutController: TcxGridRowLayoutController);
begin
  FLayoutController := ALayoutController;
  inherited Create(FLayoutController.GridView);
end;

procedure TcxGridRowLayoutContainer.CreateLayout;
begin
  BeginUpdate;
  try
    FIsLayoutCreated := True;
    UpdateRootOptions;
    CheckRootGroupLayoutDirection;
    CreateGroups;
    CreateLayoutItems;
    PlaceItems;
    CheckItemsAlignment;
  finally
    EndUpdate;
  end;
end;

procedure TcxGridRowLayoutContainer.DestroyLayout;
begin
  Reset;
  FIsLayoutCreated := False;
end;

procedure TcxGridRowLayoutContainer.RecreateLayout;
begin
  DestroyLayout;
  if LayoutController.Options.Active then
    CreateLayout;
end;

function TcxGridRowLayoutContainer.GetGroupForPlacing: TdxCustomLayoutGroup;
var
  I: Integer;
  AGroup: TdxCustomLayoutGroup;
begin
  Result := nil;
  for I := 0 to AbsoluteItemCount - 1 do
    if AbsoluteItems[I] is TdxCustomLayoutGroup then
    begin
      AGroup := TdxCustomLayoutGroup(AbsoluteItems[I]);
      if (Result = nil) or (AGroup.Count < Result.Count) then
        Result := AGroup;
    end;
end;

procedure TcxGridRowLayoutContainer.PlaceItems;
var
  I: Integer;
begin
  for I := 0 to AbsoluteItemCount - 1 do
    if AbsoluteItems[I] is TcxGridRowLayoutItem then
      if CanPlaceItem(TcxGridRowLayoutItem(AbsoluteItems[I])) then
        AbsoluteItems[I].Parent := GetGroupForPlacing;
end;

function TcxGridRowLayoutContainer.GetRootMinHeight: Integer;
begin
  if Root <> nil then
    Result := Root.ViewInfo.MinHeight
  else
    Result := 0;
end;

function TcxGridRowLayoutContainer.GetViewInfo: TcxGridLayoutContainerViewInfo;
begin
  Result := TcxGridLayoutContainerViewInfo(inherited ViewInfo);
end;


procedure TcxGridRowLayoutContainer.SetDefaultItemName(AItem: TdxCustomLayoutItem);
begin
  if not GridView.IsLoading then
    AItem.Name := GetValidItemName(TdxCustomLayoutItemAccess(AItem).GetBaseName, False);
end;

procedure TcxGridRowLayoutContainer.UpdateRootName;
begin
  Root.Name := GetValidItemName(ItemsParentComponent.Name + 'RootGroup', True);
end;

function TcxGridRowLayoutContainer.GetValidItemName(const AName: TComponentName; ACheckExisting: Boolean): TComponentName;
var
  AIndex: Integer;

  function GetNextName: string;
  begin
    Result := AName + IntToStr(AIndex);
    Inc(AIndex);
  end;

  function FindComponentInSource(ASource: TComponent; ACheckChildren, ASkipSelf: Boolean; const AName: string): TComponent;
  var
    I: Integer;
  begin
    if (ASource = Self) and ASkipSelf then
      Result := nil
    else
    begin
      Result := ASource.FindComponent(AName);
      if (Result = nil) and ACheckChildren then
        for I := 0 to ASource.ComponentCount - 1 do
        begin
          Result := FindComponentInSource(ASource.Components[I], True, ASkipSelf, AName);
          if Result <> nil then
            Break;
        end;
    end;
  end;

  function IsValidName(const AName: TComponentName): Boolean;
  begin
    Result := (FindComponentInSource(Self, False, False, AName) = nil) and
      (FindComponentInSource(GridView, True, True, AName) = nil) and
      ((GridView.Owner = nil) or (FindComponentInSource(GridView.Owner, False, True, AName) = nil));
  end;

begin
  AIndex := 1;
  if ACheckExisting then
    Result := AName
  else
    Result := GetNextName;
  while not IsValidName(Result) do
    Result := GetNextName;
end;

procedure TcxGridRowLayoutContainer.CheckItemNames(const AOldName, ANewName: string);

  procedure RenameComponent(AComponent: TComponent; ANewName: TComponentName;
    const AOldName: TComponentName; AValidate: Boolean);
  var
    AComponentName, ANamePrefix: TComponentName;
  begin
    AComponentName := AComponent.Name;
    if Length(AComponentName) > Length(AOldName) then
    begin
      ANamePrefix := Copy(AComponentName, 1, Length(AOldName));
      if CompareText(AOldName, ANamePrefix) = 0 then
      begin
        Delete(AComponentName, 1, Length(AOldName));
        Insert(ANewName, AComponentName, 1);
        if AValidate then
          AComponentName := GetValidItemName(AComponentName, True);
        try
          AComponent.Name := AComponentName;
        except
          on EComponentError do ;
        end;
      end;
    end;
  end;

  procedure RenameComponents(ACaller: TComponent; const ANewName, AOldName: TComponentName;
    AComponentCount: Integer; AGetComponent: TcxGetComponent);
  var
    I: Integer;
    AComponent: TComponent;
  begin
    for I := 0 to AComponentCount - 1 do
    begin
      AComponent := AGetComponent(ACaller, I);
      RenameComponent(AComponent, ANewName, AOldName, False);
    end;
  end;

  function GetItem(ACaller: TComponent; Index: Integer): TComponent;
  begin
    Result := TdxLayoutContainer(ACaller).AbsoluteItems[Index];
  end;

  function GetAlignmentConstraints(ACaller: TComponent; Index: Integer): TComponent;
  begin
    Result := TdxLayoutContainer(ACaller).AlignmentConstraints[Index];
  end;

begin
  if CanSetItemName(Root) and not (csAncestor in Owner.ComponentState) then
  begin
    UpdateRootName;
    RenameComponents(Self, ANewName, AOldName, AbsoluteItemCount, @GetItem);
    RenameComponents(Self, ANewName, AOldName, AlignmentConstraintCount, @GetAlignmentConstraints);
    CustomizeFormPostUpdate([cfutCaption]);
  end;
end;

procedure TcxGridRowLayoutContainer.FixUpItemsOwnership;
var
  I: Integer;
  ALayoutItem: TdxCustomLayoutItem;
  AGridItem: TcxCustomGridTableItem;
begin
  if AbsoluteItemCount = 0 then
    Exit;
  BeginUpdate;
  try
    for I := 0 to AbsoluteItemCount - 1 do
    begin
      ALayoutItem := AbsoluteItems[I];
      if ALayoutItem.Owner = Self then
        Continue;
      if ALayoutItem is TcxGridRowLayoutItem then
        AGridItem := TcxGridRowLayoutItem(ALayoutItem).GridViewItem
      else
        AGridItem := nil;
      InsertComponent(ALayoutItem);
      if AGridItem <> nil then
        SetItemForGridItem(AGridItem, TcxGridRowLayoutItem(ALayoutItem));
    end;
  finally
    EndUpdate;
  end;
end;

{ TcxGridRowLayoutCustomizationController }

procedure TcxGridRowLayoutCustomizationController.DoCustomization;
begin
//do nothing
end;

function TcxGridRowLayoutCustomizationController.GetFormDefaultHeight: Integer;
begin
  Result := cxGridLayoutCustomizationFormDefaultHeight;
end;

function TcxGridRowLayoutCustomizationController.GetFormDefaultWidth: Integer;
begin
  Result := cxGridLayoutCustomizationFormDefaultWidth;
end;

{ TcxGridCustomRowLayoutOptions }

constructor TcxGridCustomRowLayoutOptions.Create(AGridView: TcxCustomGridView);
begin
  inherited Create(AGridView);
  FCellBorders := True;
  FDefaultColumnCount := 2;
  FMinValueWidth := cxGridRowLayoutMinValueWidth;
  FUseDefaultLayout := True;
end;

procedure TcxGridCustomRowLayoutOptions.Assign(Source: TPersistent);
begin
  FIsAssigning := True;
  try
    DoAssign(Source);
  finally
    FIsAssigning := False;
  end;
end;

procedure TcxGridCustomRowLayoutOptions.ActiveChanged;
begin
  if not GridView.IsLoading and UseDefaultLayout then
    LayoutController.Container.RecreateLayout;
  Changed(vcSize);
end;

procedure TcxGridCustomRowLayoutOptions.ChangeScale(M, D: Integer);
begin
  inherited ChangeScale(M, D);
  MinValueWidth := MulDiv(MinValueWidth, M, D);
end;

procedure TcxGridCustomRowLayoutOptions.DoAssign(Source: TPersistent);
var
  AOptions: TcxGridCustomRowLayoutOptions absolute Source;
begin
  if Source is TcxGridCustomRowLayoutOptions then
  begin
    CaptionSuffix := AOptions.CaptionSuffix;
    DefaultColumnCount := AOptions.DefaultColumnCount;
    DefaultStretch := AOptions.DefaultStretch;
    CellBorders := AOptions.CellBorders;
    MinValueWidth := AOptions.MinValueWidth;
    UseDefaultLayout := AOptions.UseDefaultLayout;
  end;
end;

function TcxGridCustomRowLayoutOptions.GetLayoutLocationName: string;
begin
  Result := 'row';
end;

function TcxGridCustomRowLayoutOptions.GetResetCustomSettingLayoutQuery: string;
begin
  Result := Format(ResetCustomSettingLayoutQuery, [GetLayoutLocationName]);
end;

function TcxGridCustomRowLayoutOptions.NeedStretchRecordHeight: Boolean;
begin
  Result := (DefaultStretch in [fsVertical, fsClient]);
end;

function TcxGridCustomRowLayoutOptions.NeedStretchRecordWidth: Boolean;
begin
  Result := (DefaultStretch in [fsHorizontal, fsClient]);
end;

procedure TcxGridCustomRowLayoutOptions.UseDefaultLayoutChanged;
begin
  if not GridView.IsLoading then
  begin
    if UseDefaultLayout then
      LayoutController.Container.RecreateLayout
    else
      if not LayoutController.Container.IsLayoutCreated then
        LayoutController.Container.CreateLayout;
  end;
  Changed(vcSize);
end;

procedure TcxGridCustomRowLayoutOptions.SetActive(AValue: Boolean);
begin
  if AValue <> Active then
  begin
    FActive := AValue;
    ActiveChanged;
  end;
end;

procedure TcxGridCustomRowLayoutOptions.SetCaptionSuffix(const AValue: string);
begin
  if AValue <> CaptionSuffix then
  begin
    FCaptionSuffix := AValue;
    Changed(vcSize);
  end;
end;

procedure TcxGridCustomRowLayoutOptions.SetCellBorders(const AValue: Boolean);
begin
  if AValue <> CellBorders then
  begin
    FCellBorders := AValue;
    Changed(vcSize);
  end;
end;

procedure TcxGridCustomRowLayoutOptions.SetDefaultColumnCount(AValue: Integer);
begin
  AValue := Max(AValue, 1);
  if (AValue <> DefaultColumnCount) then
  begin
    FDefaultColumnCount := AValue;
    if UseDefaultLayout and not GridView.IsLoading then
      LayoutController.Container.RecreateLayout;
    Changed(vcSize);
  end;
end;

procedure TcxGridCustomRowLayoutOptions.SetDefaultStretch(const AValue: TcxGridRowLayoutStretch);
begin
  if AValue <> DefaultStretch then
  begin
    FDefaultStretch := AValue;
    LayoutController.Container.UpdateRootOptions;
    if UseDefaultLayout and Active and not GridView.IsLoading then
      LayoutController.Container.CheckItemsAlignment;
    Changed(vcSize);
  end;
end;

procedure TcxGridCustomRowLayoutOptions.SetMinValueWidth(AValue: Integer);
begin
  AValue := Max(AValue, 0);
  if AValue <> MinValueWidth then
  begin
    FMinValueWidth := AValue;
    Changed(vcSize);
  end;
end;

procedure TcxGridCustomRowLayoutOptions.SetUseDefaultLayout(AValue: Boolean);
begin
  if GridView.IsDesigning and not FIsAssigning and AValue then
    AValue := not (dxMessageDlg(GetResetCustomSettingLayoutQuery, mtWarning, [mbYes, mbNo], 0) in [mrNo, mrCancel]);
  if AValue <> UseDefaultLayout then
  begin
    FUseDefaultLayout := AValue;
    UseDefaultLayoutChanged;
  end;
end;

{ TcxGridRowLayoutController }

constructor TcxGridRowLayoutController.Create(AGridView: TcxCustomGridTableView);
begin
  inherited Create;
  FGridView := AGridView;
  FContainer := GetContainerClass.Create(Self);
  FCustomizationController := CreateCustomizationController;
  FLayoutLookAndFeel := CreateLayoutLookAndFeel;
  UpdateLayoutLookAndFeel;
  InitializeContainer;
end;

destructor TcxGridRowLayoutController.Destroy;
begin
  FreeAndNil(FLayoutLookAndFeel);
  FreeAndNil(FCustomizationController);
  FreeAndNil(FContainer);
  inherited Destroy;
end;

procedure TcxGridRowLayoutController.AfterRestoring;
begin
  Container.IsRestoring := False;
  Container.EndUpdate;
end;

procedure TcxGridRowLayoutController.AssignStructure(ASource: TcxGridRowLayoutController);
begin
  Container.BeginUpdate;
  try
    LayoutLookAndFeel.Assign(ASource.LayoutLookAndFeel);
    if not ASource.Options.UseDefaultLayout then
      Container.CopyCustomizationSettings(ASource.Container);
  finally
    Container.EndUpdate;
  end;
end;

procedure TcxGridRowLayoutController.BeforeRestoring;
begin
  Container.BeginUpdate;
  Container.IsRestoring := True;
end;

procedure TcxGridRowLayoutController.CheckContainerName(const AOldName, ANewName: string);
begin
  Container.CheckItemNames(AOldName, ANewName);
end;

procedure TcxGridRowLayoutController.CopyCustomizationSetting(AContainer: TdxLayoutContainer);
begin
  Container.CopyCustomizationSettings(AContainer);
end;

procedure TcxGridRowLayoutController.Init;
begin
  UpdateLayoutLookAndFeel;
  if not Options.UseDefaultLayout then
    Container.InitLayout
  else
    if Options.Active then
      Container.CreateLayout;
end;

procedure TcxGridRowLayoutController.ShowCustomizationForm;
begin
  CustomizationController.Customization := True;
end;

function TcxGridRowLayoutController.CanDataCellAutoHeight: Boolean;
begin
  Result := GridView.ViewInfo.RecordsViewInfo.AutoDataCellHeight;
end;

procedure TcxGridRowLayoutController.ChangeScale(M, D: Integer);
begin
  LayoutLookAndFeel.ChangeScale(M, D);
  Container.ChangeScale(M, D);
end;

function TcxGridRowLayoutController.CreateLayoutLookAndFeel:  TcxGridRowLayoutLookAndFeel;
begin
  Result := TcxGridRowLayoutLookAndFeel.Create(GridView);
end;

function TcxGridRowLayoutController.GetContainerClass: TcxGridRowLayoutContainerClass;
begin
  Result := TcxGridRowLayoutContainer;
end;

procedure TcxGridRowLayoutController.InitializeContainer;
begin
  Container.Initialize;
  Container.LayoutLookAndFeel := LayoutLookAndFeel;
end;

function TcxGridRowLayoutController.IsContainerRestoring: Boolean;
begin
  Result := Container.IsRestoring;
end;

procedure TcxGridRowLayoutController.Store(Proc: TGetChildProc);
begin
  Container.StoreChildren(Proc);
end;

procedure TcxGridRowLayoutController.UpdateLayoutLookAndFeel;
begin
//do nothing
end;

function TcxGridRowLayoutController.GetOptions: TcxGridCustomRowLayoutOptions;
begin
  Result := GetOptionsInstance;
end;

end.
