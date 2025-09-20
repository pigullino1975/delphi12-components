unit QImport3XMLSax;

{$I QImport3VerCtrl.Inc}

interface

uses
  {$IFDEF VCL16}
    System.Classes,
    System.SysUtils,
    System.Variants,
    System.Types,
  {$ELSE}
    Classes,
    SysUtils,
    Variants,
    Types,
  {$ENDIF}
  QImport3StrTypes,
  QImport3Encoding,
  QImport3HashTable,
  QImport3BaseDocumentFile,
  QImport3Common,
  QImport3WideStrUtils;

type
  TQIXMLTokenKind = (
    xtkOpenDoc,         // lets go
    xtkDocType,         //<!DOCTYPE value>
    xtkComment,         // <!--value-->
    xtkOpenXMLDecl,     // <?xml
    xtkXMLDeclAttr,     // name="value" inside a xml declaration
    xtkCloseXMLDecl,    // ?>
    xtkOpenElem,        // <name
    xtkElemAttr,        // name="value"
    xtkFinishElem,      // <node ... >
    xtkFinishCloseElem, // <node ... />
    xtkCloseElem,       // </node>
    xtkInstruction,     // <?target content?>
    xtkText,            // value contains a text
    xtkReference,       // &name; value contains an entity
    xtkCData            // <![CDATA[value]]>
  );

  TQIXPathTokenKind = (
    ptkUnknown,         // unknown
    ptkString,          // "AbCdE" 'AbCdE'
    ptkNode,            // node
    ptkAttribute,       // @attrubute
    ptkAxis,            // axis:: / //
    ptkNamespace,       // namespace:
    ptkNumber,          // 3.14
    ptkOpenPred,        // [
    ptkClosePred,       // ]
    ptkOpenGroup,       // (
    ptkCloseGroup,      // )
    ptkFunction,        // function()
    ptkAnd,             // and
    ptkOr,              // or
    ptkDiv,             // division
    ptkMod,             // modulo
    ptkMult,            // *
    ptkPlus,            // +
    ptkMinus,           // -
    ptkEqual,           // =
    ptkNotEq,           // !=
    ptkLower,           // <
    ptkLowEq,           // <=
    ptkGreater,         // >
    ptkGreEq,           // >=
    ptkComma            // ,
  );

  TQIXMLTextType = (
    xttText,            // value of text node
    xttCData,           // value of CDATA node
    xttReference,       // value of entity
    xttComment          // value of comment node
  );

  TQIXMLNodeAction = (
    xnaOpen,            // element node opened
    xnaFinish,          // element node finished
    xnaClose            // element node closed or finished-closed
  );

  TQIXMLObjectStack = class
  private
    FList: TList;
    FCount: Integer;
    function GetItems(const Index: Integer): Pointer;
  protected
    function AddItem: Pointer;
    procedure DisposeItem(const Index: Integer); virtual;
    function NewItem: Pointer; virtual; abstract;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Pop;
    function IndexOf(const Value: Pointer): Integer;
    procedure Push;
    property Count: Integer read FCount;
    property Items[const Index: Integer]: Pointer read GetItems; default;
  end;

  PQIXMLToken = ^TQIXMLToken;
  TQIXMLToken = packed record
    Name: qiString;
    Value: qiString;
    Kind: TQIXMLTokenKind;
  end;

  TQIXMLTokenStack = class(TQIXMLObjectStack)
  private
    function GetItems(const Index: Integer): PQIXMLToken;
  protected
    function NewItem: Pointer; override;
  public
    function Add: PQIXMLToken;
    function Top: PQIXMLToken;
    property Items[const Index: Integer]: PQIXMLToken read GetItems; default;
  end;

  TQIXMLBuffer = class
  private
    FBuffer: array of qiChar;
    FIndex: Integer;
    FSize: Integer;
    FIterator: TQIBufferIterator;
    procedure SetBufferLength;
  public
    constructor Create(Size: Integer = cBufferSize);
    destructor Destroy; override;
    procedure BuildString(var Result: qiString; KillSpaces: Boolean = False); overload;
    procedure BuildString(var Result: qiString; Offset: Integer; KillSpaces: Boolean = False); overload;
    procedure Reset;
    procedure StoreChar(const Char: qiChar);
    procedure StoreText(const Text: qiString); overload;
  end;

  TQITokenizer = class
  private
    FBuffer: TQIXMLBuffer;
    FIterator: TQIIterator;
  protected
    procedure DoError; virtual;
    procedure ScanName(var Name: qiString); virtual;
    function StoreCurrentChar(CharType: TQICharType): Boolean; virtual; abstract;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Reset; virtual;
  end;

  TQIXMLTokenizer = class(TQITokenizer)
  private
    FAttributes: TQIXMLTokenStack;
    FCurrentToken: PQIXMLToken;
    FDTDDetected: Boolean;
    FEntities: TQImportHashTable;
    FKeepSpaces: Boolean;
    FPrevTokenKind: TQIXMLTokenKind;
    FPrevIteratorType: TQICharType;
    FEmptyValueDetected: Boolean;
    FOpenElements: TQIXMLTokenStack;
    FPreserveSpaces: Boolean;
    FRootOpened: Boolean;
    FSpaceOnly: Boolean;
    procedure FillEntities;
    procedure FillDefaultEntities;
    procedure DisposeEntities;
  protected
    function StoreCurrentChar(CharType: TQICharType): Boolean; override;
  public
    constructor Create(const FileName: string; Charset: TQICharsetType; Attributes: TQIXMLTokenStack);
    destructor Destroy; override;
    function GetNextToken(var Token: PQIXMLToken): Boolean;
    procedure Reset; override;
    property KeepSpaces: Boolean write FKeepSpaces;
  end;

  TQIXMLAttrList = class
  private
    FIndex: Integer;
    FList: TQIXMLTokenStack;
    function GetCurrent: PQIXMLToken;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function MoveNext: Boolean;
    procedure Reset;
    property Current: PQIXMLToken read GetCurrent;
  end;

  TQIXMLAttrListClass = class of TQIXMLAttrList;

  TQIXPathAttrStack = class(TQIXMLAttrList)
  private
    FStack: TList;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Clone: TQIXMLTokenStack;
    procedure Pop;
    procedure Push(List: TQIXMLTokenStack);
  end;

  TQIXMLTagsStack = class
  private
    FStack: TqiStringList;
  public
    constructor Create;
    destructor Destroy; override;
    function Top: qiString;
    procedure Push(ATag: qiString);
    procedure Pop;
  end;

  TQIXMLStreamProcessor = class;

  TQIXMLNotifyEvent = procedure(Sender: TQIXMLStreamProcessor) of object;
  TQIXMLTextEvent = procedure(Sender: TQIXMLStreamProcessor; const Text: qiString;
      TextType: TQIXMLTextType) of object;
  TQIXMLElementEvent = procedure(Sender: TQIXMLStreamProcessor; const Name: qiString;
      Action: TQIXMLNodeAction) of object;
  TQIXMLDocumentEvent = procedure(Sender: TQIXMLStreamProcessor; Action: TQIXMLNodeAction) of object;
  TQIXMLProcInstructionEvent = procedure(Sender: TQIXMLStreamProcessor; const Target, Content: qiString) of object;

  TQIXMLStreamProcessor = class
  private
    FDocStarted: Boolean;
    FKeepSpaces: Boolean;
    FOnGetText: TQIXMLTextEvent;
    FOnLoadDocument: TQIXMLDocumentEvent;
    FOnLoadElement: TQIXMLElementEvent;
    FTags: TQIXMLTagsStack;
    FCurrentTag: qiString;
    procedure DoLoadDocument(Action: TQIXMLNodeAction);
  protected
    FHalt: Boolean;
    FAttributes: TQIXMLAttrList;
    FTokenizer: TQIXMLTokenizer;
    procedure DoGetText(const Text: qiString; TextType: TQIXMLTextType); virtual;
    procedure DoLoadElement(const Name: qiString; Action: TQIXMLNodeAction); virtual;
    function ProcessDocument(const FileName: string): Boolean;
    procedure DoProcessToken(Token: PQIXMLToken); virtual;
    function GetAttributeListClass: TQIXMLAttrListClass; virtual; abstract;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    //use this method to enumerate attributes of element or declaration
    // in OnLoadElement or OnLoadDeclaration events
    function GetNextAttribute(out Name, Value: qiString; Stop: Boolean = False):
        Boolean;
    //interrupts processing without ability to continue
    procedure Halt;
    property KeepSpaces: Boolean write FKeepSpaces;
    property CurrentTag: qiString read FCurrentTag;
    property OnGetText: TQIXMLTextEvent read FOnGetText write FOnGetText;
    property OnLoadDocument: TQIXMLDocumentEvent read FOnLoadDocument write FOnLoadDocument;
    property OnLoadElement: TQIXMLElementEvent read FOnLoadElement write FOnLoadElement;
  end;

  TQIXMLStreamProcessorClass = class of TQIXMLStreamProcessor;

  TQISAXParser = class(TQIXMLStreamProcessor)
  private
    FOnProcessingInstruction: TQIXMLProcInstructionEvent;
    FOnLoadDeclaration: TQIXMLNotifyEvent;
    procedure DoLoadDeclaration;
    procedure DoProcessingInstruction(const Target, Content: qiString);
  protected
    procedure DoGetText(const Text: qiString; TextType: TQIXMLTextType); override;
    procedure DoProcessToken(Token: PQIXMLToken); override;
    function GetAttributeListClass: TQIXMLAttrListClass; override;
  public
    function Parse(const FileName: string): Boolean;
    property OnLoadDeclaration: TQIXMLNotifyEvent read FOnLoadDeclaration write FOnLoadDeclaration;
    property OnProcessingInstruction: TQIXMLProcInstructionEvent
      read FOnProcessingInstruction write FOnProcessingInstruction;
  end;

  TQIDirectReadParser = class(TQISAXParser)
  public
    procedure OpenDocument(const FileName: string);
    procedure CloseDocument();
    function GetNextToken(var Token: PQIXMLToken): Boolean;
    procedure DoProcessToken(Token: PQIXMLToken); override;
    property Halted: Boolean read FHalt;
  end;

  TQIPredicateOperation = ( // in descending precedence
    qpoUndefined,       // unable to define
    qpoMult,            // *
    qpoDiv,             // division
    qpoMod,             // modulo (remainder)
    qpoPlus,            // +
    qpoMinus,           // -
    qpoLower,           // <
    qpoLowEq,           // <=
    qpoGreater,         // >
    qpoGreEq,           // >=
    qpoEqual,           // =
    qpoNotEq,           // !=
    qpoAnd,             // and
    qpoOr               // or
  );

  TQIPredicateCalc = class;

  PQIExpression = ^TQIExpression;
  TQIExpression = record
    Operation: TQIPredicateOperation;
    Calculator: TQIPredicateCalc;
    Left: PQIExpression;
    Right: PQIExpression;
    Result: Variant;
  end;

// ancestor, ancestor-or-self, attribute, following, following-sibling,
// namespace, parent, preceding, self, descendant-or-self and
// preceding-sibling axes still not supported yet

  TQINodeAxis = (
    qnaUnsupported,     // not supported
    qnaChild,           // all children of current node
    qnaDescendant       // all descendants (children, grandchildren, etc) of current node
  );

  TQINodeOption = (
    qnoRoot,            // virtual root node
    qnoResult,          // last node in main path of query
    qnoAxis,            // intermediate nodes in main path of query
    qnoPredicate,       // nodes in predicates
    qnoLeaf             // node without children
  );
  TQINodeOptions = set of TQINodeOption;

  // structure that defines a container for attributes and texts of potential answer node
  PQIDataContainer = ^TQIDataContainer;
  TQIDataContainer = record
    Attributes: Pointer;  // pointer to stack of attributes
    Name: qiString;       // node name
    Text: Pointer;        // pointer to list of text nodes
  end;

  TQIBufferState = (
    qbsWait,            // buffer wait for confirmation
    qbsFlush,           // buffer is ready to be flushed
    qbsFree             // buffer should be destroyed
  );

  PQIBufferNode = ^TQIBufferNode;   // structure that defines a buffer of potential answer node
  TQIBufferNode = record
    State: TQIBufferState;          // current state of buffer
    Data: PQIDataContainer;         // pointer to data container of potential answer node
  end;

  PQIBufferNodeSet = ^TQIBufferNodeSet;
  TQIBufferNodeSet = array of PQIBufferNode;

  PQIDataNode = ^TQIDataNode;       // structure that defines streaming node in stack of query node
  TQIDataNode = record
    Data: PQIDataContainer;         // pointer to data container of potential answer node
    Depth: Integer;                 // depth of streaming node within document
    Flags: TBits;                   // indicate whether a match of predicate nodes of query node has been found
    List: PQIBufferNodeSet;         // array of buffers of potential answer nodes
  end;

  TQIDataNodeStack = class;

  PQIQueryNodeSet = ^TQIQueryNodeSet;

  PQIQueryNode = ^TQIQueryNode;     // structure that defines query node in the mapping table
  TQIQueryNode = record
    Axis: TQINodeAxis;              // axis of node
    Nodetest: qiString;             // nodetest of node
    Predicate: PQIExpression;        // predicate tree of node
    Options: TQINodeOptions;        // options that defines node kind
    Parent: PQIQueryNode;           // parent node of node
    Child: PQIQueryNode;            // child node of node in the main path
    ChildrenCount: Integer;         // count of node children
    Counter: Integer;               // count of streamed nodes
    PredChildren: PQIQueryNodeSet;  // predicate children of node
    SegmentHost: PQIQueryNode;      // axis node at the tail of main path "//" segnent
    Pos: Integer;                   // position of node among its sibling nodes
    DataStack: TQIDataNodeStack;    // stack of streaming nodes
  end;

  TQIQueryNodeSet = array of PQIQueryNode;

  TQIDataNodeStack = class(TQIXMLObjectStack)
  private
    FOwner: PQIQueryNode;
    function GetItems(const Index: Integer): PQIDataNode;
    function GetTop: PQIDataNode;
  protected
    procedure DisposeItem(const Index: Integer); override;
    function NewItem: Pointer; override;
  public
    constructor Create(Owner: PQIQueryNode);
    procedure Push(const Depth: Integer; Data: PQIDataContainer = nil);
    property Items[const Index: Integer]: PQIDataNode read GetItems; default;
    property Top: PQIDataNode read GetTop;
  end;

  TQIQueryPostOrderCallback = procedure(var Sender: PQIQueryNode) of object;

  TQIMappingTable = class
  private
    FAsteriskSequence: PQIQueryNodeSet;
    FCurrentName: qiString;
    FCurrentSequence: PQIQueryNodeSet;
    FRoot: PQIQueryNode;
    FSequences: TQImportHashTable;
    FResultFound: Boolean;
    procedure DisposeNode(var Sender: PQIQueryNode);
    procedure AppendSequence(var Sender: PQIQueryNode);
    procedure NodePostOrderTraversal(Root: PQIQueryNode; Callback:
        TQIQueryPostOrderCallback);
  public
    constructor Create(Root: PQIQueryNode);
    destructor Destroy; override;
    function Add(const Name: qiString): PQIQueryNodeSet;
    function Find(const Name: qiString): PQIQueryNodeSet;
  end;

  TQIPredicateCalc = class
  protected
    function DoCalculate(Data: PQIDataNode): Variant; virtual; abstract;
  public
    function Calculate(Data: PQIDataNode): Variant;
  end;

  TQIPredicateExpressionClass = class of TQIPredicateCalc;

  TQICalcMethod = (
    qcmUndefined,       // not defined
    qcmExistance,       // exist or not
    qcmValue            // return text or numeric value
  );

  TQIXPathEvaluator = class;

  TQIAmbiguityCalc = class(TQIPredicateCalc)
  private
    FData: PQIDataNode;
    FEvaluator: TQIXPathEvaluator;
    FMethod: TQICalcMethod;
  protected
    function CheckExistance: Boolean; virtual; abstract;
    function DoCalculate(Data: PQIDataNode): Variant; override;
    function GetValue: Variant; virtual; abstract;
  public
    constructor Create;
    property Evaluator: TQIXPathEvaluator read FEvaluator write FEvaluator;
    property Method: TQICalcMethod read FMethod write FMethod;
  end;

  TQINodeCalc = class(TQIAmbiguityCalc)
  private
    FNode: PQIQueryNode;
  protected
    function CheckExistance: Boolean; override;
    function GetValue: Variant; override;
  public
    property Node: PQIQueryNode read FNode write FNode;
  end;

  TQIAttributeCalc = class(TQIAmbiguityCalc)
  private
    FName: qiString;
  protected
    function CheckExistance: Boolean; override;
    function GetValue: Variant; override;
  public
    constructor Create;
    property Name: qiString read FName write FName;
  end;

  TQINumericCalc = class(TQINodeCalc)
  private
    FValue: Variant;
  protected
    function CheckExistance: Boolean; override;
    function GetValue: Variant; override;
  public
    constructor Create;
    property Value: Variant read GetValue write FValue;
  end;

  PQIExpressionSet = ^TQIExpressionSet;
  TQIExpressionSet = array of PQIExpression;

  TQIFunctionCalc = class(TQINodeCalc)
  private
    FArguments: PQIExpressionSet;
    FName: qiString;
  protected
    function CheckExistance: Boolean; override;
    function GetValue: Variant; override;
  public
    constructor Create;
    destructor Destroy; override;
    property Arguments: PQIExpressionSet read FArguments;
    property Name: qiString write FName;
  end;

  TQIStringCalc = class(TQIPredicateCalc)
  private
    FValue: Variant;
  protected
    function DoCalculate(Data: PQIDataNode): Variant; override;
  public
    constructor Create;
    property Value: Variant read FValue write FValue;
  end;

  TQIEvaluatorPostOrderCallback = procedure(Sender: PQIExpression; Data:
      PQIDataNode) of object;

  TQIXPathEvaluator = class(TQIXMLStreamProcessor)
  private
    FBufferQueue: TList;
    FDepth: Integer;
    FTableList: TList;
    FResultNodeOpened: Boolean;
    procedure BuildQueries(const XPath: qiString);
    procedure AddBuffer(Data: PQIDataNode; Buffer: PQIBufferNode);
    function Calculate(Node: PQIQueryNode; Data: PQIDataNode): Boolean;
    procedure ClearQueries;
    procedure ClearBufferQueue;
    function CloseNode(Node: PQIQueryNode): Boolean;
    procedure CalcPredicate(Sender: PQIExpression; Data: PQIDataNode);
    procedure PostOrderTraversal(Root: PQIExpression; Data: PQIDataNode; Callback:
        TQIEvaluatorPostOrderCallback);
    procedure FlushBufferQueue;
    procedure FreeBuffer(Buffer: PQIBufferNode);
    procedure MaskDFlags(Node: PQIQueryNode; Data, Mask: PQIDataNode);
    function OpenNode(Node: PQIQueryNode; Attributes: TQIXPathAttrStack): Boolean;
    procedure SetFlags(Node: PQIQueryNode; Data: PQIDataNode);
    procedure ProcessBufferList(Data: PQIDataNode; State: TQIBufferState);
  protected
    procedure DoGetText(const Text: qiString; TextType: TQIXMLTextType); override;
    procedure DoProcessToken(Token: PQIXMLToken); override;
    procedure DoLoadElement(const Name: qiString; Action: TQIXMLNodeAction);
        override;
    function GetAttributeListClass: TQIXMLAttrListClass; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    //XPath parameter allows to filter nodes, so events for elements and texts
    //will be triggered only for nodes that selected by XPath expression,
    //and only selected attributes will be available for enumeration
    function Evaluate(const FileName: string; const XPath: qiString = ''): Boolean;
  end;

  PQIXPathToken = ^TQIXPathToken;
  TQIXPathToken = packed record
    Value: Variant;
    Kind: TQIXPathTokenKind;
  end;

  TQIXPathTokenStack = class(TQIXMLObjectStack)
  private
    function GetItems(const Index: Integer): PQIXPathToken;
  protected
    function NewItem: Pointer; override;
  public
    function Add: PQIXPathToken;
    property Items[const Index: Integer]: PQIXPathToken read GetItems; default;
  end;

  TQIXPathTokenizer = class(TQITokenizer)
  private
    FCurrentToken: PQIXPathToken;
    FPrevTokenKind: TQIXPathTokenKind;
    FTokens: TQIXPathTokenStack;
  protected
    procedure DoError; override;
    procedure ScanName(var Name: qiString); override;
    function StoreCurrentChar(CharType: TQICharType): Boolean; override;
  public
    constructor Create(const XPath: qiString);
    destructor Destroy; override;
    function GetNextToken(var Token: PQIXPathToken): Boolean;
    procedure Reset; override;
  end;

  TQIXPathParser = class
  private
    FCalc: TQIFunctionCalc;
    FGroupLevel: TQIExpressionSet;
    FPrevTokenKind: TQIXPathTokenKind;
    FNode: PQIQueryNode;
    FOwner: TQIXPathEvaluator;
    FPredLevel: Integer;
    FTokenizer: TQIXPathTokenizer;
    function CheckPredicate: Boolean;
    function CheckGroup: Boolean;
    function CheckFunction: Boolean;
    function GetCurrentPredicate: PQIExpression;
    procedure SetCurrentPredicate(const Value: PQIExpression);
  protected
    property CurrentPredicate: PQIExpression read GetCurrentPredicate write SetCurrentPredicate;
  public
    constructor Create(Owner: TQIXPathEvaluator);
    procedure Parse(const XPath: qiString; out Table: TQIMappingTable);
  end;

  TQIXMLCharsetDetector = class
  private
    FFileName: string;
    FCharset: TQICharsetType;
    function DetectByBOM: Boolean;
    function DetectByAttribute: Boolean;
  public
    class function GetXMLCharset(const FileName: string): TQICharsetType;
    function Detect(const FileName: string; out Charset: TQICharsetType): Boolean;
  end;

implementation

const
  sParsingError = 'Parsing Error - Invalid XML document structure!';
  sPredicateError = 'XPath Error - Invalid XPath predicate structure!';
  sXPathError = 'XPath Error - syntax not supported!';
  ElemTokens = [xtkOpenElem, xtkElemAttr];
  DeclTokens = [xtkOpenXMLDecl, xtkXMLDeclAttr];
  CommonTokens = ElemTokens + DeclTokens;
  TextChars = [xctChar, xctQuery, xctSlash, xctXclam];
  TagStartStr: array[TQIXMLTokenKind] of qiString = (
    '',                 //xtkOpenDoc
    '<!DOCTYPE',        //xtkDocType
    '<!--',             //xtkComment
    '<?xml',            //xtkOpenXMLDecl
    '',                 //xtkXMLDeclAttr
    '',                 //xtkCloseXMLDecl
    '<',                //xtkOpenElem
    '',                 //xtkElemAttr
    '',                 //xtkFinishElem
    '',                 //xtkFinishCloseElem
    '</',               //xtkCloseElem
    '<?',               //xtkInstruction
    '',                 //xtkText
    '&',                //xtkReference
    '<![CDATA['         //xtkCData
  );
  TagEndStr: array[TQIXMLTokenKind] of qiString = (
    '',                 //xtkOpenDoc
    '>',                //xtkDocType
    '-->',              //xtkComment
    '',                 //xtkOpenXMLDecl
    '',                 //xtkXMLDeclAttr
    '?>',               //xtkCloseXMLDecl
    '',                 //xtkOpenElem
    '',                 //xtkElemAttr
    '>',                //xtkFinishElem
    '/>',               //xtkFinishCloseElem
    '>',                //xtkCloseElem
    '?>',               //xtkInstruction
    '',                 //xtkText
    ';',                //xtkReference
    ']]>'               //xtkCData
  );
  AxisStr: array[TQINodeAxis] of qiString = (
    '',                 //qsaUnsupported
    'child',            //qsaChild
    'descendant'        //qsaDescendant
  );
  OperationPrecedence : array[TQIPredicateOperation] of Byte = (
    0,                  // qpoUndefined
    1,                  // qpoMult
    1,                  // qpoDiv
    1,                  // qpoMod
    2,                  // qpoPlus
    2,                  // qpoMinus
    3,                  // qpoLower
    3,                  // qpoLowEq
    3,                  // qpoGreater
    3,                  // qpoGreEq
    4,                  // qpoEqual
    4,                  // qpoNotEq
    5,                  // qpoAnd
    6                   // qpoOr
  );

type
  PQIXMLEntity = ^TQIXMLEntity;
  TQIXMLEntity = packed record
    Name: qiString;
    Value: qiString;
  end;

function QISplitString(var Value: qiString; Index: Integer): qiString;
begin
  Result := Trim(Copy(Value, 1, Index - 1));
  Value := Trim(Copy(Value, Index + 1, Length(Value)));
end;

procedure FreeData(var Data: PQIDataContainer);
begin
  if Assigned(Data) then
  begin
    if Assigned(Data.Attributes) then
      TObject(Data.Attributes).Free;
    TObject(Data.Text).Free;
    Dispose(Data);
    Data := nil;
  end;
end;

procedure AppendNodeSet(NodeSet: PQIQueryNodeSet; Node: PQIQueryNode);
var
  Len: Integer;
begin
  if not Assigned(NodeSet) then
    Exit;
  Len := Length(NodeSet^);
  SetLength(NodeSet^, Len + 1);
  NodeSet^[Len] := Node;
end;

function CheckFlags(Node: PQIQueryNode; Data: PQIDataNode):
    Boolean;
begin
  Result := Data.Flags[Node.Pos];
end;

procedure DisposePredicate(Sender: PQIExpression);
begin
  if not Assigned(Sender) then
    Exit;
  if Assigned(Sender.Calculator) then
    Sender.Calculator.Free;
  Dispose(Sender);
end;

type
  TQIPredicatePostOrderCallback = procedure(Sender: PQIExpression);

procedure PredicatePostOrderTraversal(Root: PQIExpression; Callback:
    TQIPredicatePostOrderCallback);
begin
  if not Assigned(Root) then
    Exit;
  PredicatePostOrderTraversal(Root.Left, Callback);
  PredicatePostOrderTraversal(Root.Right, Callback);
  Callback(Root);
end;

{ TQISAXParser }

procedure TQISAXParser.DoGetText(const Text: qiString; TextType:
    TQIXMLTextType);
begin
  if ((TextType = xttComment) or (FDocStarted and not IsBlankText(Text))) and
    Assigned(FOnGetText) then
    FOnGetText(Self, Text, TextType);
end;

procedure TQISAXParser.DoLoadDeclaration;
begin
  if Assigned(FOnLoadDeclaration) then
    FOnLoadDeclaration(Self);
end;

procedure TQISAXParser.DoProcessToken(Token: PQIXMLToken);
begin
  case Token.Kind of
    xtkOpenElem:
      begin
        if not FDocStarted then
          DoLoadDocument(xnaOpen);
        FTags.Push(Token.Name);
        FCurrentTag := FTags.Top;
      end;
    xtkCloseXMLDecl:
      begin
        FAttributes.Reset;
        DoLoadDeclaration;
      end;
    xtkComment:
      DoGetText(Token.Value, xttComment);
    xtkInstruction:
      DoProcessingInstruction(Token.Name, Token.Value);
  else
    inherited;
  end;
end;

procedure TQISAXParser.DoProcessingInstruction(const Target, Content: qiString);
begin
  if Assigned(OnProcessingInstruction) then
    OnProcessingInstruction(Self, Target, Content);
end;

function TQISAXParser.GetAttributeListClass: TQIXMLAttrListClass;
begin
  Result := TQIXMLAttrList;
end;

function TQISAXParser.Parse(const FileName: string): Boolean;
begin
  Result := ProcessDocument(FileName);
end;

{ TQIXMLTokenizer }

constructor TQIXMLTokenizer.Create(const FileName: string; Charset: TQICharsetType; Attributes: TQIXMLTokenStack);
begin
  FIterator := TQIStreamIterator.Create(FileName, Charset);
  FAttributes := Attributes;
  FOpenElements := TQIXMLTokenStack.Create;
  FEntities := TQImportHashTable.Create(256);
  FKeepSpaces := False;
  inherited Create;
  FillDefaultEntities;
end;

destructor TQIXMLTokenizer.Destroy;
begin
  DisposeEntities;
  FreeAndNil(FEntities);
  FreeAndNil(FOpenElements);
  inherited;
end;

procedure TQIXMLTokenizer.DisposeEntities;
var
  i: Integer;
  keys: TStrings;
  p: Pointer;
begin
  keys := FEntities.GetKeys;
  try
    for i := 0 to keys.Count - 1 do
    begin
      p := FEntities.GetValue(keys[i]);
      FEntities.Remove(keys[i]);
      Dispose(p);
    end;
  finally
    FreeAndNil(keys);
  end;
end;

function TQIXMLTokenizer.GetNextToken(var Token: PQIXMLToken): Boolean;

  procedure ClosePrevOpenElement(const CheckElement: Boolean = False);
  begin
    if (FOpenElements.Count = 0) or (CheckElement and (FCurrentToken.Name <> '') and
      (FOpenElements.Top.Name <> FCurrentToken.Name)) then
      DoError
    else begin
      FOpenElements.Pop;
      FPreserveSpaces := FKeepSpaces;
    end;
  end;

  procedure FinishCloseElement;
  begin
    if FIterator.MoveNext then
    begin
      if FIterator.CurrentType <> xctGreater then // '>' should be here
        DoError;
      FCurrentToken := FOpenElements.Top;
      FCurrentToken.Value := '';
      if FPrevTokenKind in DeclTokens then
        FCurrentToken.Kind := xtkCloseXMLDecl
      else
        FCurrentToken.Kind := xtkFinishCloseElem;
      ClosePrevOpenElement;
    end;
  end;

  procedure FinishElement;
  begin
    FCurrentToken := FOpenElements.Top;
    FCurrentToken.Value := '';
    if FPrevTokenKind in DeclTokens then
      FCurrentToken.Kind := xtkCloseXMLDecl
    else
      FCurrentToken.Kind := xtkFinishElem;
  end;

  procedure ScanText;
  var
    Ct: TQICharType;
    I: Integer;
  begin
    Ct := FIterator.CurrentType;
    I := 0;
    while not FIterator.EOF do
    begin
      if not StoreCurrentChar(Ct) then
        case Ct of
          xctLower: Break;
          xctGreater:
            begin
              if I >= 2 then
                DoError; // ']]>' is not allowed
              FBuffer.StoreChar(FIterator.Current);
            end;
        else
          DoError;
        end;
      if Ct = xctSqBracketRight then
        Inc(I)
      else
        I := 0;
      FIterator.MoveNext;
      Ct := FIterator.CurrentType;
    end;
    if not FIterator.EOF then
      FIterator.Rollback;
    FCurrentToken.Kind := xtkText;
    FCurrentToken.Name := '';
    FBuffer.BuildString(FCurrentToken.Value, not (FPreserveSpaces or FSpaceOnly));
  end;

  procedure CloseOpenedElement;
  begin
    FIterator.MoveNext;
    ScanName(FCurrentToken.Name);
    FIterator.SkipBlanks;
    if FIterator.CurrentType <> xctGreater then
      DoError;
    FCurrentToken.Value := '';
    FCurrentToken.Kind := xtkCloseElem;
    ClosePrevOpenElement(True);
    FEmptyValueDetected := False;
  end;

var
  I: Integer;
  Ch: qiChar;
  Ct, PrevCt: TQICharType;
  PrevS, S: qiString;
  B: Boolean;
begin
  Result := True;
  try
    if FRootOpened and (FOpenElements.Count = 0) then // root element finished
      Result := False
    else begin
      if (FPrevIteratorType = xctSlash) and FEmptyValueDetected then
        CloseOpenedElement
      else if FIterator.MoveNext then
      begin
        FCurrentToken := FOpenElements.Add;
        case FIterator.CurrentType of
          xctLower:
            if FPrevTokenKind in CommonTokens then
              DoError
            else begin
              FIterator.MoveNext;
              case FIterator.CurrentType of
                xctSlash:
                  begin // close element
                    if FPrevIteratorType = xctGreater then
                    begin
                      FEmptyValueDetected := True;
                      FCurrentToken.Kind := xtkText;
                      FCurrentToken.Name := '';
                      FCurrentToken.Value := '';
                    end
                    else
                      CloseOpenedElement;
                  end;
                xctQuery:
                  begin
                    FIterator.MoveNext;
                    ScanName(FCurrentToken.Name);
                    if not TQICharacter.IsBlankChar(FIterator.Current) and
                      (FIterator.CurrentType <> xctQuery) then // a whitespace should be here
                      DoError;
                    if not FRootOpened and (QILowerCase(FCurrentToken.Name) = 'xml') then
                    begin // xml declaration found
                      FCurrentToken.Kind := xtkOpenXMLDecl;
                      FCurrentToken.Value := '';
                      FOpenElements.Push;
                    end
                    else begin // processing instruction found
                      FCurrentToken.Kind := xtkInstruction;
                      PrevCt := FIterator.CurrentType;
                      FIterator.MoveNext;
                      while not (((PrevCt = xctQuery) and
                        (FIterator.CurrentType = xctGreater)) or FIterator.EOF) do
                      begin
                        FBuffer.StoreChar(FIterator.Current);
                        PrevCt := FIterator.CurrentType;
                        FIterator.MoveNext;
                      end;
                      FBuffer.BuildString(FCurrentToken.Value, 1);
                    end;
                  end;
                xctXclam:
                  begin
                    FIterator.MoveNext;
                    case FIterator.Current of
                      '[': FCurrentToken.Kind := xtkCData; // cdata found
                      '-': FCurrentToken.Kind := xtkComment; // comment found
                      'D', 'd': FCurrentToken.Kind := xtkDocType; // doctype found
                    else
                      DoError;
                    end;
                    FIterator.Rollback;
                    FCurrentToken.Name := '';
                    B := True;
                    S := TagStartStr[FCurrentToken.Kind];
                    for I := 3 to Length(S) do
                    begin
                      FIterator.MoveNext;
                      if S[I] <> QIUpperCase(FIterator.Current) then
                      begin
                        B := False;
                        FIterator.Rollback;
                        Break;
                      end;
                    end;
                    if B and (FCurrentToken.Kind = xtkDocType) then
                    begin
                      FIterator.MoveNext;
                      B := TQICharacter.IsBlankChar(FIterator.Current); // a whitespace should be here
                    end;
                    if B then
                    begin
                      S := TagEndStr[FCurrentToken.Kind];
                      PrevS := StringOfChar(#0, Length(S));
                      repeat
                        if Length(PrevS) > 1 then
                          Move(PrevS[2], PrevS[1], (Length(PrevS) - 1) * SizeOf(qiChar));
                        FIterator.MoveNext;
                        Ch := FIterator.Current;
                        case FIterator.CurrentType of
                          xctUnknown: DoError;
                          xctSqBracketLeft:
                            if FCurrentToken.Kind = xtkDocType then
                            begin
                              FBuffer.StoreChar(Ch);
                              FDTDDetected := True;
                              FillEntities;
                              PrevS := StringOfChar(#0, Length(PrevS));
                              Continue;
                            end;
                        end;
                        PrevS[Length(PrevS)] := Ch;
                        FBuffer.StoreChar(Ch);
                      until ((PrevS = S) or FIterator.EOF);
                      FBuffer.BuildString(FCurrentToken.Value, Length(S));
                      if not FPreserveSpaces and (FCurrentToken.Kind = xtkCData) then
                        FCurrentToken.Value := TrimLeft(FCurrentToken.Value);
                    end
                    else
                      DoError;
                  end;
                else begin // open element
                  ScanName(FCurrentToken.Name);
                  if FIterator.CurrentType in [xctSlash, xctGreater] then
                    FIterator.Rollback
                  else if not TQICharacter.IsBlankChar(FIterator.Current) then
                    DoError;
                  FSpaceOnly := False; // "white space only" text value should be ended
                  FRootOpened := True; // ensure that root element opened
                  FCurrentToken.Value := '';
                  FCurrentToken.Kind := xtkOpenElem;
                  FOpenElements.Push;
                  if Assigned(FAttributes) then
                    FAttributes.Clear;
                end;
              end;
            end;
          xctQuery,
          xctSlash:
            if ((FIterator.CurrentType = xctSlash) and (FPrevTokenKind in ElemTokens)) or
              ((FIterator.CurrentType = xctQuery) and (FPrevTokenKind in DeclTokens)) then
              FinishCloseElement // close element
            else
              ScanText; // get text value
          xctGreater:
            if FPrevTokenKind in CommonTokens then // finish element
              FinishElement
            else begin
              if not FKeepSpaces then
                FSpaceOnly := True; // get "white space only" text value
              ScanText;
            end;
          else if FPrevTokenKind in CommonTokens then
          begin
            FIterator.SkipBlanks;
            if ((FIterator.CurrentType = xctSlash) and (FPrevTokenKind in ElemTokens)) or
              ((FIterator.CurrentType = xctQuery) and (FPrevTokenKind in DeclTokens)) then
              FinishCloseElement // close element
            else if (FIterator.CurrentType = xctGreater) and (FPrevTokenKind in ElemTokens) then
              FinishElement // finish element
            else begin  // attribute found
              if Assigned(FAttributes) then
              begin
                FCurrentToken := FAttributes.Add;
                FAttributes.Push;
                ScanName(FCurrentToken.Name); // attribute name
                FIterator.SkipBlanks;
                if FIterator.CurrentType = xctEqual then
                begin
                  FIterator.MoveNext;
                  FIterator.SkipBlanks;
                  PrevCt := FIterator.CurrentType;
                  if PrevCt in [xctSglQuote, xctDblQuote] then
                  begin // attribute value
                    FIterator.MoveNext;
                    Ct := FIterator.CurrentType;
                    while not ((Ct = PrevCt) or FIterator.EOF) do
                    begin
                      if Ct = xctGreater then
                        FBuffer.StoreChar(FIterator.Current)
                      else if not StoreCurrentChar(Ct) then
                        DoError;
                      FIterator.MoveNext;
                      Ct := FIterator.CurrentType;
                    end;
                  end
                  else
                    DoError;
                  FBuffer.BuildString(FCurrentToken.Value, FDTDDetected and not FPreserveSpaces);
                end;
              end
              else
                DoError;
              if FPrevTokenKind in DeclTokens then
              begin
                FCurrentToken.Kind := xtkXMLDeclAttr; // this is a declaration attribute
              end
              else
              begin
                FCurrentToken.Kind := xtkElemAttr; // this is a element attribute
                FPreserveSpaces := FKeepSpaces or ((FCurrentToken.Name = 'xml:space') and
                  (FCurrentToken.Value = 'preserve'));
              end;
            end;
          end
          else
          begin
            if not FKeepSpaces and (FPrevTokenKind in [xtkFinishElem, xtkCloseElem, xtkFinishCloseElem]) then
              FSpaceOnly := True; // get "white space only" text value
            ScanText;
          end;
        end;
      end
      else begin // document finished
        if FOpenElements.Count > 0 then
          DoError;
        Result := False;
        Exit;
      end;
    end;
    FPrevIteratorType := FIterator.CurrentType;
    FPrevTokenKind := FCurrentToken.Kind;
    Token := FCurrentToken;
  except
//    Result := False;
    raise;
  end;
end;

procedure TQIXMLTokenizer.FillDefaultEntities;
const
  sQuotName = 'quot';
  sAposName = 'apos';
  sAmpName = 'amp';
  sLtName = 'lt';
  sGtName = 'gt';

  sQuotValue = '"';
  sAposValue = '''';
  sAmpValue = '&';
  sLtValue = '<';
  sGtValue = '>';

  procedure AddEntity(const AName, AValue: string);
  var
    Entity: PQIXMLEntity;
  begin
    New(Entity);
    Entity.Name := AName;
    Entity.Value := AValue;
    FEntities.Add(AName, Entity);
  end;

begin
  AddEntity(sQuotName, sQuotValue);
  AddEntity(sAposName, sAposValue);
  AddEntity(sAmpName, sAmpValue);
  AddEntity(sLtName, sLtValue);
  AddEntity(sGtName, sGtValue);
end;

procedure TQIXMLTokenizer.FillEntities;
var
  Ch, InQuotes: qiChar;
  S, Name, Value: qiString;
  Ct, Quota: TQICharType;
  IsParameter: Boolean;
  Entity: PQIXMLEntity;
const
  cEntity: qiString = '<!ENTITY';
begin
  FEntities.Clear;
  S := StringOfChar(#0, Length(cEntity));
  InQuotes := #0; // not in quotes
  FIterator.MoveNext;
  Ch := FIterator.Current;
  while not ((InQuotes = #0) and
    (FIterator.CurrentType = xctSqBracketRight)) and
    not FIterator.EOF do
  begin
    if Length(S) > 1 then
      Move(S[2], S[1], (Length(S) - 1) * SizeOf(qiChar));
    S[Length(S)] := qiChar(UpCase(Char(Ch)));
    if S = cEntity then
    begin
      FIterator.MoveNext;
      Ch := FIterator.Current;
      if not TQICharacter.IsBlankChar(FIterator.Current) then
        Continue;
      if FIterator.MoveNext then
      begin
        FIterator.SkipBlanks;
        IsParameter := (FIterator.Current = '%'); // get entity name
        if IsParameter then
        begin
          FIterator.MoveNext;
          FIterator.SkipBlanks;
        end;
        ScanName(Name);
        FIterator.SkipBlanks;
        Value := ''; // get entity value
        Ct := FIterator.CurrentType;
        if not (Ct in [xctDblQuote, xctSglQuote]) then
          DoError;
        Quota := Ct;
        FIterator.MoveNext;
        Ct := FIterator.CurrentType;
        while not ((Ct = Quota) or FIterator.EOF) do
        begin
          if Ct in [xctLower, xctGreater] then
            FBuffer.StoreChar(FIterator.Current)
          else if not StoreCurrentChar(Ct) then
            DoError;
          FIterator.MoveNext;
          Ct := FIterator.CurrentType;
        end;
        FBuffer.BuildString(Value);
        if not IsParameter then // add entity to list
        begin
          New(Entity);
          Entity.Name := Name;
          Entity.Value := Value;
          FEntities.Add(Name, Entity);
        end;
        while not ((FIterator.CurrentType = xctGreater) or FIterator.EOF) do // skip to end of tag
          FIterator.MoveNext;
      end;
    end else
    begin
      case FIterator.CurrentType of
        xctUnknown:
          DoError;
        xctDblQuote, xctSglQuote:
          if InQuotes = #0 then
            InQuotes := Ch
          else if (InQuotes = Ch) then
            InQuotes := #0;
      end;
    end;
    FIterator.MoveNext;
    Ch := FIterator.Current;
  end;
end;

function TQIXMLTokenizer.StoreCurrentChar(CharType: TQICharType): Boolean;

  function CheckValid(const Text: qiString): Boolean;
  var
    I: Integer;
    Ch: qiChar;
  begin
    Result := True;
    for I := 1 to Length(Text) do
    begin
      Ch := Text[I];
      Result := QImport3Common.CharInSet(Ch, ['<', '>', #$09, #$0A, #$0D, #$20..#$3B, #$3D, #$3F..#$FF]);
      if not Result then
        case Ch of
          #$0100..#$FFFD: Result := True;
        else
          Result := False;
        end;
      if not Result then
        Break;
    end;
  end;

var
  OutCh: Integer;
  Name, Value: qiString;
  P: Pointer;
begin
  Result := CharType in [xctCR, xctLF, xctChar, xctQuery, xctSlash,
    xctXclam, xctSglQuote, xctDblQuote, xctSqBracketLeft, xctSqBracketRight,
    xctParensLeft, xctParensRight, xctDot, xctColon, xctComma, xctAt, xctAsterisk,
    xctPlus, xctMinus, xctEqual];
  if Result then
  begin
    FBuffer.StoreChar(FIterator.Current);
    Exit;
  end
  else
    Result := CharType = xctAmpersand;
  if not Result then
    Exit;
 // expand entity reference
  OutCh := 0;
  Name := '';
  Value := '';
  FIterator.MoveNext;
  if FIterator.Current = '#' then
  begin
    FIterator.MoveNext;
    if FIterator.Current = 'x' then
    begin // hexadecimal entity
      FIterator.MoveNext;
      while TQICharacter.IsHexChar(FIterator.Current) and not FIterator.EOF do
      begin
        FBuffer.StoreChar(FIterator.Current);
        FIterator.MoveNext;
      end;
      FBuffer.BuildString(Name);
      if not ((FIterator.Current = ';') and TryStrToInt('$' + Name, OutCh)) then
        DoError;
    end else
    begin // decimal entity
      while TQICharacter.IsDecChar(FIterator.Current) and not FIterator.EOF do
      begin
        Value := Value + FIterator.Current;
        FIterator.MoveNext;
      end;

      if not ((FIterator.Current = ';') and TryStrToInt(Value, OutCh)) then
        DoError;
      if OutCh <> 0 then
        Value := EmptyStr;
    end;
  end
  else begin // text entity
    FBuffer.BuildString(Value);
    ScanName(Name);
    if FEntities.TryGetValue(Name, P) then
    begin
      if FIterator.Current <> ';' then
        DoError;
      Value := Value + PQIXMLEntity(P).Value;
    end;
  end;
  if (OutCh > 0) and (Value = '') then
  begin
    Value := qiString(qiChar(OutCh));
    if not CheckValid(Value) then
      DoError;
  end;
  FBuffer.StoreText(Value);
end;

procedure TQIXMLTokenizer.Reset;
begin
  if Assigned(FAttributes) then
    FAttributes.Clear;
  FOpenElements.Clear;
  FRootOpened := False;
  FPreserveSpaces := FKeepSpaces;
  FSpaceOnly := False;
  FCurrentToken := FOpenElements.Add;
  FPrevTokenKind := xtkOpenDoc;
  FDTDDetected := False;
  inherited;
end;

function TQIXMLTokenStack.Add: PQIXMLToken;
begin
  if FCount = FList.Count then
    Result := PQIXMLToken(AddItem)
  else
    Result := Items[FCount];
end;

function TQIXMLTokenStack.GetItems(const Index: Integer): PQIXMLToken;
begin
  Result := PQIXMLToken(inherited Items[Index]);
end;

function TQIXMLTokenStack.NewItem: Pointer;
begin
  New(PQIXMLToken(Result));
end;

function TQIXMLTokenStack.Top: PQIXMLToken;
begin
    if Count = 0 then
    Result := nil
  else
    Result := Items[Pred(Count)];
end;

{ TQIXMLAttrList }

constructor TQIXMLAttrList.Create;
begin
  inherited;
  FList := TQIXMLTokenStack.Create; // Pointer(FList)
  Reset;
end;

destructor TQIXMLAttrList.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

function TQIXMLAttrList.GetCurrent: PQIXMLToken;
begin
  Result := FList[FIndex];
end;

function TQIXMLAttrList.MoveNext: Boolean;
begin
  Result := FIndex < FList.Count - 1;
  if Result then
    Inc(FIndex);
end;

procedure TQIXMLAttrList.Reset;
begin
  FIndex := -1;
end;

{ TQIXMLBuffer }

constructor TQIXMLBuffer.Create(Size: Integer = cBufferSize);
begin
  inherited Create;
  FSize := Size;
  FIterator := TQIBufferIterator.Create;
  SetBufferLength;
  Reset;
end;

destructor TQIXMLBuffer.Destroy;
begin
  FreeAndNil(FIterator);
  inherited;
end;

procedure TQIXMLBuffer.BuildString(var Result: qiString; KillSpaces: Boolean = False);
var
  I: Integer;
  IsChar: Boolean;
begin
  Result := '';
  IsChar := False;
  if FIndex > 0 then
  begin
    SetLength(Result, FIndex);
    if KillSpaces then
    begin
      I := 0;
      FIterator.Count := FIndex;
      while FIterator.MoveNext do
      begin
        if TQICharacter.IsBlankChar(FIterator.Current) then
        begin
          FIterator.SkipBlanks;
          if FIterator.EOF then
            Break;
          if IsChar then
          begin
            Result[I + 1] := #$20; // only one space should be here
            Inc(I);
          end;
        end;
        Result[I + 1] := FIterator.Current;
        Inc(I);
        if not IsChar then
          IsChar := True;
      end;
      SetLength(Result, I);
    end
    else begin
      {$IFNDEF VCL11} // will copy short strings in loop since moving is much slower
      if FIndex < 15 then
      begin
        I := 1;
        FIterator.Count := FIndex;
        while FIterator.MoveNext do
        begin
          Result[I] := FIterator.Current;
          Inc(I);
        end;
      end
      else
      {$ENDIF}
      Move(FBuffer[0], Result[1], FIndex * SizeOf(qiChar));
    end;
    Reset;
  end;
end;

procedure TQIXMLBuffer.BuildString(var Result: qiString; Offset: Integer;
    KillSpaces: Boolean = False);
begin
  Result := '';
  if FIndex - Offset > 0 then
  begin
    FIndex := FIndex - Offset;
    BuildString(Result, KillSpaces);
  end;
end;

procedure TQIXMLBuffer.Reset;
begin
  FIndex := 0;
end;

procedure TQIXMLBuffer.SetBufferLength;
begin
  SetLength(FBuffer, FSize);
  FIterator.Buffer := PqiChar(FBuffer);
  FIterator.Count := FSize;
end;

procedure TQIXMLBuffer.StoreChar(const Char: qiChar);
begin
  if FIndex = FSize then
  begin
    FSize := FSize + cBufferSize;
    SetBufferLength;
  end;
  FBuffer[FIndex] := Char;
  Inc(FIndex);
end;

procedure TQIXMLBuffer.StoreText(const Text: qiString);
var
  TextLen, Len, Mult: Integer;
{$IFNDEF VCL11}
  I: Integer;
{$ENDIF}
begin
  TextLen := Length(Text);
  if TextLen = 0 then
    Exit;
  Len := FIndex + TextLen;
  if Len >= FSize then
  begin
    Mult := (Len - FSize) div cBufferSize;
    FSize := FSize + cBufferSize * (Mult + 1);
    SetBufferLength;
  end;
  {$IFNDEF VCL11} // will copy short strings in loop since moving is much slower
  if TextLen < 15 then
    for I := 0 to TextLen - 1 do
      FBuffer[FIndex + I] := Text[I + 1]
  else
  {$ENDIF}
  Move(Text[1], FBuffer[FIndex], TextLen * SizeOf(qiChar));
  FIndex := Len;
end;

{ TQIXMLStreamProcessor }

constructor TQIXMLStreamProcessor.Create;
begin
  inherited;
  FAttributes := GetAttributeListClass.Create;
  FTags := TQIXMLTagsStack.Create;
  FKeepSpaces := True;
end;

destructor TQIXMLStreamProcessor.Destroy;
begin
  FreeAndNil(FAttributes);
  FreeAndNil(FTags);
  inherited;
end;

procedure TQIXMLStreamProcessor.DoGetText(const Text: qiString; TextType:
    TQIXMLTextType);
begin
  if (FDocStarted or not IsBlankText(Text)) and  Assigned(FOnGetText) then
    FOnGetText(Self, Text, TextType);
end;

procedure TQIXMLStreamProcessor.DoLoadDocument(Action: TQIXMLNodeAction);
begin
  if Action = xnaOpen then
    FDocStarted := True;
  if Assigned(OnLoadDocument) then
    OnLoadDocument(Self, Action);
end;

procedure TQIXMLStreamProcessor.DoLoadElement(const Name: qiString; Action:
    TQIXMLNodeAction);
begin
  if Assigned(FOnLoadElement) then
    FOnLoadElement(Self, Name, Action);
end;

function TQIXMLStreamProcessor.GetNextAttribute(out Name, Value: qiString;
    Stop: Boolean = False): Boolean;
var
  Token: PQIXMLToken;
begin
  Name := '';
  Value := '';
  Result := not Stop and FAttributes.MoveNext;
  if Result then
  begin
    Token := FAttributes.Current;
    Name := Token.Name;
    Value := Token.Value;
  end
  else
    FAttributes.Reset;
end;

procedure TQIXMLStreamProcessor.Halt;
begin
  FHalt := True;
end;

function TQIXMLStreamProcessor.ProcessDocument(const FileName: string): Boolean;
var
  Token: PQIXMLToken;
begin
  FDocStarted := False;
  FTokenizer := TQIXMLTokenizer.Create(FileName, TQIXMLCharsetDetector.GetXMLCharset(FileName), FAttributes.FList);
  Result := True;
  FHalt := False;
  FTokenizer.KeepSpaces := FKeepSpaces;
  try
    try
      while not FHalt and FTokenizer.GetNextToken(Token) do
        DoProcessToken(Token);
      if FDocStarted and not FHalt then
        DoLoadDocument(xnaClose);
    except
      raise;
  //    Result := False;
    end;
  finally
    FreeAndNil(FTokenizer);
  end;
end;

procedure TQIXMLStreamProcessor.DoProcessToken(Token: PQIXMLToken);
begin
  case Token.Kind of
    xtkCData:
      DoGetText(Token.Value, xttCData);
    xtkText:
      DoGetText(Token.Value, xttText);
    xtkReference:
      DoGetText(Token.Value, xttReference);
    xtkCloseElem:
      begin
        FTags.Pop;
        FCurrentTag := FTags.Top;
        DoLoadElement(Token.Name, xnaClose);
      end;
    xtkFinishCloseElem,
    xtkFinishElem:
      begin
        FAttributes.Reset;
        DoLoadElement(Token.Name, xnaOpen);
        if Token.Kind = xtkFinishCloseElem then
        begin
          FTags.Pop;
          FCurrentTag := FTags.Top;
          DoLoadElement(Token.Name, xnaClose);
        end;
      end;
  end;
end;

{ TQIXPathEvaluator }

procedure TQIXPathEvaluator.BuildQueries(const XPath: qiString);
var
  I: Integer;
  Table: TQIMappingTable;
  List: TqiStringList;
  Parser: TQIXPathParser;
begin
  ClearQueries;
  List := TqiStringList.Create;
  try
    List.Delimiter := '|';
    List.StrictDelimiter := True;
    List.DelimitedText := XPath;
    Parser := TQIXPathParser.Create(Self);
    try
      for I := 0 to List.Count - 1 do
      begin
        Parser.Parse(Trim(List[I]), Table);
        FTableList.Add(Table);
      end;
    finally
      Parser.Free;
    end;
  finally
    List.Free;
  end;
end;

constructor TQIXPathEvaluator.Create;
begin
  inherited;
  FDepth := 0;
  FBufferQueue := TList.Create;
  FTableList := TList.Create;
end;

destructor TQIXPathEvaluator.Destroy;
begin
  ClearQueries;
  FreeAndNil(FTableList);
  ClearBufferQueue;
  FreeAndNil(FBufferQueue);
  inherited;
end;

procedure TQIXPathEvaluator.AddBuffer(Data: PQIDataNode; Buffer: PQIBufferNode);
var
  Len: Integer;
begin
  if Assigned(Data) and Assigned(Buffer) then
  begin
    Len := Length(Data.List^);
    SetLength(Data.List^, Len + 1);
    Buffer.State := qbsWait;
    Data.List^[Len] := Buffer;
  end;
end;

function TQIXPathEvaluator.Calculate(Node: PQIQueryNode; Data: PQIDataNode):
    Boolean;
begin
  Result := True;
  if not (Assigned(Node.Predicate) and Assigned(Data)) then
    Exit;
  PostOrderTraversal(Node.Predicate, Data, CalcPredicate);
  Result := Node.Predicate.Result;
end;

procedure TQIXPathEvaluator.ClearBufferQueue;
var
  I: Integer;
begin
  for I := 0 to FBufferQueue.Count - 1 do
    FreeBuffer(FBufferQueue[I]);
  FBufferQueue.Clear;
end;

procedure TQIXPathEvaluator.ClearQueries;
var
  I: Integer;
begin
  for I := 0 to FTableList.Count - 1 do
    TObject(FTableList[I]).Free;
  FTableList.Clear;
end;

procedure TQIXPathEvaluator.ProcessBufferList(Data: PQIDataNode; State: TQIBufferState);
var
  I: Integer;
begin
  if not (Assigned(Data) and (Length(Data.List^) > 0)) then
    Exit;
  for I := Low(Data.List^) to High(Data.List^) do
    Data.List^[I].State := State;
  FlushBufferQueue;
  SetLength(Data.List^, 0);
end;

function TQIXPathEvaluator.CloseNode(Node: PQIQueryNode): Boolean;

  procedure ClearStacks(Node: PQIQueryNode);
  var
    I: Integer;
    Child: PQIQueryNode;
  begin
    if Node.DataStack.Count <> 0 then
    begin
      Node.DataStack.Clear;
      if not Assigned(Node.PredChildren) then
        Exit;
      for I := Low(Node.PredChildren^) to High(Node.PredChildren^) do
      begin
        Child := Node.PredChildren^[I];
        if not (qnoLeaf in Child.Options) then
          ClearStacks(Child);
      end;
    end;
  end;

  procedure AddBufferList(Target: PQIDataNode; Source: PQIDataNode);
  var
    TLen, SLen, I: Integer;
  begin
    if Assigned(Target) and Assigned(Source) then
    begin
      SLen := Length(Source.List^);
      if SLen > 0 then
      begin
        TLen := Length(Target.List^);
        SetLength(Target.List^, TLen + SLen);
        for I := 0 to SLen - 1 do
          Target.List^[TLen + I] := Source.List^[I];
      end;
    end;
  end;

var
  Parent, Host: PQIQueryNode;
  D, S: PQIDataNode;
  Buffer: PQIBufferNode;
begin
  Result := False;
  if qnoResult in Node.Options then
    FResultNodeOpened := False;
  if (qnoLeaf in Node.Options) or (Node.DataStack.Count = 0) then
    Exit;
  S := Node.DataStack.Top;
  if S.Depth = FDepth then
  begin
    Node.DataStack.Pop;
    if Node.DataStack.Count > 0 then
    begin
      D := Node.DataStack.Top;
      MaskDFlags(Node, D, S);
    end;
    if Calculate(Node, S) then
    begin
      Parent := Node.Parent;
      D := Parent.DataStack.Top;
      if qnoPredicate in Node.Options then
      begin
        SetFlags(Node, D);
        if Node.Axis = qnaDescendant then
          ClearStacks(Node);
      end
      else if qnoAxis in Node.Options then
        if qnoRoot in Parent.Options then
          ProcessBufferList(S, qbsFlush)
        else
          AddBufferList(D, S)
      else if qnoResult in Node.Options then
      begin
        New(Buffer);
        Buffer.Data := S.Data;

        S.Data := nil; // to avoid double destruction
        FBufferQueue.Add(Buffer);
        if qnoRoot in Parent.Options then
        begin
          Buffer.State := qbsFlush;
          FlushBufferQueue;
        end
        else
          AddBuffer(D, Buffer);
      end;
    end
    else if qnoAxis in Node.Options then
    begin
      Host := Node.SegmentHost;
      if Host.DataStack.Count > 0 then
      begin
        D := Host.DataStack.Top;
        AddBufferList(D, S)
      end
      else
        ProcessBufferList(S, qbsFree);
    end;
  end;
end;

procedure TQIXPathEvaluator.CalcPredicate(Sender: PQIExpression; Data:
    PQIDataNode);
var
  I: Integer;
  Arguments: PQIExpressionSet;
begin
  if not Assigned(Sender) then
    Exit;
  case Sender.Operation of
    qpoAnd:
      Sender.Result := Sender.Left.Result and Sender.Right.Result;
    qpoOr:
      Sender.Result := Sender.Left.Result or Sender.Right.Result;
    qpoDiv:
      Sender.Result := Sender.Left.Result / Sender.Right.Result;
    qpoMod:
      Sender.Result := Sender.Left.Result mod Sender.Right.Result;
    qpoMult:
      Sender.Result := Sender.Left.Result * Sender.Right.Result;
    qpoPlus:
      Sender.Result := Sender.Left.Result + Sender.Right.Result;
    qpoMinus:
      Sender.Result := Sender.Left.Result - Sender.Right.Result;
    qpoEqual:
      Sender.Result := Sender.Left.Result = Sender.Right.Result;
    qpoNotEq:
      Sender.Result := Sender.Left.Result <> Sender.Right.Result;
    qpoLower:
      Sender.Result := Sender.Left.Result < Sender.Right.Result;
    qpoLowEq:
      Sender.Result := Sender.Left.Result <= Sender.Right.Result;
    qpoGreater:
      Sender.Result := Sender.Left.Result > Sender.Right.Result;
    qpoGreEq:
      Sender.Result := Sender.Left.Result >= Sender.Right.Result;
  else
    if Assigned(Sender.Calculator) then
    begin
      if Sender.Calculator is TQIFunctionCalc then
      begin
        Arguments := TQIFunctionCalc(Sender.Calculator).Arguments;
        for I := Low(Arguments^) to High(Arguments^) do
          PostOrderTraversal(Arguments^[I], Data, CalcPredicate);
      end;
      Sender.Result := Sender.Calculator.Calculate(Data);
    end;
  end;
end;

procedure TQIXPathEvaluator.DoGetText(const Text: qiString; TextType:
    TQIXMLTextType);
var
  Buffer: PQIBufferNode;
  TextWithTag: qiString;
begin
  if FBufferQueue.Count > 0 then
  begin
    Buffer := FBufferQueue[FBufferQueue.Count - 1];
    if FResultNodeOpened and Assigned(Buffer) and (Buffer.State = qbsWait) and
      Assigned(Buffer.Data)
    then begin
      TextWithTag := CurrentTag + '=' + Text;
      TqiStringList(Buffer.Data.Text).AddObject(TextWithTag, TObject(TextType));
    end;
  end;
end;

procedure TQIXPathEvaluator.DoLoadElement(const Name: qiString; Action:
    TQIXMLNodeAction);
var
  Sequence: PQIQueryNodeSet;
  I, J: Integer;
  Confirmed: Boolean;
begin
  Confirmed := False;
  for I := 0 to FTableList.Count - 1 do
  begin
    Sequence := TQIMappingTable(FTableList[I]).Find(Name);
    if Assigned(Sequence) then
    begin
      case Action of
        xnaOpen:
          begin
            Inc(FDepth);
            for J := Low(Sequence^) to High(Sequence^) do
              Confirmed := Confirmed or OpenNode(Sequence^[J], TQIXPathAttrStack(FAttributes));
          end
        else begin
          for J := High(Sequence^) downto Low(Sequence^) do
            Confirmed := Confirmed or CloseNode(Sequence^[J]);
          Dec(FDepth);
        end;
      end;
      if Confirmed then
        Break;
    end;
  end;
end;

procedure TQIXPathEvaluator.DoProcessToken(Token: PQIXMLToken);
begin
  inherited;
  if Token.Kind = xtkOpenElem then
  begin
    FTags.Push(Token.Name);
    FCurrentTag := FTags.Top;
  end;
end;

procedure TQIXPathEvaluator.PostOrderTraversal(Root: PQIExpression; Data:
    PQIDataNode; Callback: TQIEvaluatorPostOrderCallback);
begin
  if not Assigned(Root) then
    Exit;
  PostOrderTraversal(Root.Left, Data, Callback);
  PostOrderTraversal(Root.Right, Data, Callback);
  Callback(Root, Data);
end;

function TQIXPathEvaluator.Evaluate(const FileName: string; const XPath:
    qiString = ''): Boolean;
begin
  Result := Trim(XPath) = sDefaultXPath;
  if not Result then
  begin
    FDepth := 0;
    FCurrenttag := EmptyStr;
    ClearBufferQueue;
    BuildQueries(XPath);
    Result := ProcessDocument(FileName);
  end;
end;

procedure TQIXPathEvaluator.FlushBufferQueue;
var
  Buffer: PQIBufferNode;
  Data: PQIDataContainer;
  Text: TqiStringList;
  I: Integer;
begin
  if FBufferQueue.Count > 0 then
    repeat
      Buffer := PQIBufferNode(FBufferQueue[0]);
      if Assigned(Buffer) then
        case Buffer.State of
          qbsWait: Break;
          else begin
            if Buffer.State = qbsFlush then
            begin
              Data := Buffer.Data;
              if Assigned(Data) then
              begin
                TQIXPathAttrStack(FAttributes).Push(Data.Attributes);
                Data.Attributes := nil; // to avoid double destruction
                try
                  if Assigned(FOnLoadElement) then
                    FOnLoadElement(Self, Data.Name, xnaOpen);
                  try
                    Text := TqiStringList(Data.Text);
                    for I := 0 to Text.Count - 1 do
                    begin
                      Self.FCurrentTag := Data.Name;
                      if Assigned(FOnGetText) then
                        FOnGetText(Self, Text[I], TQIXMLTextType(Text.Objects[I]));
                    end;
                  finally
                    if Assigned(FOnLoadElement) then
                      FOnLoadElement(Self, Data.Name, xnaClose);
                  end;
                finally
                  TQIXPathAttrStack(FAttributes).Pop;
                end;
              end;
            end;
            FreeBuffer(Buffer);
          end;
        end;
      FBufferQueue.Delete(0);
    until FBufferQueue.Count = 0;
end;

procedure TQIXPathEvaluator.FreeBuffer(Buffer: PQIBufferNode);
begin
  if not Assigned(Buffer) then
    Exit;
  FreeData(Buffer.Data);
  Dispose(Buffer);
end;

function TQIXPathEvaluator.GetAttributeListClass: TQIXMLAttrListClass;
begin
  Result := TQIXPathAttrStack;
end;

procedure TQIXPathEvaluator.MaskDFlags(Node: PQIQueryNode; Data, Mask:
    PQIDataNode);
var
  I: Integer;
  Child: PQIQueryNode;
begin
  if not Assigned(Node.PredChildren) then
    Exit;
  for I := Low(Node.PredChildren^) to High(Node.PredChildren^) do
  begin
    Child := Node.PredChildren^[I];
    if Child.Axis = qnaDescendant then
      Data.Flags[I] := Data.Flags[I] or Mask.Flags[I];
  end;
end;

function TQIXPathEvaluator.OpenNode(Node: PQIQueryNode; Attributes:
    TQIXPathAttrStack): Boolean;

  function GetDataContainer: PQIDataContainer;
  begin
    New(Result);
    Result.Attributes := Attributes.Clone;
    Result.Text := TqiStringList.Create;
    Result.Name := Node.Nodetest;
  end;

var
  Parent: PQIQueryNode;
  Data: PQIDataNode;
  Buffer: PQIBufferNode;
begin
  Result := False;
  Parent := Node.Parent;
  if Parent.DataStack.Count = 0 then
    Exit;
  Data := Parent.DataStack.Top;
  if not ((qnoPredicate in Node.Options) and CheckFlags(Node, Data)) and
    ((Node.Axis = qnaDescendant) or (Data.Depth = FDepth - 1)) then
    if qnoLeaf in Node.Options then
    begin
      if qnoPredicate in Node.Options then
        SetFlags(Node, Data)
      else if qnoResult in Node.Options then
      begin
        New(Buffer);
        Buffer.Data := GetDataContainer;
        FResultNodeOpened := True;

        if (High(Data.List^) > 0) and ((High(Data.List^) mod 2) = 0) then
//        if qnoRoot in Parent.Options then
          ProcessBufferList(Data, qbsFlush);

        FBufferQueue.Add(Buffer);
        AddBuffer(Data, Buffer);
      end;
    end
    else begin
      if (qnoPredicate in Node.Options) or (qnoAxis in Node.Options) then
        Node.DataStack.Push(FDepth)
      else if qnoResult in Node.Options then
        Node.DataStack.Push(FDepth, GetDataContainer);
    end;
end;

procedure TQIXPathEvaluator.SetFlags(Node: PQIQueryNode; Data: PQIDataNode);
begin
  Data.Flags[Node.Pos] := True;
end;

{ TQIXMLObjectStack }

procedure TQIXMLObjectStack.Push;
begin
  Inc(FCount);
end;

constructor TQIXMLObjectStack.Create;
begin
  inherited Create;
  FList := TList.Create;
  FCount := 0;
end;

procedure TQIXMLObjectStack.Pop;
begin
  Dec(FCount);
  if FCount < 0 then
    FCount := 0;
end;

destructor TQIXMLObjectStack.Destroy;
var
  I: Integer;
begin
  for I := 0 to FList.Count-1 do
    DisposeItem(I);
  FreeAndNil(FList);
  inherited;
end;

function TQIXMLObjectStack.AddItem: Pointer;
begin
  Result := NewItem;
  FList.Add(Result);
end;

procedure TQIXMLObjectStack.Clear;
begin
  FCount := 0;
end;

procedure TQIXMLObjectStack.DisposeItem(const Index: Integer);
begin
  Dispose(FList[Index]);
  FList[Index] := nil;
end;

function TQIXMLObjectStack.GetItems(const Index: Integer): Pointer;
begin
  Result := FList[Index];
end;

function TQIXMLObjectStack.IndexOf(const Value: Pointer): Integer;
var
  I: Integer;
begin
  Result := -1;
  if Value = nil then
    Exit;
  for I := 0 to Count - 1 do
  if FList[I] = Value then
  begin
    Result := I;
    Break;
  end;
end;

{ TQIDataNodeStack }

constructor TQIDataNodeStack.Create(Owner: PQIQueryNode);
begin
  inherited Create;
  FOwner := Owner;
end;

procedure TQIDataNodeStack.DisposeItem(const Index: Integer);
begin
  FreeData(PQIDataNode(FList[index]).Data);
  inherited;
end;

function TQIDataNodeStack.GetItems(const Index: Integer): PQIDataNode;
begin
  Result := PQIDataNode(inherited Items[Index]);
end;

function TQIDataNodeStack.GetTop: PQIDataNode;
begin
  if FCount > 0 then
    Result := Items[FCount - 1]
  else
    Result := nil;
end;

function TQIDataNodeStack.NewItem: Pointer;
begin
  New(PQIDataNode(Result));
  New(PQIDataNode(Result).List);
end;

procedure TQIDataNodeStack.Push(const Depth: Integer; Data: PQIDataContainer =
    nil);
var
  Node: PQIDataNode;
begin
  if FCount = FList.Count then
    Node := PQIDataNode(AddItem)
  else begin
    Node := Items[FCount];
    SetLength(Node.List^, 0);
  end;
  Node.Depth := Depth;
  Node.Data := Data;

//  if Assigned(FOwner) then
//    FOwner.
  inherited Push;
end;

{ TQIMappingTable }

constructor TQIMappingTable.Create(Root: PQIQueryNode);
begin
  inherited Create;
  FSequences := TQImportHashTable.Create(256);
  FAsteriskSequence := nil;
  FRoot := Root;
  FCurrentSequence := nil;
  FCurrentName := '';
  FResultFound := False;
end;

destructor TQIMappingTable.Destroy;
begin
  NodePostOrderTraversal(FRoot, DisposeNode); // dispose all nodes of query tree recursively
  if Assigned(FAsteriskSequence) then
    Dispose(FAsteriskSequence);
  FreeAndNil(FSequences);
  inherited;
end;

function TQIMappingTable.Add(const Name: qiString): PQIQueryNodeSet;
begin
  Result := Find(Name);
  if not Assigned(Result) then
    New(Result)
  else
    Exit;
  FCurrentSequence := Result;
  FCurrentName := Name;
// fill c-sequence using post-order traversal of nodes across a query tree
  NodePostOrderTraversal(FRoot, AppendSequence);
  if Name = '*' then
    FAsteriskSequence := Result
  else
    FSequences.Add(Name, Result);
end;

procedure TQIMappingTable.DisposeNode(var Sender: PQIQueryNode);
begin
  if not Assigned(Sender) then
    Exit;
  FreeAndNil(Sender.DataStack);
  if Assigned(Sender.PredChildren) then
  begin
    Dispose(Sender.PredChildren);
    Sender.PredChildren := nil;
  end;
  if Assigned(Sender.Predicate) then
    PredicatePostOrderTraversal(Sender.Predicate, DisposePredicate);
  Dispose(Sender);
  Sender := nil;
end;

procedure TQIMappingTable.AppendSequence(var Sender: PQIQueryNode);
begin
  if not Assigned(FCurrentSequence) then
    Exit;
  if (FCurrentName = '*') or
    (QICompareText(Sender.Nodetest, FCurrentName) = 0) then
    AppendNodeSet(FCurrentSequence, Sender);
  if qnoAxis in Sender.Options then
  begin
    if not (FResultFound or Assigned(Sender.Child)) then
    begin
      Exclude(Sender.Options, qnoAxis);
      Include(Sender.Options, qnoResult);
      FResultFound := True;
      if not Assigned(Sender.PredChildren) then
        Include(Sender.Options, qnoLeaf);
    end;
    Exit;
  end;
  if (qnoPredicate in Sender.Options) and not (qnoLeaf in Sender.Options) then
    if not (Assigned(Sender.Child) or Assigned(Sender.PredChildren)) then
      Include(Sender.Options, qnoLeaf);
end;

function TQIMappingTable.Find(const Name: qiString): PQIQueryNodeSet;
begin
  if not FSequences.TryGetValue(Name, Pointer(Result)) then
    Result := FAsteriskSequence;
end;

procedure TQIMappingTable.NodePostOrderTraversal(Root: PQIQueryNode; Callback:
    TQIQueryPostOrderCallback);
var
  I: Integer;
begin
  if not Assigned(Root) then
    Exit;
  NodePostOrderTraversal(Root.Child, Callback);
  if Assigned(Root.PredChildren) then
    for I := Low(Root.PredChildren^) to High(Root.PredChildren^) do
      NodePostOrderTraversal(Root.PredChildren^[I], Callback);
  Callback(Root);
end;

{ TQITokenizer }

constructor TQITokenizer.Create;
begin
  inherited Create;
  FBuffer := TQIXMLBuffer.Create;
  Reset;
end;

destructor TQITokenizer.Destroy;
begin
  FreeAndNil(FBuffer);
  FreeAndNil(FIterator);
  inherited;
end;

procedure TQITokenizer.DoError;
begin
  raise Exception.Create(sParsingError);
end;

procedure TQITokenizer.Reset;
begin
  FBuffer.Reset;
end;

procedure TQITokenizer.ScanName(var Name: qiString);
begin
  if not TQICharacter.IsFirstIdentChar(FIterator.Current) then
    DoError;
  while TQICharacter.IsIdentChar(FIterator.Current) and not FIterator.EOF do
  begin
    FBuffer.StoreChar(FIterator.Current);
    FIterator.MoveNext;
  end;
  FBuffer.BuildString(Name);
end;

constructor TQIXPathParser.Create(Owner: TQIXPathEvaluator);
begin
  inherited Create;
  FPredLevel := 0;
  SetLength(FGroupLevel, 0);
  FPrevTokenKind := ptkUnknown;
  FOwner := Owner;
  FNode := nil;
end;

function TQIXPathParser.CheckPredicate: Boolean;
begin
  Result := FPredLevel > 0;
end;

function TQIXPathParser.CheckGroup: Boolean;
begin
  Result := Length(FGroupLevel) > 0;
end;

function TQIXPathParser.CheckFunction: Boolean;
var
  Len: Integer;
begin
  Len := Length(FGroupLevel);
  Result := (Len > 0) and Assigned(FGroupLevel[Len - 1]);
end;

function TQIXPathParser.GetCurrentPredicate: PQIExpression;
var
  Len: Integer;
begin
  Result := nil;
  if CheckFunction then
  begin
    if Assigned(FCalc) then
    begin
      Len := Length(FCalc.Arguments^);
      if Len = 0 then
        Exit;
      Result := FCalc.Arguments^[Len - 1];
    end
    else
      Exit;
  end
  else if Assigned(FNode) then
    Result := FNode.Predicate;
end;

procedure TQIXPathParser.Parse(const XPath: qiString; out Table:
    TQIMappingTable);
var
  List: TqiStringList;
  LastPrecedence: Byte;
  Token: PQIXPathToken;
  CurrentExpression: PQIExpression;

  function InitNode(Parent: PQIQueryNode; Axis: TQINodeAxis; const Nodetest:
      qiString): PQIQueryNode;
  begin
    New(Result);
    Result.Axis := Axis;
    Result.Nodetest := Nodetest;
    Result.Predicate := nil;
    Result.Options := [];
    Result.Parent := Parent;
    Result.Child := nil;
    Result.ChildrenCount := 0;
    Result.Counter := 0;
    Result.PredChildren := nil;
    Result.SegmentHost := nil;
    Result.DataStack := TQIDataNodeStack.Create(Result);
    if Assigned(Parent) then
    begin
      Result.Pos := Parent.ChildrenCount;
      if CheckPredicate then
      begin
        if not Assigned(Parent.PredChildren) then
          New(Parent.PredChildren);
        AppendNodeSet(Parent.PredChildren, Result);
        Include(Result.Options, qnoPredicate);
      end
      else begin
        Parent.Child := Result;
        Include(Result.Options, qnoAxis);
      end;
      Inc(Parent.ChildrenCount);
    end
    else begin
      Result.Pos := -1;
      Include(Result.Options, qnoRoot);
      Result.DataStack.Push(0);
    end;
    List.Add(Nodetest);
  end;

  function TokenKindToOperation(Kind: TQIXPathTokenKind): TQIPredicateOperation;
  begin
    case Kind of
      ptkAnd: Result := qpoAnd;
      ptkOr: Result := qpoOr;
      ptkDiv: Result := qpoDiv;
      ptkMod: Result := qpoMod;
      ptkMult: Result := qpoMult;
      ptkPlus: Result := qpoPlus;
      ptkMinus: Result := qpoMinus;
      ptkEqual: Result := qpoEqual;
      ptkNotEq: Result := qpoNotEq;
      ptkLower: Result := qpoLower;
      ptkLowEq: Result := qpoLowEq;
      ptkGreater: Result := qpoGreater;
      ptkGreEq: Result := qpoGreEq;
    else
      Result := qpoUndefined;
    end;
  end;

  function InitExpression(Kind: TQIXPathTokenKind): PQIExpression;
  begin
    New(Result);
    Result.Operation := TokenKindToOperation(Kind);
    Result.Calculator := nil;
    Result.Result := False;
    Result.Left := nil;
    Result.Right := nil;
  end;

  function CheckPrecedence(Kind: TQIXPathTokenKind): Boolean;
  var
    Prec: Byte;
  begin
    if CheckGroup then
      Prec := 0
    else
      Prec := OperationPrecedence[TokenKindToOperation(Kind)];
    Result := LastPrecedence <= Prec;
    LastPrecedence := Prec;
  end;

  function InitArgument: PQIExpression;
  var
    Len: Integer;
  begin
    Result := nil;
    if not Assigned(FCalc) then
      Exit;
    Len := Length(FCalc.Arguments^);
    SetLength(FCalc.Arguments^, Len + 1);
    FCalc.Arguments^[Len] := InitExpression(ptkUnknown);
    Result := FCalc.Arguments^[Len];
  end;

  procedure DefineExpression;
  var
    B: Boolean;
  begin
    if not Assigned(CurrentExpression) then
      Exit;
    B := CurrentExpression.Operation <> qpoUndefined;
    if B then
    begin
      CurrentExpression.Right := InitExpression(ptkUnknown);
      CurrentExpression := CurrentExpression.Right;
    end;
    case Token.Kind of
      ptkAttribute:
        begin
          CurrentExpression.Calculator := TQIAttributeCalc.Create;
          TQIAttributeCalc(CurrentExpression.Calculator).Evaluator := FOwner;
          TQIAttributeCalc(CurrentExpression.Calculator).Name := Token.Value;
        end;
      ptkString:
        begin
          CurrentExpression.Calculator := TQIStringCalc.Create;
          TQIStringCalc(CurrentExpression.Calculator).Value := Token.Value;
        end;
      ptkFunction:
        begin
          CurrentExpression.Calculator := TQIFunctionCalc.Create;
          FCalc := TQIFunctionCalc(CurrentExpression.Calculator);
          FCalc.Node := FNode;
          FCalc.Name := Token.Value;
        end;
      else begin
        if Token.Kind = ptkNode then
          CurrentExpression.Calculator := TQINodeCalc.Create
        else begin
          CurrentExpression.Calculator := TQINumericCalc.Create;
          TQINumericCalc(CurrentExpression.Calculator).Value := Token.Value;
        end;
        TQINodeCalc(CurrentExpression.Calculator).Node := FNode;
      end;
    end;
    if B and (CurrentExpression.Calculator is TQIAmbiguityCalc) then
      TQIAmbiguityCalc(CurrentExpression.Calculator).Method := qcmValue
    else
      TQIAmbiguityCalc(CurrentExpression.Calculator).Method := qcmExistance;
  end;

var
  Root, Parent, Host: PQIQueryNode;
  Axis: TQINodeAxis;
  I: Integer;
begin
  List := TqiStringList.Create;
  try
    List.Duplicates := dupAccept;
    FTokenizer := TQIXPathTokenizer.Create(XPath);
    try
      Parent := nil;
      LastPrecedence := 0;
      Root := InitNode(Parent, qnaUnsupported, '');
      Axis := qnaChild;
      try
        FNode := Root;
        while FTokenizer.GetNextToken(Token) do
          case Token.Kind of
            ptkOpenPred:
              begin
                if Assigned(FNode) then
                begin
                  CurrentExpression := InitExpression(ptkUnknown);
                  CurrentPredicate := CurrentExpression;
                end;
                Inc(FPredLevel);
              end;
            ptkClosePred:
              if CheckPredicate then
              begin
                if Assigned(Parent) and Assigned(Parent.PredChildren) then
                  FNode := Parent;
                Dec(FPredLevel);
              end;
            ptkOpenGroup:
              begin
                I := Length(FGroupLevel);
                SetLength(FGroupLevel, I + 1);
                if FPrevTokenKind = ptkFunction then
                  FGroupLevel[I] := CurrentExpression
                else
                  FGroupLevel[I] := nil;
              end;
            ptkCloseGroup:
              if CheckGroup then
              begin
                I := Length(FGroupLevel) - 1;
                if I >= 0 then
                begin
                  if Assigned(FGroupLevel[I]) then
                  begin
                    FCalc := nil;
                    CurrentExpression := FGroupLevel[I];
                  end;
                  SetLength(FGroupLevel, I);
                end;
              end;
            ptkAxis:
              begin
                Axis := TQINodeAxis(Token.Value);
                if (Axis = qnaDescendant) and Assigned(FNode) and
                  (qnoAxis in FNode.Options) then
                begin
                  Host := FNode;
                  try
                    repeat
                      FNode.SegmentHost := Host;
                      FNode := FNode.Parent;
                    until (FNode.Axis = qnaDescendant) or (qnoRoot in FNode.Options);
                  finally
                    FNode := Host;
                  end;
                end;
              end;
            ptkNode,
            ptkAttribute,
            ptkNumber:
              begin
                if Token.Kind = ptkNode then
                begin
                  Parent := FNode;
                  FNode := InitNode(Parent, Axis, Token.Value);
                end;
                if CheckPredicate then
                begin
                  if CheckFunction and (FPrevTokenKind = ptkOpenGroup) then
                    CurrentExpression := InitArgument;
                  DefineExpression;
                end;
              end;
            ptkAnd, ptkOr,
            ptkDiv, ptkMod,
            ptkMult, ptkPlus,
            ptkMinus, ptkEqual,
            ptkNotEq, ptkLower,
            ptkLowEq,  ptkGreater, ptkGreEq:
              if Assigned(FNode) and CheckPredicate then
              begin
                if (CurrentExpression.Calculator is TQIAmbiguityCalc) and
                  (TQIAmbiguityCalc(CurrentExpression.Calculator).Method = qcmExistance) then
                  TQIAmbiguityCalc(CurrentExpression.Calculator).Method := qcmValue;
                if CheckPrecedence(Token.Kind) then
                begin
                  CurrentExpression := InitExpression(Token.Kind);
                  CurrentExpression.Left := CurrentPredicate;
                  CurrentPredicate := CurrentExpression;
                end
                else if Assigned(CurrentPredicate.Right) then
                begin
                  CurrentExpression := CurrentPredicate.Right;
                  CurrentPredicate.Right := InitExpression(Token.Kind);
                  CurrentPredicate.Right.Left := CurrentExpression;
                  CurrentExpression := CurrentPredicate.Right;
                end;
              end;
            ptkString,
            ptkFunction:
              if CheckPredicate then
                DefineExpression;
            ptkComma:
              if CheckFunction then
                CurrentExpression := InitArgument;
          end;
        FPrevTokenKind := Token.Kind;
      except
        raise;
      end;
    finally
      FreeAndNil(FTokenizer);
    end;
    Table := TQIMappingTable.Create(Root);
    for I := 0 to List.Count - 1 do
      Table.Add(List[I]);
  finally
    List.Free;
  end;
end;

procedure TQIXPathParser.SetCurrentPredicate(const Value: PQIExpression);
var
  Len: Integer;
begin
  if CheckFunction and Assigned(FCalc) then
  begin
    Len := Length(FCalc.Arguments^);
    if Len > 0 then
      FCalc.Arguments^[Len - 1] := Value;
  end
  else if Assigned(FNode) then
    FNode.Predicate := Value;
end;

{ TQIXPathAttrStack }

type
  PQIAttrStackItem = ^TQIAttrStackItem;
  TQIAttrStackItem = record
    Attributes: TQIXMLTokenStack;
    Index: Integer;
  end;

constructor TQIXPathAttrStack.Create;
begin
  inherited;
  FStack := TList.Create;
end;

destructor TQIXPathAttrStack.Destroy;
begin
  FreeAndNil(FStack);
  inherited;
end;

function TQIXPathAttrStack.Clone: TQIXMLTokenStack;
var
  I: Integer;
  Token: PQIXMLToken;
begin
  Result := TQIXMLTokenStack.Create; // Pointer(Result)
  for I := 0 to FList.FList.Count - 1 do
  begin
    Token := Result.AddItem;
    Token.Name := PQIXMLToken(FList.FList[I]).Name;
    Token.Value := PQIXMLToken(FList.FList[I]).Value;
    Token.Kind := PQIXMLToken(FList.FList[I]).Kind;
  end;
  Result.FCount := FList.FCount;
end;

procedure TQIXPathAttrStack.Pop;
var
  Item: PQIAttrStackItem;
begin
  if FStack.Count > 0 then
  begin
    Item := PQIAttrStackItem(FStack[FStack.Count - 1]);
    FStack.Remove(Item);
    FreeAndNil(FList); // Pointer(FList)
    FList := Item.Attributes;
    FIndex := Item.Index;
    Dispose(Item);
  end;
end;

procedure TQIXPathAttrStack.Push(List: TQIXMLTokenStack);
var
  Item: PQIAttrStackItem;
begin
  New(Item);
  Item.Attributes := FList;
  Item.Index := FIndex;
  FStack.Add(Item);
  FList := List;  // Pointer(List)
  Reset;
end;

{ TQIXPathTokenizer }

constructor TQIXPathTokenizer.Create(const XPath: qiString);
begin
  FIterator := TQIBufferIterator.Create;
  TQIBufferIterator(FIterator).Buffer := PqiChar(XPath);
  TQIBufferIterator(FIterator).Count := Length(XPath);
  inherited Create;
  FTokens := TQIXPathTokenStack.Create;
end;

destructor TQIXPathTokenizer.Destroy;
begin
  FreeAndNil(FTokens);
  inherited;
end;

procedure TQIXPathTokenizer.DoError;
begin
  raise Exception.Create(sXPathError);
end;

function TQIXPathTokenizer.GetNextToken(var Token: PQIXPathToken): Boolean;

  procedure ScanText;
  var
    Ct, PrevCt: TQICharType;
    S: qiString;
  begin
    PrevCt := FIterator.CurrentType;
    if PrevCt in [xctSglQuote, xctDblQuote] then
    begin // attribute value
      FIterator.MoveNext;
      Ct := FIterator.CurrentType;
      while not ((Ct = PrevCt) or FIterator.EOF) do
      begin
        if not StoreCurrentChar(Ct) then
          DoError;
        FIterator.MoveNext;
        Ct := FIterator.CurrentType;
      end;
    end
    else
      DoError;
    FBuffer.BuildString(S);
    FCurrentToken.Value := S;
  end;

var
  I: Integer;
  S: qiString;
  B: Boolean;
begin
  Result := False;
  try
    FCurrentToken := FTokens.Add;
    if FIterator.MoveNext then
    begin
      case FIterator.CurrentType of
        xctSlash:
          begin
            FIterator.MoveNext;
            if FIterator.CurrentType = xctSlash then
              FCurrentToken.Value := Integer(qnaDescendant)
            else if TQICharacter.IsFirstIdentChar(FIterator.Current) or (FIterator.CurrentType = xctAsterisk) then
            begin
              FCurrentToken.Value := Integer(qnaChild);
              FIterator.Rollback;
            end
            else
              DoError;
            FCurrentToken.Kind := ptkAxis;
          end;
        xctAt:
          begin
            FIterator.MoveNext;
            if not TQICharacter.IsFirstIdentChar(FIterator.Current) then
              DoError;
            FCurrentToken.Kind := ptkAttribute;
            ScanName(S);
            FCurrentToken.Value := S;
          end;
        xctSglQuote,
        xctDblQuote:
          begin
            FCurrentToken.Kind := ptkString;
            ScanText;
          end;
        xctAsterisk:
          begin
            if FPrevTokenKind = ptkAxis then
            begin
              FCurrentToken.Kind := ptkNode;
              FCurrentToken.Value := FIterator.Current;
            end
            else
              FCurrentToken.Kind := ptkMult;
          end;
        xctXclam:
          begin
            FIterator.MoveNext;
            if FIterator.CurrentType = xctEqual then
              FCurrentToken.Kind := ptkNotEq
            else
              DoError;
          end;
        xctLower,
        xctGreater:
          begin
            B := FIterator.CurrentType = xctLower;
            FIterator.MoveNext;
            if FIterator.CurrentType = xctEqual then
              if B then
                FCurrentToken.Kind := ptkLowEq
              else
                FCurrentToken.Kind := ptkGreEq
            else begin
              FIterator.Rollback;
              if B then
                FCurrentToken.Kind := ptkLower
              else
                FCurrentToken.Kind := ptkGreater
            end;
          end;
        xctPlus: FCurrentToken.Kind := ptkPlus;
        xctMinus: FCurrentToken.Kind := ptkMinus;
        xctEqual: FCurrentToken.Kind := ptkEqual;
        xctParensLeft: FCurrentToken.Kind := ptkOpenGroup;
        xctParensRight: FCurrentToken.Kind := ptkCloseGroup;
        xctSqBracketLeft: FCurrentToken.Kind := ptkOpenPred;
        xctSqBracketRight: FCurrentToken.Kind := ptkClosePred;
        xctComma: FCurrentToken.Kind := ptkComma;
        xctChar:
          if TQICharacter.IsDecChar(FIterator.Current) then
          begin
            while TQICharacter.IsNumChar(FIterator.Current) and not FIterator.EOF do
            begin
              if not StoreCurrentChar(FIterator.CurrentType) then
                DoError;
              FIterator.MoveNext;
            end;
            FIterator.SkipBlanks;
            FCurrentToken.Kind := ptkNumber;
            FBuffer.BuildString(S);
            FCurrentToken.Value := S;
          end
          else begin         // CurrentType xctSlash
            if FPrevTokenKind = ptkEqual then
            begin
              B := True;
              while B and not TQICharacter.IsIdentChar(FIterator.Current) and not FIterator.EOF do
                B := FIterator.MoveNext;
            end;
            ScanName(S);
            if FPrevTokenKind in [ptkUnknown, ptkAxis, ptkOpenPred, ptkOpenGroup] then
            begin
              B := FIterator.MoveNext;
              if FIterator.CurrentType = xctColon then
                if FIterator.MoveNext then
                  if FIterator.CurrentType = xctColon then // axis found
                  begin
                    for I := Integer(Low(TQINodeAxis)) to Integer(High(TQINodeAxis)) do
                      if QICompareText(S, AxisStr[TQINodeAxis(I)]) = 0 then
                      begin
                        FCurrentToken.Value := I;
                        Break;
                      end;
                    if VarIsNull(FCurrentToken.Value) then
                      DoError;
                    FCurrentToken.Kind := ptkAxis;
                  end
                  else begin // namespace found
                    FIterator.Rollback;
                    FCurrentToken.Kind := ptkNamespace;
                  end
                else
                  DoError
              else if FIterator.CurrentType = xctParensLeft then // function found
              begin
                FIterator.Rollback;
                FCurrentToken.Kind := ptkFunction;
              end
              else begin // node found
                if B then
                  FIterator.Rollback;
                FCurrentToken.Kind := ptkNode;
              end;
              FCurrentToken.Value := S;
            end
            else if QICompareText(S, 'and') = 0 then
              FCurrentToken.Kind := ptkAnd
            else if QICompareText(S, 'or') = 0 then
              FCurrentToken.Kind := ptkOr
            else if QICompareText(S, 'div') = 0 then
              FCurrentToken.Kind := ptkDiv
            else if QICompareText(S, 'mod') = 0 then
              FCurrentToken.Kind := ptkMod
            else begin
              FCurrentToken.Kind := ptkNode;
              FCurrentToken.Value := S;
              if FIterator.CurrentType in [xctSqBracketLeft, xctSqBracketRight]
              then
                FIterator.Rollback;
            end;
          end;
      else
        DoError;
      end;
    end
    else
      Exit;
    FPrevTokenKind := FCurrentToken.Kind;
    Token := FCurrentToken;
    Result := True;
  except
    raise;
  end;
end;

procedure TQIXPathTokenizer.Reset;
begin
  FPrevTokenKind := ptkUnknown;
  inherited;
end;

procedure TQIXPathTokenizer.ScanName(var Name: qiString);
begin
  if not TQICharacter.IsFirstIdentChar(FIterator.Current) then
    DoError;
  while TQICharacter.IsIdentChar(FIterator.Current) and not FIterator.EOF do
  begin
    FBuffer.StoreChar(FIterator.Current);
    FIterator.MoveNext;
  end;
  FBuffer.BuildString(Name);
end;

function TQIXPathTokenizer.StoreCurrentChar(CharType: TQICharType): Boolean;
begin
  Result := CharType in [xctCR, xctLF, xctChar, xctQuery, xctSlash, xctXclam,
    xctSglQuote, xctDblQuote, xctParensLeft, xctParensRight, xctDot, xctColon,
    xctComma, xctAt, xctAsterisk, xctPlus, xctMinus, xctEqual];
  if Result then
    FBuffer.StoreChar(FIterator.Current);
end;

{ TQIXPathTokenStack }

function TQIXPathTokenStack.Add: PQIXPathToken;
begin
  if FCount = FList.Count then
    Result := PQIXPathToken(AddItem)
  else
    Result := Items[FCount];
end;

function TQIXPathTokenStack.GetItems(const Index: Integer): PQIXPathToken;
begin
  Result := PQIXPathToken(inherited Items[Index]);
end;

function TQIXPathTokenStack.NewItem: Pointer;
begin
  New(PQIXPathToken(Result));
end;

{ TQIPredicateCalc }

function TQIPredicateCalc.Calculate(Data: PQIDataNode): Variant;
begin
  Result := DoCalculate(Data);
end;

constructor TQIStringCalc.Create;
begin
  inherited;
  FValue := '';
end;

{ TQIStringCalc }

function TQIStringCalc.DoCalculate(Data: PQIDataNode): Variant;
begin
  Result := FValue;
end;

{ TQIAttributeCalc }

constructor TQIAttributeCalc.Create;
begin
  inherited;
  FName := '';
end;

function TQIAttributeCalc.CheckExistance: Boolean;
var
  Name, Value: qiString;
begin
  Result := not Assigned(Evaluator);
  if not Result then
    while Evaluator.GetNextAttribute(Name, Value, Result) do
      Result := QICompareText(FName, Name) = 0;
end;

function TQIAttributeCalc.GetValue: Variant;
var
  I: Integer;
  Name, Value: qiString;
  Stop: Boolean;
  Token: PQIXMLToken;
  Attributes: TQIXMLTokenStack;
begin
  Result := null;
  if not Assigned(Evaluator) then
    Exit;
  Name := '';
  Value := '';
  Attributes := TQIXMLTokenStack(FData.Data.Attributes);
  for I := 0 to Attributes.FCount - 1 do
  begin
    Token := Attributes.Items[I];
      Name := Token.Name;
      Value := Token.Value;

    Stop := QICompareText(FName, Name) = 0;
    if Stop then
    begin
      Result := Value;
      Break;
    end;
  end;
end;

{ TQIFunctionCalc }

constructor TQIFunctionCalc.Create;
begin
  inherited;
  FName := '';
  New(FArguments);
  SetLength(FArguments^, 0);
end;

destructor TQIFunctionCalc.Destroy;
var
  I: Integer;
begin
  for I := Low(FArguments^) to High(FArguments^) do
    PredicatePostOrderTraversal(FArguments^[I], DisposePredicate);
  Dispose(FArguments);
  inherited;
end;

function TQIFunctionCalc.CheckExistance: Boolean;
begin
  Inc(FNode.Counter);
  Result := GetValue = FNode.Counter;
end;

function TQIFunctionCalc.GetValue: Variant;
begin
  if (Length(FArguments^) > 0) and (QICompareText(FName, 'not') = 0) then
    Result := not (FArguments^[0].Result)
  else
    Result := Null;
end;

constructor TQINumericCalc.Create;
begin
  inherited;
  FValue := 0;
end;

{ TQINumericCalc }

function TQINumericCalc.CheckExistance: Boolean;
begin
  Inc(FNode.Counter);
  Result := FValue = FNode.Counter;
end;

function TQINumericCalc.GetValue: Variant;
begin
  Result := FValue;
end;

{ TQINodeCalc }

function TQINodeCalc.CheckExistance: Boolean;
begin
  Result := CheckFlags(FNode, FData);
end;

function TQINodeCalc.GetValue: Variant;
begin
  Result := FNode^.Nodetest;
end;

constructor TQIAmbiguityCalc.Create;
begin
  inherited;
  FMethod := qcmUndefined;
end;

{ TQIAmbiguityCalc }

function TQIAmbiguityCalc.DoCalculate(Data: PQIDataNode): Variant;
begin
  FData := Data;
  case FMethod of
    qcmExistance:
      Result := CheckExistance;
    qcmValue:
      Result := GetValue;
  else
    Result := Null;
  end;
end;

{ TQIXMLTagsStack }

constructor TQIXMLTagsStack.Create;
begin
  inherited;
  FStack := TqiStringList.Create;
end;

destructor TQIXMLTagsStack.Destroy;
begin
  FreeAndNil(FStack);
  inherited;
end;

procedure TQIXMLTagsStack.Pop;
begin
  if FStack.Count > 0 then
    FStack.Delete(FStack.Count - 1);
end;

procedure TQIXMLTagsStack.Push(ATag: qiString);
begin
  FStack.Add(ATag);
end;

function TQIXMLTagsStack.Top: qiString;
begin
  Result := EmptyStr;
  if FStack.Count > 0 then
    Result := FStack[FStack.Count - 1];
end;

{ TQIDirectReadParser }

procedure TQIDirectReadParser.CloseDocument;
begin
  FreeAndNil(FTokenizer);
end;

function TQIDirectReadParser.GetNextToken(var Token: PQIXMLToken): Boolean;
begin
  Result := FTokenizer.GetNextToken(Token);
end;

procedure TQIDirectReadParser.DoProcessToken(Token: PQIXMLToken);
begin
  inherited DoProcessToken(Token);
end;

procedure TQIDirectReadParser.OpenDocument(const FileName: string);
begin
  FTokenizer := TQIXMLTokenizer.Create(FileName, TQIXMLCharsetDetector.GetXMLCharset(FileName), FAttributes.FList);
  FTokenizer.KeepSpaces := FKeepSpaces;
end;

{ TQIXMLCharsetDetector }

class function TQIXMLCharsetDetector.GetXMLCharset(const FileName: string): TQICharsetType;
var
  Detector: TQIXMLCharsetDetector;
begin
  Result := ctWinDefined;
  Detector := TQIXMLCharsetDetector.Create;
  try
    Detector.Detect(FileName, Result);
  finally
    FreeAndNil(Detector);
  end;
end;

function TQIXMLCharsetDetector.Detect(const FileName: string; out Charset: TQICharsetType): Boolean;
begin
  FFileName := FileName;
  FCharset := ctWinDefined;
  Result := DetectByBOM;
  if not Result then
    Result := DetectByAttribute;
  Charset := FCharset;
end;

function TQIXMLCharsetDetector.DetectByBOM: Boolean;
var
  Stream: TStream;
  Detector: TQICharsetAutoDetector;
begin
  Stream := TFileStream.Create(FFileName, fmOpenRead {$IFDEF VCL6}, fmShareDenyWrite{$ENDIF});
  Detector := TQICharsetAutoDetector.Create;
  try
    Result := Detector.Detect(Stream, FCharset, False) and Detector.BOMDetected;
  finally
    FreeAndNil(Detector);
    FreeAndNil(Stream);
  end;
end;

function TQIXMLCharsetDetector.DetectByAttribute: Boolean;
var
  Attributes: TQIXMLAttrList;
  Tokenizer: TQIXMLTokenizer;
  Token: PQIXMLToken;
begin
  Attributes := TQIXMLAttrList.Create;
  Tokenizer := TQIXMLTokenizer.Create(FFileName, FCharset, Attributes.FList);
  try
    while Tokenizer.GetNextToken(Token) do
    begin
      case Token.Kind of
        xtkXMLDeclAttr:
        begin
          if Token.Name = 'encoding' then
          begin
            FCharset := QIAliasToCharsetType(Token.Value);
            Result := True;
            Exit;
          end;
        end;
        xtkOpenElem:
          Break;
      end;
    end;
  finally
    FreeAndNil(Tokenizer);
    FreeAndNil(Attributes);
  end;
  Result := False;
end;

end.

