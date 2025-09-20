{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressMemData                                           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSMEMDATA AND ALL                }
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

unit dxmdseda;

interface

{$I cxVer.inc}

uses
  DesignIntf, Windows, Classes, Controls, Forms, StdCtrls, DB, dxmdaset, ExtCtrls, Graphics, dxForms, TypInfo;

type
  IFormDesigner = IDesigner;

  TfrmdxMemDataAddField = class(TdxForm)
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    pnlMain: TPanel;
    gbFieldProp: TGroupBox;
    edName: TEdit;
    cbFieldType: TComboBox;
    edComponent: TEdit;
    edSize: TEdit;
    gbFieldType: TRadioGroup;
    gbLookup: TGroupBox;
    cbLookupField: TComboBox;
    cbKeyField: TComboBox;
    cbDataSet: TComboBox;
    cbResultField: TComboBox;
    procedure cbFieldTypeChange(Sender: TObject);
    procedure gbFieldTypeClick(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure edSizeKeyPress(Sender: TObject; var Key: Char);
    procedure edComponentChange(Sender: TObject);
    procedure cbDataSetExit(Sender: TObject);
  private
    FData: TdxMemData;
    FLookupDS: TDataSet;
    FFormDesigner: IFormDesigner;
    FTypeInfo: PPropInfo;
    procedure GetDataSets(const AComponentName: string);
  public
    constructor Create(AData: TdxMemData; AX, AY: Integer; AFormDesigner: IFormDesigner); reintroduce;
  end;

function GetMemDataNewFieldType(Data: TdxMemData; X, Y: Integer; FormDesigner: IFormDesigner): TField;

implementation

{$R *.dfm}

uses
  SysUtils, Consts, RTLConsts, dxCore;

const
  dxThisUnitName = 'dxmdseda';

type
  TdxMemDataAccess = class(TdxMemData);

  TDummyField = class(TField)
  published
    property DataType;
  end;

function GetMemDataNewFieldType(Data: TdxMemData; X, Y: Integer; FormDesigner: IFormDesigner): TField;
var
  AForm: TfrmdxMemDataAddField;
  FieldType: TFieldType;
begin
  Result := nil;
  AForm := TfrmdxMemDataAddField.Create(Data, X, Y, FormDesigner);
  try
    if AForm.ShowModal = mrOk then
    begin
      FieldType := TFieldType(GetEnumValue(AForm.FTypeInfo.PropType^, AForm.cbFieldType.Text));
      Result := TdxMemDataAccess(Data).GetFieldClass(FieldType).Create(AForm.FData.Owner);
      try
        Result.FieldName := AForm.edName.Text;
        Result.DataSet := AForm.FData;
        Result.Name := AForm.edComponent.Text;
      except
        Result.Free;
        raise;
      end;
      try
        if AForm.edSize.Text <> '' then
          TStringField(Result).Size := StrToInt(AForm.edSize.Text);
      except
      end;
      Result.Calculated := AForm.gbFieldtype.ItemIndex = 1;
      Result.Lookup := AForm.gbFieldtype.ItemIndex = 2;
      if Result.Lookup then
      begin
        Result.KeyFields := AForm.cbKeyField.Text;
        Result.LookupDataSet := AForm.FLookupDS;
        Result.LookupKeyFields := AForm.cbLookupField.Text;
        Result.LookupResultField := AForm.cbResultField.Text;
      end;
      if AForm.FFormDesigner <> nil then
        AForm.FFormDesigner.Modified;
    end;
  finally
    AForm.Free;
  end;
end;

procedure TfrmdxMemDataAddField.cbFieldTypeChange(Sender: TObject);
begin
  edSize.Enabled := (cbFieldType.Text = 'ftString') or (cbFieldType.Text = 'ftWideString');
  if not edSize.Enabled then
    edSize.Text := '';
end;

constructor TfrmdxMemDataAddField.Create(AData: TdxMemData; AX,
  AY: Integer; AFormDesigner: IFormDesigner);
var
  FieldType: TFieldType;
  I: Integer;
begin
  inherited Create(nil);
  FData := AData;
  FFormDesigner := AFormDesigner;
  FTypeInfo := GetPropInfo(TDummyField.ClassInfo, 'DataType');
  if FTypeInfo <> nil then
  begin
    for FieldType := Low(TFieldType) to High(TFieldType) do
      if FData.SupportedFieldType(FieldType) then
        cbFieldType.Items.Add(GetEnumName(FTypeInfo.PropType^, Integer(FieldType)));

    cbFieldType.ItemIndex := 0;
    for I := 0 to FData.FieldCount - 1 do
      if (FData.Fields[I].Owner = FData.Owner) and (FData.Fields[I].FieldName <> '') then
        cbKeyField.Items.Add(FData.Fields[I].FieldName);

    FFormDesigner.GetComponentNames(GetTypeData(TDataset.ClassInfo), GetDataSets);
    Left := AX;
    Top := AY;
  end;
end;

procedure TfrmdxMemDataAddField.gbFieldTypeClick(Sender: TObject);
begin
  cbKeyField.Enabled := gbFieldtype.ItemIndex = 2;
  cbDataSet.Enabled := cbKeyField.Enabled;
  cbLookupField.Enabled := cbKeyField.Enabled;
  cbResultField.Enabled := cbKeyField.Enabled;
  if not cbResultField.Enabled then
  begin
    cbKeyField.ItemIndex := -1;
    cbDataSet.Text := '';
    cbLookupField.ItemIndex := -1;
    cbResultField.ItemIndex := -1;
    FLookupDS := nil;
  end;
end;

procedure TfrmdxMemDataAddField.edNameChange(Sender: TObject);
begin
  edComponent.Text := FData.Name + edName.Text;
  btnOk.Enabled := (edComponent.Text <> '') and (edName.Text <> '');
end;

procedure TfrmdxMemDataAddField.edSizeKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not dxCharInSet(Key, [#8, '0'..'9']) then
  begin
    Key := #0;
    MessageBeep(0);
  end;
end;

procedure TfrmdxMemDataAddField.edComponentChange(Sender: TObject);
begin
  btnOk.Enabled := (edComponent.Text <> '') and (edName.Text <> '');
end;

procedure TfrmdxMemDataAddField.cbDataSetExit(Sender: TObject);
var
  Component: TComponent;
  I: Integer;
begin
  FLookupDS := nil;
  cbLookupField.Items.Clear;
  cbResultField.Items.Clear;
  if not (csDesigning in FData.ComponentState) then
    Exit;
  if cbDataSet.Text = '' then
    Component := nil
  else
  begin
    Component := FFormDesigner.GetComponent(cbDataSet.Text);
    if not (Component is TDataSet) then
    begin
      raise EPropertyError.Create(SInvalidPropertyValue);
      Component := nil;
      cbDataSet.Text := '';
    end;
  end;
  if Component <> nil then
  begin
    FLookupDS := TDataSet(Component);
    if FLookupDS.Active then
    begin
      for I := 0 to FLookupDS.FieldCount - 1 do
        if FLookupDS.Fields[I].FieldName <> '' then
          cbLookupField.Items.Add(FLookupDS.Fields[I].FieldName)
    end
    else
    begin
      FLookupDS.FieldDefs.Update;
      for I := 0 to FLookupDS.FieldDefs.Count - 1 do
        if FLookupDS.FieldDefs[I].Name <> '' then
          cbLookupField.Items.Add(FLookupDS.FieldDefs[I].Name);
    end;
    cbResultField.Items.Assign(cbLookupField.Items);
  end;
end;

procedure TfrmdxMemDataAddField.GetDataSets(const AComponentName: string);
begin
  cbDataSet.Items.Add(AComponentName);
end;

end.
