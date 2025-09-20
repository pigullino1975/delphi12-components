program ExtendedAttributesDemoD102Tokyo;

uses
  Forms,
  ExtendedAttributesDemoMain in 'ExtendedAttributesDemoMain.pas' {ExtendedAttributesDemoMainForm},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressGanttControl Extended Attributes Demo';
  Application.CreateForm(TExtendedAttributesDemoMainForm, ExtendedAttributesDemoMainForm);
  Application.Run;
end.
