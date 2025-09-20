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

unit dxGanttControlExtendedAttributeCommands;

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  System.UITypes, System.Contnrs,
  Types, SysUtils, Classes, Graphics, ImgList, Windows, Controls, Dialogs,
  Generics.Defaults, Generics.Collections, Forms, StdCtrls, Variants,
  dxCoreClasses, cxGraphics, cxCustomCanvas, cxGeometry, cxClasses, cxControls,
  cxVariants, cxEdit, cxDrawTextUtils,
  dxGanttControlCustomClasses,
  dxGanttControlCustomDataModel,
  dxGanttControlDataModel,
  dxGanttControlExtendedAttributes,
  dxGanttControlCommands;

type
  TdxGetGanttControlExtendedAttributeValues = reference to function: TdxGanttControlExtendedAttributeValues;

  { TdxGanttControlCreateExtendedAttributeValueHistoryItem }

  TdxGanttControlCreateExtendedAttributeValueHistoryItem = class(TdxGanttControlCreateItemHistoryItem)
  strict private
    FGetExtendedAttributes: TdxGetGanttControlExtendedAttributeValues;
  protected
    function GetList: TdxGanttControlModelElementList; override;
  public
    constructor Create(AHistory: TdxGanttControlHistory; const AGetExtendedAttributes: TdxGetGanttControlExtendedAttributeValues); reintroduce;
  end;

  { TdxGanttControlRemoveExtendedAttributeValueHistoryItem }

  TdxGanttControlRemoveExtendedAttributeValueHistoryItem = class(TdxGanttControlRemoveItemHistoryItem)
  strict private
    FGetExtendedAttributes: TdxGetGanttControlExtendedAttributeValues;
  protected
    function GetList: TdxGanttControlModelElementList; override;
  public
    constructor Create(AHistory: TdxGanttControlHistory; const AGetExtendedAttributes: TdxGetGanttControlExtendedAttributeValues); reintroduce;
  end;

  { TdxGanttControlExtendedAttributeValueHistoryItem }

  TdxGanttControlExtendedAttributeValueHistoryItem = class abstract(TdxGanttControlHistoryItem)
  strict private
    FExtendedAttribute: TdxGanttControlExtendedAttributeValue;
  protected
    property ExtendedAttribute: TdxGanttControlExtendedAttributeValue read FExtendedAttribute;
  public
    constructor Create(AHistory: TdxGanttControlHistory; AExtendedAttribute: TdxGanttControlExtendedAttributeValue); reintroduce; virtual;
  end;

  { TdxGanttControlExtendedAttributeValueSetAssignedValueHistoryItem }

  TdxGanttControlExtendedAttributeValueSetAssignedValueHistoryItem = class(TdxGanttControlExtendedAttributeValueHistoryItem)
  protected
    FAssignedValue: TdxGanttExtendedAttributeValueAssignedValue;
    procedure DoUndo; override;
  end;

  { TdxGanttControlExtendedAttributeValueResetAssignedValueHistoryItem }

  TdxGanttControlExtendedAttributeValueResetAssignedValueHistoryItem = class(TdxGanttControlExtendedAttributeValueHistoryItem)
  protected
    FAssignedValue: TdxGanttExtendedAttributeValueAssignedValue;
    procedure DoRedo; override;
  end;

  { TdxGanttControlExtendedAttributeValueSetAssignedValueHistoryItem }

  TdxGanttControlExtendedAttributeValueChangeValueHistoryItem = class(TdxGanttControlExtendedAttributeValueHistoryItem)
  protected
    FOldValue: Variant;
    FNewValue: Variant;
    procedure DoRedo; override;
    procedure DoUndo; override;
  end;

  { TdxGanttControlExtendedAttributeValueChangeDurationFormatHistoryItem }

  TdxGanttControlExtendedAttributeValueChangeDurationFormatHistoryItem = class(TdxGanttControlExtendedAttributeValueHistoryItem)
  protected
    FOldDurationFormat: TdxDurationFormat;
    FNewDurationFormat: TdxDurationFormat;
    procedure DoRedo; override;
    procedure DoUndo; override;
  end;

  { TdxGanttControlExtendedAttributeValueChangePropertyCommand }

  TdxGanttControlExtendedAttributeValueChangePropertyCommand = class(TdxGanttControlCommand)
  strict private
    FExtendedAttribute: TdxGanttControlExtendedAttributeValue;
    FNewValue: Variant;
    procedure ResetAssignedValue(AAssignedValue: TdxGanttExtendedAttributeValueAssignedValue);
    procedure SetAssignedValue(AAssignedValue: TdxGanttExtendedAttributeValueAssignedValue);
    procedure SetDuration;
    procedure SetValue(const AValue: Variant);
  protected
    procedure DoExecute; override;
  public
    constructor Create(AControl: TdxGanttControlBase; AExtendedAttribute: TdxGanttControlExtendedAttributeValue; const ANewValue: Variant); reintroduce; virtual;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlChangeExtendedAttributeValueCommand }

  TdxGanttControlChangeExtendedAttributeValueCommand = class(TdxGanttControlCommand)
  strict private
    FGetExtendedAttributes: TdxGetGanttControlExtendedAttributeValues;
    FFieldName: string;
    FNewValue: Variant;
    procedure DeleteExtendedAttribute;
    function GetExtendedAttributeValue: TdxGanttControlExtendedAttributeValue;
  protected
    procedure DoExecute; override;
  public
    constructor Create(AControl: TdxGanttControlBase; const AGetExtendedAttributes: TdxGetGanttControlExtendedAttributeValues;
      AFieldName: string; const ANewValue: Variant); reintroduce; virtual;
    function Enabled: Boolean; override;
  end;

implementation

uses
  dxMeasurementUnitEdit,
  dxGanttControlUtils,
  dxGanttControlCalendars;

const
  dxThisUnitName = 'dxGanttControlExtendedAttributeCommands';

type
  TdxGanttControlExtendedAttributeValuesAccess = class(TdxGanttControlExtendedAttributeValues);
  TdxMeasurementUnitEditHelperAccess = class(TdxMeasurementUnitEditHelper);
  TdxGanttControlDataModelPropertiesAccess = class(TdxGanttControlDataModelProperties);

{ TdxGanttControlCreateExtendedAttributeValueHistoryItem }

constructor TdxGanttControlCreateExtendedAttributeValueHistoryItem.Create(
  AHistory: TdxGanttControlHistory;
  const AGetExtendedAttributes: TdxGetGanttControlExtendedAttributeValues);
begin
  inherited Create(AHistory, nil);
  FGetExtendedAttributes := AGetExtendedAttributes;
end;

function TdxGanttControlCreateExtendedAttributeValueHistoryItem.GetList: TdxGanttControlModelElementList;
begin
  Result := FGetExtendedAttributes;
end;

{ TdxGanttControlRemoveExtendedAttributeValueHistoryItem }

constructor TdxGanttControlRemoveExtendedAttributeValueHistoryItem.Create(
  AHistory: TdxGanttControlHistory;
  const AGetExtendedAttributes: TdxGetGanttControlExtendedAttributeValues);
begin
  inherited Create(AHistory, nil);
  FGetExtendedAttributes := AGetExtendedAttributes;
end;

function TdxGanttControlRemoveExtendedAttributeValueHistoryItem.GetList: TdxGanttControlModelElementList;
begin
  Result := FGetExtendedAttributes;
end;

{ TdxGanttControlExtendedAttributeValueHistoryItem }

constructor TdxGanttControlExtendedAttributeValueHistoryItem.Create(
  AHistory: TdxGanttControlHistory;
  AExtendedAttribute: TdxGanttControlExtendedAttributeValue);
begin
  inherited Create(AHistory);
  FExtendedAttribute := AExtendedAttribute;
end;

{ TdxGanttControlExtendedAttributeValueSetAssignedValueHistoryItem }

procedure TdxGanttControlExtendedAttributeValueSetAssignedValueHistoryItem.DoUndo;
begin
  inherited DoUndo;
  ExtendedAttribute.ResetValue(FAssignedValue);
end;

{ TdxGanttControlExtendedAttributeValueResetAssignedValueHistoryItem }

procedure TdxGanttControlExtendedAttributeValueResetAssignedValueHistoryItem.DoRedo;
begin
  inherited DoRedo;
  ExtendedAttribute.ResetValue(FAssignedValue);
end;

{ TdxGanttControlExtendedAttributeValueChangeValueHistoryItem }

procedure TdxGanttControlExtendedAttributeValueChangeValueHistoryItem.DoRedo;
begin
  inherited DoRedo;
  FOldValue := ExtendedAttribute.Value;
  ExtendedAttribute.Value := FNewValue;
end;

procedure TdxGanttControlExtendedAttributeValueChangeValueHistoryItem.DoUndo;
begin
  inherited DoUndo;
  ExtendedAttribute.Value := FOldValue;
end;

{ TdxGanttControlExtendedAttributeValueChangeDurationFormatHistoryItem }

procedure TdxGanttControlExtendedAttributeValueChangeDurationFormatHistoryItem.DoRedo;
begin
  inherited DoRedo;
  FOldDurationFormat := ExtendedAttribute.DurationFormat;
  ExtendedAttribute.DurationFormat := FNewDurationFormat;
end;

procedure TdxGanttControlExtendedAttributeValueChangeDurationFormatHistoryItem.DoUndo;
begin
  inherited DoUndo;
  ExtendedAttribute.DurationFormat := FOldDurationFormat;
end;

{ TdxGanttControlExtendedAttributeValueChangePropertyCommand }

constructor TdxGanttControlExtendedAttributeValueChangePropertyCommand.Create(
  AControl: TdxGanttControlBase; AExtendedAttribute: TdxGanttControlExtendedAttributeValue;
  const ANewValue: Variant);
begin
  inherited Create(AControl);
  FExtendedAttribute := AExtendedAttribute;
  FNewValue := ANewValue;
end;

procedure TdxGanttControlExtendedAttributeValueChangePropertyCommand.DoExecute;
begin
  inherited DoExecute;
  if FExtendedAttribute.&Type = TdxGanttControlExtendedAttributeCFType.Duration then
    SetDuration
  else
    SetValue(FNewValue);
end;

function TdxGanttControlExtendedAttributeValueChangePropertyCommand.Enabled: Boolean;
begin
  Result := inherited Enabled;
end;

procedure TdxGanttControlExtendedAttributeValueChangePropertyCommand.ResetAssignedValue(
  AAssignedValue: TdxGanttExtendedAttributeValueAssignedValue);
var
  AHistoryItem: TdxGanttControlExtendedAttributeValueResetAssignedValueHistoryItem;
  AHistory: TdxGanttControlHistory;
begin
  if not FExtendedAttribute.IsValueAssigned(AAssignedValue) then
    Exit;
  AHistory := Control.History;
  AHistoryItem := TdxGanttControlExtendedAttributeValueResetAssignedValueHistoryItem.Create(AHistory, FExtendedAttribute);
  AHistoryItem.FAssignedValue := AAssignedValue;
  AHistory.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

procedure TdxGanttControlExtendedAttributeValueChangePropertyCommand.SetAssignedValue(
  AAssignedValue: TdxGanttExtendedAttributeValueAssignedValue);
var
  AHistoryItem: TdxGanttControlExtendedAttributeValueSetAssignedValueHistoryItem;
  AHistory: TdxGanttControlHistory;
begin
  if FExtendedAttribute.IsValueAssigned(AAssignedValue) then
    Exit;
  AHistory := Control.History;
  AHistoryItem := TdxGanttControlExtendedAttributeValueSetAssignedValueHistoryItem.Create(AHistory, FExtendedAttribute);
  AHistoryItem.FAssignedValue := AAssignedValue;
  AHistory.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

procedure TdxGanttControlExtendedAttributeValueChangePropertyCommand.SetDuration;

  procedure DoSetDurationFormat(ADurationFormat: TdxDurationFormat);
  var
    AHistoryItem: TdxGanttControlExtendedAttributeValueChangeDurationFormatHistoryItem;
    AHistory: TdxGanttControlHistory;
  begin
    if not FExtendedAttribute.IsValueAssigned(TdxGanttExtendedAttributeValueAssignedValue.DurationFormat) then
      SetAssignedValue(TdxGanttExtendedAttributeValueAssignedValue.Value);
    AHistory := Control.History;
    AHistoryItem := TdxGanttControlExtendedAttributeValueChangeDurationFormatHistoryItem.Create(AHistory, FExtendedAttribute);
    AHistoryItem.FNewDurationFormat := ADurationFormat;
    AHistory.AddItem(AHistoryItem);
    AHistoryItem.Execute;
  end;

var
  AValueStr, ADescription, ADuration: string;
  ADurationFormat: TdxDurationFormat;
  AValue: Double;
begin
  if VarIsNull(FNewValue) or (Trim(VarToStr(FNewValue)) = '') then
  begin
    ResetAssignedValue(TdxGanttExtendedAttributeValueAssignedValue.Value);
    ResetAssignedValue(TdxGanttExtendedAttributeValueAssignedValue.DurationFormat);
  end
  else
  begin
    TdxMeasurementUnitEditHelperAccess.ExtractActualValueAndDescriptionStrings(FNewValue, AValueStr, ADescription);
    ADurationFormat := TdxGanttControlDurationFieldHelper.GetDurationFormat(ADescription, TdxGanttControlDataModelPropertiesAccess(DataModel.Properties).GetActualDurationFormat);
    if not TryStrToFloat(AValueStr, AValue) then
      AValue := 0;
    ADuration := TdxGanttControlDuration.Create(AValue, ADurationFormat).ToString;
    SetValue(ADuration);
    DoSetDurationFormat(ADurationFormat);
  end;
end;

procedure TdxGanttControlExtendedAttributeValueChangePropertyCommand.SetValue(
  const AValue: Variant);
var
  AHistoryItem: TdxGanttControlExtendedAttributeValueChangeValueHistoryItem;
  AHistory: TdxGanttControlHistory;
begin
  if not FExtendedAttribute.IsValueAssigned(TdxGanttExtendedAttributeValueAssignedValue.Value) then
    SetAssignedValue(TdxGanttExtendedAttributeValueAssignedValue.Value);
  AHistory := Control.History;
  AHistoryItem := TdxGanttControlExtendedAttributeValueChangeValueHistoryItem.Create(AHistory, FExtendedAttribute);
  AHistoryItem.FNewValue := AValue;
  AHistory.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

{ TdxGanttControlChangeExtendedAttributeValueCommand }

constructor TdxGanttControlChangeExtendedAttributeValueCommand.Create(
  AControl: TdxGanttControlBase;
  const AGetExtendedAttributes: TdxGetGanttControlExtendedAttributeValues; AFieldName: string;
  const ANewValue: Variant);
begin
  inherited Create(AControl);
  FGetExtendedAttributes := AGetExtendedAttributes;
  FFieldName := AFieldName;
  FNewValue := ANewValue;
end;

procedure TdxGanttControlChangeExtendedAttributeValueCommand.DeleteExtendedAttribute;
var
  AValue: TdxGanttControlExtendedAttributeValue;
  AHistoryItem: TdxGanttControlRemoveItemHistoryItem;
  AHistory: TdxGanttControlHistory;
begin
  AValue := FGetExtendedAttributes[FFieldName];
  if AValue = nil then
    Exit;
  AHistory := Control.History;
  AHistoryItem := TdxGanttControlRemoveExtendedAttributeValueHistoryItem.Create(AHistory, FGetExtendedAttributes);
  AHistoryItem.Index := FGetExtendedAttributes.IndexOf(AValue);
  AHistory.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

procedure TdxGanttControlChangeExtendedAttributeValueCommand.DoExecute;
var
  AExtendedAttribute: TdxGanttControlExtendedAttributeValue;
begin
  inherited DoExecute;
  if VarIsNull(FNewValue) then
    DeleteExtendedAttribute
  else
  begin
    AExtendedAttribute := GetExtendedAttributeValue;
    with TdxGanttControlExtendedAttributeValueChangePropertyCommand.Create(Control, AExtendedAttribute, FNewValue) do
    try
      DoExecute;
    finally
      Free;
    end;
  end;
end;

function TdxGanttControlChangeExtendedAttributeValueCommand.Enabled: Boolean;
var
  AExtendedAttribute: TdxGanttControlExtendedAttributeValue;
begin
  Result := inherited Enabled;
  if Result then
  begin
    if (FGetExtendedAttributes[FFieldName] = nil) and VarIsNull(FNewValue) then
      Exit(False);
    AExtendedAttribute := FGetExtendedAttributes[FFieldName];
    if AExtendedAttribute = nil then
      Exit;
    with TdxGanttControlExtendedAttributeValueChangePropertyCommand.Create(Control, AExtendedAttribute, FNewValue) do
    try
      Result := Enabled;
    finally
      Free;
    end;
  end;
end;

function TdxGanttControlChangeExtendedAttributeValueCommand.GetExtendedAttributeValue: TdxGanttControlExtendedAttributeValue;

  procedure CreateExtendedAttribute(AFieldID: Integer);
  var
    AHistoryItem: TdxGanttControlCreateItemHistoryItem;
    AHistory: TdxGanttControlHistory;
    AExtendedAttribute: TdxGanttControlExtendedAttribute;
  begin
    AHistory := Control.History;
    AHistoryItem := TdxGanttControlCreateItemHistoryItem.Create(AHistory, DataModel.ExtendedAttributes);
    AHistoryItem.Index := DataModel.ExtendedAttributes.Count;
    AHistory.AddItem(AHistoryItem);
    AHistoryItem.Execute;
    AExtendedAttribute := DataModel.ExtendedAttributes[DataModel.ExtendedAttributes.Count - 1];
    AExtendedAttribute.FieldID := AFieldID;
    AExtendedAttribute.FieldName := FFieldName;
  end;

var
  AHistoryItem: TdxGanttControlCreateItemHistoryItem;
  AHistory: TdxGanttControlHistory;
  AExtendedAttributes: TdxGanttControlExtendedAttributeValues;
begin
  AExtendedAttributes := FGetExtendedAttributes;
  Result := AExtendedAttributes[FFieldName];
  if Result = nil then
  begin
    AHistory := Control.History;
    AHistoryItem := TdxGanttControlCreateExtendedAttributeValueHistoryItem.Create(AHistory, FGetExtendedAttributes);
    AHistoryItem.Index := AExtendedAttributes.Count;
    AHistory.AddItem(AHistoryItem);
    AHistoryItem.Execute;
    Result := AExtendedAttributes[AExtendedAttributes.Count - 1];
    Result.FieldID := TdxGanttControlExtendedAttributeValuesAccess(AExtendedAttributes).GetFieldID(FFieldName);
  end;
  if DataModel.ExtendedAttributes.Find(Result.FieldID) = nil then
    CreateExtendedAttribute(Result.FieldID);
end;

end.
