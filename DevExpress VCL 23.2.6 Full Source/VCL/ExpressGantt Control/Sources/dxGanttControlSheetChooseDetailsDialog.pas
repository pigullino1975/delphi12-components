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

unit dxGanttControlSheetChooseDetailsDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, Generics.Collections,
  dxCore, cxGeometry, dxForms,
  cxGraphics, cxControls, cxLookAndFeels, cxListBox,
  cxLookAndFeelPainters, cxClasses, dxLayoutContainer, dxLayoutControl,
  dxGanttControlCustomSheet, cxCheckBox, cxContainer, cxEdit, cxCustomListBox,
  cxCheckListBox, dxLayoutControlAdapters, Menus, StdCtrls, cxButtons,
  dxLayoutcxEditAdapters, cxTextEdit, cxMaskEdit, cxSpinEdit,
  dxLayoutLookAndFeels;

type
  { TdxGanttControlChooseDetailsDialogItem }

  TdxGanttControlChooseDetailsDialogItem = class
  strict private
    FColumn: TdxGanttControlSheetColumn;
    FWidth: Integer;
    procedure SetWidth(const Value: Integer);
  public
    constructor Create(AColumn: TdxGanttControlSheetColumn);
    property Column: TdxGanttControlSheetColumn read FColumn;
    property Width: Integer read FWidth write SetWidth;
  end;

  { TdxGanttControlChooseDetailsDialogForm }

  TdxGanttControlChooseDetailsDialogFormClass = class of TdxGanttControlChooseDetailsDialogForm;
  TdxGanttControlChooseDetailsDialogForm = class(TdxForm)
    lcMainGroup_Root: TdxLayoutGroup;
    lcMain: TdxLayoutControl;
    lliCaption: TdxLayoutLabeledItem;
    liItems: TdxLayoutItem;
    lgDetails: TdxLayoutGroup;
    lgButtons: TdxLayoutGroup;
    dxLayoutSeparatorItem1: TdxLayoutSeparatorItem;
    btnOk: TcxButton;
    btnCancel: TcxButton;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    seWidth: TcxSpinEdit;
    liWidth: TdxLayoutItem;
    lliWidthDescription: TdxLayoutLabeledItem;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel;
    procedure seWidthPropertiesEditValueChanged(Sender: TObject);
  strict private
    FListBox: TdxCustomCheckListBox;
    FItems: TObjectList<TdxGanttControlChooseDetailsDialogItem>;
    FIsWidthUpdating: Boolean;
    FOptions: TdxGanttControlSheetOptions;

    procedure ListBoxSelectionChangedHandler(Sender: TObject);

    procedure ApplyLocalization;
    procedure PopulateItems;

    function GetController: TdxGanttControlSheetController;
    function GetControlScaleFactor: TdxScaleFactor;
  protected
    procedure ApplyChanges;

    property Controller: TdxGanttControlSheetController read GetController;
    property ControlScaleFactor: TdxScaleFactor read GetControlScaleFactor;
  public
    constructor Create(AOptions: TdxGanttControlSheetOptions); reintroduce;
    destructor Destroy; override;
  end;

procedure ShowGanttControlSheetChooseDetailsDialog(AOptions: TdxGanttControlSheetOptions);

var
  dxGanttControlChooseDetailsDialogFormClass: TdxGanttControlChooseDetailsDialogFormClass = TdxGanttControlChooseDetailsDialogForm;

implementation

{$R *.dfm}

uses
  Math,
  dxGanttControlStrs;

const
  dxThisUnitName = 'dxGanttControlSheetChooseDetailsDialog';

type
  TdxGanttControlSheetControllerAccess = class(TdxGanttControlSheetController);
  TdxGanttControlSheetColumnAccess = class(TdxGanttControlSheetColumn);
  TdxCustomCheckListBoxAccess = class(TdxCustomCheckListBox);

  { TdxGanttControlCheckListBox }

  TdxGanttControlCheckListBox = class(TdxCustomCheckListBox)
  protected
    procedure CheckedChanged(AItemIndex: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function NeedHandleClick: Boolean; override;
  end;

{ TdxGanttControlCheckListBox }

procedure TdxGanttControlCheckListBox.CheckedChanged(AItemIndex: Integer);
var
  AColumn: TdxGanttControlSheetColumnAccess;
begin
  inherited CheckedChanged(AItemIndex);
  if not Checked[AItemIndex] then
  begin
    AColumn := TdxGanttControlSheetColumnAccess(TdxGanttControlChooseDetailsDialogItem(Items[AItemIndex].Data).Column);
    if AColumn.Visible and not AColumn.RealAllowHide then
      Checked[AItemIndex] := True;
  end;
end;

procedure TdxGanttControlCheckListBox.KeyDown(var Key: Word;
  Shift: TShiftState);
const
  ADirection: array[Boolean] of Integer = (-1, 1);
var
  ANewIndex: Integer;
begin
  if (Shift = [ssCtrl]) and (Key = Ord('A')) then
  begin
    SelectAll;
    Key := 0;
  end;
  if (Shift = [ssCtrl]) and (Key in [VK_UP, VK_DOWN]) then
  begin
    if ItemIndex <> -1 then
    begin
      ANewIndex := ItemIndex + ADirection[Key = VK_DOWN];
      ANewIndex := Min(Items.Count - 1, Max(0, ANewIndex));
      if ItemIndex <> ANewIndex then
      begin
        BeginUpdate;
        try
          Items.Move(ItemIndex, ANewIndex);
          ItemIndex := ANewIndex;
          SelectFocusedItem;
        finally
          EndUpdate;
        end;
      end;
    end;
    Key := 0;
  end;
  inherited KeyDown(Key, Shift);
end;

function TdxGanttControlCheckListBox.NeedHandleClick: Boolean;
begin
  Result := inherited NeedHandleClick and HitAtItemCheckBox(ItemIndex);
end;

{ TdxGanttControlChooseDetailsDialogItem }

constructor TdxGanttControlChooseDetailsDialogItem.Create(
  AColumn: TdxGanttControlSheetColumn);
begin
  inherited Create;
  FColumn := AColumn;
  FWidth := FColumn.Owner.Owner.ScaleFactor.Apply(FColumn.Width);
end;

procedure TdxGanttControlChooseDetailsDialogItem.SetWidth(const Value: Integer);
begin
  if TdxGanttControlSheetColumnAccess(Column).RealAllowSize then
    FWidth := Value;
end;

{ TdxGanttControlChooseDetailsDialogForm }

constructor TdxGanttControlChooseDetailsDialogForm.Create(AOptions: TdxGanttControlSheetOptions);
begin
  inherited Create(nil);
  FOptions := AOptions;
  FItems := TObjectList<TdxGanttControlChooseDetailsDialogItem>.Create;
  FListBox := TdxGanttControlCheckListBox.Create(Self);
  FListBox.MultiSelect := True;
  FListBox.IncrementalSearch := True;
  FListBox.OnSelectionChanged := ListBoxSelectionChangedHandler;
  TdxCustomCheckListBoxAccess(FListBox).DragMode := dmAutomatic;
  liItems.Control := FListBox;
  BiDiMode := FOptions.Control.BiDiMode;
  seWidth.Properties.MinValue := ControlScaleFactor.Apply(TdxGanttControlSheetColumn.MinWidth);
  ApplyLocalization;
  PopulateItems;
end;

destructor TdxGanttControlChooseDetailsDialogForm.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

function TdxGanttControlChooseDetailsDialogForm.GetController: TdxGanttControlSheetController;
begin
  Result := FOptions.Controller;
end;

function TdxGanttControlChooseDetailsDialogForm.GetControlScaleFactor: TdxScaleFactor;
begin
  Result := FOptions.ScaleFactor;
end;

procedure TdxGanttControlChooseDetailsDialogForm.ListBoxSelectionChangedHandler(
  Sender: TObject);
var
  AItem: TdxGanttControlChooseDetailsDialogItem;
  AValue: Integer;
  AEnabled: Boolean;
  I: Integer;
begin
  AValue := -1;
  FIsWidthUpdating := True;
  try
    for I := 0 to FListBox.Items.Count - 1 do
      if FListBox.Selected[I] then
      begin
        AItem := TdxGanttControlChooseDetailsDialogItem(FListBox.Items[I].Data);
        if AItem.Width <> AValue then
        begin
          if AValue = -1 then
            AValue := AItem.Width
          else
          begin
            AValue := -1;
            Break;
          end;
        end;
      end;
    if AValue = -1 then
      seWidth.EditValue := Null
    else
      seWidth.EditValue := AValue;
    AEnabled := FOptions.AllowColumnSize;
    for I := 0 to FListBox.Items.Count - 1 do
      if FListBox.Selected[I] then
      begin
        AItem := TdxGanttControlChooseDetailsDialogItem(FListBox.Items[I].Data);
        AEnabled := TdxGanttControlSheetColumnAccess(AItem.Column).RealAllowSize;
        if AEnabled then
          Break;
      end;
    seWidth.Enabled := AEnabled;
  finally
    FIsWidthUpdating := False;
  end;
end;

procedure TdxGanttControlChooseDetailsDialogForm.PopulateItems;
var
  I: Integer;
  AColumn: TdxGanttControlSheetColumn;
  AItem: TdxGanttControlChooseDetailsDialogItem;
  AListBoxItem: TdxCustomCheckListBoxItem;
begin
  FListBox.Items.BeginUpdate;
  try
    FListBox.Items.Clear;
    FItems.Clear;
    for I := 0 to FOptions.Columns.Count - 1 do
    begin
      AColumn := FOptions.Columns[I];
      if AColumn.Visible or TdxGanttControlSheetColumnAccess(AColumn).RealAllowInsert then
      begin
        AItem := TdxGanttControlChooseDetailsDialogItem.Create(AColumn);
        FItems.Add(AItem);
        AListBoxItem := FListBox.Items.AddObject(AColumn.Caption, AItem);
        AListBoxItem.Checked := AColumn.Visible;
      end;
    end;
    if FItems.Count > 0 then
    begin
      FListBox.ItemIndex := 0;
      TdxGanttControlCheckListBox(FListBox).SelectFocusedItem;
    end;
  finally
    FListBox.Items.EndUpdate;
  end;
end;

procedure TdxGanttControlChooseDetailsDialogForm.seWidthPropertiesEditValueChanged(
  Sender: TObject);
var
  I: Integer;
begin
  if FIsWidthUpdating or not VarIsNumeric(seWidth.EditingValue) then
    Exit;
  for I := 0 to FListBox.Items.Count - 1 do
    if FListBox.Selected[I] then
      TdxGanttControlChooseDetailsDialogItem(FListBox.Items[I].Data).Width := seWidth.EditValue;
end;

procedure TdxGanttControlChooseDetailsDialogForm.ApplyChanges;

  procedure ApplyColumnChanges(AItem: TdxGanttControlChooseDetailsDialogItem; AIndex: Integer; AVisible: Boolean);
  begin
    with TdxGanttControlSheetMoveColumnCommand.Create(Controller, AItem.Column.Index, AIndex) do
    try
      Execute;
    finally
      Free;
    end;
    if AVisible then
    begin
      with TdxGanttControlSheetShowColumnCommand.Create(Controller, AItem.Column.Index) do
      try
        Execute;
      finally
        Free;
      end;
    end
    else
    begin
      with TdxGanttControlSheetHideColumnCommand.Create(Controller, AItem.Column.Index) do
      try
        Execute;
      finally
        Free;
      end;
    end;
    with TdxGanttControlSheetResizeColumnCommand.Create(Controller, AItem.Column, ControlScaleFactor.Revert(AItem.Width)) do
    try
      Execute;
    finally
      Free;
    end;

  end;

var
  I: Integer;
begin
  FOptions.Control.BeginUpdate;
  try
    for I := 0 to FListBox.Items.Count - 1 do
      ApplyColumnChanges(TdxGanttControlChooseDetailsDialogItem(FListBox.Items[I].Data), I, FListBox.Checked[I]);
  finally
    FOptions.Control.EndUpdate;
  end;
end;

procedure TdxGanttControlChooseDetailsDialogForm.ApplyLocalization;
begin
  Caption := cxGetResourceString(@sdxGanttControlChooseDetailsDialogCaption);
  liItems.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlChooseDetailsDialogDetails);
  btnOk.Caption := cxGetResourceString(@sdxGanttControlDialogOk);
  btnCancel.Caption := cxGetResourceString(@sdxGanttControlDialogCancel);
  lliCaption.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlChooseDetailsDialogDescription);
  lliWidthDescription.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlChooseDetailsDialogColumnWidthDescription);
end;

procedure ShowGanttControlSheetChooseDetailsDialog(AOptions: TdxGanttControlSheetOptions);
var
  AForm: TdxGanttControlChooseDetailsDialogForm;
begin
  AForm := dxGanttControlChooseDetailsDialogFormClass.Create(AOptions);
  try
    cxDialogsMetricsStore.InitDialog(AForm);
    if AForm.ShowModal = mrOk then
      AForm.ApplyChanges;
    cxDialogsMetricsStore.StoreMetrics(AForm);
  finally
    AForm.Free;
  end;
end;

end.
