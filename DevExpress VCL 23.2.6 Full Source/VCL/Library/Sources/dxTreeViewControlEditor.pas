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

unit dxTreeViewControlEditor;

{$I cxVer.inc}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, StdActns, ActnList,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxLayoutContainer, dxForms,
  dxLayoutControlAdapters, cxClasses, dxLayoutControl, dxCustomTree, dxTreeView,
  dxShellDialogs, dxLayoutcxEditAdapters, cxContainer, cxEdit, cxTextEdit;

type
  TfmTreeViewEditor = class(TdxForm)
    btNewItem: TButton;
    btDeleteItem: TButton;
    btNewSubItem: TButton;
    btOk: TButton;
    btCancel: TButton;
    btApply: TButton;
    btHelp: TButton;
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutGroup3: TdxLayoutGroup;
    dxLayoutGroup4: TdxLayoutGroup;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutItem3: TdxLayoutItem;
    dxLayoutItem4: TdxLayoutItem;
    grpItemProperties: TdxLayoutGroup;
    dxLayoutGroup6: TdxLayoutGroup;
    dxLayoutGroup7: TdxLayoutGroup;
    dxLayoutItem9: TdxLayoutItem;
    dxLayoutItem10: TdxLayoutItem;
    dxLayoutItem11: TdxLayoutItem;
    dxLayoutItem12: TdxLayoutItem;
    lgItems: TdxLayoutGroup;
    tvNodes: TdxTreeViewControl;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutItem14: TdxLayoutItem;
    btLoad: TButton;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    dxOpenFileDialog1: TdxOpenFileDialog;
    liNodeEnabled: TdxLayoutCheckBoxItem;
    edItemCaption: TcxTextEdit;
    dxLayoutItem15: TdxLayoutItem;
    edImageIndex: TcxTextEdit;
    dxLayoutItem5: TdxLayoutItem;
    edStateImageIndex: TcxTextEdit;
    dxLayoutItem6: TdxLayoutItem;
    edSelectedImageIndex: TcxTextEdit;
    dxLayoutItem7: TdxLayoutItem;
    edExpandedImageIndex: TcxTextEdit;
    dxLayoutItem8: TdxLayoutItem;
    liNodeChecked: TdxLayoutCheckBoxItem;
    ActionList1: TActionList;
    actNewItem: TAction;
    actNewSubItem: TAction;
    actDelete: TAction;
    actLoad: TAction;
    procedure btNewItemClick(Sender: TObject);
    procedure btNewSubItemClick(Sender: TObject);
    procedure btDeleteItemClick(Sender: TObject);
    procedure btApplyItemsClick(Sender: TObject);
    procedure btHelpClick(Sender: TObject);
    procedure tvNodesDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure tvNodesEditing(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btLoadClick(Sender: TObject);
    procedure liNodeEnabledClick(Sender: TObject);
    procedure edExpandedImageIndexExit(Sender: TObject);
    procedure edImageIndexExit(Sender: TObject);
    procedure tvNodesEdited(Sender: TdxCustomTreeView; Node: TdxTreeViewNode; var S: string);
    procedure tvNodesFocusedNodeChanged(Sender: TObject);
    procedure edImageIndexPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure liNodeCheckedClick(Sender: TObject);
    procedure tvNodesNodeStateChanged(Sender: TdxCustomTreeView; Node: TdxTreeViewNode);
    procedure edItemCaptionPropertiesChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tvNodesCollapsed(Sender: TdxCustomTreeView; Node: TdxTreeViewNode);
    procedure tvNodesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvNodesExpanded(Sender: TdxCustomTreeView; Node: TdxTreeViewNode);
    procedure tvNodesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edImageIndexPropertiesChange(Sender: TObject);
    procedure edSelectedImageIndexExit(Sender: TObject);
    procedure edStateImageIndexExit(Sender: TObject);
  private
    FTreeView: TdxCustomTreeView;
    FIsLockEditChanges: Boolean;
    FIsModified: Boolean;
    procedure DeleteSelectedNode;
  protected
    procedure ApplyChanges;
    procedure UpdateStates;
    procedure Init(ATreeView: TdxCustomTreeView);
  end;

  function dxEditTreeViewControl(ATreeView: TdxCustomTreeView): Boolean;

implementation

uses
  CommCtrl;

const
  dxThisUnitName = 'dxTreeViewControlEditor';

{$R *.dfm}

type
  TdxCustomTreeViewAccess = class(TdxCustomTreeView);

var
  SavedWidth, SavedHeight, SavedLeft, SavedTop: Integer;

procedure AssignData(ASource, ADestination: TdxCustomTreeView);
var
  AStream: TStream;
begin
  ADestination.Root.Clear;
  if ASource.Root.Count > 0 then
  begin
    AStream := TMemoryStream.Create;
    try
      TdxCustomTreeViewAccess(ASource).WriteData(AStream);
      AStream.Position := 0;
      TdxCustomTreeViewAccess(ADestination).ReadData(AStream);
    finally
      AStream.Free;
    end;
  end;
end;

function dxEditTreeViewControl(ATreeView: TdxCustomTreeView): Boolean;
var
  AEditor: TfmTreeViewEditor;
begin
  AEditor := TfmTreeViewEditor.Create(Application);
  try
    AEditor.Init(ATreeView);
    Result := AEditor.ShowModal = mrOK;
    if Result then
      AEditor.ApplyChanges;
  finally
    AEditor.Free;
  end;
end;

{ TfmTreeViewEditor }

procedure TfmTreeViewEditor.UpdateStates;
var
  AHasFocusedNode: Boolean;
begin
  AHasFocusedNode := (tvNodes.FocusedNode <> nil) and not tvNodes.FocusedNode.IsRoot;
  grpItemProperties.Enabled := AHasFocusedNode;
  btApply.Enabled := FIsModified;
  btNewSubItem.Enabled := AHasFocusedNode;
  btDeleteItem.Enabled := AHasFocusedNode;
end;

procedure TfmTreeViewEditor.btNewItemClick(Sender: TObject);
var
  ANode: TdxTreeViewNode;
begin
  ANode := tvNodes.FocusedNode;
  ANode := tvNodes.Root.AddNode(nil, ANode, nil, namAdd);
  tvNodes.MakeVisible(ANode);
  tvNodes.FocusedNode := ANode;
  edItemCaption.SetFocus;
  FIsModified := True;
  UpdateStates;
end;

procedure TfmTreeViewEditor.btNewSubItemClick(Sender: TObject);
var
  ANode, ANewNode: TdxTreeViewNode;
begin
  ANode := tvNodes.Selected;
  if ANode <> nil then
  begin
    ANewNode := ANode.AddChild;
    tvNodes.MakeVisible(ANewNode);
    tvNodes.FocusedNode := ANewNode;
  end;
  edItemCaption.SetFocus;
  FIsModified := True;
  UpdateStates;
end;

procedure TfmTreeViewEditor.btOkClick(Sender: TObject);
begin
  btApplyItemsClick(nil);
  Close;
end;

procedure TfmTreeViewEditor.DeleteSelectedNode;
var
  ANode: TdxTreeViewNode;
begin
  ANode := tvNodes.Selected;
  if ANode <> nil then
    ANode.Free;
  FIsModified := True;
  UpdateStates;
end;

procedure TfmTreeViewEditor.btCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmTreeViewEditor.btDeleteItemClick(Sender: TObject);
begin
  DeleteSelectedNode;
end;

procedure TfmTreeViewEditor.ApplyChanges;

  procedure DesignerModified;
  var
    AForm: TCustomForm;
  begin
    AForm := GetParentForm(FTreeView);
    if (AForm <> nil) and (AForm.Designer <> nil) then
      AForm.Designer.Modified;
  end;

begin
  if FIsModified then
  begin
    AssignData(tvNodes, FTreeView);
    FIsModified := False;
    UpdateStates;
    DesignerModified;
  end;
end;

procedure TfmTreeViewEditor.btApplyItemsClick(Sender: TObject);
begin
  ApplyChanges;
end;

procedure TfmTreeViewEditor.tvNodesDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := True;
end;

procedure TfmTreeViewEditor.btHelpClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

procedure TfmTreeViewEditor.btLoadClick(Sender: TObject);
begin
  if dxOpenFileDialog1.Execute then
  begin
    tvNodes.LoadFromFile(dxOpenFileDialog1.FileName);
    tvNodes.FocusedNode := tvNodes.Root.First;
    FIsModified := True;
    UpdateStates;
  end;
end;

procedure TfmTreeViewEditor.liNodeEnabledClick(Sender: TObject);
begin
  if FIsLockEditChanges then
    Exit;
  tvNodes.FocusedNode.Enabled := liNodeEnabled.Checked;
  FIsModified := True;
  UpdateStates;
end;

procedure TfmTreeViewEditor.edExpandedImageIndexExit(Sender: TObject);
var
  AValue: Integer;
begin
  if (ActiveControl <> btCancel) and TryStrToInt(edExpandedImageIndex.Text, AValue) then
    tvNodes.FocusedNode.ExpandedImageIndex := AValue;
end;

procedure TfmTreeViewEditor.edImageIndexExit(Sender: TObject);
var
  AValue: Integer;
begin
  if (ActiveControl <> btCancel) and TryStrToInt(edImageIndex.Text, AValue) then
    tvNodes.FocusedNode.ImageIndex := AValue;
end;

procedure TfmTreeViewEditor.edImageIndexPropertiesChange(Sender: TObject);
begin
  if FIsLockEditChanges then
    Exit;
  FIsModified := True;
  UpdateStates;
end;

procedure TfmTreeViewEditor.edImageIndexPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  AValue: Integer;
begin
  if ActiveControl = btCancel then
    Error := False
  else
    Error := not TryStrToInt(DisplayValue, AValue);
end;

procedure TfmTreeViewEditor.edItemCaptionPropertiesChange(Sender: TObject);
begin
  if FIsLockEditChanges then
    Exit;
  tvNodes.FocusedNode.Caption := edItemCaption.Text;
  FIsModified := True;
  UpdateStates;
end;

procedure TfmTreeViewEditor.edSelectedImageIndexExit(Sender: TObject);
var
  AValue: Integer;
begin
  if (ActiveControl <> btCancel) and TryStrToInt(edSelectedImageIndex.Text, AValue) then
    tvNodes.FocusedNode.SelectedImageIndex := AValue;
end;

procedure TfmTreeViewEditor.edStateImageIndexExit(Sender: TObject);
var
  AValue: Integer;
begin
  if (ActiveControl <> btCancel) and TryStrToInt(edStateImageIndex.Text, AValue) then
    tvNodes.FocusedNode.StateImageIndex := AValue;
end;

procedure TfmTreeViewEditor.tvNodesEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
  btNewItem.Default := False;
end;

procedure TfmTreeViewEditor.FormDestroy(Sender: TObject);
begin
  SavedWidth := Width;
  SavedHeight := Height;
  SavedLeft := Left;
  SavedTop := Top;
end;

procedure TfmTreeViewEditor.FormShow(Sender: TObject);
begin
  dxLayoutControl1.ApplyBestFit;
  AutoSize := True;
  AutoSize := False;
  dxLayoutControl1.Align := alClient;
  dxLayoutControl1Group_Root.AlignHorz := ahClient;
  dxLayoutControl1Group_Root.AlignVert := avClient;
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;

  if SavedWidth <> 0 then
    Width := SavedWidth;
  if SavedHeight <> 0 then
    Height := SavedHeight;
  if SavedLeft <> 0 then
    Left := SavedLeft
  else
    Left := (Screen.Width - Width) div 2;
  if SavedTop <> 0 then
    Top := SavedTop
  else
    Top := (Screen.Height - Height) div 2;
end;

procedure TfmTreeViewEditor.Init(ATreeView: TdxCustomTreeView);
begin
  FTreeView := ATreeView;
  TdxCustomTreeViewAccess(tvNodes).OptionsBehavior.SortType := TdxCustomTreeViewAccess(ATreeView).OptionsBehavior.SortType;
  TdxCustomTreeViewAccess(tvNodes).OptionsView.ShowCheckBoxes := TdxCustomTreeViewAccess(ATreeView).OptionsView.ShowCheckBoxes;
  liNodeChecked.Visible := TdxCustomTreeViewAccess(tvNodes).OptionsView.ShowCheckBoxes;
  AssignData(ATreeView, tvNodes);
  tvNodes.FocusedNode := tvNodes.Root.First;
  UpdateStates;
end;

procedure TfmTreeViewEditor.liNodeCheckedClick(Sender: TObject);
begin
  if FIsLockEditChanges then
    Exit;
  tvNodes.FocusedNode.Checked := liNodeChecked.Checked;
  FIsModified := True;
  UpdateStates;
end;

procedure TfmTreeViewEditor.tvNodesCollapsed(Sender: TdxCustomTreeView; Node: TdxTreeViewNode);
begin
  FIsModified := True;
  UpdateStates;
end;

procedure TfmTreeViewEditor.tvNodesDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  ANode: TdxTreeViewNode;
  AAddMode: TdxTreeNodeAttachMode;
  AChild: Boolean;
begin
  AChild := GetKeyState(VK_SHIFT) < 0;
  if AChild then
    AAddMode := namAddChild
  else
    AAddMode := namInsert;
  if not tvNodes.GetNodeAtPos(Point(X, Y), ANode) then
  begin
    ANode := TdxCustomTreeViewAccess(tvNodes).AbsoluteVisibleNodes.Last;
    if not AChild then AAddMode := namAdd;
  end;
  if ANode <> nil then
  begin
    tvNodes.FocusedNode.MoveTo(ANode, AAddMode);
    FIsModified := True;
    UpdateStates;
  end;
end;

procedure TfmTreeViewEditor.tvNodesEdited(Sender: TdxCustomTreeView; Node: TdxTreeViewNode; var S: string);
begin
  FIsLockEditChanges := True;
  try
    edItemCaption.Text := S;
  finally
    FIsLockEditChanges := False;
  end;
  FIsModified := True;
  UpdateStates;
end;

procedure TfmTreeViewEditor.tvNodesExpanded(Sender: TdxCustomTreeView; Node: TdxTreeViewNode);
begin
  FIsModified := True;
  UpdateStates;
end;

procedure TfmTreeViewEditor.tvNodesFocusedNodeChanged(Sender: TObject);
begin
  FIsLockEditChanges := True;
  try
    if (tvNodes.FocusedNode <> nil) and not tvNodes.FocusedNode.IsRoot then
    begin
      edItemCaption.Text := tvNodes.FocusedNode.Caption;
      edImageIndex.Text := IntToStr(tvNodes.FocusedNode.ImageIndex);
      edSelectedImageIndex.Text := IntToStr(tvNodes.FocusedNode.SelectedImageIndex);
      edStateImageIndex.Text := IntToStr(tvNodes.FocusedNode.StateImageIndex);
      edExpandedImageIndex.Text := IntToStr(tvNodes.FocusedNode.ExpandedImageIndex);
      liNodeEnabled.Checked := tvNodes.FocusedNode.Enabled;
      liNodeChecked.Checked := tvNodes.FocusedNode.Checked;
    end
    else
    begin
      edItemCaption.Text := '';
      edImageIndex.Text := '';
      edSelectedImageIndex.Text := '';
      edStateImageIndex.Text := '';
      edExpandedImageIndex.Text := '';
      liNodeEnabled.Checked := False;
      liNodeChecked.Checked := False;
    end;
  finally
    FIsLockEditChanges := False;
  end;
  UpdateStates;
end;

procedure TfmTreeViewEditor.tvNodesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
    DeleteSelectedNode;
end;

procedure TfmTreeViewEditor.tvNodesNodeStateChanged(Sender: TdxCustomTreeView; Node: TdxTreeViewNode);
begin
  FIsLockEditChanges := True;
  try
    liNodeChecked.Checked := tvNodes.FocusedNode.Checked;
    FIsModified := True;
  finally
    FIsLockEditChanges := False;
  end;
  UpdateStates;
end;

end.

