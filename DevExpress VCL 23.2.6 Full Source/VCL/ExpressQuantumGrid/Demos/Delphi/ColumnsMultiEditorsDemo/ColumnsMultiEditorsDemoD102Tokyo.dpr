program ColumnsMultiEditorsDemoD102Tokyo;

uses
  Forms,
  ColumnsMultiEditorsDemoDS in 'ColumnsMultiEditorsDemoDS.pas',
  ColumnsMultiEditorsDemoMain in 'ColumnsMultiEditorsDemoMain.pas' {ColumnsMultiEditorsDemoMainForm},
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo},
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  BaseForm in '..\BaseForm.pas' {fmBaseForm};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid ColumnsMultiEditors Demo';
  Application.CreateForm(TColumnsMultiEditorsDemoMainForm, ColumnsMultiEditorsDemoMainForm);
  Application.Run;
end.
