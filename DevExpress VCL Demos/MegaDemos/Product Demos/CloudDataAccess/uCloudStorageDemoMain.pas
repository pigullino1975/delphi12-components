unit uCloudStorageDemoMain;

interface

uses
  System.UITypes,
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Generics.Collections, dxCore, dxRibbonForm, dxDemoBaseMainForm,
  Controls, Forms, StdCtrls, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, ComCtrls, dxLayoutContainer,
  cxListView, cxContainer, cxEdit, cxTreeView, cxClasses, dxLayoutControl,
  dxCloudStorage, dxAuthorizationAgents, ImgList, cxImageList,
  dxActivityIndicator, dxAlertWindow, dxLayoutControlAdapters, cxButtons,
  ActnList, Dialogs, Vcl.Menus, System.Actions,
  dxRibbonCustomizationForm, dxRibbonSkins, dxLayoutcxEditAdapters, dxPSGlbl,
  dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider,
  dxPSFillPatterns, dxPSEdgePatterns, dxPSPDFExportCore, dxPSPDFExport,
  cxDrawTextUtils, dxPSPrVwStd, dxPSPrVwAdv, dxPSPrVwRibbon,
  dxPScxPageControlProducer, dxPScxEditorProducers, dxPScxExtEditorProducers,
  dxScreenTip, dxCustomHint, cxHint, dxLayoutLookAndFeels, dxBar,
  dxBarApplicationMenu, dxRibbon, dxSkinsForm, dxPgsDlg, dxPSCore,
  dxBarExtItems, cxTextEdit, dxNavBarBase, dxNavBarStyles, dxNavBar,
  dxGalleryControl, dxRibbonBackstageViewGalleryControl, dxBevel, cxLabel,
  cxGroupBox, dxRibbonBackstageView, cxSplitter, Vcl.ExtCtrls,
  uDocumentEditor, dxNavBarCollns, cxGeometry, dxFramedControl, dxShellDialogs, dxPanel;

const
  WM_SHOWSETUP = WM_USER + 1000;

type

  TfmCloudStorageDemoForm = class(TfrmMainBase)
    barNew: TdxBar;
    biNewFolder: TdxBarLargeButton;
    biUpload: TdxBarLargeButton;
    acCreateFolder: TAction;
    acUploadFile: TAction;
    acDelete: TAction;
    acRefresh: TAction;
    csMain: TdxCloudStorage;
    aaGDrive: TdxGoogleAPIOAuth2AuthorizationAgent;
    aaOneDrive: TdxMicrosoftGraphAPIOAuth2AuthorizationAgent;
    ilSystem: TImageList;
    il32x32: TcxImageList;
    il16x16: TcxImageList;
    dxLayoutControl2: TdxLayoutControl;
    tvMain: TcxTreeView;
    lvMain: TcxListView;
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutSplitterItem1: TdxLayoutSplitterItem;
    barOrganize: TdxBar;
    biDelete: TdxBarLargeButton;
    biRefrash: TdxBarLargeButton;
    dxBarManagerBar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    acConnectionSettings: TAction;
    acGoogleDrive: TAction;
    acMicrosoftOneDrive: TAction;
    aiMain: TdxActivityIndicator;
    awmMain: TdxAlertWindowManager;
    dxLayoutGroup2: TdxLayoutGroup;
    dxLayoutGroup3: TdxLayoutGroup;
    dxLayoutLabeledItem1: TdxLayoutLabeledItem;
    procedure SpecifyAuthorizationSettings1Click(Sender: TObject);
    procedure tvMainEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure lvMainEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure csMainConnectedChanged(Sender: TObject);
    procedure csMainTreeDataLoaded(Sender: TObject;
      AFolder: TdxCloudStorageCustomFolder);
    procedure tvMainExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tvMainClick(Sender: TObject);
    procedure tvMainKeyPress(Sender: TObject; var Key: Char);
    procedure lvMainGetImageIndex(Sender: TObject; Item: TListItem);
    procedure lvMainDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvMainKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure csMainItemDownloaded(Sender: TObject;
      const AItem: TdxCloudStorageItem; AStream: TStream);
    procedure csMainItemDownloading(Sender: TObject;
      const AItem: TdxCloudStorageItem; const ASize: Integer);
    procedure acNewFolderExecute(Sender: TObject);
    procedure acUploadFileExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure csMainFolderCreated(Sender: TObject;
      AFolder: TdxCloudStorageCustomFolder);
    procedure csMainItemMovedToTrash(Sender: TObject;
      const AItem: TdxCloudStorageItem);
    procedure csMainItemUploading(Sender: TObject; const AFileName: string;
      const ASize: Integer);
    procedure acConnectionSettingsExecute(Sender: TObject);
    procedure acChangeProviderExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure csMainError(Sender: TObject; const AErrorObject);
  private
    FActiveDocumentEditors: TDictionary<TDocumentEditor, TdxCloudStorageFile>;
    FIconsMap: TDictionary<Integer, Integer>;
    FSelectedNode: TTreeNode;

    procedure DoChooseProvider(ATag: Integer);
    function GetFileName(AFile: TdxCloudStorageItem): string;
    function GetTopFolder: TdxCloudStorageCustomFolder;
    function IsItemSupported(AItem: TdxCloudStorageItem): Boolean;
    procedure PopulateListItems;
    procedure PopulateNodes(AParentNode: TTreeNode);
    procedure SetSelectedNode(const Value: TTreeNode);
    procedure ShowSetup;
    function SizeToString(ASize: Integer): string;
    procedure WaitForFolderLoaded(AFolder: TdxCloudStorageCustomFolder);
    procedure UpdateActions; reintroduce;
    procedure WMShowSetup(var Message: TMessage); message WM_SHOWSETUP;
    procedure OnAfterSaveDocumentEventHandler(Sender: TObject; const AFileName: string; AStream: TStream; var AHandled: Boolean);
    procedure OnDocumentEditorCloseHandler(Sender: TObject; var Action: TCloseAction);
  protected
    function IsApplicationButtonAvailable: Boolean; override;
    function IsExportOptionsAvailable: Boolean; override;
    function IsPrintOptionsAvailable: Boolean; override;
    property SelectedNode: TTreeNode read FSelectedNode write SetSelectedNode;
  end;

var
  fmCloudStorageDemoForm: TfmCloudStorageDemoForm;

implementation

uses
  ShellApi, IOUtils, Registry, dxDemoUtils,
  uCloudSetupForm, dxCloudStorageMicrosoftOneDriveProvider,
  dxCloudStorageGoogleDriveProvider,
  dxWinInet,
  uSpreadSheetEditor,
  uRichEditControlEditor,
  uPDFViewerEditor;

{$R *.dfm}

var
  FImageListHandle: Cardinal;
  FInfo: TSHFileInfo;

function ItemsCompare(AItem1, AItem2: TdxCloudStorageItem): Integer;
begin
  if AItem1.IsFolder xor AItem2.IsFolder then
  begin
    if AItem1.IsFolder then
      Result := -1
    else
      Result := 1;
  end
  else
    Result := CompareText(AItem1.Name, AItem2.Name);
end;

function NodesCompare(lParam1, lParam2, lParamSort: TdxNativeInt): Integer stdcall;
begin
  Result := ItemsCompare(TdxCloudStorageItem(TTreeNode(lParam1).Data), TdxCloudStorageItem(TTreeNode(lParam2).Data));
end;

function ListItemsCompare(lParam1, lParam2, lParamSort: TdxNativeInt): Integer stdcall;
begin
  Result := ItemsCompare(TdxCloudStorageItem(TListItem(lParam1).Data), TdxCloudStorageItem(TListItem(lParam2).Data));
end;

procedure TfmCloudStorageDemoForm.lvMainDblClick(Sender: TObject);
var
  AItem: TdxCloudStorageItem;
  I: Integer;
begin
  if lvMain.Selected = nil then
    Exit;
  AItem := TdxCloudStorageItem(lvMain.Selected.Data);
  if AItem.IsFolder then
  begin
    for I := 0 to tvMain.Items.Count - 1 do
      if tvMain.Items[I].Data = AItem then
      begin
        tvMain.Selected := tvMain.Items[I];
        SelectedNode := tvMain.Selected;
        Break;
      end;
  end
  else
    TdxCloudStorageFile(AItem).DownloadContent;
end;

procedure TfmCloudStorageDemoForm.lvMainEditing(Sender: TObject;
  Item: TListItem; var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;

procedure TfmCloudStorageDemoForm.lvMainGetImageIndex(Sender: TObject;
  Item: TListItem);
var
  AItem: TdxCloudStorageItem;
  AFlags: Integer;
  AInfo: TSHFileInfo;
  AIndex: Integer;
  AResult: Integer;
  AImage: TBitmap;
begin
  AItem := TdxCloudStorageItem(Item.Data);
  if AItem.IsFolder then
    Exit;
  FillChar(AInfo, SizeOf(AInfo), 0);
  AFlags := SHGFI_SYSICONINDEX or SHGFI_LARGEICON or SHGFI_USEFILEATTRIBUTES;

  SHGetFileInfo(PChar(GetFileName(AItem)), 0, AInfo, SizeOf(AInfo), AFlags);
  AIndex := AInfo.iIcon;
  DestroyIcon(AInfo.hIcon);

  if not FIconsMap.TryGetValue(AIndex, AResult) then
  begin
    AResult := il32x32.Count;
    FIconsMap.Add(AIndex, AResult);
    AImage := TBitmap.Create;
    try
      ilSystem.GetBitmap(AIndex, AImage);
      il32x32.Add(AImage, nil);
    finally
      AImage.Free;
    end;
  end;
  Item.ImageIndex := AResult;
end;

procedure TfmCloudStorageDemoForm.lvMainKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    lvMainDblClick(Sender);
end;

procedure TfmCloudStorageDemoForm.tvMainClick(Sender: TObject);
begin
  SelectedNode := tvMain.Selected;
end;

procedure TfmCloudStorageDemoForm.tvMainEditing(Sender: TObject;
  Node: TTreeNode; var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;

procedure TfmCloudStorageDemoForm.tvMainExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
var
  AFolder: TdxCloudStorageCustomFolder;
begin
  AFolder := TdxCloudStorageCustomFolder(Node.Data);
  if not AFolder.IsLoaded then
  begin
    AFolder.FetchChildren(True);
    WaitForFolderLoaded(AFolder);
    AllowExpansion := AFolder.HasChildren
  end;
end;

procedure TfmCloudStorageDemoForm.tvMainKeyPress(Sender: TObject;
  var Key: Char);
begin
  SelectedNode := tvMain.Selected;
end;

procedure TfmCloudStorageDemoForm.UpdateActions;
var
  ATopFolder: TdxCloudStorageCustomFolder;
begin
  ATopFolder := GetTopFolder;
  acCreateFolder.Enabled := Active and (ATopFolder <> nil) and ATopFolder.IsRoot;
  acUploadFile.Enabled := Active and (ATopFolder <> nil) and ATopFolder.IsRoot;
  acRefresh.Enabled := Active and (ATopFolder <> nil);
  acDelete.Enabled := Active and (ATopFolder <> nil) and ATopFolder.IsRoot and (lvMain.Selected <> nil);
end;

procedure TfmCloudStorageDemoForm.acNewFolderExecute(Sender: TObject);
var
  AName: string;
begin
  AName := 'New Folder';
  if InputQuery('New folder', 'Name:', AName) then
    TdxCloudStorageFolder(tvMain.Selected.Data).CreateFolder(AName);
end;

procedure TfmCloudStorageDemoForm.acConnectionSettingsExecute(Sender: TObject);
begin
  inherited;
  ShowSetup;
end;

procedure TfmCloudStorageDemoForm.acDeleteExecute(Sender: TObject);
begin
  if not Active then
    Exit;
  if MessageDlg('Are you sure want to delete item(s)?', mtConfirmation, mbYesNoCancel, 0) = mrYes then
    TdxCloudStorageItem(lvMain.Selected.Data).MoveToTrash;
end;

procedure TfmCloudStorageDemoForm.acChangeProviderExecute(Sender: TObject);
begin
  acGoogleDrive.Checked := False;
  acMicrosoftOneDrive.Checked := False;
  DoChooseProvider(TComponent(Sender).Tag);
end;

procedure TfmCloudStorageDemoForm.acRefreshExecute(Sender: TObject);
begin
  if SelectedNode = nil then
    Exit;

  TdxCloudStorageCustomFolder(SelectedNode.Data).FetchChildren(True);
end;

procedure TfmCloudStorageDemoForm.ActionList1Update(Action: TBasicAction;
  var Handled: Boolean);
begin
  UpdateActions;
end;

procedure TfmCloudStorageDemoForm.acUploadFileExecute(Sender: TObject);
begin
  if OpenDialog.Execute then
    TdxCloudStorageFolder(SelectedNode.Data).UploadFile(OpenDialog.FileName);
end;

procedure TfmCloudStorageDemoForm.csMainConnectedChanged(Sender: TObject);
const
  AImageIndexMap: array[TdxCloudStorageSpecialFolder.TType] of Integer = (4, 2, 2, 3, 0, 5);
var
  ANode: TTreeNode;
begin
  FSelectedNode := nil;

  if not csMain.Connected then
    FActiveDocumentEditors.Clear;

  acGoogleDrive.Checked := csMain.ProviderClass = TdxCloudStorageGoogleDriveProvider;
  acMicrosoftOneDrive.Checked := csMain.ProviderClass = TdxCloudStorageMicrosoftOneDriveProvider;

  tvMain.Items.BeginUpdate;
  try
    tvMain.Items.Clear;
    lvMain.Items.Clear;
    if csMain.Connected then
    begin
      ANode := tvMain.Items.AddObject(nil, 'Files', csMain.Files.Root);
      ANode.ImageIndex := 1;
      ANode.SelectedIndex := 1;
      with lvMain.Items.Add do
      begin
        ImageIndex := 1;
        Caption := 'Files';
        Data := csMain.Files.Root;
      end;
      PopulateNodes(ANode);
      csMain.Files.Root.FetchChildren;
      csMain.Files.SpecialFolders.Enum( procedure (const ASpecialFolder: TdxCloudStorageSpecialFolder)
        begin
          ANode := tvMain.Items.AddObject(nil, ASpecialFolder.Name, ASpecialFolder);
          ANode.ImageIndex := AImageIndexMap[ASpecialFolder.&Type];
          ANode.SelectedIndex := ANode.ImageIndex;
          with lvMain.Items.Add do
          begin
            ImageIndex := ANode.ImageIndex;
            Caption := ANode.Text;
            Data := ANode.Data;
          end;
          PopulateNodes(ANode);
        end);
      tvMain.Selected := nil;
    end;
  finally
    tvMain.Items.EndUpdate;
  end;
end;

procedure TfmCloudStorageDemoForm.csMainError(Sender: TObject;
  const AErrorObject);
var
  AError: TdxJSONObject;
begin
  inherited;
  AError := TdxJSONObject(AErrorObject);
  MessageError(AError.GetChildParamValue('error', 'message'));
end;

procedure TfmCloudStorageDemoForm.csMainFolderCreated(Sender: TObject;
  AFolder: TdxCloudStorageCustomFolder);
var
  I: Integer;
begin
  TdxCloudStorageCustomFolder(SelectedNode.Data).FetchChildren(True);
  for I := 0 to AFolder.Parents.Count - 1 do
    AFolder.Parents[I].FetchChildren;
  PopulateListItems;
  for I := 0 to lvMain.Items.Count - 1 do
    if lvMain.Items[I].Data = AFolder then
    begin
      lvMain.Selected := lvMain.Items[I];
      Break;
    end;
end;

procedure TfmCloudStorageDemoForm.csMainTreeDataLoaded(Sender: TObject;
  AFolder: TdxCloudStorageCustomFolder);

  procedure ForEachNode(ANode: TTreeNode);
  var
    I: Integer;
  begin
    if ANode.Data = AFolder then
      PopulateNodes(ANode);
    for I := 0 to ANode.Count - 1 do
      ForEachNode(ANode.Item[I]);
  end;

var
  ANode: TTreeNode;
  I: Integer;
begin
  if AFolder = nil then
    Exit;
  ANode := tvMain.InnerTreeView.TopItem;
  while ANode <> nil do
  begin
    if ANode.Parent = nil then
      ForEachNode(ANode);
    ANode := ANode.GetNext;
  end;
  if (SelectedNode <> nil) and (SelectedNode.Data = AFolder) then
    PopulateListItems
  else
  for I := 0 to lvMain.Items.Count - 1 do
    if lvMain.Items[I].Data = AFolder then
    begin
      if AFolder.IsRoot and (csMain.ProviderClass = TdxCloudStorageMicrosoftOneDriveProvider) then
        lvMain.Items[I].Caption := 'Files'
      else
        lvMain.Items[I].Caption := AFolder.Name;
      Break;
    end;
end;

procedure TfmCloudStorageDemoForm.csMainItemDownloaded(Sender: TObject; const AItem: TdxCloudStorageItem;
  AStream: TStream);
var
  ADocumentEditor: TDocumentEditor;
  ADocumentEditorClass: TDocumentEditorClass;
  AFile: TdxCloudStorageFile;
  AInfo: TEditorInfo;
begin
  if not (AItem is TdxCloudStorageFile) then
    Exit;
  AFile := TdxCloudStorageFile(AItem);
  if DocumentEditorFactory.TryGetEditor(AFile.GetExtension, ADocumentEditorClass) then
  begin
    AInfo.FileName := AFile.Name;
    AInfo.Stream := AStream;
    ADocumentEditor := ADocumentEditorClass.CreateEx(Self, AInfo);
    ADocumentEditor.OnClose := OnDocumentEditorCloseHandler;
    ADocumentEditor.OnAfterSaveDocumentEvent := OnAfterSaveDocumentEventHandler;
    FActiveDocumentEditors.Add(ADocumentEditor, AFile);
  end;
end;

procedure TfmCloudStorageDemoForm.csMainItemDownloading(Sender: TObject;
  const AItem: TdxCloudStorageItem; const ASize: Integer);
begin
  inherited;
  if ASize = -1 then
    awmMain.Show('Downloading...', Format('File: %s', [AItem.Name]))
  else
    awmMain.Show('Downloading...', Format('File: %s'#13#10'Size: %s', [AItem.Name, SizeToString(ASize)]));
  Application.ProcessMessages;
end;

procedure TfmCloudStorageDemoForm.csMainItemMovedToTrash(Sender: TObject;
  const AItem: TdxCloudStorageItem);
begin
  if csMain.Files.Trash <> nil then
    csMain.Files.Trash.FetchChildren;
  if SelectedNode <> nil then
    TdxcloudStorageCustomFolder(SelectedNode.Data).FetchChildren(True);
  PopulateListItems;
end;

procedure TfmCloudStorageDemoForm.csMainItemUploading(Sender: TObject;
  const AFileName: string; const ASize: Integer);
begin
  if ASize = -1 then
    awmMain.Show('Uploading...', Format('File: %s', [AFileName]))
  else
    awmMain.Show('Uploading...', Format('File: %s'#13#10'Size: %s', [AFileName, SizeToString(ASize)]));
  Application.ProcessMessages;
end;

function TfmCloudStorageDemoForm.GetFileName(AFile: TdxCloudStorageItem): string;
var
  AExt: string;
begin
  Result := AFile.Name;
  AExt := csMain.Provider.GetExtension(AFile);
  if (AExt <>  '') and (Pos(LowerCase(AExt), LowerCase(Result)) = 0) then
    Result := Format('%s.%s', [Result, AExt]);
end;

function TfmCloudStorageDemoForm.SizeToString(ASize: Integer): string;
begin
  if ASize > 1024 * 1024 then
    Result := Format('%3.2f MB', [ASize / 1024 / 1024])
  else if ASize > 1024 then
    Result := Format('%3.2f KB', [ASize / 1024])
  else
    Result := Format('%d B', [ASize])
end;

function TfmCloudStorageDemoForm.GetTopFolder: TdxCloudStorageCustomFolder;

  function GetParent(ANode: TTreeNode): TTreeNode;
  begin
    if ANode.Parent = nil then
      Result := ANode
    else
      Result := GetParent(ANode.Parent);
  end;

begin
  Result := nil;
  if SelectedNode = nil then
    Exit;
  Result := TdxCloudStorageCustomFolder(GetParent(tvMain.Selected).Data);
end;

function TfmCloudStorageDemoForm.IsItemSupported(AItem: TdxCloudStorageItem): Boolean;
var
  AFile: TdxCloudStorageFile;
  AExtensions: TArray<string>;
  AExtension, AFileExtension: string;
begin
  Result := AItem.IsFolder or (AItem is TdxCloudStorageFile);
  if Result and (AItem is TdxCloudStorageFile) then
  begin
    AFile := TdxCloudStorageFile(AItem);
    AExtensions := TArray<string>.Create('.docx', '.doc', '.rtf', '.txt',
      '.xlsx', '.xls', '.ods',
      '.pdf');
    AFileExtension := LowerCase(AFile.GetExtension);
    for AExtension in AExtensions do
      if AFileExtension = AExtension then
        Exit(True);
    Exit(False);
  end;
end;

function TfmCloudStorageDemoForm.IsApplicationButtonAvailable: Boolean;
begin
  Result := False;
end;

function TfmCloudStorageDemoForm.IsExportOptionsAvailable: Boolean;
begin
  Result := False;
end;

function TfmCloudStorageDemoForm.IsPrintOptionsAvailable: Boolean;
begin
  Result := False;
end;

procedure TfmCloudStorageDemoForm.PopulateListItems;
var
  I: Integer;
  AFolder: TdxCloudStorageCustomFolder;
begin
  if SelectedNode = nil then
    Exit;
  AFolder := TdxCloudStorageCustomFolder(SelectedNode.Data);
  if not AFolder.IsLoaded then
  begin
    AFolder.FetchChildren;
    WaitForFolderLoaded(AFolder);
    Exit;
  end;
  lvMain.Items.BeginUpdate;
  try
    lvMain.Clear;
    for I := 0 to AFolder.Children.Count - 1 do
      if IsItemSupported(AFolder.Children[I]) then
      with lvMain.Items.Add do
      begin
        Caption := AFolder.Children[I].Name;
        Data := AFolder.Children[I];
      end;
    lvMain.CustomSort(ListItemsCompare, 0);
  finally
    lvMain.Items.EndUpdate;
  end;
end;

procedure TfmCloudStorageDemoForm.PopulateNodes(AParentNode: TTreeNode);
var
  AFolder: TdxCloudStorageCustomFolder;
  I: Integer;
begin
  AFolder := TdxCloudStorageCustomFolder(AParentNode.Data);
  if AFolder.IsRoot and (csMain.ProviderClass = TdxCloudStorageMicrosoftOneDriveProvider) then
    AParentNode.Text := 'Files'
  else
    AParentNode.Text := AFolder.Name;
  if not AFolder.IsLoaded then
  begin
    if AParentNode.Count = 0 then
      tvMain.Items.AddChild(AParentNode, '(loading...)')
  end
  else
  begin
    tvMain.Items.BeginUpdate;
    try
      AParentNode.DeleteChildren;
      for I := 0 to AFolder.Children.Count - 1 do
        if AFolder.Children[I] is TdxCloudStorageCustomFolder then
          PopulateNodes(tvMain.Items.AddChildObject(AParentNode, AFolder.Children[I].Name, AFolder.Children[I]));
      AParentNode.CustomSort(NodesCompare, 0, False);
    finally
      tvMain.Items.EndUpdate;
    end;
  end;
end;

procedure TfmCloudStorageDemoForm.SetSelectedNode(const Value: TTreeNode);
begin
  if FSelectedNode = Value then
    Exit;
  FSelectedNode := Value;
  PopulateListItems;
end;

procedure TfmCloudStorageDemoForm.DoChooseProvider(ATag: Integer);
begin
  SelectedNode := nil;
  tvMain.Items.Clear;
  lvMain.Items.Clear;
  if ATag = 0 then
  begin
    if aaOneDrive.ClientID <> '' then
      csMain.ProviderClass := TdxCloudStorageMicrosoftOneDriveProvider
    else
      if aaGDrive.ClientID <> '' then
        csMain.ProviderClass := TdxCloudStorageGoogleDriveProvider
      else
        csMain.ProviderClass := nil;
  end
  else
  begin
    if aaGDrive.ClientID <> '' then
      csMain.ProviderClass := TdxCloudStorageGoogleDriveProvider
    else
      if aaOneDrive.ClientID <> '' then
        csMain.ProviderClass := TdxCloudStorageMicrosoftOneDriveProvider
      else
        csMain.ProviderClass := nil;
  end;
  if csMain.ProviderClass = TdxCloudStorageGoogleDriveProvider then
    csMain.Provider.AuthorizationAgent := aaGDrive
  else
    if csMain.ProviderClass = TdxCloudStorageMicrosoftOneDriveProvider then
      csMain.Provider.AuthorizationAgent := aaOneDrive;
  csMain.Connected := True;
end;

procedure TfmCloudStorageDemoForm.FormCreate(Sender: TObject);
begin
  inherited;
  FActiveDocumentEditors := TDictionary<TDocumentEditor, TdxCloudStorageFile>.Create;

  FImageListHandle := SHGetFileInfo('C:\', 0, FInfo, SizeOf(FInfo), SHGFI_SYSICONINDEX or SHGFI_LARGEICON);
  ilSystem.Handle := FImageListHandle;
  FIconsMap := TDictionary<Integer, Integer>.Create;

  UpdateBaseMenuOptions;

  barInfo.ItemLinks.Delete(0);
  Caption := 'Cloud Data Access Demo';
  UpdateActions;
end;

procedure TfmCloudStorageDemoForm.FormDestroy(Sender: TObject);
begin
  ilSystem.Handle := 0;
  DestroyIcon(FInfo.hIcon);
  FreeResource(FImageListHandle);
  FIconsMap.Free;
  FreeAndNil(FActiveDocumentEditors);
  inherited;
end;

procedure TfmCloudStorageDemoForm.FormShow(Sender: TObject);
begin
  inherited;
  PostMessage(Handle, WM_SHOWSETUP, 0, 0);
end;

procedure TfmCloudStorageDemoForm.ShowSetup;
begin
  with TfmCloudSetupWizard.Create(nil) do
  try
    btnStart.Caption := 'OK';
    teGoogleApiClientID.Text := aaGDrive.ClientID;
    teGoogleApiClientSecret.Text := aaGDrive.ClientSecret;
    teMSGraphClientID.Text := aaOneDrive.ClientID;
    teMSGraphClientSecret.Text := aaOneDrive.ClientSecret;
    if ShowModal = mrOk then
    begin
      aaGDrive.ClientID := teGoogleApiClientID.Text;
      aaGDrive.ClientSecret := teGoogleApiClientSecret.Text;
      aaOneDrive.ClientID := teMSGraphClientID.Text;
      aaOneDrive.ClientSecret := teMSGraphClientSecret.Text;
      acMicrosoftOneDrive.Enabled := (aaOneDrive.ClientID <> '') and (aaOneDrive.ClientSecret <> '');
      acGoogleDrive.Enabled := (aaGDrive.ClientID <> '') and (aaGDrive.ClientSecret <> '');
      DoChooseProvider(dxLayoutGroup4.ItemIndex);
    end;
  finally
    Free;
  end;
end;

procedure TfmCloudStorageDemoForm.WaitForFolderLoaded(AFolder: TdxCloudStorageCustomFolder);
var
  P: TPoint;
  AProvider: TdxCloudStorageProvider;
begin
  if AFolder.IsLoaded then
    Exit;

  if not aiMain.Active then
  begin
    aiMain.Active := True;
    P := TPoint.Create(0, 0);
    P := lvMain.ClientToScreen(P);
    P := ScreenToClient(P);
    aiMain.Left := P.X + (lvMain.Width - aiMain.Width) div 2;
    aiMain.Top := P.Y + (lvMain.Height - aiMain.Height) div 2;
    aiMain.Visible := True;
  end;
  AProvider := csMain.Provider;
  while csMain.Connected and (csMain.Provider = AProvider) and not AFolder.IsLoaded do
    Application.ProcessMessages;

  aiMain.Active := False;
  aiMain.Visible := False;
end;

procedure TfmCloudStorageDemoForm.WMShowSetup(var Message: TMessage);
begin
  ShowSetup;
end;

procedure TfmCloudStorageDemoForm.OnAfterSaveDocumentEventHandler(Sender: TObject; const AFileName: string; AStream: TStream; var AHandled: Boolean);
var
  AFile: TdxCloudStorageFile;
begin
  if FActiveDocumentEditors.TryGetValue(Sender as TDocumentEditor, AFile) then
    AFile.UploadContent(AStream);
end;

procedure TfmCloudStorageDemoForm.OnDocumentEditorCloseHandler(Sender: TObject; var Action: TCloseAction);
begin
  if Action = caFree  then
    FActiveDocumentEditors.Remove(Sender as TDocumentEditor);
end;

procedure TfmCloudStorageDemoForm.SpecifyAuthorizationSettings1Click(Sender: TObject);
begin
  ShowSetup;
end;

const
  REG_KEY = 'Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION';
  REG_KEY_64 = 'SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION';

procedure SetIE11KeyForWebBrowser;
var
  ARegistry: TRegistry;
  AKey: string;
begin
  ARegistry := TRegistry.Create;
  try
    ARegistry.RootKey := HKEY_CURRENT_USER;
    AKey := {$IFDEF CPUX64}REG_KEY_64{$ELSE}REG_KEY{$ENDIF};
    if ARegistry.OpenKey(AKey, True) then
      ARegistry.WriteInteger(ExtractFileName(Application.ExeName), 11001);
  finally
    ARegistry.Free;
  end;
end;

procedure RemoveIE11KeyForWebBrowser;
var
  ARegistry: TRegistry;
  AKey: string;
begin
  ARegistry := TRegistry.Create;
  try
    ARegistry.RootKey := HKEY_CURRENT_USER;
    AKey := {$IFDEF CPUX64}REG_KEY_64{$ELSE}REG_KEY{$ENDIF};
    if ARegistry.OpenKey(AKey, True) then
      ARegistry.DeleteValue(ExtractFileName(Application.ExeName));
  finally
    ARegistry.Free;
  end;
end;

initialization
  SetIE11KeyForWebBrowser;
  dxMegaDemoProductIndex := dxCloudStorageIndex;

finalization
  RemoveIE11KeyForWebBrowser;

end.
