unit FileAttachmentMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, BaseForm, dxCore, dxCoreClasses, dxHashUtils, dxPDFCore,
  dxPDFBase, dxPDFText, dxPDFRecognizedObject, dxPDFDocument, dxCustomPreview, dxPDFDocumentViewer,
  dxPDFViewer, dxLayoutContainer, cxClasses, dxLayoutControl, dxLayoutControlAdapters, Menus, StdCtrls,
  cxButtons, dxLayoutLookAndFeels, dxLayoutcxEditAdapters, cxContainer, cxEdit, cxTextEdit, dxGDIPlusClasses,
  cxLabel, cxMaskEdit, cxDropDownEdit, dxShellDialogs, cxCustomListBox, cxListBox;

type
  TfrmPDFFileAttachment = class(TfmBaseForm)
    dxPDFViewer1: TdxPDFViewer;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutGroup1: TdxLayoutGroup;
    btnAttachFile: TcxButton;
    liLoadCertificate: TdxLayoutItem;
    btnDetachSeleted: TcxButton;
    dxLayoutItem2: TdxLayoutItem;
    lbAttachments: TcxListBox;
    dxLayoutItem3: TdxLayoutItem;
    procedure lbAttachmentsClick(Sender: TObject);
    procedure btnDetachSeletedClick(Sender: TObject);
    procedure btnAttachFileClick(Sender: TObject);
  protected
    procedure Attach(const AFileName: string);
    procedure Detach(const AFileName: string);
    procedure LoadDocument(const AFileName: string);
    procedure UpdateControls;
  public
    procedure AfterConstruction; override;
  end;

var
  frmPDFFileAttachment: TfrmPDFFileAttachment;

implementation

{$R *.dfm}

uses
  IOUtils, Types;

procedure TfrmPDFFileAttachment.lbAttachmentsClick(Sender: TObject);
begin
  UpdateControls;
end;

procedure TfrmPDFFileAttachment.AfterConstruction;
begin
  inherited AfterConstruction;;
  LoadDocument('..\..\Data\FileAttachment.pdf');
  Attach('..\..\Data\DevExpress.png');
  OpenDialog.Filter := '';
  UpdateControls;
end;

procedure TfrmPDFFileAttachment.Attach(const AFileName: string);
var
  AAttachment: TdxPDFFileAttachment;
begin
  dxPDFViewer1.Document.BeginUpdate;
  AAttachment := dxPDFViewer1.Document.FileAttachments.Add;
  AAttachment.LoadFromFile(AFileName);
  AAttachment.Description := 'To open the attachment in the Attachments tab, you can either click the ' +
    QuotedStr('Open file in its native application') + ' icon or double - click the attachment.';
  dxPDFViewer1.Document.EndUpdate;
  lbAttachments.Items.Add(TPath.GetFileName(AFileName));
end;

procedure TfrmPDFFileAttachment.btnAttachFileClick(Sender: TObject);
var
  I: Integer;
begin
  if OpenDialog.Execute(Handle) then
  begin
    dxPDFViewer1.BeginUpdate;
    for I := 0 to OpenDialog.Files.Count - 1 do
      Attach(OpenDialog.Files[I]);
    dxPDFViewer1.EndUpdate;
  end;
end;

procedure TfrmPDFFileAttachment.btnDetachSeletedClick(Sender: TObject);
var
  I: Integer;
begin
  dxPDFViewer1.Document.BeginUpdate;
  try
    for I := 0 to lbAttachments.Items.Count - 1 do
      if lbAttachments.Selected[I] then
        Detach(lbAttachments.Items[I]);
    lbAttachments.DeleteSelected;
  finally
    dxPDFViewer1.Document.EndUpdate;
  end;
end;

procedure TfrmPDFFileAttachment.Detach(const AFileName: string);
var
  AAttachment: TdxPDFFileAttachment;
begin
  for AAttachment in dxPDFViewer1.Document.FileAttachments do
    if SameText(AAttachment.FileName, AFileName) then
      dxPDFViewer1.Document.FileAttachments.Remove(AAttachment);
end;

procedure TfrmPDFFileAttachment.LoadDocument(const AFileName: string);
begin
  dxPDFViewer1.BeginUpdate;
  dxPDFViewer1.LoadFromFile(AFileName);
  dxPDFViewer1.OptionsNavigationPane.Attachments.Visible := bTrue;
  dxPDFViewer1.OptionsNavigationPane.Bookmarks.Visible := bFalse;
  dxPDFViewer1.OptionsNavigationPane.Thumbnails.Visible := bFalse;
  dxPDFViewer1.OptionsNavigationPane.Visible := True;
  dxPDFViewer1.OptionsZoom.ZoomFactor := 55;
  dxPDFViewer1.EndUpdate;
  Caption := 'PDF File Attachment - ' + AFileName;
end;

procedure TfrmPDFFileAttachment.UpdateControls;
begin
  btnDetachSeleted.Enabled := lbAttachments.SelCount > 0;
end;

end.

