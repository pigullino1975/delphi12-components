{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           Express Cross Platform Library classes                   }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCROSSPLATFORMLIBRARY AND ALL   }
{   ACCOMPANYING VCL AND CLX CONTROLS AS PART OF AN EXECUTABLE       }
{   PROGRAM ONLY.                                                    }
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

unit dxShellColumnCustomization;  // for internal use only

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, Menus, StdCtrls, Math, StrUtils,
  Generics.Collections, Generics.Defaults,
  dxCore, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutContainer, dxLayoutControlAdapters,
  dxLayoutcxEditAdapters, cxCheckBox, cxContainer, cxEdit,
  cxTextEdit, cxButtons, cxCustomListBox, cxCheckListBox,
  cxClasses, dxLayoutControl, dxForms, cxMaskEdit, cxSpinEdit,
  ActnList, dxLayoutLookAndFeels;

type
  TdxShellColumnCustomizeItem = class
  public
    DetailIndex: Integer;
    Text: string;
    VisibleIndex: Cardinal;
    Width: Integer;
  end;

  TdxShellColumnCustomizeItemComparer = class(TInterfacedObject, IComparer<TdxShellColumnCustomizeItem>)
  protected
    function Compare(const Left, Right: TdxShellColumnCustomizeItem): Integer;
  end;

  TdxShellColumnCustomizeItems = class(TObjectList<TdxShellColumnCustomizeItem>);

  TfmShellDialogColumnCustomization = class(TdxForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    cxCheckListBox1: TcxCheckListBox;
    dxLayoutItem1: TdxLayoutItem;
    btnOk: TcxButton;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutItem3: TdxLayoutItem;
    btnCancel: TcxButton;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutSeparatorItem1: TdxLayoutSeparatorItem;
    liColumnWidth: TdxLayoutItem;
    dxLayoutGroup2: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    edtWidth: TcxSpinEdit;
    btnHide: TcxButton;
    dxLayoutItem5: TdxLayoutItem;
    btnShow: TcxButton;
    dxLayoutItem6: TdxLayoutItem;
    btnMoveDown: TcxButton;
    dxLayoutItem7: TdxLayoutItem;
    btnMoveUp: TcxButton;
    dxLayoutItem8: TdxLayoutItem;
    dxLayoutGroup4: TdxLayoutGroup;
    ActionList1: TActionList;
    actUp: TAction;
    actDown: TAction;
    actShow: TAction;
    actHide: TAction;
    liDetails: TdxLayoutLabeledItem;
    liSelectDetails: TdxLayoutLabeledItem;
    dxLayoutEmptySpaceItem1: TdxLayoutEmptySpaceItem;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel;
    procedure FormCreate(Sender: TObject);
    procedure actDownExecute(Sender: TObject);
    procedure actHideExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure actShowExecute(Sender: TObject);
    procedure actUpExecute(Sender: TObject);
    procedure edtWidthPropertiesChange(Sender: TObject);
  private
    function GetSelectedCheckItem: TcxCheckListBoxItem;
    procedure Localize;
    property SelectedCheckItem: TcxCheckListBoxItem read GetSelectedCheckItem;
  public
    function Customize(AItems: TdxShellColumnCustomizeItems): Boolean;
    procedure InitializeLookAndFeel(ALookAndFeel: TcxLookAndFeel);
  end;

implementation

uses
  cxEditConsts;

const
  dxThisUnitName = 'dxShellColumnCustomization';

{$R *.dfm}

{ TdxShellColumnCustomizeItemComparer }

function TdxShellColumnCustomizeItemComparer.Compare(const Left,
  Right: TdxShellColumnCustomizeItem): Integer;
begin
  if Left.VisibleIndex > Right.VisibleIndex then
    Result := 1
  else
    if Left.VisibleIndex < Right.VisibleIndex then
      Result := -1
    else
      Result := AnsiCompareText(Left.Text, Right.Text);
end;

procedure TfmShellDialogColumnCustomization.FormCreate(Sender: TObject);
begin
  Localize;
  AutoSize := True;
end;

{ TfmShellDialogColumnCustomization }

procedure TfmShellDialogColumnCustomization.actDownExecute(Sender: TObject);
var
  AIndex: Integer;
begin
  AIndex := Max(0, cxCheckListBox1.ItemIndex + 1);
  SelectedCheckItem.Index := AIndex;
  cxCheckListBox1.ItemIndex := AIndex;
  FocusControl(cxCheckListBox1);
end;

procedure TfmShellDialogColumnCustomization.actHideExecute(Sender: TObject);
begin
  SelectedCheckItem.Checked := False;
  FocusControl(cxCheckListBox1);
end;

procedure TfmShellDialogColumnCustomization.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  edtWidth.Value := TdxShellColumnCustomizeItem(cxCheckListBox1.Items.Objects[cxCheckListBox1.ItemIndex]).Width;
  btnHide.Enabled :=  SelectedCheckItem.Enabled and SelectedCheckItem.Checked;
  btnShow.Enabled := SelectedCheckItem.Enabled and not SelectedCheckItem.Checked;
  btnMoveUp.Enabled := cxCheckListBox1.ItemIndex > 0;
  btnMoveDown.Enabled := (cxCheckListBox1.ItemIndex < cxCheckListBox1.Count - 1);
end;

procedure TfmShellDialogColumnCustomization.actShowExecute(Sender: TObject);
begin
  SelectedCheckItem.Checked := True;
  FocusControl(cxCheckListBox1);
end;

procedure TfmShellDialogColumnCustomization.actUpExecute(Sender: TObject);
var
  AIndex: Integer;
begin
  AIndex := Min(cxCheckListBox1.ItemIndex - 1, cxCheckListBox1.Count - 1);
  SelectedCheckItem.Index := AIndex;
  cxCheckListBox1.ItemIndex := AIndex;
  FocusControl(cxCheckListBox1);
end;

function TfmShellDialogColumnCustomization.Customize(AItems: TdxShellColumnCustomizeItems): Boolean;
var
  I: Integer;
  ACheckItem: TcxCheckListBoxItem;
  AIndex: Integer;
begin
  AItems.Sort;
  cxCheckListBox1.Items.BeginUpdate;
  try
    for I := 0 to AItems.Count - 1 do
    begin
      ACheckItem := cxCheckListBox1.Items.Add;
      ACheckItem.Text := AItems[I].Text;
      ACheckItem.Checked := AItems[I].VisibleIndex <> $FFFFFFFF;
      ACheckItem.Enabled := AItems[I].DetailIndex > 0;
      ACheckItem.ItemObject := AItems[I];
    end;
  finally
    cxCheckListBox1.Items.EndUpdate;
  end;
  cxCheckListBox1.ItemIndex := 0;
  Result := ShowModal = mrOk;
  if Result then
  begin
    AIndex := 0;
    for I := 0 to cxCheckListBox1.Count - 1 do
      if cxCheckListBox1.Items[I].Checked then
      begin
        (cxCheckListBox1.Items.Objects[I] as TdxShellColumnCustomizeItem).VisibleIndex := AIndex;
        Inc(AIndex);
      end
      else
        (cxCheckListBox1.Items.Objects[I] as TdxShellColumnCustomizeItem).VisibleIndex := $FFFFFFFF;
  end;
end;

procedure TfmShellDialogColumnCustomization.InitializeLookAndFeel(
  ALookAndFeel: TcxLookAndFeel);
begin
  dxLayoutCxLookAndFeel1.LookAndFeel.MasterLookAndFeel := ALookAndFeel;
  btnMoveUp.LookAndFeel.MasterLookAndFeel := ALookAndFeel;
  btnMoveDown.LookAndFeel.MasterLookAndFeel := ALookAndFeel;
  btnHide.LookAndFeel.MasterLookAndFeel := ALookAndFeel;
  btnShow.LookAndFeel.MasterLookAndFeel := ALookAndFeel;
  btnOk.LookAndFeel.MasterLookAndFeel := ALookAndFeel;
  btnCancel.LookAndFeel.MasterLookAndFeel := ALookAndFeel;
  edtWidth.Style.LookAndFeel.MasterLookAndFeel := ALookAndFeel;
  cxCheckListBox1.Style.LookAndFeel.MasterLookAndFeel := ALookAndFeel;
end;

procedure TfmShellDialogColumnCustomization.edtWidthPropertiesChange(
  Sender: TObject);
begin
  TdxShellColumnCustomizeItem(cxCheckListBox1.Items.Objects[cxCheckListBox1.ItemIndex]).Width := edtWidth.Value;
end;

function TfmShellDialogColumnCustomization.GetSelectedCheckItem: TcxCheckListBoxItem;
begin
  Result := cxCheckListBox1.Items[cxCheckListBox1.ItemIndex];
end;

procedure TfmShellDialogColumnCustomization.Localize;
begin
  liDetails.Caption := cxGetResourceString(@sdxDetails);
  liColumnWidth.Caption := cxGetResourceString(@sdxColumnWidthCaption);
  liSelectDetails.Caption := cxGetResourceString(@sdxSelectDetailsCaption);
  Caption := cxGetResourceString(@sdxChooseDetails);
  btnOk.Caption := cxGetResourceString(@cxSEditButtonOK);
  btnCancel.Caption := cxGetResourceString(@cxSEditButtonCancel);
  btnMoveUp.Caption := cxGetResourceString(@sdxMoveUp);
  btnMoveDown.Caption := cxGetResourceString(@sdxMoveDown);
  btnHide.Caption := cxGetResourceString(@sdxHide);
  btnShow.Caption := cxGetResourceString(@sdxShow);
end;

end.
