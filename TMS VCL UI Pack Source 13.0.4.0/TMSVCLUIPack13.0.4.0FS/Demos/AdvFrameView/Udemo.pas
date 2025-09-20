unit Udemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvScrollBox, AdvFrameView, Uframedemo;

type
  TForm1 = class(TForm)
    AdvFrameView1: TAdvFrameView;
    Frame21: TFrame2;
    procedure AdvFrameView1FrameCreate(Sender: TObject; AIndex: Integer;
      AFrame: TFrame);
    procedure FormCreate(Sender: TObject);
    procedure AdvFrameView1FrameSelect(Sender: TObject; AIndex: Integer;
      AFrame: TFrame);
    procedure AdvFrameView1FrameUnSelect(Sender: TObject; AIndex: Integer;
      AFrame: TFrame);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.AdvFrameView1FrameCreate(Sender: TObject; AIndex: Integer;
  AFrame: TFrame);
begin
  (AFrame as TFrame2).Label1.Caption := 'Team '+ AIndex.ToString+#13#10' Ranking';
end;

procedure TForm1.AdvFrameView1FrameSelect(Sender: TObject; AIndex: Integer;
  AFrame: TFrame);
begin
  AFrame.Color := clYellow;
end;

procedure TForm1.AdvFrameView1FrameUnSelect(Sender: TObject; AIndex: Integer;
  AFrame: TFrame);
begin
  AFrame.Color := clBtnface;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  AdvFrameView1.FrameClass := TFrame2;
end;

end.
