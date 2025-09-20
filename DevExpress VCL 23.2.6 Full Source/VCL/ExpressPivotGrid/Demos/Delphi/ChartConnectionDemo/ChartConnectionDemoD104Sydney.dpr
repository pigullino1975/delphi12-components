program ChartConnectionDemoD104Sydney;

uses
  Forms,
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {frmDemoBasicMain},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  DemoBasicDM in '..\Common\DemoBasicDM.pas' {dmOrders: TDataModule},
  ChartConnectionDemoMain in 'ChartConnectionDemoMain.pas' {frmChartConnection},
  DemoUtils in '..\Common\DemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmOrders, dmOrders);
  Application.CreateForm(TfrmChartConnection, frmChartConnection);
  Application.Run;
end.
