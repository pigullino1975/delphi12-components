{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressEditors                                           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSEDITORS AND ALL                }
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

unit dxListViewEditor;

{$I cxVer.inc}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, cxGraphics, cxControls, cxLookAndFeels,
  DesignIntf, cxDesignWindows,
  dxGenerics, cxLookAndFeelPainters, dxLayoutContainer, dxLayoutControlAdapters, cxClasses,
  dxLayoutControl, dxListView,
  StdActns, ActnList, dxTreeView, Menus, cxButtons, cxContainer,
  cxEdit, cxCustomListBox, cxListBox, dxLayoutLookAndFeels,
  dxLayoutcxEditAdapters, cxTextEdit, cxMaskEdit, cxDropDownEdit;

type
  TdxItemInfo = class
  strict private
    FSubItems: TStringList;
    FSubItemImages: TdxIntegerList;
    FCaption: string;
    FImageIndex: Integer;
    FStateIndex: Integer;
    FGroupID: Integer;
  public
    constructor Create(AItem: TdxListItem);
    destructor Destroy; override;
    procedure AddSubItem(const ACaption: string; ANode: TdxTreeViewNode; AImageIndex: Integer);
    procedure DeleteSubItem(AIndex: Integer);
    procedure InsertSubItem(AIndex: Integer; const ACaption: string; ANode: TdxTreeViewNode; AImageIndex: Integer);
    procedure MoveTo(ASourceIndex, ADestIndex: Integer);

    property Caption: string read FCaption write FCaption;
    property ImageIndex: Integer read FImageIndex write FImageIndex;
    property StateIndex: Integer read FStateIndex write FStateIndex;
    property GroupID: Integer read FGroupID write FGroupID;
    property SubItems: TStringList read FSubItems;
    property SubItemImages: TdxIntegerList read FSubItemImages;
  end;

  TfmListViewEditor = class(TcxDesignFormEditor)
    btNewItem: TcxButton;
    btDeleteItem: TcxButton;
    btNewSubItem: TcxButton;
    edStateImageIndex: TcxTextEdit;
    btOk: TcxButton;
    btCancel: TcxButton;
    btApply: TcxButton;
    btHelp: TcxButton;
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutGroup1: TdxLayoutGroup;
    lgTabs: TdxLayoutGroup;
    dxLayoutGroup3: TdxLayoutGroup;
    dxLayoutGroup4: TdxLayoutGroup;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutItem3: TdxLayoutItem;
    dxLayoutItem4: TdxLayoutItem;
    grpItemProperties: TdxLayoutGroup;
    dxLayoutGroup6: TdxLayoutGroup;
    dxLayoutItem6: TdxLayoutItem;
    dxLayoutItem7: TdxLayoutItem;
    dxLayoutGroup7: TdxLayoutGroup;
    dxLayoutItem9: TdxLayoutItem;
    dxLayoutItem10: TdxLayoutItem;
    dxLayoutItem11: TdxLayoutItem;
    dxLayoutItem12: TdxLayoutItem;
    lgItems: TdxLayoutGroup;
    lgColumns: TdxLayoutGroup;
    lgGroups: TdxLayoutGroup;
    lgGroupsContainer: TdxLayoutGroup;
    lgColumnsContainer: TdxLayoutGroup;
    lbColumns: TcxListBox;
    dxLayoutItem13: TdxLayoutItem;
    dxLayoutItem14: TdxLayoutItem;
    lbGroups: TcxListBox;
    dxLayoutGroup5: TdxLayoutGroup;
    btNewColumn: TcxButton;
    btDeleteColumn: TcxButton;
    btNewGroup: TcxButton;
    btDeleteGroup: TcxButton;
    dxLayoutItem15: TdxLayoutItem;
    dxLayoutItem16: TdxLayoutItem;
    dxLayoutGroup10: TdxLayoutGroup;
    dxLayoutItem17: TdxLayoutItem;
    dxLayoutItem18: TdxLayoutItem;
    alTextEditOperationWorkaround: TActionList;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EditSelectAll1: TEditSelectAll;
    EditUndo1: TEditUndo;
    EditDelete1: TEditDelete;
    tvItems: TdxTreeViewControl;
    dxLayoutItem19: TdxLayoutItem;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel;
    edItemCaption: TcxTextEdit;
    dxLayoutItem5: TdxLayoutItem;
    dxLayoutItem1: TdxLayoutItem;
    edImageIndex: TcxTextEdit;
    cbGroupID: TcxComboBox;
    dxLayoutItem20: TdxLayoutItem;
    procedure btNewItemClick(Sender: TObject);
    procedure btNewSubItemClick(Sender: TObject);
    procedure btDeleteItemClick(Sender: TObject);
    procedure btApplyItemsClick(Sender: TObject);
    procedure btHelpClick(Sender: TObject);
    procedure edItemCaptionExit(Sender: TObject);
    procedure edImageIndexExit(Sender: TObject);
    procedure edStateImageIndexExit(Sender: TObject);
    procedure tvItemsChanging(Sender: TObject; Node: TdxTreeViewNode; var AllowChange: Boolean);
    procedure tvItemsDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure tvItemsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvItemsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ValueChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure lbColumnsStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure lbColumnsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lbColumnsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lbColumnsEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure lbColumnsClick(Sender: TObject);
    procedure lbGroupsClick(Sender: TObject);
    procedure lbGroupsStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure lbGroupsEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure lbGroupsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lbGroupsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure btNewColumnClick(Sender: TObject);
    procedure btDeleteColumnClick(Sender: TObject);
    procedure btNewGroupClick(Sender: TObject);
    procedure btDeleteGroupClick(Sender: TObject);
    procedure tvItemsEdited(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode; var S: string);
    procedure tvItemsEditing(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode; var Allow: Boolean);
    procedure tvItemsFocusedNodeChanged(Sender: TObject);
    procedure tvItemsCanFocusNode(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode; var Allow: Boolean);
    procedure lgTabsTabChanging(Sender: TObject; ANewTabIndex: Integer; var Allow: Boolean);
    procedure lgTabsTabChanged(Sender: TObject);
    procedure lbGroupsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lbColumnsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edImageIndexPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure edStateImageIndexPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure cbGroupIDPropertiesEditValueChanged(Sender: TObject);
  private
    FColumnsPrevDragIndex: Integer;
    FGroupsPrevDragIndex: Integer;
    FDeleting: Boolean;
    FDropping: Boolean;
    FModifying: Boolean;
    function GetListView: TdxListViewControl;
    function CanFlushItemControls: Boolean;
    procedure FlushItemControls;
    procedure GetItem(AItemInfo: TdxItemInfo; AValue: TdxListItem);
    procedure ValidateItemsGroupID;
  protected
    function GetGroupDisplayName(AGroup: TdxListGroup): string;
    procedure InitFormEditor; override;
    procedure InitColumnsPage;
    procedure InitGroupsPage;
    procedure InitItemsPage;
    function IsListViewNode(ANode: TdxTreeViewNode): Boolean;
    procedure ReindexColumnsProc(AList: TList; ANewIndex: Integer);
    procedure ReindexGroupsProc(AList: TList; ANewIndex: Integer);
    procedure SetItem(AValue: TdxItemInfo);
    procedure SetStates;
    procedure SetSubItem(const S: string; AImageIndex: Integer);
    procedure UpdateCaption; override;
    procedure UpdateItemCaption;
    procedure UpdateItemGroups;
    procedure UpdateColumns;
    procedure UpdateGroups;
    procedure UpdateItems;
  public
    procedure DoItemsModified; override;
    procedure SelectionsChanged(const ASelection: TDesignerSelectionList); override;
    property ListView: TdxListViewControl read GetListView;
  end;

  TdxListViewEditorTab = (lvetItems, lvetColumns, lvetGroups);

function ShowListViewEditor(ADesigner: IDesigner; AListView: TComponent;
  ATab: TdxListViewEditorTab): TcxDesignFormEditor;

procedure AssignFromVCLListView(ASource: TListView; ADest: TdxListViewControl);

implementation

uses
  Math, CommCtrl, dxThreading, dxInplaceEditing, dxCustomTree, dxTypeHelpers;

const
  dxThisUnitName = 'dxListViewEditor';

const
  SItemEditNoGroupID = '-1 - (None)';
  SItemEditGroupIDStr = '%d - %s';

{$R *.dfm}

type
  TdxTreeViewHelper = class helper for TdxTreeViewControl
  public
    function GetEditingText: string;
  end;

  TdxListColumnHelper = class helper for TdxListColumn
  public
    function GetDisplayName: string;
  end;

var
  ActiveTab: TdxListViewEditorTab;

{ TdxTreeViewHelper }

function TdxTreeViewHelper.GetEditingText: string;
var
  AIntf: IdxInplaceEdit;
begin
  AIntf := InplaceEdit;
  if AIntf <> nil then
    Result := AIntf.Value
  else
    Result := '';
end;

{ TdxListColumnHelper }

function TdxListColumnHelper.GetDisplayName: string;
var
  AInfo: string;
begin
  Result := Caption;
  if Result = '' then
    Result := Name;
  if FSubItemIndex < 0 then
    AInfo := 'Item'
  else
    AInfo := Format('SubItem[%d]', [FSubItemIndex]);
  Result := Format('%s    -    %s', [Result, AInfo]);
end;

function ShowListViewEditor(ADesigner: IDesigner; AListView: TComponent;
  ATab: TdxListViewEditorTab): TcxDesignFormEditor;
begin
  ActiveTab := ATab;
  Result := ShowFormEditorClass(ADesigner, AListView, TfmListViewEditor);
end;

function ConvertGroupOptions(ASource: TListGroupStateSet): TdxListGroupOptions;
begin
  Result := [];
  if lgsHidden in ASource then
    Include(Result, TdxListGroupOption.Hidden);
  if lgsCollapsible in ASource then
    Include(Result, TdxListGroupOption.Collapsible);
  if lgsNoHeader in ASource then
    Include(Result, TdxListGroupOption.NoHeader);
end;

procedure AssignFromVCLListView(ASource: TListView; ADest: TdxListViewControl);
var
  I, J: Integer;
  ASourceItem: TListItem;
  ADestItem: TdxListItem;
  ASourceGroup: TListGroup;
  ADestGroup: TdxListGroup;
  ASourceColumn: TListColumn;
  ADestColumn: TdxListColumn;
begin
  ADest.BeginUpdate;
  try
    ADest.Items.Clear;
    ADest.Groups.Clear;
    ADest.Columns.Clear;
    ADest.Fonts.SetFont(ASource.Font, True);
    ADest.ImageOptions.GroupHeaderImages := ASource.GroupHeaderImages;
    ADest.ImageOptions.LargeImages := ASource.LargeImages;
    ADest.ImageOptions.SmallImages := ASource.SmallImages;
    ADest.ImageOptions.StateImages := ASource.StateImages;
    ADest.ImageOptions.ColumnHeaderImages := ASource.SmallImages; 
    case ASource.ViewStyle of
      vsIcon:
        ADest.ViewStyle := TdxListViewStyle.Icon;
      vsSmallIcon:
        ADest.ViewStyle := TdxListViewStyle.SmallIcon;
      vsList:
        ADest.ViewStyle := TdxListViewStyle.List;
      vsReport:
        ADest.ViewStyle := TdxListViewStyle.Report;
    end;
    for I := 0 to ASource.Columns.Count - 1 do
    begin
      ASourceColumn := ASource.Columns[I];
      ADestColumn := ADest.Columns.Add;
      ADestColumn.Alignment := ASourceColumn.Alignment;
      ADestColumn.Caption := ASourceColumn.Caption;
      ADestColumn.HeaderAlignment := ASourceColumn.Alignment;
      ADestColumn.ImageIndex := ASourceColumn.ImageIndex;
      ADestColumn.MinWidth := ASourceColumn.MinWidth;
      ADestColumn.MaxWidth := ASourceColumn.MaxWidth;
      if ASourceColumn.Width > 0 then
        ADestColumn.Width := ASourceColumn.Width;
    end;
    for I := 0 to ASource.Groups.Count - 1 do
    begin
      ASourceGroup := ASource.Groups[I];
      ADestGroup := ADest.Groups.Add;
      ADestGroup.Footer := ASourceGroup.Footer;
      ADestGroup.FooterAlign := ASourceGroup.FooterAlign;
      ADestGroup.Header := ASourceGroup.Header;
      ADestGroup.HeaderAlign := ASourceGroup.HeaderAlign;
      ADestGroup.TitleImage := ASourceGroup.TitleImage;
      ADestGroup.Subtitle := ASourceGroup.Subtitle;
      ADestGroup.Collapsed := lgsCollapsed in ASourceGroup.State;
      ADestGroup.Options := ConvertGroupOptions(ASourceGroup.State);
      ADestGroup.GroupID := ASourceGroup.GroupID;
    end;
    ADest.GroupView := ASource.GroupView;
    for I := 0 to ASource.Items.Count - 1 do
    begin
      ASourceItem := ASource.Items[I];
      ADestItem := ADest.Items.Add;
      ADestItem.Caption := ASourceItem.Caption;
      ADestItem.ImageIndex := ASourceItem.ImageIndex;
      ADestItem.StateIndex := ASourceItem.StateIndex;
      ADestItem.GroupID := ASourceItem.GroupID;
      ADestItem.SubItems.Assign(ASourceItem.SubItems);
      for J := 0 to ASourceItem.SubItems.Count - 1 do
        ADestItem.SubItemImages[J] := ASourceItem.SubItemImages[J];
    end;

    ADest.Hint := ASource.Hint;
    ADest.MultiSelect := ASource.MultiSelect;
    ADest.OwnerData := ASource.OwnerData;
    case ASource.IconOptions.Arrangement of
      iaTop:
        begin
          ADest.ViewStyleIcon.Arrangement := TdxListIconsArrangement.Horizontal;
          ADest.ViewStyleSmallIcon.Arrangement := TdxListIconsArrangement.Horizontal;
        end;
      iaLeft:
        begin
          ADest.ViewStyleIcon.Arrangement := TdxListIconsArrangement.Vertical;
          ADest.ViewStyleSmallIcon.Arrangement := TdxListIconsArrangement.Vertical;
        end;
    end;
    if not ASource.IconOptions.WrapText then
      ADest.ViewStyleIcon.TextLineCount := 1;
    ADest.ViewStyleReport.RowSelect := ASource.RowSelect;
    ADest.ViewStyleReport.ShowColumnHeaders := ASource.ShowColumnHeaders;
    case ASource.SortType of
      stNone: ADest.SortType := TdxListViewSortType.None;
      stData: ADest.SortType := TdxListViewSortType.Data;
      stText: ADest.SortType := TdxListViewSortType.Text;
      stBoth: ADest.SortType := TdxListViewSortType.Both;
    end;
    ADest.ExplorerStyle := False;
  finally
    ADest.EndUpdate;
  end;
end;

procedure ConvertError(AValue: TEdit);
begin
  with AValue do
  begin
    SetFocus;
    SelectAll;
  end;
end;

{ TdxItemInfo }

constructor TdxItemInfo.Create(AItem: TdxListItem);
var
  I: Integer;
begin
  inherited Create;
  FSubItems := TStringList.Create;
  FSubItemImages := TdxIntegerList.Create;
  FStateIndex := -1;
  FGroupID := -1;
  if AItem <> nil then
  begin
    FCaption := AItem.Caption;
    FImageIndex := AItem.ImageIndex;
    FStateIndex := AItem.StateIndex;
    FGroupID := AItem.GroupID;
    FSubItems.Assign(AItem.SubItems);
    for I := 0 to AItem.SubItems.Count - 1 do
      FSubItemImages.Add(AItem.SubItemImages[I]);
  end;
end;

destructor TdxItemInfo.Destroy;
begin
  FSubItems.Free;
  FSubItemImages.Free;
  inherited Destroy;
end;

procedure TdxItemInfo.AddSubItem(const ACaption: string; ANode: TdxTreeViewNode; AImageIndex: Integer);
begin
  FSubItems.AddObject(ACaption, ANode);
  FSubItemImages.Add(AImageIndex);
end;

procedure TdxItemInfo.DeleteSubItem(AIndex: Integer);
begin
  FSubItems.Delete(AIndex);
  FSubItemImages.Delete(AIndex);
end;

procedure TdxItemInfo.InsertSubItem(AIndex: Integer; const ACaption: string; ANode: TdxTreeViewNode; AImageIndex: Integer);
begin
  FSubItems.InsertObject(AIndex, ACaption, ANode);
  FSubItemImages.Insert(AIndex, AImageIndex);
end;

procedure TdxItemInfo.MoveTo(ASourceIndex, ADestIndex: Integer);
var
  ACaption: string;
  AImageIndex: Integer;
  ANode: Pointer;
begin
  ACaption := FSubItems[ASourceIndex];
  ANode := FSubItems.Objects[ASourceIndex];
  AImageIndex := FSubItemImages[ASourceIndex];
  DeleteSubItem(ASourceIndex);
  InsertSubItem(ADestIndex, ACaption, ANode, AImageIndex);
end;

{ TdxListViewItems }

procedure TfmListViewEditor.SetStates;
begin
  btDeleteItem.Enabled := tvItems.Root.Count > 0;
  grpItemProperties.Enabled := btDeleteItem.Enabled;
  btApply.Enabled := False;
  btNewSubItem.Enabled := tvItems.FocusedNode <> nil;
end;

procedure TfmListViewEditor.GetItem(AItemInfo: TdxItemInfo; AValue: TdxListItem);
var
  I: Integer;
begin
  AValue.Caption := AItemInfo.Caption;
  AValue.ImageIndex := AItemInfo.ImageIndex;
  AValue.StateIndex := AItemInfo.StateIndex;
  AValue.GroupID := AItemInfo.GroupID;
  AValue.SubItems.Assign(AItemInfo.SubItems);
  for I := 0 to AItemInfo.SubItems.Count - 1 do
    AValue.SubItemImages[I] := AItemInfo.SubItemImages[I];
end;

function TfmListViewEditor.GetListView: TdxListViewControl;
begin
  Result := TdxListViewControl(Component);
end;

function TfmListViewEditor.GetGroupDisplayName(AGroup: TdxListGroup): string;
begin
  Result := AGroup.Header;
  if Result = '' then
    Result := AGroup.Name;
end;

procedure TfmListViewEditor.InitFormEditor;
begin
  inherited InitFormEditor;
  InitItemsPage;
  InitColumnsPage;
  InitGroupsPage;
  lgTabs.ItemIndex := Ord(ActiveTab);
end;

procedure TfmListViewEditor.InitColumnsPage;
begin
  FColumnsPrevDragIndex := -1;
  UpdateColumns;
end;

procedure TfmListViewEditor.InitGroupsPage;
begin
  FGroupsPrevDragIndex := -1;
  UpdateGroups;
end;

procedure TfmListViewEditor.InitItemsPage;
begin
  UpdateItems;
  SetStates;
end;

function TfmListViewEditor.IsListViewNode(ANode: TdxTreeViewNode): Boolean;
begin
  Result := (ANode <> nil) and not ANode.IsRoot;
end;

procedure TfmListViewEditor.UpdateColumns;
var
  I, AItemIndex, ATopIndex: Integer;
  ASelection: TStringList;
  AColumn: TdxListColumn;
begin
  lbColumns.Items.BeginUpdate;
  try
    ListBoxSaveSelection(lbColumns.InnerListBox, ASelection, AItemIndex, ATopIndex);
    try
      lbColumns.Items.Clear;
      for I := 0 to ListView.Columns.Count - 1 do
      begin
        AColumn := ListView.Columns[I];
        lbColumns.Items.AddObject(AColumn.GetDisplayName, AColumn);
      end;
    finally
      ListBoxRestoreSelection(lbColumns.InnerListBox, ASelection, FColumnsPrevDragIndex, ATopIndex);
    end;
  finally
    lbColumns.Items.EndUpdate;
  end;
end;

procedure TfmListViewEditor.UpdateGroups;
var
  I, AItemIndex, ATopIndex: Integer;
  ASelection: TStringList;
  AGroup: TdxListGroup;
begin
  lbGroups.Items.BeginUpdate;
  try
    ListBoxSaveSelection(lbGroups.InnerListBox, ASelection, AItemIndex, ATopIndex);
    try
      lbGroups.Items.Clear;
      for I := 0 to ListView.Groups.Count - 1 do
      begin
        AGroup := ListView.Groups[I];
        lbGroups.Items.AddObject(GetGroupDisplayName(AGroup), AGroup);
      end;
    finally
      ListBoxRestoreSelection(lbGroups.InnerListBox, ASelection, FGroupsPrevDragIndex, ATopIndex);
    end;
  finally
    lbGroups.Items.EndUpdate;
  end;
  UpdateItemGroups;
end;

procedure TfmListViewEditor.UpdateItemGroups;
var
  I: Integer;
begin
  cbGroupID.Properties.Items.BeginUpdate;
  try
    cbGroupID.Properties.Items.Clear;
    cbGroupID.Properties.Items.AddObject(SItemEditNoGroupID, nil);
    for I := 0 to ListView.Groups.Count - 1 do
      cbGroupID.Properties.Items.AddObject(Format(SItemEditGroupIDStr, [ListView.Groups[I].GroupID, GetGroupDisplayName(ListView.Groups[I])]), ListView.Groups[I]);
  finally
    cbGroupID.Properties.Items.EndUpdate;
  end;
  if tvItems.Root.Count > 0 then
  begin
    tvItems.FocusedNode := tvItems.Root.First;
    tvItemsFocusedNodeChanged(nil);
  end;
end;

procedure TfmListViewEditor.UpdateItems;
var
  I, J: Integer;
  ANode: TdxTreeViewNode;
  AItemInfo: TdxItemInfo;
begin
  tvItems.BeginUpdate;
  try
    tvItems.Root.Clear;
    for I := 0 to ListView.Items.Count - 1 do
    begin
      AItemInfo := TdxItemInfo.Create(ListView.Items[I]);
      ANode := tvItems.Root.AddChild(AItemInfo.Caption, AItemInfo);
      for J := 0 to AItemInfo.SubItems.Count - 1 do
        AItemInfo.SubItems.Objects[J] := ANode.AddChild(AItemInfo.SubItems[J]);
    end;
  finally
    tvItems.EndUpdate;
  end;
  UpdateItemGroups;
end;

procedure TfmListViewEditor.ReindexColumnsProc(AList: TList; ANewIndex: Integer);
var
  I: Integer;
begin
  if AList.Count = 0 then Exit;
  if TdxListColumn(AList[0]).Index < ANewIndex then
  begin
    for I := 0 to AList.Count - 1 do
      TdxListColumn(AList[I]).Index := ANewIndex;
  end
  else
  begin
    for I := AList.Count - 1 downto 0 do
      TdxListColumn(AList[I]).Index := ANewIndex;
  end;
  Designer.Modified;
end;

procedure TfmListViewEditor.lbColumnsClick(Sender: TObject);
begin
  ListBoxApplySelection(lbColumns.InnerListBox, ListView);
  ListView.Invalidate;
end;

procedure TfmListViewEditor.lbColumnsDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  ListBoxDragDrop(lbColumns.InnerListBox, Sender, Source, X, Y, FColumnsPrevDragIndex, ReindexColumnsProc);
end;

procedure TfmListViewEditor.lbColumnsDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  ListBoxDragOver(lbColumns.InnerListBox, Sender, Source, X, Y, State, Accept, FColumnsPrevDragIndex);
end;

procedure TfmListViewEditor.lbColumnsEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  UpdateColumns;
  ListBoxEndDrag(lbColumns.InnerListBox, Sender, Target, X, Y, FColumnsPrevDragIndex);
end;

procedure TfmListViewEditor.lbColumnsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) and (lbColumns.SelCount > 0) then
  begin
    btDeleteColumnClick(nil);
    Key := 0;
  end;
end;

procedure TfmListViewEditor.lbColumnsStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  FColumnsPrevDragIndex := -1;
end;

procedure TfmListViewEditor.ReindexGroupsProc(AList: TList; ANewIndex: Integer);
var
  I: Integer;
begin
  if AList.Count = 0 then Exit;
  if TdxListColumn(AList[0]).Index < ANewIndex then
  begin
    for I := 0 to AList.Count - 1 do
      TdxListGroup(AList[I]).Index := ANewIndex;
  end
  else
  begin
    for I := AList.Count - 1 downto 0 do
      TdxListGroup(AList[I]).Index := ANewIndex;
  end;
  Designer.Modified;
end;

procedure TfmListViewEditor.lbGroupsClick(Sender: TObject);
begin
  ListBoxApplySelection(lbGroups.InnerListBox, ListView);
  ListView.Invalidate;
end;

procedure TfmListViewEditor.lbGroupsDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  ListBoxDragDrop(lbGroups.InnerListBox, Sender, Source, X, Y, FGroupsPrevDragIndex, ReindexGroupsProc);
end;

procedure TfmListViewEditor.lbGroupsDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  ListBoxDragOver(lbGroups.InnerListBox, Sender, Source, X, Y, State, Accept, FGroupsPrevDragIndex);
end;

procedure TfmListViewEditor.lbGroupsEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  UpdateGroups;
  ListBoxEndDrag(lbGroups.InnerListBox, Sender, Target, X, Y, FGroupsPrevDragIndex);
end;

procedure TfmListViewEditor.lbGroupsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) and (lbGroups.SelCount > 0) then
  begin
    btDeleteGroupClick(nil);
    Key := 0;
  end;
end;

procedure TfmListViewEditor.lbGroupsStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  FGroupsPrevDragIndex := -1;
end;

procedure TfmListViewEditor.lgTabsTabChanged(Sender: TObject);
begin
  UpdateItemGroups;
end;

procedure TfmListViewEditor.lgTabsTabChanging(Sender: TObject;
  ANewTabIndex: Integer; var Allow: Boolean);
begin
  if ANewTabIndex <> 0 then
    FlushItemControls;
end;

procedure TfmListViewEditor.SelectionsChanged(const ASelection: TDesignerSelectionList);
begin
  ListBoxSynchronizeSelection(lbColumns.InnerListBox);
  ListBoxSynchronizeSelection(lbGroups.InnerListBox);
  btDeleteColumn.Enabled := lbColumns.SelCount > 0;
  btDeleteGroup.Enabled := lbGroups.SelCount > 0;
end;

procedure TfmListViewEditor.SetItem(AValue: TdxItemInfo);
var
  I: Integer;
begin
  edImageIndex.Enabled := True;
  edStateImageIndex.Enabled := True;
  cbGroupID.Enabled := True;
  if AValue <> nil then
  begin
    edItemCaption.Text := AValue.Caption;
    edImageIndex.Text := IntToStr(AValue.ImageIndex);
    edStateImageIndex.Text := IntToStr(AValue.StateIndex);

    if AValue.GroupID < 0 then
      cbGroupID.ItemIndex := 0
    else
    begin
      for I := 1 to cbGroupID.Properties.Items.Count - 1 do
      begin
        if TdxListGroup(cbGroupID.Properties.Items.Objects[I]).GroupID = AValue.GroupID then
        begin
          cbGroupID.ItemIndex := I;
          Exit;
        end;
      end;
      cbGroupID.ItemIndex := 0;
    end;
  end
  else
  begin
    edItemCaption.Text := '';
    edImageIndex.Text := '';
    edStateImageIndex.Text := '';
    cbGroupID.ItemIndex := -1;
  end;
end;

procedure TfmListViewEditor.SetSubItem(const S: string; AImageIndex: Integer);
begin
  edStateImageIndex.Enabled := False;
  cbGroupID.Enabled := False;
  edImageIndex.Text := IntToStr(AImageIndex);
  edItemCaption.Text := S;
end;

function TfmListViewEditor.CanFlushItemControls: Boolean;
begin
  Result := not (FDeleting or FDropping);
end;

procedure TfmListViewEditor.FlushItemControls;
begin
  if not CanFlushItemControls then
    Exit;
  edItemCaptionExit(nil);
  edImageIndexExit(nil);
  edStateImageIndexExit(nil);
end;

procedure TfmListViewEditor.tvItemsCanFocusNode(Sender: TdxCustomTreeView;
  ANode: TdxTreeViewNode; var Allow: Boolean);
begin
  FlushItemControls;
end;

procedure TfmListViewEditor.tvItemsChanging(Sender: TObject; Node: TdxTreeViewNode;
  var AllowChange: Boolean);
begin
  FlushItemControls;
end;

procedure TfmListViewEditor.btNewColumnClick(Sender: TObject);
var
  AColumn: TdxListColumn;
begin
  AColumn := ListView.Columns.Add;
  UpdateColumns;
  SelectComponent(AColumn);
end;

procedure TfmListViewEditor.btNewGroupClick(Sender: TObject);
var
  AGroup: TdxListGroup;
begin
  AGroup := ListView.Groups.Add;
  UpdateGroups;
  SelectComponent(AGroup);
end;

procedure TfmListViewEditor.btNewItemClick(Sender: TObject);
var
  ANode: TdxTreeViewNode;
begin
  ANode := tvItems.Root.AddChild('', TdxItemInfo.Create(nil));
  ANode.MakeVisible;
  ANode.Focused := True;
  edItemCaption.SetFocus;
  btApply.Enabled := True;
end;

procedure TfmListViewEditor.btNewSubItemClick(Sender: TObject);
var
  ANode, ANewNode: TdxTreeViewNode;
begin
  ANode := tvItems.FocusedNode;
  if IsListViewNode(ANode) then
  begin
    if ANode.Data <> nil then // on the Item
    begin
      ANewNode := ANode.AddChild('');
      TdxItemInfo(ANode.Data).AddSubItem('', ANewNode, -1);
    end
    else
    begin 
      ANewNode := ANode.Parent.AddChild('');
      TdxItemInfo(ANode.Parent.Data).AddSubItem('', ANewNode, -1);
    end;
    ANewNode.MakeVisible;
    tvItems.FocusedNode := ANewNode;
  end;
  edItemCaption.SetFocus;
  btApply.Enabled := True;
end;

procedure TfmListViewEditor.btDeleteItemClick(Sender: TObject);
var
  ANode: TdxTreeViewNode;
  AIndex: Integer;
begin
  ANode := tvItems.FocusedNode;
  if IsListViewNode(ANode) then
  begin
    FDeleting := True;
    try
      if ANode.Data = nil then
      begin
        AIndex := TdxItemInfo(ANode.Parent.Data).SubItems.IndexOfObject(ANode);
        TdxItemInfo(ANode.Parent.Data).DeleteSubItem(AIndex);
      end
      else
        TdxItemInfo(ANode.Data).Free;
      ANode.Free;
    finally
      FDeleting := False;
    end;
  end;
  if tvItems.Root.Count = 0 then
    SetItem(nil);
  SetStates;
  btApply.Enabled := True;
end;

procedure TfmListViewEditor.tvItemsFocusedNodeChanged(Sender: TObject);
var
  ATempEnabled: Boolean;
  AItemInfoSubs: TStrings;
  AIndex: Integer;
  ANode: TdxTreeViewNode;
begin
  ATempEnabled := btApply.Enabled;
  ANode := tvItems.FocusedNode;
  if IsListViewNode(ANode) then
  begin
    SetStates;
    if ANode.Data <> nil then
      SetItem(TdxItemInfo(ANode.Data))
    else
    begin
      AItemInfoSubs := TdxItemInfo(ANode.Parent.Data).SubItems;
      AIndex := AItemInfoSubs.IndexOfObject(ANode);
      SetSubItem(AItemInfoSubs[AIndex], TdxItemInfo(ANode.Parent.Data).SubItemImages[AIndex]);
    end;
  end
  else
    SetItem(nil);
  btApply.Enabled := ATempEnabled;
end;

procedure TfmListViewEditor.btOkClick(Sender: TObject);
begin
  btApplyItemsClick(nil);
  Close;
end;

procedure TfmListViewEditor.btCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmListViewEditor.btDeleteColumnClick(Sender: TObject);
begin
  ListBoxDeleteSelection(lbColumns.InnerListBox, True);
  if InRange(lbColumns.ItemIndex, 0, lbColumns.Count - 1) then
    SelectComponent(TPersistent(lbColumns.Items.Objects[lbColumns.ItemIndex]));
end;

procedure TfmListViewEditor.ValidateItemsGroupID;
var
  I, J, AGroupID: Integer;
  AFound: Boolean;
  AInfo: TdxItemInfo;
begin
  for I := 0 to tvItems.Root.Count - 1 do
  begin
    AInfo := TdxItemInfo(tvItems.Root[I].Data);
    AGroupID := AInfo.GroupID;
    AFound := False;
    for J := 0 to ListView.Groups.Count - 1 do
    begin
      if ListView.Groups[J].GroupID = AGroupID then
      begin
        AFound := True;
        Break;
      end;
    end;
    if not AFound then
      AInfo.GroupID := -1;
  end;
end;

procedure TfmListViewEditor.btDeleteGroupClick(Sender: TObject);
begin
  ListBoxDeleteSelection(lbGroups.InnerListBox, True);
  if InRange(lbGroups.ItemIndex, 0, lbGroups.Count - 1) then
    SelectComponent(TPersistent(lbGroups.Items.Objects[lbGroups.ItemIndex]));
  ValidateItemsGroupID;
end;

procedure TfmListViewEditor.ValueChange(Sender: TObject);
begin
  if FModifying then
    Exit;
  btApply.Enabled := True;
  if Sender = edItemCaption then
    edItemCaptionExit(Sender);
end;

procedure TfmListViewEditor.edItemCaptionExit(Sender: TObject);
var
  ANode: TdxTreeViewNode;
  AItemInfoSubs: TStrings;
  AIndex: Integer;
begin
  ANode := tvItems.FocusedNode;
  if IsListViewNode(ANode) then
  begin
    if ANode.Data = nil then
    begin
      AItemInfoSubs := TdxItemInfo(ANode.Parent.Data).SubItems;
      AIndex := AItemInfoSubs.IndexOfObject(ANode);
      AItemInfoSubs[AIndex] := edItemCaption.Text;
    end
    else
      TdxItemInfo(ANode.Data).Caption := edItemCaption.Text;
    ANode.Caption := edItemCaption.Text;
  end;
end;

procedure TfmListViewEditor.cbGroupIDPropertiesEditValueChanged(Sender: TObject);
var
  ANode: TdxTreeViewNode;
  AIndex: Integer;
begin
  if FModifying then
    Exit;
  ValueChange(Sender);

  ANode := tvItems.FocusedNode;
  if IsListViewNode(ANode) then
  begin
    AIndex := cbGroupID.ItemIndex;
    if InRange(AIndex, 1, cbGroupID.Properties.Items.Count - 1) then
      TdxItemInfo(ANode.Data).GroupID := TdxListGroup(cbGroupID.Properties.Items.Objects[AIndex]).GroupID
    else
      TdxItemInfo(ANode.Data).GroupID := -1;
  end;
end;

procedure TfmListViewEditor.DoItemsModified;
begin
  FModifying := True;
  try
    inherited DoItemsModified;
    UpdateColumns;
    UpdateGroups;
  finally
    FModifying := False;
  end;
end;

procedure TfmListViewEditor.tvItemsEdited(Sender: TdxCustomTreeView;
  ANode: TdxTreeViewNode; var S: string);
begin
  edItemCaption.Text := S;
  edItemCaptionExit(nil);
  btNewItem.Default := True;
end;

procedure TfmListViewEditor.tvItemsEditing(Sender: TdxCustomTreeView;
  ANode: TdxTreeViewNode; var Allow: Boolean);
begin
  btNewItem.Default := False;
end;

procedure TfmListViewEditor.edImageIndexExit(Sender: TObject);
var
  ANode: TdxTreeViewNode;
  AIndex, AValue: Integer;
begin
  if (ActiveControl <> btCancel) and TryStrToInt(edImageIndex.Text, AValue) then
  begin
    ANode := tvItems.FocusedNode;
    if IsListViewNode(ANode) then
    begin
      if ANode.Data <> nil then
        TdxItemInfo(ANode.Data).ImageIndex := AValue
      else
      begin
        AIndex := TdxItemInfo(ANode.Parent.Data).SubItems.IndexOfObject(ANode);
        TdxItemInfo(ANode.Parent.Data).SubItemImages[AIndex] := AValue;
      end;
    end;
  end;
end;

procedure TfmListViewEditor.edImageIndexPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  AValue: Integer;
begin
  if ActiveControl = btCancel then
    Error := False
  else
    Error := not TryStrToInt(DisplayValue, AValue);
end;

procedure TfmListViewEditor.edStateImageIndexExit(Sender: TObject);
var
  ANode: TdxTreeViewNode;
  AValue: Integer;
begin
  if (ActiveControl <> btCancel) and TryStrToInt(edStateImageIndex.Text, AValue) then
  begin
    ANode := tvItems.FocusedNode;
    if IsListViewNode(ANode) and (ANode.Data <> nil) then
      TdxItemInfo(ANode.Data).StateIndex := AValue;
  end;
end;

procedure TfmListViewEditor.edStateImageIndexPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  AValue: Integer;
begin
  if ActiveControl = btCancel then
    Error := False
  else
    Error := not TryStrToInt(DisplayValue, AValue);
end;

procedure TfmListViewEditor.btApplyItemsClick(Sender: TObject);
var
  ANode: TdxTreeViewNode;
  AListItem: TdxListItem;
  I: Integer;
begin
  FlushItemControls;
  ListView.Items.BeginUpdate;
  try
    ListView.Items.Clear;
    for I := 0 to tvItems.Root.Count - 1 do
    begin
      ANode := tvItems.Root[I];
      AListItem := ListView.Items.Add;
      GetItem(TdxItemInfo(ANode.Data), AListItem);
    end;
  finally
    ListView.Items.EndUpdate;
  end;
  btApply.Enabled := False;
  Designer.Modified;
end;

procedure TfmListViewEditor.tvItemsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  ANode, AFocusedNode: TdxTreeViewNode;
  AChild: Boolean;
begin
  AChild := GetKeyState(VK_SHIFT) < 0;
  AFocusedNode := tvItems.FocusedNode;
  if not tvItems.GetNodeAtPos(TPoint.Create(X, Y), ANode) then
    ANode := tvItems.DropTarget;
  if ANode = nil then
    Accept := False
  else
    Accept := (AFocusedNode <> ANode) and not (AChild and AFocusedNode.HasAsParent(ANode))
      and not ANode.HasAsParent(AFocusedNode)
      and not (AFocusedNode.HasChildren and (ANode.Data = nil))
      and not (AChild and (ANode.Data <> nil) and AFocusedNode.HasChildren);
end;

procedure TfmListViewEditor.tvItemsDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  ANode, AFocusedNode: TdxTreeViewNode;
  AChild: Boolean;

  procedure MoveNode(ASource, ADest: TdxTreeViewNode);
  begin
    if ADest.Index = ADest.Parent.Count - 1 then
      ASource.MoveTo(ADest, namAdd)
    else
      ASource.MoveTo(ADest, namInsert);
  end;

  procedure AddItem(ASource, ADest: TdxTreeViewNode);
  var
    AInfo: TdxItemInfo;
    AIndex, AImageIndex: Integer;
  begin
    if (ASource.Data = nil) and (ADest.Data = nil) then
    begin
      AInfo := TdxItemInfo(ASource.Parent.Data);
      AImageIndex := AInfo.ImageIndex;
      AIndex := AInfo.SubItems.IndexOfObject(ASource);
      AInfo.DeleteSubItem(AIndex);
      MoveNode(ASource, ADest);
      TdxItemInfo(ADest.Parent.Data).InsertSubItem(ASource.Index, ASource.Caption, ASource, AImageIndex);
    end
    else if (ASource.Data <> nil) and (ADest.Data <> nil) then
    begin
      if not AChild then
        MoveNode(ASource, ADest)
      else
      begin
        AInfo := TdxItemInfo(ASource.Data);
        AImageIndex := AInfo.ImageIndex;
        AInfo.Free;
        ASource.Data := nil;
        MoveNode(ASource, ADest);
        TdxItemInfo(ADest.Data).InsertSubItem(ASource.Index, ASource.Caption, ASource, AImageIndex);
      end;
    end
    else if (ASource.Data <> nil) and (ADest.Data = nil) then
    begin
      AInfo := TdxItemInfo(ASource.Data);
      AImageIndex := AInfo.ImageIndex;
      AInfo.Free;
      ASource.Data := nil;
      MoveNode(ASource, ADest);
      TdxItemInfo(ADest.Parent.Data).InsertSubItem(ASource.Index, ASource.Caption, ASource, AImageIndex);
    end
    else if (ASource.Data = nil) and (ADest.Data <> nil) then
    begin
      AInfo := TdxItemInfo(ASource.Parent.Data);
      AImageIndex := AInfo.ImageIndex;
      AIndex := AInfo.SubItems.IndexOfObject(ASource);
      AInfo.DeleteSubItem(AIndex);
      if AChild then
      begin
        ASource.MoveTo(ADest, namAddChild);
        TdxItemInfo(ADest.Data).InsertSubItem(ASource.Index, ASource.Caption, ASource, AImageIndex);
      end
      else
      begin
        ASource.MoveTo(ADest, namInsert);
        ASource.Data := TdxItemInfo.Create(nil);
      end;
    end;
  end;

begin
  AFocusedNode := tvItems.FocusedNode;
  if IsListViewNode(AFocusedNode) then
  begin
    AChild := GetKeyState(VK_SHIFT) < 0;
    if not tvItems.GetNodeAtPos(TPoint.Create(X, Y), ANode) then
    begin
      ANode := tvItems.Root.Last;
      while (not ANode.IsRoot) and not ANode.IsVisible do
        ANode := ANode.GetPrev;
    end;
    if IsListViewNode(ANode) then
    try
      if AChild and (ANode.Parent <> nil) then ANode := ANode.Parent;
      FDropping := True;
      AddItem(AFocusedNode, ANode);
        AFocusedNode.Focused := True;
      btApply.Enabled := True;
    finally
      FDropping := False;
    end;
  end;
end;

procedure TfmListViewEditor.btHelpClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

procedure TfmListViewEditor.tvItemsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) and btDeleteItem.Enabled then
  begin
    btDeleteItemClick(nil);
    Key := 0;
  end;
  TdxUIThreadSyncService.EnqueueInvokeInUIThread(Self, UpdateItemCaption);
end;

procedure TfmListViewEditor.UpdateCaption;
var
  S: string;
begin
  if (Component <> nil) and (Component.Name <> '') then
  begin
    S := Component.Name;
    if Component.Owner <> nil then
      S := Component.Owner.Name + '.' + S;
    Caption := S + ' - Editor';
  end;
end;

procedure TfmListViewEditor.UpdateItemCaption;
var
  AItemInfoSubs: TStrings;
  AEditNode: TdxTreeViewNode;
  AValue: string;
begin
  if tvItems.IsEditing then
  begin
    AValue := tvItems.GetEditingText;
    AEditNode := tvItems.FocusedNode;
    if AEditNode.Data = nil then
    begin
      AItemInfoSubs := TdxItemInfo(AEditNode.Parent.Data).SubItems;
      AItemInfoSubs[AItemInfoSubs.IndexOfObject(AEditNode)] := AValue;
    end
    else
      TdxItemInfo(AEditNode.Data).Caption := AValue;
    edItemCaption.Text := AValue;
  end;
end;

procedure TfmListViewEditor.FormDestroy(Sender: TObject);
begin
  TdxUIThreadSyncService.Unsubscribe(Self);
end;

end.

