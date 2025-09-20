program FlowChartReportLinkD104Sydney;

uses
  Forms,
  FlowChartRLMain in 'FlowChartRLMain.pas' {FlowChartRLMainForm},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Report Link Demo - ExpressFlowChart';
  Application.CreateForm(TFlowChartRLMainForm, FlowChartRLMainForm);
  Application.Run;
end.
