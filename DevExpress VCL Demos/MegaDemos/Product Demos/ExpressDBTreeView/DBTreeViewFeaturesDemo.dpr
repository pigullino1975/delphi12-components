program DBTreeViewFeaturesDemo;

{$SETPEOSVERSION 5.0}
{$SETPESUBSYSVERSION 5.0}

uses
  Forms,
  main in 'main.pas' {MainForm},
  Grid in 'Grid.pas' {GridForm},
  More in 'More.pas' {MoreForm},
  Find in 'Find.pas' {FindForm},
  dxDemoUtils in '..\Common\dxDemoUtils.pas',
  dxAboutDemo in '..\Common\dxAboutDemo.pas' {dxAboutDemoForm};

{$R *.res}
{$R ..\Common\dxDPIAwareManifestPM2.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressDBTree Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TGridForm, GridForm);
  Application.CreateForm(TMoreForm, MoreForm);
  Application.CreateForm(TFindForm, FindForm);
  Application.Run;
end.
