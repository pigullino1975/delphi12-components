unit DesktopDemoData;

interface

uses
  SysUtils, Classes, cxClasses, dxLayoutLookAndFeels, cxLookAndFeels, dxSkinsForm, ImgList, Controls,
  cxImageList, cxGraphics, dxGDIPlusClasses, Graphics;

type
  TdmData = class(TDataModule)
    SkinController: TdxSkinController;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutSkinLookAndFeel1: TdxLayoutSkinLookAndFeel;
    ilSmall: TcxImageList;
    ilMedium: TcxImageList;
    icPeople: TcxImageCollection;
    icPeopleItem1: TcxImageCollectionItem;
    icPeopleItem2: TcxImageCollectionItem;
    icPeopleItem3: TcxImageCollectionItem;
    icPeopleItem4: TcxImageCollectionItem;
    icPeopleItem5: TcxImageCollectionItem;
    icPeopleItem6: TcxImageCollectionItem;
    icPeopleItem7: TcxImageCollectionItem;
    icPeopleItem8: TcxImageCollectionItem;
    icPeopleItem9: TcxImageCollectionItem;
    icPeopleItem10: TcxImageCollectionItem;
    icPeopleItem11: TcxImageCollectionItem;
    icPeopleItem12: TcxImageCollectionItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmData: TdmData;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
