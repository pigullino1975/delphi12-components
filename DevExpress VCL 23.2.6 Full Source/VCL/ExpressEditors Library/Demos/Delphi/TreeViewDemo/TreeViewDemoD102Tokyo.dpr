program TreeViewDemoD102Tokyo;

uses
  Forms,
  TreeViewDemoMain in 'TreeViewDemoMain.pas' {fmTreeViewDemo},
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  DemoUtils in '..\DemoUtils.pas',
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmTreeViewDemo, fmTreeViewDemo);
  Application.Run;
end.
