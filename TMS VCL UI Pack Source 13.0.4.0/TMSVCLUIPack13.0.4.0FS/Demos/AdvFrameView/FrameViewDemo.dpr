program FrameViewDemo;

uses
  Vcl.Forms,
  Udemo in 'Udemo.pas' {Form1},
  Uframedemo in 'Uframedemo.pas' {Frame2: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
