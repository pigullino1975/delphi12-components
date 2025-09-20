unit SelectStorageUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, dxSkinsCore, Menus,
  cxLookAndFeelPainters, cxButtons, cxRadioGroup, cxControls, cxContainer,
  cxEdit, cxGroupBox, cxGraphics, cxLookAndFeels, dxForms;

type
  TSelectStorage = class(TdxForm)
    cxGroupBox1: TcxGroupBox;
    rbDBStorage: TcxRadioButton;
    rbUnboundStorage: TcxRadioButton;
    btnOK: TcxButton;
    cxGroupBox2: TcxGroupBox;
  end;

implementation

{$R *.dfm}

end.
