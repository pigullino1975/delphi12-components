program HamburgerMenuDemoD102Tokyo;

uses
  Forms,
  HamburgerMenuDemoMain in 'HamburgerMenuDemoMain.pas' {dxBreadcrumbEditDemoForm},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  dxDemoUtils in '..\Common\dxDemoUtils.pas',
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmHamburgerMenuDemo, frmHamburgerMenuDemo);
  Application.Run;
end.
