{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressCore Library                                      }
{                                                                    }
{           Copyright (c) 1998-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCORE LIBRARY AND ALL           }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY. }
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

unit dxXMLReaderUtils;

{$I cxVer.inc}

interface

uses
  Windows, Classes, Generics.Collections, Generics.Defaults, dxCore, cxClasses, dxXMLClasses, dxXMLReader;

type
  TdxXMLNodeHandler = class;
  TdxXMLNodeHandlers = class;
  TdxXMLNodeHandlerStack = class;

  { TdxXMLNodeHandler }

  TdxXMLNodeHandlerCreateFunc = function (const AReader: TdxXmlReader): TdxXMLNodeHandler of object;
  TdxXMLNodeHandlerCreateFuncEx = function (const AData: TObject): TdxXMLNodeHandler of object;
  TdxXMLNodeHandlerTextProc = procedure (const AText: string) of object;

  TdxXMLNodeHandlerClass = class of TdxXMLNodeHandler;
  TdxXMLNodeHandler = class
  strict private
    FHandlers: TdxXMLNodeHandlers;
    FRefCount: Integer;

    function GetHandlers: TdxXMLNodeHandlers; inline;
  protected
    FOwner: TObject;

    function Skip(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    //
    property Handlers: TdxXMLNodeHandlers read GetHandlers;
  public
    constructor Create(AOwner: TObject; AData: TObject); virtual;
    destructor Destroy; override;
    procedure BeforeDestruction; override;
    function CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler; virtual;
    procedure OnAttributes(const AReader: TdxXmlReader); virtual;
    procedure OnEnd; virtual;
    procedure OnText(const AReader: TdxXmlReader); virtual;
    // References
    procedure AddReference; inline;
    procedure RemoveReference; inline;
  end;

  { TdxXMLNodeHandlers }

  TdxXMLNodeHandlers = class
  strict private type
  {$REGION 'Internal Types'}
    THandlerInfo = record
      CreateClass: TdxXMLNodeHandlerClass;
      CreateFunc: TdxXMLNodeHandlerCreateFunc;
      CreateFuncEx: TdxXMLNodeHandlerCreateFuncEx;
      Data: TObject;
      TextProc: TdxXMLNodeHandlerTextProc;
    end;
  {$ENDREGION}
  strict private
    FData: TDictionary<AnsiString, THandlerInfo>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const ANamespace, ANodeName: AnsiString; AClass: TdxXMLNodeHandlerClass; AData: TObject = nil); overload;
    procedure Add(const ANamespace, ANodeName: AnsiString; AFunc: TdxXMLNodeHandlerCreateFunc); overload;
    procedure Add(const ANamespace, ANodeName: AnsiString; AFunc: TdxXMLNodeHandlerCreateFuncEx; AData: TObject); overload;
    procedure Add(const ANamespace, ANodeName: AnsiString; AProc: TdxXMLNodeHandlerTextProc; AIgnoreSpaceControl: Boolean = False); overload;
    procedure Add(const ANodeName: AnsiString; AClass: TdxXMLNodeHandlerClass; AData: TObject = nil); overload;
    procedure Add(const ANodeName: AnsiString; AFunc: TdxXMLNodeHandlerCreateFunc); overload;
    procedure Add(const ANodeName: AnsiString; AFunc: TdxXMLNodeHandlerCreateFuncEx; AData: TObject); overload;
    procedure Add(const ANodeName: AnsiString; AProc: TdxXMLNodeHandlerTextProc; AIgnoreSpaceControl: Boolean = False); overload;
    function CreateHandler(AOwner: TObject; AReader: TdxXmlReader; const AName: string): TdxXMLNodeHandler;
  end;

  { TdxXMLNodeHandlerStack }

  TdxXMLNodeHandlerStack = class
  strict private
    FList: TList;
  public
    constructor Create;
    destructor Destroy; override;
    function IsEmpty: Boolean; inline;
    function Peek: TdxXMLNodeHandler; inline;
    procedure Pop;
    procedure Push(AValue: TdxXMLNodeHandler);
  end;

  { TdxXMLDocumentHandler }

  TdxXMLDocumentHandler = class
  strict private
    FHandlers: TdxXMLNodeHandlers;
    FOwner: TObject;
    FProgressHelper: TcxCustomProgressCalculationHelper;
    FSettings: TdxXmlReaderSettings;
    FSkipRootNode: Boolean;
    FStream: TStream;
    FStreamOwnership: TStreamOwnership;
  protected
    function CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler; virtual;
  public
    constructor Create(AStream: TStream; AStreamOwnership: TStreamOwnership = soReference;
      AOwner: TObject = nil; AProgressHelper: TcxCustomProgressCalculationHelper = nil);
    destructor Destroy; override;
    procedure Run;
    //
    property Handlers: TdxXMLNodeHandlers read FHandlers;
    property SkipRootNode: Boolean read FSkipRootNode write FSkipRootNode;
  end;

implementation

uses
  SysUtils, dxStringHelper;

const
  dxThisUnitName = 'dxXMLReaderUtils';

type

  { TdxXMLNodeSkipHandler }

  TdxXMLNodeSkipHandler = class(TdxXMLNodeHandler)
  strict private
    FOwnerHandler: TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
    function CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler; override;
  end;

  { TdxXMLNodeTextHandler }

  TdxXMLNodeTextHandler = class(TdxXMLNodeHandler)
  strict private
    FIgnoreSpaceControl: Boolean;
    FProc: TdxXMLNodeHandlerTextProc;
    FValue: string;
  public
    constructor Create(AProc: TdxXMLNodeHandlerTextProc; AIgnoreSpaceControl: Boolean); reintroduce;
    procedure OnEnd; override;
    procedure OnText(const AReader: TdxXmlReader); override;
  end;

{ TdxXMLNodeHandler }

constructor TdxXMLNodeHandler.Create(AOwner: TObject; AData: TObject);
begin
  FOwner := AOwner;
end;

destructor TdxXMLNodeHandler.Destroy;
begin
  FreeAndNil(FHandlers);
  inherited;
end;

procedure TdxXMLNodeHandler.BeforeDestruction;
begin
  if FRefCount > 0 then
    raise EInvalidOperation.Create('You cannot destroy the Handler that has references!');
  inherited;
end;

function TdxXMLNodeHandler.CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  if FHandlers <> nil then
    Result := FHandlers.CreateHandler(FOwner, AReader, AReader.Name)
  else
    Result := nil;
end;

procedure TdxXMLNodeHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  // do nothing
end;

procedure TdxXMLNodeHandler.OnEnd;
begin
  // do nothing
end;

procedure TdxXMLNodeHandler.OnText(const AReader: TdxXmlReader);
begin
  // do nothing
end;

procedure TdxXMLNodeHandler.AddReference;
begin
  Inc(FRefCount);
end;

procedure TdxXMLNodeHandler.RemoveReference;
begin
  Dec(FRefCount);
  if FRefCount = 0 then
    Free;
end;

function TdxXMLNodeHandler.Skip(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := TdxXMLNodeSkipHandler.Create(FOwner, Self);
end;

function TdxXMLNodeHandler.GetHandlers: TdxXMLNodeHandlers;
begin
  if FHandlers = nil then
    FHandlers := TdxXMLNodeHandlers.Create;
  Result := FHandlers;
end;

{ TdxXMLNodeHandlers }

constructor TdxXMLNodeHandlers.Create;
begin
  FData := TDictionary<AnsiString, THandlerInfo>.Create;
end;

destructor TdxXMLNodeHandlers.Destroy;
begin
  FreeAndNil(FData);
  inherited;
end;

procedure TdxXMLNodeHandlers.Add(const ANodeName: AnsiString; AClass: TdxXMLNodeHandlerClass; AData: TObject = nil);
var
  AInfo: THandlerInfo;
begin
  ZeroMemory(@AInfo, SizeOf(AInfo));
  AInfo.CreateClass := AClass;
  AInfo.Data := AData;
  FData.AddOrSetValue(ANodeName, AInfo);
end;

procedure TdxXMLNodeHandlers.Add(const ANodeName: AnsiString;
  AProc: TdxXMLNodeHandlerTextProc; AIgnoreSpaceControl: Boolean = False);
var
  AInfo: THandlerInfo;
begin
  ZeroMemory(@AInfo, SizeOf(AInfo));
  AInfo.TextProc := AProc;
  AInfo.Data := TObject(AIgnoreSpaceControl);
  FData.AddOrSetValue(ANodeName, AInfo);
end;

procedure TdxXMLNodeHandlers.Add(const ANamespace, ANodeName: AnsiString; AFunc: TdxXMLNodeHandlerCreateFuncEx; AData: TObject);
begin
  if ANamespace <> '' then
    Add(ANamespace + ':' + ANodeName, AFunc, AData)
  else
    Add(ANodeName, AFunc, AData)
end;

procedure TdxXMLNodeHandlers.Add(const ANodeName: AnsiString; AFunc: TdxXMLNodeHandlerCreateFuncEx; AData: TObject);
var
  AInfo: THandlerInfo;
begin
  ZeroMemory(@AInfo, SizeOf(AInfo));
  AInfo.CreateFuncEx := AFunc;
  AInfo.Data := AData;
  FData.AddOrSetValue(ANodeName, AInfo);
end;

procedure TdxXMLNodeHandlers.Add(const ANodeName: AnsiString; AFunc: TdxXMLNodeHandlerCreateFunc);
var
  AInfo: THandlerInfo;
begin
  ZeroMemory(@AInfo, SizeOf(AInfo));
  AInfo.CreateFunc := AFunc;
  FData.AddOrSetValue(ANodeName, AInfo);
end;

procedure TdxXMLNodeHandlers.Add(const ANamespace, ANodeName: AnsiString; AFunc: TdxXMLNodeHandlerCreateFunc);
begin
  if ANamespace <> '' then
    Add(ANamespace + ':' + ANodeName, AFunc)
  else
    Add(ANodeName, AFunc)
end;

procedure TdxXMLNodeHandlers.Add(const ANamespace, ANodeName: AnsiString; AClass: TdxXMLNodeHandlerClass; AData: TObject = nil);
begin
  if ANamespace <> '' then
    Add(ANamespace + ':' + ANodeName, AClass, AData)
  else
    Add(ANodeName, AClass, AData);
end;

procedure TdxXMLNodeHandlers.Add(const ANamespace, ANodeName: AnsiString; AProc: TdxXMLNodeHandlerTextProc; AIgnoreSpaceControl: Boolean);
begin
  if ANamespace <> '' then
    Add(ANamespace + ':' + ANodeName, AProc, AIgnoreSpaceControl)
  else
    Add(ANodeName, AProc, AIgnoreSpaceControl);
end;

function TdxXMLNodeHandlers.CreateHandler(AOwner: TObject; AReader: TdxXmlReader; const AName: string): TdxXMLNodeHandler;

  function TryExtractLocalName(const AName: string; out ALocalName: string): Boolean;
  var
    AIndex: Integer;
  begin
    AIndex := TdxStringHelper.IndexOf(AName, ':');
    Result := AIndex <> -1;
    if Result then
      ALocalName := TdxStringHelper.Substring(AName, AIndex + 1);
  end;

var
  AInfo: THandlerInfo;
  ASuccess: Boolean;
  ALocalName: string;
begin
  Result := nil;
  ASuccess := FData.TryGetValue(AnsiString(AName), AInfo);
  if not ASuccess and TryExtractLocalName(AName, ALocalName) then
    ASuccess := FData.TryGetValue(AnsiString(ALocalName), AInfo); 
  if ASuccess then
  begin
    if Assigned(AInfo.CreateFunc) then
      Result := AInfo.CreateFunc(AReader)
    else if Assigned(AInfo.CreateFuncEx) then
      Result := AInfo.CreateFuncEx(AInfo.Data)
    else if Assigned(AInfo.CreateClass) then
      Result := AInfo.CreateClass.Create(AOwner, AInfo.Data)
    else if Assigned(AInfo.TextProc) then
      Result := TdxXMLNodeTextHandler.Create(AInfo.TextProc, AInfo.Data <> nil);
  end;
end;

{ TdxXMLNodeHandlerStack }

constructor TdxXMLNodeHandlerStack.Create;
begin
  FList := TList.Create;
  FList.Capacity := 16;
end;

destructor TdxXMLNodeHandlerStack.Destroy;
begin
  while not IsEmpty do
    Pop;
  FreeAndNil(FList);
  inherited;
end;

function TdxXMLNodeHandlerStack.IsEmpty: Boolean;
begin
  Result := FList.Count = 0;
end;

function TdxXMLNodeHandlerStack.Peek: TdxXMLNodeHandler;
begin
  if FList.Count = 0 then
    raise EdxException.Create('Stack is empty');
  Result := FList.List[FList.Count - 1];
end;

procedure TdxXMLNodeHandlerStack.Pop;
var
  AHandler: TdxXMLNodeHandler;
begin
  if FList.Count = 0 then
    raise EdxException.Create('Stack is empty');
  AHandler := FList.List[FList.Count - 1];
  FList.Delete(FList.Count - 1);
  if AHandler <> nil then
    AHandler.RemoveReference;
end;

procedure TdxXMLNodeHandlerStack.Push(AValue: TdxXMLNodeHandler);
begin
  if AValue <> nil then
    AValue.AddReference;
  FList.Add(AValue);
end;

{ TdxXMLNodeSkipHandler }

constructor TdxXMLNodeSkipHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FOwnerHandler := AData as TdxXMLNodeHandler;
end;

function TdxXMLNodeSkipHandler.CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := FOwnerHandler.CreateHandler(AReader);
end;

{ TdxXMLNodeTextHandler }

constructor TdxXMLNodeTextHandler.Create(AProc: TdxXMLNodeHandlerTextProc; AIgnoreSpaceControl: Boolean);
begin
  inherited Create(nil, nil);
  FProc := AProc;
  FIgnoreSpaceControl := AIgnoreSpaceControl;
end;

procedure TdxXMLNodeTextHandler.OnEnd;
begin
  FProc(TdxXmlConvert.DecodeName(FValue));
end;

procedure TdxXMLNodeTextHandler.OnText(const AReader: TdxXmlReader);
begin
  if FIgnoreSpaceControl then
    FValue := AReader.Value
  else
    FValue := AReader.ActualValue;
end;

{ TdxXMLDocumentHandler }

constructor TdxXMLDocumentHandler.Create(
  AStream: TStream; AStreamOwnership: TStreamOwnership = soReference;
  AOwner: TObject = nil; AProgressHelper: TcxCustomProgressCalculationHelper = nil);
begin
  FOwner := AOwner;
  FStream := AStream;
  FStreamOwnership := AStreamOwnership;
  FSettings := TdxXmlReaderSettings.Create;
  FSettings.IgnoreComments := True;
  FSettings.IgnoreWhitespace := True;
  FProgressHelper := AProgressHelper;
  FHandlers := TdxXMLNodeHandlers.Create;
end;

destructor TdxXMLDocumentHandler.Destroy;
begin
  if FStreamOwnership = soOwned then
    FreeAndNil(FStream);
  FreeAndNil(FHandlers);
  FreeAndNil(FSettings);
  inherited;
end;

procedure TdxXMLDocumentHandler.Run;

  function SafeReadNext(AReader: TdxXmlReader): Boolean;
  begin
    try
      Result := AReader.Read;
    except
      Result := False;
    end;
  end;

  procedure SafeEndElement(AStack: TdxXMLNodeHandlerStack);
  var
    AHandler: TdxXMLNodeHandler;
  begin
    AHandler := AStack.Peek;
    if AHandler <> nil then
      AHandler.OnEnd;
    AStack.Pop;
  end;

var
  AStack: TdxXMLNodeHandlerStack;
  AHandler: TdxXMLNodeHandler;
  AReader: TdxXmlReader;
begin
  if FProgressHelper <> nil then
    FProgressHelper.BeginStage(100);
  try
    if FStream.Position < FStream.Size then
    begin
      AStack := TdxXMLNodeHandlerStack.Create;
      AReader := FSettings.CreateReader(FStream);
      try
        while SafeReadNext(AReader) do
          case AReader.NodeType of
            TdxXmlNodeType.EndElement:
              if AReader.Depth >= Ord(SkipRootNode) then
                SafeEndElement(AStack);

            TdxXmlNodeType.Element:
              if AReader.Depth >= Ord(SkipRootNode) then
              begin
                if AStack.IsEmpty then
                  AHandler := CreateHandler(AReader)
                else
                begin
                  AHandler := AStack.Peek;
                  if AHandler <> nil then
                    AHandler := AHandler.CreateHandler(AReader);
                end;

                AStack.Push(AHandler);
                if AHandler <> nil then
                  AHandler.OnAttributes(AReader);
                if AReader.IsEmptyElement then
                  SafeEndElement(AStack);
                if FProgressHelper <> nil then
                  FProgressHelper.SetTaskNumber(AReader.GetProgress);
              end;

            TdxXmlNodeType.Text, TdxXmlNodeType.SignificantWhitespace:
              if not AStack.IsEmpty then
              begin
                AHandler := AStack.Peek;
                if AHandler <> nil then
                  AHandler.OnText(AReader);
              end;
          end;
      finally
        AReader.Free;
        AStack.Free;
      end;
    end;
  finally
    if FProgressHelper <> nil then
      FProgressHelper.EndStage;
  end;
end;

function TdxXMLDocumentHandler.CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := Handlers.CreateHandler(FOwner, AReader, AReader.Name);
end;

end.
