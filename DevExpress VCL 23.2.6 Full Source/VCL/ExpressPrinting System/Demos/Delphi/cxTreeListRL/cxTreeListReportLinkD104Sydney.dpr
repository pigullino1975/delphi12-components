program cxTreeListReportLinkD104Sydney;

uses
  Forms,
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  cxTreeListRLMain in 'cxTreeListRLMain.pas' {cxTreeListRLMainForm};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Report Link Demo - ExpressQuantumTreeList';
  Application.CreateForm(TcxTreeListRLMainForm, cxTreeListRLMainForm);
  Application.Run;
end.
