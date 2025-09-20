unit uSlideShow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxClasses, dxSkinsForm, dxImageSlider, dxGDIPlusClasses,
  dxLayoutContainer, dxLayoutLookAndFeels, dxLayoutControl, Generics.Defaults,
  Generics.Collections, Vcl.ExtCtrls, dxForms;

type
  TSlideShow = class(TdxForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxImageSlider1: TdxImageSlider;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure dxImageSlider1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    BaseCaption: string;
    procedure UpdateCaption;
  public
    class procedure DoShowEditor(AImageCollection: TcxImageCollection);
  end;

implementation

{$R *.dfm}

{ TSlideShow }

class procedure TSlideShow.DoShowEditor(AImageCollection: TcxImageCollection);
var
  AForm: TSlideShow;
begin
  AForm := TSlideShow.Create(Application);
  try
    AForm.dxImageSlider1.Images := AImageCollection;
    AForm.BaseCaption := AForm.Caption;
    AForm.Timer1.Enabled := True;
    AForm.UpdateCaption;
    AForm.ShowModal;
  finally
    AForm.Free;
  end;
end;

procedure TSlideShow.UpdateCaption;
begin
  Caption := BaseCaption + ' - ' + IntToStr(dxImageSlider1.ItemIndex + 1) + ' of ' + IntToStr(dxImageSlider1.Images.Count);
end;

procedure TSlideShow.dxImageSlider1Click(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

procedure TSlideShow.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TSlideShow.Timer1Timer(Sender: TObject);
begin
  dxImageSlider1.GoToImage((dxImageSlider1.ItemIndex + 1) mod dxImageSlider1.Images.Count);
  UpdateCaption;
end;

end.
