unit PageMergingMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, BaseForm, dxCore, dxCoreClasses, dxHashUtils, dxPDFCore,
  dxPDFBase, dxPDFText, dxPDFRecognizedObject, dxPDFDocument, dxCustomPreview, dxPDFDocumentViewer,
  dxPDFViewer, dxLayoutContainer, cxClasses, dxLayoutControl, dxLayoutControlAdapters, Menus, StdCtrls,
  cxButtons, dxLayoutLookAndFeels, dxLayoutcxEditAdapters, dxShellDialogs;

type
  TfrmPDFPageMerging = class(TfmBaseForm)
    dxPDFViewer1: TdxPDFViewer;
    dxLayoutItem1: TdxLayoutItem;
    btnOpen: TcxButton;
    btnAppend: TcxButton;
    dxLayoutItem3: TdxLayoutItem;
    dxLayoutItem4: TdxLayoutItem;
    btnSave: TcxButton;
    dxLayoutItem5: TdxLayoutItem;
    dxLayoutGroup1: TdxLayoutGroup;
    btnNew: TcxButton;
    dxLayoutItem2: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnAppendClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  protected
    procedure UpdateControls;
    procedure LoadDocument(const AFileName: string);
  end;

var
  frmPDFPageMerging: TfrmPDFPageMerging;

implementation

{$R *.dfm}

procedure TfrmPDFPageMerging.btnAppendClick(Sender: TObject);
var
  ADocument: TdxPDFDocument;
begin
  if OpenDialog.Execute then
  begin
    Screen.Cursor := crHourGlass;
    ADocument := TdxPDFDocument.Create;
    try
      ADocument.LoadFromFile(OpenDialog.FileName);
      dxPDFViewer1.Document.Append(ADocument);
    finally
      ADocument.Free;
      Screen.Cursor := crDefault;
    end;
  end;
  UpdateControls;
end;

procedure TfrmPDFPageMerging.btnNewClick(Sender: TObject);
begin
  dxPDFViewer1.Document.Clear;
  UpdateControls;
end;

procedure TfrmPDFPageMerging.btnOpenClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    LoadDocument(OpenDialog.FileName);
  UpdateControls;
end;

procedure TfrmPDFPageMerging.btnSaveClick(Sender: TObject);
begin
  SaveDialog.DefaultExt := 'pdf';
  if SaveDialog.Execute then
    dxPDFViewer1.Document.SaveToFile(SaveDialog.FileName, True);
  UpdateControls;
end;

procedure TfrmPDFPageMerging.FormCreate(Sender: TObject);
begin
  LoadDocument('..\..\Data\PageMerging.pdf');
end;

procedure TfrmPDFPageMerging.UpdateControls;
begin
  btnSave.Enabled := dxPDFViewer1.IsDocumentLoaded;
end;

procedure TfrmPDFPageMerging.LoadDocument(const AFileName: string);
begin
  dxPDFViewer1.BeginUpdate;
  dxPDFViewer1.LoadFromFile(AFileName);
  dxPDFViewer1.OptionsZoom.ZoomFactor := 70;
  dxPDFViewer1.EndUpdate;
end;

end.
