{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressGanttControl                                      }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSGANTTCONTROL AND ALL           }
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

unit dxGanttControlViewResourceSheet;

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  System.UITypes, System.Contnrs,
  SysUtils, Windows, Messages, Types, Forms, Controls, Graphics, Dialogs,
  Classes, Themes, Generics.Defaults, Generics.Collections, StdCtrls,
  dxCore, dxCoreClasses, cxClasses, cxControls, cxCustomCanvas, cxGeometry,
  cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, cxStorage,
  dxGanttControlCustomView,
  dxGanttControlCommands,
  dxGanttControlCustomSheet,
  dxGanttControlCustomClasses,
  dxGanttControlSplitter,
  dxGanttControlDataModel,
  dxGanttControlResources,
  dxGanttControlCalendars,
  dxGanttControlCustomDataModel;

type
  TdxGanttControlResourceSheetView = class;
  TdxGanttControlResourceSheetController = class;
  TdxGanttControlResourceSheetViewController = class;

  { TdxViewResourceSheetDeleteFocusedItemCommand }

  TdxViewResourceSheetDeleteFocusedItemCommand = class(TdxGanttControlSheetDeleteFocusedItemCommand)
  strict private
    function GetController: TdxGanttControlResourceSheetController; inline;
  protected
    procedure DoExecute; override;
    property Controller: TdxGanttControlResourceSheetController read GetController;
  end;

  { TdxGanttControlResourceSheetViewInfo }

  TdxGanttControlResourceSheetViewInfo = class(TdxGanttControlSheetCustomViewInfo);

  { TdxGanttControlViewResourceSheetViewInfo }

  TdxGanttControlViewResourceSheetViewInfo = class(TdxGanttControlViewCustomViewInfo)
  strict private
    FInnerViewInfo: TdxGanttControlResourceSheetViewInfo;
    function GetView: TdxGanttControlResourceSheetView; inline;
  protected
    function CalculateItemBounds(AItem: TdxGanttControlCustomItemViewInfo): TRect; override;
    procedure Clear; override;
    function CreateInnerViewInfo: TdxGanttControlResourceSheetViewInfo; virtual;

    property InnerViewInfo: TdxGanttControlResourceSheetViewInfo read FInnerViewInfo;
  public
    procedure CalculateLayout; override;
    procedure Calculate(const R: TRect); override;

    property View: TdxGanttControlResourceSheetView read GetView;
  end;

  { TdxGanttControlResourceSheetController }

  TdxGanttControlResourceSheetController = class(TdxGanttControlViewSheetController)
  strict private
    FParentController: TdxGanttControlResourceSheetViewController;
    procedure ResourceChangedHandler(Sender: TdxGanttControlDataModel; AResource: TdxGanttControlResource);
    procedure ResourceListBeforeResetHandler(Sender: TObject);
    procedure ResourceListChangedHandler(Sender: TObject; const AItem: TdxGanttControlModelElementListItem;
      AAction: TCollectionNotification);
    function GetFocusedDataItem: TdxGanttControlResource; inline;
  protected
    function GetView: TdxGanttControlCustomView; override;
    function GetViewInfo: TdxGanttControlCustomItemViewInfo; override;

    procedure DeleteFocusedItem; override;

    property FocusedDataItem: TdxGanttControlResource read GetFocusedDataItem;
  public
    constructor Create(AParentController: TdxGanttControlResourceSheetViewController); reintroduce;
    destructor Destroy; override;
  end;

  { TdxGanttControlResourceSheetViewController }

  TdxGanttControlResourceSheetViewController = class(TdxGanttControlViewCustomController)
  strict private
    FSheetController: TdxGanttControlResourceSheetController;
    function GetView: TdxGanttControlResourceSheetView;
    function InternalGetViewInfo: TdxGanttControlViewResourceSheetViewInfo; inline;
  protected
    function GetControllerByCursorPos(const P: TPoint): TdxGanttControlCustomController; override;

    procedure DoKeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DoKeyPress(var Key: Char); override;
    procedure DoKeyUp(var Key: Word; Shift: TShiftState); override;

    procedure Activated; override;
    procedure Deactivated; override;
    procedure DoCreateScrollBars; override;
    procedure DoDestroyScrollBars; override;
    procedure InitScrollbars; override;
    function IsMouseWheelHandleNeeded(const MousePos: TPoint): Boolean; override;
    function ProcessNCSizeChanged: Boolean; override;
    procedure UnInitScrollbars; override;
    function InitializeBuiltInPopupMenu(APopupMenu: TdxGanttControlPopupMenu; var P: TPoint): Boolean; override;

    property ViewInfo: TdxGanttControlViewResourceSheetViewInfo read InternalGetViewInfo;
  public
    constructor Create(AView: TdxGanttControlCustomView); override;
    destructor Destroy; override;

    property SheetController: TdxGanttControlResourceSheetController read FSheetController; // for internal use
    property View: TdxGanttControlResourceSheetView read GetView;
  end;

  { TdxGanttControlResourceSheetViewDataProvider }

  TdxGanttControlResourceSheetViewDataProvider = class(TdxGanttControlSheetCustomDataProvider)
  strict private
    FDataModel: TdxGanttControlDataModel;

    procedure ResourceBeforeResetHandler(Sender: TObject);
    procedure ResourceChangedHandler(Sender: TObject; const AItem: TdxGanttControlModelElementListItem;
      AAction: TCollectionNotification);

    function InternalGetItem(Index: Integer): TdxGanttControlResource; inline;
    function GetResource(AIndex: Integer): TdxGanttControlResource; inline;
  protected
    procedure InternalAppendItem; override;
    procedure InternalInsertNewItem(AIndex: Integer); override;
    procedure InternalInsertItem(AIndex: Integer; ADataItem: TObject); override;
    function GetRowHeaderCaption(AData: TObject): string; override;
    procedure InternalExtractLastItem; override;
    function IsBlank(ADataItem: TObject): Boolean; override;

    function CanAddItem(AItem: TObject): Boolean; override;
    function CanCollapse(AItem: TObject): Boolean; override;
    function CanExpand(AItem: TObject): Boolean; override;
    function GetDataItemCount: Integer; override;
    function GetDataItem(Index: Integer): TObject; override;
    function GetDataItemIndex(ADataItem: TObject): Integer; override;
    procedure InternalExtractItem(AIndex: Integer); override;
    procedure MoveDataItem(AData: TObject; ANewIndex: Integer); override;

    property Items[Index: Integer]: TdxGanttControlResource read InternalGetItem;
  public
    constructor Create(AControl: TdxGanttControlBase); override;
    destructor Destroy; override;

    property DataModel: TdxGanttControlDataModel read FDataModel;
    property Resources[AIndex: Integer]: TdxGanttControlResource read GetResource; default;
  end;

  { TdxGanttControlResourceViewSheetOptions }

  TdxGanttControlResourceStartDragEvent = procedure(Sender: TObject; AResource: TdxGanttControlResource; var AAllow: Boolean) of object;
  TdxGanttControlResourceDragAndDropEvent = procedure(Sender: TObject; AResource: TdxGanttControlResource; ANewID: Integer; var AAccept: Boolean) of object;
  TdxGanttControlResourceEndDragEvent = procedure(Sender: TObject; AResource: TdxGanttControlResource) of object;

  TdxGanttControlResourceViewSheetOptions = class(TdxGanttControlViewSheetOptions)
  strict private
    FOnResourceDragAndDrop: TdxGanttControlResourceDragAndDropEvent;
    FOnResourceEndDrag: TdxGanttControlResourceEndDragEvent;
    FOnResourceStartDrag: TdxGanttControlResourceStartDragEvent;
    function InternalGetOwner: TdxGanttControlResourceSheetView; inline;
    function GetAllowResourceMove: Boolean;
    procedure SetAllowResourceMove(const Value: Boolean);
  protected
    function CreateColumns: TdxGanttControlSheetColumns; override;
    function GetController: TdxGanttControlSheetController; override;
    function GetDataProvider: TdxGanttControlSheetCustomDataProvider; override;
    function GetOwnerComponent: TComponent; override;
    function GetScaleFactor: TdxScaleFactor; override;
    function DoRowStartDrag(ADataItem: TObject): Boolean; override;
    function DoRowDragAndDrop(ADataItem: TObject; ANewIndex: Integer): Boolean; override;
    procedure DoRowEndDrag(ADataItem: TObject); override;
  public
    property Owner: TdxGanttControlResourceSheetView read InternalGetOwner;
  published
    property AllowResourceMove: Boolean read GetAllowResourceMove write SetAllowResourceMove default True;
    property CellAutoHeight;
    property Columns;
    property RowHeight;
    property OnResourceDragAndDrop: TdxGanttControlResourceDragAndDropEvent read FOnResourceDragAndDrop write FOnResourceDragAndDrop;
    property OnResourceEndDrag: TdxGanttControlResourceEndDragEvent read FOnResourceEndDrag write FOnResourceEndDrag;
    property OnResourceStartDrag: TdxGanttControlResourceStartDragEvent read FOnResourceStartDrag write FOnResourceStartDrag;
  end;

  { TdxGanttControlResourceSheetView }

  TdxGanttControlResourceSheetView = class(TdxGanttControlCustomView)
  strict private
    FOptionsSheet: TdxGanttControlResourceViewSheetOptions;

    procedure OptionsChangedHandler(Sender: TObject; AChanges: TdxGanttControlOptionsChangedTypes);

    function InternalGetController: TdxGanttControlResourceSheetViewController;
    function InternalGetDataProvider: TdxGanttControlResourceSheetViewDataProvider;
    procedure SetOptionsSheet(const Value: TdxGanttControlResourceViewSheetOptions);
  protected
    function CreateController: TdxGanttControlViewCustomController; override;
    function CreateDataProvider: TdxGanttControlCustomDataProvider; override;
    function CreateViewInfo: TdxGanttControlViewCustomViewInfo; override;
    procedure DoAssign(Source: TPersistent); override;
    procedure DoReset; override;
    function GetType: TdxGanttControlViewType; override;
    // IcxStoredObject
    function GetObjectName: string; override;
    procedure GetCustomProperties(AProperties: TStrings); override;
    // IcxStoredParent
    procedure StoredChildren(AChildren: TStringList); override;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;

    property Controller: TdxGanttControlResourceSheetViewController read InternalGetController; // for internal use
    property DataProvider: TdxGanttControlResourceSheetViewDataProvider read InternalGetDataProvider;
  published
    property OptionsSheet: TdxGanttControlResourceViewSheetOptions read FOptionsSheet write SetOptionsSheet;
  end;

implementation

uses
  dxGanttControl,
  dxGanttControlResourceCommands,
  dxGanttControlResourceSheetColumns;

const
  dxThisUnitName = 'dxGanttControlViewResourceSheet';

type
  TdxGanttControlElementCustomListAccess = class(TdxGanttControlModelElementList);

{ TdxViewResourceSheetDeleteFocusedItemCommand }

procedure TdxViewResourceSheetDeleteFocusedItemCommand.DoExecute;
begin
  inherited DoExecute;
  with TdxGanttControlDeleteResourceCommand.Create(Control, Controller.FocusedDataItem) do
  try
    Execute;
  finally
    Free;
  end;
end;

function TdxViewResourceSheetDeleteFocusedItemCommand.GetController: TdxGanttControlResourceSheetController;
begin
  Result := TdxGanttControlResourceSheetController(inherited Controller);
end;

{ TdxGanttControlViewResourceSheetViewInfo }

procedure TdxGanttControlViewResourceSheetViewInfo.Calculate(const R: TRect);
begin
  inherited Calculate(R);
end;

function TdxGanttControlViewResourceSheetViewInfo.CalculateItemBounds(
  AItem: TdxGanttControlCustomItemViewInfo): TRect;
begin
  Result := Bounds;
end;

procedure TdxGanttControlViewResourceSheetViewInfo.CalculateLayout;
begin
  Clear;
  FInnerViewInfo := CreateInnerViewInfo;
  AddChild(FInnerViewInfo);
  inherited CalculateLayout;
end;

procedure TdxGanttControlViewResourceSheetViewInfo.Clear;
begin
  inherited Clear;
  FInnerViewInfo := nil;
end;

function TdxGanttControlViewResourceSheetViewInfo.CreateInnerViewInfo: TdxGanttControlResourceSheetViewInfo;
begin
  Result := TdxGanttControlResourceSheetViewInfo.Create(Self, View.OptionsSheet);
end;

function TdxGanttControlViewResourceSheetViewInfo.GetView: TdxGanttControlResourceSheetView;
begin
  Result := TdxGanttControlResourceSheetView(inherited View);
end;

{ TdxGanttControlResourceSheetController }

constructor TdxGanttControlResourceSheetController.Create(
  AParentController: TdxGanttControlResourceSheetViewController);
begin
  inherited Create(AParentController.Control, AParentController.View.OptionsSheet);
  FParentController := AParentController;
  TdxCustomGanttControl(Control).DataModel.ResourceChangedHandlers.Add(ResourceChangedHandler);
  TdxCustomGanttControl(Control).DataModel.Resources.ListChangedHandlers.Add(ResourceListChangedHandler);
  TdxCustomGanttControl(Control).DataModel.Resources.BeforeResetHandlers.Add(ResourceListBeforeResetHandler);
end;

destructor TdxGanttControlResourceSheetController.Destroy;
begin
  TdxCustomGanttControl(Control).DataModel.Resources.ListChangedHandlers.Remove(ResourceListChangedHandler);
  TdxCustomGanttControl(Control).DataModel.Resources.BeforeResetHandlers.Remove(ResourceListBeforeResetHandler);
  TdxCustomGanttControl(Control).DataModel.ResourceChangedHandlers.Remove(ResourceChangedHandler);
  inherited Destroy;
end;

procedure TdxGanttControlResourceSheetController.DeleteFocusedItem;
begin
  with TdxViewResourceSheetDeleteFocusedItemCommand.Create(Self) do
  try
    Execute;
  finally
    Free;
  end;
end;

function TdxGanttControlResourceSheetController.GetFocusedDataItem: TdxGanttControlResource;
begin
  Result := TdxGanttControlResource(inherited FocusedDataItem);
end;

function TdxGanttControlResourceSheetController.GetView: TdxGanttControlCustomView;
begin
  Result := FParentController.View;
end;

function TdxGanttControlResourceSheetController.GetViewInfo: TdxGanttControlCustomItemViewInfo;
begin
  if FParentController.ViewInfo = nil then
    Result := nil
  else
    Result := FParentController.ViewInfo.InnerViewInfo
end;

procedure TdxGanttControlResourceSheetController.ResourceChangedHandler(Sender: TdxGanttControlDataModel; AResource: TdxGanttControlResource);
begin
  if (FParentController.ViewInfo = nil) or (FParentController.ViewInfo.InnerViewInfo = nil) then
    Exit;
  if AResource <> nil then
    FParentController.ViewInfo.InnerViewInfo.CachedDataRowHeight.Remove(AResource);
end;

procedure TdxGanttControlResourceSheetController.ResourceListBeforeResetHandler(
  Sender: TObject);
begin
  if (FParentController.ViewInfo = nil) or (FParentController.ViewInfo.InnerViewInfo = nil) then
    Exit;
  FParentController.ViewInfo.InnerViewInfo.CachedDataRowHeight.Clear;
end;

procedure TdxGanttControlResourceSheetController.ResourceListChangedHandler(
  Sender: TObject; const AItem: TdxGanttControlModelElementListItem;
  AAction: TCollectionNotification);
begin
  if (FParentController.ViewInfo = nil) or (FParentController.ViewInfo.InnerViewInfo = nil) then
    Exit;
  if AAction in [cnExtracted, cnRemoved] then
    FParentController.ViewInfo.InnerViewInfo.CachedDataRowHeight.Remove(AItem);
end;

{ TdxGanttControlResourceSheetViewController }

constructor TdxGanttControlResourceSheetViewController.Create(
  AView: TdxGanttControlCustomView);
begin
  inherited Create(AView);
  FSheetController := TdxGanttControlResourceSheetController.Create(Self);
end;

destructor TdxGanttControlResourceSheetViewController.Destroy;
begin
  FreeAndNil(FSheetController);
  inherited Destroy;
end;

function TdxGanttControlResourceSheetViewController.GetControllerByCursorPos(const P: TPoint): TdxGanttControlCustomController;
begin
  Result := SheetController;
end;

procedure TdxGanttControlResourceSheetViewController.Activated;
begin
  SheetController.Activated;
end;

procedure TdxGanttControlResourceSheetViewController.Deactivated;
begin
  SheetController.Deactivated;
end;

procedure TdxGanttControlResourceSheetViewController.DoCreateScrollBars;
begin
  SheetController.DoCreateScrollBars;
end;

procedure TdxGanttControlResourceSheetViewController.DoDestroyScrollBars;
begin
  SheetController.DoDestroyScrollBars;
end;

procedure TdxGanttControlResourceSheetViewController.DoKeyDown(var Key: Word;
  Shift: TShiftState);
begin
  inherited DoKeyDown(Key, Shift);
  if Key <> 0 then
    SheetController.KeyDown(Key, Shift);
end;

procedure TdxGanttControlResourceSheetViewController.DoKeyPress(var Key: Char);
begin
  inherited DoKeyPress(Key);
  if Key <> #0 then
    SheetController.KeyPress(Key);
end;

procedure TdxGanttControlResourceSheetViewController.DoKeyUp(var Key: Word;
  Shift: TShiftState);
begin
  inherited DoKeyUp(Key, Shift);
  if Key <> 0 then
    SheetController.KeyUp(Key, Shift);
end;

function TdxGanttControlResourceSheetViewController.InitializeBuiltInPopupMenu(
  APopupMenu: TdxGanttControlPopupMenu; var P: TPoint): Boolean;
begin
  Result := SheetController.InitializeBuiltInPopupMenu(APopupMenu, P);
end;

procedure TdxGanttControlResourceSheetViewController.InitScrollbars;
begin
  SheetController.InitScrollbars;
end;

function TdxGanttControlResourceSheetViewController.IsMouseWheelHandleNeeded(const MousePos: TPoint): Boolean;
begin
  Result := not FSheetController.EditingController.IsEditing;
end;

function TdxGanttControlResourceSheetViewController.ProcessNCSizeChanged: Boolean;
begin
  Result := FSheetController.ProcessNCSizeChanged;
end;

procedure TdxGanttControlResourceSheetViewController.UnInitScrollbars;
begin
  SheetController.UnInitScrollbars;
end;

function TdxGanttControlResourceSheetViewController.GetView: TdxGanttControlResourceSheetView;
begin
  Result := TdxGanttControlResourceSheetView(inherited View);
end;

function TdxGanttControlResourceSheetViewController.InternalGetViewInfo: TdxGanttControlViewResourceSheetViewInfo;
begin
  Result := TdxGanttControlViewResourceSheetViewInfo(inherited ViewInfo);
end;

{ TdxGanttControlResourceSheetViewDataProvider }

constructor TdxGanttControlResourceSheetViewDataProvider.Create(
  AControl: TdxGanttControlBase);
begin
  inherited Create(AControl);
  FDataModel := TdxCustomGanttControl(AControl).DataModel;
  FDataModel.Resources.ListChangedHandlers.Add(ResourceChangedHandler);
  FDataModel.Resources.BeforeResetHandlers.Add(ResourceBeforeResetHandler);
end;

destructor TdxGanttControlResourceSheetViewDataProvider.Destroy;
begin
  FDataModel.Resources.ListChangedHandlers.Remove(ResourceChangedHandler);
  FDataModel.Resources.BeforeResetHandlers.Remove(ResourceBeforeResetHandler);
  inherited Destroy;
end;

function TdxGanttControlResourceSheetViewDataProvider.CanAddItem(
  AItem: TObject): Boolean;
begin
  Result := TdxGanttControlResource(AItem).ID > 0;
end;

function TdxGanttControlResourceSheetViewDataProvider.CanCollapse(
  AItem: TObject): Boolean;
begin
  Result := False;
end;

function TdxGanttControlResourceSheetViewDataProvider.CanExpand(
  AItem: TObject): Boolean;
begin
  Result := False;
end;

function TdxGanttControlResourceSheetViewDataProvider.GetDataItemCount: Integer;
begin
  Result := FDataModel.Resources.Count;
end;

function TdxGanttControlResourceSheetViewDataProvider.GetDataItem(
  Index: Integer): TObject;
begin
  Result := FDataModel.Resources[Index];
end;

function TdxGanttControlResourceSheetViewDataProvider.GetDataItemIndex(
  ADataItem: TObject): Integer;
begin
  Result := TdxGanttControlResource(ADataItem).ID;
end;

function TdxGanttControlResourceSheetViewDataProvider.GetResource(
  AIndex: Integer): TdxGanttControlResource;
begin
  Result := TdxGanttControlResource(inherited Items[AIndex]);
end;

function TdxGanttControlResourceSheetViewDataProvider.GetRowHeaderCaption(
  AData: TObject): string;
begin
  if AData = nil then
    Result := inherited GetRowHeaderCaption(AData)
  else
    Result := IntToStr(TdxGanttControlResource(AData).ID);
end;

procedure TdxGanttControlResourceSheetViewDataProvider.InternalAppendItem;
var
  AResource: TdxGanttControlResource;
begin
  AResource := DataModel.Resources.Append;
  AResource.Blank := True;
end;

procedure TdxGanttControlResourceSheetViewDataProvider.InternalExtractItem(
  AIndex: Integer);
begin
  TdxGanttControlElementCustomListAccess(DataModel.Resources).InternalExtract(Items[AIndex]);
end;

procedure TdxGanttControlResourceSheetViewDataProvider.InternalExtractLastItem;
var
  AResource: TdxGanttControlResource;
begin
  AResource := DataModel.Resources[DataModel.Resources.Count - 1];
  TdxGanttControlElementCustomListAccess(DataModel.Resources).InternalExtract(AResource);
end;

function TdxGanttControlResourceSheetViewDataProvider.InternalGetItem(
  Index: Integer): TdxGanttControlResource;
begin
  Result := TdxGanttControlResource(inherited DataItems[Index]);
end;

procedure TdxGanttControlResourceSheetViewDataProvider.InternalInsertItem(
  AIndex: Integer; ADataItem: TObject);
begin
  TdxGanttControlElementCustomListAccess(DataModel.Resources).InternalInsert(AIndex, TdxGanttControlModelElementListItem(ADataItem));
end;

procedure TdxGanttControlResourceSheetViewDataProvider.InternalInsertNewItem(
  AIndex: Integer);
var
  AResource: TdxGanttControlResource;
begin
  AResource := TdxGanttControlResource(TdxGanttControlElementCustomListAccess(DataModel.Resources).CreateItem);
  AResource.Blank := True;
  InternalInsertItem(AIndex, AResource);
end;

function TdxGanttControlResourceSheetViewDataProvider.IsBlank(
  ADataItem: TObject): Boolean;
begin
  Result := TdxGanttControlResource(ADataItem).Blank;
end;

procedure TdxGanttControlResourceSheetViewDataProvider.MoveDataItem(
  AData: TObject; ANewIndex: Integer);
var
  AResource: TdxGanttControlResource;
begin
  AResource := TdxGanttControlResource(AData);
  with TdxGanttControlMoveResourceCommand.Create(Control, AResource, ANewIndex) do
  try
    Execute;
  finally
    Free;
  end;
end;

procedure TdxGanttControlResourceSheetViewDataProvider.ResourceBeforeResetHandler(
  Sender: TObject);
begin
  ClearItems;
end;

procedure TdxGanttControlResourceSheetViewDataProvider.ResourceChangedHandler(
  Sender: TObject; const AItem: TdxGanttControlModelElementListItem;
  AAction: TCollectionNotification);
begin
  if AAction in [cnRemoved, cnExtracted]  then
    ItemRemoved(AItem);
end;

{ TdxGanttControlResourceViewSheetOptions }

function TdxGanttControlResourceViewSheetOptions.CreateColumns: TdxGanttControlSheetColumns;
begin
  Result := TdxGanttControlResourceSheetColumns.Create(Self);
end;

function TdxGanttControlResourceViewSheetOptions.DoRowStartDrag(
  ADataItem: TObject): Boolean;
begin
  Result := inherited DoRowStartDrag(ADataItem);
  if Assigned(OnResourceStartDrag) then
    OnResourceStartDrag(Self, TdxGanttControlResource(ADataItem), Result);
end;

function TdxGanttControlResourceViewSheetOptions.DoRowDragAndDrop(ADataItem: TObject; ANewIndex: Integer): Boolean;
begin
  Result := inherited DoRowDragAndDrop(ADataItem, ANewIndex);
  if Assigned(OnResourceDragAndDrop) then
    OnResourceDragAndDrop(Self, TdxGanttControlResource(ADataItem), ANewIndex, Result);
end;

procedure TdxGanttControlResourceViewSheetOptions.DoRowEndDrag(ADataItem: TObject);
begin
  inherited DoRowEndDrag(ADataItem);
  if Assigned(OnResourceEndDrag) then
    OnResourceEndDrag(Self, TdxGanttControlResource(ADataItem));
end;

function TdxGanttControlResourceViewSheetOptions.GetController: TdxGanttControlSheetController;
begin
  if Owner.Controller = nil then
    Result := nil
  else
    Result := TdxGanttControlResourceSheetViewController(Owner.Controller).SheetController;
end;

function TdxGanttControlResourceViewSheetOptions.GetDataProvider: TdxGanttControlSheetCustomDataProvider;
begin
  Result := TdxGanttControlSheetCustomDataProvider(Owner.DataProvider);
end;

function TdxGanttControlResourceViewSheetOptions.GetOwnerComponent: TComponent;
begin
  Result := Owner.Owner;
end;

function TdxGanttControlResourceViewSheetOptions.GetScaleFactor: TdxScaleFactor;
begin
  Result := Owner.ScaleFactor;
end;

function TdxGanttControlResourceViewSheetOptions.InternalGetOwner: TdxGanttControlResourceSheetView;
begin
  Result := TdxGanttControlResourceSheetView(inherited Owner);
end;

function TdxGanttControlResourceViewSheetOptions.GetAllowResourceMove: Boolean;
begin
  Result := AllowRowMove;
end;

procedure TdxGanttControlResourceViewSheetOptions.SetAllowResourceMove(
  const Value: Boolean);
begin
  AllowRowMove := Value;
end;

{ TdxGanttControlResourceSheetView }

constructor TdxGanttControlResourceSheetView.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FOptionsSheet := TdxGanttControlResourceViewSheetOptions.Create(Self);
  FOptionsSheet.ChangedHandlers.Add(OptionsChangedHandler);
end;

destructor TdxGanttControlResourceSheetView.Destroy;
begin
  FreeAndNil(FOptionsSheet);
  inherited Destroy;
end;

procedure TdxGanttControlResourceSheetView.DoReset;
begin
  inherited DoReset;
  FOptionsSheet.Reset;
end;

procedure TdxGanttControlResourceSheetView.DoAssign(Source: TPersistent);
begin
  if Source is TdxGanttControlResourceSheetView then
    OptionsSheet := TdxGanttControlResourceSheetView(Source).OptionsSheet;
  inherited DoAssign(Source);
end;

function TdxGanttControlResourceSheetView.CreateController: TdxGanttControlViewCustomController;
begin
  Result := TdxGanttControlResourceSheetViewController.Create(Self);
end;

function TdxGanttControlResourceSheetView.CreateDataProvider: TdxGanttControlCustomDataProvider;
begin
  Result := TdxGanttControlResourceSheetViewDataProvider.Create(Owner);
end;

function TdxGanttControlResourceSheetView.CreateViewInfo: TdxGanttControlViewCustomViewInfo;
begin
  Result := TdxGanttControlViewResourceSheetViewInfo.Create(Self);
end;

function TdxGanttControlResourceSheetView.GetType: TdxGanttControlViewType;
begin
  Result := TdxGanttControlViewType.ResourceSheet;
end;

function TdxGanttControlResourceSheetView.InternalGetController: TdxGanttControlResourceSheetViewController;
begin
  Result := TdxGanttControlResourceSheetViewController(inherited Controller);
end;

function TdxGanttControlResourceSheetView.InternalGetDataProvider: TdxGanttControlResourceSheetViewDataProvider;
begin
  Result := TdxGanttControlResourceSheetViewDataProvider(inherited DataProvider);
end;

procedure TdxGanttControlResourceSheetView.OptionsChangedHandler(
  Sender: TObject; AChanges: TdxGanttControlOptionsChangedTypes);
begin
  Changed(AChanges);
end;

procedure TdxGanttControlResourceSheetView.SetOptionsSheet(
  const Value: TdxGanttControlResourceViewSheetOptions);
begin
  FOptionsSheet.Assign(Value);
end;

// IcxStoredObject }

function TdxGanttControlResourceSheetView.GetObjectName: string;
begin
  Result := 'ResourceSheet';
end;

procedure TdxGanttControlResourceSheetView.GetCustomProperties(AProperties: TStrings);
begin
  AProperties.Add('Active');
end;

// IcxStoredParent
procedure TdxGanttControlResourceSheetView.StoredChildren(AChildren: TStringList);
begin
  AChildren.AddObject('', OptionsSheet);
end;

end.
