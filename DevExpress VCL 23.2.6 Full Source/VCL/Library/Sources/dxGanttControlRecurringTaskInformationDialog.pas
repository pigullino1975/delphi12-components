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

unit dxGanttControlRecurringTaskInformationDialog;

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  System.UITypes,
  Windows, Messages, SysUtils, Generics.Defaults, Generics.Collections, Variants, Classes, Graphics, Controls, Forms,
  ComCtrls, Dialogs,
  dxForms, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxLayoutcxEditAdapters,
  dxLayoutControlAdapters, cxContainer, cxEdit, Menus, StdCtrls, cxButtons, dxLayoutContainer, cxSpinEdit,
  dxMeasurementUnitEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxClasses, dxLayoutControl, dxLayoutLookAndFeels,
  dxCore, dxGanttControl, dxGanttControlCustomDataModel, dxGanttControlDataModel, dxGanttControlStrs,
  dxGanttControlDialogUtils, dxGanttControlViewChart, dxGanttControlTasks, dxGanttControlCustomClasses,
  dxGanttControlCommands, dxGanttControlCalendars,
  cxDateUtils, cxCalendar, cxPC, cxGroupBox;

type
  TdxGanttControlRecurringTaskInformationDialogForm = class(TdxForm)
    lcMainGroup_Root: TdxLayoutGroup;
    lcMain: TdxLayoutControl;
    meDuration: TdxMeasurementUnitEdit;
    liDuration: TdxLayoutItem;
    btnOk: TcxButton;
    liBtnOk: TdxLayoutItem;
    btnCancel: TcxButton;
    liBtnCancel: TdxLayoutItem;
    lgButtons: TdxLayoutGroup;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel;
    edName: TcxTextEdit;
    liName: TdxLayoutItem;
    lgRecurrenceRange: TdxLayoutGroup;
    deRangeStart: TcxDateEdit;
    liRangeStart: TdxLayoutItem;
    deRangeEndBy: TcxDateEdit;
    liRangeEndBy: TdxLayoutItem;
    lgTogGroup: TdxLayoutGroup;
    lgTabs: TdxLayoutGroup;
    cmbCalendar: TcxComboBox;
    liCalendar: TdxLayoutItem;
    lgRecurrencePattern: TdxLayoutGroup;
    lgRecurrencePeriod: TdxLayoutGroup;
    lgRecurrencePatternSetup: TdxLayoutGroup;
    lrbDaily: TdxLayoutRadioButtonItem;
    lrbWeekly: TdxLayoutRadioButtonItem;
    lrbMonthly: TdxLayoutRadioButtonItem;
    lrbYearly: TdxLayoutRadioButtonItem;
    lgRecurrencePatternSetupDays: TdxLayoutGroup;
    lgRecurrencePatternSetupWeeks: TdxLayoutGroup;
    lgRecurrencePatternSetupMonths: TdxLayoutGroup;
    lgRecurrencePatternSetupYears: TdxLayoutGroup;
    dxLayoutGroup1: TdxLayoutGroup;
    seDailyEvery: TcxSpinEdit;
    liDailyEvery: TdxLayoutItem;
    lrbDailyEveryDays: TdxLayoutRadioButtonItem;
    lrbDailyEveryWorkdays: TdxLayoutRadioButtonItem;
    dxLayoutSeparatorItem2: TdxLayoutSeparatorItem;
    dxLayoutGroup3: TdxLayoutGroup;
    dxLayoutGroup4: TdxLayoutGroup;
    seWeeklyEvery: TcxSpinEdit;
    liWeeklyRecurEveryWeeks: TdxLayoutItem;
    liWeeklyRecurEveryWeeksOn: TdxLayoutLabeledItem;
    lcbSunday: TdxLayoutCheckBoxItem;
    lcbMonday: TdxLayoutCheckBoxItem;
    lcbTuesday: TdxLayoutCheckBoxItem;
    lcbWednesday: TdxLayoutCheckBoxItem;
    lcbThursday: TdxLayoutCheckBoxItem;
    lcbFriday: TdxLayoutCheckBoxItem;
    lcbSaturday: TdxLayoutCheckBoxItem;
    seMonthlyDay: TcxSpinEdit;
    liMonthlyDay: TdxLayoutItem;
    dxLayoutGroup9: TdxLayoutGroup;
    seMonthlyDayOfEvery: TcxSpinEdit;
    liMonthlyDayOfEvery: TdxLayoutItem;
    lbMonthlyDayOfEveryMonths: TdxLayoutLabeledItem;
    dxLayoutGroup10: TdxLayoutGroup;
    lrbMonthlyDay: TdxLayoutRadioButtonItem;
    lrbMonthlyThe: TdxLayoutRadioButtonItem;
    cmbMonthlyTheRegularDay: TcxComboBox;
    liMonthlyTheRegularDay: TdxLayoutItem;
    cmbMonthlyTheWeekDay: TcxComboBox;
    liMonthlyTheWeekDay: TdxLayoutItem;
    seMonthlyTheDayOfEvery: TcxSpinEdit;
    liMonthlyTheDayOfEvery: TdxLayoutItem;
    lbMonthlyTheDayOfEveryMonths: TdxLayoutLabeledItem;
    dxLayoutGroup11: TdxLayoutGroup;
    dxLayoutGroup12: TdxLayoutGroup;
    lrbYearlyOn: TdxLayoutRadioButtonItem;
    lrbYearlyThe: TdxLayoutRadioButtonItem;
    cmbYearlyTheRegularDay: TcxComboBox;
    liYearlyTheRegularDay: TdxLayoutItem;
    cmbYearlyTheRegularWeekDay: TcxComboBox;
    liYearlyTheRegularWeekDay: TdxLayoutItem;
    cmbYearlyTheMonth: TcxComboBox;
    liYearlyTheMonth: TdxLayoutItem;
    ceYearlyOnDay: TcxSpinEdit;
    liYearlyOnDay: TdxLayoutItem;
    cmbYearlyOnMonth: TcxComboBox;
    liYearlyOnMonth: TdxLayoutItem;
    dxLayoutGroup13: TdxLayoutGroup;
    lrbRangeEndAfter: TdxLayoutRadioButtonItem;
    lrbRangeEndBy: TdxLayoutRadioButtonItem;
    seRangeEndAfter: TcxSpinEdit;
    liRangeEndAfterOccurrences: TdxLayoutItem;
    lgCalendar: TdxLayoutGroup;
    dxLayoutGroup2: TdxLayoutGroup;
    AlignmentConstraint1: TdxLayoutAlignmentConstraint;
    AlignmentConstraint2: TdxLayoutAlignmentConstraint;
    dxLayoutGroup5: TdxLayoutGroup;
    dxLayoutGroup6: TdxLayoutGroup;
    AlignmentConstraint4: TdxLayoutAlignmentConstraint;
    AlignmentConstraint5: TdxLayoutAlignmentConstraint;
    AlignmentConstraint6: TdxLayoutAlignmentConstraint;
    AlignmentConstraint7: TdxLayoutAlignmentConstraint;
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnOkClick(Sender: TObject);
    procedure meDurationPropertiesEditValueChanged(Sender: TObject);
    procedure lrbDailyClick(Sender: TObject);
    procedure deRangeStartPropertiesCloseUp(Sender: TObject);
    procedure deRangeEndByPropertiesCloseUp(Sender: TObject);
    procedure cmbYearlyOnMonthPropertiesChange(Sender: TObject);
    procedure deRangeStartPropertiesEditValueChanged(Sender: TObject);
    procedure seRangeEndAfterPropertiesEditValueChanged(Sender: TObject);
    procedure deRangeEndByPropertiesEditValueChanged(Sender: TObject);
  private
    FActualTask: TdxGanttControlTask;
    FDurationEditHelper: TdxMeasurementUnitEditHelper;
    FInitialDurationHasEstimatedFormat: Boolean;
    FInitializing: Boolean;
    FPercentEditHelper: TdxMeasurementUnitEditHelper;
    FTask: TdxGanttControlTask;

    function GetGanttControl: TdxCustomGanttControl;
  protected
    procedure ApplyLocalization; virtual;
    procedure AddPossibleDurationDescriptions; virtual;
    procedure CalculateRangeInfo;
    procedure CheckDialogItemsEnabling; virtual;
    function GetActualCalendarUID: Integer;
    function GetActualDurationFormat(var AError: Boolean; var AErrorText: TCaption): TdxDurationFormat;
    function GetActualDurationValue: Variant;
    function GetInitialDurationDescription(AFormat: TdxDurationFormat): string; virtual;
    function GetWeekDayRegularNumber(ADate: TDateTime): Word;
    procedure Initialize; virtual;
    procedure InitializeCalendar; virtual;
    procedure InitializeDurationEditor;
    procedure InitializeDaily; virtual;
    procedure InitializeWeekly; virtual;
    procedure InitializeMonthly; virtual;
    procedure InitializeRange; virtual;
    procedure InitializeYearly; virtual;
    class procedure InitializeMeasurementUnits;
    procedure PopulateRecurrenceInfo(var ATask: TdxGanttControlTask);
    function ValidateRecurrenceInfo(var AErrorText: TCaption): Boolean; virtual;

    procedure DurationEditIncrementValueHandler(Sender: TObject; AButton: TcxSpinEditButton;
      var AValue: Variant; var AHandled: Boolean);
    procedure DurationEditValidateHandler(Sender: TObject; var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);

    property ActualTask: TdxGanttControlTask read FActualTask;
    property GanttControl: TdxCustomGanttControl read GetGanttControl;
    property DurationEditHelper: TdxMeasurementUnitEditHelper read FDurationEditHelper;
    property PercentEditHelper: TdxMeasurementUnitEditHelper read FPercentEditHelper;
    property Task: TdxGanttControlTask read FTask;
  public
    constructor Create(AGanttControl: TdxGanttControlBase; ATask: TdxGanttControlTask); reintroduce; overload; virtual;
    constructor Create(AGanttControl: TdxGanttControlBase; ANewTaskIndex: Integer); reintroduce; overload; virtual;
    destructor Destroy; override;
  end;

  TdxGanttControlRecurringTaskInformationDialogFormClass = class of TdxGanttControlRecurringTaskInformationDialogForm;

var
  dxGanttControlRecurringTaskInformationDialogFormClass: TdxGanttControlRecurringTaskInformationDialogFormClass = TdxGanttControlRecurringTaskInformationDialogForm;

procedure ShowRecurringTaskInformationDialog(AController: TdxGanttControlChartViewController; ATask: TdxGanttControlTask); overload;
procedure ShowRecurringTaskInformationDialog(AGanttControl: TdxGanttControlBase; ATask: TdxGanttControlTask); overload;

implementation

{$R *.dfm}

uses
  DateUtils,
  Math,
  StrUtils,
  dxCoreClasses,
  cxGeometry,
  dxMessageDialog,
  dxCultureInfo,
  dxGanttControlUtils,
  dxGanttControlTaskCommands;

const
  dxThisUnitName = 'dxGanttControlRecurringTaskInformationDialog';

var
  dxGanttCalendarUIDs: TArray<Integer>;

type
  TdxCustomGanttControlAccess = class(TdxCustomGanttControl);
  TdxLayoutContainerAccess = class(TdxLayoutContainer);
  TdxLayoutContainerFocusControllerAccess = class(TdxLayoutContainerFocusController);

type
  { TdxDurationEditHelper }

  TdxDurationEditHelper = class(TdxMeasurementUnitEditHelper)
  protected
    function GetCheckableCandidate(const ADescription: string): string; override;
  end;

function TdxDurationEditHelper.GetCheckableCandidate(const ADescription: string): string;
begin
  Result := inherited GetCheckableCandidate(ADescription);
  while (Length(Result) > 1) and
    (Result[Length(Result)] = dxduEstimatedTimePostfix[1]) and (Result[Length(Result) - 1] = dxduEstimatedTimePostfix[1]) do
    Delete(Result, Length(Result), 1);
end;

function DayTypeToWeekDayAsIndex(ADayType: TdxGanttControlRecurrenceDayType): Integer;
begin
  Result := Ord(ADayType) - Ord(TdxGanttControlRecurrenceDayType.Monday);
  if Result < 0 then
    Inc(Result, 7);
end;

function IndexWeekDayToDayType(Value: Integer): TdxGanttControlRecurrenceDayType;
begin
  Inc(Value);
  if Value >= 7 then
    Dec(Value, 7);
  Result := TdxGanttControlRecurrenceDayType(Value + Ord(TdxGanttControlRecurrenceDayType.Sunday));
end;

{ TdxGanttControlRecurringTaskInformationDialogForm }

constructor TdxGanttControlRecurringTaskInformationDialogForm.Create(
  AGanttControl: TdxGanttControlBase; ATask: TdxGanttControlTask);
var
  AValue: TdxGanttTaskAssignedValue;
begin
  inherited Create(AGanttControl);
  FTask := ATask;
  FActualTask := TdxGanttControlTask.Create(ATask.Owner);
  FActualTask.BeginUpdate;
  FActualTask.Assign(Task);
  for AValue := Low(TdxGanttTaskAssignedValue) to High(TdxGanttTaskAssignedValue) do
    FActualTask.ResetValue(AValue);
  Initialize;
end;

constructor TdxGanttControlRecurringTaskInformationDialogForm.Create(
  AGanttControl: TdxGanttControlBase; ANewTaskIndex: Integer);
begin
  inherited Create(AGanttControl);
  FTask := nil;
  FActualTask := TdxGanttControlTask.Create(GanttControl.DataModel.Tasks);
  Initialize;
end;

destructor TdxGanttControlRecurringTaskInformationDialogForm.Destroy;
begin
  FreeAndNil(FDurationEditHelper);
  FreeAndNil(FPercentEditHelper);
  FreeAndNil(FActualTask);
  inherited Destroy;
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  ADisplayValue: Variant;
  AErrorText: TCaption;
  AError: Boolean;
  ADurationFormat: TdxDurationFormat;
begin
  if ModalResult <> mrOk then
    Exit;

  if FActualTask <> nil then
  begin
    DurationEditValidateHandler(nil, ADisplayValue, AErrorText, AError);
    CanClose := not AError;
    if not CanClose then
    begin
      dxMessageDlg(AErrorText, mtWarning, [mbOK], 0);
      meDuration.SetFocus;
      Exit;
    end;
    ADurationFormat := GetActualDurationFormat(AError, AErrorText);
    if Task <> nil then
      if ((ADurationFormat = TdxDurationFormat.Days) and (Task.RecurrencePattern.DurationFormat = TdxDurationFormat.Null)) or
         ((ADurationFormat = TdxDurationFormat.EstimatedDays) and (Task.RecurrencePattern.DurationFormat = TdxDurationFormat.EstimatedNull)) then
        ADurationFormat := Task.RecurrencePattern.DurationFormat;
    FActualTask.Name := Trim(edName.Text);
    FActualTask.DurationFormat := ADurationFormat;
    FActualTask.RecurrencePattern.DurationFormat := ADurationFormat;
    PopulateRecurrenceInfo(FActualTask);
    CanClose := ValidateRecurrenceInfo(AErrorText);
    if not CanClose then
    begin
      dxMessageDlg(AErrorText, mtWarning, [mbOK], 0);
      TdxLayoutContainerFocusControllerAccess(TdxLayoutContainerAccess(lcbMonday.Container).FocusController).SetItemFocus(lcbMonday);
      Exit;
    end;
  end;

  if CanClose and (FActualTask = nil) then
    CanClose := not GanttControl.OptionsBehavior.ConfirmDelete or
                   (dxMessageDlg(GetDeletingTaskConfirmation(Task), mtConfirmation, [mbOK, mbCancel], 0) = mrOk);
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.FormShow(Sender: TObject);
var
  dH, dW: Integer;
begin
  lcMain.HandleNeeded;
  dH := lcMain.OccupiedClientHeight + lcMain.Top - ClientHeight;
  dW := lcMain.OccupiedClientWidth - ClientWidth;
  Width := Width + dW;
  Height := Height + dH;
  edName.SetFocus;
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.ApplyLocalization;

  procedure PopulateRegularItems(AComboBox: TcxComboBox);
  begin
    with AComboBox.Properties.Items do
    begin
      Clear;
      Add(cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogFirst));
      Add(cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogSecond));
      Add(cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogThird));
      Add(cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogFourth));
      Add(cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogLast));
    end;
  end;

  procedure PopulateWeekDays(AComboBox: TcxComboBox);
  begin
    AComboBox.Properties.Items.Clear;
    AComboBox.Properties.Items.Add(TdxCultureInfo.CurrentCulture.FormatSettings.LongDayNames[2]);   // Mon
    AComboBox.Properties.Items.Add(TdxCultureInfo.CurrentCulture.FormatSettings.LongDayNames[3]);   // Tue
    AComboBox.Properties.Items.Add(TdxCultureInfo.CurrentCulture.FormatSettings.LongDayNames[4]);   // Wed
    AComboBox.Properties.Items.Add(TdxCultureInfo.CurrentCulture.FormatSettings.LongDayNames[5]);   // Thu
    AComboBox.Properties.Items.Add(TdxCultureInfo.CurrentCulture.FormatSettings.LongDayNames[6]);   // Fri
    AComboBox.Properties.Items.Add(TdxCultureInfo.CurrentCulture.FormatSettings.LongDayNames[7]);   // Sat
    AComboBox.Properties.Items.Add(TdxCultureInfo.CurrentCulture.FormatSettings.LongDayNames[1]);   // Sun
  end;

  procedure PopulateMonths(AComboBox: TcxComboBox);
  var
    AMonth: Word;
  begin
    AComboBox.Properties.Items.Clear;
    for AMonth := 1 to 12 do
      AComboBox.Properties.Items.Add(TdxCultureInfo.CurrentCulture.FormatSettings.LongMonthNames[AMonth]);
  end;

begin
  InitializeMeasurementUnits;
  Caption := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogCaption);

  liName.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogTaskName);
  liDuration.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogTaskDuration);

  lgRecurrencePattern.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogRecurrencePattern);
  lrbDaily.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogDaily);
  liDailyEvery.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogDailyEvery);
  lrbDailyEveryDays.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogDailyEveryDays);
  lrbDailyEveryWorkdays.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogDailyEveryWorkdays);

  lrbWeekly.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogWeekly);
  liWeeklyRecurEveryWeeks.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogWeeklyRecurEvery);
  liWeeklyRecurEveryWeeksOn.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogWeeklyRecurWeeksOn);
  lcbSunday.CaptionOptions.Text := TdxCultureInfo.CurrentCulture.FormatSettings.LongDayNames[1];
  lcbMonday.CaptionOptions.Text := TdxCultureInfo.CurrentCulture.FormatSettings.LongDayNames[2];
  lcbTuesday.CaptionOptions.Text := TdxCultureInfo.CurrentCulture.FormatSettings.LongDayNames[3];
  lcbWednesday.CaptionOptions.Text := TdxCultureInfo.CurrentCulture.FormatSettings.LongDayNames[4];
  lcbThursday.CaptionOptions.Text := TdxCultureInfo.CurrentCulture.FormatSettings.LongDayNames[5];
  lcbFriday.CaptionOptions.Text := TdxCultureInfo.CurrentCulture.FormatSettings.LongDayNames[6];
  lcbSaturday.CaptionOptions.Text := TdxCultureInfo.CurrentCulture.FormatSettings.LongDayNames[7];

  lrbMonthly.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogMonthly);
  lrbMonthlyDay.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogDay);
  liMonthlyDayOfEvery.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogOfEvery);
  lbMonthlyDayOfEveryMonths.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogMonths);
  lrbMonthlyThe.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogThe);
  liMonthlyTheDayOfEvery.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogOfEvery);
  lbMonthlyTheDayOfEveryMonths.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogMonths);
  PopulateRegularItems(cmbMonthlyTheRegularDay);
  PopulateWeekDays(cmbMonthlyTheWeekDay);

  lrbYearly.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogYearly);
  lrbYearlyOn.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogOn);
  lrbYearlyThe.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogThe);
  liYearlyTheMonth.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogOf);
  PopulateMonths(cmbYearlyOnMonth);
  PopulateRegularItems(cmbYearlyTheRegularDay);
  PopulateWeekDays(cmbYearlyTheRegularWeekDay);
  PopulateMonths(cmbYearlyTheMonth);

  lgRecurrenceRange.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogRange);
  liRangeStart.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogRangeStart);
  lrbRangeEndAfter.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogRangeEndAfter);
  liRangeEndAfterOccurrences.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogRangeEndAfterOccurrences);
  lrbRangeEndBy.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogRangeEndBy);

  lgCalendar.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogSchedulingCalendar);
  liCalendar.CaptionOptions.Text := cxGetResourceString(@sdxGanttControlRecurringTaskInformationDialogSchedulingCalendarName);

  btnOk.Caption := cxGetResourceString(@sdxGanttControlDialogOk);
  btnCancel.Caption := cxGetResourceString(@sdxGanttControlDialogCancel);
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.AddPossibleDurationDescriptions;
begin
  TdxGanttControlDialogUtils.PopulatePossibleDescriptions(DurationEditHelper, True);
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.CalculateRangeInfo;
var
  ATask: TdxGanttControlTask;
  AOccurrences: TList<TDateTime>;
begin
  if FInitializing then
    Exit;
  ATask := TdxGanttControlTask.Create(FActualTask.Owner);
  try
    ATask.Assign(FActualTask);
    PopulateRecurrenceInfo(ATask);
    AOccurrences := TdxGanttControlOccurrencesCalculator.GetOccurrences(ATask);
    try
      if not liRangeEndAfterOccurrences.Enabled then
        seRangeEndAfter.Value := AOccurrences.Count
      else
        if AOccurrences.Count > 0 then
          deRangeEndBy.Date := Int(AOccurrences[AOccurrences.Count - 1])
        else
          deRangeEndBy.Date := Int(deRangeStart.Date);
    finally
      AOccurrences.Free;
    end;
  finally
    ATask.Free;
  end;
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.CheckDialogItemsEnabling;
begin
  if FInitializing then
    Exit;
  if lrbDaily.Checked then
    lgRecurrencePatternSetup.ItemIndex := lrbDaily.Tag
  else if lrbWeekly.Checked then
    lgRecurrencePatternSetup.ItemIndex := lrbWeekly.Tag
  else if lrbMonthly.Checked then
    lgRecurrencePatternSetup.ItemIndex := lrbMonthly.Tag
  else
    lgRecurrencePatternSetup.ItemIndex := lrbYearly.Tag;

  liMonthlyDay.Enabled := lrbMonthlyDay.Checked;
  liMonthlyDayOfEvery.Enabled := liMonthlyDay.Enabled;
  lbMonthlyDayOfEveryMonths.Enabled := liMonthlyDay.Enabled;
  liMonthlyTheRegularDay.Enabled := not liMonthlyDay.Enabled;
  liMonthlyTheWeekDay.Enabled := not liMonthlyDay.Enabled;
  liMonthlyTheDayOfEvery.Enabled := not liMonthlyDay.Enabled;
  lbMonthlyTheDayOfEveryMonths.Enabled := not liMonthlyDay.Enabled;

  liYearlyOnDay.Enabled := lrbYearlyOn.Checked;
  liYearlyOnMonth.Enabled := liYearlyOnDay.Enabled;
  liYearlyTheRegularDay.Enabled := not liYearlyOnDay.Enabled;
  liYearlyTheRegularWeekDay.Enabled := not liYearlyOnDay.Enabled;
  liYearlyTheMonth.Enabled := not liYearlyOnDay.Enabled;

  liRangeEndAfterOccurrences.Enabled := lrbRangeEndAfter.Checked;
  liRangeEndBy.Enabled := not liRangeEndAfterOccurrences.Enabled;
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.cmbYearlyOnMonthPropertiesChange(Sender: TObject);
begin
  case cmbYearlyOnMonth.ItemIndex of
    1:
      ceYearlyOnDay.Properties.MaxValue := 28;
    3, 5, 8, 10:
      ceYearlyOnDay.Properties.MaxValue := 30;
    else
     ceYearlyOnDay.Properties.MaxValue := 31;
  end;
end;

function TdxGanttControlRecurringTaskInformationDialogForm.GetActualCalendarUID: Integer;
begin
  Result := dxGanttCalendarUIDs[cmbCalendar.ItemIndex];
end;

function TdxGanttControlRecurringTaskInformationDialogForm.GetActualDurationFormat(
  var AError: Boolean; var AErrorText: TCaption): TdxDurationFormat;
var
  AActualDescription: string;
begin
  AActualDescription := TdxDurationEditHelper(DurationEditHelper).GetCheckableCandidate(DurationEditHelper.GetDescriptionFromText(meDuration.Text));
  if AActualDescription = '' then
    AActualDescription := DurationEditHelper.DefaultDescription;
  Result := TdxGanttControlDialogUtils.GetDurationFormat(AActualDescription, AError, AErrorText);
end;

function TdxGanttControlRecurringTaskInformationDialogForm.GetActualDurationValue: Variant;
begin
  if Trim(meDuration.Text) = '' then
    Result := 1
  else
    Result := DurationEditHelper.GetValueFromText(Trim(meDuration.Text), False);
end;

function TdxGanttControlRecurringTaskInformationDialogForm.GetInitialDurationDescription(AFormat: TdxDurationFormat): string;
begin
  Result := TdxGanttControlDialogUtils.GetDurationDescription(AFormat);
  if TdxGanttControlDialogUtils.IsDurationEstimated(AFormat) then
    Result := Result + dxduEstimatedTimePostfix;
end;

function TdxGanttControlRecurringTaskInformationDialogForm.GetWeekDayRegularNumber(ADate: TDateTime): Word;
var
  ACurrentMonth: Word;
begin
  Result := 1;
  ACurrentMonth := MonthOf(ADate);
  ADate := ADate - 7;
  while MonthOf(ADate) = ACurrentMonth do
  begin
    Inc(Result);
    ADate := ADate - 7;
  end;
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.Initialize;
const
  ADateOrderMap: array[TcxDateOrder] of Integer = (2, 1, 1);
var
  AConstraint: TdxLayoutAlignmentConstraint;
begin
  FInitializing := True;

  TdxGanttControlDialogUtils.SetControlsReadOnly(lcMain, not GanttControl.IsEditable);

  FActualTask.Recurring := True;
  FActualTask.Summary := True;
  FActualTask.Manual := False;

  ApplyLocalization;
  BiDiMode := GanttControl.BiDiMode;
  dxLayoutCxLookAndFeel1.LookAndFeel := TdxCustomGanttControlAccess(GanttControl).LookAndFeel;
  edName.Text := ActualTask.Name;

  InitializeDurationEditor;
  InitializeDaily;
  InitializeWeekly;
  InitializeMonthly;
  InitializeYearly;
  InitializeRange;
  InitializeCalendar;

  if (Task = nil) or (FActualTask.RecurrencePattern.&Type = TdxGanttControlRecurrenceType.Weekly) then
    lrbWeekly.Checked := True
  else
  case FActualTask.RecurrencePattern.&Type of
    TdxGanttControlRecurrenceType.Daily: lrbDaily.Checked := True;
    TdxGanttControlRecurrenceType.AbsoluteMonthly,
    TdxGanttControlRecurrenceType.RelativeMonthly: lrbMonthly.Checked := True;
    TdxGanttControlRecurrenceType.AbsoluteYearly,
    TdxGanttControlRecurrenceType.RelativeYearly: lrbYearly.Checked := True;
  end;
  liYearlyOnDay.Index := ADateOrderMap[cxGetDateOrder(TdxGanttControlUtils.GetShortDateTimeFormat)];
  AConstraint := lcMain.CreateAlignmentConstraint;
  AConstraint.Kind := ackLeft;
  liYearlyOnDay.Parent.Items[1].AlignmentConstraint := AConstraint;
  liYearlyTheRegularDay.AlignmentConstraint := AConstraint;
  FInitializing := False;
  CheckDialogItemsEnabling;
  CalculateRangeInfo;
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.InitializeCalendar;
var
  I: Integer;
  AList: TList<Integer>;
begin
  AList := TList<Integer>.Create;
  try
    cmbCalendar.Properties.Items.Clear;
    cmbCalendar.Properties.Items.Add(cxGetResourceString(@sdxGanttControlCaptionNone));
    cmbCalendar.ItemIndex := 0;
    AList.Add(-1);
    for I := 0 to GanttControl.DataModel.Calendars.Count - 1 do
      if GanttControl.DataModel.Calendars[I].IsBaseCalendar then
      begin
        cmbCalendar.Properties.Items.Add(GanttControl.DataModel.Calendars[I].Name);
        AList.Add(GanttControl.DataModel.Calendars[I].UID);
        if Task = nil then
          cmbCalendar.ItemIndex := 0
        else
          if Task.CalendarUID = GanttControl.DataModel.Calendars[I].UID then
            cmbCalendar.ItemIndex := cmbCalendar.Properties.Items.Count - 1;
      end;
    dxGanttCalendarUIDs := AList.ToArray;
  finally
    AList.Free;
  end;
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.InitializeDurationEditor;
var
  AFormat: TdxDurationFormat;
  ADuration: TdxGanttControlDuration;
begin
  if (Task = nil) or Task.Blank then
  begin
    ADuration := TdxGanttControlDuration.Create(GanttControl.DataModel.DefaultTaskDuration);
    AFormat := TdxDurationFormat.Days;
  end
  else
  begin
    ADuration := TdxGanttControlDuration.Create(Task.RecurrencePattern.Duration);
    AFormat := Task.RecurrencePattern.DurationFormat;
  end;
  FActualTask.RecurrencePattern.Duration := ADuration.ToString;
  FActualTask.RecurrencePattern.DurationFormat := AFormat;
  FDurationEditHelper := TdxDurationEditHelper.Create(GetInitialDurationDescription(AFormat), 1, 2,
    0, MaxCurrency, cxGetResourceString(@sdxGanttControlDurationFormatDayExtraShort));
  AddPossibleDurationDescriptions;
  meDuration.Text := TdxGanttControlDialogUtils.GetDurationText(FDurationEditHelper, ADuration, AFormat);
  meDuration.ActiveProperties.OnIncrementValue := DurationEditIncrementValueHandler;
  meDuration.ActiveProperties.OnValidate := DurationEditValidateHandler;
  meDuration.ActiveProperties.MinValue := DurationEditHelper.MinValue;
  meDuration.ActiveProperties.MaxValue := DurationEditHelper.MaxValue;
  meDuration.ActiveProperties.ExceptionOnInvalidInput := True;
  meDuration.Properties.ImmediatePost := True;
  FInitialDurationHasEstimatedFormat := TdxGanttControlDialogUtils.IsDurationEstimated(AFormat);
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.InitializeDaily;
begin
  if Task = nil then
  begin
    seDailyEvery.Value := 1;
    lrbDailyEveryDays.Checked := True;
  end
  else
  begin
    if FActualTask.RecurrencePattern.&Type = TdxGanttControlRecurrenceType.Daily then
      seDailyEvery.Value := FActualTask.RecurrencePattern.Interval;
    lrbDailyEveryWorkdays.Checked := FActualTask.RecurrencePattern.DayType = TdxGanttControlRecurrenceDayType.Workday;
    lrbDailyEveryDays.Checked := not lrbDailyEveryWorkdays.Checked;
  end;
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.InitializeWeekly;
begin
  if Task <> nil then
  begin
    if FActualTask.RecurrencePattern.&Type = TdxGanttControlRecurrenceType.Weekly then
      seWeeklyEvery.Value := FActualTask.RecurrencePattern.Interval;
    lcbSunday.Checked := dSunday in FActualTask.RecurrencePattern.Days;
    lcbMonday.Checked := dMonday in Task.RecurrencePattern.Days;
    lcbTuesday.Checked := dTuesday in Task.RecurrencePattern.Days;
    lcbWednesday.Checked := dWednesday in Task.RecurrencePattern.Days;
    lcbThursday.Checked := dThursday in Task.RecurrencePattern.Days;
    lcbFriday.Checked := dFriday in Task.RecurrencePattern.Days;
    lcbSaturday.Checked := dSaturday in Task.RecurrencePattern.Days;
  end;
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.InitializeMonthly;
begin
  seMonthlyDay.Value := DayOf(Date);
  cmbMonthlyTheRegularDay.ItemIndex := GetWeekDayRegularNumber(Date) - 1;
  cmbMonthlyTheWeekDay.ItemIndex := DayOfTheWeek(Date) - 1;
  if (Task = nil) or not (Task.RecurrencePattern.&Type in [TdxGanttControlRecurrenceType.AbsoluteMonthly, TdxGanttControlRecurrenceType.RelativeMonthly]) then
    lrbMonthlyDay.Checked := True
  else
    if (Task <> nil) and (Task.RecurrencePattern.&Type in [TdxGanttControlRecurrenceType.AbsoluteMonthly, TdxGanttControlRecurrenceType.RelativeMonthly]) then
    begin
      lrbMonthlyDay.Checked := Task.RecurrencePattern.&Type = TdxGanttControlRecurrenceType.AbsoluteMonthly;
      if lrbMonthlyDay.Checked then
      begin
        seMonthlyDay.Value := Task.RecurrencePattern.DayOfMonth;
        seMonthlyDayOfEvery.Value := Task.RecurrencePattern.Interval;
      end
      else
      begin
        lrbMonthlyThe.Checked := True;
        cmbMonthlyTheRegularDay.ItemIndex := Ord(Task.RecurrencePattern.Index);
        cmbMonthlyTheWeekDay.ItemIndex := DayTypeToWeekDayAsIndex(Task.RecurrencePattern.DayType);
        seMonthlyTheDayOfEvery.Value := Task.RecurrencePattern.Interval;
      end;
    end;
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.InitializeYearly;
begin
  ceYearlyOnDay.Value := DayOf(Date);
  cmbYearlyOnMonth.ItemIndex := MonthOf(Date) - 1;
  cmbYearlyTheRegularDay.ItemIndex := GetWeekDayRegularNumber(Date) - 1;
  cmbYearlyTheRegularWeekDay.ItemIndex := DayOfTheWeek(Date) - 1;
  cmbYearlyTheMonth.ItemIndex := cmbYearlyOnMonth.ItemIndex;
  if (Task = nil) or not (Task.RecurrencePattern.&Type in [TdxGanttControlRecurrenceType.AbsoluteYearly, TdxGanttControlRecurrenceType.RelativeYearly]) then
    lrbYearlyOn.Checked := True
  else
    if (Task <> nil) and (Task.RecurrencePattern.&Type in [TdxGanttControlRecurrenceType.AbsoluteYearly, TdxGanttControlRecurrenceType.RelativeYearly]) then
    begin
      lrbYearlyOn.Checked := Task.RecurrencePattern.&Type = TdxGanttControlRecurrenceType.AbsoluteYearly;
      if lrbYearlyOn.Checked then
      begin
        ceYearlyOnDay.Value := Task.RecurrencePattern.DayOfMonth;
        cmbYearlyOnMonth.ItemIndex := Task.RecurrencePattern.Month - 1;
      end
      else
      begin
        lrbYearlyThe.Checked := True;
        cmbYearlyTheRegularDay.ItemIndex := Ord(Task.RecurrencePattern.Index);
        cmbYearlyTheRegularWeekDay.ItemIndex := DayTypeToWeekDayAsIndex(Task.RecurrencePattern.DayType);
        cmbYearlyTheMonth.ItemIndex := Task.RecurrencePattern.Month - 1;
      end;
    end;
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.InitializeRange;
begin
  deRangeStart.Properties.DisplayFormat := TdxGanttControlUtils.GetShortDateTimeFormat;
  deRangeStart.Properties.EditFormat := deRangeStart.Properties.DisplayFormat;
  deRangeStart.Properties.MinDate := TdxGanttControlDataModel.MinDate;
  deRangeEndBy.Properties.DisplayFormat := deRangeStart.Properties.DisplayFormat;
  deRangeEndBy.Properties.EditFormat := deRangeStart.Properties.EditFormat;
  deRangeEndBy.Properties.MinDate := TdxGanttControlDataModel.MinDate;
  if Task = nil then
  begin
    deRangeStart.Date := Date + 8/24;
    deRangeEndBy.Date := Date + 17/24;
    seRangeEndAfter.Value := 1;
    lrbRangeEndBy.Checked := True;
  end
  else
  begin
    deRangeStart.Date := Task.RecurrencePattern.Start;
    lrbRangeEndAfter.Checked := Task.RecurrencePattern.FinishType = TdxGanttControlRecurrenceFinishType.Count;
    seRangeEndAfter.Value := Task.RecurrencePattern.Count;
    lrbRangeEndBy.Checked := not lrbRangeEndAfter.Checked;
    deRangeEndBy.Date := Task.RecurrencePattern.Finish;
  end;
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.PopulateRecurrenceInfo(var ATask: TdxGanttControlTask);

  procedure PopulateAsDaily;
  begin
    ATask.RecurrencePattern.&Type := TdxGanttControlRecurrenceType.Daily;
    ATask.RecurrencePattern.Interval := seDailyEvery.Value;
    if lrbDailyEveryDays.Checked then
      ATask.RecurrencePattern.DayType := TdxGanttControlRecurrenceDayType.Day
    else
      ATask.RecurrencePattern.DayType := TdxGanttControlRecurrenceDayType.Workday;
  end;

  procedure PopulateAsWeekly;
  begin
    ATask.RecurrencePattern.&Type := TdxGanttControlRecurrenceType.Weekly;
    ATask.RecurrencePattern.Interval := seWeeklyEvery.Value;
    ATask.RecurrencePattern.Days := [];
    if lcbSunday.Checked then
      ATask.RecurrencePattern.Days := ATask.RecurrencePattern.Days + [dSunday];
    if lcbMonday.Checked then
      ATask.RecurrencePattern.Days := ATask.RecurrencePattern.Days + [dMonday];
    if lcbTuesday.Checked then
      ATask.RecurrencePattern.Days := ATask.RecurrencePattern.Days + [dTuesday];
    if lcbWednesday.Checked then
      ATask.RecurrencePattern.Days := ATask.RecurrencePattern.Days + [dWednesday];
    if lcbThursday.Checked then
      ATask.RecurrencePattern.Days := ATask.RecurrencePattern.Days + [dThursday];
    if lcbFriday.Checked then
      ATask.RecurrencePattern.Days := ATask.RecurrencePattern.Days + [dFriday];
    if lcbSaturday.Checked then
      ATask.RecurrencePattern.Days := ATask.RecurrencePattern.Days + [dSaturday];
  end;

  procedure PopulateAsMonthly;
  begin
    if lrbMonthlyDay.Checked then
    begin
      ATask.RecurrencePattern.&Type := TdxGanttControlRecurrenceType.AbsoluteMonthly;
      ATask.RecurrencePattern.DayOfMonth := seMonthlyDay.Value;
      ATask.RecurrencePattern.Interval := seMonthlyDayOfEvery.Value;
    end
    else
    begin
      ATask.RecurrencePattern.&Type := TdxGanttControlRecurrenceType.RelativeMonthly;
      ATask.RecurrencePattern.Index := TdxGanttControlRecurrenceIndex(cmbMonthlyTheRegularDay.ItemIndex);
      ATask.RecurrencePattern.DayType := IndexWeekDayToDayType(cmbMonthlyTheWeekDay.ItemIndex);
      ATask.RecurrencePattern.Interval := seMonthlyTheDayOfEvery.Value;
    end;
  end;

  procedure PopulateAsYearly;
  begin
    if lrbYearlyOn.Checked then
    begin
      ATask.RecurrencePattern.&Type := TdxGanttControlRecurrenceType.AbsoluteYearly;
      ATask.RecurrencePattern.DayOfMonth := ceYearlyOnDay.Value;
      ATask.RecurrencePattern.Month := cmbYearlyOnMonth.ItemIndex + 1;
    end
    else
    begin
      ATask.RecurrencePattern.&Type := TdxGanttControlRecurrenceType.RelativeYearly;
      ATask.RecurrencePattern.Index := TdxGanttControlRecurrenceIndex(cmbYearlyTheRegularDay.ItemIndex);
      ATask.RecurrencePattern.DayType := IndexWeekDayToDayType(cmbYearlyTheRegularWeekDay.ItemIndex);
      ATask.RecurrencePattern.Month := cmbYearlyTheMonth.ItemIndex + 1;
    end;
  end;

  procedure PopulateRangeInfo;
  begin
    ATask.RecurrencePattern.Start := deRangeStart.Date;
    if lrbRangeEndAfter.Checked then
      ATask.RecurrencePattern.FinishType := TdxGanttControlRecurrenceFinishType.Count
    else
      ATask.RecurrencePattern.FinishType := TdxGanttControlRecurrenceFinishType.Date;
    ATask.RecurrencePattern.Count := seRangeEndAfter.Value;
    ATask.RecurrencePattern.Finish := deRangeEndBy.Date;
  end;

begin
  if lrbDaily.Checked then
    PopulateAsDaily
  else if lrbWeekly.Checked then
    PopulateAsWeekly
  else if lrbMonthly.Checked then
    PopulateAsMonthly
  else
    PopulateAsYearly;
  PopulateRangeInfo;
  ATask.RecurrencePattern.CalendarUID := GetActualCalendarUID;
end;

function TdxGanttControlRecurringTaskInformationDialogForm.ValidateRecurrenceInfo(var AErrorText: TCaption): Boolean;
begin
  Result := (FActualTask.RecurrencePattern.&Type <> TdxGanttControlRecurrenceType.Weekly) or (FActualTask.RecurrencePattern.Days <> []);
  if not Result then
    AErrorText := cxGetResourceString(@sdxGanttControlMessageInvalidWeekSchedule);
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.meDurationPropertiesEditValueChanged(Sender: TObject);
var
  AValue: Variant;
  AError: Boolean;
  AErrorText: TCaption;
  AActualDuration: TdxGanttControlDuration;
begin
  DurationEditValidateHandler(nil, AValue, AErrorText, AError);
  if not AError then
  begin
    AActualDuration := TdxGanttControlDuration.Create(GetActualDurationValue, GetActualDurationFormat(AError, AErrorText));
    FActualTask.RecurrencePattern.Duration := AActualDuration.ToString;
    CalculateRangeInfo;
  end;
end;

class procedure TdxGanttControlRecurringTaskInformationDialogForm.InitializeMeasurementUnits;
begin
  TdxGanttControlDialogUtils.InitializeDurationUnits;
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.lrbDailyClick(Sender: TObject);
begin
  CheckDialogItemsEnabling;
  CalculateRangeInfo;
end;

function TdxGanttControlRecurringTaskInformationDialogForm.GetGanttControl: TdxCustomGanttControl;
begin
  Result := Owner as TdxCustomGanttControl;
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.deRangeStartPropertiesCloseUp(Sender: TObject);
begin
  TdxGanttControlDialogUtils.DateValidateHandler(deRangeStart, True);
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.deRangeStartPropertiesEditValueChanged(Sender: TObject);
begin
  CalculateRangeInfo;
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.seRangeEndAfterPropertiesEditValueChanged(Sender: TObject);
begin
  if seRangeEndAfter.Enabled then
    CalculateRangeInfo;
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.deRangeEndByPropertiesEditValueChanged(Sender: TObject);
begin
  if deRangeEndBy.Enabled then
    CalculateRangeInfo;
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.deRangeEndByPropertiesCloseUp(Sender: TObject);
begin
  TdxGanttControlDialogUtils.DateValidateHandler(deRangeEndBy, False);
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.DurationEditIncrementValueHandler(Sender: TObject;
  AButton: TcxSpinEditButton; var AValue: Variant; var AHandled: Boolean);
begin
  AHandled := DurationEditHelper.IncrementValue(AButton, AValue);
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.DurationEditValidateHandler(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  AValue: Variant;
  AFloatValue: Double;
begin
  AValue := GetActualDurationValue;
  if VarIsNull(AValue) then
    Error := True
  else
  begin
    AFloatValue := AValue;
    Error := (CompareValue(AFloatValue, DurationEditHelper.MinValue) < 0) or
             (CompareValue(AFloatValue, DurationEditHelper.MaxValue) > 0);
  end;
  if Error then
    ErrorText := cxGetResourceString(@sdxGanttControlMessageInvalidDurationFormat);
end;

procedure TdxGanttControlRecurringTaskInformationDialogForm.btnOkClick(Sender: TObject);
begin
  ModalResult := (Sender as TcxButton).ModalResult;
end;

procedure ShowRecurringTaskInformationDialog(AController: TdxGanttControlChartViewController; ATask: TdxGanttControlTask);
begin
  ShowRecurringTaskInformationDialog(AController.Control, ATask);
end;

procedure ShowRecurringTaskInformationDialog(AGanttControl: TdxGanttControlBase; ATask: TdxGanttControlTask);
var
  FRecurringTaskInformationForm: TdxGanttControlRecurringTaskInformationDialogForm;
  AControl: TdxCustomGanttControlAccess;
  ACommand: TdxGanttControlCommand;
begin
  AControl := TdxCustomGanttControlAccess(AGanttControl);
  if not AControl.DoShowRecurringTaskInformationDialog(ATask) then
  begin
    if ATask <> nil then
      FRecurringTaskInformationForm := dxGanttControlRecurringTaskInformationDialogFormClass.Create(AControl, ATask)
    else
      FRecurringTaskInformationForm := dxGanttControlRecurringTaskInformationDialogFormClass.Create(AControl, TdxCustomGanttControl(AGanttControl).ViewChart.Controller.FocusedRowIndex);
    try
      cxDialogsMetricsStore.InitDialog(FRecurringTaskInformationForm);
      if FRecurringTaskInformationForm.ShowModal = mrOk then
      begin
        if ATask <> nil then
          ACommand := TdxGanttControlChangeTaskCommand.Create(AGanttControl, ATask, FRecurringTaskInformationForm.ActualTask)
        else
          ACommand := TdxViewChartInsertRecurringTaskCommand.Create(TdxCustomGanttControl(AGanttControl).ViewChart.Controller,
            TdxCustomGanttControl(AGanttControl).ViewChart.Controller.FocusedRowIndex, FRecurringTaskInformationForm.ActualTask);
        try
          ACommand.Execute;
        finally
          ACommand.Free;
        end;
      end;
      cxDialogsMetricsStore.StoreMetrics(FRecurringTaskInformationForm);
    finally
      FRecurringTaskInformationForm.Free;
    end;
  end;
end;

end.
