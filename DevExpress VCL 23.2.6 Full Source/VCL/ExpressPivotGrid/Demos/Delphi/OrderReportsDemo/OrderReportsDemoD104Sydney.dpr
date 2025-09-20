program OrderReportsDemoD104Sydney;

uses
  Forms,
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {frmDemoBasicMain},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  DemoBasicDM in '..\Common\DemoBasicDM.pas' {dmOrders: TDataModule},
  OrderReportsMain in 'OrderReportsMain.pas' {frmOrderReport},
  DemoUtils in '..\Common\DemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmOrders, dmOrders);
  Application.CreateForm(TfrmOrderReport, frmOrderReport);
  Application.Run;
end.
