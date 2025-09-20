{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           Express Cross Platform Library classes                   }
{                                                                    }
{           Copyright (c) 2000-2024 Developer Express Inc.           }
{           ALL RIGHTS RESERVED                                      }
{                                                                    }
{   The entire contents of this file is protected by U.S. and        }
{   International Copyright Laws. Unauthorized reproduction,         }
{   reverse-engineering, and distribution of all or any portion of   }
{   the code contained in this file is strictly prohibited and may   }
{   result in severe civil and criminal penalties and will be        }
{   prosecuted to the maximum extent possible under the law.         }
{                                                                    }
{   RESTRICTIONS                                                     }
{                                                                    }
{   THIS SOURCE CODE AND ALL RESULTING INTERMEDIATE FILES            }
{   (DCU, OBJ, DLL, ETC.) ARE CONFIDENTIAL AND PROPRIETARY TRADE     }
{   SECRETS OF DEVELOPER EXPRESS INC. THE REGISTERED DEVELOPER IS    }
{   LICENSED TO DISTRIBUTE THE EXPRESSCROSSPLATFORMLIBRARY AND ALL   }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM       }
{   ONLY.                                                            }
{                                                                    }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED       }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE         }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE        }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT   }
{   AND PERMISSION FROM DEVELOPER EXPRESS INC.                       }
{                                                                    }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON        }
{   ADDITIONAL RESTRICTIONS.                                         }
{                                                                    }
{********************************************************************}

unit cxImageListEditor;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Windows, SysUtils, Classes, Generics.Collections, ImgList, ComCtrls, Controls, Graphics, Forms, Dialogs,
  dxCore, dxCoreClasses, dxCoreGraphics, dxGDIPlusAPI, dxGDIPlusClasses, cxClasses, cxGeometry, cxGraphics, cxFormats,
  dxSVGImage, dxSmartImage, cxVariants, cxImageList, dxForms, dxListView;

type
  TcxImageListEditor = class;

  { TcxImageFileFormat }

  TcxImageFileFormat = record
    GraphicClass: TGraphicClass;
    Name: string;
    Ext: string;
  end;

  { TcxImageFileFormats }

  TcxImageFileFormatList = array of TcxImageFileFormat;
  TcxImageFileFormats = class
  strict private
    class var FInstance: TcxImageFileFormats;
  strict private
    FList: TcxImageFileFormatList;

    function Count: Integer;
    function GetItem(Index: Integer): TcxImageFileFormat;
  protected
    class procedure Finalize;
    class function GetInstance: TcxImageFileFormats;

    property Items[Index: Integer]: TcxImageFileFormat read GetItem;
  public
    procedure Register(const AName, AExt: string; AGraphicClass: TGraphicClass);

    function GetGraphicClass(const AFileName: string): TGraphicClass;
    function GetFilter: string;
  end;

  { TcxCustomImageListEditorForm }

  TcxCustomImageListEditorFormClass = class of TcxCustomImageListEditorForm;
  TcxCustomImageListEditorForm = class(TdxForm)
  protected
    FImageListEditor: TcxImageListEditor;

    procedure DataChanged(Sender: TObject);
    procedure UpdateControls; virtual; abstract;
    procedure RestorePosition; virtual;
    procedure StorePosition; virtual;
  public
    constructor Create(AImageListEditor: TcxImageListEditor); reintroduce; virtual;

    function GetVisualDataControl: TdxListViewControl; virtual; abstract;
    procedure SetImportList(AValue: TStrings); virtual; abstract;
  end;

  { TcxImageListEditor }

  TcxImageListEditorAddMode = (amAdd, amInsert, amReplace);
  TcxImageType = (itBMP, itICO, itPNG);

  TcxImageListEditor = class
  strict private
    FChanged: Boolean;
    FImageListModified: Boolean;

    FDataControl: TdxListViewControl;
    FImageList: TcxImageList;
    FOriginalImageList: TcxImageList;
    FShowImageTypes: Boolean;

    FImportList: TStrings;
    FVisibleImportList: TStrings;

    FClipboardFormat: Word;
    FSplitImages: TdxDefaultBoolean;
    FUpdateCount: Integer;

    FOnChange: TNotifyEvent;

    procedure AddDataItems(AImageList: TcxImagelist);
    procedure AddImage(AImageInfo: TcxImageInfo; var AInsertIndex: Integer; AMultiSelect: Boolean); overload;
    procedure AddImage(AImage: TGraphic; AMask: TBitmap; AMaskColor: TColor;
      var AInsertIndex: Integer; const AFileName, AKeywords: string; AMultiSelect: Boolean);  overload;
    procedure AddImageCore(AImage: TGraphic; AMask: TBitmap; AMaskColor: TColor;
      var AInsertIndex: Integer; const AFileName, AKeywords: string);
    procedure AddImagesFromStream(AStream: TStream; var AInsertIndex: Integer);
    procedure Change;
    procedure DeleteDataItem(Sender: TdxCustomListView; AItem: TdxListItem);
    procedure DeleteImage(AIndex: Integer);
    function ExportSelectedAsImage(ABackgroundColor: TColor): TcxBitmap32;
    function ExportSelectedAsStream: TMemoryStream;
    function FirstSelectedImageIndex: Integer;
    function GetDataItems: TdxListItems;
    function GetFocusedImageIndex: Integer;
    function GetFocusedImageInfo: TcxImageInfo;
    function GetImageHeight: Integer;
    function GetImagesCount: Integer;
    function GetImagesInfo(Index: Integer): TcxImageInfo;
    function GetImageWidth: Integer;
    function IsIndexValid(AIndex: Integer): Boolean;
    procedure ImageListChanged;
    procedure SelectDataItem(Sender: TdxCustomListView; AItem: TdxListItem; ASelected: Boolean);
    procedure SetFocusedImageIndex(AValue: Integer);
    procedure SetImageList(AValue: TcxImageList);
    procedure SetImagesInfo(Index: Integer; AValue: TcxImageInfo);
    procedure SetImportList(AValue: TStrings);
    procedure SetShowImageTypes(const Value: Boolean);

    procedure Adding;
    procedure Added(AInsertIndex: Integer);
    procedure UpdateImageList;
    procedure UpdateListViewItems;
    procedure UpdateVisibleImportList;
  protected
    FEditorForm: TcxCustomImageListEditorForm;

    function GetEditorFormClass: TcxCustomImageListEditorFormClass; virtual;
    function GetImageCaption(AIndex: Integer): string; virtual;
    function GetImageInfoFromFile(const AFileName: string; AImageInfo: TcxImageInfo): Boolean;
    function GetImageListEditorCaption(AImageList: TcxImageList): string; virtual;
    function ShowRasterImagesResizeConfirmation: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    function Edit(AImageList: TcxImagelist): Boolean;

    procedure AddImages(AFiles: TStrings; AAddMode: TcxImageListEditorAddMode);
    procedure ClearImages;
    procedure ConvertTo32bit;
    procedure DeleteSelectedImages;
    procedure ExportImages(const AFileName: string; AFormat: TcxImageType = itBMP);
    procedure ImportImages(AImageList: TCustomImageList);
    procedure MoveImage(ASourceImageIndex, ADestImageIndex: Integer);

    function CanCopyToClipboard: Boolean;
    function CanPasteFromClipboard: Boolean;
    procedure CutToClipboard;
    procedure CopyToClipboard;
    procedure PasteFromClipboard;

    procedure ClearSelection;
    function GetSelectionCount: Integer;
    function IsAnyImageSelected: Boolean;
    function IsSingleImageSelected: Boolean;
    function IsVectorImageSelected: Boolean;
    procedure SelectAll;

    procedure BeginUpdate;
    procedure EndUpdate;
    function IsUpdateLocked: Boolean;

    procedure ApplyChanges; virtual;
    function IsChanged: Boolean;
    procedure UpdateTransparentColor(AColor: TColor);
    function ChangeImagesSize(const AValue: TSize): Boolean;
    procedure SynchronizeData(AStartIndex, ACount: Integer);

    property DataControl: TdxListViewControl read FDataControl;
    property DataItems: TdxListItems read GetDataItems;
    property FocusedImageIndex: Integer read GetFocusedImageIndex write SetFocusedImageIndex;
    property FocusedImageInfo: TcxImageInfo read GetFocusedImageInfo;
    property ImageHeight: Integer read GetImageHeight;
    property ImageList: TcxImageList read FImageList write SetImageList;
    property ImageListModified: Boolean read FImageListModified;
    property ImagesCount: Integer read GetImagesCount;
    property ImagesInfo[Index: Integer]: TcxImageInfo read GetImagesInfo write SetImagesInfo;
    property ImageWidth: Integer read GetImageWidth;
    property ImportList: TStrings read FImportList write SetImportList;
    property OriginalImageList: TcxImageList read FOriginalImageList;
    property ShowImageTypes: Boolean read FShowImageTypes write SetShowImageTypes;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { TdxMultiPartGlyphEditor }

  TdxMultiPartGlyphEditor = class(TcxImageListEditor)
  strict private
    FGlyph: TdxSmartGlyph;
    FMultiPartGlyphSupport: IdxMultiPartGlyphSupport;

    procedure CombineGlyphs;
    procedure PopulateImageList(AImageList: TcxImageList);
  protected
    function GetImageCaption(AIndex: Integer): string; override;
    function GetImageListEditorCaption(AImageList: TcxImageList): string; override;
  public
    procedure ApplyChanges; override;
    function Edit(AGlyph: TdxSmartGlyph; AMultiPartGlyphSupport: IdxMultiPartGlyphSupport): Boolean;
  end;

function cxImageFileFormats: TcxImageFileFormats;
function cxEditImageList(AImageList: TcxImageList; AImportList: TStrings): Boolean;
procedure PngImageListTocxImageList(APngImages: TComponent; AImages: TcxImageList);
implementation

uses
  Types, Math, Clipbrd, dxMessageDialog, cxImageListEditorView, dxIconLibraryEditorHelpers;

const
  dxThisUnitName = 'cxImageListEditor';

const
  sMsgChangeImagesSizeConfirm = 'This will change the image dimensions and scale the existing images in the list. Scaling raster images may reduce their visual quality. Do you want to proceed?';
  sMsgSplitConfirm = 'The image in the file %s is too large.'#13#10'Do you want to split it into smaller images?';
  sMsgReplaceConfirm = 'File %s is already exists.'#13#10'Do you want to replace it?';

type
  TReaderAccess = class(TReader);
  TWriterAccess = class(TWriter);
  TcxImageListAccess = class(TcxImageList);
  TdxCustomSmartImageAccess = class(TdxCustomSmartImage);
  TdxListViewControllerAccess = class(TdxListViewController);

  { TcxIcon }

  TcxIcon = class(TIcon)
  protected
    procedure SetBitmap(ABitmap: TBitmap);
  public
    constructor CreateFromBitmap(ABitmap: TBitmap);
    procedure GetImageInfo(AImageInfo: TcxImageInfo);
    procedure HandleNeeded;
  end;

  { TPngImageListImporter }

  TPngImageListImporter = class
  strict private
    class procedure AddImageFromBinaryData(WriteData: TStreamProc; AImages: TcxImageList);
    class procedure ProcessPngImageList(AInputStream: TMemoryStream; AImages: TcxImageList);
  public
    class procedure Import(APngImages: TComponent; AImages: TcxImageList);
  end;

function cxImageFileFormats: TcxImageFileFormats;
begin
  Result := TcxImageFileFormats.GetInstance;
end;

function cxEditImageList(AImageList: TcxImageList; AImportList: TStrings): Boolean;
var
  AImageListEditor: TcxImageListEditor;
begin
  Result := False;
  if AImageList = nil then
    Exit;
  AImageListEditor := TcxImageListEditor.Create;
  try
    AImageListEditor.ImportList := AImportList;
    Result := AImageListEditor.Edit(AImageList);
  finally
    AImageListEditor.Free;
  end;
end;

procedure PngImageListTocxImageList(APngImages: TComponent; AImages: TcxImageList);
begin
  TPngImageListImporter.Import(APngImages, AImages);
end;

{ TPngImageListImporter }

class procedure TPngImageListImporter.AddImageFromBinaryData(WriteData: TStreamProc; AImages: TcxImageList);
var
  AStream: TMemoryStream;
  ACount: Longint;
  B: TBitmap;
begin
  AStream := TMemoryStream.Create;
  try
    WriteData(AStream);
    ACount := AStream.Size;
    if ACount > 0 then
    begin
      AStream.Write(AStream.Memory^, ACount);
      AStream.Position := 0;
      with TdxPNGImage.Create do
      try
        LoadFromStream(AStream);
        B := GetAsBitmap;
        try
          AImages.Add(B, nil);
        finally
          B.Free;
        end;
      finally
        Free;
      end;
    end;
  finally
    AStream.Free;
  end;
end;

class procedure TPngImageListImporter.ProcessPngImageList(AInputStream: TMemoryStream; AImages: TcxImageList);
var
  ASaveSeparator: Char;
  AParser: TParser;

  function ConvertOrderModifier: Integer;
  begin
    Result := -1;
    if AParser.Token = '[' then
    begin
      AParser.NextToken;
      AParser.CheckToken(toInteger);
      Result := AParser.TokenInt;
      AParser.NextToken;
      AParser.CheckToken(']');
      AParser.NextToken;
    end;
  end;

  procedure ConvertHeader(AIsInherited, AIsInline: Boolean);
  var
    AClassName, AObjectName: string;
  begin
    AParser.CheckToken(toSymbol);
    AClassName := AParser.TokenString;
    AObjectName := '';
    if AParser.NextToken = ':' then
    begin
      AParser.NextToken;
      AParser.CheckToken(toSymbol);
      AObjectName := AClassName;
      AClassName := AParser.TokenString;
      AParser.NextToken;
    end;
    ConvertOrderModifier;
  end;

  procedure ConvertProperty; forward;

  procedure ConvertValue(const APropName: string);

    procedure SkipString;
    begin
      while AParser.NextToken = '+' do
      begin
        AParser.NextToken;
        if not dxCharInSet(AParser.Token, [Classes.toString, Classes.toWString]) then
          AParser.CheckToken(Classes.toString);
      end;
    end;

    procedure SkipBinaryData;
    var
      S: TMemoryStream;
    begin
      S := TMemoryStream.Create;
      try
        AParser.HexToBinary(S);
      finally
        S.Free;
      end;
    end;

  begin
    if dxCharInSet(AParser.Token, [Classes.toString, Classes.toWString]) then
      SkipString
    else
    begin
      case AParser.Token of
        toSymbol, toInteger, toFloat:;
        '[':
          begin
            AParser.NextToken;
            if AParser.Token <> ']' then
              while True do
              begin
                if AParser.NextToken = ']' then Break;
                AParser.CheckToken(',');
                AParser.NextToken;
              end;
          end;
        '(':
          begin
            AParser.NextToken;
            while AParser.Token <> ')' do
              ConvertValue('');
          end;
        '{':
          begin
            if APropName = 'PngImage.Data' then
              AddImageFromBinaryData(AParser.HexToBinary, AImages)
            else
              SkipBinaryData;
          end;
        '<':
          begin
            AParser.NextToken;
            while AParser.Token <> '>' do
            begin
              AParser.CheckTokenSymbol('item');
              AParser.NextToken;
              ConvertOrderModifier;
              AParser.TokenString;
              while not AParser.TokenSymbolIs('end') do ConvertProperty;
              AParser.NextToken;
            end;
          end;
      else
        raise EdxException.Create('Convert error');
      end;
      AParser.NextToken;
    end;
  end;

  procedure ConvertProperty;
  var
    APropName: string;
  begin
    AParser.CheckToken(toSymbol);
    APropName := AParser.TokenString;
    AParser.NextToken;
    while AParser.Token = '.' do
    begin
      AParser.NextToken;
      AParser.CheckToken(toSymbol);
      APropName := APropName + '.' + AParser.TokenString;
      AParser.NextToken;
    end;
    AParser.CheckToken('=');
    AParser.NextToken;
    ConvertValue(APropName);
  end;

  procedure ConvertObject;
  var
    AInheritedObject: Boolean;
    AInlineObject: Boolean;
  begin
    AInheritedObject := False;
    AInlineObject := False;
    if AParser.TokenSymbolIs('INHERITED') then
      AInheritedObject := True
    else if AParser.TokenSymbolIs('INLINE') then
      AInlineObject := True
    else
      AParser.CheckTokenSymbol('OBJECT');
    AParser.NextToken;
    ConvertHeader(AInheritedObject, AInlineObject);
    while not AParser.TokenSymbolIs('END') and
      not AParser.TokenSymbolIs('OBJECT') and
      not AParser.TokenSymbolIs('INHERITED') and
      not AParser.TokenSymbolIs('INLINE') do
      ConvertProperty;
    while not AParser.TokenSymbolIs('END') do
      ConvertObject;
  end;

begin
  AParser := TParser.Create(AInputStream);
  ASaveSeparator := dxFormatSettings.DecimalSeparator;
  dxFormatSettings.DecimalSeparator := '.';
  try
    ConvertObject;
  finally
    dxFormatSettings.DecimalSeparator := ASaveSeparator;
    AParser.Free;
  end;
end;

class procedure TPngImageListImporter.Import(APngImages: TComponent; AImages: TcxImageList);
var
  S, D: TMemoryStream;
begin
  S := TMemoryStream.Create;
  try
    S.WriteComponent(APngImages);
    S.Position := 0;
    D := TMemoryStream.Create;
    try
      ObjectBinaryToText(S, D);
      S.Position := 0;
      D.Position := 0;
      ProcessPngImageList(D, AImages);
    finally
      D.Free;
    end;
  finally
    S.Free;
  end;
end;

{ TcxIcon }

constructor TcxIcon.CreateFromBitmap(ABitmap: TBitmap);
begin
  inherited Create;
  SetBitmap(ABitmap);
end;

procedure TcxIcon.GetImageInfo(AImageInfo: TcxImageInfo);
var
  AImages: TcxImageListAccess;
begin
  HandleNeeded;
  AImages := TcxImageListAccess.CreateSize(Width, Height);
  try
    AImages.AddIcon(Self);
    AImageInfo.Assign(AImages.GetImageInfo(0));
    if AImageInfo.IsAlphaUsed then
      AImageInfo.FlushMask;
  finally
    AImages.Free;
  end;
end;

procedure TcxIcon.HandleNeeded;
begin
  Handle;
end;

procedure TcxIcon.SetBitmap(ABitmap: TBitmap);
var
  AImageList: TcxImageList;
begin
  AImageList := TcxImageList.CreateSize(ABitmap.Width, ABitmap.Height);
  try
   AImageList.Add(ABitmap, nil);
   AImageList.GetIcon(0, Self, dsTransparent, itImage);
  finally
   AImageList.Free;
  end;
end;

{ TcxImageFileFormats }

class procedure TcxImageFileFormats.Finalize;
begin
  FreeAndNil(FInstance);
end;

class function TcxImageFileFormats.GetInstance: TcxImageFileFormats;
begin
  if FInstance = nil then
    FInstance := TcxImageFileFormats.Create;
  Result := FInstance;
end;

procedure TcxImageFileFormats.Register(const AName, AExt: string; AGraphicClass: TGraphicClass);
begin
  SetLength(FList, Count + 1);
  FList[Count - 1].Name := AName;
  FList[Count - 1].Ext := AExt;
  FList[Count - 1].GraphicClass := AGraphicClass;
end;

function TcxImageFileFormats.GetGraphicClass(const AFileName: string): TGraphicClass;
var
  AExt: string;
  I: Integer;
begin
  Result := nil;
  AExt := ExtractFileExt(AFileName);
  for I := 0 to Count - 1 do
    if SameText(AExt, Items[I].Ext) then
      Result := Items[I].GraphicClass;
end;

function TcxImageFileFormats.GetFilter: string;
var
  I: Integer;
  AAllExtentions, AAllImages: string;
begin
  AAllExtentions := '';
  AAllImages := '';
  for I := 0 to Count - 1 do
  begin
    if AAllExtentions = '' then
      AAllExtentions := '*' + Items[I].Ext
    else
      AAllExtentions := AAllExtentions + ';*' + Items[I].Ext;

    if AAllImages = '' then
      AAllImages := Items[I].Name + '|*' + Items[I].Ext
    else
      AAllImages := AAllImages + '|' + Items[I].Name + '|*' + Items[I].Ext;
  end;
  Result := 'All supported image types|' + AAllExtentions + '|' + AAllImages;
end;

function TcxImageFileFormats.Count: Integer;
begin
  Result := Length(FList);
end;

function TcxImageFileFormats.GetItem(Index: Integer): TcxImageFileFormat;
begin
  Result := FList[Index];
end;

{ TcxCustomImageListEditorForm }

constructor TcxCustomImageListEditorForm.Create(AImageListEditor: TcxImageListEditor);
begin
  inherited Create(nil);
  FImageListEditor := AImageListEditor;
  FImageListEditor.OnChange := DataChanged;
end;

procedure TcxCustomImageListEditorForm.DataChanged(Sender: TObject);
begin
  UpdateControls;
end;

procedure TcxCustomImageListEditorForm.RestorePosition;
begin
  // do nothing
end;

procedure TcxCustomImageListEditorForm.StorePosition;
begin
  // do nothing
end;

{ TcxImageListEditor }

constructor TcxImageListEditor.Create;
begin
  inherited Create;
  FImageList := TcxImageList.Create(nil);
  FEditorForm := GetEditorFormClass.Create(Self);
  FEditorForm.RestorePosition;
  FImportList := TStringList.Create;
  FVisibleImportList := TStringList.Create;
  FClipboardFormat := RegisterClipboardFormat('DXIL');

  FDataControl := FEditorForm.GetVisualDataControl;
  FDataControl.ImageOptions.SmallImages := ImageList;
  FDataControl.ImageOptions.LargeImages := ImageList;
  FDataControl.OnDeletion := DeleteDataItem;
  FDataControl.OnSelectItem := SelectDataItem;
end;

destructor TcxImageListEditor.Destroy;
begin
  ClearImages;
  FDataControl.OnSelectItem := nil;
  FDataControl.OnDeletion := nil;
  FDataControl := nil;
  FreeAndNil(FVisibleImportList);
  FreeAndNil(FImportList);
  FEditorForm.StorePosition;
  FreeAndNil(FEditorForm);
  FreeAndNil(FImageList);
  inherited;
end;

function TcxImageListEditor.Edit(AImageList: TcxImagelist): Boolean;
var
  ACaption: string;
begin
  ImageList := AImageList;
  ACaption := GetImageListEditorCaption(AImageList);
  FEditorForm.Caption := ACaption;
  FEditorForm.ShowModal;
  Result := FImageListModified;
end;

procedure TcxImageListEditor.ConvertTo32bit;
var
  I: Integer;
begin
  for I := 0 to DataItems.Count - 1 do
    TcxImageInfo(DataItems[I].Data).ConvertTo32Bit;
  ImageListChanged;
end;

procedure TcxImageListEditor.AddImages(AFiles: TStrings; AAddMode: TcxImageListEditorAddMode);
var
  AImageInfo: TcxImageInfo;
  AInsertIndex: Integer;
  I: Integer;
begin
  case AAddMode of
    amAdd:
      AInsertIndex := ImagesCount;
    amInsert:
      AInsertIndex := Max(0, FocusedImageIndex);
  else {amReplace}
    AInsertIndex := FirstSelectedImageIndex;
    DeleteSelectedImages;
  end;

  Adding;
  try
    AImageInfo := TcxImageInfo.Create;
    try
      for I := 0 to AFiles.Count - 1 do
      begin
        if GetImageInfoFromFile(AFiles[I], AImageInfo) then
          AddImage(AImageInfo, AInsertIndex, AFiles.Count > 1);
      end;
    finally
      AImageInfo.Free;
    end;
  finally
    Added(AInsertIndex);
  end;
end;

procedure TcxImageListEditor.ClearImages;
begin
  DataItems.Clear;
  UpdateImageList;
end;

procedure TcxImageListEditor.DeleteSelectedImages;
var
  ASelectedIndex: Integer;
  I: Integer;
begin
  ASelectedIndex := FocusedImageIndex;
  for I := ImagesCount - 1 downto 0 do
  begin
    if DataItems[I].Selected then
      DeleteImage(I);
  end;
  FocusedImageIndex := Min(ASelectedIndex, ImagesCount - 1);
end;

procedure TcxImageListEditor.ExportImages(const AFileName: string; AFormat: TcxImageType = itBMP);

  function CanReplace: Boolean;
  begin
    Result := dxMessageDlg(Format(sMsgReplaceConfirm, [AFileName]), mtWarning, [mbYes, mbNo], 0) = mrYes;
  end;

  procedure ExportBitmap(ABitmap: TBitmap);
  begin
    case AFormat of
      itBMP:
        ABitmap.SaveToFile(AFileName);

      itICO:
        with TcxIcon.CreateFromBitmap(ABitmap) do
        try
          SaveToFile(AFileName);
        finally
          Free;
        end;

      itPNG:
        with TdxPNGImage.CreateFromBitmap(ABitmap) do
        try
          SaveToFile(AFileName);
        finally
          Free;
        end;
    end;
  end;

var
  ABitmap: TcxBitmap32;
  APrevSelectedItem: TdxListItem;
begin
  if not FileExists(AFileName) or CanReplace then
  begin
    Application.ProcessMessages;
    APrevSelectedItem := DataControl.FocusedItem;
    try
      if not IsAnyImageSelected then
        SelectAll;

      ABitmap := ExportSelectedAsImage(IfThen(AFormat = itPNG, clNone, clFuchsia));
      try
        ExportBitmap(ABitmap);
      finally
        ABitmap.Free;
      end;
    finally
      DataControl.FocusedItem := APrevSelectedItem;
    end;
  end;
end;

procedure TcxImageListEditor.ImportImages(AImageList: TCustomImageList);
begin
  if AImageList.Count <> 0 then
  begin
    if (AImageList.ClassName = 'TPngImageList') and CheckGdiPlus then
      PngImageListTocxImageList(AImageList, ImageList)
    else
      ImageList.CopyImages(AImageList);

    SynchronizeData(ImagesCount, AImageList.Count);
    FChanged := True;
    FocusedImageIndex := ImagesCount - 1;
  end;
  Change;
end;

procedure TcxImageListEditor.MoveImage(ASourceImageIndex, ADestImageIndex: Integer);
var
  AList: TList;
  I: Integer;
begin
  if ADestImageIndex <> ASourceImageIndex then
  begin
    AList := TList.Create;
    try
      for I := 0 to ImagesCount - 1 do
        AList.Add(DataItems[I].Data);
      AList.Move(ASourceImageIndex, ADestImageIndex);
      for I := 0 to ImagesCount - 1 do
        DataItems[I].Data := AList[I];
    finally
      AList.Free;
    end;
    FocusedImageIndex := ADestImageIndex;
  end;
  UpdateImageList;
end;

function TcxImageListEditor.CanCopyToClipboard: Boolean;
begin
  Result := IsAnyImageSelected;
end;

function TcxImageListEditor.CanPasteFromClipboard: Boolean;
begin
  Result := TdxSmartImage.HasClipboardFormat;
end;

procedure TcxImageListEditor.CutToClipboard;
begin
  CopyToClipboard;
  DeleteSelectedImages;
end;

procedure TcxImageListEditor.CopyToClipboard;
var
  ABitmap: TcxBitmap32;
  APngImage: TdxPNGImage;
  AStream: TMemoryStream;
begin
  if CanCopyToClipboard then
  begin
    Clipboard.Open;
    try
      Clipboard.Clear;

      // copy as image (bmp + png)
      ABitmap := ExportSelectedAsImage(clNone);
      try
        APngImage := TdxPNGImage.CreateFromBitmap(ABitmap);
        try
          APngImage.CopyToClipboard;
        finally
          APngImage.Free;
        end;
      finally
        ABitmap.Free;
      end;

      // copy in native file format
      AStream := ExportSelectedAsStream;
      try
        SetClipboardData(FClipboardFormat, dxStreamToHGlobal(AStream));
      finally
        AStream.Free;
      end;
    finally
      Clipboard.Close;
    end;
  end;
end;

procedure TcxImageListEditor.PasteFromClipboard;
var
  AImage: TdxSmartImage;
  AInsertIndex: Integer;
  AStream: TStream;
begin
  if CanPasteFromClipboard then
  begin
    AInsertIndex := FirstSelectedImageIndex;
    if AInsertIndex >= 0 then
      DeleteSelectedImages
    else
      AInsertIndex := ImagesCount;

    Adding;
    try
      Clipboard.Open;
      try
        if Clipboard.HasFormat(FClipboardFormat) then
        begin
          AStream := TdxHGlobalReadOnlyStream.Create(Clipboard.GetAsHandle(FClipboardFormat));
          try
            AddImagesFromStream(AStream, AInsertIndex);
          finally
            AStream.Free;
          end;
        end
        else
        begin
          AImage := TdxSmartImage.Create;
          try
            AImage.PasteFromClipboard;
            if not AImage.Empty then
              AddImage(AImage, nil, clDefault, AInsertIndex, 'Clipboard.png', '', False);
          finally
            AImage.Free;
          end;
        end;
      finally
        Clipboard.Close;
      end;
    finally
      Added(AInsertIndex);
    end;
  end;
end;

procedure TcxImageListEditor.ClearSelection;
var
  I: Integer;
begin
  for I := 0 to ImagesCount - 1 do
    DataItems[I].Selected := False;
end;

function TcxImageListEditor.GetSelectionCount: Integer;
begin
  Result := DataControl.SelectedItemCount;
end;

function TcxImageListEditor.IsAnyImageSelected: Boolean;
begin
  Result := (FocusedImageIndex <> -1) and (GetSelectionCount > 0);
end;

function TcxImageListEditor.IsSingleImageSelected: Boolean;
begin
  Result := (FocusedImageIndex <> -1) and (GetSelectionCount = 1);
end;

function TcxImageListEditor.IsVectorImageSelected: Boolean;
begin
  Result := IsSingleImageSelected and Supports(FocusedImageInfo.Image, IdxVectorImage);
end;

procedure TcxImageListEditor.SelectAll;
var
  I: Integer;
begin
  for I := 0 to ImagesCount - 1 do
    DataItems[I].Selected := True;
end;

procedure TcxImageListEditor.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TcxImageListEditor.EndUpdate;
begin
  Dec(FUpdateCount);
end;

function TcxImageListEditor.IsUpdateLocked: Boolean;
begin
  Result := FUpdateCount > 0;
end;

procedure TcxImageListEditor.ApplyChanges;
begin
  if IsChanged then
  begin
    FOriginalImageList.Width := ImageWidth;
    FOriginalImageList.Height := ImageHeight;
    AddDataItems(FOriginalImageList);
    FImageListModified := True;
    FChanged := False;
  end;
  Change;
end;

function TcxImageListEditor.IsChanged: Boolean;
begin
  Result := FChanged;
end;

procedure TcxImageListEditor.UpdateTransparentColor(AColor: TColor);
var
  I: Integer;
begin
  AColor := ColorToRGB(AColor);
  for I := 0 to ImagesCount - 1 do
    if DataItems[I].Selected and (ImagesInfo[I].MaskColor <> AColor) then
    begin
      ImagesInfo[I].MaskColor := AColor;
      UpdateImageList;
    end;
end;

function TcxImageListEditor.ChangeImagesSize(const AValue: TSize): Boolean;
begin
  Result := False;
  if (ImageWidth <> AValue.cx) or (ImageHeight <> AValue.cy) then
  begin
    if not TcxImageListAccess(ImageList).HasRasterImages or ShowRasterImagesResizeConfirmation then
    begin
      DataItems.Clear;
      ImageList.Resize(AValue);
      SynchronizeData(0, ImageList.Count);
      UpdateVisibleImportList;
      ImageListChanged;
      Result := True;
    end;
  end;
end;

procedure TcxImageListEditor.SynchronizeData(AStartIndex, ACount: Integer);
var
  AImageInfo: TcxImageInfo;
  I: Integer;
begin
  for I := AStartIndex to AStartIndex + ACount - 1 do
  begin
    AImageInfo := TcxImageInfo.Create;
    AImageInfo.Assign(TcxImageListAccess(ImageList).GetImageInfo(I));
    DataItems.Add.Data := AImageInfo;
  end;
  UpdateImageList;
end;

function TcxImageListEditor.GetEditorFormClass: TcxCustomImageListEditorFormClass;
begin
  Result := TcxImageListEditorForm;
end;

function TcxImageListEditor.GetImageCaption(AIndex: Integer): string;
begin
  Result := IntToStr(AIndex);
end;

function TcxImageListEditor.GetImageInfoFromFile(const AFileName: string; AImageInfo: TcxImageInfo): Boolean;
var
  ACollection: IdxImageCollection;
  AGraphic: TGraphic;
  AGraphicClass: TGraphicClass;
begin
  AImageInfo.Reset;

  if Supports(dxIconLibraryIntf, IdxImageCollection, ACollection) then
  begin
    if ACollection.GetImageInfo(AFileName, AImageInfo) then
      Exit(True);
  end;

  AGraphicClass := cxImageFileFormats.GetGraphicClass(AFileName);
  Result := AGraphicClass <> nil;
  if Result then
  begin
    AGraphic := AGraphicClass.Create;
    try
      AGraphic.LoadFromFile(AFileName);
      if AGraphic is TcxIcon then
      begin
        AGraphic.SetSize(ImageWidth, ImageHeight);
        TcxIcon(AGraphic).GetImageInfo(AImageInfo);
      end
      else
      begin
        AImageInfo.Image := AGraphic;
        AImageInfo.MaskColor := clDefault;
      end;
    finally
      AGraphic.Free;
    end;
  end;
end;

function TcxImageListEditor.GetImageListEditorCaption(AImageList: TcxImageList): string;
begin
  Result := AImageList.Name;
  if AImageList.Owner <> nil then
    Result := AImageList.Owner.Name + '.' + Result;
end;

function TcxImageListEditor.ShowRasterImagesResizeConfirmation: Boolean;
begin
  Result := dxMessageDlg(sMsgChangeImagesSizeConfirm, mtWarning, [mbYes, mbNo], 0) = mrYes;
end;

procedure TcxImageListEditor.AddDataItems(AImageList: TcxImagelist);
var
  I: Integer;
begin
  AImageList.BeginUpdate;
  try
    AImageList.Clear;
    for I := 0 to ImagesCount - 1 do
      TcxImageListAccess(AImageList).AddImageInfo(ImagesInfo[I]);
  finally
    AImageList.EndUpdate;
  end;
end;

procedure TcxImageListEditor.AddImage(AImageInfo: TcxImageInfo; var AInsertIndex: Integer; AMultiSelect: Boolean);
begin
  AddImage(AImageInfo.Image, AImageInfo.Mask, AImageInfo.MaskColor,
    AInsertIndex, AImageInfo.FileName, AImageInfo.Keywords, AMultiSelect);
end;

procedure TcxImageListEditor.AddImage(AImage: TGraphic; AMask: TBitmap; AMaskColor: TColor;
  var AInsertIndex: Integer; const AFileName, AKeywords: string; AMultiSelect: Boolean);

  function CanSplitImage(AImage: TGraphic): Boolean;
  begin
    Result := TcxImageListAccess(ImageList).CanSplitImage(AImage);
  end;

  function CheckIsSplitMode: Boolean;
  var
    AButtons: TMsgDlgButtons;
  begin
    Result := False;
    if CanSplitImage(AImage) then
    begin
      if FSplitImages = bDefault then
      begin
        AButtons := [mbYes, mbNo, mbCancel];
        if AMultiSelect then
          AButtons := AButtons + [mbYesToAll, mbNoToAll];

        case dxMessageDlg(Format(sMsgSplitConfirm, [AFileName]), mtConfirmation, AButtons, 0) of
          mrCancel:
            Abort;
          mrNoToAll:
            FSplitImages := bFalse;
          mrYesToAll:
            FSplitImages := bTrue;
          mrYes:
            Exit(True);
        end;
      end;
      Result := FSplitImages = bTrue;
    end;
  end;

  function GetActualMaskColor(AImage: TGraphic; AMask: TBitmap): TColor;
  begin
    Result := AMaskColor;
    if Result = clDefault then
      Result := TcxImageInfoHelper.GetDefaultTransparentColor(AImage, AMask);
  end;

var
  AColCount: Integer;
  AColIndex: Integer;
  ADestBitmap: TcxBitmap;
  ADestMask: TcxBitmap;
  ADestRect: TRect;
  ARowCount: Integer;
  ARowIndex: Integer;
  ASourceImageSize: TSize;
  ASourceRect: TRect;
begin
  if Supports(AImage, IdxVectorImage) and not CanSplitImage(AImage) then
  begin
    AddImageCore(AImage, AMask, clNone, AInsertIndex, AFileName, AKeywords);
    Exit;
  end;

  if (ImageWidth = AImage.Width) and (ImageHeight = AImage.Height) and not IsGlyphAssigned(AMask) then
  begin
    AddImageCore(AImage, AMask, GetActualMaskColor(AImage, AMask), AInsertIndex, AFileName, AKeywords);
    Exit;
  end;

  if CheckIsSplitMode then
    ASourceImageSize := cxSize(ImageWidth, ImageHeight)
  else
    ASourceImageSize := cxSize(AImage.Width, AImage.Height);

  AColCount := AImage.Width div ASourceImageSize.cx;
  ARowCount := AImage.Height div ASourceImageSize.cy;

  if IsGlyphAssigned(AMask) then
    ADestMask := TcxBitmap.CreateSize(ImageWidth, ImageHeight, pf1bit)
  else
    ADestMask := nil;

  ADestBitmap := TcxBitmap.CreateSize(ImageWidth, ImageHeight, pf32bit);
  try
    ADestRect := cxRectCenter(ADestBitmap.ClientRect, Min(ImageWidth, ASourceImageSize.cx), Min(ImageHeight, ASourceImageSize.cy));
    for ARowIndex := 0 to ARowCount - 1 do
      for AColIndex := 0 to AColCount - 1 do
      begin
        ADestBitmap.Canvas.Brush.Color := TcxImageInfoHelper.GetDefaultTransparentColor(AImage, AMask);
        ADestBitmap.Canvas.FillRect(ADestBitmap.ClientRect);

        ASourceRect := cxRectBounds(AColIndex * ASourceImageSize.cx, ARowIndex * ASourceImageSize.cy, ASourceImageSize);
        TcxImageInfoHelper.CopyRect(ADestBitmap, ADestRect, AImage, ASourceRect);
        if ADestMask <> nil then
          TcxImageInfoHelper.CopyRect(ADestMask, ADestRect, AMask, ASourceRect);

        AddImageCore(ADestBitmap, ADestMask, GetActualMaskColor(ADestBitmap, ADestMask), AInsertIndex, AFileName, AKeywords);
      end;
  finally
    ADestBitmap.Free;
    ADestMask.Free;
  end;
end;

procedure TcxImageListEditor.AddImageCore(AImage: TGraphic; AMask: TBitmap;
  AMaskColor: TColor; var AInsertIndex: Integer; const AFileName, AKeywords: string);
var
  AImageInfo: TcxImageInfo;
begin
  AImageInfo := TcxImageInfo.Create;
  AImageInfo.Image := AImage;
  AImageInfo.Mask := AMask;
  AImageInfo.MaskColor := AMaskColor;
  AImageInfo.FileName := AFileName;
  AImageInfo.Keywords := AKeywords;
  DataItems.Add.Data := AImageInfo;
  MoveImage(ImagesCount - 1, AInsertIndex);
  Inc(AInsertIndex);
end;

procedure TcxImageListEditor.AddImagesFromStream(AStream: TStream; var AInsertIndex: Integer);
var
  AImageInfo: TcxImageInfo;
  AReader: TReaderAccess;
  ACount: Integer;
begin
  ACount := ReadIntegerFunc(AStream);
  AReader := TReaderAccess.Create(AStream, 4096);
  try
    AImageInfo := TcxImageInfo.Create;
    try
      while ACount > 0 do
      begin
        AImageInfo.FlushMask;

        AReader.ReadListBegin;
        while not AReader.EndOfList do
          AReader.ReadProperty(AImageInfo);
        AReader.ReadListEnd;

        AddImage(AImageInfo, AInsertIndex, ACount > 1);
        Dec(ACount);
      end;
    finally
      AImageInfo.Free;
    end;
  finally
    AReader.Free;
  end;
end;

procedure TcxImageListEditor.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TcxImageListEditor.DeleteDataItem(Sender: TdxCustomListView; AItem: TdxListItem);
begin
  TObject(AItem.Data).Free;
end;

procedure TcxImageListEditor.DeleteImage(AIndex: Integer);
begin
  if IsIndexValid(AIndex) then
  begin
    DataItems.Delete(AIndex);
    UpdateImageList;
  end;
end;

function TcxImageListEditor.ExportSelectedAsImage(ABackgroundColor: TColor): TcxBitmap32;
var
  AImageIndex: Integer;
  ARect: TRect;
begin
  Result := TcxBitmap32.CreateSize(ImageList.Width * GetSelectionCount, ImageList.Height, True);
  if cxColorIsValid(ABackgroundColor) then
    Result.cxCanvas.FillRect(Result.ClientRect, ABackgroundColor);

  ARect := cxRect(0, 0, ImageList.Width, ImageList.Height);
  for AImageIndex := 0 to ImagesCount - 1 do
    if DataItems[AImageIndex].Selected then
    begin
      TcxImageInfoHelper.CopyRect(Result, ARect, ImagesInfo[AImageIndex].Image);
      ARect := cxRectOffset(ARect, ImageList.Width, 0);
    end;
end;

function TcxImageListEditor.ExportSelectedAsStream: TMemoryStream;
var
  AImageIndex: Integer;
  AWriter: TWriterAccess;
begin
  Result := TMemoryStream.Create;
  WriteIntegerProc(Result, GetSelectionCount);

  AWriter := TWriterAccess.Create(Result, 4096);
  try
    for AImageIndex := 0 to ImagesCount - 1 do
    begin
      if DataItems[AImageIndex].Selected then
      begin
        AWriter.WriteListBegin;
        AWriter.WriteProperties(ImagesInfo[AImageIndex]);
        AWriter.WriteListEnd;
      end;
    end;
  finally
    AWriter.Free;
  end;
end;

function TcxImageListEditor.FirstSelectedImageIndex: Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to ImagesCount - 1 do
  begin
    if DataItems[I].Selected then
      Exit(DataItems[I].ImageIndex);
  end;
end;

function TcxImageListEditor.GetImagesCount: Integer;
begin
  Result := DataItems.Count;
end;

function TcxImageListEditor.GetFocusedImageIndex: Integer;
begin
  Result := -1;
  if DataControl.FocusedItem <> nil then
    Result := DataControl.FocusedItem.Index;
end;

function TcxImageListEditor.GetFocusedImageInfo: TcxImageInfo;
begin
  Result := ImagesInfo[FocusedImageIndex];
end;

function TcxImageListEditor.GetImageHeight: Integer;
begin
  Result := ImageList.Height;
end;

function TcxImageListEditor.GetImagesInfo(Index: Integer): TcxImageInfo;
begin
  if IsIndexValid(Index) then
    Result := TcxImageInfo(DataItems[Index].Data)
  else
    Result := nil;
end;

procedure TcxImageListEditor.SetImageList(AValue: TcxImageList);
begin
  FOriginalImageList := AValue;
  ImageList.Assign(AValue);
  SynchronizeData(0, ImageList.Count);
  FChanged := False;
  FocusedImageIndex := 0;
  UpdateVisibleImportList;
end;

function TcxImageListEditor.GetImageWidth: Integer;
begin
  Result := ImageList.Width;
end;

function TcxImageListEditor.IsIndexValid(AIndex: Integer): Boolean;
begin
  Result := (AIndex >= 0) and (AIndex < ImagesCount);
end;

procedure TcxImageListEditor.ImageListChanged;
begin
  UpdateListViewItems;
  FChanged := True;
  Change;
end;

procedure TcxImageListEditor.SelectDataItem(Sender: TdxCustomListView; AItem: TdxListItem; ASelected: Boolean);
begin
  if ASelected then
    DataControl.FocusedItem := AItem;
end;

function TcxImageListEditor.GetDataItems: TdxListItems;
begin
  Result := DataControl.Items;
end;

procedure TcxImageListEditor.SetFocusedImageIndex(AValue: Integer);
begin
  if IsIndexValid(AValue) then
  begin
    ClearSelection;
    DataItems[AValue].Selected := True;
    DataControl.FocusedItem.MakeVisible(True);
  end;
end;

procedure TcxImageListEditor.SetImagesInfo(Index: Integer; AValue: TcxImageInfo);
begin
  if DataItems[Index].Data <> AValue then
    DataItems[Index].Data := AValue;
end;

procedure TcxImageListEditor.SetImportList(AValue: TStrings);
begin
  if AValue <> nil then
    FImportList.Assign(AValue)
  else
    FImportList.Clear;
end;

procedure TcxImageListEditor.SetShowImageTypes(const Value: Boolean);
begin
  if FShowImageTypes <> Value then
  begin
    FShowImageTypes := Value;
    UpdateListViewItems;
  end;
end;

procedure TcxImageListEditor.Adding;
begin
  BeginUpdate;
  ClearSelection;
  Application.ProcessMessages;
  FSplitImages := bDefault;
end;

procedure TcxImageListEditor.Added(AInsertIndex: Integer);
begin
  FocusedImageIndex := AInsertIndex - 1;
  EndUpdate;
  FEditorForm.UpdateControls;
end;

procedure TcxImageListEditor.UpdateImageList;

  procedure MakeSystemBackground(ASource, ADestination: TBitmap);
  var
    R: TRect;
  begin
    R := Rect(0, 0, ADestination.Width, ADestination.Height);
    ADestination.Canvas.Brush.Color := clWindow;
    ADestination.Canvas.FillRect(R);
    cxAlphaBlend(ADestination, ASource, R, R);
  end;

var
  I: Integer;
  AImageInfo: TcxImageInfo;
  AEditorImageInfo: TcxImageInfo;
begin
  ImageList.BeginUpdate;
  try
    ImageList.Clear;
    AImageInfo := TcxImageInfo.Create;
    try
      for I := 0 to ImagesCount - 1 do
      begin
        AEditorImageInfo := ImagesInfo[I];
        if not IsXPManifestEnabled and (AEditorImageInfo.Image is TBitmap) and AEditorImageInfo.IsAlphaUsed then
        begin
          AImageInfo.Assign(AEditorImageInfo);
          MakeSystemBackground(AEditorImageInfo.Image as TBitmap, AImageInfo.Image as TBitmap);
          TcxImageListAccess(ImageList).AddImageInfo(AImageInfo);
        end
        else
          TcxImageListAccess(ImageList).AddImageInfo(AEditorImageInfo);
      end;
    finally
      AImageInfo.Free;
    end;
  finally
    ImageList.EndUpdate;
  end;
  ImageListChanged;
end;

procedure TcxImageListEditor.UpdateListViewItems;

  function GetCaption(AIndex: Integer): string;
  begin
    Result := GetImageCaption(AIndex);
    if ShowImageTypes then
      Result := Result + dxCRLF + ImagesInfo[AIndex].ImageType;
  end;

var
  AIndex: Integer;
  AItem: TdxListItem;
begin
  for AIndex := 0 to ImagesCount - 1 do
  begin
    AItem := DataItems[AIndex];
    AItem.Caption := GetCaption(AIndex);
    AItem.ImageIndex := AIndex;
  end;
end;

procedure TcxImageListEditor.UpdateVisibleImportList;
var
  I: Integer;
  ACustomImageList: TCustomImageList;
begin
  FVisibleImportList.Clear;
  for I := 0 to FImportList.Count - 1 do
  begin
    ACustomImageList := TCustomImageList(FImportList.Objects[I]);
    if (ACustomImageList.Width = ImageWidth) and (ACustomImageList.Height = ImageHeight) and (ACustomImageList.Count > 0) then
      FVisibleImportList.AddObject(FImportList[I], FImportList.Objects[I]);
  end;
  FEditorForm.SetImportList(FVisibleImportList);
  Change;
end;

{ TdxMultiPartGlyphEditor }

procedure TdxMultiPartGlyphEditor.ApplyChanges;
begin
  inherited;
  FMultiPartGlyphSupport.GlyphCount := ImageList.Count;
  CombineGlyphs;
end;

function TdxMultiPartGlyphEditor.Edit(AGlyph: TdxSmartGlyph; AMultiPartGlyphSupport: IdxMultiPartGlyphSupport): Boolean;
var
  AImageList: TcxImageList;
begin
  FGlyph := AGlyph;
  FMultiPartGlyphSupport := AMultiPartGlyphSupport;
  AImageList := TcxImageList.Create(nil);
  try
    PopulateImageList(AImageList);
    Result := inherited Edit(AImageList);
  finally
    AImageList.Free;
  end;
end;

function TdxMultiPartGlyphEditor.GetImageCaption(AIndex: Integer): string;
begin
  Result := FMultiPartGlyphSupport.GetStateCaption(AIndex);
end;

function TdxMultiPartGlyphEditor.GetImageListEditorCaption(AImageList: TcxImageList): string;
begin
  Result := 'Glyph Editor';
end;

procedure TdxMultiPartGlyphEditor.CombineGlyphs;

  procedure CombineToBitmap;
  var
    I: Integer;
    ABitmap: TcxBitmap32;
    ARect: TRect;
    ASmartGlyph: TdxSmartImage;
    AStream: TStream;
  begin
    ABitmap := TcxBitmap32.CreateSize(ImageList.Width * ImageList.Count, ImageList.Height);
    try
      ABitmap.Clear;
      ARect := Rect(0, 0, ImageList.Width, ImageList.Height);
      for I := 0 to ImageList.Count - 1 do
      begin
        TdxImageDrawer.DrawImage(ABitmap.cxCanvas, ARect, nil, ImageList, I, True);
        ARect := cxRectOffsetHorz(ARect, ImageList.Width);
      end;
      ASmartGlyph := TdxSmartImage.CreateFromBitmap(ABitmap);
      try
        AStream := TMemoryStream.Create;
        try
          ASmartGlyph.SaveToStreamByCodec(AStream, dxImagePng);
          AStream.Position := 0;
          FGlyph.LoadFromStream(AStream);
        finally
          AStream.Free;
        end;
      finally
        ASmartGlyph.Free;
      end;
    finally
      ABitmap.Free;
    end;
    FGlyph.SourceWidth := 0;
    FGlyph.SourceHeight := 0;
  end;

  procedure CombineToVector;
  var
    I: Integer;
    AList: TList<TdxSVGImageHandle>;
  begin
    AList := TList<TdxSVGImageHandle>.Create;
    try
      AList.Capacity := ImageList.Count;
      for I := 0 to ImageList.Count - 1 do
        AList.Add(TdxCustomSmartImageAccess(ImagesInfo[I].Image).Handle as TdxSVGImageHandle);

      TdxCustomSmartImageAccess(FGlyph).Handle := TdxSVGEditingHelper.Combine(AList);
    finally
      AList.Free;
    end;
    FGlyph.SourceWidth := ImageList.Width * ImageList.Count;
    FGlyph.SourceHeight := ImageList.Height;
  end;

  function IsVectorGlyphs: Boolean;
  var
    I: Integer;
  begin
    Result := True;
    for I := 0 to ImageList.Count - 1 do
      if not (ImagesInfo[I].Image is TdxCustomSmartImage) or (TdxSmartImage(ImagesInfo[I].Image).ImageCodec <> TdxSVGImageCodec) then
      begin
        Result := False;
        Break;
      end;
  end;

begin
  if IsVectorGlyphs then
    CombineToVector
  else
    CombineToBitmap;
end;

procedure TdxMultiPartGlyphEditor.PopulateImageList(AImageList: TcxImageList);

  procedure PopulateFromBitmap;
  begin
    AImageList.SetSize(FGlyph.SourceWidth div Max(1, FMultiPartGlyphSupport.GlyphCount), FGlyph.SourceHeight);
    AImageList.Add(FGlyph);
  end;

  procedure PopulateFromVector;
  var
    AImage: TdxSmartImage;
    AList: TList<TdxSVGImageHandle>;
    I: Integer;
  begin
    if TdxSVGEditingHelper.Split(FGlyph, AList) then
    try
      AImage := TdxSmartImage.Create;
      try
        AImageList.SetSize(FGlyph.SourceWidth div Max(1, AList.Count), FGlyph.SourceHeight);
        for I := 0 to AList.Count - 1 do
        begin
          TdxCustomSmartImageAccess(AImage).Handle := AList[I];
          AImageList.Add(AImage);
        end;
      finally
        AImage.Free;
      end;
    finally
      AList.Free;
    end
    else
    begin
      AImageList.SetSize(FGlyph.SourceWidth, FGlyph.SourceHeight);
      AImageList.Add(FGlyph);
    end;
  end;

begin
  if not FGlyph.Empty then
  begin
    if Supports(FGlyph, IdxVectorImage) then
      PopulateFromVector
    else
      PopulateFromBitmap;
  end;
end;

procedure RegisterAssistants;
begin
  cxImageFileFormats.Register('Bitmaps (*.bmp)', '.bmp', TBitmap);
  cxImageFileFormats.Register('Icons (*.ico)', '.ico', TcxIcon);
  if CheckGdiPlus then
  begin
    if GetClass(TdxPNGImage.ClassName) <> nil then
      cxImageFileFormats.Register('DevExpress PNG (*.png)', '.png', TdxPNGImage);
    if TdxSmartImageCodecsRepository.Contains(TdxSVGImageCodec) then
      cxImageFileFormats.Register('DevExpress SVG (*.svg)', '.svg', TdxSmartImage);
  end;
end;

procedure UnregisterAssistants;
begin
  TcxImageFileFormats.Finalize;
end;


initialization

  dxUnitsLoader.AddUnit(SysInit.HInstance, dxThisUnitName, RegisterAssistants, UnregisterAssistants);

finalization

  dxUnitsLoader.RemoveUnit(SysInit.HInstance, dxThisUnitName, UnregisterAssistants);

end.
