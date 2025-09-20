{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressPDFViewer                                         }
{                                                                    }
{           Copyright (c) 2015-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSPDFVIEWER AND ALL              }
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

unit dxPDFContext;

{$I cxVer.inc}

interface

uses
  SysUtils, Classes, Generics.Defaults, Generics.Collections, dxCoreClasses, dxGenerics, dxPDFBase, dxPDFCore;

type
  { TdxPDFWritingContext }

  TdxPDFWritingContext = class(TcxIUnknownObject, IdxPDFWriterContext) // for internal use
  strict protected
    function GetUniqueName(ATree: TdxPDFCustomTree; const AName: string): string; virtual;
    procedure AddDestinationName(const AName: string); virtual;
    procedure AddReference(ADictionary: TdxPDFWriterDictionary; AObject: TdxPDFObject; const ATypeKey, AKey: string); virtual;
    function AllowPageParentReference: Boolean; virtual;
    function GetDestinationName(const AName: string): string; virtual;
    function GetObjectNumber(AObject: TdxPDFObject): Integer; virtual;
    function FindColorSpaceName(const AName: string): string; virtual;
    function FindFontName(const AName: string): string; virtual;
    function FindFormFieldName(const AName: string): string; virtual;
    function FindGraphicsStateParameters(const AName: string): string; virtual;
    function FindPatternName(const AName: string): string; virtual;
    function FindShadingName(const AName: string): string; virtual;
    function FindXObjectName(const AName: string): string; virtual;
  end;

  { TdxPDFDocumentWritingContext }

  TdxPDFDocumentWritingContext = class(TdxPDFWritingContext) // for internal use
  strict private
    FWriter: TObject;
  strict protected
    function GetObjectNumber(AObject: TdxPDFObject): Integer; override;
  public
    constructor Create(AWriter: TObject);
  end;

  { TdxPDFCloningContext }

  TdxPDFCloningContext = class(TdxPDFWritingContext) // for internal use
  strict private
    FColorSpaceNameMap: TdxPDFStringStringDictionary;
    FDestinationNameMap: TdxPDFStringStringDictionary;
    FFontNameMap: TdxPDFStringStringDictionary;
    FFormFieldNameMap: TdxPDFStringStringDictionary;
    FGraphicsStateParametersNameMap: TdxPDFStringStringDictionary;
    FPatternNameMap: TdxPDFStringStringDictionary;
    FRepository: TdxPDFDocumentRepository;
    FSavedDestinationNameList: TdxPDFStringHashSet;
    FShadingNameMap: TdxPDFStringStringDictionary;
    FStartObjectNumber: Integer;
    FWriterHelper: TdxPDFWriterHelper;
    FXObjectNameMap: TdxPDFStringStringDictionary;
    //
    FClonedObjects: TdxObjectIntegerDictionary;
    FSourceObjectToCloneList: TList;
    FSourceObjectToCloneNumberMap: TdxObjectIntegerDictionary;
    //
    FSharedTypes: TStringList;
    //
    function CloneAndAdd(ASource: TdxPDFPage): TdxPDFPage;
    function CloneDestination(AObject: TdxPDFObject): TdxPDFCustomDestination;
    function CloneObject(AObject: TdxPDFObject): Integer;
    function ClonePage(APage: TdxPDFPage): Integer;
    function DoExecute(AObject: TdxPDFObject): Integer;
    function Execute(AObject: TdxPDFObject; out AObjectNumber: Integer): Boolean;
    function GetName(AMap: TdxPDFStringStringDictionary; const AName: string): string;
    function SaveToBytes(AObject: TdxPDFObject; AObjectNumber: Integer): TBytes;
    function TryGetName(AMap: TdxPDFStringStringDictionary; const AKey: string; out AName: string): Boolean;
    function TryGetObjectNumber(AObject: TdxPDFObject; out ANumber: Integer): Boolean;
    function TryGetSharedObjectNumber(AObject: TdxPDFObject; out ANumber: Integer): Boolean;
    procedure Append(ADestination, ASource: TdxPDFBookmarkList); overload;
    procedure Append(ADestination, ASource: TdxPDFCustomTree); overload;
    procedure Append(ADestination, ASource: TdxPDFCustomTree; ALeafKeyList: TStringList); overload;
    procedure Append(ADestination, ASource: TdxPDFObjectList; ANameMap: TdxPDFStringStringDictionary); overload;
    procedure Append(ADestination, ASource: TdxPDFResources); overload;
    procedure Append(ASource: TdxPDFInteractiveForm); overload;
    procedure Append(ASource: TdxPDFInternalPageList; const APageIndexes: array of Integer; ATargetPageIndex: Integer); overload;
    procedure CloneAndCreateObject(AObject: TdxPDFObject; ACreateProc: TProc<TdxPDFWritingContext, TdxPDFBase>);
    procedure Rename(AExternalDestinations: TdxPDFDestinationTree);
    procedure RenameFields(AFields, AExternalFields: TdxPDFInteractiveFormFieldCollection);
  protected
    function AllowPageParentReference: Boolean; override;
    function FindColorSpaceName(const AName: string): string; override;
    function FindFontName(const AName: string): string; override;
    function FindFormFieldName(const AName: string): string; override;
    function FindGraphicsStateParameters(const AName: string): string; override;
    function FindPatternName(const AName: string): string; override;
    function FindShadingName(const AName: string): string; override;
    function FindXObjectName(const AName: string): string; override;
    function GetDestinationName(const AName: string): string; override;
    function GetObjectNumber(AObject: TdxPDFObject): Integer; override;
    function GetUniqueName(ATree: TdxPDFCustomTree; const AName: string): string; override;
    procedure AddDestinationName(const AName: string); override;
    procedure AddReference(ADictionary: TdxPDFWriterDictionary; AObject: TdxPDFObject; const ATypeKey, AKey: string); override;
  public
    class procedure Clone(ARepository: TdxPDFDocumentRepository; ASourceCatalog: TdxPDFCatalog;
      const APageIndexes: array of Integer; ATargetPageIndex: Integer; ACloneNonPageContent: Boolean); static;
    constructor Create(ARepository: TdxPDFDocumentRepository);
    destructor Destroy; override;
  end;

function dxPDFDefaultWriterContext: IdxPDFWriterContext; // for internal use

implementation

uses
  Math, Windows, dxCore, dxPDFTypes, dxPDFInteractivity, dxPDFAnnotation, dxPDFUtils, dxPDFDocument;

const
  dxThisUnitName = 'dxPDFContext';

type
  TdxPDFBaseAccess = class(TdxPDFBase);
  TdxPDFBookmarkAccess = class(TdxPDFBookmark);
  TdxPDFCustomTreeAccess = class(TdxPDFCustomTree);
  TdxPDFDocumentCustomWriterAccess = class(TdxPDFDocumentCustomWriter);
  TdxPDFDocumentNamesAccess = class(TdxPDFDocumentNames);
  TdxPDFDocumentRepositoryAccess = class(TdxPDFDocumentRepository);
  TdxPDFObjectAccess = class(TdxPDFObject);
  TdxPDFObjectListAccess = class(TdxPDFObjectList);
  TdxPDFPageAccess = class(TdxPDFPage);
  TdxPDFPageListAccess = class(TdxPDFPageList);
  TdxPDFResourcesAccess = class(TdxPDFResources);
  TdxPDFWriterAccess = class(TdxPDFWriter);

var
  dxgPDFDefaultWriteContext: TdxPDFWritingContext;

function dxPDFDefaultWriterContext: IdxPDFWriterContext;
begin
  if dxgPDFDefaultWriteContext = nil then
    dxgPDFDefaultWriteContext := TdxPDFWritingContext.Create;
  dxTestCheck(Supports(dxgPDFDefaultWriteContext, IdxPDFWriterContext, Result), 'IdxPDFWriterContext');
end;

{ TdxPDFWritingContext }

function TdxPDFWritingContext.FindColorSpaceName(const AName: string): string;
begin
  Result := AName;
end;

function TdxPDFWritingContext.FindFontName(const AName: string): string;
begin
  Result := AName;
end;

function TdxPDFWritingContext.FindGraphicsStateParameters(const AName: string): string;
begin
  Result := AName;
end;

function TdxPDFWritingContext.FindPatternName(const AName: string): string;
begin
  Result := AName;
end;

function TdxPDFWritingContext.FindShadingName(const AName: string): string;
begin
  Result := AName;
end;

function TdxPDFWritingContext.FindXObjectName(const AName: string): string;
begin
  Result := AName;
end;

function TdxPDFWritingContext.AllowPageParentReference: Boolean;
begin
  Result := True;
end;

function TdxPDFWritingContext.FindFormFieldName(const AName: string): string;
begin
  Result := AName;
end;

function TdxPDFWritingContext.GetDestinationName(const AName: string): string;
begin
  Result := AName;
end;

function TdxPDFWritingContext.GetObjectNumber(AObject: TdxPDFObject): Integer;
begin
  Result := AObject.Number;
end;

function TdxPDFWritingContext.GetUniqueName(ATree: TdxPDFCustomTree; const AName: string): string;
begin
  Result := AName;
end;

procedure TdxPDFWritingContext.AddDestinationName(const AName: string);
begin
  // do nothing
end;

procedure TdxPDFWritingContext.AddReference(ADictionary: TdxPDFWriterDictionary; AObject: TdxPDFObject;
  const ATypeKey, AKey: string);
begin
  ADictionary.AddReference(AKey, AObject);
end;

{ TdxPDFDocumentWritingContext }

constructor TdxPDFDocumentWritingContext.Create(AWriter: TObject);
begin
  inherited Create;
  FWriter := AWriter as TdxPDFDocumentCustomWriter;
end;

function TdxPDFDocumentWritingContext.GetObjectNumber(AObject: TdxPDFObject): Integer;
begin
  if not TdxPDFDocumentCustomWriterAccess(FWriter).WriteObjectList.Contains(AObject) then
  begin
    Result := TdxPDFDocumentCustomWriterAccess(FWriter).WriteObjectList.Add(AObject) + 1;
    AObject.Number := Result;
  end;
  Result := AObject.Number;
end;

{ TdxPDFCloningContext }

class procedure TdxPDFCloningContext.Clone(ARepository: TdxPDFDocumentRepository; ASourceCatalog: TdxPDFCatalog;
  const APageIndexes: array of Integer; ATargetPageIndex: Integer; ACloneNonPageContent: Boolean);
var
  AContext: TdxPDFCloningContext;
  ASourceNames, ANames: TdxPDFDocumentNamesAccess;
begin
  if Length(APageIndexes) = 0 then
    Exit;
  AContext := TdxPDFCloningContext.Create(ARepository);
  try
    ASourceNames := TdxPDFDocumentNamesAccess(ASourceCatalog.Names);
    ANames := TdxPDFDocumentNamesAccess(ARepository.Catalog.Names);
    AContext.Append(ASourceCatalog.AcroForm);
    AContext.Rename(ASourceNames.PageDestinations);
    AContext.Append(TdxPDFPageListAccess(ASourceCatalog.Pages).Items, APageIndexes, ATargetPageIndex);
    if ACloneNonPageContent then
    begin
      AContext.Append(ARepository.Catalog.Bookmarks, ASourceCatalog.Bookmarks);
      AContext.Append(ANames.EmbeddedFileSpecifications, ASourceNames.EmbeddedFileSpecifications);
      TdxPDFDocumentRepositoryAccess(ARepository).AddChange(dcData);
    end;
    AContext.Append(ANames.PageDestinations, ASourceNames.PageDestinations);
    TdxPDFDocumentRepositoryAccess(ARepository).UpdateStructure;
  finally
    AContext.Free;
  end;
end;

constructor TdxPDFCloningContext.Create(ARepository: TdxPDFDocumentRepository);
begin
  inherited Create;
  FRepository := ARepository;
  FClonedObjects := TdxObjectIntegerDictionary.Create;
  FColorSpaceNameMap := TdxPDFStringStringDictionary.Create;
  FDestinationNameMap := TdxPDFStringStringDictionary.Create;
  FFontNameMap := TdxPDFStringStringDictionary.Create;
  FFormFieldNameMap := TdxPDFStringStringDictionary.Create;
  FGraphicsStateParametersNameMap := TdxPDFStringStringDictionary.Create;
  FPatternNameMap := TdxPDFStringStringDictionary.Create;
  FShadingNameMap := TdxPDFStringStringDictionary.Create;
  FXObjectNameMap := TdxPDFStringStringDictionary.Create;
  FSourceObjectToCloneNumberMap := TdxObjectIntegerDictionary.Create;
  FSourceObjectToCloneList := TList.Create;
  FSourceObjectToCloneList.Capacity := 1024;
  FSharedTypes := TStringList.Create;
  FSharedTypes.Add(TdxPDFDocumentImage.GetTypeName);
  FSavedDestinationNameList := TdxPDFStringHashSet.Create;
  FWriterHelper := TdxPDFWriterHelper.Create(Self, FRepository.EncryptionInfo);
end;

destructor TdxPDFCloningContext.Destroy;
begin
  FreeAndNil(FWriterHelper);
  FreeAndNil(FSavedDestinationNameList);
  FreeAndNil(FSharedTypes);
  FreeAndNil(FSourceObjectToCloneList);
  FreeAndNil(FSourceObjectToCloneNumberMap);
  FreeAndNil(FXObjectNameMap);
  FreeAndNil(FShadingNameMap);
  FreeAndNil(FPatternNameMap);
  FreeAndNil(FGraphicsStateParametersNameMap);
  FreeAndNil(FFormFieldNameMap);
  FreeAndNil(FFontNameMap);
  FreeAndNil(FDestinationNameMap);
  FreeAndNil(FColorSpaceNameMap);
  FreeAndNil(FClonedObjects);
  inherited Destroy;
end;

function TdxPDFCloningContext.Execute(AObject: TdxPDFObject; out AObjectNumber: Integer): Boolean;
begin
  AObjectNumber := DoExecute(AObject);
  Result := TdxPDFUtils.IsIntegerValid(AObjectNumber);
end;

function TdxPDFCloningContext.FindColorSpaceName(const AName: string): string;
begin
  Result := GetName(FColorSpaceNameMap, AName);
end;

function TdxPDFCloningContext.FindFontName(const AName: string): string;
begin
  Result := GetName(FFontNameMap, AName);
end;

function TdxPDFCloningContext.FindFormFieldName(const AName: string): string;
begin
  Result := GetName(FFormFieldNameMap, AName);
end;

function TdxPDFCloningContext.FindGraphicsStateParameters(const AName: string): string;
begin
  Result := GetName(FGraphicsStateParametersNameMap, AName);
end;

function TdxPDFCloningContext.FindPatternName(const AName: string): string;
begin
  Result := GetName(FPatternNameMap, AName);
end;

function TdxPDFCloningContext.FindShadingName(const AName: string): string;
begin
  Result := GetName(FShadingNameMap, AName);
end;

function TdxPDFCloningContext.FindXObjectName(const AName: string): string;
begin
  Result := GetName(FXObjectNameMap, AName);
end;

function TdxPDFCloningContext.CloneDestination(AObject: TdxPDFObject): TdxPDFCustomDestination;
var
  ADestination: TdxPDFCustomDestination;
begin
  CloneAndCreateObject(AObject,
    procedure(AContext: TdxPDFWritingContext; ARawObject: TdxPDFBase)
    begin
      ADestination := FRepository.CreateDestination(ARawObject);
    end);
  Result := ADestination;
end;

function TdxPDFCloningContext.CloneObject(AObject: TdxPDFObject): Integer;
begin
  if AObject = nil then
    Exit(-1);
  dxTestCheck(Execute(AObject, Result), 'CloneObject is fail');
end;

function TdxPDFCloningContext.ClonePage(APage: TdxPDFPage): Integer;
var
  APageIndex: Integer;
begin
  APageIndex := -1;
  CloneAndCreateObject(APage,
    procedure(AContext: TdxPDFWritingContext; ARawObject: TdxPDFBase)
    begin
      APageIndex := TdxPDFPageListAccess(FRepository.Catalog.Pages).CreatePageNode(
        TdxPDFPageListAccess(FRepository.Catalog.Pages).NodeList, ARawObject as TdxPDFReaderDictionary);
    end);
  Result := APageIndex;
end;

procedure TdxPDFCloningContext.Append(ADestination, ASource: TdxPDFObjectList; ANameMap: TdxPDFStringStringDictionary);

  function GetUniqueKey(const AKey: string): string;
  begin
    Result := TdxPDFObjectListAccess(ADestination).GetUniqueName;
    ANameMap.Add(AKey, Result);
  end;

var
  AItem: TPair<string, TdxPDFReferencedObject>;
  AItemKey: string;
  ANewItem: TPair<string, TdxPDFObject>;
  ANewItems: TDictionary<string, TdxPDFObject>;
  AObject: TdxPDFObject;
begin
  if (ASource.Count = 0) or (ANameMap = nil) then
    Exit;
  ANewItems := TDictionary<string, TdxPDFObject>.Create;
  try
    for AItem in TdxPDFObjectListAccess(ASource).InternalObjects do
    begin
      if TdxPDFObjectListAccess(ADestination).InternalObjects.ContainsKey(AItem.Key) then
      begin
        AItemKey := GetUniqueKey(AItem.Key);
        AObject := TdxPDFObjectListAccess(ASource).GetObject(AItem.Key);
      end
      else
      begin
        AItemKey := AItem.Key;
        AObject := AItem.Value as TdxPDFObject;
      end;
      ANewItems.Add(AItemKey, AObject);
    end;

    for ANewItem in ANewItems do
      CloneAndCreateObject(ANewItem.Value,
        procedure(AContext: TdxPDFWritingContext; AObject: TdxPDFBase)
        begin
          TdxPDFObjectListAccess(ADestination).AddDeferredObject(ADestination.GetTypeName, ANewItem.Key, AObject);
        end);
  finally
    ANewItems.Free;
  end;
end;

procedure TdxPDFCloningContext.Append(ADestination, ASource: TdxPDFCustomTree);
var
  AKey: string;
  ALeafKeyList: TStringList;
begin
  ALeafKeyList := TStringList.Create;
  try
    for AKey in ASource.Keys do
      ALeafKeyList.Add(AKey);
    Append(ADestination, ASource, ALeafKeyList);
  finally
    ALeafKeyList.Free;
  end;
end;

procedure TdxPDFCloningContext.Append(ADestination, ASource: TdxPDFResources);
begin
  Append(TdxPDFResourcesAccess(ADestination).Fonts, TdxPDFResourcesAccess(ASource).Fonts, FFontNameMap);
  Append(TdxPDFResourcesAccess(ADestination).XObjects, TdxPDFResourcesAccess(ASource).XObjects, FXObjectNameMap);
  Append(TdxPDFResourcesAccess(ADestination).ColorSpaces, TdxPDFResourcesAccess(ASource).ColorSpaces, FColorSpaceNameMap);
  Append(TdxPDFResourcesAccess(ADestination).Patterns, TdxPDFResourcesAccess(ASource).Patterns, FPatternNameMap);
  Append(TdxPDFResourcesAccess(ADestination).Shadings, TdxPDFResourcesAccess(ASource).Shadings, FShadingNameMap);
  Append(TdxPDFResourcesAccess(ADestination).GraphicStatesParametersList,
    TdxPDFResourcesAccess(ASource).GraphicStatesParametersList, FGraphicsStateParametersNameMap);
end;

procedure TdxPDFCloningContext.Append(ASource: TdxPDFInteractiveForm);
begin
  if (ASource = nil) or (ASource.Fields.Count = 0) then
    Exit;
  if FRepository.Catalog.AcroForm.Resources <> nil then
    Append(FRepository.Catalog.AcroForm.Resources, ASource.Resources);
  RenameFields(FRepository.Catalog.AcroForm.Fields, ASource.Fields);
end;

procedure TdxPDFCloningContext.Append(ADestination, ASource: TdxPDFBookmarkList);
var
  I: Integer;
  AAction: TdxPDFCustomAction;
  ASourceBookmark, ANewBookmark: TdxPDFBookmark;
  ADestinationInfo: TdxPDFDestinationInfo;
begin
  for I := 0 to ASource.Count - 1 do
  begin
    ASourceBookmark := ASource[I];
    ADestinationInfo := TdxPDFBookmarkAccess(ASourceBookmark).DestinationInfo;
    if ADestinationInfo <> nil then
    begin
      if ADestinationInfo.Name <> '' then
      begin
        AddDestinationName(ADestinationInfo.Name);
        ADestinationInfo := TdxPDFDestinationInfo.Create(GetDestinationName(ADestinationInfo.Name));
      end
      else
        if ASourceBookmark.Destination = nil then
          ADestinationInfo := nil
        else
          ADestinationInfo := TdxPDFDestinationInfo.Create(CloneDestination(ASourceBookmark.Destination));
    end;
    AAction := ASourceBookmark.Action;
    if AAction <> nil then
      AAction := FRepository.GetAction(CloneObject(AAction));
    ANewBookmark := TdxPDFBookmark.Create(ADestinationInfo, ASourceBookmark, AAction);
    ADestination.Add(ANewBookmark);
    Append(ANewBookmark.Children, ASourceBookmark.Children);
  end;
  if ASource.Count > 0 then
    TdxPDFDocumentRepositoryAccess(FRepository).OutlinesChanged;
end;

procedure TdxPDFCloningContext.Append(ASource: TdxPDFInternalPageList; const APageIndexes: array of Integer;
  ATargetPageIndex: Integer);
var
  AAddedPageList, APageList: TdxPDFInternalPageList;
  I: Integer;
begin
  APageList := TdxPDFInternalPageList.Create;
  try
    APageList.AddRange(ASource);
    AAddedPageList := TdxPDFInternalPageList.Create;
    try
      for I := 0 to Length(APageIndexes) - 1 do
        AAddedPageList.Add(CloneAndAdd(APageList[APageIndexes[I]]));
      for I := 0 to AAddedPageList.Count - 1 do
      begin
        AAddedPageList[I].Move(ATargetPageIndex);
        Inc(ATargetPageIndex);
      end;
    finally
      AAddedPageList.Free;
    end;
  finally
    APageList.Free;
  end;
end;

procedure TdxPDFCloningContext.Rename(AExternalDestinations: TdxPDFDestinationTree);
var
  AName: string;
begin
  for AName in AExternalDestinations.Keys do
    if TdxPDFDocumentNamesAccess(FRepository.Catalog.Names).PageDestinations.ContainsKey(AName) then
      FDestinationNameMap.Add(AName, TdxPDFCustomTree.GetUniqueKey(FDestinationNameMap));
end;

procedure TdxPDFCloningContext.Append(ADestination, ASource: TdxPDFCustomTree; ALeafKeyList: TStringList);
var
  AKey: string;
  I: Integer;
begin
  for I := 0 to ALeafKeyList.Count - 1 do
  begin
    AKey := ALeafKeyList[I];
    CloneAndCreateObject(TdxPDFCustomTreeAccess(ASource).InternalGetValue(AKey),
      procedure(AContext: TdxPDFWritingContext; AObject: TdxPDFBase)
      begin
        TdxPDFCustomTreeAccess(ADestination).AddDeferredObject(
          TdxPDFCustomTreeAccess(ADestination).GetLeafName(AContext, AKey), AObject);
      end);
   end;
end;

function TdxPDFCloningContext.CloneAndAdd(ASource: TdxPDFPage): TdxPDFPage;
var
  AClonedPage: TdxPDFPage;
begin
  FRepository.Catalog.LockChanges(
    function: Boolean
    var
      APageIndex: Integer;
    begin
      APageIndex := ClonePage(ASource);
      Result := APageIndex <> -1;
      if Result then
      begin
        AClonedPage := FRepository.Catalog.Pages[APageIndex];
        TdxPDFPageAccess(AClonedPage).Data.ForEachWidgetAnnotation(
          procedure(AAnnotation: TdxPDFCustomAnnotation)
          begin
            FRepository.Catalog.AcroForm.Add(TdxPDFWidgetAnnotation(AAnnotation).Field);
          end);
      end;
    end);
  Result := AClonedPage;
end;

function TdxPDFCloningContext.DoExecute(AObject: TdxPDFObject): Integer;
var
  AIndex: Integer;
  AIndirectObject: TdxPDFIndirectObject;
  AObjectToClone: TdxPDFObject;
  AObjectNumber: Integer;
begin
  AObjectToClone := AObject;
  dxTestCheck(AObjectToClone <> nil, 'AObjectToClone = nil');
  dxTestCheck(FSourceObjectToCloneList.Count = 0, 'FSourceObjectToCloneList.Count <> 0');

  FStartObjectNumber := Max(1, FRepository.MaxObjectNumber);
  Result := FWriterHelper.RegisterIndirectObject(AObjectToClone);
  AIndex := 0;
  try
    while AIndex < FSourceObjectToCloneList.Count do
    begin
      AObjectToClone := FSourceObjectToCloneList[AIndex];
      if FSourceObjectToCloneNumberMap.TryGetValue(AObjectToClone, AObjectNumber) then
      begin
        AIndirectObject := TdxPDFIndirectObject.Create(AObjectNumber, 0, SaveToBytes(AObjectToClone, AObjectNumber));
        FRepository.Add(AIndirectObject.Number, AIndirectObject);
        FClonedObjects.Add(AObjectToClone, AIndirectObject.Number);
      end;
      Inc(AIndex);
    end;
    FSourceObjectToCloneList.Clear;
  except
    on E: EdxException do
      Result := dxPDFInvalidValue
    else
      raise;
  end;
end;

function TdxPDFCloningContext.GetName(AMap: TdxPDFStringStringDictionary; const AName: string): string;
begin
  if not AMap.TryGetValue(AName, Result) then
    Result := AName
  else
    Result := Result;
end;

function TdxPDFCloningContext.SaveToBytes(AObject: TdxPDFObject; AObjectNumber: Integer): TBytes;
var
  AData: TdxPDFBase;
  AWriter: TdxPDFWriter;
begin
  AData := TdxPDFObjectAccess(AObject).Write(FWriterHelper);
  AData.Reference;
  AWriter := TdxPDFWriter.Create(TdxPDFMemoryStream.Create, True);
  try
    TdxPDFWriterAccess(AWriter).FEncryptionInfo := FRepository.EncryptionInfo;
    TdxPDFWriterAccess(AWriter).FCurrentObjectNumber := AObjectNumber;
    TdxPDFBaseAccess(AData).Write(AWriter);
    Result := TdxPDFMemoryStream(AWriter.Stream).Data;
  finally
    AWriter.Free;
    AData.Release;
  end;
end;

function TdxPDFCloningContext.TryGetName(AMap: TdxPDFStringStringDictionary; const AKey: string;
  out AName: string): Boolean;
begin
  AName := GetName(AMap, AKey);
  Result := AName <> AKey;
end;

function TdxPDFCloningContext.TryGetObjectNumber(AObject: TdxPDFObject; out ANumber: Integer): Boolean;
begin
  Result := FClonedObjects.TryGetValue(AObject, ANumber) or FSourceObjectToCloneNumberMap.TryGetValue(AObject, ANumber);
end;

function TdxPDFCloningContext.TryGetSharedObjectNumber(AObject: TdxPDFObject; out ANumber: Integer): Boolean;
begin
  Result := (FRepository = TdxPDFObjectAccess(AObject).Repository) and (FSharedTypes.IndexOf(AObject.GetTypeName) <> -1);
  if Result then
    ANumber := AObject.Number;
end;

procedure TdxPDFCloningContext.CloneAndCreateObject(AObject: TdxPDFObject;
  ACreateProc: TProc<TdxPDFWritingContext, TdxPDFBase>);

  function GetRawObject(ANumber: Integer; out AObject: TdxPDFBase): Boolean;
  begin
    Result := FRepository.TryGetDictionaryObject(ANumber, AObject) or FRepository.TryGetObject(ANumber, AObject);
  end;

var
  AObjectNumber: Integer;
  ARawObject: TdxPDFBase;
begin
  if (AObject <> nil) and Execute(AObject, AObjectNumber) and GetRawObject(AObjectNumber, ARawObject) then
    ACreateProc(Self, ARawObject);
end;

procedure TdxPDFCloningContext.RenameFields(AFields, AExternalFields: TdxPDFInteractiveFormFieldCollection);
const
  FieldNamePrefix = '_Field';
var
  AFormField: TdxPDFInteractiveFormField;
  AFormFieldName, AName: string;
  ALastRenamedFormFieldNumber: Integer;
  ANames: TdxPDFStringHashSet;
  I: Integer;
begin
  if AFields.Count = 0 then
    Exit;
  ALastRenamedFormFieldNumber := 0;
  ANames := TdxPDFStringHashSet.Create;
  try
    for I := 0 to AFields.Count - 1 do
      ANames.Include(AFields.Items[I].Name);

    for I := 0 to AExternalFields.Count - 1 do
    begin
      AFormField := AExternalFields.Items[I];
      AFormFieldName := AFormField.Name;
      if (AFormFieldName <> '') and ANames.Contains(AFormFieldName) then
      begin
        AName := AFormFieldName + FieldNamePrefix + IntToStr(ALastRenamedFormFieldNumber);
        while ANames.Contains(AName) do
        begin
          Inc(ALastRenamedFormFieldNumber);
          AName := FieldNamePrefix + IntToStr(ALastRenamedFormFieldNumber);
        end;
        if not FFormFieldNameMap.ContainsKey(AFormFieldName) then
        begin
          FFormFieldNameMap.Add(AFormFieldName, AName);
          ANames.Include(AName);
        end;
      end;
    end;
  finally
    ANames.Free;
  end;
end;

function TdxPDFCloningContext.AllowPageParentReference: Boolean;
begin
  Result := False;
end;

function TdxPDFCloningContext.GetDestinationName(const AName: string): string;
begin
  if not FDestinationNameMap.TryGetValue(AName, Result) then
    Result := AName;
end;

function TdxPDFCloningContext.GetObjectNumber(AObject: TdxPDFObject): Integer;
begin
  dxTestCheck(AObject <> nil, 'AObjectToClone = nil');
  if not TryGetObjectNumber(AObject, Result) then
    if not TryGetSharedObjectNumber(AObject, Result) and not FSourceObjectToCloneNumberMap.TryGetValue(AObject, Result) then
    begin
      Result := FStartObjectNumber + FSourceObjectToCloneList.Add(AObject) + 1;
      FSourceObjectToCloneNumberMap.Add(AObject, Result);
    end;
end;

function TdxPDFCloningContext.GetUniqueName(ATree: TdxPDFCustomTree; const AName: string): string;
begin
  Result := ATree.GetUniqueKey;
end;

procedure TdxPDFCloningContext.AddDestinationName(const AName: string);
begin
  if AName <> '' then
    FSavedDestinationNameList.Include(AName);
end;

procedure TdxPDFCloningContext.AddReference(ADictionary: TdxPDFWriterDictionary; AObject: TdxPDFObject;
  const ATypeKey, AKey: string);
var
  AMap: TdxPDFStringStringDictionary;
  AActualKey: string;
begin
  if ATypeKey = TdxPDFFonts.GetTypeName then
    AMap := FFontNameMap
  else

  if ATypeKey = TdxPDFColorSpaces.GetTypeName then
    AMap := FColorSpaceNameMap
  else

  if ATypeKey = TdxPDFPatterns.GetTypeName then
    AMap := FPatternNameMap
  else

  if ATypeKey = TdxPDFShadings.GetTypeName then
    AMap := FShadingNameMap
  else

  if ATypeKey = TdxPDFGraphicsStateParameters.GetTypeName then
    AMap := FGraphicsStateParametersNameMap
  else
    AMap := nil;

  if (AMap = nil) or not TryGetName(AMap, AKey, AActualKey) then
    AActualKey := AKey;
  ADictionary.AddReference(AActualKey, AObject);
end;


initialization

finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  FreeAndNil(dxgPDFDefaultWriteContext);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.

