unit UnboundModeDemoAbout;

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, cxButtons, ComCtrls, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  Menus, cxLabel;

type
  TUnboundModeDemoAboutForm = class(TForm)
    imgIcon: TImage;
    btnOK: TcxButton;
    lbDemoName: TcxLabel;
    lbCopyright: TcxLabel;
    bvBottom: TBevel;
    lbCompanyName: TcxLabel;
    reDemoInfo: TRichEdit;
  end;

implementation

{$R *.dfm}

end.
