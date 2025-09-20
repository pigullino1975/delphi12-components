unit BaselinesDemoMain;

interface

{$I cxVer.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, StdCtrls,
  dxCore, cxContainer, cxEdit, cxTextEdit, cxDropDownEdit, cxMaskEdit, cxSpinEdit,
  cxGraphics, cxClasses, cxControls,
{$IFDEF EXPRESSSKINS}
  dxSkinsdxRibbonPainter,
  dxSkinsdxBarPainter,
{$ENDIF}
  cxLookAndFeels, cxLookAndFeelPainters, dxLayoutControl,
  dxLayoutContainer, dxLayoutLookAndFeels, dxLayoutcxEditAdapters, DemoBasicMain,
  dxGanttControlCustomClasses, dxGanttControl, dxGanttControlCustomSheet, dxGanttControlViewChart,
  dxGanttControlViewResourceSheet, dxGanttControlViewTimeline, dxGanttControlTasks, dxGanttControlAssignments,
  dxGanttControlDataModel, dxGanttControlResources, dxLayoutControlAdapters,
  ActnList, ImgList, cxImageList, dxShellDialogs, cxButtons, cxGroupBox;

type
  TBaselinesDemoMainForm = class(TDemoBasicMainForm)
    dxLayoutGroup9: TdxLayoutGroup;
    cbBaseline: TcxComboBox;
    dxLayoutItem8: TdxLayoutItem;
    dxLayoutItem9: TdxLayoutItem;
    cbSetBaseline: TcxComboBox;
    lcbiSelectedTasks: TdxLayoutCheckBoxItem;
    cxButton3: TcxButton;
    dxLayoutItem10: TdxLayoutItem;
    cxButton4: TcxButton;
    dxLayoutItem11: TdxLayoutItem;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    procedure GanttControlDataModelLoaded(Sender: TObject);
    procedure GanttControlViewChartBaselineNumberChanged(Sender: TObject);
    procedure GanttControlBaselineChanged(Sender: TObject; ABaseline: TdxGanttControlDataModelBaseline);
    procedure FormCreate(Sender: TObject);
    procedure cbBaselinePropertiesEditValueChanged(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure cxButton4Click(Sender: TObject);
  private
    FLockCount: Integer;
    function BaselineToText(ABaseline: TdxGanttControlDataModelBaseline): string;
    procedure UpdateBaselineList;
  end;

var
  BaselinesDemoMainForm: TBaselinesDemoMainForm;

implementation

{$R *.dfm}

uses
  Math,
  dxCoreClasses,
  dxGanttControlCustomDataModel;

{ TBaselinesDemoMainForm }

function TBaselinesDemoMainForm.BaselineToText(
  ABaseline: TdxGanttControlDataModelBaseline): string;
begin
  if ABaseline.Description <> '' then
    Result := ABaseline.Description
  else if ABaseline.Number = 0 then
    Result := Format('Baseline (Last saved on %s)', [DateTimeToStr(ABaseline.Created)])
  else
    Result := Format('Baseline %d (Last saved on %s)', [ABaseline.Number, DateTimeToStr(ABaseline.Created)])
end;

procedure TBaselinesDemoMainForm.cbBaselinePropertiesEditValueChanged(
  Sender: TObject);
begin
  if FLockCount > 0 then
    Exit;
  if (cbBaseline.ItemIndex = -1) or (cbBaseline.ActiveProperties.Items.Objects[cbBaseline.ItemIndex] = nil) then
    GanttControl.ViewChart.HideBaselines
  else
    GanttControl.ViewChart.ShowBaselines(TdxGanttControlDataModelBaseline(cbBaseline.ActiveProperties.Items.Objects[cbBaseline.ItemIndex]).Number);
end;

procedure TBaselinesDemoMainForm.cxButton3Click(Sender: TObject);
begin
  GanttControl.ViewChart.SetBaselines(cbSetBaseline.ItemIndex, lcbiSelectedTasks.Checked);
end;

procedure TBaselinesDemoMainForm.cxButton4Click(Sender: TObject);
begin
  GanttControl.ViewChart.ClearBaselines(cbSetBaseline.ItemIndex, lcbiSelectedTasks.Checked);
end;

procedure TBaselinesDemoMainForm.FormCreate(Sender: TObject);
begin
  inherited;
  GanttControl.DataModel.LoadFromFile('..\..\Data\SoftDev-Baselines.xml');
end;

procedure TBaselinesDemoMainForm.GanttControlDataModelLoaded(Sender: TObject);
begin
  inherited;
  UpdateBaselineList;
  cbBaseline.ItemIndex := 0;
  cbSetBaseline.ItemIndex := 0;
end;

procedure TBaselinesDemoMainForm.GanttControlViewChartBaselineNumberChanged(Sender: TObject);
var
  I: Integer;
begin
  if GanttControl.ViewChart.BaselineNumber < 0 then
    cbBaseline.ItemIndex := 0
  else
  begin
    for I := 1 to cbBaseline.ActiveProperties.Items.Count - 1 do
      if TdxGanttControlDataModelBaseline(cbBaseline.ActiveProperties.Items.Objects[I]).Number = GanttControl.ViewChart.BaselineNumber then
      begin
        cbBaseline.ItemIndex := I;
        Break;
      end;
  end;
end;

procedure TBaselinesDemoMainForm.GanttControlBaselineChanged(Sender: TObject; ABaseline: TdxGanttControlDataModelBaseline);
begin
  UpdateBaselineList;
end;

procedure TBaselinesDemoMainForm.UpdateBaselineList;
var
  I: Integer;
  AText: string;
  ABaseline: TdxGanttControlDataModelBaseline;
  ASetBaselineIndex: Integer;
begin
  Inc(FLockCount);
  cbBaseline.ActiveProperties.BeginUpdate;
  cbSetBaseline.ActiveProperties.BeginUpdate;
  try
    if GanttControl.ViewChart.BaselineNumber < 0 then
      ABaseline := nil
    else
      ABaseline := GanttControl.DataModel.Baselines.Find(GanttControl.ViewChart.BaselineNumber);
    ASetBaselineIndex := cbSetBaseline.ItemIndex;
    cbBaseline.ActiveProperties.Items.Clear;
    cbSetBaseline.ActiveProperties.Items.Clear;
    cbSetBaseline.ActiveProperties.Items.Add('Baseline');
    for I := 1 to 10 do
      cbSetBaseline.ActiveProperties.Items.Add(Format('Baseline %d', [I]));
    cbBaseline.ActiveProperties.Items.Add('None');
    for I := 0 to GanttControl.DataModel.Baselines.Count - 1 do
    begin
      AText := BaselineToText(GanttControl.DataModel.Baselines[I]);
      cbBaseline.ActiveProperties.Items.AddObject(AText, GanttControl.DataModel.Baselines[I]);
      if GanttControl.DataModel.Baselines[I].Number <= 10 then
      begin
        cbSetBaseline.ActiveProperties.Items[GanttControl.DataModel.Baselines[I].Number] := AText;
        cbSetBaseline.ActiveProperties.Items.Objects[GanttControl.DataModel.Baselines[I].Number] := GanttControl.DataModel.Baselines[I];
      end;
    end;
    I := cbBaseline.ActiveProperties.Items.IndexOfObject(ABaseline);
    cbBaseline.ItemIndex := Max(0, I);
    cbSetBaseline.ItemIndex := ASetBaselineIndex;
  finally
    cbSetBaseline.ActiveProperties.EndUpdate;
    cbBaseline.ActiveProperties.EndUpdate;
    Dec(FLockCount);
  end;
end;

end.
