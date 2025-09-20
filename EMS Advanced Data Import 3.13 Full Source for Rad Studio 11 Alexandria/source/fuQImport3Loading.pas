unit fuQImport3Loading;

{$I QImport3VerCtrl.Inc}

{$IFDEF VCL6} {$WARN UNIT_PLATFORM OFF} {$ENDIF}

interface

uses
  {$IFDEF VCL16}
    System.Classes,
    Vcl.ComCtrls,
    Vcl.Controls,
    Vcl.ExtCtrls,
    Vcl.FileCtrl,
    Vcl.Forms,
    Vcl.Graphics,
    Vcl.StdCtrls,
  {$ELSE}
    Classes,
    ComCtrls,
    Controls,
    ExtCtrls,
    FileCtrl,
    Forms,
    Graphics,
    StdCtrls,
  {$ENDIF}
  QImport3StrIDs,
  QImport3Common;

type
  TfmQImport3Loading = class(TForm)
    Animate1: TAnimate;
    Bevel1: TBevel;
    laLoading_01: TLabel;
    pbLoadingInfo: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure pbLoadingInfoPaint(Sender: TObject);
  private
    FLoadingInfo: string;
  public
  end;

function ShowLoading(AForm: TForm; const LoadingInfo: string): TForm;

implementation

{$R *.DFM}

function ShowLoading(AForm: TForm; const LoadingInfo: string): TForm;
begin
  Result := TfmQImport3Loading.Create(AForm);
  (Result as TfmQImport3Loading).Animate1.Active := true;
  (Result as TfmQImport3Loading).FLoadingInfo := LoadingInfo;
  Result.Show;
end;

procedure TfmQImport3Loading.FormCreate(Sender: TObject);
begin
  laLoading_01.Caption := QImportLoadStr(QIL_Loading);
end;

procedure TfmQImport3Loading.pbLoadingInfoPaint(Sender: TObject);
var
  s: string;
  Canvas: TCanvas;
  h, w, dh, dw: integer;
begin
  Canvas := pbLoadingInfo.Canvas;
  s := MinimizeName(FLoadingInfo, Canvas, pbLoadingInfo.Width - 8);
  h := Canvas.TextHeight(s);
  w := Canvas.TextWidth(s);
  dh := (pbLoadingInfo.Height - h) div 2;
  dw := (pbLoadingInfo.Width - w) div 2;
  Canvas.TextOut(dw, dh, s);
end;

end.
