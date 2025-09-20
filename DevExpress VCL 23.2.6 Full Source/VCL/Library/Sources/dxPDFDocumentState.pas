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

unit dxPDFDocumentState;

{$I cxVer.inc}

interface

uses
  Classes, cxCustomCanvas, dxPDFCore, dxPDFBase, dxPDFTypes, dxPDFAnnotation;

type
  TdxPDFDocumentState = class;
  TdxPDFPageState = class;

  { IdxPDFAnnotationState }

  IdxPDFAnnotationState = interface
  ['{12AF3963-4B78-479C-B9B5-0E7B408688D8}']
    function GetHidden: Boolean;
    function GetName: string;
    function GetReadOnly: Boolean;
    function GetRect: TdxPDFPageRect;
    function GetState: TdxPDFAnnotationAppearanceState;
    function GetVisible: Boolean;
    procedure SetState(const AValue: TdxPDFAnnotationAppearanceState);
    //
    property State: TdxPDFAnnotationAppearanceState read GetState write SetState;
  end;

  { IdxPDFAnnotationVisitor }

  IdxPDFAnnotationVisitor = interface(IdxPDFCustomAnnotationVisitor)
  ['{C3A4963F-725D-4FD2-8CA8-EC369565EBD5}']
    procedure Visit(AAnnotation: TdxPDFCaretAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFCircleAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFFileAttachmentAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFFreeTextAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFInkAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFLinkAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFMovieAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFRedactAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFSquareAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFStampAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFTextAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFWidgetAnnotation); overload;
  end;

  { TdxPDFAnnotationState }

  TdxPDFAnnotationState = class(TInterfacedObject, IdxPDFAnnotationState)
  strict private
    FAnnotation: TdxPDFCustomAnnotation;
    FPageState: TdxPDFPageState;
    // IdxPDFAnnotationState
    function GetHidden: Boolean;
    function GetName: string;
    function GetReadOnly: Boolean;
    function GetRect: TdxPDFPageRect;
    function GetState: TdxPDFAnnotationAppearanceState;
    function GetVisible: Boolean;
    procedure SetState(const AValue: TdxPDFAnnotationAppearanceState);
  protected
    property Annotation: TdxPDFCustomAnnotation read FAnnotation;
  public
    constructor Create(APageState: TdxPDFPageState; AAnnotation: TdxPDFCustomAnnotation);
  end;

  { TdxPDFCommonAnnotationState }

  TdxPDFCommonAnnotationState = class(TdxPDFAnnotationState);

  { TdxPDFPageState }

  TdxPDFPageState = class
  strict private
    FAnnotationStateList: TInterfaceList;
    FDocumentState: TdxPDFDocumentState;
    FPage: TdxPDFPage;
    FPageIndex: Integer;
    //
    function GetAnnotationStateList: TInterfaceList;
  public
    constructor Create(ADocumentState: TdxPDFDocumentState; APage: TdxPDFPage; APageIndex: Integer);
    destructor Destroy; override;
    //
    property AnnotationStateList: TInterfaceList read GetAnnotationStateList;
    property Page: TdxPDFPage read FPage;
  end;

  { TdxPDFDocumentState }

  TdxPDFDocumentState = class(TdxPDFObject) // for internal use
  strict private
    FDocument: TObject;
    FPageStates: TdxPDFIntegerObjectDictionary<TdxPDFPageState>;
    FRotationAngle: TcxRotationAngle;
    //
    function GetAcroForm: TdxPDFInteractiveForm;
    function GetCatalog: TdxPDFCatalog;
    function GetDocumentRepository: TdxPDFDocumentRepository;
    function GetImageDataStorage: TdxPDFDocumentImageDataStorage;
    function GetPages: TdxPDFPageList;
    function GetPageState(APageIndex: Integer): TdxPDFPageState;
    function GetFontDataStorage: TdxPDFFontDataStorage;
  protected
    function GetPageIndex(APage: TdxPDFPage): Integer;
    procedure FieldChanged(ASender: TObject);
  public
    constructor Create(ADocument: TObject); reintroduce;
    destructor Destroy; override;
    //
    function IsEmpty: Boolean;
    procedure Update(AChanges: TdxPDFDocumentChanges); virtual;
    //
    property AcroForm: TdxPDFInteractiveForm read GetAcroForm;
    property Catalog: TdxPDFCatalog read GetCatalog;
    property FontDataStorage: TdxPDFFontDataStorage read GetFontDataStorage;
    property ImageDataStorage: TdxPDFDocumentImageDataStorage read GetImageDataStorage;
    property Pages: TdxPDFPageList read GetPages;
    property PageStates[APageIndex: Integer]: TdxPDFPageState read GetPageState;
    property RotationAngle: TcxRotationAngle read FRotationAngle write FRotationAngle;
  end;

implementation

uses
  SysUtils, dxCore, dxCoreClasses, dxPDFDocument;

const
  dxThisUnitName = 'dxPDFDocumentState';

type
  TdxPDFCustomAnnotationAccess = class(TdxPDFCustomAnnotation);
  TdxPDFDocumentAccess = class(TdxPDFDocument);
  TdxPDFPagesAccess = class(TdxPDFPages);

  { TdxPDFCustomVisitorFactory<TInput, TOutput> }

  TdxPDFCustomVisitorFactory<TInput, TOutput> = class(TcxIUnknownObject)
  strict private
    FResult: TOutput;
  strict protected
    procedure DoVisit(AInput: TInput); virtual; abstract;
    procedure SetResult(AResult: TOutput);
  public
    function CreateVisitor(AInput: TInput): TOutput;
  end;

  { TdxPDFAnnotationStateFactory }

  TdxPDFAnnotationStateFactory = class(TdxPDFCustomVisitorFactory<TdxPDFCustomAnnotation, IdxPDFAnnotationState>,
    IdxPDFAnnotationVisitor)
  strict private
    FPageState: TdxPDFPageState;
    // IdxPDFAnnotationVisitor
    procedure Visit(AAnnotation: TdxPDFCustomAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFCaretAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFCircleAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFFileAttachmentAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFFreeTextAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFInkAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFLinkAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFMovieAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFRedactAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFSquareAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFStampAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFTextAnnotation); overload;
    procedure Visit(AAnnotation: TdxPDFWidgetAnnotation); overload;
    //
    procedure CreateDefaultAnnotationState(AAnnotation: TdxPDFCustomAnnotation);
  strict protected
    procedure DoVisit(AInput: TdxPDFCustomAnnotation); override;
  protected
    function CreateList: TInterfaceList;
  public
    class function CreateStateList(APageState: TdxPDFPageState): TInterfaceList; static;
    class function IsNotReply(AAnnotation: TdxPDFMarkupAnnotation): Boolean; static;
    constructor Create(APageState: TdxPDFPageState);
  end;

{ TdxPDFCustomVisitorFactory<TInput, TOutput> }

procedure TdxPDFCustomVisitorFactory<TInput, TOutput>.SetResult(AResult: TOutput);
begin
  FResult := AResult;
end;

function TdxPDFCustomVisitorFactory<TInput, TOutput>.CreateVisitor(AInput: TInput): TOutput;
begin
  SetResult(Default(TOutput));
  DoVisit(AInput);
  Result := FResult;
end;

{ TdxPDFAnnotationStateFactory }

function TdxPDFAnnotationStateFactory.CreateList: TInterfaceList;
var
  AStateList: TInterfaceList;
begin
  AStateList := TInterfaceList.Create;
  FPageState.Page.ForEachAnnotation(
    procedure(AAnnotation: TdxPDFCustomAnnotation)
    var
      AState: IdxPDFAnnotationState;
    begin
      AState := CreateVisitor(AAnnotation);
      if AState <> nil then
        AStateList.Add(AState);
    end);
  Result := AStateList;
end;

procedure TdxPDFAnnotationStateFactory.DoVisit(AInput: TdxPDFCustomAnnotation);
var
  AVisitor: IdxPDFAnnotationVisitor;
begin
  if Supports(Self, IdxPDFAnnotationVisitor, AVisitor) then
    AInput.Accept(AVisitor);
end;

procedure TdxPDFAnnotationStateFactory.CreateDefaultAnnotationState(AAnnotation: TdxPDFCustomAnnotation);
begin
  SetResult(TdxPDFCommonAnnotationState.Create(FPageState, AAnnotation));
end;

class function TdxPDFAnnotationStateFactory.CreateStateList(APageState: TdxPDFPageState): TInterfaceList;
var
  AFactory: TdxPDFAnnotationStateFactory;
begin
   AFactory := TdxPDFAnnotationStateFactory.Create(APageState);
   try
     Result := AFactory.CreateList;
   finally
     AFactory.Free;
   end;
end;

class function TdxPDFAnnotationStateFactory.IsNotReply(AAnnotation: TdxPDFMarkupAnnotation): Boolean;
begin
  Result := AAnnotation.InReplyTo = nil;
end;

procedure TdxPDFAnnotationStateFactory.Visit(AAnnotation: TdxPDFFreeTextAnnotation);
begin
  CreateDefaultAnnotationState(AAnnotation);
end;

procedure TdxPDFAnnotationStateFactory.Visit(AAnnotation: TdxPDFInkAnnotation);
begin
  CreateDefaultAnnotationState(AAnnotation);
end;

procedure TdxPDFAnnotationStateFactory.Visit(AAnnotation: TdxPDFLinkAnnotation);
begin
  CreateDefaultAnnotationState(AAnnotation);
end;

procedure TdxPDFAnnotationStateFactory.Visit(AAnnotation: TdxPDFCustomAnnotation);
begin
  CreateDefaultAnnotationState(AAnnotation);
end;

procedure TdxPDFAnnotationStateFactory.Visit(AAnnotation: TdxPDFCaretAnnotation);
begin
  CreateDefaultAnnotationState(AAnnotation);
end;

procedure TdxPDFAnnotationStateFactory.Visit(AAnnotation: TdxPDFCircleAnnotation);
begin
  CreateDefaultAnnotationState(AAnnotation);
end;

procedure TdxPDFAnnotationStateFactory.Visit(AAnnotation: TdxPDFFileAttachmentAnnotation);
begin
  CreateDefaultAnnotationState(AAnnotation);
end;

procedure TdxPDFAnnotationStateFactory.Visit(AAnnotation: TdxPDFStampAnnotation);
begin
  CreateDefaultAnnotationState(AAnnotation);
end;

procedure TdxPDFAnnotationStateFactory.Visit(AAnnotation: TdxPDFTextAnnotation);
begin
  CreateDefaultAnnotationState(AAnnotation);
end;

procedure TdxPDFAnnotationStateFactory.Visit(AAnnotation: TdxPDFWidgetAnnotation);
begin
  CreateDefaultAnnotationState(AAnnotation);
end;

procedure TdxPDFAnnotationStateFactory.Visit(AAnnotation: TdxPDFMovieAnnotation);
begin
  CreateDefaultAnnotationState(AAnnotation);
end;

procedure TdxPDFAnnotationStateFactory.Visit(AAnnotation: TdxPDFRedactAnnotation);
begin
  CreateDefaultAnnotationState(AAnnotation);
end;

procedure TdxPDFAnnotationStateFactory.Visit(AAnnotation: TdxPDFSquareAnnotation);
begin
  CreateDefaultAnnotationState(AAnnotation);
end;

constructor TdxPDFAnnotationStateFactory.Create(APageState: TdxPDFPageState);
begin
  inherited Create;
  FPageState := APageState;
end;

{ TdxPDFDocumentState }

constructor TdxPDFDocumentState.Create(ADocument: TObject);
begin
  inherited Create(nil);
  FDocument := ADocument as TdxPDFDocument;
  FParent := Catalog;
  FPageStates := TdxPDFIntegerObjectDictionary<TdxPDFPageState>.Create;
end;

destructor TdxPDFDocumentState.Destroy;
begin
  FreeAndNil(FPageStates);
  inherited Destroy;
end;

function TdxPDFDocumentState.IsEmpty: Boolean;
begin
  Result := TdxPDFDocumentAccess(FDocument).Catalog.IsEmpty;
end;

procedure TdxPDFDocumentState.Update(AChanges: TdxPDFDocumentChanges);
begin
  // do nothing
end;

function TdxPDFDocumentState.GetPageIndex(APage: TdxPDFPage): Integer;
begin
  Result := TdxPDFPagesAccess(TdxPDFDocument(FDocument).Pages).List.IndexOf(APage);
end;

procedure TdxPDFDocumentState.FieldChanged(ASender: TObject);
begin
  Changed([dcModified, dcInteractiveLayer]);
end;

function TdxPDFDocumentState.GetAcroForm: TdxPDFInteractiveForm;
begin
  Result := TdxPDFDocumentAccess(FDocument).AcroForm;
end;

function TdxPDFDocumentState.GetCatalog: TdxPDFCatalog;
begin
  Result := TdxPDFDocumentAccess(FDocument).Catalog;
end;

function TdxPDFDocumentState.GetDocumentRepository: TdxPDFDocumentRepository;
begin
  Result := TdxPDFDocumentAccess(FDocument).Repository;
end;

function TdxPDFDocumentState.GetImageDataStorage: TdxPDFDocumentImageDataStorage;
begin
  Result := GetDocumentRepository.ImageDataStorage;
end;

function TdxPDFDocumentState.GetPages: TdxPDFPageList;
begin
  Result := TdxPDFPagesAccess(TdxPDFDocumentAccess(FDocument).Pages).List;
end;

function TdxPDFDocumentState.GetPageState(APageIndex: Integer): TdxPDFPageState;
begin
  if not FPageStates.TryGetValue(APageIndex, Result) then
  begin
    Result := TdxPDFPageState.Create(Self, Pages.Page[APageIndex], APageIndex);
    FPageStates.Add(APageIndex, Result);
  end;
end;

function TdxPDFDocumentState.GetFontDataStorage: TdxPDFFontDataStorage;
begin
  Result := GetDocumentRepository.FontDataStorage;
end;

{ TdxPDFAnnotationState }

constructor TdxPDFAnnotationState.Create(APageState: TdxPDFPageState; AAnnotation: TdxPDFCustomAnnotation);
begin
  inherited Create;
  FAnnotation := AAnnotation;
  FPageState := APageState;
end;

function TdxPDFAnnotationState.GetHidden: Boolean;
begin
  Result := False;
end;

function TdxPDFAnnotationState.GetName: string;
begin
  Result := TdxPDFCustomAnnotationAccess(FAnnotation).Name;
end;

function TdxPDFAnnotationState.GetReadOnly: Boolean;
begin
  Result := TdxPDFCustomAnnotationAccess(FAnnotation).ReadOnly;
end;

function TdxPDFAnnotationState.GetRect: TdxPDFPageRect;
begin
  Result := TdxPDFCustomAnnotationAccess(FAnnotation).PageRect;
end;

function TdxPDFAnnotationState.GetState: TdxPDFAnnotationAppearanceState;
begin
  Result := asNormal;
end;

function TdxPDFAnnotationState.GetVisible: Boolean;
begin
  Result := TdxPDFCustomAnnotationAccess(FAnnotation).Visible;
end;

procedure TdxPDFAnnotationState.SetState(const AValue: TdxPDFAnnotationAppearanceState);
begin
// do nothing
end;

{ TdxPDFPageState }

constructor TdxPDFPageState.Create(ADocumentState: TdxPDFDocumentState; APage: TdxPDFPage; APageIndex: Integer);
begin
  inherited Create;
  FDocumentState := ADocumentState;
  FPage := APage;
  FPageIndex := APageIndex;
end;

destructor TdxPDFPageState.Destroy;
begin
  FreeAndNil(FAnnotationStateList);
  inherited;
end;

function TdxPDFPageState.GetAnnotationStateList: TInterfaceList;
begin
  if FAnnotationStateList = nil then
    FAnnotationStateList := TdxPDFAnnotationStateFactory.CreateStateList(Self);
  Result := FAnnotationStateList;
end;

end.
