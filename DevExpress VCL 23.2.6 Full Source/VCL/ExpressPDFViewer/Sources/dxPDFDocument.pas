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

unit dxPDFDocument;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Classes, Windows, SysUtils, Graphics, Generics.Defaults, Generics.Collections, dxGenerics, cxClasses, dxCoreClasses,
  cxGraphics, cxGeometry, dxGDIPlusClasses, dxProtectionUtils, dxThreading, dxX509Certificate, dxPrintUtils,
  dxPDFBase, dxPDFTypes, dxPDFParser, dxPDFCore, dxPDFText, dxPDFFontUtils, dxPDFEncryption, dxPDFInteractivity,
  dxPDFRecognizedObject, dxPDFSignature, dxPDFContext, dxPDFInteractiveFormField, dxPDFForm, dxPDFDocumentState;

const
  dxPDFDefaultPasswordAttemptsLimit = 3;

type
  IdxPDFDocumentListener = interface // for internal use
  ['{E09155EC-FB27-4A4F-8517-B5F96D14CEAA}']
    procedure Changed(AChanges: TdxPDFDocumentChanges); // for internal use
  end;

  TdxPDFDocument = class;
  TdxPDFDocumentSequentialTextSearch = class;

  TdxPDFDocumentLoadInfo = record
  public
    FileName: string;
    FileStream: TStream;
  end;

  TdxPDFDocumentLoadedEvent = procedure(Sender: TdxPDFDocument; const AInfo: TdxPDFDocumentLoadInfo) of object;
  TdxPDFDocumentSaveProgressEvent = procedure(Sender: TdxPDFDocument; APercent: Integer) of object;
  TdxPDFDocumentTextSearchProgressEvent = procedure(Sender: TdxPDFDocument; APageIndex, APercent: Integer) of object;

  TdxPDFDocumentTextSearchDirection = (tsdForward, tsdBackward);
  TdxPDFDocumentTextSearchStatus = (tssFound, tssNotFound, tssFinished);

  TdxPDFDocumentTextSearchOptions = record
  public
    CaseSensitive: Boolean;
    Direction: TdxPDFDocumentTextSearchDirection;
    WholeWords: Boolean;

    class function Default: TdxPDFDocumentTextSearchOptions; static;
  end;

  TdxPDFDocumentTextSearchResult = record
  public
    Range: TdxPDFPageTextRange;
    Status: TdxPDFDocumentTextSearchStatus;
  end;

  TdxPDFPageInfo = record
  private
    FPage: TdxPDFPage;
    //
    function AllowContentExtraction: Boolean;
    function CanRecognizeContent: Boolean;
    function GetHyperlinks: TdxPDFHyperlinkList;
    function GetImages: TdxPDFImageList;
    function GetRotationAngle: TcxRotationAngle;
    function GetSize: TdxPointF;
    function GetText: string;
    function GetUserUnit: Integer;
  public
    procedure Initialize(APage: TdxPDFPage); // for internal use
    procedure Pack;
    procedure Rotate(AAngle: TcxRotationAngle);
    //
    property Hyperlinks: TdxPDFHyperlinkList read GetHyperlinks;
    property Images: TdxPDFImageList read GetImages;
    property RotationAngle: TcxRotationAngle read GetRotationAngle;
    property Size: TdxPointF read GetSize;
    property Text: string read GetText;
    property UserUnit: Integer read GetUserUnit;
  end;

  { TdxPDFPages }

  TdxPDFPages = class
  strict private
    FDocument: TdxPDFDocument;
    //
    function GetCount: Integer;
    function GetItem(AIndex: Integer): TdxPDFPageInfo;
    function GetList: TdxPDFPageList;
  protected
    property List: TdxPDFPageList read GetList;
  public
    constructor Create(ADocument: TdxPDFDocument);  // for internal use
    //
    procedure Add(ASource: TdxPDFDocument; ASourceIndex: Integer); overload;
    procedure Add(ASource: TdxPDFDocument; const ASourceIndexes: array of Integer); overload;
    procedure Delete(AIndex: Integer); overload;
    procedure Delete(const AIndexes: array of Integer); overload;
    procedure Insert(AIndex: Integer; ASource: TdxPDFDocument); overload;
    procedure Insert(AIndex: Integer; ASource: TdxPDFDocument; ASourceIndex: Integer); overload;
    procedure Insert(AIndex: Integer; ASource: TdxPDFDocument; const ASourceIndexes: array of Integer); overload;
    procedure Move(ACurrentIndex, ANewIndex: Integer); overload;
    procedure Move(const ACurrentIndexes: array of Integer; ANewIndex: Integer); overload;
    //
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TdxPDFPageInfo read GetItem; default;
  end;

  { TdxPDFSecurityOptions }

  TdxPDFSecurityOptions = class(TPersistent)
  strict private
    FAlgorithm: TdxPDFEncryptionAlgorithmType;
    FEnabled: Boolean;
    FOwnerPassword: string;
    FPermissions: TdxPDFDocumentPermissions;
    FUserPassword: string;
  public
    constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;
    procedure Reset;
    //
    property Algorithm: TdxPDFEncryptionAlgorithmType read FAlgorithm write FAlgorithm;
    property Enabled: Boolean read FEnabled write FEnabled default False;
    property Permissions: TdxPDFDocumentPermissions read FPermissions write FPermissions;
    property OwnerPassword: string read FOwnerPassword write FOwnerPassword;
    property UserPassword: string read FUserPassword write FUserPassword;
  end;

  { TdxPDFSignatureOptions }

  TdxPDFSignatureOptions = class(TPersistent)
  strict private
    FEmbeddedSignatures: TdxPDFSignatureFieldInfoList;
    FEnabled: Boolean;
    FSignature: TdxPDFSignatureFieldInfo;

    function GetEmbeddedSignatureCount: Integer;
    function GetEmbeddedSignature(Index: Integer): TdxPDFSignatureFieldInfo;
    procedure SetSignature(const AValue: TdxPDFSignatureFieldInfo);
  protected
    FDocument: TdxPDFDocument;
    //
    function Contains(AField: TdxPDFInteractiveFormSignatureField): Boolean;
    function IsSignatureValid: Boolean;
    procedure AddEmbeddedSignature(AField: TdxPDFInteractiveFormSignatureField);
    procedure DeleteEmbeddedSignature(AField: TdxPDFInteractiveFormSignatureField);
    procedure DeleteEmbeddedSignatures;
    procedure Validate(AAllowSignatureRemoval: Boolean);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function IsDocumentSigned: Boolean;
    procedure Assign(Source: TPersistent); override;
    procedure Reset;
    //
    property EmbeddedSignatureCount: Integer read GetEmbeddedSignatureCount;
    property EmbeddedSignatures[Index: Integer]: TdxPDFSignatureFieldInfo read GetEmbeddedSignature;
    property Enabled: Boolean read FEnabled write FEnabled default False;
    property Signature: TdxPDFSignatureFieldInfo read FSignature write SetSignature;
  end;

  { TdxPDFDocument }

  TdxPDFDocument = class
  strict private
    FCatalog: TdxPDFCatalog;
    FEncryptionDictionary: TdxPDFDictionary;
    FEncryptionDictionaryNumber: Integer;
    FForm: TdxPDFForm;
    FID: TdxPDFDocumentID;
    FInfoObjectNumber: Integer;
    FInformation: TdxPDFDocumentInformation;
    FListenerList: IInterfaceList;
    FLoadInfo: TdxPDFDocumentLoadInfo;
    FPages: TdxPDFPages;
    FPasswordAttemptsLimit: Integer;
    FRepository: TdxPDFDocumentRepository;
    FRootObjectNumber: Integer;
    FSecurityOptions: TdxPDFSecurityOptions;
    FSignatureOptions: TdxPDFSignatureOptions;
    FState: TdxPDFDocumentState;
    FTextSearch: TdxPDFDocumentSequentialTextSearch;
    // Flags
    FChanges: TdxPDFDocumentChanges;
    FLockCount: Integer;
    FModified: Boolean;
    FNeedClearedNotification: Boolean;
    FNeedLoadedNotification: Boolean;
    // Events
    FOnChanged: TNotifyEvent;
    FOnFieldEditValueChanged: TNotifyEvent;
    FOnFieldEditValueChanging: TdxPDFFormFieldEditValueChangingEvent;
    FOnGetPassword: TdxGetPasswordEvent;
    FOnLoaded: TdxPDFDocumentLoadedEvent;
    FOnSaveProgress: TdxPDFDocumentSaveProgressEvent;
    FOnSearchProgress: TdxPDFDocumentTextSearchProgressEvent;
    FOnUnloaded: TNotifyEvent;
    //
    function GetAcroForm: TdxPDFInteractiveForm;
    function GetAllowContentExtraction: Boolean;
    function GetAllowPrinting: Boolean;
    function GetBookmarks: TdxPDFBookmarkList;
    function GetEncryptionInfo: TdxPDFEncryptionInfo;
    function GetFileAttachments: TdxPDFFileAttachmentList;
    function GetFileName: string;
    function GetFileSize: Int64;
    function getForm: TdxPDFForm; // for Builder
    function GetIsEmpty: Boolean;
    function GetIsEncrypted: Boolean;
    function GetOutlines: TdxPDFOutlines;
    function GetPageCount: Integer;
    function GetPageInfo(AIndex: Integer): TdxPDFPageInfo;
    function GetParser: TdxPDFDocumentParser;
    procedure SetAcroFrom(const AValue: TdxPDFInteractiveForm);
    procedure SetCatalog(const AValue: TdxPDFCatalog);
    procedure SetChanges(const AValue: TdxPDFDocumentChanges);
    procedure SetEncryptionDictionary(const AValue: TdxPDFDictionary);
    procedure SetRepository(const AValue: TdxPDFDocumentRepository);
    procedure SetOnSearchProgress(const AValue: TdxPDFDocumentTextSearchProgressEvent);
    procedure SetSecurityOptions(const AValue: TdxPDFSecurityOptions);
    procedure SetSignatureOptions(const AValue: TdxPDFSignatureOptions);
    //
    function CreateStream(AStream: TStream): TMemoryStream; overload;
    function CreateStream(const AFileName: string): TMemoryStream; overload;
    function DoLoad: Boolean;
    function DoReadDocument: Boolean;
    procedure AcroFormChanged;
    procedure Changed;
    procedure ClearEncryptionDictionaryNumber;
    procedure ClearLoadInfo;
    procedure CreateDocumentState;
    procedure CreateEmptyRepository;
    procedure CreateRepository(AStream: TStream);
    procedure DoClear;
    procedure Initialize;
    procedure PopulateLoadInfo(const AFileName: string; AStream: TStream);
    procedure PopulateSecurityOptions;
    procedure RecreateCatalog;
    procedure ReadCorruptedDocument;
    procedure ReadID(AObject: TdxPDFBase);
    procedure ReadObjectNumber(ADictionary: TdxPDFDictionary; const AKey: string; var ANumber: Integer);
    procedure ReadTrailer;
    procedure ReadVersion;
    procedure UpdateInformation;
    procedure UpdateTrailer(ADictionary: TdxPDFDictionary);
    //
    procedure OnAddFieldHandler(Sender: TObject);
    procedure OnDeleteFieldHandler(Sender: TObject);
    //
    property EncryptionDictionary: TdxPDFDictionary read FEncryptionDictionary write SetEncryptionDictionary;
  protected
    procedure ClearRecognizedContent;
    function GetFontByName(const AFontName: string): TdxPDFCustomFont;
    function IsLocked: Boolean;
    procedure SetModified(AValue: Boolean);
    procedure ResetModified;
    //
    property AcroForm: TdxPDFInteractiveForm read GetAcroForm write SetAcroFrom;
    property Catalog: TdxPDFCatalog read FCatalog write SetCatalog;
    property IsEmpty: Boolean read GetIsEmpty;
    property Outlines: TdxPDFOutlines read GetOutlines;
  protected
    function DoCreateDocumentState: TdxPDFDocumentState; virtual;
    procedure AddChange(AChange: TdxPDFDocumentChange);
    procedure AddListener(const AListener: IdxPDFDocumentListener);
    procedure BeforeClear; virtual;
    procedure ClonePages(ADocument: TdxPDFDocument; const APageIndexes: array of Integer; ATargetPageIndex: Integer;
      ACloneNonePageContent: Boolean);
    procedure CreateSubClasses; virtual;
    procedure DestroySubClasses; virtual;
    //
    procedure DoFieldEditValueChanged(ASender: TObject);
    procedure DoFieldEditValueChanging(ASender: TdxPDFCustomField; const AOldValue, ANewValue: Variant;
      var AAccept: Boolean);
    procedure Load(AStream: TStream; const AFileName: string = '');
    procedure RemoveListener(const AListener: IdxPDFDocumentListener);
    procedure Save(AStream: TStream; AAllowSignatureRemoval, AClearSignatures: Boolean; AResetModified: Boolean = False);
    procedure UpdateForm;
    //
    function ApplySignature(ASignatureInfo: TdxPDFSignatureFieldInfo): TdxPDFSignature;
    //
    property Bookmarks: TdxPDFBookmarkList read GetBookmarks;
    property Changes: TdxPDFDocumentChanges read FChanges write SetChanges;
    property EncryptionInfo: TdxPDFEncryptionInfo read GetEncryptionInfo;
    property ID: TdxPDFDocumentID read FID write FID;
    property IsEncrypted: Boolean read GetIsEncrypted;
    property Parser: TdxPDFDocumentParser read GetParser;
    property Repository: TdxPDFDocumentRepository read FRepository write SetRepository;
    property State: TdxPDFDocumentState read FState;
    property TextSearch: TdxPDFDocumentSequentialTextSearch read FTextSearch;
    //
    property OnFieldEditValueChanged: TNotifyEvent read FOnFieldEditValueChanged write FOnFieldEditValueChanged;
    property OnFieldEditValueChanging: TdxPDFFormFieldEditValueChangingEvent read FOnFieldEditValueChanging write
      FOnFieldEditValueChanging;
  public
    constructor Create;
    destructor Destroy; override;
    //
    function FindText(const AText: string): TdxPDFDocumentTextSearchResult; overload; {$IFDEF BCBCOMPATIBLE}virtual;{$ENDIF}
    function FindText(const AText: string;
      const AOptions: TdxPDFDocumentTextSearchOptions): TdxPDFDocumentTextSearchResult; overload; {$IFDEF BCBCOMPATIBLE}virtual;{$ENDIF}
    function FindText(const AText: string;
      const AOptions: TdxPDFDocumentTextSearchOptions; APageIndex: Integer): TdxPDFDocumentTextSearchResult; overload; {$IFDEF BCBCOMPATIBLE}virtual;{$ENDIF}
    procedure FindText(const AText: string; const AOptions: TdxPDFDocumentTextSearchOptions;
      var AFoundRanges: TdxPDFPageTextRanges); overload; {$IFDEF BCBCOMPATIBLE}virtual;{$ENDIF}
    //
    procedure Append(const AFileName: string); overload;
    procedure Append(AStream: TStream); overload;
    procedure Append(ASource: TdxPDFDocument); overload;
    procedure BeginUpdate;
    procedure Clear;
    procedure EndUpdate;
    procedure LoadFromFile(const AFileName: string);
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToFile(const AFileName: string; AAllowSignatureRemoval: Boolean = False; AResetModified: Boolean = True);
    procedure SaveToStream(AStream: TStream; AAllowSignatureRemoval: Boolean = False; AResetModified: Boolean = True);
    //
    property AllowContentExtraction: Boolean read GetAllowContentExtraction;
    property AllowPrinting: Boolean read GetAllowPrinting;
    property FileAttachments: TdxPDFFileAttachmentList read GetFileAttachments;
    property Form: TdxPDFForm read getForm;
    property Information: TdxPDFDocumentInformation read FInformation;
    property Modified: Boolean read FModified;
    property PageCount: Integer read GetPageCount;
    property PageInfo[Index: Integer]: TdxPDFPageInfo read GetPageInfo;
    property Pages: TdxPDFPages read FPages;
    property PasswordAttemptsLimit: Integer read FPasswordAttemptsLimit write FPasswordAttemptsLimit;
    property SecurityOptions: TdxPDFSecurityOptions read FSecurityOptions write SetSecurityOptions;
    property SignatureOptions: TdxPDFSignatureOptions read FSignatureOptions write SetSignatureOptions;
    //
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property OnGetPassword: TdxGetPasswordEvent read FOnGetPassword write FOnGetPassword;
    property OnLoaded: TdxPDFDocumentLoadedEvent read FOnLoaded write FOnLoaded;
    property OnSaveProgress: TdxPDFDocumentSaveProgressEvent read FOnSaveProgress write FOnSaveProgress;
    property OnSearchProgress: TdxPDFDocumentTextSearchProgressEvent read FOnSearchProgress write SetOnSearchProgress;
    property OnUnloaded: TNotifyEvent read FOnUnloaded write FOnUnloaded;
  end;

  { TdxPDFDocumentSequentialTextSearch }

  TdxPDFDocumentSequentialTextSearch = class
  strict private
    FAborted: Boolean;
    FArabicNumericReplacements: TdxPDFStringStringDictionary;
    FCompleted: Boolean;
    FDocument: TdxPDFDocument;
    FHasResults: Boolean;
    FFoundWords: TdxPDFTextWordList;
    FLastSearchResult: TdxPDFDocumentTextSearchResult;
    FMoveNext: TThreadMethod;
    FPageIndex: Integer;
    FPageLines: TdxPDFTextLineList;
    FPageWords: TdxPDFTextWordList;
    FProcessedPageIndexes: TdxIntegerList;
    FOptions: TdxPDFDocumentTextSearchOptions;
    FRecognizedContentPageIndex: Integer;
    FSearchStart: Boolean;
    FSearchString: string;
    FStartPageIndex: Integer;
    FStartWordIndex: Integer;
    FSearchWords: TStringList;
    FWordDelimiters: TStringList;
    FWordIndex: Integer;

    FOnComplete: TNotifyEvent;
    FOnProgress: TdxPDFDocumentTextSearchProgressEvent;

    procedure SetCompleted(const AValue: Boolean);
    procedure SetDocument(const AValue: TdxPDFDocument);
    procedure SetFoundWords(const AValue: TdxPDFTextWordList);
    procedure SetOptions(const AValue: TdxPDFDocumentTextSearchOptions);
    procedure SetSearchWords(const AValue: TStringList);

    function CanCompare: Boolean;
    function CanSearch(const AText: string; const AOptions: TdxPDFDocumentTextSearchOptions;APageIndex: Integer): Boolean;
    function CompareWordList(APageWordList: TStringList): Boolean;
    function CompareWords(const AWord1, AWord2: string): Boolean;
    function CreateWordList(const AText: string): TStringList;
    function GetPageText(AWordIndex, ACount: Integer): string;
    function GetProgressPercent: Integer;
    function GetStepDirection(ADirection: TdxPDFDocumentTextSearchDirection): TThreadMethod;
    function Initialize(const AText: string; APageIndex: Integer; const AOptions: TdxPDFDocumentTextSearchOptions): Boolean;
    function PrepareComparingWord(const AWord: string): string;
    function TryCompare: Boolean;
    procedure PackCurrentPageRecognizedContent;
    procedure ProgressChanged;
    procedure RecognizeCurrentPage;
    procedure ResetRecognizedText;
    procedure StepBackward;
    procedure StepForward;
    procedure UpdateProcessedPageIndexes;

    property Document: TdxPDFDocument read FDocument write SetDocument;
    property FoundWords: TdxPDFTextWordList read FFoundWords write SetFoundWords;
    property SearchWords: TStringList read FSearchWords write SetSearchWords;
  strict protected
    procedure ClearProcessedPageIndexes;
  protected
    function GetLastSearchRecord: TdxPDFDocumentTextSearchResult; virtual;
    procedure ClearAfterComplete; virtual;
    procedure DirectionChanged; virtual;
    procedure InternalClear; virtual;
    procedure InternalFind; virtual;
    procedure SetLastSearchRecord(const AValue: TdxPDFDocumentTextSearchResult); virtual;

    function DoFind: Boolean;
    function GetSearchResult(APageIndex: Integer; AWords: TdxPDFTextWordList;
      AStatus: TdxPDFDocumentTextSearchStatus): TdxPDFDocumentTextSearchResult;
    procedure Clear;

    property Completed: Boolean read FCompleted write SetCompleted;
    property HasResults: Boolean read FHasResults;
    property LastSearchResult: TdxPDFDocumentTextSearchResult read GetLastSearchRecord write SetLastSearchRecord;
    property Options: TdxPDFDocumentTextSearchOptions read FOptions write SetOptions;
    property PageIndex: Integer read FPageIndex;
    property SearchStart: Boolean read FSearchStart;
  public
    constructor Create;
    destructor Destroy; override;

    function Find(ADocument: TdxPDFDocument; const AText: string; const AOptions: TdxPDFDocumentTextSearchOptions;
      APageIndex: Integer): TdxPDFDocumentTextSearchResult;

    property OnComplete: TNotifyEvent read FOnComplete write FOnComplete;
    property OnProgress: TdxPDFDocumentTextSearchProgressEvent read FOnProgress write FOnProgress;
  end;

  { TdxPDFDocumentContinuousTextSearch }

  TdxPDFDocumentContinuousTextSearch = class(TdxPDFDocumentSequentialTextSearch)
  strict private
    FCurrentResultIndex: Integer;
    FNotFoundRecordIndex: Integer;
    FSearchResultList: TList<TdxPDFDocumentTextSearchResult>;
    function GetFoundRanges: TdxPDFPageTextRanges;
    procedure CalculateCurrentResultIndex;
  protected
    function GetLastSearchRecord: TdxPDFDocumentTextSearchResult; override;
    procedure ClearAfterComplete; override;
    procedure DirectionChanged; override;
    procedure InternalClear; override;
    procedure InternalFind; override;
    procedure SetLastSearchRecord(const AValue: TdxPDFDocumentTextSearchResult); override;
  public
    constructor Create;
    destructor Destroy; override;

    property FoundRanges : TdxPDFPageTextRanges read GetFoundRanges;
  end;

  { TdxPDFWriteObjectList }

  TdxPDFWriteObjectList = class // for internal use
  strict private
    FHashSet: TdxPDFPointerHashSet;
    FItems: TList;
    //
    function GetCount: Integer;
  protected
    property Items: TList read FItems;
  public
    constructor Create(ACapacity: Integer);
    destructor Destroy; override;
    //
    function Add(AItem: Pointer): Integer;
    function Contains(AItem: Pointer): Boolean;
    procedure Clear;
    //
    property Count: Integer read GetCount;
  end;

  { TdxPDFDocumentCustomWriter }

  TdxPDFDocumentCustomWriter = class(TdxPDFWriter) // for internal use
  strict private
    FContext: TdxPDFDocumentWritingContext;
    FHelper: TdxPDFWriterHelper;
    FObjectsOffsets: TList;
    FWriteObjectList: TdxPDFWriteObjectList;
    //
    procedure AddObjectOffset(AOffset: Integer);
    procedure WriteEndOfDocument;
    procedure WriteHeader;
    procedure WriteObject(AObject: TdxPDFObject);
    procedure WriteObjects;
    procedure WriteTrailer;
    procedure WriteXRef;
  strict protected
    function GetVersion: string; virtual; abstract;
    function HasXRef: Boolean; virtual;
    procedure PopulateTrailer(ADictionary: TdxPDFWriterDictionary); virtual; abstract;
    procedure RegisterTrailerObjects; virtual;
    procedure UpdateProgress(AWrittenObjectCount: Integer); virtual;
    //
    property Helper: TdxPDFWriterHelper read FHelper;
    property ObjectsOffsets: TList read FObjectsOffsets;
  protected
    property WriteObjectList: TdxPDFWriteObjectList read FWriteObjectList;
  public
    constructor Create(AStream: TStream);
    destructor Destroy; override;
    procedure Write; virtual;
  end;

  { TdxPDFDocumentWriter }

  TdxPDFDocumentWriter = class(TdxPDFDocumentCustomWriter) // for internal use
  strict private
    FCurrentProgress: Integer;
    FDocument: TdxPDFDocument;
    FEncryption: TdxPDFObject;
    FEncryptionInfo: TdxPDFEncryptionInfo;

    FOnProgress: TdxPDFDocumentSaveProgressEvent;
  protected
    function CreateEncryptionProvider: IdxPDFEncryptionInfo; override;
    function GetVersion: string; override;
    procedure PopulateTrailer(ADictionary: TdxPDFWriterDictionary); override;
    procedure RegisterTrailerObjects; override;
    procedure UpdateProgress(AWrittenObjectCount: Integer); override;
  public
    constructor Create(ADocument: TdxPDFDocument; AStream: TStream; AOnProgress: TdxPDFDocumentSaveProgressEvent);
    destructor Destroy; override;
    procedure Write(ADeleteEmbeddedSignatures: Boolean); reintroduce;
  end;

function dxPDFDocumentExportToImage(ADocument: TdxPDFDocument; APageIndex, AWidth: Integer;
  AImage: TdxSmartImage; ARotationAngle: TcxRotationAngle = ra0; ACancelCallback: TdxTaskCancelCallback = nil): Boolean;
function dxPDFDocumentExportToImageEx(ADocument: TdxPDFDocument; APageIndex: Integer; const AZoomFactor: Double;
  AImage: TdxSmartImage; ARotationAngle: TcxRotationAngle = ra0; ACancelCallback: TdxTaskCancelCallback = nil): Boolean;
function dxPDFDocumentExportToBitmap(ADocument: TdxPDFDocument; APageIndex: Integer; const AZoomFactor: Double;
  ABitmap: TBitmap; ARotationAngle: TcxRotationAngle = ra0; ACancelCallback: TdxTaskCancelCallback = nil): Boolean;
function dxPDFDocumentExportToPNG(ADocument: TdxPDFDocument; APageIndex: Integer; const AZoomFactor: Double;
  AImage: TdxSmartImage; ARotationAngle: TcxRotationAngle = ra0): Boolean; overload;
function dxPDFDocumentExportToPNG(ADocument: TdxPDFDocument; const AFolder, AFilePrefix: string; const AZoomFactor: Double;
  AHandler: TObject = nil; ARotationAngle: TcxRotationAngle = ra0): Boolean; overload;
function dxPDFDocumentExportToTIFF(ADocument: TdxPDFDocument; const AZoomFactor: Double; AImage: TdxSmartImage;
  AHandler: TObject = nil; ARotationAngle: TcxRotationAngle = ra0): Boolean; overload;
function dxPDFDocumentExportToTIFF(ADocument: TdxPDFDocument; const AFileName: string; const AZoomFactor: Double;
  AHandler: TObject = nil; ARotationAngle: TcxRotationAngle = ra0): Boolean; overload;
//
function dxPDFDocumentGetPagesToRotate(ADocument: TdxPDFDocument; const APageIndexes: array of Integer;
  APageNumbers: TdxPageNumbers; APageOrientation: TdxPageOrientationSubset; AUsePageNumber: Boolean = False): TIntegerDynArray; // for internal use
procedure dxPDFDocumentRotatePages(ADocument: TdxPDFDocument; const APageIndexes: array of Integer;
  AAngle: TcxRotationAngle; APageNumbers: TdxPageNumbers = pnAll;
  APageOrientation: TdxPageOrientationSubset = posAll);  

implementation

{$R dxBiDiData.res}

uses
  Math, Contnrs, dxCore, dxTypeHelpers, dxPDFUtils, dxPDFDocumentStrs, dxPDFAnnotation, dxPDFCommandInterpreter;

const
  dxThisUnitName = 'dxPDFDocument';

type
  TdxPDFBaseAccess = class(TdxPDFBase);
  TdxPDFCatalogAccess = class(TdxPDFCatalog);
  TdxPDFDocumentInformationAccess = class(TdxPDFDocumentInformation);
  TdxPDFDocumentRepositoryAccess = class(TdxPDFDocumentRepository);
  TdxPDFEncryptionInfoAccess = class(TdxPDFEncryptionInfo);
  TdxPDFFormAccess = class(TdxPDFForm);
  TdxPDFObjectAccess = class(TdxPDFObject);
  TdxPDFPageAccess = class(TdxPDFPage);
  TdxPDFPageListAccess = class(TdxPDFPageList);
  TdxPDFSignatureAccess = class(TdxPDFSignature);
  TdxPDFSignatureFieldInfoAccess = class(TdxPDFSignatureFieldInfo);
  TdxPDFTextLineListAccess = class(TdxPDFTextLineList);
  TdxPDFTextWordAccess = class(TdxPDFTextWord);
  TdxPDFTextWordPartAccess = class(TdxPDFTextWordPart);

  { TdxPDFDocumentExport }

  TdxPDFDocumentExport = class
  strict private
    FCancelCallback: TdxTaskCancelCallback;
    FDocument: TdxPDFDocument;
    FFixedWidth: Integer;
    FHandler: TObject;
    FProgressHelper: TcxProgressCalculationHelper;
    FRotationAngle: TcxRotationAngle;
    FZoomFactor: Double;

    function CreateRenderParameters(APage: TdxPDFPage): TdxPDFRenderParameters;
    procedure ProgressHandler(Sender: TObject; APercent: Integer);
    procedure SaveToStream(APageIndex: Integer; AStream: TStream);
  protected
    function GetPageImage(AIndex: Integer; const ASize: TSize; AMode: TcxImageFitMode; var AFrame: TdxSmartImage): Boolean;
    function DoExportToBitmap(APageIndex: Integer; AImage: TGraphic): Boolean; overload;
    function DoExportToBitmap(const AFolder, AFilePrefix: string): Boolean; overload;
    function DoExportToTIFF(AImage: TdxSmartImage): Boolean; overload;
    function DoExportToTIFF(const AFileName: string): Boolean; overload;
  public
    constructor Create(ADocument: TdxPDFDocument; const AZoomFactor: Double; ARotationAngle: TcxRotationAngle;
      AHandler: TObject = nil; ACancelCallback: TdxTaskCancelCallback = nil);
    constructor CreateEx(ADocument: TdxPDFDocument; AWidth: Integer; ARotationAngle: TcxRotationAngle;
      AHandler: TObject = nil; ACancelCallback: TdxTaskCancelCallback = nil);
    destructor Destroy; override;

    class function ExportToBitmapBySize(ADocument: TdxPDFDocument; APageIndex, AWidth: Integer;
      ARotationAngle: TcxRotationAngle; AImage: TdxSmartImage; const ACancelCallback: TdxTaskCancelCallback): Boolean; static;
    class function ExportToBitmapByZoomFactor(ADocument: TdxPDFDocument; APageIndex: Integer; const AZoomFactor: Double;
      ARotationAngle: TcxRotationAngle; AImage: TdxSmartImage; ACancelCallback: TdxTaskCancelCallback = nil): Boolean; overload; static;
    class function ExportToBitmapByZoomFactor(ADocument: TdxPDFDocument; APageIndex: Integer; const AZoomFactor: Double;
      ARotationAngle: TcxRotationAngle; ABitmap: TBitmap; ACancelCallback: TdxTaskCancelCallback = nil): Boolean; overload; static;
    class function ExportToBitmaps(ADocument: TdxPDFDocument; const AFolder, AFilePrefix: string; const AZoomFactor: Double;
      ARotationAngle: TcxRotationAngle; AHandler: TObject = nil): Boolean; static;
    class function ExportToTIFF(ADocument: TdxPDFDocument; const AZoomFactor: Double; AImage: TdxSmartImage;
      ARotationAngle: TcxRotationAngle; AHandler: TObject = nil): Boolean; overload; static;
    class function ExportToTIFF(ADocument: TdxPDFDocument; const AFileName: string; const AZoomFactor: Double;
      ARotationAngle: TcxRotationAngle; AHandler: TObject = nil): Boolean; overload; static;
  end;

function dxPDFDocumentExportToImage(ADocument: TdxPDFDocument; APageIndex, AWidth: Integer;
  AImage: TdxSmartImage; ARotationAngle: TcxRotationAngle = ra0; ACancelCallback: TdxTaskCancelCallback = nil): Boolean;
begin
  Result := TdxPDFDocumentExport.ExportToBitmapBySize(
    ADocument, APageIndex, AWidth, ARotationAngle, AImage, ACancelCallback);
end;

function dxPDFDocumentExportToImageEx(ADocument: TdxPDFDocument; APageIndex: Integer; const AZoomFactor: Double;
  AImage: TdxSmartImage; ARotationAngle: TcxRotationAngle = ra0; ACancelCallback: TdxTaskCancelCallback = nil): Boolean;
begin
  Result := TdxPDFDocumentExport.ExportToBitmapByZoomFactor(
    ADocument, APageIndex, AZoomFactor, ARotationAngle, AImage, ACancelCallback);
end;

function dxPDFDocumentExportToBitmap(ADocument: TdxPDFDocument; APageIndex: Integer; const AZoomFactor: Double;
  ABitmap: TBitmap; ARotationAngle: TcxRotationAngle = ra0; ACancelCallback: TdxTaskCancelCallback = nil): Boolean;
begin
  Result := TdxPDFDocumentExport.ExportToBitmapByZoomFactor(
    ADocument, APageIndex, AZoomFactor, ARotationAngle, ABitmap, ACancelCallback);
end;

function dxPDFDocumentExportToPNG(ADocument: TdxPDFDocument; APageIndex: Integer; const AZoomFactor: Double;
  AImage: TdxSmartImage; ARotationAngle: TcxRotationAngle = ra0): Boolean;
begin
  Result := TdxPDFDocumentExport.ExportToBitmapByZoomFactor(
    ADocument, APageIndex, AZoomFactor, ARotationAngle, AImage, TdxTaskCancelCallback(nil));
end;

function dxPDFDocumentExportToPNG(ADocument: TdxPDFDocument; const AFolder, AFilePrefix: string; const AZoomFactor: Double;
  AHandler: TObject = nil; ARotationAngle: TcxRotationAngle = ra0): Boolean;
begin
  Result := TdxPDFDocumentExport.ExportToBitmaps(ADocument, AFolder, AFilePrefix, AZoomFactor, ARotationAngle, AHandler);
end;

function dxPDFDocumentExportToTIFF(ADocument: TdxPDFDocument; const AZoomFactor: Double; AImage: TdxSmartImage;
  AHandler: TObject = nil; ARotationAngle: TcxRotationAngle = ra0): Boolean; overload;
begin
  Result := TdxPDFDocumentExport.ExportToTIFF(ADocument, AZoomFactor, AImage, ARotationAngle, AHandler);
end;

function dxPDFDocumentExportToTIFF(ADocument: TdxPDFDocument; const AFileName: string; const AZoomFactor: Double;
  AHandler: TObject = nil; ARotationAngle: TcxRotationAngle = ra0): Boolean; overload;
begin
  Result := TdxPDFDocumentExport.ExportToTIFF(ADocument, AFileName, AZoomFactor, ARotationAngle, AHandler);
end;

function dxPDFDocumentGetPagesToRotate(ADocument: TdxPDFDocument; const APageIndexes: array of Integer;
  APageNumbers: TdxPageNumbers; APageOrientation: TdxPageOrientationSubset; AUsePageNumber: Boolean = False): TIntegerDynArray;

  function IsPageNumbersSubset(APageIndex: Integer): Boolean;
  begin
    case APageNumbers of
      pnEven:
        Result := APageIndex mod 2 = 0;
      pnOdd:
        Result := APageIndex mod 2 <> 0;
    else
      Result := True;
    end;
  end;

  function IsPageOrientationSubset(APageIndex: Integer): Boolean;

    function IsPagePortraitOrientation(APageIndex: Integer): Boolean;
    var
      ASize: TdxPointF;
    begin
      ASize := ADocument.PageInfo[APageIndex].Size;
      Result := ASize.X <= ASize.Y;
    end;

  begin
    case APageOrientation of
      posPortrait:
        Result := IsPagePortraitOrientation(APageIndex);
      posLandscape:
        Result := not IsPagePortraitOrientation(APageIndex);
    else
      Result := True;
    end;
  end;

var
  I, APageIndex: Integer;
begin
  SetLength(Result, 0);
  for I := 0 to Length(APageIndexes) - 1 do
  begin
    APageIndex := APageIndexes[I];
    if AUsePageNumber then
      Dec(APageIndex);
    if IsPageNumbersSubset(APageIndex) and IsPageOrientationSubset(APageIndex) then
      TdxPDFUtils.AddValue(APageIndex, Result);
  end;
end;


procedure dxPDFDocumentRotatePages(ADocument: TdxPDFDocument; const APageIndexes: array of Integer;
  AAngle: TcxRotationAngle; APageNumbers: TdxPageNumbers = pnAll; APageOrientation: TdxPageOrientationSubset = posAll);

  procedure DoRotate(const AIndexes: array of Integer; AAngle: TcxRotationAngle);
  var
    I: Integer;
  begin
    ADocument.BeginUpdate;
    try
      for I := 0 to Length(AIndexes) - 1 do
        ADocument.Pages[AIndexes[I]].Rotate(AAngle);
    finally
      ADocument.EndUpdate;
    end;
  end;

begin
  if (ADocument = nil) or (AAngle = ra0) then
    Exit;
  DoRotate(dxPDFDocumentGetPagesToRotate(ADocument, APageIndexes, APageNumbers, APageOrientation), AAngle);
end;

{ TdxPDFDocumentExport }

constructor TdxPDFDocumentExport.Create(
  ADocument: TdxPDFDocument; const AZoomFactor: Double; ARotationAngle: TcxRotationAngle;
  AHandler: TObject = nil; ACancelCallback: TdxTaskCancelCallback = nil);
begin
  inherited Create;
  FDocument := ADocument;
  FZoomFactor := AZoomFactor;
  FHandler := AHandler;
  FProgressHelper := TcxProgressCalculationHelper.Create(1, Self, ProgressHandler);
  FRotationAngle := ARotationAngle;
  FCancelCallback := ACancelCallback;
end;

constructor TdxPDFDocumentExport.CreateEx(ADocument: TdxPDFDocument; AWidth: Integer; ARotationAngle: TcxRotationAngle;
  AHandler: TObject = nil; ACancelCallback: TdxTaskCancelCallback = nil);
begin
  Create(ADocument, 1, ARotationAngle, AHandler, ACancelCallback);
  FFixedWidth := AWidth;
end;

destructor TdxPDFDocumentExport.Destroy;
begin
  FreeAndNil(FProgressHelper);
  inherited Destroy;
end;

class function TdxPDFDocumentExport.ExportToBitmapBySize(ADocument: TdxPDFDocument; APageIndex, AWidth: Integer;
  ARotationAngle: TcxRotationAngle; AImage: TdxSmartImage; const ACancelCallback: TdxTaskCancelCallback): Boolean;
var
  AHelper: TdxPDFDocumentExport;
begin
  AHelper := TdxPDFDocumentExport.CreateEx(ADocument, AWidth, ARotationAngle, nil, ACancelCallback);
  try
    Result := AHelper.DoExportToBitmap(APageIndex, AImage);
  finally
    AHelper.Free;
  end;
end;

class function TdxPDFDocumentExport.ExportToBitmapByZoomFactor(ADocument: TdxPDFDocument; APageIndex: Integer;
  const AZoomFactor: Double; ARotationAngle: TcxRotationAngle; AImage: TdxSmartImage;
  ACancelCallback: TdxTaskCancelCallback = nil): Boolean;
var
  AHelper: TdxPDFDocumentExport;
begin
  AHelper := TdxPDFDocumentExport.Create(ADocument, AZoomFactor, ARotationAngle, nil, ACancelCallback);
  try
    Result := AHelper.DoExportToBitmap(APageIndex, AImage);
  finally
    AHelper.Free;
  end;
end;

class function TdxPDFDocumentExport.ExportToBitmapByZoomFactor(
  ADocument: TdxPDFDocument; APageIndex: Integer; const AZoomFactor: Double;
  ARotationAngle: TcxRotationAngle; ABitmap: TBitmap; ACancelCallback: TdxTaskCancelCallback = nil): Boolean;
var
  AHelper: TdxPDFDocumentExport;
begin
  AHelper := TdxPDFDocumentExport.Create(ADocument, AZoomFactor, ARotationAngle, nil, ACancelCallback);
  try
    Result := AHelper.DoExportToBitmap(APageIndex, ABitmap);
  finally
    AHelper.Free;
  end;
end;

class function TdxPDFDocumentExport.ExportToBitmaps(ADocument: TdxPDFDocument; const AFolder, AFilePrefix: string;
  const AZoomFactor: Double; ARotationAngle: TcxRotationAngle; AHandler: TObject = nil): Boolean;
var
  AHelper: TdxPDFDocumentExport;
begin
  AHelper := TdxPDFDocumentExport.Create(ADocument, AZoomFactor, ARotationAngle, AHandler);
  try
    Result := AHelper.DoExportToBitmap(AFolder, AFilePrefix);
  finally
    AHelper.Free;
  end;
end;

class function TdxPDFDocumentExport.ExportToTIFF(ADocument: TdxPDFDocument; const AZoomFactor: Double; AImage: TdxSmartImage;
  ARotationAngle: TcxRotationAngle; AHandler: TObject = nil): Boolean;
var
  AHelper: TdxPDFDocumentExport;
begin
  AHelper := TdxPDFDocumentExport.Create(ADocument, AZoomFactor, ARotationAngle, AHandler);
  try
    Result := AHelper.DoExportToTIFF(AImage);
  finally
    AHelper.Free;
  end;
end;

class function TdxPDFDocumentExport.ExportToTIFF(ADocument: TdxPDFDocument; const AFileName: string; const AZoomFactor: Double;
  ARotationAngle: TcxRotationAngle; AHandler: TObject = nil): Boolean;
var
  AHelper: TdxPDFDocumentExport;
begin
  AHelper := TdxPDFDocumentExport.Create(ADocument, AZoomFactor, ARotationAngle, AHandler);
  try
    Result := AHelper.DoExportToTIFF(AFileName);
  finally
    AHelper.Free;
  end;
end;

function TdxPDFDocumentExport.GetPageImage(AIndex: Integer;
  const ASize: TSize; AMode: TcxImageFitMode; var AFrame: TdxSmartImage): Boolean;
begin
  AFrame := TdxSmartImage.Create;
  Result := ExportToBitmapByZoomFactor(FDocument, AIndex, FZoomFactor, FRotationAngle, AFrame);
  FProgressHelper.NextTask;
end;

function TdxPDFDocumentExport.DoExportToBitmap(APageIndex: Integer; AImage: TGraphic): Boolean;
var
  AStream: TMemoryStream;
begin
  AStream := TMemoryStream.Create;
  try
    SaveToStream(APageIndex, AStream);
    AStream.Position := 0;
    AImage.LoadFromStream(AStream);
    Result := True;
  finally
    AStream.Free;
  end;
end;

function TdxPDFDocumentExport.DoExportToBitmap(const AFolder, AFilePrefix: string): Boolean;
var
  I: Integer;
  AImage: TdxSmartImage;
  AFileStream: TFileStream;
  AOutputFolder: string;
begin
  if not DirectoryExists(AFolder) then
    CreateDir(AFolder);
  AOutputFolder := dxIncludeTrailingPathDelimiter(AFolder);
  FProgressHelper.BeginStage(FDocument.PageCount);
  Result := False;
  try
    for I := 0 to FDocument.PageCount - 1 do
    begin
      AImage := TdxSmartImage.Create;
      try
        Result := ExportToBitmapByZoomFactor(FDocument, I, FZoomFactor, FRotationAngle, AImage);
        if Result then
        begin
          AFileStream := TFileStream.Create(AOutputFolder + AFilePrefix + IntToStr(I) + '.png', fmCreate);
          try
            AImage.SaveToStreamByCodec(AFileStream, dxImagePng);
          finally
            AFileStream.Free;
          end;
        end;
      finally
        AImage.Free;
      end;
      FProgressHelper.NextTask;
    end;
  finally
    FProgressHelper.EndStage;
  end;
end;

function TdxPDFDocumentExport.DoExportToTIFF(AImage: TdxSmartImage): Boolean;
var
  ATemp: TdxSmartImage;
begin
  FProgressHelper.BeginStage(FDocument.PageCount);
  try
    try
      ATemp := dxCreateMultiFrameTIFF(FDocument.PageCount, cxNullSize, ifmNormal, GetPageImage);
      Result := ATemp <> nil;
      if Result then
        try
          AImage.Assign(ATemp);
        finally
          ATemp.Free;
        end;
    except
    {$IFNDEF DELPHI102TOKYO}
       Result := False;
    {$ENDIF}
    end;
    Result := AImage <> nil;
  finally
    FProgressHelper.EndStage;
  end;
end;

function TdxPDFDocumentExport.DoExportToTIFF(const AFileName: string): Boolean;
var
  AImage: TdxSmartImage;
begin
  AImage := TdxSmartImage.Create;
  try
    Result := DoExportToTIFF(AImage);
    if Result then
      try
        AImage.SaveToFile(AFileName);
      except
        Result := False;
      end;
  finally
    AImage.Free;
  end;
end;

function TdxPDFDocumentExport.CreateRenderParameters(APage: TdxPDFPage): TdxPDFRenderParameters;

  function GetScaleFactor: Double;
  begin
    if FFixedWidth = 0 then
      Result := FZoomFactor * APage.UserUnit * 96 / 72
    else
      Result := FFixedWidth / APage.Size.X;
  end;

  function GetRect(AScaleFactor: Double): TRect;
  begin
    if FFixedWidth = 0 then
      Result := cxRect(0, 0, Trunc(APage.Size.X * AScaleFactor), Trunc(APage.Size.Y * AScaleFactor))
    else
      Result := cxRect(0, 0, FFixedWidth, Round(FFixedWidth * APage.Size.Y / APage.Size.X));
    if (FRotationAngle = raPlus90) or (FRotationAngle = raMinus90) then
      Result := cxRectRotate(Result);
  end;

begin
  Result := TdxPDFRenderParameters.Create(FDocument.State);
  Result.ScaleFactor := GetScaleFactor;
  Result.Rect := GetRect(Result.ScaleFactor);
  Result.Angle := FRotationAngle;
  Result.CancelCallback := FCancelCallback;
end;

procedure TdxPDFDocumentExport.ProgressHandler(Sender: TObject; APercent: Integer);
var
  AIntf: IcxProgress;
begin
  if Supports(FHandler, IcxProgress, AIntf) then
    AIntf.OnProgress(Sender, APercent);
end;

procedure TdxPDFDocumentExport.SaveToStream(APageIndex: Integer; AStream: TStream);
var
  APage: TdxPDFPage;
  AParameters: TdxPDFRenderParameters;
begin
  APage := FDocument.Pages.List[APageIndex];
  AParameters := CreateRenderParameters(APage);
  try
    TdxPDFPageAccess(APage).Export(AParameters, AStream);
  finally
    AParameters.Free;
  end;
end;

{ TdxPDFDocumentTextSearchOptions }

class function TdxPDFDocumentTextSearchOptions.Default: TdxPDFDocumentTextSearchOptions;
begin
  Result.CaseSensitive := False;
  Result.Direction := tsdForward;
  Result.WholeWords := False;
end;

{ TdxPDFPageInfo }

procedure TdxPDFPageInfo.Initialize(APage: TdxPDFPage);
begin
  FPage := APage;
end;

procedure TdxPDFPageInfo.Pack;
begin
  FPage.Pack;
end;

procedure TdxPDFPageInfo.Rotate(AAngle: TcxRotationAngle);
begin
  TdxPDFPageAccess(FPage).Rotate(TdxPDFUtils.ConvertToIntEx(AAngle));
end;

function TdxPDFPageInfo.CanRecognizeContent: Boolean;
begin
  Result := AllowContentExtraction and (FPage.RecognizedContent <> nil);
end;

function TdxPDFPageInfo.AllowContentExtraction: Boolean;
begin
  Result := (TdxPDFPageAccess(FPage).Document as TdxPDFDocument).AllowContentExtraction;
end;

function TdxPDFPageInfo.GetHyperlinks: TdxPDFHyperlinkList;
begin
  if CanRecognizeContent then
    Result := TdxPDFPageAccess(FPage).Hyperlinks
  else
    Result := nil;
end;

function TdxPDFPageInfo.GetImages: TdxPDFImageList;
begin
  if CanRecognizeContent then
    Result := FPage.RecognizedContent.Images
  else
    Result := nil;
end;

function TdxPDFPageInfo.GetRotationAngle: TcxRotationAngle;
begin
  Result := TdxPDFUtils.ConvertToRotationAngle(FPage.RotationAngle);
end;

function TdxPDFPageInfo.GetSize: TdxPointF;
begin
  Result := FPage.Size;
end;

function TdxPDFPageInfo.GetText: string;
begin
  if CanRecognizeContent then
    Result := FPage.RecognizedContent.Text
  else
    Result := '';
end;

function TdxPDFPageInfo.GetUserUnit: Integer;
begin
  Result := FPage.UserUnit;
end;

{ TdxPDFPages }

constructor TdxPDFPages.Create(ADocument: TdxPDFDocument);
begin
  inherited Create;
  FDocument := ADocument;
end;

procedure TdxPDFPages.Add(ASource: TdxPDFDocument; ASourceIndex: Integer);
begin
  Insert(Count, ASource, ASourceIndex);
end;

procedure TdxPDFPages.Add(ASource: TdxPDFDocument; const ASourceIndexes: array of Integer);
begin
  Insert(Count, ASource, ASourceIndexes);
end;

procedure TdxPDFPages.Delete(AIndex: Integer);
begin
  TdxPDFPageListAccess(List).Delete(AIndex);
end;

procedure TdxPDFPages.Delete(const AIndexes: array of Integer);
var
  I: Integer;
begin
  FDocument.BeginUpdate;
  try
    for I := 0 to Length(AIndexes) - 1 do
      Delete(AIndexes[I]);
  finally
    FDocument.EndUpdate;
  end;
end;

procedure TdxPDFPages.Insert(AIndex: Integer; ASource: TdxPDFDocument);
begin
  Insert(AIndex, ASource, TdxPDFUtils.ConvertToPageIndexes(ASource.PageCount));
end;

procedure TdxPDFPages.Insert(AIndex: Integer; ASource: TdxPDFDocument; ASourceIndex: Integer);
begin
  Insert(AIndex, ASource, [ASourceIndex]);
end;

procedure TdxPDFPages.Insert(AIndex: Integer; ASource: TdxPDFDocument; const ASourceIndexes: array of Integer);
begin
  if ASource.IsEmpty then
    Exit;
  FDocument.BeginUpdate;
  try
    FDocument.ClonePages(ASource, ASourceIndexes, AIndex, False);
  finally
    FDocument.EndUpdate;
  end;
end;

procedure TdxPDFPages.Move(ACurrentIndex, ANewIndex: Integer);
begin
  TdxPDFPageListAccess(FDocument.Pages.List).Move(ACurrentIndex, ANewIndex);
end;

procedure TdxPDFPages.Move(const ACurrentIndexes: array of Integer; ANewIndex: Integer);
begin
  FDocument.BeginUpdate;
  try
    TdxPDFPageListAccess(FDocument.Pages.List).Move(ACurrentIndexes, ANewIndex);
  finally
    FDocument.EndUpdate;
  end;
end;

function TdxPDFPages.GetCount: Integer;
begin
  Result := List.Count;
end;

function TdxPDFPages.GetItem(AIndex: Integer): TdxPDFPageInfo;
begin
  Result.Initialize(List[AIndex]);
end;

function TdxPDFPages.GetList: TdxPDFPageList;
begin
  Result := FDocument.Catalog.Pages;
end;

{ TdxPDFSecurityOptions }

constructor TdxPDFSecurityOptions.Create;
begin
  Reset;
end;

procedure TdxPDFSecurityOptions.Assign(Source: TPersistent);
begin
  if Source is TdxPDFSecurityOptions then
  begin
    Enabled := TdxPDFSecurityOptions(Source).Enabled;
    Algorithm := TdxPDFSecurityOptions(Source).Algorithm;
    Permissions := TdxPDFSecurityOptions(Source).Permissions;
    OwnerPassword := TdxPDFSecurityOptions(Source).OwnerPassword;
    UserPassword := TdxPDFSecurityOptions(Source).UserPassword;
  end;
end;

procedure TdxPDFSecurityOptions.Reset;
begin
  Algorithm := eatRC128Bit;
  Permissions := [Low(TdxPDFDocumentPermission)..High(TdxPDFDocumentPermission)];
  Enabled := False;
  OwnerPassword := '';
  UserPassword := '';
end;

{ TdxPDFSignatureOptions }

constructor TdxPDFSignatureOptions.Create;
begin
  inherited Create;
  FEmbeddedSignatures := TdxPDFSignatureFieldInfoList.Create;
  FSignature := TdxPDFSignatureFieldInfo.Create;
  Reset;
end;

destructor TdxPDFSignatureOptions.Destroy;
begin
  FreeAndNil(FSignature);
  FreeAndNil(FEmbeddedSignatures);
  inherited Destroy;
end;

function TdxPDFSignatureOptions.IsDocumentSigned: Boolean;
begin
  Result := EmbeddedSignatureCount > 0;
end;

procedure TdxPDFSignatureOptions.Assign(Source: TPersistent);
begin
  if Source is TdxPDFSignatureOptions then
  begin
    Enabled := TdxPDFSignatureOptions(Source).Enabled;
    FDocument := TdxPDFSignatureOptions(Source).FDocument;
    Signature.Assign(TdxPDFSignatureOptions(Source).Signature);
  end;
end;

procedure TdxPDFSignatureOptions.Reset;
begin
  FEnabled := False;
  FSignature.Certificate := nil;
  FSignature.ContactInfo := '';
  FSignature.Location := '';
  FSignature.Reason := '';
end;

function TdxPDFSignatureOptions.Contains(AField: TdxPDFInteractiveFormSignatureField): Boolean;
var
  AInfo: TdxPDFSignatureFieldInfo;
begin
  for AInfo in FEmbeddedSignatures do
    if TdxPDFSignatureFieldInfoAccess(AInfo).FField = AField then
      Exit(True);
  Result := False;
end;

function TdxPDFSignatureOptions.IsSignatureValid: Boolean;
begin
  Result := (Signature.ContactInfo <> '') and (Signature.Location <> '') and (Signature.Reason <> '') and
    (Signature.Certificate <> nil);
end;

procedure TdxPDFSignatureOptions.AddEmbeddedSignature(AField: TdxPDFInteractiveFormSignatureField);

  function CreateInfo: TdxPDFSignatureFieldInfo;
  var
    APageIndex: Integer;
    ARect: TRect;
    ASignature: TdxPDFSignature;
  begin
    Result := TdxPDFSignatureFieldInfo.Create;
    TdxPDFSignatureFieldInfoAccess(Result).FField := AField;
    if AField.Widget <> nil then
    begin
      APageIndex := AField.Widget.PageIndex;
      TdxPDFSignatureFieldInfoAccess(Result).Appearance.Bounds.PageIndex := APageIndex;
      if APageIndex >= 0 then
      begin
        ARect := AField.Widget.Rect.ToRectF.DeflateToTRect;
        ARect.Top := Trunc(TdxPDFObjectAccess(AField).Repository.Catalog.Pages[APageIndex].Bounds.Top - Abs(ARect.Height));
        ARect.Height := Trunc(Abs(AField.Widget.Rect.Height));
      end
      else
        ARect := cxNullRect;
      TdxPDFSignatureFieldInfoAccess(Result).Appearance.Bounds.Rect := ARect;
      if AField.Widget is TdxPDFWidgetAnnotation then
      begin
        TdxPDFSignatureFieldInfoAccess(Result).Appearance.RotationAngle :=
          TdxPDFUtils.ConvertToRotationAngle(TdxPDFWidgetAnnotation(AField.Widget).RotationAngle);
      end;
    end;
    ASignature := AField.Signature as TdxPDFSignature;
    if ASignature <> nil then
      TdxPDFSignatureAccess(ASignature).Populate(Result);
  end;

begin
  if not Contains(AField) then
    FEmbeddedSignatures.Add(CreateInfo);
end;

procedure TdxPDFSignatureOptions.DeleteEmbeddedSignature(AField: TdxPDFInteractiveFormSignatureField);
var
  AInfo: TdxPDFSignatureFieldInfo;
begin
  for AInfo in FEmbeddedSignatures do
    if TdxPDFSignatureFieldInfoAccess(AInfo).FField = AField then
    begin
      FEmbeddedSignatures.Remove(AInfo);
      Break;
    end;
end;

procedure TdxPDFSignatureOptions.DeleteEmbeddedSignatures;
var
  AInfo: TdxPDFSignatureFieldInfo;
begin
  while EmbeddedSignatureCount > 0 do
  begin
    AInfo := FEmbeddedSignatures.First;
    FDocument.AcroForm.Delete(TdxPDFSignatureFieldInfoAccess(AInfo).FField, True);
    FEmbeddedSignatures.Remove(AInfo);
  end;
end;

procedure TdxPDFSignatureOptions.Validate(AAllowSignatureRemoval : Boolean);
begin
  if not AAllowSignatureRemoval and IsDocumentSigned then
    TdxPDFUtils.RaiseException('The document has a digital signature and cannot be saved. ' +
      'To remove the signature and save the document, call the method again and pass True for ' +
      'the AAllowSignatureRemoval parameter.');
  if Enabled and not IsSignatureValid then
    TdxPDFUtils.RaiseException('Cannot sign the document. The signature information is incomplete.');
end;

function TdxPDFSignatureOptions.GetEmbeddedSignatureCount: Integer;
begin
  Result := FEmbeddedSignatures.Count;
end;

function TdxPDFSignatureOptions.GetEmbeddedSignature(Index: Integer): TdxPDFSignatureFieldInfo;
begin
  Result := FEmbeddedSignatures[Index];
end;

procedure TdxPDFSignatureOptions.SetSignature(const AValue: TdxPDFSignatureFieldInfo);
begin
  FSignature.Assign(AValue);
end;

{ TdxPDFDocument }

constructor TdxPDFDocument.Create;
begin
  inherited Create;
  FListenerList := TInterfaceList.Create;
  CreateSubClasses;
  Initialize;
end;

destructor TdxPDFDocument.Destroy;
begin
  FOnGetPassword := nil;
  FOnLoaded := nil;
  FOnUnloaded := nil;
  FOnSearchProgress := nil;
  Clear;
  DestroySubClasses;
  FListenerList := nil;
  inherited Destroy;
end;

function TdxPDFDocument.FindText(const AText: string): TdxPDFDocumentTextSearchResult;
var
  AOptions: TdxPDFDocumentTextSearchOptions;
begin
  AOptions.CaseSensitive := False;
  AOptions.WholeWords := False;
  AOptions.Direction := tsdForward;
  Result := FindText(AText, AOptions);
end;

function TdxPDFDocument.FindText(const AText: string; const AOptions: TdxPDFDocumentTextSearchOptions): TdxPDFDocumentTextSearchResult;
begin
  Result := FindText(AText, AOptions, 0);
end;

function TdxPDFDocument.FindText(const AText: string; const AOptions: TdxPDFDocumentTextSearchOptions;
  APageIndex: Integer): TdxPDFDocumentTextSearchResult;
begin
  Result := FTextSearch.Find(Self, AText, AOptions, APageIndex);
end;

procedure TdxPDFDocument.FindText(const AText: string; const AOptions: TdxPDFDocumentTextSearchOptions;
  var AFoundRanges: TdxPDFPageTextRanges);
var
  AAdvancedTextSearch: TdxPDFDocumentContinuousTextSearch;
begin
  AAdvancedTextSearch := TdxPDFDocumentContinuousTextSearch.Create;
  AAdvancedTextSearch.OnProgress := OnSearchProgress;
  try
    AAdvancedTextSearch.Find(Self, AText, AOptions, 0);
    AFoundRanges := AAdvancedTextSearch.FoundRanges;
  finally
    AAdvancedTextSearch.Free;
  end;
end;

procedure TdxPDFDocument.Append(const AFileName: string);
var
  ADocument: TdxPDFDocument;
begin
  if IsEmpty then
    LoadFromFile(AFileName)
  else
  begin
    ADocument := TdxPDFDocument.Create;
    try
      ADocument.LoadFromFile(AFileName);
      Append(ADocument);
    finally
      ADocument.Free;
    end;
  end;
end;

procedure TdxPDFDocument.Append(AStream: TStream);
var
  ADocument: TdxPDFDocument;
begin
  if IsEmpty then
    LoadFromStream(AStream)
  else
  begin
    ADocument := TdxPDFDocument.Create;
    try
      ADocument.LoadFromStream(AStream);
      Append(ADocument);
    finally
      ADocument.Free;
    end;
  end;
end;

procedure TdxPDFDocument.Append(ASource: TdxPDFDocument);
begin
  BeginUpdate;
  try
    ClonePages(ASource, TdxPDFUtils.ConvertToPageIndexes(ASource.PageCount), PageCount, True);
  finally
    EndUpdate;
  end;
end;

procedure TdxPDFDocument.BeginUpdate;
begin
  Inc(FLockCount);
end;

procedure TdxPDFDocument.Clear;
begin
  DoClear;
end;

procedure TdxPDFDocument.EndUpdate;
begin
  Dec(FLockCount);
  Changed;
end;

procedure TdxPDFDocument.LoadFromFile(const AFileName: string);
begin
  Load(CreateStream(AFileName), AFileName);
end;

procedure TdxPDFDocument.LoadFromStream(AStream: TStream);
begin
  Load(CreateStream(AStream));
end;

procedure TdxPDFDocument.SaveToFile(const AFileName: string; AAllowSignatureRemoval: Boolean = False;
  AResetModified: Boolean = True);
const
  BufferSize = 256 * 1024;
var
  AStream: TdxBufferedStream;
begin
  if IsEmpty then
    Exit;
  SignatureOptions.Validate(AAllowSignatureRemoval);
  AStream := TdxBufferedStream.Create(AFileName, fmCreate, BufferSize);
  try
    SaveToStream(AStream, AAllowSignatureRemoval, AResetModified);
  finally
    AStream.Free;
  end;
end;

procedure TdxPDFDocument.SaveToStream(AStream: TStream; AAllowSignatureRemoval: Boolean = False;
  AResetModified: Boolean = True);
begin
  Save(AStream, AAllowSignatureRemoval, True, AResetModified);
end;

function TdxPDFDocument.DoCreateDocumentState: TdxPDFDocumentState;
begin
  Result := TdxPDFDocumentState.Create(Self);
end;

procedure TdxPDFDocument.AddChange(AChange: TdxPDFDocumentChange);
begin
  Include(FChanges, AChange);
end;

procedure TdxPDFDocument.AddListener(const AListener: IdxPDFDocumentListener);
begin
  FListenerList.Add(AListener);
end;

procedure TdxPDFDocument.BeforeClear;
begin
  // do nothing
end;

procedure TdxPDFDocument.ClonePages(ADocument: TdxPDFDocument; const APageIndexes: array of Integer;
  ATargetPageIndex: Integer; ACloneNonePageContent: Boolean);
begin
  TdxPDFCloningContext.Clone(Repository, ADocument.Catalog, APageIndexes, Max(0, ATargetPageIndex), ACloneNonePageContent);
end;

procedure TdxPDFDocument.CreateSubClasses;
begin
  ClearEncryptionDictionaryNumber;
  CreateEmptyRepository;
  FPages := TdxPDFPages.Create(Self);

  FSecurityOptions := TdxPDFSecurityOptions.Create;
  FSignatureOptions := TdxPDFSignatureOptions.Create;
  FSignatureOptions.FDocument := Self;
  FTextSearch := TdxPDFDocumentSequentialTextSearch.Create;
  FTextSearch.OnProgress := OnSearchProgress;

  FEncryptionDictionary := nil;
end;

procedure TdxPDFDocument.DestroySubClasses;
begin
  FreeAndNil(FForm);
  FreeAndNil(FState);
  FreeAndNil(FSignatureOptions);
  FreeAndNil(FSecurityOptions);
  FreeAndNil(FTextSearch);
  EncryptionDictionary := nil;
  FreeAndNil(FInformation);
  FreeAndNil(FPages);
  FreeAndNil(FCatalog);
  FRepository.Catalog := nil;
  if Repository <> nil then
    FRepository.Clear;
  dxPDFFreeObject(FRepository);
  FRepository := nil;
end;

procedure TdxPDFDocument.DoFieldEditValueChanged(ASender: TObject);
begin
  if not IsLocked then
    dxCallNotify(OnFieldEditValueChanged, ASender);
end;

procedure TdxPDFDocument.DoFieldEditValueChanging(ASender: TdxPDFCustomField; const AOldValue, ANewValue: Variant;
  var AAccept: Boolean);
begin
  if not IsLocked and Assigned(OnFieldEditValueChanging) then
    OnFieldEditValueChanging(ASender, AOldValue, ANewValue, AAccept);
end;

procedure TdxPDFDocument.Load(AStream: TStream; const AFileName: string = '');
begin
  Clear;
  PopulateLoadInfo(AFileName, AStream);
  CreateRepository(AStream);
  if not DoLoad then
    DoClear;
end;

procedure TdxPDFDocument.RemoveListener(const AListener: IdxPDFDocumentListener);
begin
  FListenerList.Remove(AListener);
end;

procedure TdxPDFDocument.Save(AStream: TStream; AAllowSignatureRemoval, AClearSignatures: Boolean;
  AResetModified: Boolean = False);
var
  AWriter: TdxPDFDocumentWriter;
begin
  if IsEmpty then
    Exit;
  SignatureOptions.Validate(AAllowSignatureRemoval);
  Catalog.Metadata.Update(Information);
  AWriter := TdxPDFDocumentWriter.Create(Self, AStream, OnSaveProgress);
  try
    AWriter.Write(AClearSignatures);
  finally
    AWriter.Free;
  end;
  if AResetModified then
    SetModified(False);
end;

procedure TdxPDFDocument.UpdateForm;
begin
  if FForm <> nil then
    TdxPDFFormAccess(FForm).Update;
end;

function TdxPDFDocument.ApplySignature(ASignatureInfo: TdxPDFSignatureFieldInfo): TdxPDFSignature;
var
  AField: TdxPDFInteractiveFormSignatureField;
begin
  if SignatureOptions.Enabled then
  begin
    AField := AcroForm.AddSignatureField(ASignatureInfo) as TdxPDFInteractiveFormSignatureField;
    Result := AField.Signature as TdxPDFSignature;
  end
  else
    Result := nil;
end;

procedure TdxPDFDocument.ClearRecognizedContent;
var
  I: Integer;
begin
  for I := 0 to PageCount - 1 do
    Pages.List[I].PackRecognizedContent(True);
end;

function TdxPDFDocument.GetFontByName(const AFontName: string): TdxPDFCustomFont;
begin
  Result := nil;
end;

function TdxPDFDocument.IsLocked: Boolean;
begin
  Result := FLockCount <> 0;
end;

procedure TdxPDFDocument.SetModified(AValue: Boolean);
begin
  FModified := AValue;
end;

procedure TdxPDFDocument.ResetModified;
begin
  SetModified(False);
end;

function TdxPDFDocument.GetAcroForm: TdxPDFInteractiveForm;
begin
  Result := FCatalog.AcroForm;
end;

function TdxPDFDocument.GetAllowContentExtraction: Boolean;
begin
  Result := (EncryptionInfo = nil) or EncryptionInfo.AllowContentExtraction;
end;

function TdxPDFDocument.GetAllowPrinting: Boolean;
begin
  Result := (EncryptionInfo = nil) or EncryptionInfo.AllowPrinting;
end;

function TdxPDFDocument.GetBookmarks: TdxPDFBookmarkList;
begin
  Result := FCatalog.Bookmarks;
end;

function TdxPDFDocument.GetEncryptionInfo: TdxPDFEncryptionInfo;
begin
  if FRepository <> nil then
    Result := FRepository.EncryptionInfo
  else
    Result := nil;
end;

function TdxPDFDocument.GetFileAttachments: TdxPDFFileAttachmentList;
begin
  Result := FCatalog.FileAttachments;
end;

function TdxPDFDocument.GetFileName: string;
begin
  Result := FLoadInfo.FileName;
end;

function TdxPDFDocument.GetFileSize: Int64;
begin
  if FLoadInfo.FileStream <> nil then
    Result := FLoadInfo.FileStream.Size
  else
    Result := 0;
end;

function TdxPDFDocument.GetForm: TdxPDFForm;
begin
  if FForm = nil then
    FForm := TdxPDFForm.Create(Self);
  Result := FForm;
end;

function TdxPDFDocument.GetIsEmpty: Boolean;
begin
  Result := FState.IsEmpty;
end;

function TdxPDFDocument.GetIsEncrypted: Boolean;
begin
  Result := FEncryptionDictionary <> nil;
  if not Result and TdxPDFUtils.IsIntegerValid(FEncryptionDictionaryNumber) then
  begin
    EncryptionDictionary := Repository.GetDictionary(FEncryptionDictionaryNumber);
    Result := EncryptionDictionary <> nil;
  end;
end;

function TdxPDFDocument.GetOutlines: TdxPDFOutlines;
begin
  Result := Catalog.Outlines;
end;

function TdxPDFDocument.GetPageCount: Integer;
begin
  Result := Pages.Count;
end;

function TdxPDFDocument.GetPageInfo(AIndex: Integer): TdxPDFPageInfo;
begin
  Result := Pages[AIndex];
end;

function TdxPDFDocument.GetParser: TdxPDFDocumentParser;
begin
  Result := Repository.Parser;
end;

procedure TdxPDFDocument.SetAcroFrom(const AValue: TdxPDFInteractiveForm);
begin
  FCatalog.AcroForm := AValue;
end;

procedure TdxPDFDocument.SetCatalog(const AValue: TdxPDFCatalog);
begin
  if AValue <> FCatalog then
  begin
    FCatalog.Free;
    FCatalog := AValue;
    Repository.Catalog := FCatalog;
    CreateDocumentState;
  end;
end;

procedure TdxPDFDocument.SetChanges(const AValue: TdxPDFDocumentChanges);
begin
  if FChanges <> AValue then
  begin
    FChanges := FChanges + AValue;
    Changed;
  end;
end;

procedure TdxPDFDocument.SetEncryptionDictionary(const AValue: TdxPDFDictionary);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FEncryptionDictionary));
end;

procedure TdxPDFDocument.SetRepository(const AValue: TdxPDFDocumentRepository);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FRepository));
end;

procedure TdxPDFDocument.SetOnSearchProgress(const AValue: TdxPDFDocumentTextSearchProgressEvent);
begin
  FOnSearchProgress := AValue;
  FTextSearch.OnProgress := FOnSearchProgress;
end;

procedure TdxPDFDocument.SetSecurityOptions(const AValue: TdxPDFSecurityOptions);
begin
  FSecurityOptions.Assign(AValue);
end;

procedure TdxPDFDocument.SetSignatureOptions(const AValue: TdxPDFSignatureOptions);
begin
  FSignatureOptions.Assign(AValue);
end;

function TdxPDFDocument.CreateStream(AStream: TStream): TMemoryStream;
begin
  Result := TMemoryStream.Create;
  try
    Result.LoadFromStream(AStream);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

function TdxPDFDocument.CreateStream(const AFileName: string): TMemoryStream;
var
  AFileStream: TFileStream;
begin
  AFileStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    Result := CreateStream(AFileStream);
  finally
    AFileStream.Free;
  end;
end;

function TdxPDFDocument.DoLoad: Boolean;
var
  ASavedStartPosition: Int64;
begin
  Result := False;
  ASavedStartPosition := 0;
  try
    try
      ReadVersion;
      Parser.SaveStartPosition;
      ASavedStartPosition := Parser.StartPosition;
      ReadTrailer;
      Result := DoReadDocument;
    except
      on E: EdxPDFEncryptionException do
        raise;
    else
      try
        RecreateCatalog;
        Parser.StartPosition := ASavedStartPosition;
        ReadCorruptedDocument;
        Result := DoReadDocument;
      except
        on E: EdxPDFAbortException do
          TdxPDFUtils.RaiseException;
        else
          raise;
       end;
    end;
  except
    DoClear;
    raise;
  end;
end;

function TdxPDFDocument.DoReadDocument: Boolean;
begin
  if IsEncrypted then
  begin
    Repository.ReadEncryptionInfo(FEncryptionDictionary, FID);
    Result := Repository.CheckPassword(PasswordAttemptsLimit, OnGetPassword);
    if not Result then
      TdxPDFUtils.RaiseException(cxGetResourceString(@sdxPDFDocumentIncorrectPassword), EdxPDFEncryptionException);
  end
  else
    Result := True;

  if Result then
  begin
    BeginUpdate;
    try
      TdxPDFObjectAccess(FCatalog).Read(Repository.GetDictionary(FRootObjectNumber));
      if TdxPDFUtils.IsIntegerValid(FInfoObjectNumber) then
        TdxPDFObjectAccess(Information).Read(Repository.GetDictionary(FInfoObjectNumber));
      PopulateSecurityOptions;
      SignatureOptions.Reset;
      FChanges := [];
      FNeedLoadedNotification := True;
      UpdateInformation;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdxPDFDocument.AcroFormChanged;
begin
  Include(FChanges, dcModified);
  Include(FChanges, dcLayout);
  Include(FChanges, dcInteractiveLayer);
  Changed;
end;

procedure TdxPDFDocument.Changed;
var
  I: Integer;
begin
  if not IsLocked then
  begin
    UpdateForm;

    SetModified(FModified or (dcModified in FChanges));
    if FNeedClearedNotification then
    begin
      SetModified(dcModified in FChanges);
      dxCallNotify(OnUnloaded, Self);
      FNeedClearedNotification := False;
    end;

    if FNeedLoadedNotification and Assigned(OnLoaded) then
    begin
      FOnLoaded(Self, FLoadInfo);
      FNeedLoadedNotification := False;
    end;

    State.Update(FChanges);

    if FChanges <> [] then
    begin
      for I := 0 to FListenerList.Count - 1 do
        IdxPDFDocumentListener(FListenerList[I]).Changed(FChanges);
      if not IsEmpty then
        dxCallNotify(OnChanged, Self);
      FChanges := [];
    end;
  end;
end;

procedure TdxPDFDocument.ClearEncryptionDictionaryNumber;
begin
  FEncryptionDictionaryNumber := dxPDFInvalidValue;
end;

procedure TdxPDFDocument.ClearLoadInfo;
begin
  FLoadInfo.FileName := '';
  FLoadInfo.FileStream := nil;
end;

procedure TdxPDFDocument.CreateDocumentState;
begin
  FreeAndNil(FState);
  FState := DoCreateDocumentState;
end;

procedure TdxPDFDocument.CreateEmptyRepository;
begin
  CreateRepository(TMemoryStream.Create);
end;

procedure TdxPDFDocument.CreateRepository(AStream: TStream);
begin
  if FRepository <> nil then
    FRepository.Free;
  FRepository := TdxPDFDocumentRepository.Create(Self, AStream);
  TdxPDFDocumentRepositoryAccess(FRepository).OnAddField := OnAddFieldHandler;
  TdxPDFDocumentRepositoryAccess(FRepository).OnDeleteField := OnDeleteFieldHandler;
  FRepository.Reference;
  RecreateCatalog;
  FreeAndNil(FInformation);
  FInformation := TdxPDFDocumentInformation.CreateEx(Repository);
end;

procedure TdxPDFDocument.DoClear;
begin
  BeforeClear;
  SetLength(FID[0], 0);
  SetLength(FID[1], 0);
  ClearEncryptionDictionaryNumber;
  TextSearch.Clear;
  ClearLoadInfo;
  ClearRecognizedContent;
  DestroySubClasses;
  CreateSubClasses;
  FChanges := [];
  FNeedClearedNotification := True;
  Changed;
end;

procedure TdxPDFDocument.Initialize;
begin
  FPasswordAttemptsLimit := dxPDFDefaultPasswordAttemptsLimit;
end;

procedure TdxPDFDocument.PopulateLoadInfo(const AFileName: string; AStream: TStream);
begin
  FLoadInfo.FileName := AFileName;
  FLoadInfo.FileStream := AStream;
end;

procedure TdxPDFDocument.PopulateSecurityOptions;
begin
  SecurityOptions.Reset;
  if EncryptionInfo <> nil then
  begin
    SecurityOptions.Enabled := True;
    SecurityOptions.Algorithm := EncryptionInfo.Algorithm.GetType;
    SecurityOptions.Permissions := EncryptionInfo.Algorithm.Permissions;
  end;
end;

procedure TdxPDFDocument.RecreateCatalog;
begin
  FreeAndNil(FCatalog);
  FCatalog := Repository.CreateCatalog;
  Repository.Catalog := FCatalog;
  CreateDocumentState;
end;

procedure TdxPDFDocument.ReadCorruptedDocument;
var
  ADictionary: TdxPDFDictionary;
begin
  Repository.RemoveCorruptedObjects;
  Parser.FindObjects;
  if Parser.FindToken(TdxPDFKeywords.Trailer) then
  begin
    ADictionary := Parser.ReadDictionary(Parser.ReadTrailerData);
    try
      UpdateTrailer(ADictionary);
    finally
      dxPDFFreeObject(ADictionary);
    end;
  end;
end;

procedure TdxPDFDocument.ReadID(AObject: TdxPDFBase);
var
  AArray: TdxPDFArray;
  AIDReferences: TdxPDFReferencedObjects;
begin
  if AObject <> nil then
  begin
    AArray := AObject as TdxPDFArray;
    if AArray.Count <> 2 then
      TdxPDFUtils.RaiseTestException('Error id count');

    case AArray[0].ObjectType of
      otString:
        begin
          FID[0] := TdxPDFUtils.StrToByteArray((AArray[0] as TdxPDFString).Value);
          FID[1] := TdxPDFUtils.StrToByteArray((AArray[1] as TdxPDFString).Value);
        end;

      otIndirectReference:
        begin
          AIDReferences := TdxPDFReferencedObjects.Create;
          try
            AIDReferences.Add(GetParser.ReadIndirectObject((AArray[0] as TdxPDFReference).Offset));
            AIDReferences.Add(GetParser.ReadIndirectObject((AArray[1] as TdxPDFReference).Offset));
            FID[0] := (AIDReferences[0] as TdxPDFIndirectObject).Data;
            FID[1] := (AIDReferences[1] as TdxPDFIndirectObject).Data;
          finally
            AIDReferences.Free;
          end;
        end;
    end;
  end;
end;

procedure TdxPDFDocument.ReadObjectNumber(ADictionary: TdxPDFDictionary; const AKey: string; var ANumber: Integer);
var
  AObject: TdxPDFBase;
begin
  if not TdxPDFUtils.IsIntegerValid(ANumber) then
    ANumber := dxPDFInvalidValue;
  if ADictionary = nil then
    TdxPDFUtils.Abort;
  if ADictionary.Contains(AKey) then
    if ADictionary.TryGetObject(AKey, AObject) then
      ANumber := AObject.Number;
end;

procedure TdxPDFDocument.ReadTrailer;
var
  AOffset: Int64;
  ATrailer: TdxPDFDictionary;
  ANeedUpdateTrailer: Boolean;
begin
  ATrailer := nil;
  AOffset := Parser.ReadCrossReferencesOffset;
  if AOffset > 0 then
  begin
    ANeedUpdateTrailer := True;
    repeat
      try
        Parser.ReadTrailer(AOffset, ATrailer);
        AOffset := dxPDFInvalidValue;
        if ATrailer <> nil then
        begin
          if ANeedUpdateTrailer then
            UpdateTrailer(ATrailer);
          ANeedUpdateTrailer := False;
          AOffset := ATrailer.GetInteger('Prev');
        end;
      finally
        dxPDFFreeObject(ATrailer);
      end;
    until not TdxPDFUtils.IsIntegerValid(AOffset)
  end;
end;

procedure TdxPDFDocument.ReadVersion;
begin
  Parser.ReadVersion(TdxPDFDocumentInformationAccess(Information).FVersion);
end;

procedure TdxPDFDocument.UpdateInformation;
begin
  TdxPDFDocumentInformationAccess(Information).FFileSize := GetFileSize;
  TdxPDFDocumentInformationAccess(Information).FFileName := GetFileName;
end;

procedure TdxPDFDocument.UpdateTrailer(ADictionary: TdxPDFDictionary);
var
  ANumber: Integer;
begin
  ReadObjectNumber(ADictionary, TdxPDFKeywords.Root, FRootObjectNumber);
  ReadObjectNumber(ADictionary, TdxPDFKeywords.Info, FInfoObjectNumber);
  ReadID(ADictionary.GetObject(TdxPDFKeywords.ID));
  if EncryptionDictionary = nil then
  begin
    EncryptionDictionary := ADictionary.GetDictionary(TdxPDFKeywords.Encrypt);
    if (EncryptionDictionary = nil) and not TdxPDFUtils.IsIntegerValid(FEncryptionDictionaryNumber) and
      ADictionary.TryGetReference(TdxPDFKeywords.Encrypt, ANumber) then
      FEncryptionDictionaryNumber := ANumber;
  end;
end;

procedure TdxPDFDocument.OnAddFieldHandler(Sender: TObject);
begin
  if Sender is TdxPDFInteractiveFormSignatureField then
    FSignatureOptions.AddEmbeddedSignature(TdxPDFInteractiveFormSignatureField(Sender));
  AcroFormChanged;
end;

procedure TdxPDFDocument.OnDeleteFieldHandler(Sender: TObject);
begin
  if Sender is TdxPDFInteractiveFormSignatureField then
    FSignatureOptions.DeleteEmbeddedSignature(TdxPDFInteractiveFormSignatureField(Sender));
  AcroFormChanged;
end;

{ TdxPDFDocumentSequentialTextSearch }

constructor TdxPDFDocumentSequentialTextSearch.Create;
begin
  inherited Create;
  FRecognizedContentPageIndex := -1;
  SearchWords := nil;
  FoundWords := nil;
  FProcessedPageIndexes := TdxIntegerList.Create;

  FWordDelimiters := TStringList.Create;
  FWordDelimiters.Add('?');
  FWordDelimiters.Add('<');
  FWordDelimiters.Add('=');
  FWordDelimiters.Add(',');
  FWordDelimiters.Add('.');
  FWordDelimiters.Add('!');
  FWordDelimiters.Add('@');
  FWordDelimiters.Add('#');
  FWordDelimiters.Add('$');
  FWordDelimiters.Add('%');
  FWordDelimiters.Add('^');
  FWordDelimiters.Add('&');
  FWordDelimiters.Add('*');
  FWordDelimiters.Add('(');
  FWordDelimiters.Add(')');
  FWordDelimiters.Add('+');
  FWordDelimiters.Add('_');
  FWordDelimiters.Add('-');
  FWordDelimiters.Add('=');
  FWordDelimiters.Add('~');
  FWordDelimiters.Add('`');
  FWordDelimiters.Add('{');
  FWordDelimiters.Add('}');
  FWordDelimiters.Add('[');
  FWordDelimiters.Add('}');
  FWordDelimiters.Add(';');
  FWordDelimiters.Add(':');
  FWordDelimiters.Add('"');
  FWordDelimiters.Add('>');
  FWordDelimiters.Add('||');
  FWordDelimiters.Add('|');
  FWordDelimiters.Add('\');
  FWordDelimiters.Add('/');

  FArabicNumericReplacements := TdxPDFStringStringDictionary.Create;
  FArabicNumericReplacements.Add(Char(1632), '0');
  FArabicNumericReplacements.Add(Char(1633), '1');
  FArabicNumericReplacements.Add(Char(1634), '2');
  FArabicNumericReplacements.Add(Char(1635), '3');
  FArabicNumericReplacements.Add(Char(1636), '4');
  FArabicNumericReplacements.Add(Char(1637), '5');
  FArabicNumericReplacements.Add(Char(1638), '6');
  FArabicNumericReplacements.Add(Char(1639), '7');
  FArabicNumericReplacements.Add(Char(1640), '8');
  FArabicNumericReplacements.Add(Char(1641), '9');
  FArabicNumericReplacements.TrimExcess;
end;

destructor TdxPDFDocumentSequentialTextSearch.Destroy;
begin
  ResetRecognizedText;
  FreeAndNil(FArabicNumericReplacements);
  FreeAndNil(FWordDelimiters);
  FreeAndNil(FProcessedPageIndexes);
  FoundWords := nil;
  SearchWords := nil;
  inherited Destroy;
end;

function TdxPDFDocumentSequentialTextSearch.GetLastSearchRecord: TdxPDFDocumentTextSearchResult;
begin
  Result := FLastSearchResult;
end;

procedure TdxPDFDocumentSequentialTextSearch.ClearAfterComplete;
begin
  FCompleted := False;
  FProcessedPageIndexes.Clear;
  ProgressChanged;
end;

procedure TdxPDFDocumentSequentialTextSearch.DirectionChanged;
begin
  InternalClear;
  FProcessedPageIndexes.Clear;
  ProgressChanged;
end;

procedure TdxPDFDocumentSequentialTextSearch.InternalClear;
begin
  FSearchStart := True;
  FCompleted := False;
end;

procedure TdxPDFDocumentSequentialTextSearch.InternalFind;
const
  StatusMap: array[Boolean] of TdxPDFDocumentTextSearchStatus = (tssNotFound, tssFinished);
begin
  try
    Completed := not DoFind;
    if Completed then
      LastSearchResult := GetSearchResult(FPageIndex, nil, StatusMap[FHasResults]);
  except
    on EdxPDFAbortException do;
    on EAbort do;
    else
      raise;
  end;
end;

procedure TdxPDFDocumentSequentialTextSearch.SetLastSearchRecord(const AValue: TdxPDFDocumentTextSearchResult);
begin
  FLastSearchResult := AValue;
end;

function TdxPDFDocumentSequentialTextSearch.DoFind: Boolean;
begin
  Result := False;
  repeat
    FoundWords := TdxPDFTextWordList.Create;
    FMoveNext;
    if CanCompare and TryCompare then
    begin
      FStartWordIndex := IfThen(FStartWordIndex = -1, 0, FStartWordIndex);
      if FSearchStart then
      begin
        FStartWordIndex := FWordIndex;
        FStartPageIndex := FPageIndex;
        FSearchStart := False;
        FHasResults := True;
      end
      else
        if (FPageIndex = FStartPageIndex) and (FWordIndex = FStartWordIndex) then
        begin
          FSearchStart := True;
          FWordIndex := IfThen(FOptions.Direction = tsdForward, FWordIndex - 1, FWordIndex + 1);
          Break;
        end;
      LastSearchResult := GetSearchResult(FPageIndex, FoundWords, tssFound);
      Exit(True);
    end;
    if (FPageIndex = FStartPageIndex) and (FWordIndex = FStartWordIndex) then
      Break;
    FStartWordIndex := IfThen(FStartWordIndex = -1, 0, FStartWordIndex);
  until not (FSearchStart or not ((FPageIndex = FStartPageIndex) and (FWordIndex = FStartWordIndex)));
end;

function TdxPDFDocumentSequentialTextSearch.Find(ADocument: TdxPDFDocument; const AText: string;
  const AOptions: TdxPDFDocumentTextSearchOptions; APageIndex: Integer): TdxPDFDocumentTextSearchResult;
begin
  Document := ADocument;
  try
    if CanSearch(AText, AOptions, APageIndex) then
    begin
      Options := AOptions;
      InternalFind;
    end
    else
    begin
      LastSearchResult := GetSearchResult(FPageIndex, nil, tssNotFound);
      Completed := True;
    end;
  finally
    Result := LastSearchResult;
  end;
end;

function TdxPDFDocumentSequentialTextSearch.GetSearchResult(APageIndex: Integer; AWords: TdxPDFTextWordList;
  AStatus: TdxPDFDocumentTextSearchStatus): TdxPDFDocumentTextSearchResult;

  function GetRange(APageIndex: Integer; AWords: TdxPDFTextWordList): TdxPDFPageTextRange;
  var
    ALastWord: TdxPDFTextWord;
  begin
    Result := TdxPDFPageTextRange.Invalid;
    Result.PageIndex := APageIndex;
    if AWords <> nil then
    begin
      ALastWord := AWords[AWords.Count - 1];
      Result := TdxPDFPageTextRange.Create(APageIndex, AWords[0].Index, 0, ALastWord.Index,
        TdxPDFTextWordAccess(ALastWord).Characters.Count);
    end;
  end;

begin
  Result.Status := AStatus;
  Result.Range := GetRange(APageIndex, AWords);
end;

procedure TdxPDFDocumentSequentialTextSearch.Clear;
begin
  ClearProcessedPageIndexes;
  FSearchString := '';
  ResetRecognizedText;
  InternalClear;
end;

procedure TdxPDFDocumentSequentialTextSearch.ClearProcessedPageIndexes;
begin
  FProcessedPageIndexes.Clear;
end;

procedure TdxPDFDocumentSequentialTextSearch.SetCompleted(const AValue: Boolean);
begin
  if FCompleted <> AValue then
  begin
    FCompleted := AValue;
    dxCallNotify(OnComplete, Self);
  end;
end;

procedure TdxPDFDocumentSequentialTextSearch.SetDocument(const AValue: TdxPDFDocument);
begin
  if FDocument <> AValue then
  begin
    FAborted := True;
    FDocument := AValue;
    InternalClear;
  end;
end;

procedure TdxPDFDocumentSequentialTextSearch.SetFoundWords(const AValue: TdxPDFTextWordList);
begin
  if FFoundWords <> nil then
    FFoundWords.Free;
  FFoundWords := AValue;
end;

procedure TdxPDFDocumentSequentialTextSearch.SetOptions(const AValue: TdxPDFDocumentTextSearchOptions);
begin
  if FOptions.Direction <> AValue.Direction then
    DirectionChanged;
  FOptions := AValue;
  FMoveNext := GetStepDirection(FOptions.Direction);
end;

procedure TdxPDFDocumentSequentialTextSearch.SetSearchWords(const AValue: TStringList);
begin
  if FSearchWords <> nil then
    FSearchWords.Free;
  FSearchWords := AValue;
end;

function TdxPDFDocumentSequentialTextSearch.CanCompare: Boolean;
begin
  Result := (FPageWords <> nil) and not ((FPageWords.Count = 0) or (FSearchWords = nil) or (FSearchWords <> nil) and
      (FSearchWords.Count = 0) or (FWordIndex + FSearchWords.Count > FPageWords.Count));
end;

function TdxPDFDocumentSequentialTextSearch.CanSearch(const AText: string; const AOptions: TdxPDFDocumentTextSearchOptions;
  APageIndex: Integer): Boolean;
begin
  Result := (AText <> '') and (Document <> nil) and (Document.PageCount > 0) and Initialize(AText, APageIndex, AOptions);
end;

function TdxPDFDocumentSequentialTextSearch.CompareWordList(APageWordList: TStringList): Boolean;
var
  I: Integer;
  S1, S2: string;
begin
  Result := True;
  for I := 1 to FSearchWords.Count - 1 do
  begin
    S1 := PrepareComparingWord(APageWordList[I]);
    S2 := PrepareComparingWord(FSearchWords[I]);
    if I < FSearchWords.Count - 1 then
    begin
      if S1 <> S2 then
        Exit(False);
    end
    else
      if FOptions.WholeWords and (S1 <> S2) or
        not(FOptions.WholeWords or TdxPDFTextUtils.StartsWith(S1, S2)) then
        Exit(False);
  end;
  for I := FWordIndex to FWordIndex + FSearchWords.Count - 1 do
    FFoundWords.Add(FPageWords[I]);
end;

function TdxPDFDocumentSequentialTextSearch.CompareWords(const AWord1, AWord2: string): Boolean;
begin
  if FOptions.WholeWords then
  begin
    Result := AnsiCompareStr(AWord1, AWord2) = 0;
    if Result then
      FFoundWords.Add(FPageWords[FWordIndex]);
  end
  else
  begin
    Result := AnsiPos(AWord2, AWord1) > 0;
    if Result then
      FFoundWords.Add(FPageWords[FWordIndex]);
  end;
end;

function TdxPDFDocumentSequentialTextSearch.CreateWordList(const AText: string): TStringList;
const
  LineBreakMarker = #13#10;
var
  I: Integer;
  S, S1, ADelimiter: string;
begin
  S := StringReplace(AText, #9, LineBreakMarker, [rfReplaceAll]);
  for ADelimiter in FWordDelimiters do
    S := StringReplace(S, ADelimiter, ADelimiter + LineBreakMarker, [rfReplaceAll]);
  for I := 1 to Length(S) do
    if TdxPDFTextUtils.IsCJK(S[I]) then
      S1 := S1 + S[I] + LineBreakMarker
    else
      S1 := S1 + S[I];
  S1 := StringReplace(S1, ' ', LineBreakMarker, [rfReplaceAll]);
  Result := TStringList.Create;
  if S1 = LineBreakMarker then
    S1 := '';
  Result.Text := S1;
end;

function TdxPDFDocumentSequentialTextSearch.GetPageText(AWordIndex, ACount: Integer): string;

  function TryGetNumericReplacement(const ACharacter: string): string;
  begin
    Result := '';
    if not FArabicNumericReplacements.TryGetValue(ACharacter, Result) then
      Result := ACharacter;
  end;

var
  I, J, ACurrentWordIndex: Integer;
  ABuilder: TdxBiDiStringBuilder;
  APart: TdxPDFTextWordPart;
  AWord: TdxPDFTextWord;
begin
  ACurrentWordIndex := FWordIndex;
  ABuilder := TdxBiDiStringBuilder.Create;
  if FPageWords <> nil then
    try
      for I := 0 to ACount - 1 do
      begin
        AWord := FPageWords[ACurrentWordIndex];
        if AWord <> nil then
          for APart in TdxPDFTextWordAccess(AWord).PartList do
          begin
            for J := 0 to APart.Characters.Count - 1 do
              ABuilder.Append(TryGetNumericReplacement(APart.Characters[J].Text));
            if TdxPDFTextWordPartAccess(APart).WordEnded then
              ABuilder.Append(' ');
          end;
        Inc(ACurrentWordIndex);
      end;
      Result := TrimRight(ABuilder.EndCurrentLineAndGetString);
    finally
      ABuilder.Free;
    end;
end;

function TdxPDFDocumentSequentialTextSearch.GetProgressPercent: Integer;
begin
  Result := Round(FProcessedPageIndexes.Count / FDocument.PageCount * 100);
end;

function TdxPDFDocumentSequentialTextSearch.GetStepDirection(ADirection: TdxPDFDocumentTextSearchDirection): TThreadMethod;
begin
  if ADirection = tsdForward then
    Result := StepForward
  else
    Result := StepBackward;
end;

function TdxPDFDocumentSequentialTextSearch.Initialize(const AText: string; APageIndex: Integer;
  const AOptions: TdxPDFDocumentTextSearchOptions): Boolean;

  function SameTextOptions(const P1, P2: TdxPDFDocumentTextSearchOptions): Boolean;
  begin
    Result := (P1.CaseSensitive = P2.CaseSensitive) and (P1.WholeWords = P2.WholeWords);
  end;

var
  ARecognitionsStartIndex: Integer;
begin
  Result := True;
  if FAborted or (AText <> FSearchString) or not SameTextOptions(Options, AOptions) then
  begin
    FAborted := False;
    FMoveNext := GetStepDirection(AOptions.Direction);
    FLastSearchResult.Range := TdxPDFPageTextRange.Invalid;
    FLastSearchResult.Status := tssNotFound;
    FPageIndex := APageIndex;
    FWordIndex := -1;
    ARecognitionsStartIndex := FPageIndex;
    RecognizeCurrentPage;
    FProcessedPageIndexes.Clear;
    if FPageLines <> nil then
      while (FPageWords = nil) or (FPageWords.Count = 0) do
      begin
        FMoveNext;
        RecognizeCurrentPage;
        if FPageIndex = ARecognitionsStartIndex then
          Exit(False);
      end;
    InternalClear;
    FHasResults := False;
    FSearchString := AText;
    FStartPageIndex := FPageIndex;
    FStartWordIndex := -1;
    SearchWords := CreateWordList(FSearchString);
  end;
  if FCompleted then
    ClearAfterComplete;
end;

function TdxPDFDocumentSequentialTextSearch.PrepareComparingWord(const AWord: string): string;
begin
  if FOptions.CaseSensitive then
    Result := AWord
  else
    Result := AnsiUpperCase(AWord);
end;

function TdxPDFDocumentSequentialTextSearch.TryCompare: Boolean;
var
  APageWord, ASearchWord: string;
  APageWordList: TStringList;
begin
  Result := False;
  APageWordList := CreateWordList(GetPageText(FWordIndex, FSearchWords.Count));
  try
    if APageWordList.Count > 0 then
    begin
      APageWord := PrepareComparingWord(APageWordList[0]);
      ASearchWord := PrepareComparingWord(FSearchWords[0]);
      if FSearchWords.Count = 1 then
        Result := CompareWords(APageWord, ASearchWord);
      if not Result then
      begin
        if FOptions.WholeWords and (APageWord <> ASearchWord) or  not (FOptions.WholeWords or
          TdxPDFTextUtils.EndsWith(APageWord, ASearchWord)) then
          Exit(False);
         Result := CompareWordList(APageWordList);
      end;
    end;
  finally
    APageWordList.Free;
  end;
end;

procedure TdxPDFDocumentSequentialTextSearch.PackCurrentPageRecognizedContent;
begin
  ResetRecognizedText;
  if InRange(FPageIndex, 0, FDocument.PageCount - 1) then
    FDocument.Pages.List[FPageIndex].PackRecognizedContent;
end;

procedure TdxPDFDocumentSequentialTextSearch.ProgressChanged;
begin
  if Assigned(OnProgress) then
    try
      OnProgress(FDocument, FPageIndex, GetProgressPercent);
    except
      on EdxPDFAbortException do
      begin
        FAborted := True;
        raise
      end
      else
        raise;
    end;
end;

procedure TdxPDFDocumentSequentialTextSearch.RecognizeCurrentPage;
var
  APage: TdxPDFPage;
begin
  ResetRecognizedText;
  APage := FDocument.Pages.List[FPageIndex];
  if APage.RecognizedContent <> nil then
  begin
    FRecognizedContentPageIndex := FPageIndex;
    TdxPDFPageAccess(APage).LockRecognizedContent;
    FPageLines := APage.RecognizedContent.TextLines;
    FPageWords := TdxPDFTextLineListAccess(FPageLines).WordList;
  end;
end;

procedure TdxPDFDocumentSequentialTextSearch.ResetRecognizedText;
var
  APage: TdxPDFPageAccess;
begin
  if (FRecognizedContentPageIndex > -1) and not FDocument.IsEmpty then
  begin
    APage := TdxPDFPageAccess(FDocument.Pages.Items[FRecognizedContentPageIndex]);
    APage.UnLockRecognizedContent;
    APage.Pack;
  end;
  FRecognizedContentPageIndex := -1;
  FPageLines := nil;
  FPageWords := nil;
end;

procedure TdxPDFDocumentSequentialTextSearch.StepBackward;
begin
  if FWordIndex <= 0 then
  begin
    UpdateProcessedPageIndexes;
    PackCurrentPageRecognizedContent;
    FPageIndex := IfThen(FPageIndex <= 0, FDocument.PageCount - 1, FPageIndex - 1);
    RecognizeCurrentPage;
    FWordIndex := FPageWords.Count - 1;
  end
  else
    Dec(FWordIndex);
end;

procedure TdxPDFDocumentSequentialTextSearch.StepForward;
begin
  if FPageWords <> nil then
  begin
    if FWordIndex >= FPageWords.Count - 1 then
    begin
      UpdateProcessedPageIndexes;
      PackCurrentPageRecognizedContent;
      FPageIndex := IfThen(FPageIndex >= FDocument.PageCount - 1, 0, FPageIndex + 1);
      FWordIndex := 0;
      RecognizeCurrentPage;
    end
    else
      Inc(FWordIndex);
  end;
end;

procedure TdxPDFDocumentSequentialTextSearch.UpdateProcessedPageIndexes;
begin
  if not FProcessedPageIndexes.Contains(FPageIndex) then
  begin
    FProcessedPageIndexes.Add(FPageIndex);
    ProgressChanged;
  end;
end;

{ TdxPDFDocumentContinuousTextSearch }

constructor TdxPDFDocumentContinuousTextSearch.Create;
begin
  inherited Create;
  FSearchResultList := TList<TdxPDFDocumentTextSearchResult>.Create;
end;

destructor TdxPDFDocumentContinuousTextSearch.Destroy;
begin
  FreeAndNil(FSearchResultList);
  inherited Destroy;
end;

function TdxPDFDocumentContinuousTextSearch.GetLastSearchRecord: TdxPDFDocumentTextSearchResult;
begin
  if FSearchResultList.Count > 0 then
    Result := FSearchResultList[Max(FCurrentResultIndex, 0)]
  else
    Result := GetSearchResult(PageIndex, nil, tssNotFound);
end;

procedure TdxPDFDocumentContinuousTextSearch.ClearAfterComplete;
begin
//
end;

procedure TdxPDFDocumentContinuousTextSearch.DirectionChanged;
var
  ANotFoundRecord: TdxPDFDocumentTextSearchResult;
begin
  if FSearchResultList.Count > 0 then
  begin
    ANotFoundRecord := FSearchResultList[FNotFoundRecordIndex];
    FSearchResultList.Delete(FNotFoundRecordIndex);
    FSearchResultList.Insert(FCurrentResultIndex, ANotFoundRecord);
    FNotFoundRecordIndex := FCurrentResultIndex;
  end;
end;

procedure TdxPDFDocumentContinuousTextSearch.InternalClear;
begin
  inherited InternalClear;
  FCurrentResultIndex := -1;
  Completed := False;
  FSearchResultList.Clear;
end;

procedure TdxPDFDocumentContinuousTextSearch.InternalFind;
const
  StatusMap: array[Boolean] of TdxPDFDocumentTextSearchStatus = (tssNotFound, tssFinished);
begin
  if not Completed and SearchStart then
  begin
    ClearProcessedPageIndexes;
    InternalClear;
    FCurrentResultIndex := 0;
    if DoFind then
      while not (LastSearchResult.Status in [tssNotFound, tssFinished]) do
      begin
        Completed := not DoFind;
        if Completed then
        begin
          LastSearchResult := GetSearchResult(PageIndex, nil, StatusMap[HasResults]);
          FNotFoundRecordIndex := FSearchResultList.Count - 1;
          Break;
        end;
      end;
    Completed := True;
    FCurrentResultIndex := -1;
  end;
  CalculateCurrentResultIndex;
end;

procedure TdxPDFDocumentContinuousTextSearch.SetLastSearchRecord(const AValue: TdxPDFDocumentTextSearchResult);
begin
  FSearchResultList.Add(AValue);
end;

function TdxPDFDocumentContinuousTextSearch.GetFoundRanges: TdxPDFPageTextRanges;

  procedure AddRange(const ARange: TdxPDFPageTextRange);
  var
    L: Integer;
  begin
    L := Length(Result);
    SetLength(Result, L + 1);
    Result[L] := ARange;
  end;

var
  I: Integer;
begin
  for I := 0 to FSearchResultList.Count - 1 do
    if FSearchResultList[I].Status = tssFound then
      AddRange(FSearchResultList[I].Range);
end;

procedure TdxPDFDocumentContinuousTextSearch.CalculateCurrentResultIndex;
begin
  if Options.Direction = tsdForward then
    Inc(FCurrentResultIndex)
  else
    Dec(FCurrentResultIndex);
  if FCurrentResultIndex < 0 then
    FCurrentResultIndex := FSearchResultList.Count - 1;
  if FCurrentResultIndex > FSearchResultList.Count - 1 then
    FCurrentResultIndex := 0;
end;

{ TdxPDFDocumentCustomWriter }

constructor TdxPDFDocumentCustomWriter.Create(AStream: TStream);
begin
  inherited Create(AStream, False);
  FObjectsOffsets := TList.Create;
  FObjectsOffsets.Capacity := 1024;
  FWriteObjectList := TdxPDFWriteObjectList.Create(FObjectsOffsets.Capacity);
  FContext := TdxPDFDocumentWritingContext.Create(Self);
  FHelper := TdxPDFWriterHelper.Create(FContext, EncryptionInfo)
end;

destructor TdxPDFDocumentCustomWriter.Destroy;
begin
  FreeAndNil(FWriteObjectList);
  FreeAndNil(FObjectsOffsets);
  FreeAndNil(FHelper);
  FreeAndNil(FContext);
  inherited Destroy;
end;

procedure TdxPDFDocumentCustomWriter.Write;
var
  AXRefOffset: Int64;
begin
  WriteHeader;
  WriteObjects;
  AXRefOffset := Stream.Position;
  if HasXRef then
    WriteXRef;
  WriteTrailer;
  if HasXRef then
  begin
    WriteString(TdxPDFKeywords.StartXRef, True);
    WriteInteger(AXRefOffset);
  end;
  WriteEndOfDocument;
end;

function TdxPDFDocumentCustomWriter.HasXRef: Boolean;
begin
  Result := True;
end;

procedure TdxPDFDocumentCustomWriter.RegisterTrailerObjects;
begin
  // do nothing
end;

procedure TdxPDFDocumentCustomWriter.UpdateProgress(AWrittenObjectCount: Integer);
begin
  // do nothing
end;

procedure TdxPDFDocumentCustomWriter.AddObjectOffset(AOffset: Integer);
begin
  FObjectsOffsets.Add(Pointer(AOffset));
end;

procedure TdxPDFDocumentCustomWriter.WriteEndOfDocument;
begin
  WriteLineFeed;
  WriteString(TdxPDFKeywords.EOF);
end;

procedure TdxPDFDocumentCustomWriter.WriteHeader;
begin
  WriteString(GetVersion, True);
  WriteString('%'#226#227#207#211, True);
end;

procedure TdxPDFDocumentCustomWriter.WriteObject(AObject: TdxPDFObject);
var
  AData: TdxPDFBase;
begin
  AData := TdxPDFObjectAccess(AObject).Write(FHelper);
  AData.Reference;
  try
    AddObjectOffset(Stream.Position);
    BeginWriteObject(AObject.Number);
    TdxPDFBaseAccess(AData).Write(Self);
    EndWriteObject;
  finally
    AData.Release;
  end;
end;

procedure TdxPDFDocumentCustomWriter.WriteObjects;
var
  AIndex: Integer;
begin
  FObjectsOffsets.Count := 0;
  FWriteObjectList.Clear;
  RegisterTrailerObjects;

  AIndex := 0;
  while AIndex < FWriteObjectList.Count do
  begin
    WriteObject(FWriteObjectList.Items.List[AIndex]);
    WriteLineFeed;
    Inc(AIndex);
    UpdateProgress(AIndex);
  end;
end;

procedure TdxPDFDocumentCustomWriter.WriteTrailer;
var
  ADictionary: TdxPDFWriterDictionary;
begin
  WriteString(TdxPDFKeywords.Trailer, True);
  ADictionary := Helper.CreateDictionary;
  try
    PopulateTrailer(ADictionary);
    TdxPDFBaseAccess(ADictionary).Write(Self);
  finally
    ADictionary.Free;
  end;
  WriteLineFeed;
end;

procedure TdxPDFDocumentCustomWriter.WriteXRef;
var
  I: Integer;
begin
  WriteString('xref', True);
  WriteString('0 ' + IntToStr(FObjectsOffsets.Count + 1), True);
  WriteString('0000000000 65535 f', True);
  for I := 0 to FObjectsOffsets.Count - 1 do
    WriteString(FormatFloat('0000000000', Integer(FObjectsOffsets.Items[I])) + ' 00000 n', True);
end;

{ TdxPDFDocumentWriter }

constructor TdxPDFDocumentWriter.Create(ADocument: TdxPDFDocument;
  AStream: TStream; AOnProgress: TdxPDFDocumentSaveProgressEvent);
var
  ADictionary: TdxPDFDictionary;
begin
  FDocument := ADocument;
  inherited Create(AStream);
  FCurrentProgress := 0;
  FOnProgress := AOnProgress;

  if FEncryptionInfo <> nil then
  begin
    ADictionary := Helper.CreateDictionary;
    TdxPDFEncryptionInfoAccess(FEncryptionInfo).Write(ADictionary);
    FEncryption := Helper.CreateIndirectObject(ADictionary);
  end;
end;

destructor TdxPDFDocumentWriter.Destroy;
begin
  inherited Destroy;
  FreeAndNil(FEncryptionInfo);
end;

procedure TdxPDFDocumentWriter.Write(ADeleteEmbeddedSignatures: Boolean);
var
  ASignature: TdxPDFSignature;
begin
  if ADeleteEmbeddedSignatures then
    FDocument.SignatureOptions.DeleteEmbeddedSignatures;
  ASignature := FDocument.ApplySignature(FDocument.SignatureOptions.Signature);
  inherited Write;
  if ASignature <> nil then
    ASignature.Patch(Self);
end;

function TdxPDFDocumentWriter.CreateEncryptionProvider: IdxPDFEncryptionInfo;
begin
  if FDocument.SecurityOptions.Enabled then
  begin
    FEncryptionInfo := TdxPDFEncryptionInfo.Create(
      FDocument.ID,
      FDocument.SecurityOptions.Algorithm,
      FDocument.SecurityOptions.UserPassword,
      FDocument.SecurityOptions.OwnerPassword,
      FDocument.SecurityOptions.Permissions
    );
    Result := FEncryptionInfo;
  end
  else
    Result := nil;
end;

function TdxPDFDocumentWriter.GetVersion: string;
begin
  Result := '%PDF-' + TdxPDFUtils.ConvertToStr(FDocument.Information.Version);
end;

procedure TdxPDFDocumentWriter.PopulateTrailer(ADictionary: TdxPDFWriterDictionary);
var
  AIDArray: TdxPDFArray;
begin
  ADictionary.Add(TdxPDFKeywords.Size, ObjectsOffsets.Count);
  ADictionary.AddReference(TdxPDFKeywords.Info, FDocument.Information);
  ADictionary.AddReference(TdxPDFKeywords.Root, FDocument.Catalog);
  ADictionary.AddReference(TdxPDFKeywords.Encrypt, FEncryption);

  AIDArray := TdxPDFArray.Create;
  AIDArray.Add(TdxPDFSpecialBytes.Create(FDocument.ID[0]));
  AIDArray.Add(TdxPDFSpecialBytes.Create(FDocument.ID[1]));
  ADictionary.Add(TdxPDFKeywords.ID, AIDArray);
end;

procedure TdxPDFDocumentWriter.RegisterTrailerObjects;
begin
  Helper.RegisterIndirectObject(FDocument.Information);
  Helper.RegisterIndirectObject(FDocument.Catalog);
  Helper.RegisterIndirectObject(FEncryption);
end;

procedure TdxPDFDocumentWriter.UpdateProgress(AWrittenObjectCount: Integer);
begin
  if Assigned(FOnProgress) then
  begin
    FCurrentProgress := Max(FCurrentProgress, MulDiv(AWrittenObjectCount, 100,
      Max(WriteObjectList.Count, FDocument.Repository.ObjectCount)));
    FOnProgress(FDocument, FCurrentProgress);
  end;
end;

{ TdxPDFWriteObjectList }

constructor TdxPDFWriteObjectList.Create(ACapacity: Integer);
begin
  inherited Create;
  FItems := TList.Create;
  FItems.Capacity := ACapacity;
  FHashSet := TdxPDFPointerHashSet.Create;
end;

destructor TdxPDFWriteObjectList.Destroy;
begin
  FreeAndNil(FHashSet);
  FreeAndNil(FItems);
  inherited Destroy;;
end;

function TdxPDFWriteObjectList.Add(AItem: Pointer): Integer;
begin
  Result := FItems.Add(AItem);
  FHashSet.Include(AItem);
end;

function TdxPDFWriteObjectList.Contains(AItem: Pointer): Boolean;
begin
  Result := FHashSet.Contains(AItem);
end;

procedure TdxPDFWriteObjectList.Clear;
begin
  FItems.Count := 0;
  FHashSet.Clear;
end;

function TdxPDFWriteObjectList.GetCount: Integer;
begin
  Result := FItems.Count;
end;

end.

