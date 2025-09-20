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

unit dxGanttControlResourceSheetColumns;

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  System.UITypes, System.Contnrs,
  Types, SysUtils, Graphics, Generics.Defaults, Generics.Collections, Windows,
  Controls, Classes, Variants,
  dxCore, dxCoreClasses, cxGeometry, cxVariants, cxEdit, cxControls, cxCustomCanvas, dxGDIPlusClasses,
  dxGanttControlCustomView,
  dxGanttControlCustomClasses,
  dxGanttControlCustomSheet,
  dxGanttControlCustomDataModel,
  dxGanttControlDataModel,
  dxGanttControlExtendedAttributes,
  dxGanttControlCalendars,
  dxGanttControlCommands,
  dxGanttControlResourceCommands,
  dxGanttControlSheetColumns,
  dxGanttControlResources;

type
  { TdxGanttControlResourceSheetColumns }

  TdxGanttControlResourceSheetColumns = class(TdxGanttControlViewSheetColumns)
  protected
    function GetExtendedAttributeColumnClass: TdxGanttControlExtendedAttributeSheetColumnClass; override;
    function GetFieldLevel: TdxGanttControlExtendedAttributeLevel; override;
    procedure RegisterColumnClasses; override;
    function StoredCreateChild(const AObjectName, AClassName: string): TObject; override;
  end;

  { TdxGanttControlResourceSheetColumn }

  TdxGanttControlResourceSheetColumn = class abstract(TdxGanttControlSheetColumn)
  strict private
    function GetDataModel: TdxGanttControlDataModel; inline;
  protected
    function CreateChangeValueCommand(AControl: TdxGanttControlBase; ADataItem: TObject; const ANewValue: Variant): TdxGanttControlCommand; override;
    function CreateProperties: TcxCustomEditProperties; override;
    function GetChangeValueCommandClass: TdxGanttControlChangeResourcePropertyCommandClass; virtual; abstract;
    function DoGetEditValue(AResource: TdxGanttControlResource): Variant; virtual; abstract;

    function GetEditValue(AData: TObject): Variant; override; final;

    property DataModel: TdxGanttControlDataModel read GetDataModel;
  end;

  { TdxGanttControlResourceSheetColumnIndicator }

  TdxGanttControlResourceSheetColumnIndicator = class(TdxGanttControlResourceSheetColumn)
  protected
    function CanShowFilterButton: Boolean; override;
    function CreateViewInfo(ASheetViewInfo: TdxGanttControlSheetCustomViewInfo): TdxGanttControlSheetColumnHeaderViewInfo; override;
    function GetDefaultAllowRename: TdxDefaultBoolean; override;
    function GetDefaultAllowWordWrap: TdxDefaultBoolean; override;
    function GetDefaultCaption: string; override;
    function GetDefaultShowFilterButton: Boolean; override;
    function GetDefaultWidth: Integer; override;
    class function GetDesignCaption: string; override;
  end;

  { TdxGanttControlResourceSheetColumnIndicatorHeaderViewInfo }

  TdxGanttControlResourceSheetColumnIndicatorHeaderViewInfo = class(TdxGanttControlSheetColumnHeaderImageViewInfo)
  protected
    function CalculateImage: TdxGPImage; override;
  end;

  { TdxGanttControlResourceSheetDataCellViewInfo }

  TdxGanttControlResourceSheetDataCellViewInfo = class(TdxGanttControlSheetCellStringValueViewInfo)
  protected
    function HasDisplayText: Boolean; override;
  end;

  { TdxGanttControlResourceSheetColumnName }

  TdxGanttControlResourceSheetColumnName = class(TdxGanttControlResourceSheetColumn)
  protected
    function GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass; override;
    function GetDefaultCaption: string; override;
    function GetDefaultWidth: Integer; override;
    function GetDefaultWordWrap: Boolean; override;
    function GetChangeValueCommandClass: TdxGanttControlChangeResourcePropertyCommandClass; override;
    class function GetDesignCaption: string; override;
    function GetHintText: string; override;
    function GetPropertiesClass: TcxCustomEditPropertiesClass; override;

    function DoGetEditValue(AResource: TdxGanttControlResource): Variant; override;
  end;

  { TdxGanttControlResourceSheetColumnResourceNameDataCellViewInfo }

  TdxGanttControlResourceSheetColumnResourceNameDataCellViewInfo = class(TdxGanttControlResourceSheetDataCellViewInfo);

  { TdxGanttControlResourceSheetColumnType }

  TdxGanttControlResourceSheetColumnType = class(TdxGanttControlResourceSheetColumn)
  protected
    function CreateProperties: TcxCustomEditProperties; override;
    function GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass; override;
    function GetDefaultCaption: string; override;
    function GetDefaultWidth: Integer; override;
    function GetChangeValueCommandClass: TdxGanttControlChangeResourcePropertyCommandClass; override;
    class function GetDesignCaption: string; override;
    function GetHintText: string; override;
    function GetPropertiesClass: TcxCustomEditPropertiesClass; override;

    function DoGetEditValue(AResource: TdxGanttControlResource): Variant; override;
  end;

  { TdxGanttControlResourceSheetColumnTypeDataCellViewInfo }

  TdxGanttControlResourceSheetColumnTypeDataCellViewInfo = class(TdxGanttControlResourceSheetDataCellViewInfo);

  { TdxGanttControlResourceSheetColumnGroup }

  TdxGanttControlResourceSheetColumnGroup = class(TdxGanttControlResourceSheetColumn)
  protected
    function GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass; override;
    function GetDefaultCaption: string; override;
    function GetDefaultWidth: Integer; override;
    function GetChangeValueCommandClass: TdxGanttControlChangeResourcePropertyCommandClass; override;
    class function GetDesignCaption: string; override;
    function GetHintText: string; override;
    function GetPropertiesClass: TcxCustomEditPropertiesClass; override;

    function DoGetEditValue(AResource: TdxGanttControlResource): Variant; override;
  end;

  { TdxGanttControlResourceSheetColumnResourceGroupDataCellViewInfo }

  TdxGanttControlResourceSheetColumnResourceGroupDataCellViewInfo = class(TdxGanttControlResourceSheetDataCellViewInfo);

  { TdxGanttControlResourceSheetColumnBaseCalendar }

  TdxGanttControlResourceSheetColumnBaseCalendar = class(TdxGanttControlResourceSheetColumn)
  strict private
    FCalendars: TStringList;
    procedure CalendarChangedHandler(Sender: TdxGanttControlDataModel; ACalendar: TdxGanttControlCalendar);
    procedure UpdateCalendars;
  protected
    function CreateProperties: TcxCustomEditProperties; override;
    function GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass; override;
    function GetDefaultCaption: string; override;
    function GetDefaultVisible: Boolean; override;
    function GetDefaultWidth: Integer; override;
    function GetChangeValueCommandClass: TdxGanttControlChangeResourcePropertyCommandClass; override;
    class function GetDesignCaption: string; override;
    function GetHintText: string; override;
    function GetPropertiesClass: TcxCustomEditPropertiesClass; override;

    function DoGetEditValue(AResource: TdxGanttControlResource): Variant; override;
  public
    constructor Create(AOwner: TdxGanttControlSheetColumns); override;
    destructor Destroy; override;
  end;

  { TdxGanttControlResourceSheetColumnResourceBaseCalendarDataCellViewInfo }

  TdxGanttControlResourceSheetColumnResourceBaseCalendarDataCellViewInfo = class(TdxGanttControlResourceSheetDataCellViewInfo);

  { TdxGanttControlResourceSheetExtendedAttributeSheetColumn }

  TdxGanttControlResourceSheetExtendedAttributeSheetColumn = class(TdxGanttControlExtendedAttributeSheetColumn)
  protected
    function CreateChangeValueCommand(AControl: TdxGanttControlBase; ADataItem: TObject; const ANewValue: Variant): TdxGanttControlCommand; override;
    function GetActiveCalendar(ADataItem: TObject): TdxGanttControlCalendar; override;
    function GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass; override;
    function GetFieldID: Integer; override;
    function GetExtendedAttributeValues(AData: TObject): TdxGanttControlExtendedAttributeValues; override;
  end;

  { TdxGanttControlResourceSheetColumnResourceExtendedAttributeDataCellViewInfo }

  TdxGanttControlResourceSheetColumnResourceExtendedAttributeDataCellViewInfo = class(TdxGanttControlResourceSheetDataCellViewInfo)
  strict private
    function GetColumn: TdxGanttControlResourceSheetExtendedAttributeSheetColumn; inline;
  protected
    function CalculateItemBounds(AItem: TdxGanttControlCustomItemViewInfo): TRect; override;
    function DoCalculateDisplayText: string; override;
    function GetCurrentCursor(const P: TPoint; const ADefaultCursor: TCursor): TCursor; override;
    function HasDisplayText: Boolean; override;
    property Column: TdxGanttControlResourceSheetExtendedAttributeSheetColumn read GetColumn;
  public
    procedure CalculateLayout; override;
  end;

implementation

uses
  cxTextEdit, cxDropDownEdit, cxLookAndFeelPainters,
  dxGanttControl,
  dxGanttControlStrs,
  dxGanttControlImages;

const
  dxThisUnitName = 'dxGanttControlResourceSheetColumns';

{ TdxGanttControlResourceSheetColumns }

function TdxGanttControlResourceSheetColumns.GetExtendedAttributeColumnClass: TdxGanttControlExtendedAttributeSheetColumnClass;
begin
  Result := TdxGanttControlResourceSheetExtendedAttributeSheetColumn;
end;

function TdxGanttControlResourceSheetColumns.GetFieldLevel: TdxGanttControlExtendedAttributeLevel;
begin
  Result := TdxGanttControlExtendedAttributeLevel.Resource;
end;

procedure TdxGanttControlResourceSheetColumns.RegisterColumnClasses;
begin
  inherited RegisterColumnClasses;
  RegisterColumnClass(TdxGanttControlResourceSheetColumnName);
  RegisterColumnClass(TdxGanttControlResourceSheetColumnType);
  RegisterColumnClass(TdxGanttControlResourceSheetColumnGroup);
  RegisterColumnClass(TdxGanttControlResourceSheetColumnBaseCalendar);
end;

function TdxGanttControlResourceSheetColumns.StoredCreateChild(const AObjectName, AClassName: string): TObject;
var
  AUpperCaseClassName: string;
begin
  AUpperCaseClassName := UpperCase(AClassName);
  if AUpperCaseClassName = UpperCase(TdxGanttControlResourceSheetColumnName.ClassName) then
    Result := Add(TdxGanttControlResourceSheetColumnName)
  else
  if AUpperCaseClassName = UpperCase(TdxGanttControlResourceSheetColumnType.ClassName) then
    Result := Add(TdxGanttControlResourceSheetColumnType)
  else
  if AUpperCaseClassName = UpperCase(TdxGanttControlResourceSheetColumnGroup.ClassName) then
    Result := Add(TdxGanttControlResourceSheetColumnGroup)
  else
  if AUpperCaseClassName = UpperCase(TdxGanttControlResourceSheetColumnBaseCalendar.ClassName) then
    Result := Add(TdxGanttControlResourceSheetColumnBaseCalendar)
  else
  if AUpperCaseClassName = UpperCase(TdxGanttControlResourceSheetExtendedAttributeSheetColumn.ClassName) then
    Result := Add(TdxGanttControlResourceSheetExtendedAttributeSheetColumn)
  else
    Result := inherited StoredCreateChild(AObjectName, AClassName);
  if Result <> nil then
    DoInitStoredObject(Result);
end;

{ TdxGanttControlResourceSheetColumn }

function TdxGanttControlResourceSheetColumn.CreateChangeValueCommand(
  AControl: TdxGanttControlBase; ADataItem: TObject;
  const ANewValue: Variant): TdxGanttControlCommand;
var
  AResource: TdxGanttControlResource;
begin
  AResource := TdxGanttControlResource(ADataItem);
  Result := GetChangeValueCommandClass.Create(AControl, AResource, ANewValue);
end;

function TdxGanttControlResourceSheetColumn.CreateProperties: TcxCustomEditProperties;
begin
  Result := inherited CreateProperties;
  if Result <> nil then
    Result.Alignment.Vert := taTopJustify;
end;

function TdxGanttControlResourceSheetColumn.GetDataModel: TdxGanttControlDataModel;
begin
  Result := TdxCustomGanttControl(TdxGanttControlCustomView(Owner.Owner.Owner).Owner).DataModel;
end;

function TdxGanttControlResourceSheetColumn.GetEditValue(
  AData: TObject): Variant;
begin
  try
    if TdxGanttControlResource(AData).Blank then
      Result := Null
    else
      Result := DoGetEditValue(TdxGanttControlResource(AData));
  except
    Result := Null;
  end;
end;

{ TdxGanttControlResourceSheetColumnIndicator }

function TdxGanttControlResourceSheetColumnIndicator.CanShowFilterButton: Boolean;
begin
  Result := False;
end;

function TdxGanttControlResourceSheetColumnIndicator.CreateViewInfo(
  ASheetViewInfo: TdxGanttControlSheetCustomViewInfo): TdxGanttControlSheetColumnHeaderViewInfo;
begin
  Result := TdxGanttControlResourceSheetColumnIndicatorHeaderViewInfo.Create(ASheetViewInfo, Self);
end;

function TdxGanttControlResourceSheetColumnIndicator.GetDefaultAllowRename: TdxDefaultBoolean;
begin
  Result := bFalse;
end;

function TdxGanttControlResourceSheetColumnIndicator.GetDefaultAllowWordWrap: TdxDefaultBoolean;
begin
  Result := bFalse;
end;

function TdxGanttControlResourceSheetColumnIndicator.GetDefaultCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewResourceSheetColumnIndicatorCaption);
end;

function TdxGanttControlResourceSheetColumnIndicator.GetDefaultShowFilterButton: Boolean;
begin
  Result := False;
end;

function TdxGanttControlResourceSheetColumnIndicator.GetDefaultWidth: Integer;
begin
  Result := 39;
end;

class function TdxGanttControlResourceSheetColumnIndicator.GetDesignCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewResourceSheetColumnIndicatorCaption);
end;

{ TdxGanttControlResourceSheetColumnIndicatorHeaderViewInfo }

function TdxGanttControlResourceSheetColumnIndicatorHeaderViewInfo.CalculateImage: TdxGPImage;
begin
  Result := TdxGanttControlImages.Info;
end;

{ TdxGanttControlResourceSheetDataCellViewInfo }

function TdxGanttControlResourceSheetDataCellViewInfo.HasDisplayText: Boolean;
begin
  Result := inherited HasDisplayText and
    not TdxGanttControlResource(Owner.Data).Blank;
end;

{ TdxGanttControlResourceSheetColumnName }

function TdxGanttControlResourceSheetColumnName.DoGetEditValue(
  AResource: TdxGanttControlResource): Variant;
begin
  Result := AResource.Name;
end;

function TdxGanttControlResourceSheetColumnName.GetChangeValueCommandClass: TdxGanttControlChangeResourcePropertyCommandClass;
begin
  Result := TdxGanttControlChangeResourceNameCommand;
end;

function TdxGanttControlResourceSheetColumnName.GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass;
begin
  Result := TdxGanttControlResourceSheetColumnResourceNameDataCellViewInfo;
end;

function TdxGanttControlResourceSheetColumnName.GetDefaultCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewResourceSheetColumnResourceNameCaption);
end;

function TdxGanttControlResourceSheetColumnName.GetDefaultWidth: Integer;
begin
  Result := 285;
end;

function TdxGanttControlResourceSheetColumnName.GetDefaultWordWrap: Boolean;
begin
  Result := True;
end;

class function TdxGanttControlResourceSheetColumnName.GetDesignCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewResourceSheetColumnResourceNameCaption)
end;

function TdxGanttControlResourceSheetColumnName.GetHintText: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewResourceSheetColumnResourceNameDescription);
end;

function TdxGanttControlResourceSheetColumnName.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxGanttControlPropertiesClassCollection.GetTextFieldPropertiesClass;
end;

{ TdxGanttControlResourceSheetColumnType }

function TdxGanttControlResourceSheetColumnType.CreateProperties: TcxCustomEditProperties;
var
  AResult: TcxComboBoxProperties;
begin
  Result := inherited CreateProperties;
  AResult := TcxComboBoxProperties(Result);
  AResult.Items.Add(cxGetResourceString(@sdxGanttControlResourceTypeWork));
  AResult.Items.Add(cxGetResourceString(@sdxGanttControlResourceTypeMaterial));
  AResult.Items.Add(cxGetResourceString(@sdxGanttControlResourceTypeCost));
  AResult.DropDownListStyle := lsEditFixedList;
  AResult.ImmediatePost := True;
  AResult.ImmediateDropDown := False;
  AResult.ImmediateDropDownWhenKeyPressed := False;
  AResult.ImmediateDropDownWhenActivated := False;
end;

function TdxGanttControlResourceSheetColumnType.DoGetEditValue(
  AResource: TdxGanttControlResource): Variant;
begin
  if AResource.IsValueAssigned(TdxGanttResourceAssignedValue.&Type) then
  begin
    case AResource.&Type of
      TdxGanttControlResourceType.Material: Result := cxGetResourceString(@sdxGanttControlResourceTypeMaterial);
      TdxGanttControlResourceType.Work: Result := cxGetResourceString(@sdxGanttControlResourceTypeWork);
    else
      Result := cxGetResourceString(@sdxGanttControlResourceTypeCost);
    end;
  end
  else
    Result := Null;
end;

function TdxGanttControlResourceSheetColumnType.GetChangeValueCommandClass: TdxGanttControlChangeResourcePropertyCommandClass;
begin
  Result := TdxGanttControlChangeResourceTypeCommand;
end;

function TdxGanttControlResourceSheetColumnType.GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass;
begin
  Result := TdxGanttControlResourceSheetColumnTypeDataCellViewInfo;
end;

function TdxGanttControlResourceSheetColumnType.GetDefaultCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewResourceSheetColumnTypeCaption);
end;

function TdxGanttControlResourceSheetColumnType.GetDefaultWidth: Integer;
begin
  Result := 50;
end;

class function TdxGanttControlResourceSheetColumnType.GetDesignCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewResourceSheetColumnTypeCaption);
end;

function TdxGanttControlResourceSheetColumnType.GetHintText: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewResourceSheetColumnTypeDescription);
end;

function TdxGanttControlResourceSheetColumnType.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxComboBoxProperties;
end;

{ TdxGanttControlResourceSheetColumnGroup }

function TdxGanttControlResourceSheetColumnGroup.DoGetEditValue(
  AResource: TdxGanttControlResource): Variant;
begin
  if not AResource.IsValueAssigned(TdxGanttResourceAssignedValue.Group) then
    Result := Null
  else
    Result := AResource.Group;
end;

function TdxGanttControlResourceSheetColumnGroup.GetChangeValueCommandClass: TdxGanttControlChangeResourcePropertyCommandClass;
begin
  Result := TdxGanttControlChangeResourceGroupCommand;
end;

function TdxGanttControlResourceSheetColumnGroup.GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass;
begin
  Result := TdxGanttControlResourceSheetColumnResourceGroupDataCellViewInfo;
end;

function TdxGanttControlResourceSheetColumnGroup.GetDefaultCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewResourceSheetColumnGroupCaption);
end;

function TdxGanttControlResourceSheetColumnGroup.GetDefaultWidth: Integer;
begin
  Result := 100;
end;

class function TdxGanttControlResourceSheetColumnGroup.GetDesignCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewResourceSheetColumnGroupCaption);
end;

function TdxGanttControlResourceSheetColumnGroup.GetHintText: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewResourceSheetColumnGroupDescription);
end;

function TdxGanttControlResourceSheetColumnGroup.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxGanttControlPropertiesClassCollection.GetTextFieldPropertiesClass;
end;

{ TdxGanttControlResourceSheetColumnBaseCalendar }

constructor TdxGanttControlResourceSheetColumnBaseCalendar.Create(
  AOwner: TdxGanttControlSheetColumns);
begin
  inherited Create(AOwner);
  FCalendars := TStringList.Create;
  DataModel.CalendarChangedHandlers.Add(CalendarChangedHandler);
  UpdateCalendars;
end;

destructor TdxGanttControlResourceSheetColumnBaseCalendar.Destroy;
begin
  DataModel.CalendarChangedHandlers.Remove(CalendarChangedHandler);
  FreeAndNil(FCalendars);
  inherited Destroy;
end;

procedure TdxGanttControlResourceSheetColumnBaseCalendar.CalendarChangedHandler(
  Sender: TdxGanttControlDataModel; ACalendar: TdxGanttControlCalendar);
begin
  UpdateCalendars;
end;

function TdxGanttControlResourceSheetColumnBaseCalendar.CreateProperties: TcxCustomEditProperties;
var
  AResult: TcxComboBoxProperties;
begin
  Result := inherited CreateProperties;
  AResult := TcxComboBoxProperties(Result);
  AResult.ImmediatePost := True;
  AResult.ImmediateDropDown := False;
  AResult.ImmediateDropDownWhenKeyPressed := False;
  AResult.ImmediateDropDownWhenActivated := False;
end;

function TdxGanttControlResourceSheetColumnBaseCalendar.DoGetEditValue(
  AResource: TdxGanttControlResource): Variant;
var
  ACalendarUID: Integer;
  ACalendar: TdxGanttControlCalendar;
begin
  if not AResource.IsValueAssigned(TdxGanttResourceAssignedValue.CalendarUID) then
    Result := Null
  else
  begin
    ACalendarUID := AResource.CalendarUID;
    ACalendar := TdxGanttControlDataModel(AResource.DataModel).Calendars.GetCalendarByUID(ACalendarUID);
    if ACalendar <> nil then
      Result := ACalendar.Name
    else
      Result := Null;
  end;
end;

function TdxGanttControlResourceSheetColumnBaseCalendar.GetChangeValueCommandClass: TdxGanttControlChangeResourcePropertyCommandClass;
begin
  Result := TdxGanttControlChangeResourceCalendarUIDCommand;
end;

function TdxGanttControlResourceSheetColumnBaseCalendar.GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass;
begin
  Result := TdxGanttControlResourceSheetColumnResourceBaseCalendarDataCellViewInfo;
end;

function TdxGanttControlResourceSheetColumnBaseCalendar.GetDefaultCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewResourceSheetColumnBaseCalendarCaption);
end;

function TdxGanttControlResourceSheetColumnBaseCalendar.GetDefaultVisible: Boolean;
begin
  Result := False;
end;

function TdxGanttControlResourceSheetColumnBaseCalendar.GetDefaultWidth: Integer;
begin
  Result := 120;
end;

class function TdxGanttControlResourceSheetColumnBaseCalendar.GetDesignCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewResourceSheetColumnBaseCalendarCaption);
end;

function TdxGanttControlResourceSheetColumnBaseCalendar.GetHintText: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewResourceSheetColumnBaseCalendarDescription);
end;

function TdxGanttControlResourceSheetColumnBaseCalendar.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxComboBoxProperties;
end;

procedure TdxGanttControlResourceSheetColumnBaseCalendar.UpdateCalendars;
var
  I: Integer;
begin
  FCalendars.BeginUpdate;
  try
    FCalendars.Clear;
    for I := 0 to DataModel.Calendars.Count - 1 do
      FCalendars.AddObject(DataModel.Calendars[I].Name, DataModel.Calendars[I]);
  finally
    FCalendars.EndUpdate;
  end;
  TcxComboBoxProperties(Properties).Items.Assign(FCalendars);
end;

{ TdxGanttControlResourceSheetExtendedAttributeSheetColumn }

function TdxGanttControlResourceSheetExtendedAttributeSheetColumn.CreateChangeValueCommand(
  AControl: TdxGanttControlBase; ADataItem: TObject;
  const ANewValue: Variant): TdxGanttControlCommand;
begin
  Result := TdxGanttControlChangeResourceExtendedAttributeValueCommand.Create(Owner.Owner.Control, TdxGanttControlResource(ADataItem), FieldName, ANewValue);
end;

function TdxGanttControlResourceSheetExtendedAttributeSheetColumn.GetActiveCalendar(
  ADataItem: TObject): TdxGanttControlCalendar;
begin
  if ADataItem <> nil then
    Result := TdxGanttControlResource(ADataItem).RealCalendar
  else
    Result := inherited GetActiveCalendar(ADataItem);
end;

function TdxGanttControlResourceSheetExtendedAttributeSheetColumn.GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass;
begin
  Result := TdxGanttControlResourceSheetColumnResourceExtendedAttributeDataCellViewInfo;
end;

function TdxGanttControlResourceSheetExtendedAttributeSheetColumn.GetFieldID: Integer;
begin
  Result := TdxGanttControlExtendedAttributeHelper.GetFieldID(FieldName, TdxGanttControlExtendedAttributeLevel.Resource);
end;

function TdxGanttControlResourceSheetExtendedAttributeSheetColumn.GetExtendedAttributeValues(
  AData: TObject): TdxGanttControlExtendedAttributeValues;
begin
  Result := TdxGanttControlResource(AData).ExtendedAttributes;
end;

{ TdxGanttControlResourceSheetColumnResourceExtendedAttributeDataCellViewInfo }

function TdxGanttControlResourceSheetColumnResourceExtendedAttributeDataCellViewInfo.CalculateItemBounds(
  AItem: TdxGanttControlCustomItemViewInfo): TRect;
begin
  Result := Bounds;
end;

procedure TdxGanttControlResourceSheetColumnResourceExtendedAttributeDataCellViewInfo.CalculateLayout;
begin
  inherited CalculateLayout;
  if HasDisplayText and (Column.&Type = TdxGanttControlExtendedAttributeCFType.Flag) then
    AddChild(TdxGanttControlCheckBoxViewInfo.Create(Self));
end;

function TdxGanttControlResourceSheetColumnResourceExtendedAttributeDataCellViewInfo.DoCalculateDisplayText: string;
begin
  if Column.&Type = TdxGanttControlExtendedAttributeCFType.Flag then
    Result := ''
  else
    Result := inherited DoCalculateDisplayText;
end;

function TdxGanttControlResourceSheetColumnResourceExtendedAttributeDataCellViewInfo.GetColumn: TdxGanttControlResourceSheetExtendedAttributeSheetColumn;
begin
  Result := TdxGanttControlResourceSheetExtendedAttributeSheetColumn(inherited Column);
end;

function TdxGanttControlResourceSheetColumnResourceExtendedAttributeDataCellViewInfo.GetCurrentCursor(
  const P: TPoint; const ADefaultCursor: TCursor): TCursor;
begin
  if Column.&Type = TdxGanttControlExtendedAttributeCFType.Flag then
    Result := crDefault
  else
    Result := inherited GetCurrentCursor(P, ADefaultCursor);
end;

function TdxGanttControlResourceSheetColumnResourceExtendedAttributeDataCellViewInfo.HasDisplayText: Boolean;
begin
  Result := inherited HasDisplayText and
    ((Column.GetExtendedAttributeValues(Owner.Data)[Column.FieldName] <> nil) or
    (Column.&Type = TdxGanttControlExtendedAttributeCFType.Flag));
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  RegisterClasses([TdxGanttControlResourceSheetColumnIndicator, TdxGanttControlResourceSheetColumnName,
    TdxGanttControlResourceSheetColumnType, TdxGanttControlResourceSheetColumnGroup,
    TdxGanttControlResourceSheetColumnBaseCalendar]);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
