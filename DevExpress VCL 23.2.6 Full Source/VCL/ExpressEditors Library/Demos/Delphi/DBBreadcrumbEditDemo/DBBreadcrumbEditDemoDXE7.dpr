program DBBreadcrumbEditDemoDXE7;

uses
  Forms,
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  DemoUtils in '..\DemoUtils.pas',
  AboutDemoForm in '..\AboutDemoForm.pas',
  DBBreadcrumbEditDemoMain in 'DBBreadcrumbEditDemoMain.pas' {dxDBBreadcrumbEditDemoForm};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdxDBBreadcrumbEditDemoForm, dxDBBreadcrumbEditDemoForm);
  Application.Run;
end.
