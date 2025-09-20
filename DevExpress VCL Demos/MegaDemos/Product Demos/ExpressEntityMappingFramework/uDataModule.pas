unit uDataModule;

interface

{$I cxVer.inc}

uses
  System.SysUtils, System.Classes, cxSchedulerUtils,
  //  EMF
  dxEMF.Core, dxEMF.DataProvider.FireDAC, dxEMF.DataSet, dxEMF.DB.SQLite, dxEMF.Types, dxEMF.DB.Criteria,
  PhotoViewerClasses, uEntityEditor,
{$IFDEF DELPHI19}
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Dapt,
  FireDAC.Comp.Client, FireDAC.VCLUI.Wait, FireDAC.Comp.UI,
  {$IFDEF DELPHI104}
  FireDAC.Phys.SQLiteWrapper.Stat,
  {$ENDIF}
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite;
{$ELSE}
  uADStanIntf, uADStanOption, uADStanError,
  uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADGUIxFormsWait, uADStanParam, uADDatSManager, uADDAptIntf,
  uADDAptManager, uADCompDataSet, uADCompClient,
  uADPhysODBCBase, uADPhysSQLite, uADCompGUIx;
{$ENDIF}

type
  { TDataModule1 }

  TDataModule1 = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  strict private
{$IFDEF DELPHI19}
    FConnection: TFDConnection;
  {$ELSE}
    FConnection: TADConnection;
  {$ENDIF}
    FEMFDataProvider: TdxEMFFireDACDataProvider;
    FEMFSession: TdxEMFSession;

    function GetPhotosSortingExpressions: TdxSortByExpressions;
    procedure ClearData;
    procedure PopulateAlbums;
    procedure PopulateEffects;
    procedure PopulateFilters;

    property EMFSession: TdxEMFSession read FEMFSession;
  public
    function GetAlbum(AID: Integer): IdxEMFCollection<TAlbum>;
    function GetAlbumByCaption(const ACaption: string): TAlbum;
    function GetAlbumByID(AID: Integer): TAlbum;
    function GetAlbumCollection: IdxEMFCollection<TAlbum>;
    function GetAlbumCollectionByDate(ADateList: TcxSchedulerDateList): IdxEMFCollection<TAlbum>;
    function GetEffectCollection: IdxEMFCollection<TEffect>;
    function GetFilterCollection: IdxEMFCollection<TFilter>;
    function GetPhotoCollection: IdxEMFCollection<TPhoto>; overload;
    function GetPhotoCollection(const AAlbumIDs: TArray<Integer>; AMinRating, AMaxRating: Integer;
      ADateList: TcxSchedulerDateList): IdxEMFCollection<TPhoto>; overload;
    function FindAlbum(const AFileName: string; out AAlbum: TAlbum): Boolean;
    procedure DeleteEntity(AEntity: TPhotoViewerEntity);
    procedure RestoreOriginalContent(AShowSplash: Boolean);
    procedure SaveEntity(AEntity: TPhotoViewerEntity);
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

uses
  Windows, Types, IOUtils, Forms, Math, DateUtils, dxCoreGraphics, cxDateUtils, dxEMF.Linq, dxGDIPlusAPI,
  uPhotoViewerForm;

const
  DefaultDatabaseName = 'PhotoViewer';
  DefaultDatabasePath = '\Data\';

type
  TEffectType = (etPolaroid, etGrayScale, etNegative, etSepia, etBGR, etGBR, etBlackAndWhite, etOldPaper, etRedChannel,
    etGreenChannel, etBlueChannel);

function GetDatabaseName(AGenerateName: Boolean = False): string;
begin
  Result := DefaultDatabasePath + DefaultDatabaseName;
  if AGenerateName then
    Result := Result + TPath.GetRandomFileName;
  Result := Result + '.db';
end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
var
  ADatabase: string;
begin
  ADatabase := TPath.GetDirectoryName(Application.ExeName) + GetDatabaseName;
  if FileExists(ADatabase) then
    if not DeleteFile(PWideChar(ADatabase)) then
      ADatabase := TPath.GetDirectoryName(Application.ExeName) + GetDatabaseName(True);
{$IFDEF DELPHI19}
  FConnection := TFDConnection.Create(Self);
  FConnection.Params.Database := ADatabase;
  FConnection.Params.DriverID := 'SQLite';
{$ELSE}
  FConnection := TADConnection.Create(Self);
  FConnection.Params.Add('Database=' + ADatabase);
  FConnection.Params.Add('DriverID=SQLite');
{$ENDIF}
  FEMFDataProvider := TdxEMFFireDACDataProvider.Create(Self);
  FEMFDataProvider.Connection := FConnection;
  FEMFDataProvider.Options.AutoCreate := TdxAutoCreateOption.DatabaseAndSchema;
  FEMFSession := TdxEMFSession.Create(Self);
  FEMFSession.DataProvider := FEMFDataProvider;
  RestoreOriginalContent(False);
end;

procedure TDataModule1.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FEMFSession);
  FreeAndNil(FEMFDataProvider);
  FreeAndNil(FConnection);
end;

function TDataModule1.GetAlbum(AID: Integer): IdxEMFCollection<TAlbum>;
begin
  Result := DataModule1.EMFSession.GetObjects<TAlbum>(TdxCriteriaOperator.Parse('ID = ' + IntToStr(AID)));
end;

function TDataModule1.GetAlbumByCaption(const ACaption: string): TAlbum;
begin
  Result := DataModule1.EMFSession.Find<TAlbum>(TdxCriteriaOperator.Parse('Caption = ' + '''' + ACaption + ''''));
end;

function TDataModule1.GetAlbumByID(AID: Integer): TAlbum;
begin
  Result := DataModule1.EMFSession.Find<TAlbum>(AID);
end;

function TDataModule1.GetAlbumCollection: IdxEMFCollection<TAlbum>;
begin
  Result := DataModule1.EMFSession.GetObjects<TAlbum>;
end;

function TDataModule1.GetAlbumCollectionByDate(ADateList: TcxSchedulerDateList): IdxEMFCollection<TAlbum>;
var
  I: Integer;
  ACondition: string;
begin
  Result := nil;
  if ADateList.Count > 0 then
  begin
    ACondition := ' ';
    for I := 0 to ADateList.Count - 1 do
    begin
      ACondition := ACondition + 'DateOf(Date) = ' + '#' + cxDateToStr(ADateList[I]) + '#';
      if I < ADateList.Count - 1 then
        ACondition := ACondition + ' or ';
    end;
    Result := EMFSession.GetObjects<TAlbum>(TdxCriteriaOperator.Parse(ACondition));
  end;
end;

function TDataModule1.GetEffectCollection: IdxEMFCollection<TEffect>;
begin
  Result := EMFSession.GetObjects<TEffect>;
end;

function TDataModule1.GetFilterCollection: IdxEMFCollection<TFilter>;
begin
  Result := EMFSession.GetObjects<TFilter>;
end;

function TDataModule1.GetPhotoCollection: IdxEMFCollection<TPhoto>;
begin
  Result := EMFSession.GetObjects<TPhoto>(nil, GetPhotosSortingExpressions);
end;

function TDataModule1.GetPhotoCollection(const AAlbumIDs: TArray<Integer>; AMinRating, AMaxRating: Integer;
  ADateList: TcxSchedulerDateList): IdxEMFCollection<TPhoto>;
var
  I: Integer;
  AAlbumContent: IdxEMFCollection<TAlbumContent>;
  ACondition, AIDs: string;
  APhotoIDs: TArray<Integer>;
begin
  Result := nil;
  if ADateList.Count > 0 then
  begin
    ACondition := ' ';
    for I := 0 to ADateList.Count - 1 do
    begin
      ACondition := ACondition + 'DateOf([Photo].Date) = ' + '#' + cxDateToStr(ADateList[I]) + '#';
      if I < ADateList.Count - 1 then
        ACondition := ACondition + ' or ';
    end;

    ACondition := '(' + ACondition + ')';
    if Length(AAlbumIDs) > 0 then
    begin
      AIDs := '';
      for I in AAlbumIDs do
        AIDs := AIDs + IntToStr(I) + ',';
      AIDs := Copy(AIDs, 1, Length(AIDs) - 1);
      ACondition := ACondition + ' and [Album].ID in (' + AIDs + ')';
    end;
    ACondition := ACondition +  ' and [Photo].Rating between (' + IntToStr(AMinRating) + ', ' + IntToStr(AMaxRating) + ')';
    AAlbumContent := EMFSession.GetObjects<TAlbumContent>(TdxCriteriaOperator.Parse(ACondition));
    if AAlbumContent.Count > 0 then
    begin
      SetLength(APhotoIDs, AAlbumContent.Count);
      for I := 0 to AAlbumContent.Count - 1 do
        APhotoIDs[I] := AAlbumContent[I].Photo.ID;
      Result := EMFSession.GetObjects<TPhoto>(TdxInOperator.Create<Integer>('ID', APhotoIDs), GetPhotosSortingExpressions);
    end
    else
      Result := nil;
  end;
end;

function TDataModule1.FindAlbum(const AFileName: string; out AAlbum: TAlbum): Boolean;
var
  AAlbumCaption: string;
  APosition: Integer;
begin
  Result := AFileName[1] = '(';
  if Result then
  begin
    APosition := Pos(')', AFileName);
    Result:= APosition > 1;
    if Result then
    begin
      AAlbumCaption := StringReplace(Copy(AFileName, 2, APosition - 2), '-', ' ', [rfReplaceAll]);
      AAlbum := GetAlbumByCaption(AAlbumCaption);
      Result := AAlbum <> nil;
      if not Result then
      begin
        AAlbum := TAlbum.Create;
        AAlbum.Caption := AAlbumCaption;
        SaveEntity(AAlbum);
        Result := True;
      end;
    end;
  end
  else
    AAlbum := nil;
end;

procedure TDataModule1.DeleteEntity(AEntity: TPhotoViewerEntity);
begin
  if AEntity <> nil then
    EMFSession.Delete(AEntity);
end;

procedure TDataModule1.RestoreOriginalContent(AShowSplash: Boolean);
begin
  TPhotoViewerForm.ExecuteLongOperation(
    procedure
    begin
      FEMFSession.CreateSchema([TAlbum, TPhoto, TAlbumContent, TCustomFilter, TFilter, TEffect]);
      ClearData;
      PopulateEffects;
      PopulateFilters;
      PopulateAlbums;
    end, 'Content generation...');
end;

procedure TDataModule1.SaveEntity(AEntity: TPhotoViewerEntity);
begin
  if AEntity <> nil then
    EMFSession.Save(AEntity);
end;

function TDataModule1.GetPhotosSortingExpressions: TdxSortByExpressions;
begin
  Result := TdxSortByExpressions.Create;
  Result.Add(TdxSortByExpression.Create(TdxOperandProperty.Create('Caption')));
  Result.Add(TdxSortByExpression.Create(TdxOperandProperty.Create('Rating'), TdxSortDirection.Descending));
end;

procedure TDataModule1.ClearData;

  procedure ClearData(AClass: TClass);
  var
    AObject: TObject;
  begin
    for AObject in EMFSession.GetObjects(AClass) do
      EMFSession.Delete(AObject);
  end;

begin
  EMFSession.BeginTrackingChanges;
  ClearData(TAlbum);
  ClearData(TPhoto);
  ClearData(TEffect);
  ClearData(TFilter);
  EMFSession.FlushChanges;
end;

procedure TDataModule1.PopulateAlbums;

  function IsFile(AFindData: TWIN32FindData): Boolean;
  var
    AFileName: string;
  begin
    AFileName := AFindData.cFileName;
    Result := (AFileName <> '.') and (AFileName <> '..') and
      (AFindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY = 0);
  end;

  function GetFileName(AFindData: TWIN32FindData): string;
  begin
    Result := AFindData.cFileName;
  end;

var
  AAlbum: TAlbum;
  AAlbumCollection: IdxEMFCollection<TAlbum>;
  AMask, AFilePath: string;
  AHandle: THandle;
  AFindData: TWIN32FindData;
  APhotoCollection: IdxEMFCollection<TPhoto>;
  APath: string;
begin
  APath := ExtractFilePath(Application.ExeName) + 'Data';
  AFilePath := IncludeTrailingPathDelimiter(APath);
  AMask := '*.jpg';
  APath := AFilePath + AMask;
  AAlbumCollection := DataModule1.GetAlbumCollection;
  APhotoCollection := DataModule1.GetPhotoCollection;
  AHandle := FindFirstFile(PChar(APath), AFindData);
  if AHandle <> INVALID_HANDLE_VALUE then
    try
      repeat
        if IsFile(AFindData) and ((AMask = '*') or SameText(ExtractFileExt(AFindData.cFileName), ExtractFileExt(AMask))) then
        begin
          APhotoCollection.Add(TPhoto.Create);
          APhotoCollection.Last.Image.LoadFromFile(AFilePath + GetFileName(AFindData));
          APhotoCollection.Last.Caption := GetFileName(AFindData);
          APhotoCollection.Last.Rating := RandomRange(1, 6);
          APhotoCollection.Last.Date := IncDay(APhotoCollection.Last.Date, RandomRange(-5, 5));
          SaveEntity(APhotoCollection.Last);
          if FindAlbum(AFindData.cFileName, AAlbum) then
          begin
            EMFSession.BeginTrackingChanges;
            AAlbum.AddPhoto(APhotoCollection.Last);
            EMFSession.FlushChanges;
          end;
        end;
        if not FindNextFile(AHandle, AFindData) then Break;
      until False;
    finally
      Windows.FindClose(AHandle);
    end;
end;

procedure TDataModule1.PopulateEffects;
const
  ColorMatrics: array [TEffectType] of TdxGpColorMatrix =
    (
    //  PolaroidFilter: TdxGpColorMatrix =
        ((1.438, -0.062, -0.062, 0, 0),
         (-0.122, 1.378, -0.122, 0, 0),
         (0.016, -0.016, 1.438, 0, 0),
         (0, 0, 0, 1, 0),
         (0.03, 0.05, -0.2, 0, 1)),
  //    GrayScaleFilter: TdxGpColorMatrix =
        ((0.3, 0.3, 0.3, 0, 0),
         (0.59, 0.59, 0.59, 0, 0),
         (0.11, 0.11, 0.11, 0, 0),
         (0, 0, 0, 1, 0),
         (0, 0, 0, 0, 1)),
   //   NegativeFilter: TdxGpColorMatrix =
        ((-1, 0, 0, 0, 0),
         (0, -1, 0, 0, 0),
         (0, 0, -1, 0, 0),
         (0, 0, 0, 1, 0),
         (1, 1, 1, 0, 1)),
    //  SepiaFilter: TdxGpColorMatrix =
        ((0.393, 0.349, 0.272, 0, 0),
         (0.769, 0.686, 0.534, 0, 0),
         (0.189, 0.168, 0.131, 0, 0),
         (0, 0, 0, 1, 0),
         (0, 0, 0, 0, 1)),
    //  BGRFilter: TdxGpColorMatrix =
        ((0, 0, 1, 0, 0),
         (0, 1, 0, 0, 0),
         (1, 0, 0, 0, 0),
         (0, 0, 0, 1, 0),
         (0, 0, 0, 0, 1)),
   //   GBRFilter: TdxGpColorMatrix =
        ((0, 1, 0, 0, 0),
         (0, 0, 1, 0, 0),
         (1, 0, 0, 0, 0),
         (0, 0, 0, 1, 0),
         (0, 0, 0, 0, 1)),
   //   BlackAndWhite: TdxGpColorMatrix =
        ((1.5, 1.5, 1.5, 0, 0),
         (1.5, 1.5, 1.5, 0, 0),
         (1.5, 1.5, 1.5, 0, 0),
         (0, 0, 0, 1, 0),
         (-1, -1, -1, 0, 1)),
   //   WhiteToAlpha: TdxGpColorMatrix =
        ((1, 0, 0, -1, 0),
         (0, 1, 0, -1, 0),
         (0, 0, 1, -1, 0),
         (0, 0, 0, 1, 0),
         (0, 0, 0, 0, 1)),
   //   RedChannel: TdxGpColorMatrix =
        ((1, 0, 0, 0, 0),
         (0, 0, 0, 0, 0),
         (0, 0, 0, 0, 0),
         (0, 0, 0, 1, 0),
         (0, 0, 0, 0, 1)),
   //   GreenChannel: TdxGpColorMatrix =
        ((0, 0, 0, 0, 0),
         (0, 1, 0, 0, 0),
         (0, 0, 0, 0, 0),
         (0, 0, 0, 1, 0),
         (0, 0, 0, 0, 1)),
   //   BlueChannel: TdxGpColorMatrix =
        ((0, 0, 0, 0, 0),
         (0, 0, 0, 0, 0),
         (0, 0, 1, 0, 0),
         (0, 0, 0, 1, 0),
         (0, 0, 0, 0, 1))
         );

  SImageFilterName: array [TEffectType] of string = ('Polaroid', 'GrayScale', 'Negative', 'Sepia', 'BGR', 'GBR',
    'Black & White', 'White To Alpha', 'Red Channel', 'Green Channel', 'Blue Channel');
var
  I: TEffectType;
  AEffect: TEffect;
begin
  EMFSession.BeginTrackingChanges;
  for I := Low(TEffectType) to High(TEffectType) do
  begin
    AEffect := TEffect.Create;
    AEffect.Assign(ColorMatrics[I]);
    AEffect.Caption := SImageFilterName[I];
    AEffect.Image.LoadFromFile('Data\(Athens)-Academy-of-Athens.jpg');
    SaveEntity(AEffect);
  end;
  EMFSession.FlushChanges;
end;

procedure TDataModule1.PopulateFilters;
var
  AFilter: TFilter;
begin
  AFilter := TFilter.Create;
  AFilter.Caption := 'Custom Filter 1';
  AFilter.Image.LoadFromFile('Data\(Athens)-Academy-of-Athens.jpg');
  AFilter.Contrast := 41;
  AFilter.Color := TdxAlphaColors.FromArgb(255, 247, 0, 0);
  DataModule1.SaveEntity(AFilter);
end;

end.
