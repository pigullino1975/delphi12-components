{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressBars Customization Form                           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSBARS AND ALL ACCOMPANYING VCL  }
{   CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY.                  }
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

unit dxBarCustForm;

{$I cxVer.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ComCtrls, ExtCtrls, Menus,
  Buttons, cxClasses, dxBar, ActnList, ToolWin, ImgList, Contnrs, dxBarCustomCustomizationForm, dxSkinsCore, cxButtons,
  cxControls, cxContainer, cxEdit, cxLabel, cxCheckBox, cxGroupBox, cxGraphics, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxListBox, cxPC, cxCheckListBox, cxLookAndFeels, cxLookAndFeelPainters, dxLayoutContainer, dxLayoutControl,
  dxLayoutControlAdapters, dxLayoutLookAndFeels, dxLayoutcxEditAdapters, cxImageList, cxCustomListBox;

type
  TdxBarPermissiveProc = function (Sender: TComponent): Boolean of object;

  TdxBarCustomizationForm = class(TdxBarCustomCustomizationForm)
    BBarDelete: TcxButton;
    BBarNew: TcxButton;
    BBarRename: TcxButton;
    BBarReset: TcxButton;
    BClose: TcxButton;
    BHelp: TcxButton;
    BResetUsageData: TcxButton;
    btnAddGroup: TcxButton;
    btnAddGroupItem: TcxButton;
    btnDeleteGroup: TcxButton;
    btnDeleteGroupItem: TcxButton;
    btnMoveGroupDown: TcxButton;
    btnMoveGroupItemDown: TcxButton;
    btnMoveGroupItemUp: TcxButton;
    btnMoveGroupUp: TcxButton;
    CategoriesPopupButtonPlace: TcxButton;
    ComboBoxMenuAnimations: TcxComboBox;
    ComboBoxMenuAnimationsEx: TcxComboBox;
    CommandsPopupButtonPlace: TcxButton;
    DescriptionLabel: TdxLayoutLabeledItem;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup;
    dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup;
    dxLayoutEmptySpaceItem1: TdxLayoutEmptySpaceItem;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutGroup2: TdxLayoutGroup;
    dxLayoutGroup3: TdxLayoutGroup;
    dxLayoutGroup4: TdxLayoutGroup;
    dxLayoutGroup5: TdxLayoutGroup;
    dxLayoutGroup6: TdxLayoutGroup;
    dxLayoutGroup7: TdxLayoutGroup;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutItem11: TdxLayoutItem;
    dxLayoutItem12: TdxLayoutItem;
    dxLayoutItem19: TdxLayoutItem;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutItem20: TdxLayoutItem;
    dxLayoutItem22: TdxLayoutItem;
    dxLayoutItem23: TdxLayoutItem;
    dxLayoutItem24: TdxLayoutItem;
    dxLayoutItem25: TdxLayoutItem;
    dxLayoutItem26: TdxLayoutItem;
    dxLayoutItem27: TdxLayoutItem;
    dxLayoutItem28: TdxLayoutItem;
    dxLayoutItem29: TdxLayoutItem;
    dxLayoutItem3: TdxLayoutItem;
    dxLayoutItem30: TdxLayoutItem;
    dxLayoutItem31: TdxLayoutItem;
    dxLayoutItem4: TdxLayoutItem;
    dxLayoutItem5: TdxLayoutItem;
    dxLayoutItem6: TdxLayoutItem;
    dxLayoutItem7: TdxLayoutItem;
    dxLayoutItem8: TdxLayoutItem;
    dxLayoutSeparatorItem1: TdxLayoutSeparatorItem;
    dxLayoutSeparatorItem2: TdxLayoutSeparatorItem;
    EnhancedOptionsPanel: TdxLayoutGroup;
    Label1: TdxLayoutItem;
    Label2: TcxLabel;
    Label3: TcxLabel;
    LabelCategories: TdxLayoutItem;
    LabelCommands: TdxLayoutItem;
    LabelDescription: TcxLabel;
    LabelMenuAnimations: TdxLayoutItem;
    LabelToolbars: TdxLayoutItem;
    LAllCommands: TcxListBox;
    lbBarsList: TcxListBox;
    lbCategories: TcxListBox;
    lbGroups: TcxListBox;
    lbGroupsItems: TcxListBox;
    lbItems: TcxListBox;
    lcMain: TdxLayoutControl;
    lcMainGroup_Root: TdxLayoutGroup;
    lcMainLookAndFeel: TdxLayoutCxLookAndFeel;
    lcMainLookAndFeelList: TdxLayoutLookAndFeelList;
    liBBarReset: TdxLayoutItem;
    liBHelp: TdxLayoutItem;
    PageControl: TdxLayoutGroup;
    StandardOptionsPanel: TdxLayoutGroup;
    tsCommands: TdxLayoutGroup;
    tsGroups: TdxLayoutGroup;
    tsItems: TdxLayoutGroup;
    tsOptions: TdxLayoutGroup;
    tsToolbars: TdxLayoutGroup;
    tvKeyTips: TTreeView;
    CBMenusShowRecentItemsFirst: TdxLayoutCheckBoxItem;
    CBShowFullMenusAfterDelay: TdxLayoutCheckBoxItem;
    CBLargeIconsEx: TdxLayoutCheckBoxItem;
    CBHint1Ex: TdxLayoutCheckBoxItem;
    CBHint2Ex: TdxLayoutCheckBoxItem;
    CBLargeIcons: TdxLayoutCheckBoxItem;
    CBHint1: TdxLayoutCheckBoxItem;
    CBHint2: TdxLayoutCheckBoxItem;
    CBShowCommandsWithShortCut: TdxLayoutCheckBoxItem;
    dxLayoutSeparatorItem3: TdxLayoutSeparatorItem;
    dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup;
    dxLayoutSeparatorItem4: TdxLayoutSeparatorItem;
    dxLayoutAutoCreatedGroup5: TdxLayoutAutoCreatedGroup;

    function GetIsSkinUsed: Boolean;
    procedure BCloseClick(Sender: TObject);
    procedure BHelpClick(Sender: TObject);
    procedure BResetUsageDataClick(Sender: TObject);
    procedure CBHint1Click(Sender: TObject);
    procedure CBHint1ExClick(Sender: TObject);
    procedure CBHint2Click(Sender: TObject);
    procedure CBLargeIconsClick(Sender: TObject);
    procedure CBMenusShowRecentItemsFirstClick(Sender: TObject);
    procedure CBShowCommandsWithShortCutClick(Sender: TObject);
    procedure CBShowFullMenusAfterDelayClick(Sender: TObject);
    procedure ComboBoxMenuAnimationsClick(Sender: TObject);
    procedure lbItemsDrawItem(AControl: TcxListBox; ACanvas: TcxCanvas; AIndex: Integer; ARect: TRect; AState: TOwnerDrawState);
  private
    FLookAndFeel: TcxLookAndFeel;

    procedure OnItemLinksChanged(Sender: TObject);
  protected
    procedure WndProc(var Message: TMessage); override;

    function GetAllCommandsListBox: TcxListBox; override;
    function GetBarItemsBackgroundColor: TColor; override;
    function GetBarListBox: TcxListBox; override;
    function GetCategoriesList: TcxListBox; override;
    function GetGroupItemsListBox: TcxListBox; override;
    function GetGroupsListBox: TcxListBox; override;
    function GetItemsListBox: TcxListBox; override;
    function GetPainterClass: TdxBarCustomizationFormPainterClass; override;
    function GetShowCommandsWithShortCut: Boolean; override;
    procedure PrepareControls; override;
    procedure SynchronizeListBoxes; override;
    procedure UpdateItemDescription(const AText: string); override;

    property IsSkinUsed: Boolean read GetIsSkinUsed;
    property LookAndFeel: TcxLookAndFeel read FLookAndFeel;
  public
    constructor CreateEx(ABarManager: TdxBarManager); override;
    destructor Destroy; override;
    procedure BarManagerStyleChanged; override;
    procedure DesignSelectionChanged(Sender: TObject); override;
    procedure SelectPage(APageIndex: Integer); override;
    procedure SwitchToItemsPage; override;
    procedure UpdateHelpButton; override;
    procedure UpdateOptions; override;
  end;

implementation

{$R *.DFM}

uses
  Types, dxBarNameEd, dxBarPopupMenuEd, dxBarItemEd, dxBarStrs, dxBarAddGroupItemsEd, TypInfo, dxUxTheme,
  dxThemeManager, dxThemeConsts, dxOffice11, dxSkinInfo, Math, cxGeometry, dxCore, dxCoreGraphics,
  dxDPIAwareUtils, cxAccessibility;

const
  dxThisUnitName = 'dxBarCustForm';

const
  dxBarButtonHeight = 24;

type
  TdxBarAccess = class(TdxBar);
  TdxBarItemAccess = class(TdxBarItem);
  TdxBarManagerAccess = class(TdxBarManager);
  TcxControlAccess = class(TcxControl);
  TcxListBoxAccess = class(TcxListBox);
  
  { TdxBarCustomizationFormSkinPainter }

  TdxBarCustomizationFormSkinPainter = class(TdxBarCustomizationFormPainter)
  private
    class function GetLookAndFeelPainter: TcxCustomLookAndFeelPainter;
    class function GetPopupMenuElement: TdxSkinElement;
    class function GetPopupMenuLinkDropButtonElement: TdxSkinElement;
    class function GetPopupMenuLinkSelectedElement(AIsDropDown: Boolean): TdxSkinElement;
    class function GetSideStripElement: TdxSkinElement;
    class function GetSkinElementColor(AElement: TdxSkinElement; ATextColor: Boolean): TColor;
    class function GetSkinInfo(var ASkinInfo: TdxSkinInfo): Boolean;
  protected
    class procedure DrawSkinElement(ACanvas: TCanvas; const R: TRect; AElement: TdxSkinElement; AIsRightToLeft: Boolean = False);
    class procedure DrawSkinElementContent(ACanvas: TCanvas; R: TRect; AElement: TdxSkinElement);

    class procedure DrawButtonOrSubItemArrowBackground(ACanvas: TCanvas; R: TRect; AItem: TdxBarItem; Selected: Boolean); override;
    class procedure DrawButtonOrSubItemBackground(ACanvas: TCanvas; AItem: TdxBarItem;
      const ABounds, ASideStripRect, AArrowRect: TRect; ASelected: Boolean); override;
    class procedure DrawButtonOrSubItemGlyph(ACanvas: TCanvas; R: TRect; AItem: TdxBarItem; ASelected: Boolean); override;

    class procedure DrawEditEdge(ACanvas: TCanvas; var AItemRect: TRect; AItem: TdxCustomBarEdit; ASelected: Boolean); override;
    class procedure InternalDrawCaption(ACanvas: TCanvas; var ATextRect: TRect;
      const AText: string; AItem: TdxCustomBarEdit; ASelected: Boolean); override;
  public
    class function BrushColors(Selected: Boolean; AItem: TdxBarItem): TColor; override;
    class procedure DrawCheckBox(ACanvas: TCanvas; R: TRect; AChecked, AEnabled: Boolean); override;
    class procedure DrawComboBoxButton(ACanvas: TCanvas; AItem: TdxBarItem; ARect: TRect; ASelected: Boolean); override;
    class procedure DrawEdit(ACanvas: TCanvas; ARect: TRect; AItem: TdxCustomBarEdit; Selected, ADrawArrowButton: Boolean); override;
    class procedure DrawFocusedRect(ACanvas: TCanvas; ARect: TRect; AItem: TdxBarItem); override;
    class function FontColors(Selected: Boolean): TColor; override;
    class function GetBarButtonHeight: Integer; override;
    class function GetComboBoxButtonWidth: Integer; override;
    class function GetListBoxPadding(AListBox: TcxListBox): TdxPadding; override;
  end;

{ TdxBarCustomizationForm }

constructor TdxBarCustomizationForm.CreateEx(ABarManager: TdxBarManager);
begin
  FLookAndFeel := TcxLookAndFeel.Create(Self);
  inherited CreateEx(ABarManager);

  if BarManager.Designing then
    TdxBarManagerAccess(BarManager).OnItemLinksChanged := OnItemLinksChanged;
end;

destructor TdxBarCustomizationForm.Destroy;
begin
  if BarManager.Designing then
    TdxBarManagerAccess(BarManager).OnItemLinksChanged := nil;
  FreeAndNil(FLookAndFeel);
  inherited Destroy;
end;

procedure TdxBarCustomizationForm.OnItemLinksChanged(Sender: TObject);
begin
  DeferredCallSynchronizationListBox(LAllCommands);
end;

function TdxBarCustomizationForm.GetBarItemsBackgroundColor: TColor;
begin
  Result := LookAndFeelPainter.DefaultEditorBackgroundColor(False);
  if Result = clDefault then
    Result := inherited GetBarItemsBackgroundColor;
end;

procedure TdxBarCustomizationForm.PrepareControls;

  procedure PrepareToolBarsSheet;
  begin
    liBBarReset.Visible := not BarManager.Designing and TdxBarManagerAccess(BarManager).CanReset;
    LabelToolbars.Caption := cxGetResourceString(@dxSBAR_TOOLBARS);
    tsToolbars.Caption := cxGetResourceString(@dxSBAR_TABSHEET1);
  end;

  procedure PrepareItemsSheet;
  var
    APadding: TdxPadding;
  begin
    tsItems.Caption := cxGetResourceString(@dxSBAR_TABSHEET2);
    if LookAndFeelPainter.ApplyEditorAdvancedMode then 
    begin
      APadding := LookAndFeelPainter.GetListBoxItemPadding(ScaleFactor);
      lbItems.ItemHeight := lbItems.ItemHeight + APadding.Height;
      lbItems.Style.AssignedValues := [];
      lbItems.StyleHot.AssignedValues := [];
      lbItems.StyleDisabled.AssignedValues := [];
    end;
    LabelCategories.Caption := cxGetResourceString(@dxSBAR_CATEGORIES);
    LabelCommands.Caption := cxGetResourceString(@dxSBAR_COMMANDS);
    LabelDescription.Caption := cxGetResourceString(@dxSBAR_DESCRIPTION);
    CategoriesPopupButtonPlace.Caption := cxGetResourceString(@dxSBAR_MODIFY);
    CommandsPopupButtonPlace.Caption := cxGetResourceString(@dxSBAR_MODIFY);

    if not BarManager.Designing then
    begin
      LabelCommands.Control := nil;
      LabelCategories.Control := nil;
      CategoriesPopupButtonPlace.Visible := False;
      CommandsPopupButtonPlace.Visible := False;
    end;
  end;

  procedure PrepareOptionsSheet;
  begin
    tsOptions.Caption := cxGetResourceString(@dxSBAR_TABSHEET3);

    if BarManager.GetPaintStyle = bmsStandard then
    begin
      CBLargeIcons.Caption := cxGetResourceString(@dxSBAR_LARGEICONS);
      CBHint1.Caption := cxGetResourceString(@dxSBAR_HINTOPT1);
      CBHint2.Caption := cxGetResourceString(@dxSBAR_HINTOPT2);
      LabelMenuAnimations.Caption := cxGetResourceString(@dxSBAR_MENUANIMATIONS);

      with ComboBoxMenuAnimations do
        Width := PrepareMenuAnimationsComboBox(Font, Properties.Items);
    end
    else
    begin
      Label3.Caption := cxGetResourceString(@dxSBAR_PERSMENUSANDTOOLBARS);
      CBMenusShowRecentItemsFirst.Caption := cxGetResourceString(@dxSBAR_MENUSSHOWRECENTITEMS);
      CBShowFullMenusAfterDelay.Caption := cxGetResourceString(@dxSBAR_SHOWFULLMENUSAFTERDELAY);
      with BResetUsageData do
      begin
        Caption := cxGetResourceString(@dxSBAR_RESETUSAGEDATA);
        Width := cxTextWidth(Font, GetTextOf(Caption)) + 17;
      end;
      Label1.Caption := cxGetResourceString(@dxSBAR_MENUANIMATIONS);
      Label2.Caption := cxGetResourceString(@dxSBAR_OTHEROPTIONS);
      CBLargeIconsEx.Caption := cxGetResourceString(@dxSBAR_LARGEICONS);
      CBHint1Ex.Caption := cxGetResourceString(@dxSBAR_HINTOPT1);
      CBHint2Ex.Caption := cxGetResourceString(@dxSBAR_HINTOPT2);

      with ComboBoxMenuAnimationsEx do
        Width := PrepareMenuAnimationsComboBox(Font, Properties.Items);
    end;
  end;

  procedure PrepareKeyTipsSheet(AContainer: IcxAccessibilityHelper; ANodes: TTreeNodes; AParentNode: TTreeNode = nil);
  var
    AContainerBar: IdxBarAccessibilityHelper;
    AChild: TcxAccessibilityHelper;
    AContainerHelper: TdxBarAccessibilityHelper;
    AKeyTipWindowsManager: IdxBarKeyTipWindowsManager;
    I: Integer;
  begin
    if (AContainer = nil) or (not Supports(AContainer, IdxBarAccessibilityHelper, AContainerBar)) then
      Exit;
    AContainerHelper := AContainerBar.GetBarHelper;
    if AContainerHelper.Selectable then
      AParentNode := ANodes.AddChild(AParentNode, AContainerHelper.OwnerObject.ClassName);
    if AContainerBar.AreKeyTipsSupported(AKeyTipWindowsManager) then
      for I := 0 to AContainerHelper.ChildCount - 1 do
      begin
        AChild := AContainer.GetHelper.Childs[I];
        PrepareKeyTipsSheet(AChild, ANodes, AParentNode);
      end;
  end;

  procedure PrepareButtons;
  begin
    BResetUsageData.Enabled := not BarManager.Designing;
    BClose.Caption := cxGetResourceString(@dxSBAR_CLOSE);
    UpdateHelpButton;
  end;

  procedure PrepareButtonsActions;
  begin
    BBarNew.Action := aNewToolBar;
    BBarReset.Action := aResetToolBar;
    BBarDelete.Action := aDeleteToolBar;
    BBarRename.Action := aRenameToolBar;
  end;

begin
  PrepareButtons;
  PrepareButtonsActions;
  PrepareToolBarsSheet;
  PrepareItemsSheet;
  PrepareOptionsSheet;
  PrepareKeyTipsSheet(GetRootAccessibleObject(BarManager.Owner.Handle), tvKeyTips.Items);
  tsCommands.Visible := BarManager.Designing;
  tsGroups.Visible := BarManager.Designing;
end;

procedure TdxBarCustomizationForm.SynchronizeListBoxes;
begin
  SynchronizeListBox(LAllCommands);
  SynchronizeListBox(lbBarsList);
  SynchronizeListBox(lbCategories);
  SynchronizeListBox(lbItems);
  SynchronizeListBox(lbGroups);
end;

procedure TdxBarCustomizationForm.UpdateItemDescription(const AText: string);
begin
  DescriptionLabel.Caption := AText;
end;

procedure TdxBarCustomizationForm.WndProc(var Message: TMessage);
begin
  if (Message.Msg = WM_ERASEBKGND) then
    Message.Result := 1
  else
    inherited;
end;

function TdxBarCustomizationForm.GetAllCommandsListBox: TcxListBox;
begin
  Result := LAllCommands;
end;

function TdxBarCustomizationForm.GetBarListBox: TcxListBox;
begin
  Result := lbBarsList;
end;

function TdxBarCustomizationForm.GetItemsListBox: TcxListBox;
begin
  Result := lbItems;
end;

function TdxBarCustomizationForm.GetCategoriesList: TcxListBox;
begin
  Result := lbCategories;
end;

function TdxBarCustomizationForm.GetGroupItemsListBox: TcxListBox;
begin
  Result := lbGroupsItems;
end;

function TdxBarCustomizationForm.GetGroupsListBox: TcxListBox;
begin
  Result := lbGroups;
end;

function TdxBarCustomizationForm.GetPainterClass: TdxBarCustomizationFormPainterClass;
begin
  if IsSkinUsed then
    Result := TdxBarCustomizationFormSkinPainter
  else
    Result := inherited GetPainterClass;
end;

function TdxBarCustomizationForm.GetShowCommandsWithShortCut: Boolean;
begin
  Result := CBShowCommandsWithShortCut.Checked;
end;

procedure TdxBarCustomizationForm.BarManagerStyleChanged;
begin
  inherited BarManagerStyleChanged;
  PrepareLookAndFeel(LookAndFeel, BarManager);
  SetControlLookAndFeel(Self, LookAndFeel);
end;

procedure TdxBarCustomizationForm.DesignSelectionChanged(Sender: TObject);
begin
  if not (csDestroying in (Application.ComponentState + BarManager.ComponentState + ComponentState)) then
  begin
    SynchronizeListBoxSelection(lbBarsList);
    SynchronizeListBoxSelection(lbItems);
    SynchronizeListBoxSelection(LAllCommands);
    SynchronizeListBoxSelection(lbGroups)
  end;
end;

procedure TdxBarCustomizationForm.SelectPage(APageIndex: Integer);
begin
  PageControl.ItemIndex := APageIndex;
end;

procedure TdxBarCustomizationForm.SwitchToItemsPage;
begin
  PageControl.ItemIndex := tsItems.Index;
end;

procedure TdxBarCustomizationForm.UpdateHelpButton;
begin
  BHelp.Glyph.Assign(BarManager.HelpButtonGlyph);
  liBHelp.Visible := BarManager.ShowHelpButton;
end;

procedure TdxBarCustomizationForm.UpdateOptions;
begin
  StandardOptionsPanel.Visible := BarManager.GetPaintStyle = bmsStandard;
  EnhancedOptionsPanel.Visible := BarManager.GetPaintStyle <> bmsStandard;

  CBMenusShowRecentItemsFirst.Checked := BarManager.MenusShowRecentItemsFirst;
  CBShowFullMenusAfterDelay.Checked := BarManager.ShowFullMenusAfterDelay;
  CBShowFullMenusAfterDelay.Enabled := CBMenusShowRecentItemsFirst.Checked;

  CBLargeIcons.Checked := BarManager.LargeIcons;
  CBLargeIconsEx.Checked := BarManager.LargeIcons;
  CBHint1.Checked := BarManager.ShowHint;
  CBHint1Ex.Checked := BarManager.ShowHint;
  CBHint2.Checked := BarManager.ShowShortcutInHint;
  CBHint2Ex.Checked := BarManager.ShowShortcutInHint;
  CBHint2Ex.Enabled := CBHint1Ex.Checked;
  ComboBoxMenuAnimations.ItemIndex := Ord(BarManager.MenuAnimations);
  ComboBoxMenuAnimationsEx.ItemIndex := Ord(BarManager.MenuAnimations);
end;

procedure TdxBarCustomizationForm.CBMenusShowRecentItemsFirstClick(Sender: TObject);
begin
  CBShowFullMenusAfterDelay.Enabled := CBMenusShowRecentItemsFirst.Checked;
  BarManager.MenusShowRecentItemsFirst := CBMenusShowRecentItemsFirst.Checked;
end;

procedure TdxBarCustomizationForm.CBShowCommandsWithShortCutClick(Sender: TObject);
begin
  SynchronizeListBox(LAllCommands);
end;

procedure TdxBarCustomizationForm.CBShowFullMenusAfterDelayClick(Sender: TObject);
begin
  BarManager.ShowFullMenusAfterDelay := CBShowFullMenusAfterDelay.Checked;
end;

procedure TdxBarCustomizationForm.BResetUsageDataClick(Sender: TObject);
begin
  BarManager.ResetUsageDataWithConfirmation;
end;

procedure TdxBarCustomizationForm.CBLargeIconsClick(Sender: TObject);
begin
  BarManager.LargeIcons := TdxLayoutCheckBoxItem(Sender).Checked;
end;

procedure TdxBarCustomizationForm.CBHint1Click(Sender: TObject);
begin
  BarManager.ShowHint := TdxLayoutCheckBoxItem(Sender).Checked;
end;

procedure TdxBarCustomizationForm.CBHint1ExClick(Sender: TObject);
begin
  CBHint2Ex.Enabled := CBHint1Ex.Checked;
  CBHint1Click(Sender);
end;

procedure TdxBarCustomizationForm.CBHint2Click(Sender: TObject);
begin
  BarManager.ShowShortCutInHint := TdxLayoutCheckBoxItem(Sender).Checked;
end;

procedure TdxBarCustomizationForm.ComboBoxMenuAnimationsClick(Sender: TObject);
begin
  BarManager.MenuAnimations := TdxBarMenuAnimations(TcxComboBox(Sender).ItemIndex);
end;

function TdxBarCustomizationForm.GetIsSkinUsed: Boolean;
begin
  Result := Assigned(LookAndFeel.SkinPainter);
end;

procedure TdxBarCustomizationForm.lbItemsDrawItem(
  AControl: TcxListBox; ACanvas: TcxCanvas; AIndex: Integer; ARect: TRect;
  AState: TOwnerDrawState);
var
  ABitmap: TcxBitmap;
  AItem: TdxBarItem;
begin
  AItem := ItemList[AIndex];
  if Assigned(AItem) then
  begin
    ABitmap := TcxBitmap.CreateSize(ARect, pf32bit);
    try
      ABitmap.Canvas.Font := ACanvas.Font;
      ABitmap.Canvas.TextFlags := ACanvas.TextFlags;
      TdxBarItemAccess(AItem).DrawCustomizingImage(ABitmap.Canvas, ABitmap.ClientRect, AState);
      if odFocused in AState then
        PainterClass.DrawFocusedRect(ABitmap.Canvas, ABitmap.ClientRect, AItem);
      cxBitBlt(ACanvas.Handle, ABitmap.Canvas.Handle, ARect, cxNullPoint, SRCCOPY);
    finally
      ABitmap.Free;
    end;
  end;
end;

{ TdxBarCustomizationFormSkinPainter }

class function TdxBarCustomizationFormSkinPainter.BrushColors(
  Selected: Boolean; AItem: TdxBarItem): TColor;
begin
  Result := GetSkinElementColor(GetPopupMenuElement, False);
  if Result = clDefault then
    Result := inherited BrushColors(Selected, AItem)
end;

class procedure TdxBarCustomizationFormSkinPainter.DrawCheckBox(
  ACanvas: TCanvas; R: TRect; AChecked, AEnabled: Boolean);
const
  EnableMap: array[Boolean] of TcxButtonState = (cxbsDisabled, cxbsNormal);
var
  AcxCanvas: TcxCanvas;
begin
  AcxCanvas := TcxCanvas.Create(ACanvas);
  try
    InflateRect(R, -1, -1);
    GetLookAndFeelPainter.DrawScaledCheckButton(AcxCanvas, R, EnableMap[AEnabled], AChecked, ScaleFactor);
  finally
    AcxCanvas.Free;
  end;
end;

class procedure TdxBarCustomizationFormSkinPainter.DrawComboBoxButton(
  ACanvas: TCanvas; AItem: TdxBarItem; ARect: TRect; ASelected: Boolean);
const
  ComboBoxStateMap: array[Boolean] of TcxButtonState = (cxbsNormal, cxbsHot);
var
  AcxCanvas: TcxCanvas;
begin
  AcxCanvas := TcxCanvas.Create(ACanvas);
  try
    FillRectByColor(ACanvas.Handle, ARect,
      GetLookAndFeelPainter.DefaultEditorBackgroundColorEx(esckNormal));
    GetLookAndFeelPainter.DrawScaledEditorButton(AcxCanvas, ARect,
      cxbkComboBtn, ComboBoxStateMap[ASelected], ScaleFactor);
    GetLookAndFeelPainter.DrawScaledEditorButtonGlyph(AcxCanvas, ARect,
      cxbkComboBtn, ComboBoxStateMap[ASelected], ScaleFactor);
  finally
    AcxCanvas.Free;
  end;
end;

class procedure TdxBarCustomizationFormSkinPainter.DrawEdit(ACanvas: TCanvas;
  ARect: TRect; AItem: TdxCustomBarEdit; Selected: Boolean; ADrawArrowButton: Boolean);
var
  R, ASideStripRect: TRect;
begin
  CalcButtonOrSubItemRects(AItem, ARect, ASideStripRect, R, R);
  DrawSkinElementContent(ACanvas, ARect, GetPopupMenuElement);
  DrawSkinElement(ACanvas, ASideStripRect, GetSideStripElement, UseRightToLeftAlignment(AItem));
  if Selected then
    DrawSkinElement(ACanvas, ARect, GetPopupMenuLinkSelectedElement(False), False);
  if UseRightToLeftAlignment(AItem) then
    ARect.Right := ASideStripRect.Left - 5
  else
    ARect.Left := ASideStripRect.Right + 5;
  inherited DrawEdit(ACanvas, ARect, AItem, Selected, ADrawArrowButton);
end;

class procedure TdxBarCustomizationFormSkinPainter.DrawFocusedRect(
  ACanvas: TCanvas; ARect: TRect; AItem: TdxBarItem);
begin
  // do nothing
end;

class function TdxBarCustomizationFormSkinPainter.GetListBoxPadding(AListBox: TcxListBox): TdxPadding;
begin
  if TcxListBoxAccess(AListBox).ViewInfo.Painter.SupportsListBoxPadding then
    Result := TcxListBoxAccess(AListBox).ViewInfo.Painter.GetListBoxItemPadding(TcxListBoxAccess(AListBox).ScaleFactor)
  else
    Result := inherited GetListBoxPadding(AListBox);
end;

class procedure TdxBarCustomizationFormSkinPainter.DrawButtonOrSubItemArrowBackground(
  ACanvas: TCanvas; R: TRect; AItem: TdxBarItem; Selected: Boolean);
begin
  if Selected then
    DrawSkinElement(ACanvas, R, GetPopupMenuLinkDropButtonElement);
end;

class procedure TdxBarCustomizationFormSkinPainter.DrawButtonOrSubItemBackground(
  ACanvas: TCanvas; AItem: TdxBarItem; const ABounds, ASideStripRect: TRect;
  const AArrowRect: TRect; ASelected: Boolean);
var
  AIsDropDown: Boolean;
begin
  AIsDropDown := (AItem is TdxBarCustomButton) and (TdxBarCustomButton(AItem).ButtonStyle = bsDropDown);
  DrawSkinElementContent(ACanvas, ABounds, GetPopupMenuElement);
  DrawSkinElement(ACanvas, ASideStripRect, GetSideStripElement, UseRightToLeftAlignment(AItem));
  if ASelected then
    DrawSkinElement(ACanvas, cxRectSetRight(ABounds, AArrowRect.Left), GetPopupMenuLinkSelectedElement(AIsDropDown));
  if AIsDropDown then
    DrawButtonOrSubItemArrowBackground(ACanvas, AArrowRect, AItem, ASelected);
end;

class procedure TdxBarCustomizationFormSkinPainter.DrawButtonOrSubItemGlyph(
  ACanvas: TCanvas; R: TRect; AItem: TdxBarItem; ASelected: Boolean);
const
  StateMap: array[Boolean] of TdxSkinElementState = (esNormal, esPressed);
var
  AColorPalette: IdxColorPalette;
  AElement: TdxSkinElement;
begin
  AElement := GetPopupMenuElement;
  if AElement <> nil then
    AColorPalette := AElement.GetGlyphColorPalette(StateMap[ASelected])
  else
    AColorPalette := nil;

  R := cxRectCenter(R, GetGlyphSize(AItem));
  TransparentDraw(ACanvas.Handle, 0, R, R, AItem.Glyph, AItem.GetCurrentImages,
    AItem.ImageIndex, AItem.BarManager.ImageListBkColor, True, False, False{Flat},
    ASelected, False, False, False{Shadow}, False{Faded}, True{SmoothResize},
    AItem.BarManager.ImageOptions.UseLeftBottomPixelAsTransparent, AColorPalette);
end;

class procedure TdxBarCustomizationFormSkinPainter.DrawEditEdge(ACanvas: TCanvas;
  var AItemRect: TRect; AItem: TdxCustomBarEdit; ASelected: Boolean);
begin
  InflateRect(AItemRect, -2, -2);
  FrameRectByColor(ACanvas.Handle, AItemRect, GetLookAndFeelPainter.GetContainerBorderColor(ASelected));
  InflateRect(AItemRect, -1, -1);
end;

class procedure TdxBarCustomizationFormSkinPainter.DrawSkinElement(
  ACanvas: TCanvas; const R: TRect; AElement: TdxSkinElement; AIsRightToLeft: Boolean);
begin
  if Assigned(AElement) then
    AElement.RightToLeftDependentDraw(ACanvas.Handle, R, dxSystemScaleFactor, AIsRightToLeft);
end;

class procedure TdxBarCustomizationFormSkinPainter.DrawSkinElementContent(
  ACanvas: TCanvas; R: TRect; AElement: TdxSkinElement);
var
  AcxCanvas: TcxCanvas;
begin
  if Assigned(AElement) then
  begin
    AcxCanvas := TcxCanvas.Create(ACanvas);
    try
      AcxCanvas.SaveClipRegion;
      try
        AcxCanvas.IntersectClipRect(R);
        with AElement.Image, AElement.Borders do
        begin
          Dec(R.Left, Max(Margins.Left, Left.Thin));
          Dec(R.Top, Max(Margins.Top, Top.Thin));
          Inc(R.Bottom, Max(Margins.Bottom, Bottom.Thin));
          Inc(R.Right, Max(Margins.Right, Right.Thin));
        end;
        AElement.Draw(ACanvas.Handle, R);
      finally
        AcxCanvas.RestoreClipRegion;
      end;
    finally
      AcxCanvas.Free;
    end;
  end;
end;

class function TdxBarCustomizationFormSkinPainter.FontColors(Selected: Boolean): TColor;
begin
  Result := GetSkinElementColor(GetPopupMenuElement, True);
  if Result = clDefault then
    Result := inherited FontColors(Selected);
end;

class function TdxBarCustomizationFormSkinPainter.GetSkinElementColor(
  AElement: TdxSkinElement; ATextColor: Boolean): TColor;
begin
  if AElement = nil then
    Result := clDefault
  else
    if ATextColor then
      Result := AElement.TextColor
    else
      Result := AElement.Color;
end;

class function TdxBarCustomizationFormSkinPainter.GetLookAndFeelPainter: TcxCustomLookAndFeelPainter;
begin
  Result := dxBarCustomizingForm.LookAndFeelPainter;
end;

class function TdxBarCustomizationFormSkinPainter.GetPopupMenuElement: TdxSkinElement;
var
  ASkinInfo: TdxSkinInfo;
begin
  if GetSkinInfo(ASkinInfo) then
    Result := ASkinInfo.PopupMenu
  else
    Result := nil;
end;

class function TdxBarCustomizationFormSkinPainter.GetPopupMenuLinkDropButtonElement: TdxSkinElement;
var
  ASkinInfo: TdxSkinInfo;
begin
  if GetSkinInfo(ASkinInfo) then
    Result := ASkinInfo.PopupMenuSplitButton2
  else
    Result := nil;
end;

class function TdxBarCustomizationFormSkinPainter.GetPopupMenuLinkSelectedElement(
  AIsDropDown: Boolean): TdxSkinElement;
var
  ASkinInfo: TdxSkinInfo;
begin
  if not GetSkinInfo(ASkinInfo) then
    Result := nil
  else
    if AIsDropDown then
      Result := ASkinInfo.PopupMenuSplitButton
    else
      Result := ASkinInfo.PopupMenuLinkSelected;
end;

class function TdxBarCustomizationFormSkinPainter.GetSideStripElement: TdxSkinElement;
var
  ASkinInfo: TdxSkinInfo;
begin
  if GetSkinInfo(ASkinInfo) then
    Result := ASkinInfo.PopupMenuSideStrip
  else
    Result := nil;
end;

class function TdxBarCustomizationFormSkinPainter.GetSkinInfo(var ASkinInfo: TdxSkinInfo): Boolean;
var
  APainter: TcxCustomLookAndFeelPainter;
begin
  APainter := GetLookAndFeelPainter;
  Result := (APainter <> nil) and APainter.GetPainterData(ASkinInfo);
end;

class function TdxBarCustomizationFormSkinPainter.GetBarButtonHeight: Integer;
begin
  Result := ScaleFactor.Apply(dxBarButtonHeight);
end;

class function TdxBarCustomizationFormSkinPainter.GetComboBoxButtonWidth: Integer;
begin
  Result := ScaleFactor.Apply(GetLookAndFeelPainter.EditButtonSize.cy);
  if Result = 0 then
    Result := inherited GetComboBoxButtonWidth;
end;

class procedure TdxBarCustomizationFormSkinPainter.InternalDrawCaption(
  ACanvas: TCanvas; var ATextRect: TRect; const AText: string; AItem: TdxCustomBarEdit; ASelected: Boolean);
begin
  Inc(ATextRect.Right, ScaleFactor.Apply(cxTextOffset + 1));
  ACanvas.Font.Color := FontColors(ASelected);
  ACanvas.Brush.Style := bsClear;
  cxDrawText(ACanvas.Handle, AText, ATextRect, DT_NOCLIP or DT_NOPREFIX or DT_SINGLELINE or DT_LEFT or DT_VCENTER);
end;

procedure TdxBarCustomizationForm.BCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TdxBarCustomizationForm.BHelpClick(Sender: TObject);
begin
  DoShowHelp;
end;

end.
