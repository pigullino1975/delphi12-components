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

unit dxGanttControlSheetColumns;

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  System.UITypes, System.Contnrs,
  Types, SysUtils, Graphics, Generics.Defaults, Generics.Collections, Windows,
  Controls, Classes, Variants,
  dxCore, dxCoreClasses, cxVariants, cxEdit, cxControls, cxCustomCanvas, dxGDIPlusClasses,
  cxGeometry, cxGraphics, cxCheckBox, dxTreeView, cxSpinEdit, dxMeasurementUnitEdit,
  dxGanttControlCustomClasses,
  dxGanttControlCustomSheet,
  dxGanttControlCustomView,
  dxGanttControlCustomDataModel,
  dxGanttControlDataModel,
  dxGanttControlCommands,
  dxGanttControlCalendars,
  dxGanttControlExtendedAttributes,
  dxGanttControlExtendedAttributeCommands;

type
  IdxGanttControlDateEditPropertiesHelper = interface // for internal use
  ['{8CE366F1-1113-4D84-AA93-3DC34F92078A}']
    function GetEditValue(ADataItem: TObject): Variant;
    function GetActiveCalendar(ADataItem: TObject): TdxGanttControlCalendar;
  end;

  IdxGanttControlDurationEditPropertiesHelper = interface // for internal use
  ['{1862EB18-B3B1-41BA-9B20-DA76284E9255}']
    function GetDurationFormat(ADataItem: TObject): TdxDurationFormat;
    function GetValue(ADataItem: TObject): Double;
  end;

  { TdxGanttControlPropertiesClassCollection }

  TdxGanttControlPropertiesClassCollection = class // for internal use
  public
    class function GetCostFieldPropertiesClass: TcxCustomEditPropertiesClass; static;
    class function GetDurationFieldPropertiesClass: TcxCustomEditPropertiesClass; static;
    class function GetFinishFieldPropertiesClass: TcxCustomEditPropertiesClass; static;
    class function GetFlagFieldPropertiesClass: TcxCustomEditPropertiesClass; static;
    class function GetNumberFieldPropertiesClass: TcxCustomEditPropertiesClass; static;
    class function GetStartFieldPropertiesClass: TcxCustomEditPropertiesClass; static;
    class function GetTextFieldPropertiesClass: TcxCustomEditPropertiesClass; static;

    class procedure InitializeEditProperties(AColumn: TdxGanttControlSheetColumn; AProperties: TcxCustomEditProperties); static;
    class procedure PrepareEditProperties(AColumn: TdxGanttControlSheetColumn; AProperties: TcxCustomEditProperties; AData: TObject); static;
  end;

  { TdxGanttControlExtendedAttributeSheetColumn }

  TdxGanttControlExtendedAttributeSheetColumn = class abstract(TdxGanttControlSheetColumn,
    IdxGanttControlDateEditPropertiesHelper,
    IdxGanttControlDurationEditPropertiesHelper)
  strict private
    FFieldName: string;

    procedure PropertiesChangedHandler(Sender: TObject);

    function GetDataModel: TdxGanttControlDataModel; inline;
    function GetType: TdxGanttControlExtendedAttributeCFType;
  protected
    function CreateProperties: TcxCustomEditProperties; override;
    function GetAlignment: TAlignment; override;
    function GetDefaultAllowWordWrap: TdxDefaultBoolean; override;
    function GetDefaultCaption: string; override;
    function GetEditValue(AData: TObject): Variant; override; final;
    function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    procedure DoCaptionChanged(const ANewCaption: string); override;
    procedure PrepareEditProperties(AProperties: TcxCustomEditProperties; AData: TObject); override;
    function ShowEditorImmediately: Boolean; override;

    function GetActiveCalendar(ADataItem: TObject): TdxGanttControlCalendar; virtual;
    function GetFieldID: Integer; virtual; abstract;
    function GetExtendedAttributeValues(AData: TObject): TdxGanttControlExtendedAttributeValues; virtual; abstract;

    function GetDurationFormat(ADataItem: TObject): TdxDurationFormat;
    function GetValue(ADataItem: TObject): Double;

    procedure SetFieldName(const AValue: string);
    function GetHintText: string; override;

    function GetProperties(AProperties: TStrings): Boolean; override;
    procedure GetPropertyValue(const AName: string; var AValue: Variant); override;
    procedure SetPropertyValue(const AName: string; const AValue: Variant); override;

    property DataModel: TdxGanttControlDataModel read GetDataModel;
    property &Type: TdxGanttControlExtendedAttributeCFType read GetType;
  public
    constructor Create(AOwner: TdxGanttControlSheetColumns; const AFieldName: string); reintroduce; virtual;
    destructor Destroy; override;

    property FieldName: string read FFieldName;
  end;
  TdxGanttControlExtendedAttributeSheetColumnClass = class of TdxGanttControlExtendedAttributeSheetColumn;

  { TdxGanttControlViewSheetColumns }

  TdxGanttControlViewSheetColumns = class abstract(TdxGanttControlSheetColumns)
  strict private
    function GetDataModel: TdxGanttControlDataModel; inline;
  protected
    function GetExtendedAttributeColumn(const AFieldName: string): TdxGanttControlExtendedAttributeSheetColumn;
    function GetFieldLevel: TdxGanttControlExtendedAttributeLevel; virtual; abstract;
    function GetExtendedAttributeColumnClass: TdxGanttControlExtendedAttributeSheetColumnClass; virtual; abstract;
    property DataModel: TdxGanttControlDataModel read GetDataModel;
  public
    function AddExtendedAttributeColumn(const AFieldName: string): TdxGanttControlExtendedAttributeSheetColumn;
    procedure AddExtendedAttributeColumns(AType: TdxGanttControlExtendedAttributeCFType);
    procedure RetrieveMissingExtendedAttributeColumns;
  end;

  { TdxGanttControlCheckBoxViewInfo }

  TdxGanttControlCheckBoxViewInfo = class(TdxGanttControlCustomOwnedItemViewInfo)
  strict private
    FEditRect: TRect;
    FImage: TdxGPImage;
    function GetColumn: TdxGanttControlSheetColumn; inline;
    function GetOwner: TdxGanttControlSheetCellCustomViewInfo; inline;
  protected
    procedure DoDraw; override;
    function IsHitTestTransparent: Boolean; override;
  public
    constructor Create(AOwner: TdxGanttControlSheetCellCustomViewInfo); reintroduce;
    procedure Calculate(const R: TRect); override;

    property Column: TdxGanttControlSheetColumn read GetColumn;
    property Owner: TdxGanttControlSheetCellCustomViewInfo read GetOwner;
  end;

implementation

uses
  DateUtils, Math,
  dxTypeHelpers, cxDateUtils, cxFormats, cxLookAndFeelPainters,
  cxContainer, cxTextEdit, cxCurrencyEdit, cxDropDownEdit, cxCalendar,
  dxGanttControlStrs,
  dxGanttControlUtils,
  dxGanttControl,
  dxGanttControlDialogUtils,
  dxGanttControlTaskInformationDialog;

const
  dxThisUnitName = 'dxGanttControlSheetColumns';

type
  TdxGanttControlExtendedAttributeValuesAccess = class(TdxGanttControlExtendedAttributeValues);
  TdxGanttControlSheetColumnAccess = class(TdxGanttControlSheetColumn);
  TdxMeasurementUnitEditHelperAccess = class(TdxMeasurementUnitEditHelper);
  TdxGanttControlTaskInformationDialogFormAccess = class(TdxGanttControlTaskInformationDialogForm);
  TdxGanttControlDataModelPropertiesAccess = class(TdxGanttControlDataModelProperties);

  { TdxGanttDateEditProperties }

  TdxGanttDateEditProperties = class(TcxDateEditProperties)
  protected
    FColumn: TdxGanttControlSheetColumn;
    FData: TObject;
  public
    constructor Create(AOwner: TPersistent); override;
    class function GetContainerClass: TcxContainerClass; override;
  end;

  { TdxGanttDateEdit }

  TdxGanttDateEdit = class(TcxDateEdit)
  protected
    procedure DoCloseUp; override;
    function DoGetDefaultTime(ACalendar: TdxGanttControlCalendar; ADate: TDate): TDateTime; virtual; abstract;
    procedure DoOnValidate(var ADisplayValue: Variant; var AErrorText: TCaption; var AError: Boolean); override;
    function GetDefaultTime(AData: TObject; ADate: TDate): TDateTime;
    function IsOnValidateEventAssigned: Boolean; override;
  public
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
  end;

  { TdxGanttFinishDateEditProperties }

  TdxGanttFinishDateEditProperties = class(TdxGanttDateEditProperties)
  public
    class function GetContainerClass: TcxContainerClass; override;
  end;

  { TdxGanttFinishDateEdit }

  TdxGanttFinishDateEdit = class(TdxGanttDateEdit)
  protected
    function DoGetDefaultTime(ACalendar: TdxGanttControlCalendar; ADate: TDate): TDateTime; override;
  public
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
  end;

  { TdxGanttStartDateEditProperties }

  TdxGanttStartDateEditProperties = class(TdxGanttDateEditProperties)
  public
    class function GetContainerClass: TcxContainerClass; override;
  end;

  { TdxGanttStartDateEdit }

  TdxGanttStartDateEdit = class(TdxGanttDateEdit)
  protected
    function DoGetDefaultTime(ACalendar: TdxGanttControlCalendar; ADate: TDate): TDateTime; override;
  public
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
  end;

  { TdxGanttDurationEditProperties }

  TdxGanttDurationEditProperties = class(TdxMeasurementUnitEditProperties)
  strict private
    FHelper: TdxMeasurementUnitEditHelper;
    procedure AddPossibleDescriptions;
    procedure CreateHelper(const ADescription, ADefaultDescription: string; AMaxPrecession: Integer);
  protected
    function DoGetNewValue(Sender: TObject; AButton: TcxSpinEditButton; var AValue: Variant): Boolean; override;
    procedure Prepare(AColumn: TdxGanttControlSheetColumn; AData: TObject);
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
    class function GetContainerClass: TcxContainerClass; override;
    procedure ValidateDisplayValue(var DisplayValue: Variant;
      var ErrorText: TCaption; var Error: Boolean; AEdit: TcxCustomEdit); override;
  end;

  { TdxGanttMeasurementUnitEdit }

  TdxGanttMeasurementUnitEdit = class(TdxMeasurementUnitEdit)
  private
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
  end;

  { TdxGanttCurrencyEditProperties }

  TdxGanttCurrencyEditProperties = class(TcxCurrencyEditProperties)
  protected
    procedure Initialize(AColumn: TdxGanttControlSheetColumn);
  public
    class function GetContainerClass: TcxContainerClass; override;
  end;

  { TdxGanttCurrencyEdit }

  TdxGanttCurrencyEdit = class(TcxCurrencyEdit)
  public
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
  end;

{ TdxGanttDateEditProperties }

constructor TdxGanttDateEditProperties.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  DisplayFormat := TdxGanttControlUtils.GetShortDateTimeFormat;
  EditFormat := DisplayFormat;
  MinDate := TdxGanttControlDataModel.MinDate;
  ImmediatePost := True;
end;

class function TdxGanttDateEditProperties.GetContainerClass: TcxContainerClass;
begin
  Result := TdxGanttDateEdit;
end;

{ TdxGanttDateEdit }

procedure TdxGanttDateEdit.DoCloseUp;
var
  AData: TObject;
  ADate: TDateTime;
  AHelper: IdxGanttControlDateEditPropertiesHelper;
begin
  inherited DoCloseUp;
  AData := TdxGanttDateEditProperties(Properties).FData;
  AHelper := TdxGanttDateEditProperties(Properties).FColumn as IdxGanttControlDateEditPropertiesHelper;
  if (AData <> nil) and not VarIsNull(AHelper.GetEditValue(AData)) then
    Exit;
  if VarIsNull(EditingValue) then
    Exit;
  ADate := VarToDateTime(EditingValue);
  if ADate = DateOf(ADate) then
  begin
    EditValue := GetDefaultTime(AData, ADate);
    ModifiedAfterEnter := True;
  end;
end;

procedure TdxGanttDateEdit.DoOnValidate(var ADisplayValue: Variant;
  var AErrorText: TCaption; var AError: Boolean);

  procedure DoValidateDisplayValue;
  var
    ADate: TDateTime;
    AData: TObject;
    AResult: string;
  begin
    if VarToStr(ADisplayValue) = '' then
    begin
      EditValue := Null;
      ModifiedAfterEnter := True;
      Exit;
    end;
    if not TextToDateEx(VarToStr(ADisplayValue), ADate, Properties.EditFormat) then
      Exit;
    if ADate <> DateOf(ADate) then
      Exit;
    if (ADate < TdxGanttControlDataModel.MinDate) and (ADate > 0) and (ADate < 365) and (Trunc(ADate) = ADate) then
    begin
      ADate := StartOfTheYear(Now) + ADate - 1;
      ADisplayValue := cxDateToStr(ADate);
    end;
    if cxDateToStr(ADate) = Trim(VarToStr(ADisplayValue)) then
    begin
      AData := TdxGanttDateEditProperties(Properties).FData;
      DateTimeToString(AResult, Properties.EditFormat, GetDefaultTime(AData, ADate));
      ADisplayValue := AResult;
    end;
  end;

begin
  try
    DoValidateDisplayValue;
  except
    AError := True;
  end;
  inherited DoOnValidate(ADisplayValue, AErrorText, AError);
end;

function TdxGanttDateEdit.GetDefaultTime(AData: TObject;
  ADate: TDate): TDateTime;
var
  ACalendar: TdxGanttControlCalendar;
  AHelper: IdxGanttControlDateEditPropertiesHelper;
begin
  AHelper := TdxGanttDateEditProperties(Properties).FColumn as IdxGanttControlDateEditPropertiesHelper;
  ACalendar := AHelper.GetActiveCalendar(AData);
  if ACalendar.IsWorkday(ADate) then
    Result := DoGetDefaultTime(ACalendar, ADate)
  else
    Result := ADate;
end;

class function TdxGanttDateEdit.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxGanttDateEditProperties;
end;

function TdxGanttDateEdit.IsOnValidateEventAssigned: Boolean;
begin
  Result := True;
end;

{ TdxGanttFinishDateEditProperties }

class function TdxGanttFinishDateEditProperties.GetContainerClass: TcxContainerClass;
begin
  Result := TdxGanttFinishDateEdit;
end;

{ TdxGanttStartDateEdit }

function TdxGanttFinishDateEdit.DoGetDefaultTime(
  ACalendar: TdxGanttControlCalendar; ADate: TDate): TDateTime;
begin
  Result := ACalendar.GetFinishWorkTime(ADate);
end;

class function TdxGanttFinishDateEdit.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxGanttFinishDateEditProperties;
end;

{ TdxGanttStartDateEditProperties }

class function TdxGanttStartDateEditProperties.GetContainerClass: TcxContainerClass;
begin
  Result := TdxGanttStartDateEdit;
end;

{ TdxGanttStartDateEdit }

function TdxGanttStartDateEdit.DoGetDefaultTime(
  ACalendar: TdxGanttControlCalendar; ADate: TDate): TDateTime;
begin
  Result := ACalendar.GetStartWorkTime(ADate);
end;

class function TdxGanttStartDateEdit.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxGanttStartDateEditProperties;
end;

{ TdxGanttDurationEditProperties }

constructor TdxGanttDurationEditProperties.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  Alignment.Vert := taTopJustify;
  ExceptionOnInvalidInput := True;
end;

destructor TdxGanttDurationEditProperties.Destroy;
begin
  FreeAndNil(FHelper);
  inherited Destroy;
end;

function TdxGanttDurationEditProperties.DoGetNewValue(Sender: TObject;
  AButton: TcxSpinEditButton; var AValue: Variant): Boolean;
var
  AValueStr, ADescription: string;
  ADurationFormat: TdxDurationFormat;
  AError: Boolean;
  AErrorText: TCaption;
begin
  Result := FHelper.IncrementValue(AButton, AValue);
  if Result then
  begin
    TdxMeasurementUnitEditHelperAccess.ExtractActualValueAndDescriptionStrings(AValue, AValueStr, ADescription);
    ADurationFormat := TdxGanttControlDialogUtils.GetDurationFormat(ADescription, AError, AErrorText);
    ADescription := TdxGanttControlDuration.GetDurationMeasurementUnit(ADurationFormat, AValueStr <> '1', True);
    AValue := Format('%s %s', [AValueStr, ADescription]);
  end;
end;

procedure TdxGanttDurationEditProperties.AddPossibleDescriptions;

  procedure InternalAdd(const ADescription: string);
  begin
    FHelper.AddPossibleDescription(ADescription);
    FHelper.AddPossibleDescription(TdxGanttControlDurationFieldHelper.ElapsedTimePrefix + ADescription);
    FHelper.AddPossibleDescription(ADescription + TdxGanttControlDurationFieldHelper.EstimatedTimePostfix);
    FHelper.AddPossibleDescription(TdxGanttControlDurationFieldHelper.ElapsedTimePrefix + ADescription + TdxGanttControlDurationFieldHelper.EstimatedTimePostfix);
  end;

begin
  TdxGanttControlDurationFieldHelper.InitializeDurationFormatDescriptions;
  InternalAdd(TdxGanttControlDurationFieldHelper.MinuteExtraShortName);
  InternalAdd(TdxGanttControlDurationFieldHelper.MinuteName);
  InternalAdd(TdxGanttControlDurationFieldHelper.MinutesName);
  InternalAdd(TdxGanttControlDurationFieldHelper.MinuteShortName);
  InternalAdd(TdxGanttControlDurationFieldHelper.MinutesShortName);
  InternalAdd(TdxGanttControlDurationFieldHelper.HourExtraShortName);
  InternalAdd(TdxGanttControlDurationFieldHelper.HourName);
  InternalAdd(TdxGanttControlDurationFieldHelper.HoursName);
  InternalAdd(TdxGanttControlDurationFieldHelper.HourShortName);
  InternalAdd(TdxGanttControlDurationFieldHelper.HoursShortName);
  InternalAdd(TdxGanttControlDurationFieldHelper.DayExtraShortName);
  InternalAdd(TdxGanttControlDurationFieldHelper.DayName);
  InternalAdd(TdxGanttControlDurationFieldHelper.DaysName);
  InternalAdd(TdxGanttControlDurationFieldHelper.WeekExtraShortName);
  InternalAdd(TdxGanttControlDurationFieldHelper.WeekName);
  InternalAdd(TdxGanttControlDurationFieldHelper.WeeksName);
  InternalAdd(TdxGanttControlDurationFieldHelper.WeekShortName);
  InternalAdd(TdxGanttControlDurationFieldHelper.WeeksShortName);
  InternalAdd(TdxGanttControlDurationFieldHelper.MonthExtraShortName);
  InternalAdd(TdxGanttControlDurationFieldHelper.MonthName);
  InternalAdd(TdxGanttControlDurationFieldHelper.MonthsName);
  InternalAdd(TdxGanttControlDurationFieldHelper.MonthShortName);
  InternalAdd(TdxGanttControlDurationFieldHelper.MonthsShortName);
end;

procedure TdxGanttDurationEditProperties.CreateHelper(const ADescription,
  ADefaultDescription: string; AMaxPrecession: Integer);
begin
  if FHelper <> nil then
  begin
    FHelper.Description := ADescription;
    FHelper.DefaultDescription := ADefaultDescription;
    FHelper.MaxPrecision := AMaxPrecession;
  end
  else
    FHelper := TdxMeasurementUnitEditHelper.Create(ADescription, 1, AMaxPrecession, 0, MaxCurrency, ADefaultDescription);
  AddPossibleDescriptions;
end;

class function TdxGanttDurationEditProperties.GetContainerClass: TcxContainerClass;
begin
  Result := TdxGanttMeasurementUnitEdit;
end;

procedure TdxGanttDurationEditProperties.Prepare(
  AColumn: TdxGanttControlSheetColumn; AData: TObject);
const
  AMaxPrecessions: array[Boolean] of Integer = (2, 1);
var
  ADurationFormat: TdxDurationFormat;
  AValue: Double;
  AValueHelper: IdxGanttControlDurationEditPropertiesHelper;
begin
  AValueHelper := AColumn as IdxGanttControlDurationEditPropertiesHelper;
  ADurationFormat := AValueHelper.GetDurationFormat(AData);
  AValue := AValueHelper.GetValue(AData);
  CreateHelper(' ' + TdxGanttControlDuration.GetDurationMeasurementUnit(ADurationFormat, AValue <> 1, True),
    cxGetResourceString(@sdxGanttControlDurationFormatDay),
    AMaxPrecessions[ADurationFormat in [TdxDurationFormat.Minutes, TdxDurationFormat.EstimatedMinutes,
    TdxDurationFormat.ElapsedMinutes, TdxDurationFormat.EstimatedElapsedMinutes]]);
  MinValue := FHelper.MinValue;
  MaxValue := FHelper.MaxValue;
end;

procedure TdxGanttDurationEditProperties.ValidateDisplayValue(
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean;
  AEdit: TcxCustomEdit);
var
  AValue: Variant;
  AFloatValue: Double;
begin
  AValue := FHelper.GetValueFromText(DisplayValue, False);
  if VarIsNull(AValue) then
    Error := True
  else
  begin
    AFloatValue := AValue;
    Error := (CompareValue(AFloatValue, FHelper.MinValue) < 0) or
             (CompareValue(AFloatValue, FHelper.MaxValue) > 0);
  end;
  if Error then
    ErrorText := cxGetResourceString(@sdxGanttControlMessageInvalidLagValue);
  inherited ValidateDisplayValue(DisplayValue, ErrorText, Error, AEdit);
end;

{ TdxGanttMeasurementUnitEdit }

class function TdxGanttMeasurementUnitEdit.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxGanttDurationEditProperties;
end;

{ TdxGanttCurrencyEditProperties }

class function TdxGanttCurrencyEditProperties.GetContainerClass: TcxContainerClass;
begin
  Result := TdxGanttCurrencyEdit;
end;

procedure TdxGanttCurrencyEditProperties.Initialize(AColumn: TdxGanttControlSheetColumn);
var
  ADataModelProperties: TdxGanttControlDataModelProperties;
  AFormatSettings: TFormatSettings;
begin
  ADataModelProperties := TdxCustomGanttControl(AColumn.Owner.Owner.Control).DataModel.Properties;
  dxGetLocaleFormatSettings(GetUserDefaultLCID, AFormatSettings);
  if ADataModelProperties.IsValueAssigned(TdxGanttPropertiesAssignedValue.CurrencyDigits) then
  begin
    AFormatSettings.CurrencyDecimals := Ord(ADataModelProperties.CurrencyDigits);
    DecimalPlaces := AFormatSettings.CurrencyDecimals;
  end;
  if ADataModelProperties.IsValueAssigned(TdxGanttPropertiesAssignedValue.CurrencySymbol) then
    AFormatSettings.CurrencyString := ADataModelProperties.CurrencySymbol;
  if ADataModelProperties.IsValueAssigned(TdxGanttPropertiesAssignedValue.CurrencySymbolPosition) then
    AFormatSettings.CurrencyFormat := Ord(ADataModelProperties.CurrencySymbolPosition);
  DisplayFormat := cxFormatController.GetCurrencyFormat(AFormatSettings);
end;

{ TdxGanttCurrencyEdit }

class function TdxGanttCurrencyEdit.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxGanttCurrencyEditProperties;
end;

{ TdxGanttControlPropertiesClassCollection }

class function TdxGanttControlPropertiesClassCollection.GetCostFieldPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxGanttCurrencyEditProperties;
end;

class function TdxGanttControlPropertiesClassCollection.GetDurationFieldPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxGanttDurationEditProperties;
end;

class function TdxGanttControlPropertiesClassCollection.GetFinishFieldPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxGanttFinishDateEditProperties;
end;

class function TdxGanttControlPropertiesClassCollection.GetFlagFieldPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxCheckBoxProperties;
end;

class function TdxGanttControlPropertiesClassCollection.GetNumberFieldPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxSpinEditProperties;
end;

class function TdxGanttControlPropertiesClassCollection.GetStartFieldPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxGanttStartDateEditProperties;
end;

class function TdxGanttControlPropertiesClassCollection.GetTextFieldPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxTextEditProperties;
end;

class procedure TdxGanttControlPropertiesClassCollection.InitializeEditProperties(AColumn: TdxGanttControlSheetColumn; AProperties: TcxCustomEditProperties);
begin
  if AProperties.InheritsFrom(TdxGanttCurrencyEditProperties) then
    TdxGanttCurrencyEditProperties(AProperties).Initialize(AColumn);
end;

class procedure TdxGanttControlPropertiesClassCollection.PrepareEditProperties(
  AColumn: TdxGanttControlSheetColumn; AProperties: TcxCustomEditProperties; AData: TObject);
begin
  if AProperties.InheritsFrom(TdxGanttDateEditProperties) then
  begin
    TdxGanttDateEditProperties(AProperties).FData := AData;
    TdxGanttDateEditProperties(AProperties).FColumn := AColumn;
  end;
  if AProperties.InheritsFrom(TdxGanttDurationEditProperties) then
    TdxGanttDurationEditProperties(AProperties).Prepare(AColumn, AData);
end;

{ TdxGanttControlExtendedAttributeSheetColumn }

constructor TdxGanttControlExtendedAttributeSheetColumn.Create(
  AOwner: TdxGanttControlSheetColumns; const AFieldName: string);
begin
  inherited Create(AOwner);
  SetFieldName(AFieldName);
  DataModel.PropertiesChangedHandlers.Add(PropertiesChangedHandler);
end;

destructor TdxGanttControlExtendedAttributeSheetColumn.Destroy;
begin
  DataModel.PropertiesChangedHandlers.Remove(PropertiesChangedHandler);
  inherited Destroy;
end;

procedure TdxGanttControlExtendedAttributeSheetColumn.DoCaptionChanged(const ANewCaption: string);
var
  AAttribute: TdxGanttControlExtendedAttribute;
begin
  AAttribute := DataModel.ExtendedAttributes.Find(GetFieldID);
  if AAttribute <> nil then
    AAttribute.Alias := Caption;
  inherited DoCaptionChanged(ANewCaption);
end;

function TdxGanttControlExtendedAttributeSheetColumn.CreateProperties: TcxCustomEditProperties;
begin
  Result := inherited CreateProperties;
  TdxGanttControlPropertiesClassCollection.InitializeEditProperties(Self, Result);
  if Result <> nil then
    Result.Alignment.Vert := taTopJustify;
end;

function TdxGanttControlExtendedAttributeSheetColumn.GetActiveCalendar(
  ADataItem: TObject): TdxGanttControlCalendar;
begin
  Result := DataModel.ActiveCalendar;
end;

function TdxGanttControlExtendedAttributeSheetColumn.GetAlignment: TAlignment;
begin
  if &Type in [TdxGanttControlExtendedAttributeCFType.Number, TdxGanttControlExtendedAttributeCFType.Cost] then
    Result := taRightJustify
  else
    Result := inherited GetAlignment;
end;

function TdxGanttControlExtendedAttributeSheetColumn.GetDataModel: TdxGanttControlDataModel;
begin
  Result := TdxCustomGanttControl(TdxGanttControlCustomView(Owner.Owner.Owner).Owner).DataModel;
end;

function TdxGanttControlExtendedAttributeSheetColumn.GetDefaultAllowWordWrap: TdxDefaultBoolean;
begin
  if &Type = TdxGanttControlExtendedAttributeCFType.Flag then
    Result := bFalse
  else
    Result := bDefault;
end;

function TdxGanttControlExtendedAttributeSheetColumn.GetDefaultCaption: string;
var
  AAttribute: TdxGanttControlExtendedAttribute;
begin
  AAttribute := DataModel.ExtendedAttributes.Find(GetFieldID);
  if (AAttribute <> nil) and AAttribute.IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.Alias) then
    Result := AAttribute.Alias
  else
    Result := FFieldName;
end;

function TdxGanttControlExtendedAttributeSheetColumn.GetDurationFormat(
  ADataItem: TObject): TdxDurationFormat;
var
  AAttributes: TdxGanttControlExtendedAttributeValues;
begin
  Result := TdxGanttControlDataModelPropertiesAccess(DataModel.Properties).GetActualDurationFormat;
  if ADataItem <> nil then
  begin
    AAttributes := GetExtendedAttributeValues(ADataItem);
    if AAttributes[FieldName] <> nil then
      Result := AAttributes[FieldName].DurationFormat;
  end;
end;

function TdxGanttControlExtendedAttributeSheetColumn.GetEditValue(
  AData: TObject): Variant;
var
  AValues: TdxGanttControlExtendedAttributeValues;
  AValue: TdxGanttControlExtendedAttributeValue;
begin
  Result := Null;
  if AData = nil then
    Exit;
  AValues := GetExtendedAttributeValues(AData);
  AValue := AValues[FieldName];
  if AValue = nil then
    Exit;
  if AValue.&Type = TdxGanttControlExtendedAttributeCFType.Duration then
    Result := AValue.DurationAsDisplayValue
  else
    Result := AValue.Value;
end;

function TdxGanttControlExtendedAttributeSheetColumn.GetHintText: string;
begin
  case &Type of
    TdxGanttControlExtendedAttributeCFType.Cost:
      Result := cxGetResourceString(@sdxGanttControlSheetExtendedAttributeCostColumnDescription);
    TdxGanttControlExtendedAttributeCFType.Start:
      Result := cxGetResourceString(@sdxGanttControlSheetExtendedAttributeStartColumnDescription);
    TdxGanttControlExtendedAttributeCFType.Date:
      Result := cxGetResourceString(@sdxGanttControlSheetExtendedAttributeDateColumnDescription);
    TdxGanttControlExtendedAttributeCFType.Duration:
      Result := cxGetResourceString(@sdxGanttControlSheetExtendedAttributeDurationColumnDescription);
    TdxGanttControlExtendedAttributeCFType.Finish:
      Result := cxGetResourceString(@sdxGanttControlSheetExtendedAttributeFinishColumnDescription);
    TdxGanttControlExtendedAttributeCFType.Flag:
      Result := cxGetResourceString(@sdxGanttControlSheetExtendedAttributeFlagColumnDescription);
    TdxGanttControlExtendedAttributeCFType.Number:
      Result := cxGetResourceString(@sdxGanttControlSheetExtendedAttributeNumberColumnDescription);
    TdxGanttControlExtendedAttributeCFType.Text:
      Result := cxGetResourceString(@sdxGanttControlSheetExtendedAttributeTextColumnDescription);
  else
    Result := '';
  end;
end;

function TdxGanttControlExtendedAttributeSheetColumn.GetProperties(AProperties: TStrings): Boolean;
begin
  Result := inherited GetProperties(AProperties);
  AProperties.Add('FieldName');
end;

procedure TdxGanttControlExtendedAttributeSheetColumn.GetPropertyValue(const AName: string; var AValue: Variant);
begin
  if AName = 'FieldName' then
    AValue := FieldName
  else
    inherited GetPropertyValue(AName, AValue);
end;

procedure TdxGanttControlExtendedAttributeSheetColumn.SetPropertyValue(const AName: string; const AValue: Variant);
begin
  if AName = 'FieldName' then
    FFieldName := AValue
  else
    inherited SetPropertyValue(AName, AValue);
end;

function TdxGanttControlExtendedAttributeSheetColumn.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  case &Type of
    TdxGanttControlExtendedAttributeCFType.Cost:
      Result := TdxGanttControlPropertiesClassCollection.GetCostFieldPropertiesClass;
    TdxGanttControlExtendedAttributeCFType.Start,
    TdxGanttControlExtendedAttributeCFType.Date:
      Result := TdxGanttControlPropertiesClassCollection.GetStartFieldPropertiesClass;
    TdxGanttControlExtendedAttributeCFType.Duration:
      Result := TdxGanttControlPropertiesClassCollection.GetDurationFieldPropertiesClass;
    TdxGanttControlExtendedAttributeCFType.Finish:
      Result := TdxGanttControlPropertiesClassCollection.GetFinishFieldPropertiesClass;
    TdxGanttControlExtendedAttributeCFType.Flag:
      Result := TdxGanttControlPropertiesClassCollection.GetFlagFieldPropertiesClass;
    TdxGanttControlExtendedAttributeCFType.Number:
      Result := TdxGanttControlPropertiesClassCollection.GetNumberFieldPropertiesClass;
  else
    Result := TdxGanttControlPropertiesClassCollection.GetTextFieldPropertiesClass;
  end;
end;

function TdxGanttControlExtendedAttributeSheetColumn.GetType: TdxGanttControlExtendedAttributeCFType;
begin
  Result := TdxGanttControlExtendedAttributeHelper.GetFieldType(GetFieldID);
end;

function TdxGanttControlExtendedAttributeSheetColumn.GetValue(
  ADataItem: TObject): Double;
var
  AAttributes: TdxGanttControlExtendedAttributeValues;
  AAttribute: TdxGanttControlExtendedAttributeValue;
  ADurationFormat: TdxDurationFormat;
begin
  Result := 0;
  if ADataItem <> nil then
  begin
    AAttributes := GetExtendedAttributeValues(ADataItem);
    AAttribute := AAttributes[FieldName];
    if AAttribute = nil then
      Exit;
    if AAttribute.IsValueAssigned(TdxGanttExtendedAttributeValueAssignedValue.DurationFormat) then
      ADurationFormat := AAttribute.DurationFormat
    else
      ADurationFormat := TdxGanttControlDataModelPropertiesAccess(DataModel.Properties).GetActualDurationFormat;
    Result := TdxGanttControlDuration.GetDurationValue(VarToStr(AAttribute.Value), ADurationFormat);
  end;
end;

function TdxGanttControlExtendedAttributeSheetColumn.ShowEditorImmediately: Boolean;
begin
  Result := &Type = TdxGanttControlExtendedAttributeCFType.Flag;
end;

procedure TdxGanttControlExtendedAttributeSheetColumn.PrepareEditProperties(
  AProperties: TcxCustomEditProperties; AData: TObject);
begin
  inherited PrepareEditProperties(AProperties, AData);
  TdxGanttControlPropertiesClassCollection.PrepareEditProperties(Self, AProperties, AData);
end;

procedure TdxGanttControlExtendedAttributeSheetColumn.PropertiesChangedHandler(
  Sender: TObject);
begin
  TdxGanttControlPropertiesClassCollection.InitializeEditProperties(Self, Properties);
end;

procedure TdxGanttControlExtendedAttributeSheetColumn.SetFieldName(
  const AValue: string);
var
  AFieldID: Integer;
begin
  if FieldName <> AValue then
  begin
    AFieldID := GetFieldID;
    FFieldName := AValue;
    DoReset;
    if AFieldID <> GetFieldID then
      RecreateProperties;
  end;
end;

{ TdxGanttControlViewSheetColumns }

function TdxGanttControlViewSheetColumns.AddExtendedAttributeColumn(
  const AFieldName: string): TdxGanttControlExtendedAttributeSheetColumn;
begin
  Result := GetExtendedAttributeColumnClass.Create(Self, AFieldName);
  List.Add(Result);
  Changed;
end;

procedure TdxGanttControlViewSheetColumns.AddExtendedAttributeColumns(AType: TdxGanttControlExtendedAttributeCFType);
var
  I: Integer;
  AFieldName: string;
begin
  for I := 1 to TdxGanttControlExtendedAttributeHelper.FieldCountMap[AType] do
  begin
    AFieldName := Format('%s%d', [TdxGanttControlExtendedAttributeHelper.PatternNameMap[AType], I]);
    if GetExtendedAttributeColumn(AFieldName) = nil then
      AddExtendedAttributeColumn(AFieldName).Visible := False;
  end;
end;

function TdxGanttControlViewSheetColumns.GetDataModel: TdxGanttControlDataModel;
begin
  Result := TdxCustomGanttControl(TdxGanttControlCustomView(Owner.Owner).Owner).DataModel;
end;

function TdxGanttControlViewSheetColumns.GetExtendedAttributeColumn(
  const AFieldName: string): TdxGanttControlExtendedAttributeSheetColumn;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].InheritsFrom(TdxGanttControlExtendedAttributeSheetColumn) and (TdxGanttControlExtendedAttributeSheetColumn(Items[I]).FieldName = AFieldName) then
      Exit(TdxGanttControlExtendedAttributeSheetColumn(Items[I]));
  Result := nil;
end;

procedure TdxGanttControlViewSheetColumns.RetrieveMissingExtendedAttributeColumns;
var
  I: Integer;
  AAttribute: TdxGanttControlExtendedAttribute;
  AExtendedAttributes: TdxGanttControlExtendedAttributes;
  AColumn: TdxGanttControlExtendedAttributeSheetColumn;
begin
  AExtendedAttributes := DataModel.ExtendedAttributes;
  for I := 0 to AExtendedAttributes.Count - 1 do
  begin
    AAttribute := AExtendedAttributes[I];
    if (AAttribute.Level = GetFieldLevel) then
    begin
      AColumn := GetExtendedAttributeColumn(AAttribute.FieldName);
      if AColumn = nil then
        AddExtendedAttributeColumn(AAttribute.FieldName)
      else
        AColumn.Visible := True;
    end;
  end;
end;

{ TdxGanttControlCheckBoxViewInfo }

constructor TdxGanttControlCheckBoxViewInfo.Create(AOwner: TdxGanttControlSheetCellCustomViewInfo);
begin
  inherited Create(AOwner);
end;

procedure TdxGanttControlCheckBoxViewInfo.Calculate(const R: TRect);

  function GetValue(AColumn: TdxGanttControlSheetColumnAccess): TcxCheckBoxState;
  var
    AValue: Variant;
  begin
    AValue := AColumn.GetEditValue(Owner.Owner.Data);
    if VarCompare(AValue, True) = 0 then
      Result := cbsChecked
    else if VarCompare(AValue, False) = 0 then
      Result := cbsUnchecked
    else
      Result := cbsGrayed;
  end;

  function IsBestFitCalculating: Boolean;
  begin
    Result := R.Width = MaxInt;
  end;

var
  AColumn: TdxGanttControlSheetColumnAccess;
begin
  inherited Calculate(R);
  if IsBestFitCalculating then
    Exit;
  AColumn := TdxGanttControlSheetColumnAccess(Column);
  FEditRect := R;
  FEditRect.Bottom := FEditRect.Bottom - 1;
  if UseRightToLeftAlignment then
    FEditRect.Left := FEditRect.Left + 1
  else
    FEditRect.Right := FEditRect.Right - 1;
  FImage := CanvasCache.GetCheckBoxImage(AColumn.Properties, FEditRect.Size, GetValue(AColumn), ScaleFactor);
end;

procedure TdxGanttControlCheckBoxViewInfo.DoDraw;
var
  AImage: TcxCanvasBasedImage;
begin
  AImage := CanvasCache.GetImage(FImage);
  Canvas.DrawImage(FImage, FEditRect, @AImage);
end;

function TdxGanttControlCheckBoxViewInfo.GetColumn: TdxGanttControlSheetColumn;
begin
  Result := Owner.Column;
end;

function TdxGanttControlCheckBoxViewInfo.GetOwner: TdxGanttControlSheetCellCustomViewInfo;
begin
  Result := TdxGanttControlSheetCellCustomViewInfo(inherited Owner);
end;

function TdxGanttControlCheckBoxViewInfo.IsHitTestTransparent: Boolean;
begin
  Result := True;
end;

end.
