unit ExtendedAttributesDemoMain;

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
  dxGanttControlResources, cxGroupBox, dxLayoutControlAdapters, cxButtons, dxGanttControlExtendedAttributes,
  ActnList, ImgList, cxImageList;

type
  TExtendedAttributesDemoMainForm = class(TDemoBasicMainForm)
    lcbAlwaysShowEditor: TdxLayoutCheckBoxItem;
    procedure GanttControlDataModelLoaded(Sender: TObject);
    procedure lcbAlwaysShowEditorClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  ExtendedAttributesDemoMainForm: TExtendedAttributesDemoMainForm;

implementation

{$R *.dfm}

uses
  dxGanttControlCustomView;

constructor TExtendedAttributesDemoMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  GanttControl.DataModel.LoadFromFile('..\..\Data\ExtendedAttributesDemo.xml');
end;

procedure TExtendedAttributesDemoMainForm.GanttControlDataModelLoaded(
  Sender: TObject);

  procedure CreateExtendedAttributeColumns(AOptions: TdxGanttControlViewSheetOptions);
  begin
    AOptions.Columns.Reset;
    AOptions.RetrieveMissingExtendedAttributeColumns;
    AOptions.AddExtendedAttributeColumns;
  end;

begin
  inherited;
  CreateExtendedAttributeColumns(GanttControl.ViewChart.OptionsSheet);
  GanttControl.ViewChart.OptionsSheet.Columns[0].Visible := False;
  GanttControl.ViewChart.OptionsSheet.Columns[1].Visible := False;
  GanttControl.ViewChart.OptionsSheet.Columns[3].Visible := False;
  GanttControl.ViewChart.OptionsSheet.Columns[7].Visible := False;
  CreateExtendedAttributeColumns(GanttControl.ViewResourceSheet.OptionsSheet);
end;

procedure TExtendedAttributesDemoMainForm.lcbAlwaysShowEditorClick(
  Sender: TObject);
begin
  inherited;
  GanttControl.OptionsBehavior.AlwaysShowEditor := lcbAlwaysShowEditor.Checked;
end;

end.
