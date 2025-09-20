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

unit cxSplitterEditor;

{$I cxVer.inc}

interface

uses
  Windows, Classes, Controls, Dialogs, ExtCtrls, Forms, Graphics, Messages,
  StdCtrls, SysUtils, Variants,
  cxButtons, cxCheckBox, cxContainer, cxControls, cxEdit,
  cxGroupBox, cxListBox, cxLookAndFeelPainters, cxLookAndFeels, cxMaskEdit,
  cxRadioGroup, cxSpinEdit, cxSplitter, cxTextEdit, cxTrackBar, cxGraphics,
  Menus, dxLayoutcxEditAdapters, dxLayoutControlAdapters, cxClasses,
  dxLayoutLookAndFeels, dxLayoutContainer, cxCustomListBox, dxLayoutControl;


type
  TcxSplitEditor = class(TForm)
    cxBtnOK: TcxButton;
    cxBtnCancel: TcxButton;
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    cxRbHzNone: TcxRadioButton;
    cxCbHzVisible: TcxCheckBox;
    cxTbHzWidth: TcxTrackBar;
    cxRbHzMp8: TcxRadioButton;
    cxRbHzXp: TcxRadioButton;
    cxRbHzMp9: TcxRadioButton;
    cxRbHzSimple: TcxRadioButton;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutSkinLookAndFeel1: TdxLayoutSkinLookAndFeel;
    cxCbAhd: TcxCheckBox;
    cxCbAp: TcxCheckBox;
    cxCbSnap: TcxCheckBox;
    cxCbRu: TcxCheckBox;
    cxSeMs: TcxSpinEdit;
    cxSePao: TcxSpinEdit;
    dxLayoutGroup2: TdxLayoutGroup;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutGroup3: TdxLayoutGroup;
    dxLayoutItem5: TdxLayoutItem;
    dxLayoutLabeledItem1: TdxLayoutLabeledItem;
    dxLayoutItem6: TdxLayoutItem;
    dxLayoutGroup4: TdxLayoutGroup;
    dxLayoutLabeledItem2: TdxLayoutLabeledItem;
    dxLayoutItem7: TdxLayoutItem;
    dxLayoutItem8: TdxLayoutItem;
    dxLayoutGroup5: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    dxLayoutItem9: TdxLayoutItem;
    dxLayoutItem10: TdxLayoutItem;
    dxLayoutGroup6: TdxLayoutGroup;
    dxLayoutItem11: TdxLayoutItem;
    dxLayoutItem12: TdxLayoutItem;
    dxLayoutGroup7: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup;
    dxLayoutItem13: TdxLayoutItem;
    dxLayoutItem14: TdxLayoutItem;
    dxLayoutLabeledItem3: TdxLayoutLabeledItem;
    dxLayoutItem15: TdxLayoutItem;
    dxLayoutGroup8: TdxLayoutGroup;
    dxLayoutItem17: TdxLayoutItem;
    dxLayoutItem18: TdxLayoutItem;
    cxGroupBox1: TcxGroupBox;
    cxGroupBox4: TcxGroupBox;
    cxListBox1: TcxListBox;
    cxSplit: TcxSplitter;
    cxListBox2: TcxListBox;
    dxLayoutItem3: TdxLayoutItem;
    procedure cxCbAhdClick(Sender: TObject);
    procedure cxCbApClick(Sender: TObject);
    procedure cxCbSnapClick(Sender: TObject);
    procedure cxCbRuClick(Sender: TObject);
    procedure cxSeMsPropertiesChange(Sender: TObject);
    procedure cxSePaoPropertiesChange(Sender: TObject);
    procedure cxCbHzVisiblePropertiesChange(Sender: TObject);
    procedure cxRbHzNoneClick(Sender: TObject);
    procedure cxRbHzMp8Click(Sender: TObject);
    procedure cxTbHzWidthPropertiesChange(Sender: TObject);
  public
    procedure SetSplitControls;
  end;

procedure ShowSplitterEditor(ASplitter: TcxSplitter);

implementation

{$R *.dfm}

uses
  cxExtEditConsts;

const
  dxThisUnitName = 'cxSplitterEditor';

procedure ShowSplitterEditor(ASplitter: TcxSplitter);
var
  AOwnerCaption: string;
begin
  with TcxSplitEditor.Create(Application) do
  try
    if ASplitter.Owner <> nil then
      AOwnerCaption := ASplitter.Owner.Name + '.'
    else
      AOwnerCaption := '';
    Caption := Format('%s%s - Splitter Control', [AOwnerCaption, ASplitter.Name]);
    cxSplit.AllowHotZoneDrag := ASplitter.AllowHotZoneDrag;
    cxSplit.AutoPosition := ASplitter.AutoPosition;
    cxSplit.AutoSnap := ASplitter.AutoSnap;
    cxSplit.PositionAfterOpen := ASplitter.PositionAfterOpen;
    cxSplit.MinSize := ASplitter.MinSize;
    cxSplit.ResizeUpdate := ASplitter.ResizeUpdate;
    if Assigned(ASplitter.HotZone) then
    begin
      cxSplit.HotZoneClassName := ASplitter.HotZoneClassName;
      cxSplit.HotZone.Assign(ASplitter.Hotzone);
    end;
    SetSplitControls;
    if ShowModal = mrOK then
    begin
      ASplitter.AllowHotZoneDrag := cxSplit.AllowHotZoneDrag;
      ASplitter.AutoPosition := cxSplit.AutoPosition;
      ASplitter.AutoSnap := cxSplit.AutoSnap;
      ASplitter.PositionAfterOpen := cxSplit.PositionAfterOpen;
      ASplitter.MinSize := cxSplit.MinSize;
      ASplitter.ResizeUpdate := cxSplit.ResizeUpdate;
      if Assigned(cxSplit.HotZone) then
      begin
        ASplitter.HotZoneClassName := cxSplit.HotZoneClassName;
        ASplitter.HotZone.Assign(cxSplit.HotZone);
      end
      else
        ASplitter.HotZoneClassName := '';
      SetDesignerModified(ASplitter);
    end;
  finally
    Free;
  end;
end;

procedure TcxSplitEditor.cxCbAhdClick(Sender: TObject);
begin
  cxSplit.AllowHotZoneDrag := cxCbAhd.Checked;
end;

procedure TcxSplitEditor.cxCbApClick(Sender: TObject);
begin
  cxSplit.AutoPosition := cxCbAp.Checked;
end;

procedure TcxSplitEditor.cxCbSnapClick(Sender: TObject);
begin
  cxSplit.AutoSnap := cxCbSnap.Checked;
end;

procedure TcxSplitEditor.cxCbRuClick(Sender: TObject);
begin
  cxSplit.ResizeUpdate := cxCbRu.Checked;
end;

procedure TcxSplitEditor.cxSeMsPropertiesChange(Sender: TObject);
begin
  cxSplit.MinSize := Integer(cxSeMs.Value);
end;

procedure TcxSplitEditor.cxSePaoPropertiesChange(Sender: TObject);
begin
  cxSplit.PositionAfterOpen := Integer(cxSePao.Value);
end;

procedure TcxSplitEditor.cxCbHzVisiblePropertiesChange(Sender: TObject);
begin
  if Assigned(cxSplit.Hotzone) then
    cxSplit.HotZone.Visible := cxCbHzVisible.Checked;
end;

procedure TcxSplitEditor.cxRbHzNoneClick(Sender: TObject);
begin
  cxCbHzVisible.Checked := False;
  cxSplit.HotZoneClassName := '';
  cxCbHzVisible.Enabled := False;
  cxTbHzWidth.Enabled := False;
end;

procedure TcxSplitEditor.cxRbHzMp8Click(Sender: TObject);
var
  vText: string;
  vHzcl: TcxHotZoneStyleClass;
begin
  vText := TcxRadioButton(Sender).Hint;
  vHzCl := TcxHotZoneStyleClass(GetRegisteredHotZoneStyles.FindByClassName(vText));
  if vHzCl = nil then
    vHzCl := TcxHotZoneStyleClass(GetRegisteredHotZoneStyles.FindByDescription(vText));
  cxSplit.HotZoneStyleClass := vHzCl;
  cxCbHzVisible.Enabled := True;
  cxCbHzVisible.Checked := True;
  cxTbHzWidth.Enabled := True;
  cxTbHzWidth.EditValue := Variant(cxSplit.HotZone.SizePercent);
end;

procedure TcxSplitEditor.cxTbHzWidthPropertiesChange(Sender: TObject);
begin
  if Assigned(cxSplit.HotZone) then
    cxSplit.HotZone.SizePercent := Integer(cxTbHzWidth.EditValue);
end;

Procedure TcxSplitEditor.SetSplitControls;
Var
  vHzt: Integer;
Begin
  cxCbAhd.Checked := cxSplit.AllowHotZoneDrag;
  cxCbAp.Checked := cxSplit.AutoPosition;
  cxSePao.Value := Variant(cxSplit.PositionAfterOpen);
  cxCbSnap.Checked := cxSplit.AutoSnap;
  cxSeMs.Value := Variant(cxSplit.MinSize);
  cxCbRu.Checked := cxSplit.ResizeUpdate;
  if Assigned(cxSplit.HotZone) then
  begin
    cxTbHzWidth.EditValue := TcxEditValue(cxSplit.HotZone.SizePercent);
    cxCbHzVisible.Checked := cxSplit.HotZone.Visible;
    vHzt := GetRegisteredHotZoneStyles.GetIndexByClass(cxSplit.HotZone.ClassType);
    case vHzt of
      0: cxRbHzMp8.Checked := True;
      1: cxRbHzMp9.Checked := True;
      2: cxRbHzXp.Checked := True;
      3: cxRbHzSimple.Checked := True;
    end;
  end
  else
  begin
    cxRbHzNone.Checked := True;
  end;
  cxTbHzWidth.Enabled := Assigned(cxSplit.HotZone);
end;

end.
