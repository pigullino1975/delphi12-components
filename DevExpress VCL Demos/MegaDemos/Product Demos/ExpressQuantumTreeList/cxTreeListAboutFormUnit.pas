unit cxTreeListAboutFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxCustomTreeListBaseFormUnit, dxSkinsCore, 
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMemo, cxRichEdit,
  cxLookAndFeelPainters, StdCtrls, ExtCtrls, cxGroupBox, cxGraphics, cxLookAndFeels, ActnList, cxClasses,
  dxLayoutLookAndFeels, dxLayoutContainer, dxLayoutControl, dxLayoutcxEditAdapters, Actions;

type
  TfrmAbout = class(TcxCustomTreeListDemoUnitForm)
    dxLayoutItem1: TdxLayoutItem;
    reAbout: TcxRichEdit;
  private
    { Private declarations }
  public
    procedure ActivateDataSet; override;
    class function GetID: Integer; override;
  end;

implementation

{$R *.dfm}

{ TTfrmAbout }

procedure TfrmAbout.ActivateDataSet;
var
  AStream: TStream;
begin
  AStream := TResourceStream.Create(hInstance, 'TREELISTFEATURESLIST', 'TREELISTFEATURES');
  try
    reAbout.Lines.LoadFromStream(AStream);
  finally
    AStream.Free;
  end;
end;

class function TfrmAbout.GetID: Integer;
begin
  Result := -1;
end;

initialization
  TfrmAbout.Register;

end.
