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

unit dxIconLibrary;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHIXE8}
  System.Hash,
{$ENDIF}
  Classes, Windows, SysUtils, Controls, Generics.Defaults, Generics.Collections, StrUtils, RTTI, Registry, Contnrs, IOUtils,
  cxClasses, dxCore, cxGraphics, dxSmartImage, cxGeometry, dxGDIPlusClasses, dxHash, dxHashUtils, dxThreading;

const
  sdxIconLibraryCollections = 'Collections';
  sdxIconLibraryCollectionsVector = 'CollectionsVector';
  sdxIconLibraryCategories = 'Categories';
  sdxIconLibraryCategoriesVector = 'CategoriesVector';
  sdxIconLibrarySizes = 'Sizes';

type
  TdxIconLibraryEnumFilesProc = reference to procedure (const AFileName: string);

type
  TdxIconLibrary = class;

  TFileObjectType = (fotFile, fotDirectory);

  { TdxIconLibraryCustomObject }

  TdxIconLibraryCustomObjectClass = class of TdxIconLibraryCustomObject;
  TdxIconLibraryCustomObject = class
  strict private
    FDisplayName: string;
    FName: string;
  private
    FParent: TdxIconLibraryCustomObject;
  protected
    procedure DoBeforeRemove(AObject: TdxIconLibraryCustomObject); virtual;
  public
    constructor Create(const AName: string; AParent: TdxIconLibraryCustomObject); virtual;
    procedure BeforeDestruction; override;
    procedure Refresh; virtual; abstract;

    property DisplayName: string read FDisplayName write FDisplayName;
    property Name: string read FName;
    property Parent: TdxIconLibraryCustomObject read FParent;
  end;

  { TdxIconLibraryCollection }

  TdxIconLibraryCollection = class(TdxIconLibraryCustomObject)
  strict private
    function GetCount: Integer;
    function GetItem(AIndex: Integer): TdxIconLibraryCustomObject; inline;
  protected
    FItemClass: TdxIconLibraryCustomObjectClass;
    FItems: TcxObjectList;

    procedure EnumFiles(AProc: TdxIconLibraryEnumFilesProc); virtual; abstract;
  public
    constructor Create(const AName: string; AParent: TdxIconLibraryCustomObject); override;
    destructor Destroy; override;
    procedure BeforeDestruction; override;
    function Add(const AName: string): TdxIconLibraryCustomObject;
    function Find(const AName: string; var AIndex: Integer): Boolean;
    procedure Refresh; override;
    procedure Remove(AItem: TdxIconLibraryCustomObject);

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TdxIconLibraryCustomObject read GetItem; default;
  end;

  { TdxIconLibraryImage }

  TdxIconLibraryImage = class(TdxIconLibraryCustomObject)
  strict private
    FImage: TdxSmartGlyph;
    FImageSize: TSize;
    FImageSizeAssigned: Boolean;
    FImageSizeAsString: string;
    FTag: TcxTag;

    function FetchImageSizeFromFileName(out ASize: TSize): Boolean;
    procedure ImageSizeNeeded; inline;
    function GetCategoryName: string;
    function GetCollectionName: string;
    function GetFileName: string; inline;
    function GetImageSize: TSize; inline;
    function GetImageSizeAsString: string; inline;
  public
    constructor Create(const AName: string; AParent: TdxIconLibraryCustomObject); override;
    destructor Destroy; override;
    procedure LoadFromFile;
    procedure Refresh; override;

    property CollectionName: string read GetCollectionName;
    property FileName: string read GetFileName;
    property CategoryName: string read GetCategoryName;
    property Image: TdxSmartGlyph read FImage;
    property ImageSize: TSize read GetImageSize;
    property ImageSizeAsString: string read GetImageSizeAsString;
    property Tag: TcxTag read FTag write FTag;
  end;

  { TdxIconLibraryCategory }

  TdxIconLibraryCategory = class(TdxIconLibraryCollection)
  strict private
    function GetItem(AIndex: Integer): TdxIconLibraryImage; inline;
  private
    function GetIsEmpty: Boolean;
  protected
    procedure EnumFiles(AProc: TdxIconLibraryEnumFilesProc); override;
  public
    constructor Create(const AName: string; AParent: TdxIconLibraryCustomObject); override;

    property IsEmpty: Boolean read GetIsEmpty;
    property Items[Index: Integer]: TdxIconLibraryImage read GetItem; default;
  end;

  { TdxIconLibrarySet }

  TdxIconLibrarySet = class(TdxIconLibraryCollection)
  strict private
    function GetItem(AIndex: Integer): TdxIconLibraryCategory; inline;
  private
    function GetIsEmpty: Boolean;
  protected
    procedure EnumFiles(AProc: TdxIconLibraryEnumFilesProc); override;
  public
    constructor Create(const AName: string; AParent: TdxIconLibraryCustomObject); override;

    property IsEmpty: Boolean read GetIsEmpty;
    property Items[Index: Integer]: TdxIconLibraryCategory read GetItem; default;
  end;

  { IdxIconLibraryListener }

  IdxIconLibraryListener = interface
  ['{738906C8-47A7-4002-9FBE-34BA00419D4E}']
    procedure OnChanged(Sender: TdxIconLibraryCollection);
    procedure OnChanging(Sender: TdxIconLibraryCollection);
    procedure OnRemoving(Sender: TdxIconLibraryCustomObject);
  end;

  { TdxIconLibraryListeners }

  TdxIconLibraryListeners = class(TList<IdxIconLibraryListener>)
  protected
    procedure NotifyChanging(Sender: TdxIconLibraryCollection);
    procedure NotifyChanged(Sender: TdxIconLibraryCollection);
    procedure NotifyRemoving(Sender: TdxIconLibraryCustomObject);
  end;

  { TdxIconLibraryFileName }

  TdxIconLibraryFileName = class
  public const
    SizeSeparator = '_';
  protected
    class function ParseName(const AName: string; out ASize: string): string;
  public
    class function Build(const ACollection, ACategory, AName: string;
      AWidth: Integer = 0; AHeight: Integer = 0; ARelative: Boolean = False): string;
    class function Parse(AFileName: string; out ACollection, ACategory, AName: string): Boolean; overload;
    class function Parse(AFileName: string; out ACollection, ACategory, AName, ADisplayName, ASize: string): Boolean; overload;
    class function ToAbsolute(const AFileName: string): string;
    class function ToRelative(const AFileName: string): string;
  end;

  { TdxIconLibrary }

  TdxIconLibrary = class(TdxIconLibraryCollection)
  public const
    SizeVector = 'Vector';
  strict private
    FFileSystemMonitors: TObjectList;
    FListeners: TdxIconLibraryListeners;
    FPaths: TStringList;

    procedure FileSystemChangeHandler(Sender: TObject);
    function GetItem(AIndex: Integer): TdxIconLibrarySet; inline;
    function GetItemByName(const AName: string): TdxIconLibrarySet;
  protected
    procedure DoBeforeRemove(AObject: TdxIconLibraryCustomObject); override;
    procedure EnumFiles(AProc: TdxIconLibraryEnumFilesProc); override;
  public
    constructor Create(const APath: string); reintroduce;
    destructor Destroy; override;
    procedure Refresh; override;
    function AddUserCollection(const AName, APath: string): TdxIconLibrarySet;
    procedure RemoveUserCollection(const AName: string);
    function IsUserCollection(const AName: string): Boolean;
    property Listeners: TdxIconLibraryListeners read FListeners;
    property Items[Index: Integer]: TdxIconLibrarySet read GetItem; default;
  end;


function dxGetIconLibraryPath: string;

procedure FillUsersIconLibraryPaths(AList: TStringList);
procedure RegisterUserIconLibraryCollection(const AName, APath: string);
procedure UnregisterUserIconLibraryCollection(const AName: string);
procedure SaveIconLibrarySettings(const AName, AValue: string);
function ReadIconLibrarySettings(const AName: string): TValue;

implementation

uses
  Types, dxSVGImage, dxStringHelper;

const
  dxThisUnitName = 'dxIconLibrary';

const
  dxIconLibraryRelativePath = '\ExpressLibrary\Sources\Icon Library\';
  sdxIconLibraryCollectionsRegistry = 'Software\Developer Express\IconLibrary';

var
  FActualIconLibraryPath: string = '';
  FImageExtensions: TStringList;

procedure RegisterUserIconLibraryCollection(const AName, APath: string);
var
  ARegistry: TRegistry;
begin
  ARegistry := TRegistry.Create;
  try
    ARegistry.RootKey := HKEY_CURRENT_USER;
    if ARegistry.OpenKey(sdxIconLibraryCollectionsRegistry + '\Collections', True) then
      ARegistry.WriteString(AName, APath);
  finally
    ARegistry.Free;
  end;
end;

procedure UnregisterUserIconLibraryCollection(const AName: string);
var
  ARegistry: TRegistry;
begin
  ARegistry := TRegistry.Create;
  try
    ARegistry.RootKey := HKEY_CURRENT_USER;
    if ARegistry.OpenKey(sdxIconLibraryCollectionsRegistry + '\Collections', False) then
    begin
      if ARegistry.ValueExists(AName) then
        ARegistry.DeleteValue(AName);
    end;
  finally
    ARegistry.Free;
  end;
end;

procedure FillUsersIconLibraryPaths(AList: TStringList);
var
  ARegistry: TRegistry;
  AValueNames: TStringList;
  I: Integer;
begin
  ARegistry := TRegistry.Create;
  AValueNames := TStringList.Create;
  try
    ARegistry.RootKey := HKEY_CURRENT_USER;
    if ARegistry.OpenKeyReadOnly(sdxIconLibraryCollectionsRegistry + '\Collections') then
    begin
      ARegistry.GetValueNames(AValueNames);
      for I := 0 to AValueNames.Count - 1 do
        AList.Values[AValueNames[I]] := ARegistry.ReadString(AValueNames[I]);
    end;
  finally
    AValueNames.Free;
    ARegistry.Free;
  end;
end;

procedure SaveIconLibrarySettings(const AName, AValue: string);
var
  ARegistry: TRegistry;
begin
  ARegistry := TRegistry.Create;
  try
    ARegistry.RootKey := HKEY_CURRENT_USER;
    if ARegistry.OpenKey(sdxIconLibraryCollectionsRegistry, True) then
      ARegistry.WriteString(AName, AValue);
  finally
    ARegistry.Free;
  end;
end;

function ReadIconLibrarySettings(const AName: string): TValue;
var
  ARegistry: TRegistry;
begin
  Result := TValue.Empty;
  ARegistry := TRegistry.Create;
  try
    ARegistry.RootKey := HKEY_CURRENT_USER;
    if ARegistry.OpenKeyReadOnly(sdxIconLibraryCollectionsRegistry) then
    begin
      if ARegistry.ValueExists(AName) then
        Result := ARegistry.ReadString(AName);
    end;
  finally
    ARegistry.Free;
  end;
end;

procedure UpdateImageExtensionList;
var
  I, J: Integer;
  AExtensions: TArray<string>;
begin
  if not Assigned(FImageExtensions) then
  begin
    FImageExtensions := TStringList.Create;
    FImageExtensions.Duplicates := TDuplicates.dupIgnore;
    FImageExtensions.Sorted := True;
  end;
  for I := 0 to TdxSmartImageCodecsRepository.Count - 1 do
  begin
    AExtensions := TdxSmartImageCodecsRepository.Items[I].Extensions.Split([';']);
    for J := Low(AExtensions) to High(AExtensions) do
      if AExtensions[J] <> '' then
        FImageExtensions.Add(ReplaceStr(AExtensions[J], '*', ''));
  end;
end;

type

  { TdxIconLibraryMonitor }

  TdxIconLibraryMonitor = class(TThread)
  strict private
    FChangeAggregator: TcxTimer;
    FChangeHandle: THandle;
    FPath: string;

    FOnChange: TNotifyEvent;

    procedure ReleaseHandle;
    procedure TimerHandler(Sender: TObject);
  protected
    procedure Execute; override;
  public
    constructor Create(const APath: string; AChangeNotify: TNotifyEvent);
    destructor Destroy; override;

    property Path: string read FPath;
  end;

procedure ListFiles(APath: string; AProc: TdxIconLibraryEnumFilesProc; AFileObjectType: TFileObjectType; ARecursive: Boolean);
var
  ASearchRec: TSearchRec;
  AType: TFileObjectType;
begin
  APath := IncludeTrailingPathDelimiter(APath);
  if FindFirst(APath + '*', faAnyFile, ASearchRec) = 0 then
  try
    repeat
      if ((ASearchRec.Attr and faHidden) = faHidden)
        or (ASearchRec.Name = '.') or (ASearchRec.Name = '..') then
        Continue;
      if (ASearchRec.Attr and faDirectory) = faDirectory then
        AType := fotDirectory
      else
        AType := fotFile;
      if AType = AFileObjectType then
        AProc(APath + ASearchRec.Name);
      if ARecursive and (AType = fotDirectory) then
        ListFiles(APath + ASearchRec.Name + PathDelim, AProc, AFileObjectType, ARecursive);
    until FindNext(ASearchRec) <> 0;
  finally
    FindClose(ASearchRec);
  end;
end;

function dxGetIconLibraryPath: string;
{$IF DEFINED(CXTEST) AND DEFINED(CXEDITORSTEST)}
{$ELSE}
var
  APath: string;
{$IFEND}
begin
  if FActualIconLibraryPath = '' then
  begin
  {$IF DEFINED(CXTEST) AND DEFINED(CXEDITORSTEST)}
    FActualIconLibraryPath := ExtractFilePath(ParamStr(0)) + 'Icon Library\';
  {$ELSE}
    FActualIconLibraryPath := GetEnvironmentVariable('DXVCL') + dxIconLibraryRelativePath;
    if not DirectoryExists(FActualIconLibraryPath) then
    begin
      APath := GetEnvironmentVariable('DX_ICON_LIBRARY');
      if APath <> '' then
        FActualIconLibraryPath := IncludeTrailingPathDelimiter(APath);
    end;
  {$IFEND}
  end;
  Result := FActualIconLibraryPath;
end;

{ TdxIconLibraryCustomObject }

constructor TdxIconLibraryCustomObject.Create(const AName: string; AParent: TdxIconLibraryCustomObject);
begin
  inherited Create;
  FName := AName;
  FParent := AParent;
  FDisplayName := ExtractFileName(FName);
end;

procedure TdxIconLibraryCustomObject.BeforeDestruction;
begin
  inherited;
  DoBeforeRemove(Self);
end;

procedure TdxIconLibraryCustomObject.DoBeforeRemove(AObject: TdxIconLibraryCustomObject);
begin
  if FParent <> nil then
    FParent.DoBeforeRemove(AObject);
end;

{ TdxIconLibraryCollection }

constructor TdxIconLibraryCollection.Create(const AName: string; AParent: TdxIconLibraryCustomObject);
begin
  inherited;
  FItems := TcxObjectList.Create;
  FItemClass := TdxIconLibraryCustomObject;
end;

destructor TdxIconLibraryCollection.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TdxIconLibraryCollection.BeforeDestruction;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].FParent := nil;
  inherited BeforeDestruction;
end;

function TdxIconLibraryCollection.Add(const AName: string): TdxIconLibraryCustomObject;
var
  AIndex: Integer;
begin
  if Find(AName, AIndex) then
    Exit(Items[AIndex]);

  Result := FItemClass.Create(AName, Self);
  FItems.Insert(AIndex, Result);
end;

function TdxIconLibraryCollection.Find(const AName: string; var AIndex: Integer): Boolean;
var
  ACompareResult: Integer;
  AHigh: Integer;
  ALow: Integer;
  AMiddle: Integer;
begin
  ALow := 0;
  AHigh := Count - 1;
  Result := False;
  while ALow <= AHigh do
  begin
    AMiddle := (ALow + AHigh) shr 1;
    ACompareResult := CompareText(Items[AMiddle].Name, AName);
    if ACompareResult < 0 then
      ALow := AMiddle + 1
    else
    begin
      AHigh := AMiddle - 1;
      if ACompareResult = 0 then
        Result := True;
    end;
  end;
  AIndex := ALow;
end;

procedure TdxIconLibraryCollection.Remove(AItem: TdxIconLibraryCustomObject);
begin
  FItems.FreeAndRemove(AItem);
end;

procedure TdxIconLibraryCollection.Refresh;
var
  ARemovedItems: TList;
  I: Integer;
begin
  if Count > 0 then
  begin
    ARemovedItems := TList.Create;
    try
      ARemovedItems.Capacity := Count;
      ARemovedItems.Assign(FItems);
      EnumFiles(
        procedure (const S: string)
        var
          AItem: TdxIconLibraryCustomObject;
        begin
          AItem := Add(S);
          AItem.Refresh;
          ARemovedItems.Remove(AItem);
        end);
      for I := 0 to ARemovedItems.Count - 1 do
        Remove(ARemovedItems.List[I]);
    finally
      ARemovedItems.Free;
    end;
  end
  else
    EnumFiles(
      procedure (const S: string)
      begin
        Add(S).Refresh;
      end);
end;

function TdxIconLibraryCollection.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TdxIconLibraryCollection.GetItem(AIndex: Integer): TdxIconLibraryCustomObject;
begin
  Result := TdxIconLibraryCustomObject(FItems.List[AIndex]);
end;

{ TdxIconLibraryImage }

constructor TdxIconLibraryImage.Create(const AName: string; AParent: TdxIconLibraryCustomObject);
begin
  inherited;
  FImage := TdxSmartGlyph.Create;
end;

destructor TdxIconLibraryImage.Destroy;
begin
  FreeAndNil(FImage);
  inherited Destroy;
end;

procedure TdxIconLibraryImage.LoadFromFile;
begin
  FImage.LoadFromFile(FileName);
  FImage.HandleNeeded;
end;

procedure TdxIconLibraryImage.Refresh;
begin
  FImage.Clear;
  FImageSizeAssigned := False;
end;

function TdxIconLibraryImage.FetchImageSizeFromFileName(out ASize: TSize): Boolean;
var
  ASizeString: string;
begin
  TdxIconLibraryFileName.ParseName(DisplayName, ASizeString);
  Result := cxTryStringToSize(ASizeString, ASize);
end;

procedure TdxIconLibraryImage.ImageSizeNeeded;
var
  ACodec: TdxSmartImageCodecClass;
begin
  if not FImageSizeAssigned then
  begin
    FImageSizeAssigned := True;
    FImageSize := cxNullSize;

    if EndsText('.svg', Name) then
      FImageSizeAsString := TdxIconLibrary.SizeVector
    else
      if FetchImageSizeFromFileName(FImageSize) or TdxSmartImageCodecsRepository.GetImageInfo(FileName, FImageSize, ACodec) then
        FImageSizeAsString := cxSizeToString(FImageSize)
      else
        FImageSizeAsString := '?';
  end;
end;

function TdxIconLibraryImage.GetCollectionName: string;
begin
  if (Parent is TdxIconLibraryCategory) and (Parent.Parent is TdxIconLibraryCollection) then
    Result := Parent.Parent.DisplayName
  else
    Result := '-';
end;

function TdxIconLibraryImage.GetFileName: string;
begin
  if Length(Name) < MAX_PATH then
    Result := Name
  else
    Result := '\\?\' + Name;
end;

function TdxIconLibraryImage.GetCategoryName: string;
begin
  if Parent is TdxIconLibraryCategory then
    Result := Parent.DisplayName
  else
    Result := '-';
end;

function TdxIconLibraryImage.GetImageSize: TSize;
begin
  ImageSizeNeeded;
  Result := FImageSize;
end;

function TdxIconLibraryImage.GetImageSizeAsString: string;
begin
  ImageSizeNeeded;
  Result := FImageSizeAsString;
end;

{ TdxIconLibraryCategory }

constructor TdxIconLibraryCategory.Create(const AName: string; AParent: TdxIconLibraryCustomObject);
begin
  inherited;
  FItemClass := TdxIconLibraryImage;
end;

procedure TdxIconLibraryCategory.EnumFiles(AProc: TdxIconLibraryEnumFilesProc);
var
  AFiles: TStringDynArray;
  I, iExt: Integer;
  AIsKnownImage: Boolean;
begin
  AFiles := TDirectory.GetFiles(Name, TSearchOption.soAllDirectories, nil);
  for I := Low(AFiles) to High(AFiles) do
  begin
    AIsKnownImage := False;
    for iExt := 0 to FImageExtensions.Count - 1 do
      begin
        AIsKnownImage := EndsText(FImageExtensions[iExt], AFiles[I]);
        if AIsKnownImage then
          Break;
      end;
    if AIsKnownImage then
      AProc(AFiles[I]);
  end;
end;

function TdxIconLibraryCategory.GetIsEmpty: Boolean;
begin
  Result := Count > 0;
end;

function TdxIconLibraryCategory.GetItem(AIndex: Integer): TdxIconLibraryImage;
begin
  Result := TdxIconLibraryImage(inherited Items[AIndex]);
end;

{ TdxIconLibrarySet }

constructor TdxIconLibrarySet.Create(const AName: string; AParent: TdxIconLibraryCustomObject);
begin
  inherited;
  FItemClass := TdxIconLibraryCategory;
end;

procedure TdxIconLibrarySet.EnumFiles(AProc: TdxIconLibraryEnumFilesProc);
var
  AFiles: TStringDynArray;
  I: Integer;
begin
  if DirectoryExists(Name) then 
  begin
    AFiles := TDirectory.GetDirectories(Name, TSearchOption.soTopDirectoryOnly, nil);
    for I := Low(AFiles) to High(AFiles) do
      AProc(AFiles[I]);
  end;
end;

function TdxIconLibrarySet.GetIsEmpty: Boolean;
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
    if not Items[I].IsEmpty then
      Exit(False);
  Result := True;
end;

function TdxIconLibrarySet.GetItem(AIndex: Integer): TdxIconLibraryCategory;
begin
  Result := TdxIconLibraryCategory(inherited Items[AIndex]);
end;

{ TdxIconLibraryListeners }

procedure TdxIconLibraryListeners.NotifyChanged(Sender: TdxIconLibraryCollection);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnChanged(Sender);
end;

procedure TdxIconLibraryListeners.NotifyChanging(Sender: TdxIconLibraryCollection);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnChanging(Sender);
end;

procedure TdxIconLibraryListeners.NotifyRemoving(Sender: TdxIconLibraryCustomObject);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnRemoving(Sender);
end;

{ TdxIconLibraryFileName }

class function TdxIconLibraryFileName.Build(const ACollection, ACategory, AName: string; AWidth, AHeight: Integer; ARelative: Boolean): string;
var
  ABuilder: TStringBuilder;
begin
  ABuilder := TdxStringBuilderManager.Get;
  try
    if not ARelative then
      ABuilder.Append(dxGetIconLibraryPath);
    ABuilder.Append(ACollection);
    ABuilder.Append(PathDelim);
    ABuilder.Append(ACategory);
    ABuilder.Append(PathDelim);
    if (AWidth > 0) and (AHeight > 0) then
    begin
      ABuilder.Append(ChangeFileExt(AName, ''));
      ABuilder.Append(SizeSeparator);
      ABuilder.Append(cxSizeToString(cxSize(AWidth, AHeight)));
      ABuilder.Append(ExtractFileExt(AName));
    end
    else
      ABuilder.Append(AName);

    Result := ABuilder.ToString;
  finally
    TdxStringBuilderManager.Release(ABuilder);
  end;
end;

class function TdxIconLibraryFileName.Parse(AFileName: string; out ACollection, ACategory, AName: string): Boolean;

  function ExtractPart(var AFileName: string; out APart: string): Boolean;
  var
    ADelimiter: Integer;
  begin
    ADelimiter := LastDelimiter(PathDelim + DriveDelim, AFileName);
    if ADelimiter > 0 then
    begin
      APart := Copy(AFileName, ADelimiter + 1, MaxInt);
      AFileName := Copy(AFileName, 1, ADelimiter - 1);
    end
    else
    begin
      APart := AFileName;
      AFileName := EmptyStr;
    end;
    Result := APart <> '';
  end;

begin
  Result := ExtractPart(AFileName, AName) and ExtractPart(AFileName, ACategory) and ExtractPart(AFileName, ACollection) and
    ((AFileName = '') or dxSameText(IncludeTrailingPathDelimiter(AFileName), dxGetIconLibraryPath));
end;

class function TdxIconLibraryFileName.Parse(AFileName: string; out ACollection, ACategory, AName, ADisplayName, ASize: string): Boolean;
begin
  Result := Parse(AFileName, ACollection, ACategory, AName);
  if Result then
    ADisplayName := ParseName(AName, ASize);
end;

class function TdxIconLibraryFileName.ParseName(const AName: string; out ASize: string): string;
var
  ADelimiter: Integer;
  ASizeValue: TSize;
begin
  Result := ChangeFileExt(AName, '');
  ADelimiter := LastDelimiter(SizeSeparator, Result);
  if ADelimiter > 0 then
  begin
    ASize := Copy(Result, ADelimiter + 1, MaxWord);
    if cxTryStringToSize(ASize, ASizeValue) then 
      Result := Copy(Result, 1, ADelimiter - 1)
    else
      ASize := EmptyStr;
  end
  else
    ASize := EmptyStr;
end;

class function TdxIconLibraryFileName.ToAbsolute(const AFileName: string): string;
begin
  if ExtractFileDrive(AFileName) <> '' then
    Result := AFileName
  else
    Result := dxGetIconLibraryPath + AFileName;
end;

class function TdxIconLibraryFileName.ToRelative(const AFileName: string): string;
var
  ACollection, ACategory, AName: string;
begin
  if Parse(AFileName, ACollection, ACategory, AName) then
    Result := Build(ACollection, ACategory, AName, 0, 0, True)
  else
    Result := EmptyStr;
end;

{ TdxIconLibrary }

function TdxIconLibrary.AddUserCollection(const AName, APath: string): TdxIconLibrarySet;
var
  AFileSystemMonitor: TdxIconLibraryMonitor;
begin
  AFileSystemMonitor := TdxIconLibraryMonitor.Create(APath, FileSystemChangeHandler);
  FFileSystemMonitors.Add(AFileSystemMonitor);
  FPaths.Values[AName] := AFileSystemMonitor.Path;
  UpdateImageExtensionList;
  Result := Add(APath) as TdxIconLibrarySet;
  Result.DisplayName := AName;
  Result.Refresh;
end;

constructor TdxIconLibrary.Create(const APath: string);
var
  AFileSystemMonitor: TdxIconLibraryMonitor;
begin
  inherited Create(APath, nil);
  FItemClass := TdxIconLibrarySet;
  FListeners := TdxIconLibraryListeners.Create;
  FFileSystemMonitors := TObjectList.Create(True);
  AFileSystemMonitor := TdxIconLibraryMonitor.Create(APath, FileSystemChangeHandler);
  FFileSystemMonitors.Add(AFileSystemMonitor);
  FPaths := TStringList.Create;
end;

destructor TdxIconLibrary.Destroy;
begin
  FreeAndNil(FFileSystemMonitors);
  FreeAndNil(FListeners);
  FreeAndNil(FPaths);
  inherited;
end;

procedure TdxIconLibrary.DoBeforeRemove(AObject: TdxIconLibraryCustomObject);
begin
  Listeners.NotifyRemoving(AObject);
end;

procedure TdxIconLibrary.EnumFiles(AProc: TdxIconLibraryEnumFilesProc);
var
  I: Integer;
begin
  // Enum all directories in FPaths
  ListFiles(Name, AProc, fotDirectory, False);
  for I := 0 to FPaths.Count - 1 do
  begin
    AProc(FPaths.ValueFromIndex[I]);
    GetItemByName(FPaths.ValueFromIndex[I]).DisplayName := FPaths.Names[I];
  end;
end;

procedure TdxIconLibrary.FileSystemChangeHandler(Sender: TObject);
begin
  Refresh;
end;

function TdxIconLibrary.GetItem(AIndex: Integer): TdxIconLibrarySet;
begin
  Result := inherited Items[AIndex] as TdxIconLibrarySet;
end;

function TdxIconLibrary.GetItemByName(const AName: string): TdxIconLibrarySet;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    if SameText(Items[I].Name, AName) then
      Exit(Items[I]);
end;

function TdxIconLibrary.IsUserCollection(const AName: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FPaths.Count - 1 do
    if FPaths.Names[I] = AName then
      Exit(True);
end;

procedure TdxIconLibrary.Refresh;
begin
  UpdateImageExtensionList;
  Listeners.NotifyChanging(Self);
  try
    inherited Refresh;
  finally
    Listeners.NotifyChanged(Self);
  end;
end;

procedure TdxIconLibrary.RemoveUserCollection(const AName: string);
var
  I, J: Integer;
  APath: string;
begin
  for I := 0 to FPaths.Count - 1 do
    if FPaths.Names[I] = AName then
    begin
      APath := FPaths.Values[AName];
      for J := 0 to FFileSystemMonitors.Count - 1 do
        if TdxIconLibraryMonitor(FFileSystemMonitors.Items[J]).Path = APath then
        begin
          FFileSystemMonitors.Delete(J); 
          Break;
        end;
      FPaths.Delete(I);
      Break;
    end;
end;

{ TdxIconLibraryMonitor }

constructor TdxIconLibraryMonitor.Create(const APath: string; AChangeNotify: TNotifyEvent);
const
  ChangesFilter =
    FILE_NOTIFY_CHANGE_FILE_NAME or
    FILE_NOTIFY_CHANGE_DIR_NAME or
    FILE_NOTIFY_CHANGE_SIZE or
    FILE_NOTIFY_CHANGE_LAST_WRITE;
begin
  inherited Create(False);
  FOnChange := AChangeNotify;
  FPath := IncludeTrailingPathDelimiter(APath);
  FChangeHandle := FindFirstChangeNotification(PChar(FPath), True, ChangesFilter);
  if FChangeHandle = INVALID_HANDLE_VALUE then
    FChangeHandle := 0;
  FChangeAggregator := cxCreateTimer(TimerHandler, 1000, False);
end;

destructor TdxIconLibraryMonitor.Destroy;
begin
  ReleaseHandle;
  TdxUIThreadSyncService.Unsubscribe(Self);
  FreeAndNil(FChangeAggregator);
  inherited;
end;

procedure TdxIconLibraryMonitor.Execute;
begin
  while (FChangeHandle <> 0) and not Terminated do
  begin
    case WaitForSingleObject(FChangeHandle, INFINITE) of
      WAIT_OBJECT_0:
        if not Terminated then
        begin
          TdxUIThreadSyncService.EnqueueInvokeInUIThread(Self,
            procedure
            begin
              FChangeAggregator.Enabled := False;
              FChangeAggregator.Enabled := True;
            end);
          FindNextChangeNotification(FChangeHandle);
        end;
    end;
  end;
end;

procedure TdxIconLibraryMonitor.ReleaseHandle;
begin
  FindCloseChangeNotification(FChangeHandle);
  FChangeHandle := 0;
end;

procedure TdxIconLibraryMonitor.TimerHandler(Sender: TObject);
begin
  FChangeAggregator.Enabled := False;
  CallNotify(FOnChange, Self);
end;

initialization
finalization
  FImageExtensions.Free;
end.
