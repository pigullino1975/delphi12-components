program ShellBreadcrumbEditDemoD104Sydney;

uses
  Forms,
  AboutDemoForm in '..\AboutDemoForm.pas',
  ShellBreadcrumbEditDemoMain in 'ShellBreadcrumbEditDemoMain.pas' {dxBreadcrumbEditDemoForm};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdxBreadcrumbEditDemoForm, dxBreadcrumbEditDemoForm);
  Application.Run;
end.
