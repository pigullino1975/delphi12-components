program DragDropDemoD102Tokyo;

uses
  Forms,
  DragDropMain in 'DragDropMain.pas' {fmDragDropMain},
  NavBarUtils in '..\Common\NavBarUtils.pas' {dmCommonData: TDataModule};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmCommonData, dmCommonData);
  Application.CreateForm(TfmDragDropMain, fmDragDropMain);
  Application.Run;
end.
