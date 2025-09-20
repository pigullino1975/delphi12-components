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

unit dxPDFFormData;

{$I cxVer.inc}

interface

uses
  Types, Classes, Generics.Defaults, Generics.Collections, dxPDFBase, dxPDFTypes;

type
  TdxPDFFormDataFormat = (dfFDF, dfXFDF, dfXML, dfTXT);

  { TdxPDFFormDataValue }

  TdxPDFFormDataValue = class // for internal use
  strict protected
    FValue: TStringList;
    //
    function GetFieldType: TdxPDFInteractiveFormFieldType; virtual;
    function GetValue: TStringList; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Reset; virtual;
    //
    property FieldType: TdxPDFInteractiveFormFieldType read GetFieldType;
    property Value: TStringList read GetValue;
  end;

  { TdxPDFFormData }

  TdxPDFFormData = class // for internal use
  strict private
    FItems: TdxPDFStringObjectDictionary<TdxPDFFormData>;
    FName: string;
    FValue: TdxPDFFormDataValue;
    //
    function GetFieldType: TdxPDFInteractiveFormFieldType;
    function GetItem(const AKey: string): TdxPDFFormData;
    function GetValue: string;
    function GetValues: TStringList;
    procedure SetItem(const AKey: string; AValue: TdxPDFFormData);
    procedure SetValue(const AValue: string);
  protected
    class function DetectFormat(AStream: TStream): TdxPDFFormDataFormat; static;
    function IsPasswordField: Boolean;
    function GetValueAsString: string;
    //
    property Dictionary: TdxPDFStringObjectDictionary<TdxPDFFormData> read FItems;
  public
    constructor Create; overload;
    constructor Create(AField: TObject); overload; // for internal use
    destructor Destroy; override;
    //
    procedure Assign(AData: TdxPDFFormData);
    procedure LoadFromFile(const AFileName: string); overload;
    procedure LoadFromStream(AStream: TStream); overload;
    procedure LoadFromStream(AStream: TStream; AFormat: TdxPDFFormDataFormat); overload;
    procedure Reset;
    procedure SaveToFile(const AFileName: string); overload;
    procedure SaveToStream(AStream: TStream; AFormat: TdxPDFFormDataFormat); overload;
    //
    property FieldType: TdxPDFInteractiveFormFieldType read GetFieldType;
    property Items[const AKey: string]: TdxPDFFormData read GetItem write SetItem; default;
    property Name: string read FName;
    property Value: string read GetValue write SetValue;
    property Values: TStringList read GetValues;
  end;

function dxPDFFormDataFormatFileExtension(AFormat: TdxPDFFormDataFormat): string;

implementation

uses
  Variants, Math, IOUtils, StrUtils, SysUtils,
  dxCore, dxStringHelper, cxVariants, dxXMLDoc, dxPDFCore, dxPDFParser, dxPDFDocument, dxPDFUtils;

const
  dxThisUnitName = 'dxPDFFormData';

const
  dxFDFVersion = '1.2';
  dxPDFXFDF = 'xfdf';
  dxPDFXFDFAttributeName = 'name';
  dxPDFXFDFField = 'field';
  dxPDFXFDFFields = 'fields';
  dxPDFXFDFNamespace = 'http://ns.adobe.com/xfdf/';
  dxPDFXXFDFXFDOriginalAttributeName = 'http://ns.adobe.com/xfdf-transition/';
  dxPDFXXFDFXFDOriginalAttributeShortName = 'xfdf:original';

type
  { TdxPDFFormDataFieldValue }

  TdxPDFFormDataFieldValue = class(TdxPDFFormDataValue)
  strict private
    FField: TdxPDFInteractiveFormField;
    //
    procedure OnValueChanged(ASender: TObject);
  strict protected
    function GetFieldType: TdxPDFInteractiveFormFieldType; override;
    function GetValue: TStringList; override;
  public
    constructor Create(AField: TdxPDFInteractiveFormField);
    //
    procedure Reset; override;
  end;

  { TdxFDFDocumentReader }

  TdxFDFDocumentReader = class
  strict private
    FRepository: TdxPDFDocumentRepository;
    FStream: TMemoryStream;
    FRootObjectNumber: Integer;
    //
    function FindFields(out AFields: TdxPDFArray): Boolean;
    function FindTrailerPositionAndReadObjects(out ATrailerPosition: Int64): Boolean;
    function ReadRootObjectNumber(ATrailerPosition: Int64): Boolean;
    function ReadTrailerData: TBytes;
    procedure ReadField(AData: TdxPDFFormData; const AParentName: string; ADictionary: TdxPDFDictionary);
    procedure ReadFields(AFields: TdxPDFArray; AData: TdxPDFFormData; const AParentName: string);
  public
    constructor Create(ADocument: TdxPDFDocument; AStream: TStream);
    destructor Destroy; override;
    //
    procedure Read(AData: TdxPDFFormData);
  end;

  { TdxPDFFormDataReader }

  TdxPDFFormDataReader = class
  strict private
    FData: TdxPDFFormData;
    procedure ReadFDF(AStream: TStream);
    procedure ReadTXT(AStream: TStream);
    procedure ReadXML(AStream: TStream);
    procedure ReadXMLNode(ANode: TdxXMLNode);
  public
    constructor Create(AData: TdxPDFFormData);
    procedure Read(AStream: TStream; AFormat: TdxPDFFormDataFormat);
  end;

  { TdxFDFCatalog }

  TdxFDFCatalog = class(TdxPDFObject)
  strict private
    FData: TdxPDFFormData;
    function CreateDictionary(AHelper: TdxPDFWriterHelper; AData: TdxPDFFormData; AOnlyKids: Boolean): TdxPDFDictionary;
  protected
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    constructor Create(AData: TdxPDFFormData);
  end;

  { TdxFDFWriter }

  TdxFDFWriter = class(TdxPDFDocumentCustomWriter)
  strict private
    FCatalog: TdxFDFCatalog;
  strict protected
    function GetVersion: string; override;
    function HasXRef: Boolean; override;
    procedure PopulateTrailer(ADictionary: TdxPDFWriterDictionary); override;
    procedure RegisterTrailerObjects; override;
  public
    constructor Create(AStream: TStream; ACatalog: TdxFDFCatalog);
  end;

  { TdxPDFFormDataWriterPair }

  TdxPDFFormDataWriterPair = record
  public
    Data: TdxPDFFormData;
    Key: string;
    class function Create(const AKey: string; AData: TdxPDFFormData): TdxPDFFormDataWriterPair; static;
  end;

  TdxPDFFormDataWriterWriteProc = reference to procedure(const AKey: string; AValue: TStringList);

  { TdxPDFFormDataWriter }

  TdxPDFFormDataWriter = class
  strict private
    FData: TdxPDFFormData;
    procedure WriteData(AWriteProc: TdxPDFFormDataWriterWriteProc);
    procedure WriteFDF(AStream: TStream);
    procedure WriteTXT(AStream: TStream);
    procedure WriteXFDF(AStream: TStream);
    procedure WriteXML(AStream: TStream);
  public
    class procedure Write(AStream: TStream; AData: TdxPDFFormData; AFormat: TdxPDFFormDataFormat); static;
    constructor Create(AData: TdxPDFFormData);
  end;

function dxPDFFormDataFormatFileExtension(AFormat: TdxPDFFormDataFormat): string;
const
  Map: array[TdxPDFFormDataFormat] of string = ('fdf', 'xfd', 'xml', 'txt');
begin
  Result := Map[AFormat];
end;

procedure dxPDFFormDataRaiseException;
begin
  TdxPDFUtils.RaiseException('An error occurred while reading the form data from the specified stream.');
end;

{ TdxPDFFormDataValue }

constructor TdxPDFFormDataValue.Create;
begin
  inherited Create;
  FValue := TStringList.Create;
end;

destructor TdxPDFFormDataValue.Destroy;
begin
  FreeAndNil(FValue);
  inherited Destroy;
end;

procedure TdxPDFFormDataValue.Reset;
begin
  FValue.Clear;
end;

function TdxPDFFormDataValue.GetFieldType: TdxPDFInteractiveFormFieldType;
begin
  Result := ftUnknown;
end;

function TdxPDFFormDataValue.GetValue: TStringList;
begin
  Result := FValue;
end;

{ TdxPDFFormDataFieldValue }

constructor TdxPDFFormDataFieldValue.Create(AField: TdxPDFInteractiveFormField);
begin
  inherited Create;
  FField := AField;
  FValue.OnChange := OnValueChanged;
end;

function TdxPDFFormDataFieldValue.GetFieldType: TdxPDFInteractiveFormFieldType;
begin
  Result := FField.FieldType;
end;

function TdxPDFFormDataFieldValue.GetValue: TStringList;
begin
  Result := inherited GetValue;
  Result.OnChange := nil;
  Result.Assign(FField.ExportValueList);
  FValue.OnChange := OnValueChanged;
end;

procedure TdxPDFFormDataFieldValue.OnValueChanged(ASender: TObject);
begin
  FField.SetExportEditValue(TdxPDFInteractiveFormCustomFieldEditValue.PrepareValue(FValue.Text));
end;

procedure TdxPDFFormDataFieldValue.Reset;
begin
  inherited Reset;
  FField.ResetEditValue;
end;

{ TdxPDFFormData }

constructor TdxPDFFormData.Create;
begin
  inherited Create;
  FItems := TdxPDFStringObjectDictionary<TdxPDFFormData>.Create([doOwnsValues]);
  FValue := TdxPDFFormDataValue.Create;
end;

constructor TdxPDFFormData.Create(AField: TObject);
begin
  Create;
  FreeAndNil(FValue);
  FValue := TdxPDFFormDataFieldValue.Create(AField as TdxPDFInteractiveFormField);
end;

destructor TdxPDFFormData.Destroy;
begin
  FreeAndNil(FItems);
  FreeAndNil(FValue);
  inherited Destroy;
end;

procedure TdxPDFFormData.Assign(AData: TdxPDFFormData);
var
  ADestinationData, ASourceData: TdxPDFFormData;
begin
  if (AData = nil) or (AData.Name <> Name) then
    Exit;
  Value := AData.Value;
  for ASourceData in AData.FItems.Values do
    if FItems.TryGetValue(ASourceData.Name, ADestinationData) then
      ADestinationData.Assign(ASourceData);
end;

procedure TdxPDFFormData.LoadFromFile(const AFileName: string);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    LoadFromStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TdxPDFFormData.LoadFromStream(AStream: TStream);
begin
  LoadFromStream(AStream, DetectFormat(AStream));
end;

procedure TdxPDFFormData.LoadFromStream(AStream: TStream; AFormat: TdxPDFFormDataFormat);
var
  AReader: TdxPDFFormDataReader;
begin
  AReader := TdxPDFFormDataReader.Create(Self);
  try
    AReader.Read(AStream, AFormat);
  finally
    AReader.Free;
  end;
end;

procedure TdxPDFFormData.Reset;
var
  AData: TdxPDFFormData;
begin
  if FValue <> nil then
    FValue.Reset;
  for AData in FItems.Values do
    AData.Reset;
end;

procedure TdxPDFFormData.SaveToFile(const AFileName: string);

  function DetectFormat: TdxPDFFormDataFormat;
  var
    AExtension: string;
  begin
    AExtension := LowerCase(ReplaceStr(TPath.GetExtension(AFileName), '.', ''));
    if AExtension = 'xml' then
      Result := dfXML
    else
      if AExtension = 'xfd' then
        Result := dfXFDF
      else
        if AExtension = 'fdf' then
          Result := dfFDF
        else
          Result := dfTXT;
  end;

var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveToStream(AStream, DetectFormat);
  finally
    AStream.Free;
  end;
end;

procedure TdxPDFFormData.SaveToStream(AStream: TStream; AFormat: TdxPDFFormDataFormat);
begin
  TdxPDFFormDataWriter.Write(AStream, Self, AFormat);
end;

function TdxPDFFormData.GetFieldType: TdxPDFInteractiveFormFieldType;
begin
  Result := FValue.FieldType;
end;

class function TdxPDFFormData.DetectFormat(AStream: TStream): TdxPDFFormDataFormat;

  function ReadMarker: AnsiString;
  const
    BOM: packed array[0..2] of Byte = ($EF, $BB, $BF);
    Size = 50;
  var
    APosition: Integer;
  begin
    Result := '';
    SetLength(Result, Size);
    APosition := AStream.Position;
    try
      AStream.Read(Result[1], Min(Size, AStream.Size));
      if CompareMem(@Result[1], @BOM, 3) then
        Delete(Result, 1, 3);
    finally
      AStream.Position := APosition;
    end;
  end;

var
  AFirstLine: string;
begin
  AFirstLine := dxAnsiStringToString(ReadMarker);
  if TdxStringHelper.StartsWith(AFirstLine, '%FDF-') then
    Result := dfFDF
  else
    if TdxStringHelper.StartsWith(AFirstLine, '<?xml') then
      Result := dfXML
    else
      Result := dfTXT;
end;

function TdxPDFFormData.IsPasswordField: Boolean;
begin
  Result := False;
end;

function TdxPDFFormData.GetValueAsString: string;
begin
  Result := Value;
end;

function TdxPDFFormData.GetItem(const AKey: string): TdxPDFFormData;
var
  ASplittedName: TStringDynArray;
begin
  if not FItems.TryGetValue(AKey, Result) then
  begin
    ASplittedName := TdxPDFUtils.SplitFieldName(AKey);
    if Length(ASplittedName) > 1 then
      Exit(FItems[ASplittedName[0]][ASplittedName[1]]);
    Result := TdxPDFFormData.Create;
    Result.FName := AKey;
    FItems.Add(AKey, Result);
  end;
end;

function TdxPDFFormData.GetValue: string;
begin
  Result := TdxPDFInteractiveFormCustomFieldEditValue.PrepareValue(FValue.Value.Text);
end;

function TdxPDFFormData.GetValues: TStringList;
begin
  Result := FValue.Value;
end;

procedure TdxPDFFormData.SetItem(const AKey: string; AValue: TdxPDFFormData);
begin
  if AValue = nil then
    FItems.Remove(AKey)
  else
  begin
    AValue.FName := AKey;
    FItems.AddOrSetValue(AKey, AValue);
  end;
end;

procedure TdxPDFFormData.SetValue(const AValue: string);
begin
  FValue.Value.Text := AValue;
end;

{ TdxFDFDocumentReader }

constructor TdxFDFDocumentReader.Create(ADocument: TdxPDFDocument; AStream: TStream);
begin
  inherited Create;
  FStream := TMemoryStream.Create;
  FStream.LoadFromStream(AStream);
  FRepository := TdxPDFDocumentRepository.Create(ADocument, FStream);
end;

destructor TdxFDFDocumentReader.Destroy;
begin
  FreeAndNil(FRepository);
  inherited Destroy;
end;

procedure TdxFDFDocumentReader.Read(AData: TdxPDFFormData);
var
  AFields: TdxPDFArray;
  ATrailerPosition: Int64;
begin
  TdxPDFUtils.ReadLine(FStream);
  if FindTrailerPositionAndReadObjects(ATrailerPosition) and ReadRootObjectNumber(ATrailerPosition) and FindFields(AFields) then
    ReadFields(AFields, AData, '')
  else
    dxPDFFormDataRaiseException;
end;

procedure TdxFDFDocumentReader.ReadField(AData: TdxPDFFormData; const AParentName: string; ADictionary: TdxPDFDictionary);

  procedure ConvertTo(ASource: TdxPDFArray; ADestination: TStringList);
  var
    AValue: TdxPDFBase;
    I: Integer;
  begin
    ADestination.Clear;
    for I := 0 to ASource.Count - 1 do
    begin
      AValue := ASource.ElementList[I];
      if AValue.ObjectType = otString then
        ADestination.Add(TdxPDFString(AValue).Value);
    end;
  end;

var
  AKey: string;
  AValueAsArray: TdxPDFArray;
  AValueAsString: string;
begin
  AKey := ADictionary.GetString(TdxPDFKeywords.FDFField);
  if AParentName <> '' then
    AKey := AParentName + TdxPDFUtils.FieldNameDelimiter + AKey;
  if ADictionary.TryGetArray(TdxPDFKeywords.ShortValue, AValueAsArray) then
    ConvertTo(AValueAsArray, AData[AKey].Values)
  else
    if ADictionary.TryGetTextString(TdxPDFKeywords.ShortValue, AValueAsString) then
      AData[AKey].Value := AValueAsString
    else
      if ADictionary.TryGetArray(TdxPDFKeywords.Kids, AValueAsArray) then
        ReadFields(AValueAsArray, AData, AKey)
end;

procedure TdxFDFDocumentReader.ReadFields(AFields: TdxPDFArray; AData: TdxPDFFormData; const AParentName: string);
var
  AValue: TdxPDFBase;
begin
  for AValue in AFields.ElementList do
    if AValue.ObjectType = otDictionary then
      ReadField(AData, AParentName, TdxPDFDictionary(AValue));
end;

function TdxFDFDocumentReader.FindFields(out AFields: TdxPDFArray): Boolean;
var
  ADictionary: TdxPDFDictionary;
begin
  Result := FRepository.TryGetDictionary(FRootObjectNumber, ADictionary) and
    ADictionary.TryGetDictionary(TdxPDFKeywords.FDF, ADictionary) and ADictionary.TryGetArray(TdxPDFKeywords.Fields, AFields);
end;

function TdxFDFDocumentReader.FindTrailerPositionAndReadObjects(out ATrailerPosition: Int64): Boolean;
var
  AObject: TdxPDFBase;
  AToken: TdxPDFTokenDescription;
begin
  try
    FRepository.Parser.SaveCurrentPosition;
    FRepository.Parser.SkipSpaces;
    FRepository.Parser.RestoreCurrentPosition;
    AToken := TdxPDFTokenDescription.Create(TdxPDFKeywords.Trailer);
    try
      if FRepository.Parser.FindToken(AToken) then
      begin
        ATrailerPosition := FStream.Position;
        FRepository.Parser.RestoreCurrentPosition;
        repeat
          FRepository.Parser.SaveCurrentPosition;
          if FRepository.Parser.ReadToken(AToken) then
            Break;
         FRepository.Parser.RestoreCurrentPosition;
          AObject := FRepository.Parser.ReadObject(FRepository.Parser.Position);
          if AObject <> nil then
            FRepository.Add(AObject.Number, AObject);
        until not FRepository.Parser.IsEOF;
      end
    finally
      AToken.Free;
    end;
    Result := True;
  except
    Result := False;
  end;
end;

function TdxFDFDocumentReader.ReadRootObjectNumber(ATrailerPosition: Int64): Boolean;
var
  AData: TBytes;
  ATrailer: TdxPDFDictionary;
begin
  FStream.Position := ATrailerPosition;
  AData := ReadTrailerData;
  ATrailer := FRepository.Parser.ReadDictionary(AData);
  try
    Result := (ATrailer <> nil) and ATrailer.TryGetReference(TdxPDFKeywords.Root, FRootObjectNumber);
  finally
    dxPDFFreeObject(ATrailer);
  end;
end;

function TdxFDFDocumentReader.ReadTrailerData: TBytes;
var
  ASymbol: Byte;
  AToken: TdxPDFTokenDescription;
begin
  SetLength(Result, 0);
  AToken := TdxPDFTokenDescription.Create(TdxPDFKeywords.EOF);
  try
    while not FRepository.Parser.IsEOF do
    begin
      ASymbol := FRepository.Parser.ReadByte;
      TdxPDFUtils.AddByte(ASymbol, Result);
      if AToken.Compare(ASymbol) then
      begin
        TdxPDFUtils.DeleteData(Length(Result) - AToken.SequenceLength, AToken.SequenceLength, Result);
        Break;
      end;
    end;
  finally
    AToken.Free;
  end;
end;

{ TdxPDFFormDataReader }

procedure TdxPDFFormDataReader.Read(AStream: TStream; AFormat: TdxPDFFormDataFormat);
begin
  try
    case AFormat of
      dfFDF:
        ReadFDF(AStream);
      dfXML, dfXFDF:
        ReadXML(AStream);
    else
      ReadTXT(AStream);
    end;
  except
    dxPDFFormDataRaiseException;
  end;
end;

constructor TdxPDFFormDataReader.Create(AData: TdxPDFFormData);
begin
  inherited Create;
  FData := AData;
end;

procedure TdxPDFFormDataReader.ReadFDF(AStream: TStream);
var
  AReader: TdxFDFDocumentReader;
begin
  AReader := TdxFDFDocumentReader.Create(nil, AStream);
  try
    AReader.Read(FData);
  finally
    AReader.Free;
  end;
end;

procedure TdxPDFFormDataReader.ReadTXT(AStream: TStream);

  procedure ReadData(out ANames, AValues: TStringDynArray);
  var
    ANameLine: string;
    AReader: TStringReader;
    AStringList: TStringList;
    AText: string;
    AValueLine: string;
  begin
    AStringList := TStringList.Create;
    try
      AStringList.LoadFromStream(AStream);
      AText := AStringList.Text;
    finally
      AStringList.Free;
    end;

    AReader := TStringReader.Create(AText);
    try
      ANameLine := AReader.ReadLine;
      AValueLine := TdxStringHelper.TrimEnd(AReader.ReadToEnd, [#10, #13]);
    finally
      AReader.Free;
    end;

    if (ANameLine <> '') and (AValueLine <> '') then
    begin
      ANames := TdxPDFUtils.Split(ANameLine, #9);
      AValues := TdxPDFUtils.Split(AValueLine, #9);
    end;
  end;

  procedure ConvertTo(const ASource: TArray<string>; ADestination: TStringList);
  var
    I: Integer;
  begin
    ADestination.Clear;
    for I := 0 to Length(ASource) - 1 do
      ADestination.Add(ASource[I]);
  end;

var
  AKeyCount, AValueCount, I: Integer;
  AName, AValue: string;
  ANames, AValues: TStringDynArray;
begin
  ReadData(ANames, AValues);

  AKeyCount := Length(ANames);
  AValueCount := Length(AValues);
  if (AKeyCount > 0) and (AValueCount > 0) then
  begin
    for I := 0 to AKeyCount - 1 do
    begin
      AName := ANames[I];
      if I < AValueCount then
        AValue := AValues[I]
      else
        AValue := '';
      if TdxStringHelper.StartsWith(AValue, '"') then
      begin
        AValue := TdxStringHelper.Substring(AValue, 1, Length(AValue) - 2);
        AValue := ReplaceStr(AValue, '""', '"');
        ConvertTo(TdxStringHelper.Split(AValue, [dxCRLF]), FData.Items[AName].Values);
      end
      else
        FData.Items[AName].Value := AValue;
    end;
  end;
end;

procedure TdxPDFFormDataReader.ReadXML(AStream: TStream);
var
  AData: TdxXMLDocument;
  AFields: TdxXMLNode;
begin
  AData := TdxXMLDocument.Create;
  try
    AData.LoadFromStream(AStream);
    if AData.Root.FindChild(dxPDFXFDFFields, AFields) or AData.Root.FindChild(dxPDFXFDF, AFields) then
    begin
      if AFields.NameAsString = dxPDFXFDF then
        AFields := AFields.FindChild(dxPDFXFDFFields);
      if (AFields <> nil) and (AFields.NameAsString = dxPDFXFDFFields) then
        AFields.ForEach(
          procedure(ANode: TdxXMLNode; AUserData: Pointer)
          begin
            ReadXMLNode(ANode);
          end);
    end;
  finally
    AData.Free;
  end;
end;

procedure TdxPDFFormDataReader.ReadXMLNode(ANode: TdxXMLNode);
var
  AAttribute: TdxXMLNodeAttribute;
  AName: string;
  AValues: TStringDynArray;
  I: Integer;
begin
  if ANode.Attributes.Find(dxPDFXFDFAttributeName, AAttribute) or
     ANode.Attributes.Find(dxPDFXXFDFXFDOriginalAttributeName + 'original', AAttribute) or
     ANode.Attributes.Find(dxPDFXXFDFXFDOriginalAttributeShortName, AAttribute) then
    AName := AAttribute.ValueAsString
  else
    AName := ANode.NameAsString;
  SetLength(AValues, 0);
  ANode.ForEach(
    procedure(ANode: TdxXMLNode; AUserData: Pointer)
    begin
      TdxPDFUtils.AddValue(ANode.TextAsString, AValues);
    end);
  case Length(AValues) of
    0:
      FData.Items[AName].Value := ANode.TextAsString;
    1:
      FData.Items[AName].Value := AValues[0];
  else
    for I := 0 to Length(AValues) - 1 do
      FData.Items[AName].Values.Add(AValues[I]);
  end;
end;

{ TdxPDFFormDataWriter }

class procedure TdxPDFFormDataWriter.Write(AStream: TStream; AData: TdxPDFFormData; AFormat: TdxPDFFormDataFormat);
var
  AWriter: TdxPDFFormDataWriter;
begin
  AWriter := TdxPDFFormDataWriter.Create(AData);
  try
    case AFormat of
      dfFDF:
        AWriter.WriteFDF(AStream);
      dfXML:
        AWriter.WriteXML(AStream);
      dfXFDF:
        AWriter.WriteXFDF(AStream);
    else
      AWriter.WriteTXT(AStream);
    end;
  finally
    AWriter.Free;
  end;
end;

constructor TdxPDFFormDataWriter.Create(AData: TdxPDFFormData);
begin
  inherited Create;
  FData := AData;
end;

procedure TdxPDFFormDataWriter.WriteData(AWriteProc: TdxPDFFormDataWriterWriteProc);
var
  AChildForm: TdxPDFFormData;
  AItem: TdxPDFFormDataWriterPair;
  APair: TPair<string, TdxPDFFormData>;
  AQueue: TQueue<TdxPDFFormDataWriterPair>;
begin
  AQueue := TQueue<TdxPDFFormDataWriterPair>.Create;
  try
    for APair in FData.Dictionary do
      AQueue.Enqueue(TdxPDFFormDataWriterPair.Create(APair.Key, APair.Value));
    while AQueue.Count > 0 do
    begin
      AItem := AQueue.Dequeue;
      AWriteProc(AItem.Key, AItem.Data.Values);
      for AChildForm in AItem.Data.Dictionary.Values do
        AQueue.Enqueue(TdxPDFFormDataWriterPair.Create(AItem.Key + TdxPDFUtils.FieldNameDelimiter + AChildForm.Name, AChildForm))
    end;
  finally
    AQueue.Free;
  end;
end;

procedure TdxPDFFormDataWriter.WriteFDF(AStream: TStream);
var
  ACatalog: TdxFDFCatalog;
  AWriter: TdxFDFWriter;
begin
  ACatalog := TdxFDFCatalog.Create(FData);
  try
    AWriter := TdxFDFWriter.Create(AStream, ACatalog);
    try
      AWriter.Write;
    finally
      AWriter.Free;
    end;
  finally
    ACatalog.Free;
  end;
end;

procedure TdxPDFFormDataWriter.WriteTXT(AStream: TStream);
var
  ANames, AValues: string;
begin
  WriteData(
    procedure(const AName: string; AValue: TStringList)
    var
      ACurrentValue: string;
      I: Integer;
    begin
      ANames := ANames + AName + #9;
      if AValue.Count = 1 then
        AValues := AValues + Trim(AValue.Text) + #9
      else
      begin
        ACurrentValue := AValues + '"';
        for I := 0 to AValue.Count - 1 do
        begin
          ACurrentValue := ACurrentValue + Trim(AValue[I]);
          if I < AValue.Count - 1 then
            ACurrentValue := ACurrentValue + dxCRLF;
        end;
        AValues := ACurrentValue + '"' + #9;
      end;
    end);
  WriteStringToStream(AStream, dxStringToAnsiString(ANames));
  WriteStringToStream(AStream, dxCRLF);
  WriteStringToStream(AStream, dxStringToAnsiString(AValues));
  WriteStringToStream(AStream, dxCRLF);
end;

procedure TdxPDFFormDataWriter.WriteXML(AStream: TStream);
var
  ADocument: TdxXMLDocument;
  AFields: TdxXMLNode;
begin
  ADocument := TdxXMLDocument.Create;
  try
    ADocument.AutoIndent := True;
    AFields := ADocument.Root.AddChild(dxPDFXFDFFields);
    AFields.Attributes.Add('xmlns:xfdf', dxPDFXXFDFXFDOriginalAttributeName);
    WriteData(
      procedure(const AName: string; AValue: TStringList)
      var
        AField: TdxXMLNode;
        ANeedOriginalAttribute: Boolean;
        I: Integer;
      begin
        ANeedOriginalAttribute := TdxStringHelper.Contains(AName, ' ');
        AField := AFields.AddChild(dxStringToXMLString(TdxStringHelper.Replace(AName, ' ', '')));
        if ANeedOriginalAttribute then
          AField.Attributes.Add(dxStringToXMLString(dxPDFXXFDFXFDOriginalAttributeShortName), dxStringToXMLString(AName));
        for I := 0 to AValue.Count - 1 do
          AField.AddChild('value').TextAsString := AValue[I];
      end);
    ADocument.SaveToStream(AStream);
  finally
    ADocument.Free;
  end;
end;

procedure TdxPDFFormDataWriter.WriteXFDF(AStream: TStream);
var
  ADocument: TdxXMLDocument;
  AXFDF, AFields: TdxXMLNode;
begin
  ADocument := TdxXMLDocument.Create;
  try
    ADocument.AutoIndent := True;
    AXFDF := ADocument.Root.AddChild(dxPDFXFDF);
    AXFDF.SetAttribute('xmlns', dxPDFXFDFNamespace);
    AFields := AXFDF.AddChild(dxPDFXFDFFields);
    WriteData(
      procedure(const AName: string; AValue: TStringList)
      var
        AField: TdxXMLNode;
        I: Integer;
      begin
        AField := AFields.AddChild(dxPDFXFDFField);
        AField.SetAttribute(dxPDFXFDFAttributeName, AName);
        for I := 0 to AValue.Count - 1 do
          AField.AddChild('value').TextAsString := AValue[I];
      end);
    ADocument.SaveToStream(AStream);
  finally
    ADocument.Free;
  end;
end;

{ TdxPDFFormDataWriterPair }

class function TdxPDFFormDataWriterPair.Create(const AKey: string; AData: TdxPDFFormData): TdxPDFFormDataWriterPair;
begin
  Result.Key := AKey;
  Result.Data := AData;
end;

{ TdxFDFCatalog }

constructor TdxFDFCatalog.Create(AData: TdxPDFFormData);
begin
  inherited Create;
  FData := AData;
end;

procedure TdxFDFCatalog.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  ADictionary.AddName(TdxPDFKeywords.TypeKey, TdxPDFKeywords.Catalog);
  ADictionary.Add(TdxPDFKeywords.FDF, CreateDictionary(AHelper, FData, True));
end;

function TdxFDFCatalog.CreateDictionary(AHelper: TdxPDFWriterHelper; AData: TdxPDFFormData;
  AOnlyKids: Boolean): TdxPDFDictionary;
var
  AArray: TdxPDFArray;
  ADictionary: TdxPDFDictionary;
  APair: TPair<string, TdxPDFFormData>;
begin
  ADictionary := AHelper.CreateDictionary;
  if not AOnlyKids and (AData.Name <> '') then
    ADictionary.Add(TdxPDFKeywords.FDFField, AData.Name);
  if AData.Dictionary.Count > 0 then
  begin
    AArray := AHelper.CreateArray;
    for APair in AData.Dictionary do
      if not APair.Value.IsPasswordField then
        AArray.Add(CreateDictionary(AHelper, APair.Value, False));
    ADictionary.Add(TdxPDFKeywords.Fields, AArray);
  end
  else
    if not AOnlyKids then
      ADictionary.Add('V', AData.GetValueAsString);
  Result := ADictionary;
end;

{ TdxFDFWriter }

constructor TdxFDFWriter.Create(AStream: TStream; ACatalog: TdxFDFCatalog);
begin
  inherited Create(AStream);
  FCatalog := ACatalog;
end;

function TdxFDFWriter.GetVersion: string;
begin
  Result := '%FDF-' + dxFDFVersion;
end;

function TdxFDFWriter.HasXRef: Boolean;
begin
  Result := False;
end;

procedure TdxFDFWriter.PopulateTrailer(ADictionary: TdxPDFWriterDictionary);
begin
  ADictionary.AddReference(TdxPDFKeywords.Root, FCatalog);
end;

procedure TdxFDFWriter.RegisterTrailerObjects;
begin
  Helper.RegisterIndirectObject(FCatalog);
end;

end.
