unit RenameSheetFormUnit;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, dxLayoutcxEditAdapters, dxLayoutControlAdapters, Menus,
  dxLayoutContainer, StdCtrls, cxButtons, cxTextEdit, dxLayoutControl, dxForms, cxClasses;

type
  TfrmRenameSheet = class(TdxForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    teSheetName: TcxTextEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    btnOk: TcxButton;
    dxLayoutControl1Item2: TdxLayoutItem;
    btnCancel: TcxButton;
    dxLayoutControl1Item3: TdxLayoutItem;
    dxLayoutControl1Group1: TdxLayoutAutoCreatedGroup;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
