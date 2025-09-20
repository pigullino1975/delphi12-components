{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressLayoutControl customize form                      }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSLAYOUTCONTROL AND ALL          }
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

unit dxLayoutCustomizeForm;

{$I cxVer.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Contnrs, Controls, Forms, Dialogs,
  ComCtrls, ActnList, Menus, ToolWin, StdCtrls, ImgList,
  Generics.Defaults, Generics.Collections,
  cxClasses, cxContainer, cxControls, cxGraphics, dxComCtrlsUtils, cxLookAndFeels, cxLookAndFeelPainters,
  cxButtons, cxEdit, cxGroupBox, cxTreeView, cxCheckBox,
  dxLayoutLookAndFeels, dxLayoutControl, dxLayoutDragAndDrop, dxLayoutcxEditAdapters, dxLayoutContainer,
  dxLayoutControlAdapters, cxImageList, dxTreeView;

type
  TdxLayoutControlCustomizeForm = class(TdxLayoutControlCustomCustomizeForm)
    alMain: TActionList;
    acAddGroup: TAction;
    acAddItem: TAction;
    acClose: TAction;
    acTreeViewExpandAll: TAction;
    acTreeViewCollapseAll: TAction;
    acTreeViewItemsDelete: TAction;
    acAlignLeftSide: TAction;
    acAlignRightSide: TAction;
    acAlignTopSide: TAction;
    acAlignBottomSide: TAction;
    acAlignNone: TAction;
    ilActions: TcxImageList;
    ilItems: TcxImageList;
    pmTreeViewActions: TPopupMenu;
    miExpandAll: TMenuItem;
    miCollapseAll: TMenuItem;
    miSeparator1: TMenuItem;
    miTreeViewDelete: TMenuItem;
    miSeparator2: TMenuItem;
    miAlignBy: TMenuItem;
    pmAvailableItemsActions: TPopupMenu;
    AddGroup1: TMenuItem;
    AddItem1: TMenuItem;
    Delete1: TMenuItem;
    pmAlign: TPopupMenu;
    Left1: TMenuItem;
    Right1: TMenuItem;
    op1: TMenuItem;
    Bottom1: TMenuItem;
    miSeparator3: TMenuItem;
    miSeparator4: TMenuItem;
    None1: TMenuItem;
    lcMainGroup_Root: TdxLayoutGroup;
    lcMain: TdxLayoutControl;
    lcgTreeView: TdxLayoutGroup;
    lcgAvailableItems: TdxLayoutGroup;
    acAvailableItemsDelete: TAction;
    acAvailableItemsExpandAll: TAction;
    acAvailableItemsCollapseAll: TAction;
    acAvailableItemsViewAsList: TAction;
    acTabbedView: TAction;
    acHighlightRoot: TAction;
    lcMainGroup1: TdxLayoutGroup;
    acShowDesignSelectors: TAction;
    acStore: TAction;
    acRestore: TAction;
    acTreeViewItemRename: TAction;
    miTreeViewItemRename: TMenuItem;
    Rename2: TMenuItem;
    acAvailableItemRename: TAction;
    acUndo: TAction;
    acRedo: TAction;
    N1: TMenuItem;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    N2: TMenuItem;
    Undo2: TMenuItem;
    Redo2: TMenuItem;
    acAlignBy: TAction;
    lcMainItem6: TdxLayoutItem;
    lcMainItem8: TdxLayoutItem;
    btnClose: TcxButton;
    lcMainItem1: TdxLayoutItem;
    lcMainGroup3: TdxLayoutGroup;
    cbTabbedView: TcxCheckBox;
    lcMainItem4: TdxLayoutItem;
    liShowDesignSelectors: TdxLayoutItem;
    btnShowDesignSelectors: TcxButton;
    liHighlightRoot: TdxLayoutItem;
    btnHighlightRoot: TcxButton;
    liRestore: TdxLayoutItem;
    btnRestore: TcxButton;
    liStore: TdxLayoutItem;
    btnStore: TcxButton;
    liRedo: TdxLayoutItem;
    btnRedo: TcxButton;
    liUndo: TdxLayoutItem;
    btnUndo: TcxButton;
    lcMainGroup2: TdxLayoutGroup;
    liAlignBy: TdxLayoutItem;
    btnAlignBy: TcxButton;
    lcMainItem7: TdxLayoutItem;
    btnTreeViewItemsDelete: TcxButton;
    lcMainItem9: TdxLayoutItem;
    btnTreeViewCollapseAll: TcxButton;
    lcMainItem10: TdxLayoutItem;
    btnTreeViewExpandAll: TcxButton;
    lgTreeView: TdxLayoutGroup;
    lgAvailableItems: TdxLayoutGroup;
    lcMainItem3: TdxLayoutItem;
    btnAvailableItemsViewAsList: TcxButton;
    lcMainItem11: TdxLayoutItem;
    btnAvailableItemsDelete: TcxButton;
    liAddCustomItem: TdxLayoutItem;
    btnAddItem: TcxButton;
    lcMainItem13: TdxLayoutItem;
    btnAddGroup: TcxButton;
    lcMainItem14: TdxLayoutItem;
    btnAvailableItemsCollapseAll: TcxButton;
    lcMainItem15: TdxLayoutItem;
    btnAvailableItemsExpandAll: TcxButton;
    acHAlignLeft: TAction;
    acHAlignCenter: TAction;
    acHAlignRight: TAction;
    acHAlignClient: TAction;
    acHAlignParent: TAction;
    miAlignHorz: TMenuItem;
    miHLeft: TMenuItem;
    miHCenter: TMenuItem;
    miHRight: TMenuItem;
    miHClient: TMenuItem;
    miHParentManaged: TMenuItem;
    acVAlignTop: TAction;
    acVAlignBottom: TAction;
    acVAlignCenter: TAction;
    acVAlignClient: TAction;
    acVAlignParent: TAction;
    miAlignVert: TMenuItem;
    miVAlignTop: TMenuItem;
    miVAlignCenter: TMenuItem;
    miVAlignBottom: TMenuItem;
    miVAlignClient: TMenuItem;
    miVAlignParent: TMenuItem;
    acDirectionHorizontal: TAction;
    acDirectionVertical: TAction;
    acDirectionTabbed: TAction;
    miDirection: TMenuItem;
    miDirectionHorizontal: TMenuItem;
    miDirectionVertical: TMenuItem;
    miDirectionTabbed: TMenuItem;
    acAddEmptySpaceItem: TAction;
    acBorder: TAction;
    miBorder: TMenuItem;
    acAddSeparator: TAction;
    AddEmptySpaceItem1: TMenuItem;
    acAddSeparator1: TMenuItem;
    acAddSplitter: TAction;
    acAddLabeledItem: TAction;
    pmAddCustomItem: TPopupMenu;
    AddEmptySpaceItem2: TMenuItem;
    acAddLabeledItem1: TMenuItem;
    acAddSeparator2: TMenuItem;
    acAddSplitter1: TMenuItem;
    acAddCustomItem: TAction;
    AddSplitter1: TMenuItem;
    AddLabel1: TMenuItem;
    lcMainSeparatorItem1: TdxLayoutSeparatorItem;
    lcMainSeparatorItem2: TdxLayoutSeparatorItem;
    N3: TMenuItem;
    lcMainSeparatorItem3: TdxLayoutSeparatorItem;
    lsAlignBy: TdxLayoutSeparatorItem;
    N4: TMenuItem;
    ExpandAll1: TMenuItem;
    CollapseAll1: TMenuItem;
    liAddItem: TdxLayoutItem;
    cxButton1: TcxButton;
    lsSeparator4: TdxLayoutSeparatorItem;
    acExpandButton: TAction;
    miExpandButton: TMenuItem;
    miTextPosition: TMenuItem;
    miTextPositionLeft: TMenuItem;
    miTextPositionTop: TMenuItem;
    miTextPositionRight: TMenuItem;
    miTextPositionBottom: TMenuItem;
    acTextPositionLeft: TAction;
    acTextPositionTop: TAction;
    acTextPositionRight: TAction;
    acTextPositionBottom: TAction;
    miCaptionAlignHorz: TMenuItem;
    miCaptionAlignHorzLeft: TMenuItem;
    miCaptionAlignHorzCenter: TMenuItem;
    miCaptionAlignHorzRight: TMenuItem;
    acCaptionAlignHorzLeft: TAction;
    acCaptionAlignHorzCenter: TAction;
    acCaptionAlignHorzRight: TAction;
    miCaption: TMenuItem;
    acCaption: TAction;
    miCaptionAlignVert: TMenuItem;
    miCaptionAlignVertTop: TMenuItem;
    miCaptionAlignVertCenter: TMenuItem;
    miCaptionAlignVertBottom: TMenuItem;
    acCaptionAlignVertTop: TAction;
    acCaptionAlignVertCenter: TAction;
    acCaptionAlignVertBottom: TAction;
    miGroup: TMenuItem;
    miUngroup: TMenuItem;
    acGroup: TAction;
    acUngroup: TAction;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    AddImage1: TMenuItem;
    acAddImage: TAction;
    AddImage2: TMenuItem;
    siMainSplitter: TdxLayoutSplitterItem;
    acVisibleItemsMakeFloat: TAction;
    acAvailableItemsMakeFloat: TAction;
    cxButton2: TcxButton;
    liVisibleItemsMakeFloat: TdxLayoutItem;
    liAvailableItemsMakeFloat: TdxLayoutItem;
    cxButton3: TcxButton;
    liShowItemNames: TdxLayoutItem;
    cxButton4: TcxButton;
    acShowItemNames: TAction;
    miCollapsible: TMenuItem;
    acCollapsible: TAction;
    acAddCheckBoxItem: TAction;
    acAddCheckBoxItem1: TMenuItem;
    AddCheckBoxItem1: TMenuItem;
    acAddRadioButtonItem: TAction;
    AddRadioButtonItem1: TMenuItem;
    acAddRadioButtonItem1: TMenuItem;
    tvVisibleItems: TdxTreeViewControl;
    tvAvailableItems: TdxTreeViewControl;
    cxButton5: TcxButton;
    liTransparentBorders: TdxLayoutItem;
    acTransparentBorders: TAction;

    procedure acCloseExecute(Sender: TObject);
    procedure acAddGroupExecute(Sender: TObject);
    procedure acAddItemExecute(Sender: TObject);

    procedure tvVisibleItemsContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure tvAvailableItemsContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure pmTreeViewActionsPopup(Sender: TObject);

    procedure AlignExecute(Sender: TObject);
    procedure acTreeViewItemsDeleteExecute(Sender: TObject);
    procedure acAvailableItemsDeleteExecute(Sender: TObject);
    procedure acAvailableItemsExpandAllExecute(Sender: TObject);
    procedure acAvailableItemsCollapseAllExecute(Sender: TObject);
    procedure acTreeViewExpandAllExecute(Sender: TObject);
    procedure acTreeViewCollapseAllExecute(Sender: TObject);
    procedure acAvailableItemsViewAsListExecute(Sender: TObject);
    procedure acTabbedViewExecute(Sender: TObject);
    procedure acHighlightRootExecute(Sender: TObject);
    procedure acShowDesignSelectorsExecute(Sender: TObject);
    procedure acStoreExecute(Sender: TObject);
    procedure acRestoreExecute(Sender: TObject);
    procedure acTreeViewItemRenameExecute(Sender: TObject);
    procedure acAvailableItemRenameExecute(Sender: TObject);
    procedure acUndoExecute(Sender: TObject);
    procedure acRedoExecute(Sender: TObject);
    procedure acAlignByExecute(Sender: TObject);
    procedure acHAlignExecute(Sender: TObject);
    procedure acVAlignExecute(Sender: TObject);
    procedure acDirectionsExecute(Sender: TObject);
    procedure acAddEmptySpaceItemExecute(Sender: TObject);
    procedure acBorderExecute(Sender: TObject);
    procedure acAddSeparatorExecute(Sender: TObject);
    procedure acAddCustomItemExecute(Sender: TObject);
    procedure acAddLabeledItemExecute(Sender: TObject);
    procedure acAddSplitterExecute(Sender: TObject);
    procedure acExpandButtonExecute(Sender: TObject);
    procedure acTextPositionExecute(Sender: TObject);
    procedure acCaptionAlignHorzExecute(Sender: TObject);
    procedure acCaptionExecute(Sender: TObject);
    procedure acCaptionAlignVertExecute(Sender: TObject);
    procedure acGroupExecute(Sender: TObject);
    procedure acUngroupExecute(Sender: TObject);
    procedure acAddImageExecute(Sender: TObject);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure acVisibleItemsMakeFloatExecute(Sender: TObject);
    procedure acAvailableItemsFloatExecute(Sender: TObject);
    procedure acShowItemNamesExecute(Sender: TObject);
    procedure pmAvailableItemsActionsPopup(Sender: TObject);
    procedure acCollapsibleExecute(Sender: TObject);
    procedure acAddCheckBoxItemExecute(Sender: TObject);
    procedure acAddRadioButtonItemExecute(Sender: TObject);
    procedure tvAvailableItemsAddition(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode);
    procedure tvAvailableItemsCollapsed(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode);
    procedure tvAvailableItemsCustomDrawNode(Sender: TdxCustomTreeView; Canvas: TcxCanvas; NodeViewInfo: TdxTreeViewNodeViewInfo; var Handled: Boolean);
    procedure tvAvailableItemsDeletion(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode);
    procedure tvVisibleItemsAddition(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode);
    procedure tvVisibleItemsCanFocusNode(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode; var Allow: Boolean);
    procedure tvVisibleItemsCanSelectNode(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode; var Allow: Boolean);
    procedure tvVisibleItemsDeletion(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode);
    procedure tvVisibleItemsEdited(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode; var S: string);
    procedure tvVisibleItemsEditing(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode; var Allow: Boolean);
    procedure tvAvailableItemsEnter(Sender: TObject);
    procedure tvVisibleItemsGetEditingText(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode; var S: string);
    procedure tvVisibleItemsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tvVisibleItemsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure tvVisibleItemsMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tvVisibleItemsSelectionChanged(Sender: TObject);
    procedure acTransparentBordersExecute(Sender: TObject);
  private
    FDragHelper: TdxLayoutDragAndDropHelper;
    FAvailableItemsWindowProcLinkedObject: TcxWindowProcLinkedObject;
    FItemsWindowProcLinkedObject: TcxWindowProcLinkedObject;
    FVisibleNodesDictionary: TDictionary<TdxCustomLayoutItem, TdxTreeViewNode>;
    FAvailableNodesDictionary: TDictionary<TdxCustomLayoutItem, TdxTreeViewNode>;
    FSelectionClearing: Boolean;
    FIsTreeViewClearing: Boolean;

    // TreeNodes
    procedure AddItemNode(ANodes: TdxTreeViewControl; AParentNode: TdxTreeViewNode; AItem: TdxCustomLayoutItem; AAddChildren: Boolean = True);
    procedure DeleteItemNode(AItem: TdxCustomLayoutItem);
    procedure SelectNextNode(ANode: TdxTreeViewNode);

    procedure AvailableItemsWndProc(var Message: TMessage);
    procedure ClearAllNodes(ATreeView: TdxTreeViewControl);
    function CreateItem(AClass: TdxCustomLayoutItemClass; const ACaption: string): TdxCustomLayoutItem;
    function DoCreateItem(AClass: TdxCustomLayoutItemClass; const ACaption: string): TdxCustomLayoutItem;
    procedure DoAfterInsertionItem(AItem: TdxCustomLayoutItem);
    function GetImageIndex(AItem: TdxCustomLayoutItem): Integer;
    function GetMenuItems: TdxLayoutCustomizeFormMenuItems;
    function HasClassInSelection(AClass: TClass): Boolean;
    procedure InitializePopupMenu;
    function IsHiddenGroup(AItem: TdxCustomLayoutItem): Boolean;
    procedure ItemsWndProc(var Message: TMessage);
    procedure RefreshLists(ARefreshSelection: Boolean = False);
    procedure RefreshNode(ANode: TdxTreeViewNode);
    procedure RefreshButtonStates;
    procedure RefreshView;

    // Selection
    function CanSelectItem(AItem: TdxCustomLayoutItem): Boolean;
    procedure SelectItem(AItem: TdxCustomLayoutItem);
    procedure SetItemsSelections(AList: TList);
    procedure SetLayoutItemsSelections(ATreeView: TdxTreeViewControl);

    function TreeViewWndProcHandler(ATreeView: TdxTreeViewControl; var Message: TMessage): Boolean;

    procedure RestoreCollapsedNodes(ATreeView: TdxTreeViewControl; AList: TList);
    procedure StoreCollapsedNodes(ATreeView: TdxTreeViewControl; AList: TList);
    procedure RestoreFirstNode(ATreeView: TdxTreeViewControl; AItem: TdxCustomLayoutItem);
    procedure StoreFirstNode(ATreeView: TdxTreeViewControl; out AItem: TdxCustomLayoutItem);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    function CanModify: Boolean; override;
    procedure DoInitializeControl; override;
    procedure ItemChanged(AItem: TdxCustomLayoutItem); override;
    procedure InitializeControl; override;
    function GetLayoutPopupMenu: TPopupMenu; override;
    function CanDeleteItems(ATreeView: TdxTreeViewControl): Boolean;
    procedure DeleteItems(AList: TComponentList; ATreeView: TdxTreeViewControl);
    procedure DeleteSelection(ATreeView: TdxTreeViewControl);
    function CanFloatItems(ATreeView: TdxTreeViewControl; out ANeedCheck: Boolean): Boolean;
    procedure MakeBreakFloat(AItems: TdxTreeViewControl);
    procedure Changed; override;
    procedure ResetDragAndDropObjects; override;
    function GetCustomizationCaption(AItem: TdxCustomLayoutItem): string; override;
    procedure SetCustomizationCaption(AItem: TdxCustomLayoutItem; const ACaption: string); override;

    function FindNodeByItem(AItem: TdxCustomLayoutItem; out ANode: TdxTreeViewNode): Boolean;
    procedure Localize; virtual;

    procedure RefreshItemsTreeView(ATreeView: TdxTreeViewControl; AList: TList; AViewKind: TdxLayoutAvailableItemsViewKind; ANeedSort, AShowRoot: Boolean);
    procedure RefreshAvailableItems;
    procedure RefreshVisibleItems;

    procedure RefreshEnabled; virtual;
    procedure RefreshLayoutLookAndFeel; override;
    procedure RefreshStoring; virtual;

    // popup menu
    procedure CalculateTreeViewPopupActionEnables; virtual;
    procedure CalculateTreeViewPopupActionVisibilities; virtual;
    function HasDirectionalItemInSelection: Boolean;
    function HasGroupInSelection: Boolean;
    function HasGroupsOnly: Boolean;
    function HasHiddenGroupInSelection: Boolean;
    function HasLabeledItemInSelection: Boolean;
    function HasLockedGroupInSelection: Boolean;
    function HasLockedItemInSelection: Boolean;
    function HasRootInSelection: Boolean;
    function HasSplitterOnly: Boolean;
    procedure SynchronizeTreeViewPopupActionStates; virtual;

    procedure StoreTreeViewWndProc(ATreeView: TdxTreeViewControl; out AWindowProcObject: TcxWindowProcLinkedObject; ANewWndMethod: TWndMethod);
    procedure RestoreTreeViewWndProc(var AWindowProcObject: TcxWindowProcLinkedObject);

    procedure SaveToUndo;

    property DragHelper: TdxLayoutDragAndDropHelper read FDragHelper;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Initialize; override;
    function GetHitTest(const P: TPoint): TdxCustomLayoutHitTest; override;
    procedure ToggleHotTrackState(AItem: TdxCustomLayoutItem); override;

    procedure UpdateAvailableItems; override;
    procedure UpdateCaption; override;
    procedure UpdateContent; override;
    procedure UpdateDragAndDropState; override;
    procedure UpdateSelection; override;
    procedure UpdateView; override;
    procedure UpdateVisibleItems; override;
  end;

implementation

{$R *.DFM}

uses
  Types, Math, CommCtrl, dxLayoutCommon, dxLayoutEditForm, cxGeometry,
  dxLayoutStrs, dxCore, dxOffice11, dxLayoutSelection, dxCustomTree,
  dxFormattedText, dxFormattedTextConverterBBCode, dxFormattedTextConverterRTF;

const
  dxThisUnitName = 'dxLayoutCustomizeForm';

type
  TdxCustomLayoutItemAccess = class(TdxCustomLayoutItem);
  TdxLayoutControlItemAccess = class(TdxLayoutControlItem);
  TdxCustomLayoutItemViewInfoAccess = class(TdxCustomLayoutItemViewInfo);
  TdxLayoutContainerAccess = class(TdxLayoutContainer);
  TdxCustomLayoutItemCaptionOptionsAccess = class(TdxCustomLayoutItemCaptionOptions);
  TToolBarAccess = class(TToolBar);
  TdxLayoutCustomizeFormHitTestAccess = class(TdxLayoutCustomizeFormHitTest);
  TdxLayoutSeparatorItemAccess = class(TdxLayoutSeparatorItem);
  TdxCustomLayoutGroupAccess = class(TdxCustomLayoutGroup);
  TdxLayoutSplitterItemAccess = class(TdxLayoutSplitterItem);
  TdxTreeViewNodeViewInfoAccess = class(TdxTreeViewNodeViewInfo);
{$IFDEF DXLAYOUTTEST}
  TdxTreeViewAccess = class(TdxCustomTreeView);
  TdxTreeViewViewInfoAcess = class(TdxTreeViewViewInfo);
{$ENDIF}

function GetCaptionOptions(AItem: TdxCustomLayoutItem): TdxCustomLayoutItemCaptionOptionsAccess;
begin
  Result := TdxCustomLayoutItemCaptionOptionsAccess(AItem.CaptionOptions);
end;

function CompareItemsByClass(Item1, Item2: Pointer): Integer;
begin
  Result := TdxCustomLayoutItemAccess(Item1).GetItemClassKind - TdxCustomLayoutItemAccess(Item2).GetItemClassKind;
end;

function CompareItemsByName(Item1, Item2: Pointer): Integer;

  procedure SplitNameByTrailingDigits(const AName: string; out ATrailingDigits: Integer;
    out ANameWithoutTrailingDigitals: string);
  var
    ACurrentLength: Integer;
  begin
    ANameWithoutTrailingDigitals := AName;
    ACurrentLength := Length(ANameWithoutTrailingDigitals);
    while (ACurrentLength > 0) and
      dxCharIsNumeric(ANameWithoutTrailingDigitals[ACurrentLength]) do
    begin
      ANameWithoutTrailingDigitals := Copy(ANameWithoutTrailingDigitals, 1, ACurrentLength - 1);
      ACurrentLength := Length(ANameWithoutTrailingDigitals);
    end;
    if (ACurrentLength = Length(AName)) or
        not TryStrToInt(Copy(AName, ACurrentLength + 1, Length(AName) - ACurrentLength), ATrailingDigits) then
      ATrailingDigits := -1;
  end;

var
  AName1, AName2: string;
  ANameWithoutLastDigitals1, ANameWithoutLastDigitals2: string;
  ANumber1, ANumber2: Integer;
begin
  Result := CompareItemsByClass(Item1, Item2);
  if Result = 0 then
  begin
    AName1 := TdxCustomLayoutItem(Item1).CaptionForCustomizeForm;
    AName2 := TdxCustomLayoutItem(Item2).CaptionForCustomizeForm;
    if AName1 = AName2 then
    begin
      AName1 := AName1 + TdxCustomLayoutItem(Item1).Name;
      AName2 := AName2 + TdxCustomLayoutItem(Item2).Name;
    end;
    SplitNameByTrailingDigits(AName1, ANumber1, ANameWithoutLastDigitals1);
    SplitNameByTrailingDigits(AName2, ANumber2, ANameWithoutLastDigitals2);
    Result := CompareText(ANameWithoutLastDigitals1, ANameWithoutLastDigitals2);
    if Result = 0 then
      Result := ANumber1 - ANumber2;
  end;
end;

function CompareItemsByIndex(Item1, Item2: Pointer): Integer;
var
  AItem1, AItem2: TdxCustomLayoutItem;
begin
  AItem1 := TdxCustomLayoutItem(Item1);
  AItem2 := TdxCustomLayoutItem(Item2);
  Result := AItem1.Index - AItem2.Index;
end;

function CompareItems(Item1, Item2: Pointer): Integer;
begin
  Result := CompareItemsByClass(Item1, Item2);
  if (Result = 0) and (TObject(Item1) is TdxCustomLayoutGroup) then
    Result := Integer(TdxCustomLayoutGroup(Item1).Count > 0) - Integer(TdxCustomLayoutGroup(Item2).Count > 0);
  if Result = 0 then
    Result := CompareItemsByName(Item1, Item2);
end;

{ TdxLayoutDesignForm }

constructor TdxLayoutControlCustomizeForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVisibleNodesDictionary := TDictionary<TdxCustomLayoutItem, TdxTreeViewNode>.Create;
  FAvailableNodesDictionary := TDictionary<TdxCustomLayoutItem, TdxTreeViewNode>.Create;

  tvVisibleItems.PopupMenu := pmTreeViewActions;
  tvAvailableItems.PopupMenu := pmAvailableItemsActions;
{$IFDEF DXLAYOUTTEST}
  tvVisibleItems.OptionsView.ItemHeight := 1;  
  TdxTreeViewViewInfoAcess(TdxTreeViewAccess(tvVisibleItems).ViewInfo).FContentOffset := cxNullPoint;
  tvAvailableItems.OptionsView.ItemHeight := 1;
  TdxTreeViewViewInfoAcess(TdxTreeViewAccess(tvAvailableItems).ViewInfo).FContentOffset := cxNullPoint;
{$ENDIF}
  StoreTreeViewWndProc(tvVisibleItems, FItemsWindowProcLinkedObject, ItemsWndProc);
  StoreTreeViewWndProc(tvAvailableItems, FAvailableItemsWindowProcLinkedObject, AvailableItemsWndProc);
end;

destructor TdxLayoutControlCustomizeForm.Destroy;
begin
  RestoreTreeViewWndProc(FItemsWindowProcLinkedObject);
  RestoreTreeViewWndProc(FAvailableItemsWindowProcLinkedObject);

  FreeAndNil(FDragHelper);
  FreeAndNil(FAvailableNodesDictionary);
  FreeAndNil(FVisibleNodesDictionary);
  inherited Destroy;
end;

procedure TdxLayoutControlCustomizeForm.Initialize;
begin
  acShowItemNames.Checked := Container.IsDesigning;
  pmTreeViewActions.OnPopup(nil);
  pmAvailableItemsActions.OnPopup(nil);

  inherited;

  lcMain.BeginUpdate;
  try
    Localize;
  finally
    lcMain.EndUpdate;
  end;
  InitializePopupMenu;

  Constraints.MinHeight := Height - ClientHeight + lcMainGroup_Root.ViewInfo.MinHeight;
  Constraints.MinWidth := Width - ClientWidth + lcMainGroup_Root.ViewInfo.MinWidth;
end;

function TdxLayoutControlCustomizeForm.GetHitTest(const P: TPoint): TdxCustomLayoutHitTest;

  function IsMenuKeyDown: Boolean;
  begin
    Result := GetAsyncKeyState(VK_MENU) <> 0;
  end;

  function GetDropAreaPart(AHitTestArea: Integer): TdxLayoutDropAreaPart;
  begin
    case AHitTestArea of
      -1:
        Result := apBefore;
      1:
        Result := apAfter;
    else
      Result := apLastChild;
    end;
  end;

  function GetHitTestArea(ANode: TdxTreeViewNode; AItem: TdxCustomLayoutItem; P: TPoint): Integer;
  var
    ANodeRect: TRect;
    H: Integer;
  begin
    P := ANode.TreeView.ParentToClient(P, Self);
    ANodeRect := ANode.DisplayRect(False);
    if AItem is TdxCustomLayoutGroup then
    begin
      if AItem.IsRoot then
        Result := 0
      else
      begin
        H := cxRectHeight(ANodeRect) div 4;
        if P.Y < ANodeRect.Top + H then
          Result := -1
        else
          if p.Y > ANodeRect.Bottom - H - 2 then
            Result := 1
          else
            Result := 0;
      end;
    end
    else
    begin
      H := cxRectHeight(ANodeRect) div 2;
      if P.Y < ANodeRect.Top + H then
        Result := -1
      else
        Result := 1
    end;
  end;

var
  AItem: TdxCustomLayoutItem;
  ANode: TdxTreeViewNode;
  AHitTest: TdxCustomLayoutHitTest;
  AHitTestArea: Integer;
begin
  ANode := nil;
  if tvVisibleItems.Visible and PtInRect(tvVisibleItems.BoundsRect, P) then
  begin
    Result := TdxLayoutCustomizeFormTreeViewItemsHitTest.Instance;
    tvVisibleItems.GetNodeAtPos(cxPointOffset(P, tvVisibleItems.BoundsRect.TopLeft, False), ANode);
  end
  else
    if tvAvailableItems.Visible and PtInRect(tvAvailableItems.BoundsRect, P) then
    begin
      Result := TdxLayoutCustomizeFormAvailableItemsHitTest.Instance;
      tvAvailableItems.GetNodeAtPos(cxPointOffset(P, tvAvailableItems.BoundsRect.TopLeft, False), ANode);
    end
    else
      Result := inherited GetHitTest(P);

  if ANode <> nil then
  begin
    AItem := TdxCustomLayoutItem(ANode.Data);
    TdxLayoutCustomizeFormHitTest(Result).Item := AItem;
    if TdxCustomLayoutItemAccess(AItem).IsAvailable then
      AHitTestArea := 0
    else
      AHitTestArea := GetHitTestArea(ANode, AItem, P);
    TdxLayoutCustomizeFormHitTestAccess(Result).FHitTestArea := AHitTestArea;
    TdxLayoutCustomizeFormHitTest(Result).DropAreaPart := GetDropAreaPart(AHitTestArea);
  end
  else
  begin
    TdxLayoutCustomizeFormHitTest(Result).Item := nil;
    AHitTest := lcMain.GetHitTest(P);
    if (AHitTest <> nil) and ((AHitTest.GetDestinationItem = lcgTreeView) or (AHitTest.GetDestinationItem = lcgAvailableItems)) then
      AHitTest.GetDestinationItem.MakeVisible;
  end;

  TdxLayoutCustomizeFormHitTest(Result).Container := Container;
end;

procedure TdxLayoutControlCustomizeForm.ToggleHotTrackState(AItem: TdxCustomLayoutItem);
var
  ANode: TdxTreeViewNode;
begin
  if FindNodeByItem(AItem, ANode) and ANode.IsVisible then
  begin
    ANode.DropTarget := not ANode.DropTarget;
    if ANode.HasChildren and not ANode.Expanded then
      ANode.Expand(False)
    else
      ANode.Invalidate;
  end;
end;

procedure TdxLayoutControlCustomizeForm.UpdateAvailableItems;
begin
  dxTreeForEach(tvAvailableItems.Root,
    function(ANode: TdxTreeCustomNode; AData: Pointer): Boolean
    begin
      Result := True;
      if not ANode.IsRoot then
        FAvailableNodesDictionary.Remove(ANode.Data);
    end, nil);

  RefreshAvailableItems;
end;

procedure TdxLayoutControlCustomizeForm.UpdateCaption;
begin
  if Container.IsDesigning then
    Caption := Format(cxGetResourceString(@sdxLayoutControlDesignerCaptionFormat),
      [cxGetFullComponentName(TdxLayoutContainerAccess(Container).ItemsParentComponent)])
  else
    Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormCaption);
end;

procedure TdxLayoutControlCustomizeForm.UpdateContent;
begin
  RefreshLists;
end;

procedure TdxLayoutControlCustomizeForm.UpdateDragAndDropState;
begin
  if FDragHelper.DragItem <> nil then
  begin
    if Container.ItemsParent.DragAndDropState = ddsNone then
    begin
      FDragHelper.Reset;
      tvAvailableItems.DropTarget := nil;
      tvVisibleItems.DropTarget := nil;
    end;
  end;
end;

procedure TdxLayoutControlCustomizeForm.UpdateSelection;
var
  AList: TList;
  AIntf: IdxLayoutDesignerHelper;
begin
  if IsLocked then
    Exit;
  AList := TList.Create;
  try
    if Supports(Container, IdxLayoutDesignerHelper, AIntf) then
    begin
      AIntf.GetSelection(AList);
      AIntf := nil;
    end;
    SetItemsSelections(AList);
  finally
    AList.Free;
  end;
end;

procedure TdxLayoutControlCustomizeForm.UpdateView;
begin
  RefreshView;
end;

procedure TdxLayoutControlCustomizeForm.UpdateVisibleItems;
begin
  dxTreeForEach(tvVisibleItems.Root,
    function(ANode: TdxTreeCustomNode; AData: Pointer): Boolean
    begin
      Result := True;
      if not ANode.IsRoot then
        FVisibleNodesDictionary.Remove(ANode.Data);
    end, nil);

  RefreshVisibleItems;
end;

procedure TdxLayoutControlCustomizeForm.RefreshStoring;
begin
  acStore.Visible := not Container.IsDesigning;
  liStore.Visible := acStore.Visible;
  acRestore.Visible := not Container.IsDesigning;
  liRestore.Visible := acRestore.Visible;
end;

procedure TdxLayoutControlCustomizeForm.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if not (csDestroying in ComponentState) and (Operation = opRemove) and (AComponent is TdxCustomLayoutItem) then
    DeleteItemNode(TdxCustomLayoutItem(AComponent));
end;

function TdxLayoutControlCustomizeForm.CanDeleteItems(ATreeView: TdxTreeViewControl): Boolean;
var
  AList: TList;
  I: Integer;
  AIntf: IdxLayoutDesignerHelper;
begin
  AList := TList.Create;
  try
    ATreeView.GetSelectedData(AList);
    Result := AList.Count > 0;
    if Result then
      if Supports(Container, IdxLayoutDesignerHelper, AIntf) then
      begin
        for I := 0 to AList.Count - 1 do
        begin
          Result := TdxCustomLayoutItemAccess(AList[I]).CanDelete and
            AIntf.CanDeleteComponent(TComponent(AList[I]));
          if not Result then
            Break;
        end;
      end;
  finally
    AList.Free;
  end;
end;

procedure TdxLayoutControlCustomizeForm.DeleteItems(AList: TComponentList; ATreeView: TdxTreeViewControl);
var
  AIntf: IdxLayoutDesignerHelper;
begin
  if AList.Count = 0 then
    Exit;
  SaveToUndo;
  BeginUpdate;
  ATreeView.BeginUpdate;
  try
    Container.BeginUpdate;
    try
      if Supports(Container, IdxLayoutDesignerHelper, AIntf) then
        AIntf.DeleteComponents(AList);
    finally
      Container.EndUpdate;
    end;
  finally
    ATreeView.EndUpdate;
    EndUpdate;
  end;
end;

procedure TdxLayoutControlCustomizeForm.DeleteSelection(ATreeView: TdxTreeViewControl);

  function GetMinSelectedIndex: Integer;
  var
    I: Integer;
  begin
    Result := ATreeView.AbsoluteVisibleCount - 1;
    for I := 0 to ATreeView.SelectionCount - 1 do
      Result := Min(Result, ATreeView.Selections[I].VisibleIndex);
  end;

var
  AList: TComponentList;
  ANewSelection: TdxTreeViewNode;
  ASelectedNodeIndex: Integer;
begin
  if ATreeView.SelectionCount = 0 then
    Exit;
  ATreeView.EndEdit(True);
  AList := TComponentList.Create;
  try
    ATreeView.GetSelectedData(AList);
    ASelectedNodeIndex := GetMinSelectedIndex;
    FSelectionClearing := True;
    try
      if (ATreeView.FocusedNode <> nil) and ATreeView.FocusedNode.Selected then
        ATreeView.FocusedNode := nil; 
      ATreeView.ClearSelection;       
      DeleteItems(AList, ATreeView);
    finally
      FSelectionClearing := False;
    end;
    ASelectedNodeIndex := Min(ASelectedNodeIndex, ATreeView.AbsoluteVisibleCount - 1);
    if ATreeView.AbsoluteVisibleCount > 0 then
    begin
      ANewSelection := ATreeView.AbsoluteVisibleItems[ASelectedNodeIndex];
      SelectItem(ANewSelection.Data);
    end;
  finally
    AList.Free;
  end;
end;

function TdxLayoutControlCustomizeForm.CanFloatItems(ATreeView: TdxTreeViewControl; out ANeedCheck: Boolean): Boolean;
var
  AList: TList;
  I: Integer;
begin
  ANeedCheck := False;
  Result := False;
  AList := TList.Create;
  try
    ATreeView.GetSelectedData(AList);
    for I := 0 to AList.Count - 1 do
    begin
      ANeedCheck := TdxCustomLayoutItemAccess(AList[I]).FIsFloat;
      Result := TdxCustomLayoutItemAccess(AList[I]).CanFloat;
      if not Result then
        Break;
    end;
  finally
    AList.Free;
  end;
end;

function TdxLayoutControlCustomizeForm.FindNodeByItem(AItem: TdxCustomLayoutItem; out ANode: TdxTreeViewNode): Boolean;
begin
  Result := (AItem <> nil) and (Container <> nil) and (TdxCustomLayoutItemAccess(AItem).RealContainer = Container) and
    (FVisibleNodesDictionary.TryGetValue(AItem, ANode) or (FAvailableNodesDictionary.TryGetValue(AItem, ANode)));
end;

function TdxLayoutControlCustomizeForm.GetLayoutPopupMenu: TPopupMenu;
begin
  Result := pmTreeViewActions;
end;

function TdxLayoutControlCustomizeForm.CanModify: Boolean;
begin
  Result := inherited CanModify and (Container.IsDesigning or not HasLockedItemInSelection);
end;

procedure TdxLayoutControlCustomizeForm.DoInitializeControl;
begin
  FDragHelper.Free;
  FDragHelper := TdxLayoutDragAndDropHelper.Create(Container);
  inherited DoInitializeControl;
  tvVisibleItems.FullExpand;
  tvAvailableItems.FullExpand;
end;

procedure TdxLayoutControlCustomizeForm.ItemChanged(AItem: TdxCustomLayoutItem);
var
  ANode: TdxTreeViewNode;
begin
  if FindNodeByItem(AItem, ANode) and not IsLocked then
    RefreshNode(ANode);
  if not IsLocked then
    RefreshButtonStates;
end;

procedure TdxLayoutControlCustomizeForm.InitializeControl;
begin
  lcMain.BeginUpdate;
  try
    inherited InitializeControl;
  finally
    lcMain.EndUpdate;
  end;
end;

procedure TdxLayoutControlCustomizeForm.Localize;
begin
  acAddGroup.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormAddGroup);
  acAddGroup.Hint := StripHotKey(acAddGroup.Caption);

  acAddItem.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormAddItem);
  acAddItem.Hint := StripHotKey(acAddItem.Caption);

  acAddCustomItem.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormAddAuxiliaryItem);
  acAddCustomItem.Hint := StripHotKey(acAddCustomItem.Caption);

  acAddEmptySpaceItem.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormAddEmptySpaceItem);
  acAddEmptySpaceItem.Hint := StripHotKey(acAddEmptySpaceItem.Caption);

  acAddSeparator.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormAddSeparatorItem);
  acAddSeparator.Hint := StripHotKey(acAddSeparator.Caption);

  acAddSplitter.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormAddSplitterItem);
  acAddSplitter.Hint := StripHotKey(acAddSplitter.Caption);

  acAddLabeledItem.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormAddLabeledItem);
  acAddLabeledItem.Hint := StripHotKey(acAddLabeledItem.Caption);

  acAddImage.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormAddImageItem);
  acAddImage.Hint := StripHotKey(acAddImage.Caption);

  acAddCheckBoxItem.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormAddCheckBoxItem);
  acAddCheckBoxItem.Hint := StripHotKey(acAddCheckBoxItem.Caption);

  acAddRadioButtonItem.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormAddRadioButtonItem);
  acAddRadioButtonItem.Hint := StripHotKey(acAddRadioButtonItem.Caption);

  acAvailableItemsDelete.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormDelete);
  acAvailableItemsDelete.Hint := cxGetResourceString(@sdxLayoutControlCustomizeFormDeleteHint);

  acTreeViewItemsDelete.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormDelete);
  acTreeViewItemsDelete.Hint := cxGetResourceString(@sdxLayoutControlCustomizeFormDeleteHint);

  acAlignBy.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormAlignBy);
  acAlignBy.Hint := StripHotKey(acAlignBy.Caption);

  acClose.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormClose);
  acClose.Hint := StripHotKey(acClose.Caption);

  acTreeViewExpandAll.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormExpandAll);
  acTreeViewExpandAll.Hint := StripHotKey(acTreeViewExpandAll.Caption);

  acAvailableItemsExpandAll.Caption := acTreeViewExpandAll.Caption;
  acAvailableItemsExpandAll.Hint := acTreeViewExpandAll.Hint;

  acTreeViewCollapseAll.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormCollapseAll);
  acTreeViewCollapseAll.Hint := StripHotKey(acTreeViewCollapseAll.Caption);

  acAvailableItemsCollapseAll.Caption := acTreeViewCollapseAll.Caption;
  acAvailableItemsCollapseAll.Hint := StripHotKey(acTreeViewCollapseAll.Hint);

  acAlignLeftSide.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormAlignLeftSide);
  acAlignRightSide.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormAlignRightSide);
  acAlignTopSide.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormAlignTopSide);
  acAlignBottomSide.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormAlignBottomSide);
  acAlignNone.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormAlignNone);

  miAlignHorz.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormHAlign);
  acHAlignLeft.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormHAlignLeft);
  acHAlignCenter.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormHAlignCenter);
  acHAlignRight.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormHAlignRight);
  acHAlignClient.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormHAlignClient);
  acHAlignParent.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormHAlignParent);

  miAlignVert.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormVAlign);
  acVAlignTop.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormVAlignTop);
  acVAlignCenter.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormVAlignCenter);
  acVAlignBottom.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormVAlignBottom);
  acVAlignClient.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormVAlignClient);
  acVAlignParent.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormVAlignParent);

  miDirection.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormDirection);
  acDirectionHorizontal.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormDirectionHorizontal);
  acDirectionVertical.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormDirectionVertical);
  acDirectionTabbed.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormDirectionTabbed);

  miTextPosition.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormTextPosition);
  acTextPositionLeft.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormTextPositionLeft);
  acTextPositionTop.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormTextPositionTop);
  acTextPositionRight.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormTextPositionRight);
  acTextPositionBottom.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormTextPositionBottom);

  miCaptionAlignHorz.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormCaptionAlignHorz);
  acCaptionAlignHorzLeft.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormCaptionAlignHorzLeft);
  acCaptionAlignHorzCenter.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormCaptionAlignHorzCenter);
  acCaptionAlignHorzRight.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormCaptionAlignHorzRight);

  miCaptionAlignVert.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormCaptionAlignVert);
  acCaptionAlignVertTop.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormCaptionAlignVertTop);
  acCaptionAlignVertCenter.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormCaptionAlignVertCenter);
  acCaptionAlignVertBottom.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormCaptionAlignVertBottom);

  acCaption.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormItemCaption);

  acBorder.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormGroupBorder);
  acExpandButton.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormGroupExpandButton);

  lcgTreeView.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormTreeViewGroup);
  lcgAvailableItems.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormListViewGroup);

  acTabbedView.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormTabbedView);
  acTabbedView.Hint := StripHotKey(acTabbedView.Caption);

  acAvailableItemsViewAsList.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormTreeView);
  acAvailableItemsViewAsList.Hint := StripHotKey(acAvailableItemsViewAsList.Caption);

  acStore.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormStore);
  acStore.Hint := StripHotKey(acStore.Caption);

  acRestore.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormRestore);
  acRestore.Hint := StripHotKey(acRestore.Caption);

  acTreeViewItemRename.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormRename);
  acTreeViewItemRename.Hint := acTreeViewItemRename.Caption;

  acAvailableItemRename.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormRename);
  acAvailableItemRename.Hint := acAvailableItemRename.Caption;

  acUndo.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormUndo);
  acUndo.Hint := acUndo.Caption;

  acRedo.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormRedo);
  acRedo.Hint := acRedo.Caption;

  acGroup.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormGroup);
  acUngroup.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormUngroup);

  miCollapsible.Caption := cxGetResourceString(@sdxLayoutControlCustomizeFormSplitterCollapsible);
end;

procedure TdxLayoutControlCustomizeForm.RefreshItemsTreeView(ATreeView: TdxTreeViewControl;
  AList: TList; AViewKind: TdxLayoutAvailableItemsViewKind; ANeedSort, AShowRoot: Boolean);
var
  I: Integer;
  ACollapsedItems: TList;
  ATopItem: TdxCustomLayoutItem;
begin
  BeginUpdate;
  ATreeView.BeginUpdate;
  SendMessage(ATreeView.Handle, WM_SETREDRAW, 0, 0);
  ACollapsedItems := TList.Create;
  try
    StoreFirstNode(ATreeView, ATopItem);
    StoreCollapsedNodes(ATreeView, ACollapsedItems);

    if ANeedSort then
      case AViewKind of
        aivkList:
          AList.Sort(CompareItemsByName);
        aivkTree:
          AList.Sort(CompareItems);
      end;

    ClearAllNodes(ATreeView);

    for I := 0 to AList.Count - 1 do
      AddItemNode(ATreeView, nil, TdxCustomLayoutItem(AList[I]), AViewKind = aivkTree);

    RestoreCollapsedNodes(ATreeView, ACollapsedItems);
    RestoreFirstNode(ATreeView, ATopItem);
  finally
    ACollapsedItems.Free;
    SendMessage(ATreeView.Handle, WM_SETREDRAW, 1, 0);
    ATreeView.EndUpdate;
    ATreeView.Refresh;
    CancelUpdate;
  end;
  ATreeView.OptionsView.ShowRoot := AShowRoot;
end;

procedure TdxLayoutControlCustomizeForm.RefreshAvailableItems;

  procedure PopulateItemChildren(AList: TList; AItem: TdxCustomLayoutItem);
  var
    I: Integer;
  begin
    if AItem is TdxCustomLayoutGroup then
    begin
      for I := 0 to TdxCustomLayoutGroup(AItem).Count - 1 do
        if CanShowItem(TdxCustomLayoutGroup(AItem).Items[I]) then
        begin
          AList.Add(TdxCustomLayoutGroup(AItem).Items[I]);
          PopulateItemChildren(AList, TdxCustomLayoutGroup(AItem).Items[I]);
        end;
    end;
  end;

  procedure PopulateByAvailableItems(AList: TList);
  var
    I: Integer;
    AItem: TdxCustomLayoutItem;
  begin
    for I := 0 to Container.AvailableItemCount - 1 do
    begin
      AItem := Container.AvailableItems[I];
      if CanShowItem(AItem) then
      begin
        AList.Add(AItem);
        if Container.CustomizeAvailableItemsViewKind = aivkList then
          PopulateItemChildren(AList, AItem);
      end;
    end;
  end;

var
  AList: TList;
begin
  AList := TList.Create;
  try
    PopulateByAvailableItems(AList);
    RefreshItemsTreeView(tvAvailableItems, AList, Container.CustomizeAvailableItemsViewKind, True, Container.CustomizeAvailableItemsViewKind = aivkTree);
  finally
    AList.Free;
  end;
end;

procedure TdxLayoutControlCustomizeForm.RefreshVisibleItems;

  procedure PopulateByVisibleItems(AList: TList);
  var
    I: Integer;
  begin
    AList.Add(Container.Root);
    for I := 0 to TdxLayoutContainerAccess(Container).FloatContainers.Count - 1 do
      AList.Add(TdxLayoutContainer(TdxLayoutContainerAccess(Container).FloatContainers[I]).Root.Items[0]);
  end;

var
  AList: TList;
begin
  AList := TList.Create;
  try
    PopulateByVisibleItems(AList);
    RefreshItemsTreeView(tvVisibleItems, AList, aivkTree, False, True);
  finally
    AList.Free;
  end;
end;

procedure TdxLayoutControlCustomizeForm.RefreshEnabled;
var
  ACanModify: Boolean;
  ACanAddItem: Boolean;
  AStoringSupports: Boolean;
  ACanRestore: Boolean;
  ANeedCheckFloatButton: Boolean;
begin
  if not IsLocked then
  begin
    ACanAddItem := CanAddItem;
    ACanModify := CanModify;
    AStoringSupports := TdxLayoutContainerAccess(Container).StoringSupports;
    ACanRestore := TdxLayoutContainerAccess(Container).CanRestore;
    acAvailableItemsExpandAll.Enabled := Container.CustomizeAvailableItemsViewKind = aivkTree;
    acAvailableItemsCollapseAll.Enabled := Container.CustomizeAvailableItemsViewKind = aivkTree;
    acStore.Enabled := AStoringSupports;
    acRestore.Enabled := AStoringSupports and ACanRestore;
    acTreeViewItemRename.Enabled := ACanModify and (tvVisibleItems.Selected <> nil) and (tvVisibleItems.SelectionCount = 1) and
      not (TObject(tvVisibleItems.Selected.Data) as TdxCustomLayoutItem).IsRoot and
      not TdxCustomLayoutItemAccess(tvVisibleItems.Selected.Data).IsParentLocked and TdxLayoutContainerAccess(Container).AllowRename;
    acAvailableItemRename.Enabled := ACanModify and (tvAvailableItems.Selected <> nil) and (tvAvailableItems.SelectionCount = 1) and
      not TdxCustomLayoutItemAccess(tvAvailableItems.Selected.Data).IsParentLocked and TdxLayoutContainerAccess(Container).AllowRename;

    acUndo.Enabled := Container.UndoRedoManager.CanUndo;
    acRedo.Enabled := Container.UndoRedoManager.CanRedo;

    acTreeViewItemsDelete.Enabled := CanDeleteItems(tvVisibleItems) and ACanAddItem;
    acAvailableItemsDelete.Enabled := CanDeleteItems(tvAvailableItems) and ACanAddItem;
    acVisibleItemsMakeFloat.Enabled := CanFloatItems(tvVisibleItems, ANeedCheckFloatButton);
    if acVisibleItemsMakeFloat.Enabled then
      acVisibleItemsMakeFloat.Checked := ANeedCheckFloatButton;
    acAvailableItemsMakeFloat.Enabled := CanFloatItems(tvAvailableItems, ANeedCheckFloatButton);
    if acAvailableItemsMakeFloat.Enabled then
      acAvailableItemsMakeFloat.Checked := ANeedCheckFloatButton;

    acAddGroup.Enabled := ACanModify and ACanAddItem;
    acAddItem.Enabled := Container.IsDesigning and ACanModify and ACanAddItem;
    acAddSeparator.Enabled := ACanModify and ACanAddItem;
    acAddSplitter.Enabled := ACanModify and ACanAddItem;
    acAddImage.Enabled := ACanModify and ACanAddItem;
    acAddLabeledItem.Enabled := ACanModify and ACanAddItem;
    acAddEmptySpaceItem.Enabled := ACanModify and ACanAddItem;
    acAddCustomItem.Enabled := acAddSeparator.Enabled or acAddSplitter.Enabled or acAddLabeledItem.Enabled or acAddEmptySpaceItem.Enabled;
    acAddCheckBoxItem.Enabled := ACanModify and ACanAddItem;
    acAddRadioButtonItem.Enabled := ACanModify and ACanAddItem;

    acAlignBy.Enabled := (tvVisibleItems.SelectionCount > 1) and ACanModify and ACanAddItem;
    acAlignLeftSide.Enabled := ACanModify and ACanAddItem;
    acAlignRightSide.Enabled := ACanModify and ACanAddItem;
    acAlignTopSide.Enabled := ACanModify and ACanAddItem;
    acAlignBottomSide.Enabled := ACanModify and ACanAddItem;
    acAlignNone.Enabled := ACanModify and ACanAddItem;

    acAvailableItemsViewAsList.Enabled := ACanModify;
    acTabbedView.Enabled := ACanModify;
    acHighlightRoot.Enabled := ACanModify;
    acShowDesignSelectors.Enabled := ACanModify;

    acHAlignLeft.Enabled := ACanModify;
    acHAlignRight.Enabled := ACanModify;
    acHAlignCenter.Enabled := ACanModify;
    acHAlignClient.Enabled := ACanModify;
    acHAlignRight.Enabled := ACanModify;
    acHAlignParent.Enabled := ACanModify;
    acVAlignTop.Enabled := ACanModify;
    acVAlignBottom.Enabled := ACanModify;
    acVAlignCenter.Enabled := ACanModify;
    acVAlignClient.Enabled := ACanModify;
    acVAlignParent.Enabled := ACanModify;
    acDirectionHorizontal.Enabled := ACanModify;
    acDirectionVertical.Enabled := ACanModify;
    acDirectionTabbed.Enabled := ACanModify;
    acBorder.Enabled := ACanModify;
    acExpandButton.Enabled := ACanModify;
    miAlignHorz.Enabled := ACanModify;
    miDirection.Enabled := ACanModify;
    miAlignVert.Enabled := ACanModify;
  end;
end;

procedure TdxLayoutControlCustomizeForm.RefreshLayoutLookAndFeel;
begin
  lcMain.BeginUpdate;
  try
    inherited RefreshLayoutLookAndFeel;
    lcMain.LayoutLookAndFeel := LayoutLookAndFeel;
  finally
    lcMain.EndUpdate(False);
  end;
end;

procedure TdxLayoutControlCustomizeForm.StoreTreeViewWndProc(ATreeView: TdxTreeViewControl; out AWindowProcObject: TcxWindowProcLinkedObject; ANewWndMethod: TWndMethod);
begin
  AWindowProcObject := cxWindowProcController.Add(ATreeView, ANewWndMethod);
end;

procedure TdxLayoutControlCustomizeForm.RestoreTreeViewWndProc(var AWindowProcObject: TcxWindowProcLinkedObject);
begin
  cxWindowProcController.Remove(AWindowProcObject);
end;

procedure TdxLayoutControlCustomizeForm.AddItemNode(ANodes: TdxTreeViewControl; AParentNode: TdxTreeViewNode; AItem: TdxCustomLayoutItem; AAddChildren: Boolean = True);
var
  I: Integer;
  AThisNode: TdxTreeViewNode;
  AGroup: TdxCustomLayoutGroup;
begin
  AThisNode := ANodes.Root.AddNode(nil, AParentNode, AItem, namAddChild);
  AItem.FreeNotification(Self); 
  RefreshNode(AThisNode);
  if AAddChildren and TdxCustomLayoutItemAccess(AItem).IsGroup then
  begin
    AGroup := TdxCustomLayoutGroup(AItem);
    for I := 0 to AGroup.Count - 1 do
      if CanShowItem(AGroup[I]) then
        AddItemNode(ANodes, AThisNode, AGroup[I]);
  end;
end;

procedure TdxLayoutControlCustomizeForm.DeleteItemNode(AItem: TdxCustomLayoutItem);
var
  ANode: TdxTreeViewNode;
begin
  if FindNodeByItem(AItem, ANode) then
  begin
    if ANode.TreeView = tvAvailableItems then
      FAvailableNodesDictionary.Remove(AItem)
    else
      FVisibleNodesDictionary.Remove(AItem);
    ANode.Delete;
  end;
end;

procedure TdxLayoutControlCustomizeForm.SelectNextNode(ANode: TdxTreeViewNode);
var
  ANextNode: TdxTreeViewNode;
begin
  if (csDestroying in ComponentState) or FIsTreeViewClearing or FSelectionClearing or not Container.IsDesigning and IsLocked then
    Exit;
  if ANode = ANode.TreeView.Selected then
  begin
    ANextNode := ANode.Next;
    if ANextNode = nil then
      ANextNode := ANode.GetPrev;
    if (ANextNode <> nil) and CanSelectItem(ANextNode.Data) then
    begin
      ANextNode.Selected := True;
      SelectItem(ANextNode.Data);
    end;
  end;
end;

procedure TdxLayoutControlCustomizeForm.AvailableItemsWndProc(var Message: TMessage);
begin
  if not TreeViewWndProcHandler(tvAvailableItems, Message) then
    FAvailableItemsWindowProcLinkedObject.DefaultProc(Message);
end;

procedure TdxLayoutControlCustomizeForm.ClearAllNodes(ATreeView: TdxTreeViewControl);
begin
  FIsTreeViewClearing := True;
  try
    ATreeView.Root.Clear;
  finally
    FIsTreeViewClearing := False;
  end;
end;

function TdxLayoutControlCustomizeForm.DoCreateItem(AClass: TdxCustomLayoutItemClass; const ACaption: string): TdxCustomLayoutItem;
begin
  Result := Container.CreateItem(AClass);
  Result.Caption := ACaption;
end;


function TdxLayoutControlCustomizeForm.CreateItem(AClass: TdxCustomLayoutItemClass; const ACaption: string): TdxCustomLayoutItem;
begin
  SaveToUndo;
  BeginUpdate;
  try
    Result := DoCreateItem(AClass, ACaption);
    DoAfterInsertionItem(Result);
  finally
    EndUpdate;
  end;
end;

procedure TdxLayoutControlCustomizeForm.DoAfterInsertionItem(AItem: TdxCustomLayoutItem);
var
  AIntf: IdxLayoutDesignerHelper;
begin
  if Supports(Container, IdxLayoutDesignerHelper, AIntf) then
  begin
    AIntf.SelectComponent(AItem);
    AIntf := nil;
  end;
end;

function TdxLayoutControlCustomizeForm.GetImageIndex(AItem: TdxCustomLayoutItem): Integer;
const
  AGroupIndexMap: array[Boolean, Boolean, TdxLayoutDirection] of Integer = ((
    (10, 11, 12), (13, 14, 15)), ((16, 17, 18), (19, 20, 21)));
  ASeparatorIndexMap: array[Boolean] of Integer = (4, 5);
  ASplitterIndexMap: array[Boolean] of Integer = (6, 7);

var
  AGroup: TdxCustomLayoutGroup;
begin
  case TdxCustomLayoutItemAccess(AItem).GetItemClassKind of
    ickEmptySpace:
      Result := 1;
    ickLabeled:
      Result := 2;
    ickImage:
      Result := 3;
    ickSeparator:
      Result := ASeparatorIndexMap[TdxLayoutSeparatorItemAccess(AItem).IsVertical];
    ickSplitter:
      Result := ASplitterIndexMap[TdxLayoutSplitterItem(AItem).IsVertical];
    ickCheckBox:
      Result := 8;
    ickRadioButton:
      Result := 9;
    ickGroup, ickAutoCreatedGroup:
      begin
        AGroup := TdxCustomLayoutItemAccess(AItem).AsGroup;
        Result := AGroupIndexMap[TdxCustomLayoutItemAccess(AGroup).FIsFloat, AGroup.Locked, AGroup.LayoutDirection];
        if AGroup.Hidden and not AGroup.IsRoot then
          Result := Result + 12;
      end;
    else
      Result := 0; 
  end;
end;

function TdxLayoutControlCustomizeForm.GetMenuItems: TdxLayoutCustomizeFormMenuItems;
var
  AList: TList;
begin
  AList := TList.Create;
  try
    tvVisibleItems.GetSelectedData(AList);
    Result := DoGetMenuItems(AList);
  finally
    AList.Free;
  end;
end;

function TdxLayoutControlCustomizeForm.HasClassInSelection(AClass: TClass): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to tvVisibleItems.SelectionCount - 1 do
  begin
    Result := TObject(tvVisibleItems.Selections[I].Data) is AClass;
    if Result then
      Break;
  end;
end;

procedure TdxLayoutControlCustomizeForm.InitializePopupMenu;
var
  I: Integer;
  AMenuItem: TMenuItem;
begin
  for I := 0 to pmAlign.Items.Count - 1 do
  begin
    AMenuItem := TMenuItem.Create(miAlignBy);
    AMenuItem.Caption := pmAlign.Items[I].Caption;
    AMenuItem.Action := pmAlign.Items[I].Action;
    miAlignBy.Add(AMenuItem);
  end;
end;

function TdxLayoutControlCustomizeForm.IsHiddenGroup(AItem: TdxCustomLayoutItem): Boolean;
begin
  Result := (AItem is TdxCustomLayoutGroup) and TdxCustomLayoutGroup(AItem).Hidden;
end;

procedure TdxLayoutControlCustomizeForm.ItemsWndProc(var Message: TMessage);
begin
  if not TreeViewWndProcHandler(tvVisibleItems, Message) then
    FItemsWindowProcLinkedObject.DefaultProc(Message);
end;

procedure TdxLayoutControlCustomizeForm.MakeBreakFloat(AItems: TdxTreeViewControl);
var
  AList: TList;
  I: Integer;
  P: TPoint;
begin
  AList := TList.Create;
  try
    AItems.GetSelectedData(AList);
    Container.BeginUpdate;
    try
      for I := 0 to AList.Count - 1 do
      begin
        if TdxCustomLayoutItemAccess(AList[I]).FIsFloat then
          TdxCustomLayoutItemAccess(AList[I]).LandingFloat
        else
        begin
          P := TdxCustomLayoutItemAccess(AList[I]).FFloatPos;
          if cxPointIsEqual(P, cxNullPoint) then
            P  := Container.ClientToScreen(cxNullPoint);
          TdxCustomLayoutItemAccess(AList[I]).MakeFloat(P, False);
        end;
      end;
    finally
      Container.EndUpdate;
    end;
  finally
    AList.Free;
  end;
end;

procedure TdxLayoutControlCustomizeForm.Changed;
begin
  RefreshLists(True);
end;

procedure TdxLayoutControlCustomizeForm.ResetDragAndDropObjects;
begin
  DragHelper.Reset;
  tvAvailableItems.DropTarget := nil;
  tvVisibleItems.DropTarget := nil;
  inherited;
end;

function TdxLayoutControlCustomizeForm.GetCustomizationCaption(AItem: TdxCustomLayoutItem): string;
begin
  if acShowItemNames.Checked then
    Result := AItem.Name
  else
    Result := GetCaptionOptions(AItem).FormattedText.GetDisplayText;
  if Result = '' then
    Result := cxGetResourceString(@sdxLayoutControlEmptyCaption);
end;

procedure TdxLayoutControlCustomizeForm.SetCustomizationCaption(AItem: TdxCustomLayoutItem; const ACaption: string);
begin
  if acShowItemNames.Checked then
    AItem.Name := ACaption
  else
    TdxCustomLayoutItemAccess(AItem).SetInplaceRenameCaption(ACaption);
  Container.Modified;
end;

procedure TdxLayoutControlCustomizeForm.RefreshLists(ARefreshSelection: Boolean = False);
begin
  if IsLocked then
    Exit;
  BeginUpdate;
  try
    RefreshAvailableItems;
    RefreshVisibleItems;
  finally
    CancelUpdate;
  end;
  if ARefreshSelection then
    UpdateSelection;
end;

procedure TdxLayoutControlCustomizeForm.RefreshNode(ANode: TdxTreeViewNode);
var
  AItem: TdxCustomLayoutItem;
begin
  AItem := ANode.Data;
  if AItem.IsRoot then
    ANode.Caption := cxGetResourceString(@sdxLayoutControlRoot)
  else
    ANode.Caption := AItem.CaptionForCustomizeForm;
  ANode.ImageIndex := GetImageIndex(Aitem);
end;

procedure TdxLayoutControlCustomizeForm.RefreshButtonStates;
begin
  acAvailableItemsViewAsList.Checked := Container.CustomizeAvailableItemsViewKind = aivkTree;
  acTabbedView.Checked := Container.CustomizeFormTabbedView;
  acHighlightRoot.Checked := Container.HighlightRoot;
  acShowDesignSelectors.Checked := Container.ShowDesignSelectors;

  RefreshEnabled;
end;

procedure TdxLayoutControlCustomizeForm.RefreshView;

  function AllowAnyFloat: Boolean;
  var
    I: Integer;
  begin
    if not Container.IsDesigning then
    begin
      Result := TdxLayoutContainerAccess(Container).AllowFloatingGroups;
      for I := 0 to TdxLayoutContainerAccess(Container).ManagedItemCount - 1 do
      begin
        if Result then
          Break;
        Result := Result or TdxCustomLayoutItemAccess(TdxLayoutContainerAccess(Container).ManagedItems[I]).AllowFloating;
      end;
    end
    else
      Result := False;
  end;

  function CheckTransparentBorders: Boolean;
  var
    I: Integer;
  begin
    Result := False;
    if Container.IsDesigning then
      for I := 0 to Container.AbsoluteItemCount - 1 do
      begin
        Result :=
          (Container.AbsoluteItems[I] is TdxLayoutControlItem) and
          (TdxLayoutControlItemAccess(Container.AbsoluteItems[I]).Control is TcxCustomEdit) and
          TcxCustomEdit(TdxLayoutControlItemAccess(Container.AbsoluteItems[I]).Control).Style.TransparentBorder;
        if Result then
          Break;
      end;
  end;

const
  MainGroupDirectionMap: array[Boolean] of TdxLayoutDirection = (ldHorizontal, ldTabbed);
begin
  lcMainGroup1.LayoutDirection := MainGroupDirectionMap[Container.CustomizeFormTabbedView];

  acShowDesignSelectors.Visible := Container.IsDesigning;
  liShowDesignSelectors.Visible := acShowDesignSelectors.Visible;
  acHighlightRoot.Visible := Container.IsDesigning;
  liHighlightRoot.Visible := acHighlightRoot.Visible;
  acShowItemNames.Visible := Container.IsDesigning;
  liShowItemNames.Visible := acShowItemNames.Visible;
  acTransparentBorders.Visible := CheckTransparentBorders;
  liTransparentBorders.Visible := acTransparentBorders.Visible;

  RefreshStoring;

  acUndo.Visible := not Container.IsDesigning;
  liUndo.Visible := acUndo.Visible;
  acRedo.Visible := not Container.IsDesigning;
  liRedo.Visible := acRedo.Visible;

  lsSeparator4.Visible := (liUndo.Visible or liRedo.Visible) and
    (liShowDesignSelectors.Visible or liHighlightRoot.Visible or liStore.Visible or liRestore.Visible);

  acAddItem.Visible := Container.IsDesigning;
  liAddItem.Visible := acAddItem.Visible;
  acAddCheckBoxItem.Visible := Container.IsDesigning;
  acAddRadioButtonItem.Visible := Container.IsDesigning;

  acAlignBy.Visible := Container.IsDesigning;
  lsAlignBy.Visible := acAlignBy.Visible;
  liAlignBy.Visible := acAlignBy.Visible;
  acAddImage.Visible := Container.IsDesigning;

  acVisibleItemsMakeFloat.Visible := AllowAnyFloat;
  liVisibleItemsMakeFloat.Visible := acVisibleItemsMakeFloat.Visible;
  acAvailableItemsMakeFloat.Visible := AllowAnyFloat;
  liAvailableItemsMakeFloat.Visible := acAvailableItemsMakeFloat.Visible;

  if not Container.IsDesigning then
    RefreshLayoutLookAndFeel;
  RefreshButtonStates;
end;

procedure TdxLayoutControlCustomizeForm.SaveToUndo;
begin
  if not Container.IsDesigning then
    Container.SaveToUndo;
end;

procedure TdxLayoutControlCustomizeForm.CalculateTreeViewPopupActionEnables;

  function CanMakeGroup: Boolean;
  var
    I: Integer;
  begin
    Result := tvVisibleItems.SelectionCount = 1;
    if not Result and (tvVisibleItems.SelectionCount > 1) then
      for I := 1 to tvVisibleItems.SelectionCount - 1 do
      begin
        Result := TdxCustomLayoutItem(tvVisibleItems.Selections[I - 1].Data).Parent =
          TdxCustomLayoutItem(tvVisibleItems.Selections[I].Data).Parent;
        if not Result then
          Break;
      end;
  end;

var
  ACanModify: Boolean;
  AHasLockedGroupInSelection: Boolean;
begin
  ACanModify := CanModify;
  AHasLockedGroupInSelection := HasLockedGroupInSelection;

  miDirection.Enabled := ACanModify and not AHasLockedGroupInSelection;
  miAlignHorz.Enabled := ACanModify;
  miAlignVert.Enabled := ACanModify;
  miTextPosition.Enabled := ACanModify;
  miCaptionAlignHorz.Enabled := ACanModify;
  miCaptionAlignVert.Enabled := ACanModify;
  acCaption.Enabled := ACanModify;
  acBorder.Enabled := ACanModify;
  acExpandButton.Enabled := ACanModify;
  acCollapsible.Enabled := ACanModify;

  acGroup.Enabled := ACanModify and CanMakeGroup;
  acUngroup.Enabled := ACanModify and not AHasLockedGroupInSelection;
end;

procedure TdxLayoutControlCustomizeForm.CalculateTreeViewPopupActionVisibilities;
var
  AHitTest: TdxCustomLayoutHitTest;
  APopupForTree: Boolean;
  AHasGroup: Boolean;
  AHasLabeledItem: Boolean;
  AHasDirectionalItem: Boolean;
  AHasGroupsOnly: Boolean;
  AHasSpecialGroup: Boolean;
  AMenuItems: TdxLayoutCustomizeFormMenuItems;
begin
  AMenuItems := GetMenuItems;
  AHitTest := Container.GetHitTest;
  AHasGroup := HasGroupInSelection;
  AHasLabeledItem := HasLabeledItemInSelection;
  AHasDirectionalItem := HasDirectionalItemInSelection;
  AHasGroupsOnly := HasGroupsOnly;
  AHasSpecialGroup := HasRootInSelection or HasHiddenGroupInSelection;
  APopupForTree := AHitTest.HitTestCode = htTreeViewItems;

  miExpandAll.Visible := APopupForTree;
  miCollapseAll.Visible := APopupForTree;
  miSeparator1.Visible := APopupForTree;
  acTreeViewItemRename.Visible := APopupForTree and (cfmiRename in AMenuItems);
  miDirection.Visible := AHasGroupsOnly and (cfmiDirection in AMenuItems);
  miBorder.Visible := AHasGroupsOnly and not AHasSpecialGroup and (cfmiBorder in AMenuItems);
  acExpandButton.Visible := AHasGroupsOnly and not AHasSpecialGroup and (cfmiExpandButton in AMenuItems);
  miTextPosition.Visible := (AHasGroup or AHasLabeledItem) and not AHasDirectionalItem and
    not AHasSpecialGroup and (cfmiCaptionLayout in AMenuItems);
  miCaptionAlignHorz.Visible := (AHasGroup or AHasLabeledItem) and not AHasDirectionalItem and
    not AHasSpecialGroup and (cfmiCaptionAlignHorz in AMenuItems);
  miCaptionAlignVert.Visible := (AHasGroup or AHasLabeledItem) and not AHasDirectionalItem and
    not AHasSpecialGroup and (cfmiCaptionAlignVert in AMenuItems);
  acCaption.Visible := (AHasGroup or AHasLabeledItem) and not AHasDirectionalItem and
    not AHasSpecialGroup and (cfmiCaption in AMenuItems);
  miAlignHorz.Visible := (cfmiAlignHorz in AMenuItems);
  miAlignVert.Visible := (cfmiAlignVert in AMenuItems);
  acGroup.Visible := not HasRootInSelection and (cfmiGrouping in AMenuItems);
  acUngroup.Visible := AHasGroupsOnly and not AHasSpecialGroup and
    (tvVisibleItems.SelectionCount = 1) and not TdxCustomLayoutItem(tvVisibleItems.Selected.Data).IsRoot and
    (cfmiGrouping in AMenuItems);

  acCollapsible.Visible := HasSplitterOnly;
end;

function TdxLayoutControlCustomizeForm.HasDirectionalItemInSelection: Boolean;
begin
  Result := HasClassInSelection(TdxLayoutDirectionalItem);
end;

function TdxLayoutControlCustomizeForm.HasGroupInSelection: Boolean;
begin
  Result := HasClassInSelection(TdxCustomLayoutGroup);
end;

function TdxLayoutControlCustomizeForm.HasGroupsOnly: Boolean;
begin
  Result := HasGroupInSelection and not HasLabeledItemInSelection and not HasDirectionalItemInSelection;
end;

function TdxLayoutControlCustomizeForm.HasHiddenGroupInSelection: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to tvVisibleItems.SelectionCount - 1 do
  begin
    Result := IsHiddenGroup(TdxCustomLayoutItem(tvVisibleItems.Selections[I].Data));
    if Result then
      Break;
  end;
end;

function TdxLayoutControlCustomizeForm.HasLabeledItemInSelection: Boolean;
begin
  Result := HasClassInSelection(TdxCustomLayoutLabeledItem);
end;

function TdxLayoutControlCustomizeForm.HasLockedGroupInSelection: Boolean;
var
  I: Integer;
begin
  Result := False;
  if not Container.IsDesigning then
    for I := 0 to tvVisibleItems.SelectionCount - 1 do
      if TObject(tvVisibleItems.Selections[I].Data) is TdxCustomLayoutGroup then
      begin
        Result := TdxCustomLayoutGroup(tvVisibleItems.Selections[I].Data).Locked;
        if Result then
          Break;
      end;
end;

function TdxLayoutControlCustomizeForm.HasLockedItemInSelection: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to tvVisibleItems.SelectionCount - 1 do
  begin
    Result := TdxCustomLayoutItemAccess(tvVisibleItems.Selections[I].Data).IsParentLocked;
    if Result then
      Break;
  end;
end;

function TdxLayoutControlCustomizeForm.HasRootInSelection: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to tvVisibleItems.SelectionCount - 1 do
  begin
    Result := TdxCustomLayoutItem(tvVisibleItems.Selections[I].Data).IsRoot;
    if Result then
      Break;
  end;
end;

function TdxLayoutControlCustomizeForm.HasSplitterOnly: Boolean;
begin
  Result := HasClassInSelection(TdxLayoutSplitterItem) and not HasGroupInSelection and not HasLabeledItemInSelection;
end;

procedure TdxLayoutControlCustomizeForm.SynchronizeTreeViewPopupActionStates;
const
  CaptionAlignHorzMap: array[TAlignment] of Integer = (0, 2, 1);

  procedure ResetSubMenu(AMenu: TMenuItem);
  var
    I: Integer;
  begin
    for I := 0 to AMenu.Count - 1 do
      TAction(AMenu.Items[I].Action).Checked := False;
  end;

var
  AItem: TdxCustomLayoutItem;
  ACaptionOptions: TdxCustomLayoutItemCaptionOptionsAccess;
begin
  ResetSubMenu(miAlignHorz);
  ResetSubMenu(miAlignVert);
  ResetSubMenu(miDirection);
  ResetSubMenu(miTextPosition);
  ResetSubMenu(miCaptionAlignHorz);
  ResetSubMenu(miCaptionAlignVert);

  if tvVisibleItems.SelectionCount >= 1 then
  begin
    AItem := TdxCustomLayoutItem(tvVisibleItems.Selected.Data);
    ACaptionOptions := GetCaptionOptions(AItem);

    TAction(miTextPosition.Items[Integer(ACaptionOptions.Layout)].Action).Checked := True;
    TAction(miCaptionAlignHorz.Items[CaptionAlignHorzMap[ACaptionOptions.AlignHorz]].Action).Checked := True;
    TAction(miCaptionAlignVert.Items[Integer(ACaptionOptions.AlignVert)].Action).Checked := True;
    TAction(miAlignHorz.Items[Integer(AItem.AlignHorz)].Action).Checked := True;
    TAction(miAlignVert.Items[Integer(AItem.AlignVert)].Action).Checked := True;
    acCaption.Checked := ACaptionOptions.Visible;
    if AItem is TdxLayoutSplitterItem then
      acCollapsible.Checked := TdxLayoutSplitterItem(AItem).AllowCloseOnClick;
    if AItem is TdxCustomLayoutGroup then
    begin
      TAction(miDirection.Items[Integer(TdxCustomLayoutGroup(AItem).LayoutDirection)].Action).Checked := True;
      acBorder.Checked := TdxCustomLayoutGroup(AItem).ShowBorder;
      acExpandButton.Checked := TdxCustomLayoutGroup(AItem).ButtonOptions.ShowExpandButton;
    end;
  end;
end;

function TdxLayoutControlCustomizeForm.CanSelectItem(AItem: TdxCustomLayoutItem): Boolean;
begin
  Result := (AItem <> nil) and not TdxCustomLayoutItemAccess(AItem).IsDestroying and
    Supports(Container, IdxLayoutDesignerHelper);
end;

procedure TdxLayoutControlCustomizeForm.SelectItem(AItem: TdxCustomLayoutItem);
var
  AIntf: IdxLayoutDesignerHelper;
begin
  if Supports(Container, IdxLayoutDesignerHelper, AIntf) then
  begin
    if AItem <> nil then
      AIntf.SelectComponent(AItem)
    else
      AIntf.SelectComponent(Container);
    AIntf := nil;
  end;
  RefreshEnabled;
end;

procedure TdxLayoutControlCustomizeForm.SetItemsSelections(AList: TList);

  procedure SetActiveControl(AControl: TWinControl);
  begin
//    GetParentForm(Self).ActiveControl := nil;
    GetParentForm(Self).ActiveControl := AControl;
  end;

  procedure SetTreeViewAsActiveControl(ATreeView: TdxTreeViewControl);
  begin
    if ATreeView.Visible then
    begin
      SetActiveControl(ATreeView);
      ATreeView.MakeVisible(ATreeView.FocusedNode);
    end
    else
      SetActiveControl(nil);
  end;

var
  I: Integer;
  AItem: TdxCustomLayoutItemAccess;
  AVisibleItems, AAvailableItems: TList;
  ANode: TdxTreeViewNode;
begin
  if IsLocked then
    Exit;
  BeginUpdate;
  try
    AVisibleItems := TList.Create;
    AAvailableItems := TList.Create;
    try
      for I := 0 to AList.Count - 1 do
        if FVisibleNodesDictionary.TryGetValue(AList[I], ANode) then
          AVisibleItems.Add(ANode)
        else
          if FAvailableNodesDictionary.TryGetValue(AList[I], ANode) then
            AAvailableItems.Add(ANode);

      tvVisibleItems.Select(AVisibleItems);
      tvAvailableItems.Select(AAvailableItems);

      if (AList.Count > 0) and (TObject(AList.Last) is TdxCustomLayoutItem) then
      begin
        AItem := TdxCustomLayoutItemAccess(AList.Last);
        if AItem.IsAvailable then
          SetTreeViewAsActiveControl(tvAvailableItems)
        else
          SetTreeViewAsActiveControl(tvVisibleItems);
      end;
    finally
      AVisibleItems.Free;
      AAvailableItems.Free;
    end;
  finally
    CancelUpdate;
  end;
  RefreshEnabled;
end;

procedure TdxLayoutControlCustomizeForm.SetLayoutItemsSelections(ATreeView: TdxTreeViewControl);
var
  AList: TList;
  AIntf: IdxLayoutDesignerHelper;
begin
  AList := TList.Create;
  try
    ATreeView.GetSelectedData(AList);
    if Supports(Container, IdxLayoutDesignerHelper, AIntf) then
    begin
      if (AList.Count = 1) and (TObject(AList[0]) is TdxCustomLayoutItem) then
        TdxCustomLayoutItem(AList[0]).MakeVisible;
      AIntf.SetSelection(AList);
      AIntf := nil;
    end;
  finally
    AList.Free;
  end;
end;

function TdxLayoutControlCustomizeForm.TreeViewWndProcHandler(ATreeView: TdxTreeViewControl; var Message: TMessage): Boolean;
begin
  case Message.Msg of
    CM_RECREATEWND:
      begin
        Result := True; 
//        FNodesDictionary.Clear;
      end
  else
    Result := False;
  end;
end;

procedure TdxLayoutControlCustomizeForm.RestoreCollapsedNodes(ATreeView: TdxTreeViewControl; AList: TList);
var
  I: Integer;
  ANode: TdxTreeViewNode;
begin
  ATreeView.FullExpand;
  for I := 0 to AList.Count - 1 do
    if FindNodeByItem(TdxCustomLayoutItem(AList.List[I]), ANode) then
      ANode.Expanded := False;
end;

procedure TdxLayoutControlCustomizeForm.StoreCollapsedNodes(ATreeView: TdxTreeViewControl; AList: TList);
var
  ANode: TdxTreeViewNode;
  I: Integer;
begin
  for I := 0 to ATreeView.AbsoluteVisibleCount - 1 do
  begin
    ANode := ATreeView.AbsoluteVisibleItems[I];
    if ANode.HasChildren and not ANode.Expanded then
      AList.Add(ANode.Data);
  end;
end;

procedure TdxLayoutControlCustomizeForm.RestoreFirstNode(ATreeView: TdxTreeViewControl; AItem: TdxCustomLayoutItem);
var
  ANode: TdxTreeViewNode;
begin
  if FindNodeByItem(AItem, ANode) then
    ATreeView.TopItem := ANode
  else
    ATreeView.TopItem := ATreeView.Items.GetFirstNode;
end;

procedure TdxLayoutControlCustomizeForm.StoreFirstNode(ATreeView: TdxTreeViewControl; out AItem: TdxCustomLayoutItem);
begin
  if ATreeView.TopItem <> nil then
    AItem := ATreeView.TopItem.Data
  else
    AItem := nil;
end;

procedure TdxLayoutControlCustomizeForm.acCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TdxLayoutControlCustomizeForm.acCollapsibleExecute(Sender: TObject);
var
  AList: TList;
  I: Integer;
begin
  if tvVisibleItems.IsEditing then
    Exit;
  SaveToUndo;
  Container.BeginUpdate;
  try
    acCollapsible.Checked := not acCollapsible.Checked;
    AList := TList.Create;
    try
      tvVisibleItems.GetSelectedData(AList);
      for I := 0 to AList.Count - 1 do
        TdxLayoutSplitterItem(AList[I]).AllowCloseOnClick := acCollapsible.Checked;
      Container.Modified;
    finally
      AList.Free;
    end;
  finally
    Container.EndUpdate(False);
  end;
end;

procedure TdxLayoutControlCustomizeForm.acAddCheckBoxItemExecute(Sender: TObject);
begin
  CreateItem(TdxLayoutCheckBoxItem, cxGetResourceString(@sdxLayoutControlNewCheckBoxItemCaption));
end;

procedure TdxLayoutControlCustomizeForm.acAddGroupExecute(Sender: TObject);
begin
  CreateItem(TdxLayoutContainerAccess(Container).GetDefaultGroupClass, cxGetResourceString(@sdxLayoutControlNewGroupCaption));
end;

procedure TdxLayoutControlCustomizeForm.acAddItemExecute(Sender: TObject);
begin
  CreateItem(TdxLayoutContainerAccess(Container).GetDefaultItemClass, cxGetResourceString(@sdxLayoutControlNewItemCaption));
end;

procedure TdxLayoutControlCustomizeForm.acAddEmptySpaceItemExecute(Sender: TObject);
var
  AItem: TdxCustomLayoutItem;
begin
  AItem := CreateItem(TdxLayoutEmptySpaceItem, cxGetResourceString(@sdxLayoutControlNewEmptySpaceItemCaption));
  AItem.Width := 10;
  AItem.Height := 10;
end;

procedure TdxLayoutControlCustomizeForm.acAddSeparatorExecute(Sender: TObject);
begin
  CreateItem(TdxLayoutSeparatorItem, cxGetResourceString(@sdxLayoutControlNewSeparatorItemCaption));
end;

procedure TdxLayoutControlCustomizeForm.acAddCustomItemExecute(Sender: TObject);
begin
//
end;

procedure TdxLayoutControlCustomizeForm.acAddLabeledItemExecute(Sender: TObject);
begin
  CreateItem(TdxLayoutContainerAccess(Container).GetDefaultLabelClass, cxGetResourceString(@sdxLayoutControlNewLabeledItemCaption));
end;

procedure TdxLayoutControlCustomizeForm.acAddRadioButtonItemExecute(Sender: TObject);
begin
  CreateItem(TdxLayoutRadioButtonItem, cxGetResourceString(@sdxLayoutControlNewRadioButtonItemCaption));
end;

procedure TdxLayoutControlCustomizeForm.acAddSplitterExecute(Sender: TObject);
var
  AItem: TdxCustomLayoutItem;
begin
  SaveToUndo;
  AItem := Container.CreateItem(TdxLayoutSplitterItem);
  AItem.Caption := cxGetResourceString(@sdxLayoutControlNewSplitterItemCaption);
  DoAfterInsertionItem(AItem);
end;

procedure TdxLayoutControlCustomizeForm.AlignExecute(Sender: TObject);
var
  AIntf: IdxLayoutDesignerHelper;
  AList: TList;
  ATag: TcxTag;
  I: Integer;
begin
  //todo: TdxLayoutControlAccess(Control).SaveToUndo;
  ATag := (Sender as TAction).Tag;
  AList := TList.Create;
  try
    if Supports(Container, IdxLayoutDesignerHelper, AIntf) then
    begin
      AIntf.GetSelection(AList);
      AIntf := nil;
    end;
    BeginUpdate;
    try
      Container.BeginUpdate;
      try
        if ATag = -1 then
          for I := 0 to AList.Count - 1 do
            TdxCustomLayoutItem(AList[I]).AlignmentConstraint := nil
        else
          with Container.CreateAlignmentConstraint do
          begin
            Kind := TdxLayoutAlignmentConstraintKind(ATag);
            for I := 0 to AList.Count - 1 do
              AddItem(TdxCustomLayoutItem(AList[I]));
          end;
      finally
        Container.EndUpdate;
      end;
    finally
      CancelUpdate;
    end;
  finally
    AList.Free;
  end;
end;

procedure TdxLayoutControlCustomizeForm.acTreeViewItemsDeleteExecute(Sender: TObject);
begin
  DeleteSelection(tvVisibleItems);
end;

procedure TdxLayoutControlCustomizeForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TdxLayoutControlCustomizeForm.tvVisibleItemsContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
//  acAvailableItemsDelete.Enabled := False;
end;

procedure TdxLayoutControlCustomizeForm.acAvailableItemsDeleteExecute(Sender: TObject);
begin
  DeleteSelection(tvAvailableItems);
end;

procedure TdxLayoutControlCustomizeForm.tvAvailableItemsContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
//  acTreeViewItemsDelete.Enabled := False;
end;

procedure TdxLayoutControlCustomizeForm.acAvailableItemsExpandAllExecute(Sender: TObject);
begin
  tvAvailableItems.FullExpand;
end;

procedure TdxLayoutControlCustomizeForm.acAvailableItemsCollapseAllExecute(Sender: TObject);
begin
  tvAvailableItems.FullCollapse;
end;

procedure TdxLayoutControlCustomizeForm.acTreeViewExpandAllExecute(Sender: TObject);
begin
  tvVisibleItems.EndEdit(True);
  tvVisibleItems.FullExpand;
end;

procedure TdxLayoutControlCustomizeForm.acTransparentBordersExecute(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to Container.AbsoluteItemCount - 1 do
    if (Container.AbsoluteItems[I] is TdxLayoutControlItem) and
       (TdxLayoutControlItemAccess(Container.AbsoluteItems[I]).Control is TcxCustomEdit) then
      TcxCustomEdit(TdxLayoutControlItemAccess(Container.AbsoluteItems[I]).Control).Style.TransparentBorder := False;
  acTransparentBorders.Visible := False;
end;

procedure TdxLayoutControlCustomizeForm.acTreeViewCollapseAllExecute(Sender: TObject);
begin
  tvVisibleItems.EndEdit(True);
  tvVisibleItems.FullCollapse;
//  if tvVisibleItems.Selected <> nil then
//    tvVisibleItems.Select(tvVisibleItems.Selected); //# Bug in Treeview selections not synchronized vs Selected
  SetLayoutItemsSelections(tvVisibleItems);
end;

procedure TdxLayoutControlCustomizeForm.acAvailableItemsViewAsListExecute(Sender: TObject);
const
  AViewKindMap: array [Boolean] of TdxLayoutAvailableItemsViewKind = (aivkList, aivkTree);
begin
  Container.CustomizeAvailableItemsViewKind := AViewKindMap[acAvailableItemsViewAsList.Checked];
end;

procedure TdxLayoutControlCustomizeForm.FormShortCut(var Msg: TWMKey;
  var Handled: Boolean);
begin
  case Msg.CharCode of
    VK_ESCAPE:
      begin
        Handled := tvVisibleItems.IsEditing or tvAvailableItems.IsEditing;
        if Handled then
        begin
          tvVisibleItems.EndEdit(True);
          tvAvailableItems.EndEdit(True);
        end;
      end;
  end;
end;

procedure TdxLayoutControlCustomizeForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    if tvVisibleItems.Focused and not tvVisibleItems.IsEditing then
      acTreeViewItemsDelete.Execute;
    if tvAvailableItems.Focused and not tvAvailableItems.IsEditing then
      acAvailableItemsDelete.Execute;
  end;
end;

procedure TdxLayoutControlCustomizeForm.acTabbedViewExecute(Sender: TObject);
begin
  Container.CustomizeFormTabbedView := acTabbedView.Checked;
end;

procedure TdxLayoutControlCustomizeForm.acHighlightRootExecute(Sender: TObject);
begin
  Container.HighlightRoot := acHighlightRoot.Checked;
end;

procedure TdxLayoutControlCustomizeForm.acShowDesignSelectorsExecute(Sender: TObject);
begin
  Container.ShowDesignSelectors := acShowDesignSelectors.Checked;
end;

procedure TdxLayoutControlCustomizeForm.acShowItemNamesExecute(Sender: TObject);
begin
  tvVisibleItems.EndEdit(True);
  tvAvailableItems.EndEdit(True);
  UpdateContent;
  RefreshEnabled;
end;

procedure TdxLayoutControlCustomizeForm.acStoreExecute(Sender: TObject);
begin
  TdxLayoutContainerAccess(Container).Store;
  RefreshEnabled;
end;

procedure TdxLayoutControlCustomizeForm.acRestoreExecute(Sender: TObject);
begin
  SaveToUndo;
  TdxLayoutContainerAccess(Container).Restore;
end;

procedure TdxLayoutControlCustomizeForm.acTreeViewItemRenameExecute(Sender: TObject);
begin
  tvVisibleItems.Selected.EditCaption;
end;

procedure TdxLayoutControlCustomizeForm.acAvailableItemRenameExecute(Sender: TObject);
begin
  tvAvailableItems.Selected.EditCaption;
end;

procedure TdxLayoutControlCustomizeForm.acUndoExecute(Sender: TObject);
begin
  Container.UndoRedoManager.Undo;
  RefreshButtonStates;
end;

procedure TdxLayoutControlCustomizeForm.acRedoExecute(Sender: TObject);
begin
  Container.UndoRedoManager.Redo;
  RefreshButtonStates;
end;

procedure TdxLayoutControlCustomizeForm.acAlignByExecute(Sender: TObject);
begin
// for popup
end;

procedure TdxLayoutControlCustomizeForm.acHAlignExecute(Sender: TObject);
var
  AList: TList;
  I: Integer;
begin
  if tvVisibleItems.IsEditing then
    Exit;
  SaveToUndo;
  AList := TList.Create;
  try
    tvVisibleItems.GetSelectedData(AList);
    for I := 0 to AList.Count - 1 do
      TdxCustomLayoutItem(AList[I]).AlignHorz := TdxLayoutAlignHorz((Sender as TAction).Tag);
    Container.Modified;
  finally
    AList.Free;
  end;
end;

procedure TdxLayoutControlCustomizeForm.pmAvailableItemsActionsPopup(Sender: TObject);
begin
  acAvailableItemRename.Visible := cfmiRename in GetMenuItems;
end;

procedure TdxLayoutControlCustomizeForm.pmTreeViewActionsPopup(Sender: TObject);
begin
  CalculateTreeViewPopupActionVisibilities;
  CalculateTreeViewPopupActionEnables;
  SynchronizeTreeViewPopupActionStates;
end;

procedure TdxLayoutControlCustomizeForm.acVAlignExecute(Sender: TObject);
var
  AList: TList;
  I: Integer;
begin
  if tvVisibleItems.IsEditing then
    Exit;
  SaveToUndo;
  AList := TList.Create;
  try
    tvVisibleItems.GetSelectedData(AList);
    for I := 0 to AList.Count - 1 do
      TdxCustomLayoutItem(AList[I]).AlignVert := TdxLayoutAlignVert((Sender as TAction).Tag);
    Container.Modified;
  finally
    AList.Free;
  end;
end;

procedure TdxLayoutControlCustomizeForm.acDirectionsExecute(Sender: TObject);
var
  AList: TList;
  I: Integer;
  ANewDirection: TdxLayoutDirection;
begin
  if tvVisibleItems.IsEditing then
    Exit;
  SaveToUndo;
  AList := TList.Create;
  try
    tvVisibleItems.GetSelectedData(AList);
    ANewDirection := TdxLayoutDirection((Sender as TAction).Tag);
    for I := 0 to AList.Count - 1 do
      if TObject(AList[I]) is TdxCustomLayoutGroup then
        TdxCustomLayoutGroup(AList[I]).LayoutDirection := ANewDirection;
    Container.Modified;
  finally
    AList.Free;
  end;
  tvVisibleItems.Invalidate;
end;

procedure TdxLayoutControlCustomizeForm.acBorderExecute(Sender: TObject);
var
  AList: TList;
  I: Integer;
begin
  if tvVisibleItems.IsEditing then
    Exit;
  SaveToUndo;
  acBorder.Checked := not acBorder.Checked;
  AList := TList.Create;
  try
    tvVisibleItems.GetSelectedData(AList);
    for I := 0 to AList.Count - 1 do
    begin
      if TObject(AList[I]) is TdxCustomLayoutGroup then
        TdxCustomLayoutGroup(AList[I]).ShowBorder := (Sender as TAction).Checked;
    end;
    Container.Modified;
  finally
    AList.Free;
  end;
end;

procedure TdxLayoutControlCustomizeForm.acExpandButtonExecute(Sender: TObject);
var
  AList: TList;
  I: Integer;
begin
  if tvVisibleItems.IsEditing then
    Exit;
  SaveToUndo;
  Container.BeginUpdate;
  try
    acExpandButton.Checked := not acExpandButton.Checked;
    AList := TList.Create;
    try
      tvVisibleItems.GetSelectedData(AList);
      for I := 0 to AList.Count - 1 do
      begin
        if TObject(AList[I]) is TdxCustomLayoutGroup then
          TdxCustomLayoutGroup(AList[I]).ButtonOptions.ShowExpandButton := acExpandButton.Checked;
      end;
      Container.Modified;
    finally
      AList.Free;
    end;
  finally
    Container.EndUpdate(False);
  end;
end;

procedure TdxLayoutControlCustomizeForm.acTextPositionExecute(Sender: TObject);
var
  AList: TList;
  I: Integer;
begin
  if tvVisibleItems.IsEditing then
    Exit;
  SaveToUndo;
  Container.BeginUpdate;
  try
    AList := TList.Create;
    try
      tvVisibleItems.GetSelectedData(AList);
      for I := 0 to AList.Count - 1 do
        GetCaptionOptions(TdxCustomLayoutItem(AList[I])).Layout := TdxCaptionLayout((Sender as TAction).Tag);
      Container.Modified;
    finally
      AList.Free;
    end;
  finally
    Container.EndUpdate(False);
  end;
end;

procedure TdxLayoutControlCustomizeForm.acCaptionAlignHorzExecute(Sender: TObject);
var
  AList: TList;
  I: Integer;
begin
  if tvVisibleItems.IsEditing then
    Exit;
  SaveToUndo;
  Container.BeginUpdate;
  try
    AList := TList.Create;
    try
      tvVisibleItems.GetSelectedData(AList);
      for I := 0 to AList.Count - 1 do
        GetCaptionOptions(TdxCustomLayoutItem(AList[I])).AlignHorz :=
          TAlignment((Sender as TAction).Tag);
      Container.Modified;
    finally
      AList.Free;
    end;
  finally
    Container.EndUpdate(False);
  end;
end;

procedure TdxLayoutControlCustomizeForm.acCaptionExecute(Sender: TObject);
var
  AList: TList;
  I: Integer;
begin
  if tvVisibleItems.IsEditing then
    Exit;
  SaveToUndo;
  Container.BeginUpdate;
  try
    acCaption.Checked := not acCaption.Checked;
    AList := TList.Create;
    try
      tvVisibleItems.GetSelectedData(AList);
      for I := 0 to AList.Count - 1 do
        GetCaptionOptions(TdxCustomLayoutItem(AList[I])).Visible := acCaption.Checked;
      Container.Modified;
    finally
      AList.Free;
    end;
  finally
    Container.EndUpdate(False);
  end;
end;

procedure TdxLayoutControlCustomizeForm.acCaptionAlignVertExecute(Sender: TObject);
var
  AList: TList;
  I: Integer;
begin
  if tvVisibleItems.IsEditing then
    Exit;
  SaveToUndo;
  Container.BeginUpdate;
  try
    AList := TList.Create;
    try
      tvVisibleItems.GetSelectedData(AList);
      for I := 0 to AList.Count - 1 do
        TdxCustomLayoutItemCaptionOptionsAccess(TdxCustomLayoutItem(AList[I]).CaptionOptions).AlignVert := TdxAlignmentVert((Sender as TAction).Tag);
      Container.Modified;
    finally
      AList.Free;
    end;
  finally
    Container.EndUpdate(False);
  end;
end;

procedure TdxLayoutControlCustomizeForm.acGroupExecute(Sender: TObject);
const
  LayoutDirectionMap: array [TdxLayoutDirection] of TdxLayoutDirection = (ldHorizontal, ldVertical, ldVertical);

  function GetIndexByItem(AParent: TdxCustomLayoutGroup; AItem: TdxCustomLayoutItem): Integer;
  begin
    if AParent = AItem.Parent then
      Result := AItem.Index
    else
      Result := GetIndexByItem(AParent, AItem.Parent);
  end;

  function GetIndex(AParent: TdxCustomLayoutGroup; AList: TList): Integer;
  var
    I: Integer;
  begin
    Result := AParent.Count;
    for I := 0 to AList.Count - 1 do
      Result := Min(Result, GetIndexByItem(AParent, TdxCustomLayoutItem(AList[I])));
  end;

var
  AList: TList;
  I: Integer;
  AParent: TdxCustomLayoutGroup;
  AGroup: TdxCustomLayoutGroup;
  AIndex: Integer;
begin
  if tvVisibleItems.IsEditing then
    Exit;
  SaveToUndo;
  Container.BeginUpdate;
  try
    AList := TList.Create;
    try
      tvVisibleItems.GetSelectedData(AList);
      AList.Sort(CompareItemsByIndex);
      AParent := TdxCustomLayoutItem(AList[0]).Parent;
      AIndex := GetIndex(AParent, AList);
      AGroup := DoCreateItem(TdxLayoutContainerAccess(Container).GetDefaultGroupClass, cxGetResourceString(@sdxLayoutControlNewGroupCaption)) as TdxCustomLayoutGroup;
      AGroup.LayoutDirection := LayoutDirectionMap[AParent.LayoutDirection];
      AGroup.MoveTo(AParent, AIndex);
      for I := 0 to AList.Count - 1 do
        TdxCustomLayoutItem(AList[I]).Parent := AGroup;
      Container.Modified;
    finally
      AList.Free;
    end;
  finally
    Container.EndUpdate;
  end;
end;

procedure TdxLayoutControlCustomizeForm.acUngroupExecute(Sender: TObject);
var
  AGroup: TdxCustomLayoutGroup;
begin
  if tvVisibleItems.IsEditing then
    Exit;
  SaveToUndo;
  Container.BeginUpdate;
  try
    AGroup := TdxCustomLayoutGroup(tvVisibleItems.Selected.Data);
    AGroup.MoveChildrenToParent;
    AGroup.Free;
  finally
    Container.EndUpdate;
  end;
end;

procedure TdxLayoutControlCustomizeForm.acAddImageExecute(Sender: TObject);
begin
  CreateItem(TdxLayoutImageItem, cxGetResourceString(@sdxLayoutControlNewImageItemCaption));
end;

procedure TdxLayoutControlCustomizeForm.acVisibleItemsMakeFloatExecute(Sender: TObject);
begin
  MakeBreakFloat(tvVisibleItems);
end;

procedure TdxLayoutControlCustomizeForm.acAvailableItemsFloatExecute(Sender: TObject);
begin
  MakeBreakFloat(tvAvailableItems);
end;

procedure TdxLayoutControlCustomizeForm.tvAvailableItemsAddition(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode);
begin
  FAvailableNodesDictionary.Add(ANode.Data, ANode);
end;

procedure TdxLayoutControlCustomizeForm.tvAvailableItemsCollapsed(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode);
begin
  if ANode.Focused then
    ANode.Selected := True;
end;

procedure TdxLayoutControlCustomizeForm.tvAvailableItemsCustomDrawNode(Sender: TdxCustomTreeView; Canvas: TcxCanvas; NodeViewInfo: TdxTreeViewNodeViewInfo; var Handled: Boolean);
var
  ANode: TdxTreeViewNode;
begin
  ANode := NodeViewInfo.Node;
  if ANode.Deleting then
    Exit;
  if (TObject(ANode.Data) is TdxCustomLayoutGroup) and TdxCustomLayoutGroupAccess(ANode.Data).AutoCreated and
      not TdxCustomLayoutGroup(ANode.Data).IsRoot then
  begin
    Canvas.Font.Style := [fsItalic];
    NodeViewInfo.DefaultDraw(Canvas);
    Handled := True;
  end;
end;

procedure TdxLayoutControlCustomizeForm.tvAvailableItemsDeletion(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode);
begin
  if (FAvailableNodesDictionary <> nil) and FAvailableNodesDictionary.ContainsKey(ANode.Data) then
    FAvailableNodesDictionary.Remove(ANode.Data);
  SelectNextNode(ANode);
end;

procedure TdxLayoutControlCustomizeForm.tvVisibleItemsAddition(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode);
begin
  FVisibleNodesDictionary.Add(ANode.Data, ANode);
end;

procedure TdxLayoutControlCustomizeForm.tvVisibleItemsCanFocusNode(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode; var Allow: Boolean);
begin
  Allow := ANode.Data <> nil;
end;

procedure TdxLayoutControlCustomizeForm.tvVisibleItemsCanSelectNode(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode; var Allow: Boolean);
begin
  Allow := ANode.Data <> nil;
end;

procedure TdxLayoutControlCustomizeForm.tvVisibleItemsDeletion(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode);
begin
  if (FVisibleNodesDictionary <> nil) and FVisibleNodesDictionary.ContainsKey(ANode.Data) then
    FVisibleNodesDictionary.Remove(ANode.Data);
  SelectNextNode(ANode);
end;

procedure TdxLayoutControlCustomizeForm.tvVisibleItemsEdited(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode; var S: string);
begin
  if TdxCustomLayoutItem(ANode.Data).IsRoot then
    Exit;
  RefreshButtonStates;
  BeginUpdate;
  try
    SetCustomizationCaption(TdxCustomLayoutItem(ANode.Data), S);
    S := GetCustomizationCaption(TdxCustomLayoutItem(ANode.Data));
    ANode.Caption := S; 
  finally
    CancelUpdate;
  end;
end;

procedure TdxLayoutControlCustomizeForm.tvVisibleItemsEditing(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode; var Allow: Boolean);

  function IsKeyDown(AShift: TShiftState): Boolean;
  begin
    Result := (AShift * KeyboardStateToShiftState) <> [];
  end;

begin
  Allow := not (TdxCustomLayoutItem(ANode.Data).IsRoot or (DragHelper.DragItem <> nil) or
    IsKeyDown([ssCtrl, ssShift]) or TdxCustomLayoutItemAccess(ANode.Data).IsParentLocked) and
    TdxLayoutContainerAccess(Container).AllowRename;


  RefreshEnabled;   
end;

procedure TdxLayoutControlCustomizeForm.tvAvailableItemsEnter(Sender: TObject);
var
  ATreeView: TdxTreeViewControl;
begin
  ATreeView := Sender as TdxTreeViewControl;
  if (ATreeView.Selected = nil) and (ATreeView.FocusedNode <> nil) then
    ATreeView.FocusedNode.Selected := True;
end;

procedure TdxLayoutControlCustomizeForm.tvVisibleItemsGetEditingText(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode; var S: string);
begin
  if Container.IsDesigning then
    Exit;
  if acShowItemNames.Checked then
    S := TdxCustomLayoutItemAccess(ANode.Data).Name
  else
    S := TdxCustomLayoutItemAccess(ANode.Data).GetInplaceRenameCaption;
end;

procedure TdxLayoutControlCustomizeForm.tvVisibleItemsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ANode: TdxTreeViewNode;
  ATreeView: TdxTreeViewControl;
  AHitTest: TdxTreeViewHitTest;
begin
  ATreeView := TdxTreeViewControl(Sender);
  if Button = mbLeft then
  begin
    AHitTest := ATreeView.GetHitTestAt(X, Y);
    ANode := AHitTest.HitObjectAsNode;
    if AHitTest.HitAtSelection and ([ssShift, ssCtrl] * Shift = []) then
    begin
      if not (ssDouble in Shift) then
        ANode.Selected := False;
      DragHelper.InitializeDragItem(ANode.Data, X, Y);
    end;
  end
  else
    if (Button = mbRight) and ATreeView.GetNodeAtPos(Point(X, Y), ANode) then
    begin
      ANode.Focused := True;
      if not ANode.Selected then
      begin
        if [ssShift, ssCtrl] * Shift <> [] then
          Shift := [];
        BeginUpdate;
        try
          ATreeView.Select(ANode, Shift);
        finally
          CancelUpdate;
        end;
        SetLayoutItemsSelections(ATreeView);
      end;
    end;
end;

procedure TdxLayoutControlCustomizeForm.tvVisibleItemsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then
    DragHelper.TryBeginDragAndDrop(X, Y);
end;

procedure TdxLayoutControlCustomizeForm.tvVisibleItemsMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    DragHelper.Reset;
    tvAvailableItems.DropTarget := nil;
    tvVisibleItems.DropTarget := nil;
  end;
end;

procedure TdxLayoutControlCustomizeForm.tvVisibleItemsSelectionChanged(Sender: TObject);
begin
  if not IsLocked then
    SetLayoutItemsSelections(Sender as TdxTreeViewControl);
end;

end.
