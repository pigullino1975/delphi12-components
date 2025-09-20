unit QImport3MSHtmlTLB;

{$I QImport3VerCtrl.Inc}

// ************************************************************************  //
// Type Lib: mshtml.tlb (1)
// LIBID: {3050F1C5-98B5-11CF-BB82-00AA00BDCE0B}
// LCID: 0
// Helpfile:
// HelpString: Microsoft HTML Object Library
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //

{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses
{$IFDEF VCL16}
  Winapi.Windows,
  Winapi.ActiveX,
  System.Classes,
  System.Variants;
{$ELSE}
  Windows,
  ActiveX,
  Classes,
  Variants;
{$ENDIF}

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  IID_IHTMLElement: TGUID = '{3050F1FF-98B5-11CF-BB82-00AA00BDCE0B}';
  IID_IHTMLElementCollection: TGUID = '{3050F21F-98B5-11CF-BB82-00AA00BDCE0B}';
  IID_IHTMLDocument: TGUID = '{626FC520-A41E-11CF-A731-00A0C9082637}';
  IID_IHTMLDocument2: TGUID = '{332C4425-26CB-11D0-B483-00C04FD90119}';
  CLASS_HTMLDocument: TGUID = '{25336920-03F9-11CF-8FD0-00AA00686F13}';
  IID_IHTMLTable: TGUID = '{3050F21E-98B5-11CF-BB82-00AA00BDCE0B}';
  IID_IHTMLTableRow: TGUID = '{3050F23C-98B5-11CF-BB82-00AA00BDCE0B}';

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//

  IHTMLElement = interface;
  IHTMLStyle = interface;
  IHTMLFiltersCollection = interface;
  IHTMLStyleSheet = interface;
  IHTMLStyleSheetsCollection = interface;
  IHTMLElementCollection = interface;
  IHTMLFramesCollection2 = interface;
  IHTMLWindow2 = interface;
  IHTMLLocation = interface;
  IHTMLDocument = interface;
  IHTMLDocument2 = interface;
  IHTMLSelectionObject = interface;
  IHTMLTableCaption = interface;
  IHTMLTableSection = interface;
  IHTMLTable = interface;
  IHTMLTableRow = interface;

// *********************************************************************//
// Interface: IHTMLElement
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3050F1FF-98B5-11CF-BB82-00AA00BDCE0B}
// *********************************************************************//
  IHTMLElement = interface(IDispatch)
    ['{3050F1FF-98B5-11CF-BB82-00AA00BDCE0B}']
    procedure setAttribute(const strAttributeName: WideString; AttributeValue: OleVariant;
                           lFlags: Integer); safecall;
    function getAttribute(const strAttributeName: WideString; lFlags: Integer): OleVariant; safecall;
    function removeAttribute(const strAttributeName: WideString; lFlags: Integer): WordBool; safecall;
    procedure Set__className(const p: WideString); safecall;
    function Get__className: WideString; safecall;
    procedure Set_id(const p: WideString); safecall;
    function Get_id: WideString; safecall;
    function Get_tagName: WideString; safecall;
    function Get_parentElement: IHTMLElement; safecall;
    function Get_style: IHTMLStyle; safecall;
    procedure Set_onhelp(p: OleVariant); safecall;
    function Get_onhelp: OleVariant; safecall;
    procedure Set_onclick(p: OleVariant); safecall;
    function Get_onclick: OleVariant; safecall;
    procedure Set_ondblclick(p: OleVariant); safecall;
    function Get_ondblclick: OleVariant; safecall;
    procedure Set_onkeydown(p: OleVariant); safecall;
    function Get_onkeydown: OleVariant; safecall;
    procedure Set_onkeyup(p: OleVariant); safecall;
    function Get_onkeyup: OleVariant; safecall;
    procedure Set_onkeypress(p: OleVariant); safecall;
    function Get_onkeypress: OleVariant; safecall;
    procedure Set_onmouseout(p: OleVariant); safecall;
    function Get_onmouseout: OleVariant; safecall;
    procedure Set_onmouseover(p: OleVariant); safecall;
    function Get_onmouseover: OleVariant; safecall;
    procedure Set_onmousemove(p: OleVariant); safecall;
    function Get_onmousemove: OleVariant; safecall;
    procedure Set_onmousedown(p: OleVariant); safecall;
    function Get_onmousedown: OleVariant; safecall;
    procedure Set_onmouseup(p: OleVariant); safecall;
    function Get_onmouseup: OleVariant; safecall;
    function Get_document: IDispatch; safecall;
    procedure Set_title(const p: WideString); safecall;
    function Get_title: WideString; safecall;
    procedure Set_language(const p: WideString); safecall;
    function Get_language: WideString; safecall;
    procedure Set_onselectstart(p: OleVariant); safecall;
    function Get_onselectstart: OleVariant; safecall;
    procedure scrollIntoView(varargStart: OleVariant); safecall;
    function contains(const pChild: IHTMLElement): WordBool; safecall;
    function Get_sourceIndex: Integer; safecall;
    function Get_recordNumber: OleVariant; safecall;
    procedure Set_lang(const p: WideString); safecall;
    function Get_lang: WideString; safecall;
    function Get_offsetLeft: Integer; safecall;
    function Get_offsetTop: Integer; safecall;
    function Get_offsetWidth: Integer; safecall;
    function Get_offsetHeight: Integer; safecall;
    function Get_offsetParent: IHTMLElement; safecall;
    procedure Set_innerHTML(const p: WideString); safecall;
    function Get_innerHTML: WideString; safecall;
    procedure Set_innerText(const p: WideString); safecall;
    function Get_innerText: WideString; safecall;
    procedure Set_outerHTML(const p: WideString); safecall;
    function Get_outerHTML: WideString; safecall;
    procedure Set_outerText(const p: WideString); safecall;
    function Get_outerText: WideString; safecall;
    procedure insertAdjacentHTML(const where: WideString; const html: WideString); safecall;
    procedure insertAdjacentText(const where: WideString; const text: WideString); safecall;
    function Get_parentTextEdit: IHTMLElement; safecall;
    function Get_isTextEdit: WordBool; safecall;
    procedure click; safecall;
    function Get_filters: IHTMLFiltersCollection; safecall;
    procedure Set_ondragstart(p: OleVariant); safecall;
    function Get_ondragstart: OleVariant; safecall;
    function toString: WideString; safecall;
    procedure Set_onbeforeupdate(p: OleVariant); safecall;
    function Get_onbeforeupdate: OleVariant; safecall;
    procedure Set_onafterupdate(p: OleVariant); safecall;
    function Get_onafterupdate: OleVariant; safecall;
    procedure Set_onerrorupdate(p: OleVariant); safecall;
    function Get_onerrorupdate: OleVariant; safecall;
    procedure Set_onrowexit(p: OleVariant); safecall;
    function Get_onrowexit: OleVariant; safecall;
    procedure Set_onrowenter(p: OleVariant); safecall;
    function Get_onrowenter: OleVariant; safecall;
    procedure Set_ondatasetchanged(p: OleVariant); safecall;
    function Get_ondatasetchanged: OleVariant; safecall;
    procedure Set_ondataavailable(p: OleVariant); safecall;
    function Get_ondataavailable: OleVariant; safecall;
    procedure Set_ondatasetcomplete(p: OleVariant); safecall;
    function Get_ondatasetcomplete: OleVariant; safecall;
    procedure Set_onfilterchange(p: OleVariant); safecall;
    function Get_onfilterchange: OleVariant; safecall;
    function Get_children: IDispatch; safecall;
    function Get_all: IDispatch; safecall;
    property _className: WideString read Get__className write Set__className;
    property id: WideString read Get_id write Set_id;
    property tagName: WideString read Get_tagName;
    property parentElement: IHTMLElement read Get_parentElement;
    property style: IHTMLStyle read Get_style;
    property onhelp: OleVariant read Get_onhelp write Set_onhelp;
    property onclick: OleVariant read Get_onclick write Set_onclick;
    property ondblclick: OleVariant read Get_ondblclick write Set_ondblclick;
    property onkeydown: OleVariant read Get_onkeydown write Set_onkeydown;
    property onkeyup: OleVariant read Get_onkeyup write Set_onkeyup;
    property onkeypress: OleVariant read Get_onkeypress write Set_onkeypress;
    property onmouseout: OleVariant read Get_onmouseout write Set_onmouseout;
    property onmouseover: OleVariant read Get_onmouseover write Set_onmouseover;
    property onmousemove: OleVariant read Get_onmousemove write Set_onmousemove;
    property onmousedown: OleVariant read Get_onmousedown write Set_onmousedown;
    property onmouseup: OleVariant read Get_onmouseup write Set_onmouseup;
    property document: IDispatch read Get_document;
    property title: WideString read Get_title write Set_title;
    property language: WideString read Get_language write Set_language;
    property onselectstart: OleVariant read Get_onselectstart write Set_onselectstart;
    property sourceIndex: Integer read Get_sourceIndex;
    property recordNumber: OleVariant read Get_recordNumber;
    property lang: WideString read Get_lang write Set_lang;
    property offsetLeft: Integer read Get_offsetLeft;
    property offsetTop: Integer read Get_offsetTop;
    property offsetWidth: Integer read Get_offsetWidth;
    property offsetHeight: Integer read Get_offsetHeight;
    property offsetParent: IHTMLElement read Get_offsetParent;
    property innerHTML: WideString read Get_innerHTML write Set_innerHTML;
    property innerText: WideString read Get_innerText write Set_innerText;
    property outerHTML: WideString read Get_outerHTML write Set_outerHTML;
    property outerText: WideString read Get_outerText write Set_outerText;
    property parentTextEdit: IHTMLElement read Get_parentTextEdit;
    property isTextEdit: WordBool read Get_isTextEdit;
    property filters: IHTMLFiltersCollection read Get_filters;
    property ondragstart: OleVariant read Get_ondragstart write Set_ondragstart;
    property onbeforeupdate: OleVariant read Get_onbeforeupdate write Set_onbeforeupdate;
    property onafterupdate: OleVariant read Get_onafterupdate write Set_onafterupdate;
    property onerrorupdate: OleVariant read Get_onerrorupdate write Set_onerrorupdate;
    property onrowexit: OleVariant read Get_onrowexit write Set_onrowexit;
    property onrowenter: OleVariant read Get_onrowenter write Set_onrowenter;
    property ondatasetchanged: OleVariant read Get_ondatasetchanged write Set_ondatasetchanged;
    property ondataavailable: OleVariant read Get_ondataavailable write Set_ondataavailable;
    property ondatasetcomplete: OleVariant read Get_ondatasetcomplete write Set_ondatasetcomplete;
    property onfilterchange: OleVariant read Get_onfilterchange write Set_onfilterchange;
    property children: IDispatch read Get_children;
    property all: IDispatch read Get_all;
  end;

// *********************************************************************//
// Interface: IHTMLStyle
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3050F25E-98B5-11CF-BB82-00AA00BDCE0B}
// *********************************************************************//
  IHTMLStyle = interface(IDispatch)

  end;

// *********************************************************************//
// Interface: IHTMLFiltersCollection
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3050F3EE-98B5-11CF-BB82-00AA00BDCE0B}
// *********************************************************************//
  IHTMLFiltersCollection = interface(IDispatch)

  end;

// *********************************************************************//
// Interface: IHTMLStyleSheet
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3050F2E3-98B5-11CF-BB82-00AA00BDCE0B}
// *********************************************************************//
  IHTMLStyleSheet = interface(IDispatch)

  end;

// *********************************************************************//
// Interface: IHTMLStyleSheetsCollection
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3050F37E-98B5-11CF-BB82-00AA00BDCE0B}
// *********************************************************************//
  IHTMLStyleSheetsCollection = interface(IDispatch)

  end;

// *********************************************************************//
// Interface: IHTMLElementCollection
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3050F21F-98B5-11CF-BB82-00AA00BDCE0B}
// *********************************************************************//
  IHTMLElementCollection = interface(IDispatch)
    ['{3050F21F-98B5-11CF-BB82-00AA00BDCE0B}']
    function toString: WideString; safecall;
    procedure Set_length(p: Integer); safecall;
    function Get_length: Integer; safecall;
    function Get__newEnum: IUnknown; safecall;
    function item(name: OleVariant; index: OleVariant): IDispatch; safecall;
    function tags(tagName: OleVariant): IDispatch; safecall;
    property length: Integer read Get_length write Set_length;
    property _newEnum: IUnknown read Get__newEnum;
  end;

// *********************************************************************//
// Interface: IHTMLFramesCollection2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {332C4426-26CB-11D0-B483-00C04FD90119}
// *********************************************************************//
  IHTMLFramesCollection2 = interface(IDispatch)

  end;

// *********************************************************************//
// Interface: IHTMLWindow2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {332C4427-26CB-11D0-B483-00C04FD90119}
// *********************************************************************//
  IHTMLWindow2 = interface(IHTMLFramesCollection2)

  end;

// *********************************************************************//
// Interface: IHTMLLocation
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {163BB1E0-6E00-11CF-837A-48DC04C10000}
// *********************************************************************//
  IHTMLLocation = interface(IDispatch)

  end;

// *********************************************************************//
// Interface: IHTMLDocument
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {626FC520-A41E-11CF-A731-00A0C9082637}
// *********************************************************************//
  IHTMLDocument = interface(IDispatch)
    ['{626FC520-A41E-11CF-A731-00A0C9082637}']
    function Get_Script: IDispatch; safecall;
    property Script: IDispatch read Get_Script;
  end;

// *********************************************************************//
// Interface: IHTMLDocument2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {332C4425-26CB-11D0-B483-00C04FD90119}
// *********************************************************************//
  IHTMLDocument2 = interface(IHTMLDocument)
    ['{332C4425-26CB-11D0-B483-00C04FD90119}']
    function Get_all: IHTMLElementCollection; safecall;
    function Get_body: IHTMLElement; safecall;
    function Get_activeElement: IHTMLElement; safecall;
    function Get_images: IHTMLElementCollection; safecall;
    function Get_applets: IHTMLElementCollection; safecall;
    function Get_links: IHTMLElementCollection; safecall;
    function Get_forms: IHTMLElementCollection; safecall;
    function Get_anchors: IHTMLElementCollection; safecall;
    procedure Set_title(const p: WideString); safecall;
    function Get_title: WideString; safecall;
    function Get_scripts: IHTMLElementCollection; safecall;
    procedure Set_designMode(const p: WideString); safecall;
    function Get_designMode: WideString; safecall;
    function Get_selection: IHTMLSelectionObject; safecall;
    function Get_readyState: WideString; safecall;
    function Get_frames: IHTMLFramesCollection2; safecall;
    function Get_embeds: IHTMLElementCollection; safecall;
    function Get_plugins: IHTMLElementCollection; safecall;
    procedure Set_alinkColor(p: OleVariant); safecall;
    function Get_alinkColor: OleVariant; safecall;
    procedure Set_bgColor(p: OleVariant); safecall;
    function Get_bgColor: OleVariant; safecall;
    procedure Set_fgColor(p: OleVariant); safecall;
    function Get_fgColor: OleVariant; safecall;
    procedure Set_linkColor(p: OleVariant); safecall;
    function Get_linkColor: OleVariant; safecall;
    procedure Set_vlinkColor(p: OleVariant); safecall;
    function Get_vlinkColor: OleVariant; safecall;
    function Get_referrer: WideString; safecall;
    function Get_location: IHTMLLocation; safecall;
    function Get_lastModified: WideString; safecall;
    procedure Set_url(const p: WideString); safecall;
    function Get_url: WideString; safecall;
    procedure Set_domain(const p: WideString); safecall;
    function Get_domain: WideString; safecall;
    procedure Set_cookie(const p: WideString); safecall;
    function Get_cookie: WideString; safecall;
    procedure Set_expando(p: WordBool); safecall;
    function Get_expando: WordBool; safecall;
    procedure Set_charset(const p: WideString); safecall;
    function Get_charset: WideString; safecall;
    procedure Set_defaultCharset(const p: WideString); safecall;
    function Get_defaultCharset: WideString; safecall;
    function Get_mimeType: WideString; safecall;
    function Get_fileSize: WideString; safecall;
    function Get_fileCreatedDate: WideString; safecall;
    function Get_fileModifiedDate: WideString; safecall;
    function Get_fileUpdatedDate: WideString; safecall;
    function Get_security: WideString; safecall;
    function Get_protocol: WideString; safecall;
    function Get_nameProp: WideString; safecall;
    procedure write(psarray: PSafeArray); safecall;
    procedure writeln(psarray: PSafeArray); safecall;
    function open(const url: WideString; name: OleVariant; features: OleVariant; replace: OleVariant): IDispatch; safecall;
    procedure close; safecall;
    procedure clear; safecall;
    function queryCommandSupported(const cmdID: WideString): WordBool; safecall;
    function queryCommandEnabled(const cmdID: WideString): WordBool; safecall;
    function queryCommandState(const cmdID: WideString): WordBool; safecall;
    function queryCommandIndeterm(const cmdID: WideString): WordBool; safecall;
    function queryCommandText(const cmdID: WideString): WideString; safecall;
    function queryCommandValue(const cmdID: WideString): OleVariant; safecall;
    function execCommand(const cmdID: WideString; showUI: WordBool; value: OleVariant): WordBool; safecall;
    function execCommandShowHelp(const cmdID: WideString): WordBool; safecall;
    function createElement(const eTag: WideString): IHTMLElement; safecall;
    procedure Set_onhelp(p: OleVariant); safecall;
    function Get_onhelp: OleVariant; safecall;
    procedure Set_onclick(p: OleVariant); safecall;
    function Get_onclick: OleVariant; safecall;
    procedure Set_ondblclick(p: OleVariant); safecall;
    function Get_ondblclick: OleVariant; safecall;
    procedure Set_onkeyup(p: OleVariant); safecall;
    function Get_onkeyup: OleVariant; safecall;
    procedure Set_onkeydown(p: OleVariant); safecall;
    function Get_onkeydown: OleVariant; safecall;
    procedure Set_onkeypress(p: OleVariant); safecall;
    function Get_onkeypress: OleVariant; safecall;
    procedure Set_onmouseup(p: OleVariant); safecall;
    function Get_onmouseup: OleVariant; safecall;
    procedure Set_onmousedown(p: OleVariant); safecall;
    function Get_onmousedown: OleVariant; safecall;
    procedure Set_onmousemove(p: OleVariant); safecall;
    function Get_onmousemove: OleVariant; safecall;
    procedure Set_onmouseout(p: OleVariant); safecall;
    function Get_onmouseout: OleVariant; safecall;
    procedure Set_onmouseover(p: OleVariant); safecall;
    function Get_onmouseover: OleVariant; safecall;
    procedure Set_onreadystatechange(p: OleVariant); safecall;
    function Get_onreadystatechange: OleVariant; safecall;
    procedure Set_onafterupdate(p: OleVariant); safecall;
    function Get_onafterupdate: OleVariant; safecall;
    procedure Set_onrowexit(p: OleVariant); safecall;
    function Get_onrowexit: OleVariant; safecall;
    procedure Set_onrowenter(p: OleVariant); safecall;
    function Get_onrowenter: OleVariant; safecall;
    procedure Set_ondragstart(p: OleVariant); safecall;
    function Get_ondragstart: OleVariant; safecall;
    procedure Set_onselectstart(p: OleVariant); safecall;
    function Get_onselectstart: OleVariant; safecall;
    function elementFromPoint(x: Integer; y: Integer): IHTMLElement; safecall;
    function Get_parentWindow: IHTMLWindow2; safecall;
    function Get_styleSheets: IHTMLStyleSheetsCollection; safecall;
    procedure Set_onbeforeupdate(p: OleVariant); safecall;
    function Get_onbeforeupdate: OleVariant; safecall;
    procedure Set_onerrorupdate(p: OleVariant); safecall;
    function Get_onerrorupdate: OleVariant; safecall;
    function toString: WideString; safecall;
    function createStyleSheet(const bstrHref: WideString; lIndex: Integer): IHTMLStyleSheet; safecall;
    property all: IHTMLElementCollection read Get_all;
    property body: IHTMLElement read Get_body;
    property activeElement: IHTMLElement read Get_activeElement;
    property images: IHTMLElementCollection read Get_images;
    property applets: IHTMLElementCollection read Get_applets;
    property links: IHTMLElementCollection read Get_links;
    property forms: IHTMLElementCollection read Get_forms;
    property anchors: IHTMLElementCollection read Get_anchors;
    property title: WideString read Get_title write Set_title;
    property scripts: IHTMLElementCollection read Get_scripts;
    property designMode: WideString read Get_designMode write Set_designMode;
    property selection: IHTMLSelectionObject read Get_selection;
    property readyState: WideString read Get_readyState;
    property frames: IHTMLFramesCollection2 read Get_frames;
    property embeds: IHTMLElementCollection read Get_embeds;
    property plugins: IHTMLElementCollection read Get_plugins;
    property alinkColor: OleVariant read Get_alinkColor write Set_alinkColor;
    property bgColor: OleVariant read Get_bgColor write Set_bgColor;
    property fgColor: OleVariant read Get_fgColor write Set_fgColor;
    property linkColor: OleVariant read Get_linkColor write Set_linkColor;
    property vlinkColor: OleVariant read Get_vlinkColor write Set_vlinkColor;
    property referrer: WideString read Get_referrer;
    property location: IHTMLLocation read Get_location;
    property lastModified: WideString read Get_lastModified;
    property url: WideString read Get_url write Set_url;
    property domain: WideString read Get_domain write Set_domain;
    property cookie: WideString read Get_cookie write Set_cookie;
    property expando: WordBool read Get_expando write Set_expando;
    property charset: WideString read Get_charset write Set_charset;
    property defaultCharset: WideString read Get_defaultCharset write Set_defaultCharset;
    property mimeType: WideString read Get_mimeType;
    property fileSize: WideString read Get_fileSize;
    property fileCreatedDate: WideString read Get_fileCreatedDate;
    property fileModifiedDate: WideString read Get_fileModifiedDate;
    property fileUpdatedDate: WideString read Get_fileUpdatedDate;
    property security: WideString read Get_security;
    property protocol: WideString read Get_protocol;
    property nameProp: WideString read Get_nameProp;
    property onhelp: OleVariant read Get_onhelp write Set_onhelp;
    property onclick: OleVariant read Get_onclick write Set_onclick;
    property ondblclick: OleVariant read Get_ondblclick write Set_ondblclick;
    property onkeyup: OleVariant read Get_onkeyup write Set_onkeyup;
    property onkeydown: OleVariant read Get_onkeydown write Set_onkeydown;
    property onkeypress: OleVariant read Get_onkeypress write Set_onkeypress;
    property onmouseup: OleVariant read Get_onmouseup write Set_onmouseup;
    property onmousedown: OleVariant read Get_onmousedown write Set_onmousedown;
    property onmousemove: OleVariant read Get_onmousemove write Set_onmousemove;
    property onmouseout: OleVariant read Get_onmouseout write Set_onmouseout;
    property onmouseover: OleVariant read Get_onmouseover write Set_onmouseover;
    property onreadystatechange: OleVariant read Get_onreadystatechange write Set_onreadystatechange;
    property onafterupdate: OleVariant read Get_onafterupdate write Set_onafterupdate;
    property onrowexit: OleVariant read Get_onrowexit write Set_onrowexit;
    property onrowenter: OleVariant read Get_onrowenter write Set_onrowenter;
    property ondragstart: OleVariant read Get_ondragstart write Set_ondragstart;
    property onselectstart: OleVariant read Get_onselectstart write Set_onselectstart;
    property parentWindow: IHTMLWindow2 read Get_parentWindow;
    property styleSheets: IHTMLStyleSheetsCollection read Get_styleSheets;
    property onbeforeupdate: OleVariant read Get_onbeforeupdate write Set_onbeforeupdate;
    property onerrorupdate: OleVariant read Get_onerrorupdate write Set_onerrorupdate;
  end;

// *********************************************************************//
// Interface: IHTMLSelectionObject
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3050F25A-98B5-11CF-BB82-00AA00BDCE0B}
// *********************************************************************//
  IHTMLSelectionObject = interface(IDispatch)

  end;

// *********************************************************************//
// Interface: IHTMLTableCaption
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3050F2EB-98B5-11CF-BB82-00AA00BDCE0B}
// *********************************************************************//
  IHTMLTableCaption = interface(IDispatch)

  end;

// *********************************************************************//
// Interface: IHTMLTableSection
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3050F23B-98B5-11CF-BB82-00AA00BDCE0B}
// *********************************************************************//
  IHTMLTableSection = interface(IDispatch)

  end;

// *********************************************************************//
// Interface: IHTMLTable
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3050F21E-98B5-11CF-BB82-00AA00BDCE0B}
// *********************************************************************//
  IHTMLTable = interface(IDispatch)
    ['{3050F21E-98B5-11CF-BB82-00AA00BDCE0B}']
    procedure Set_cols(p: Integer); safecall;
    function Get_cols: Integer; safecall;
    procedure Set_border(p: OleVariant); safecall;
    function Get_border: OleVariant; safecall;
    procedure Set_frame(const p: WideString); safecall;
    function Get_frame: WideString; safecall;
    procedure Set_rules(const p: WideString); safecall;
    function Get_rules: WideString; safecall;
    procedure Set_cellSpacing(p: OleVariant); safecall;
    function Get_cellSpacing: OleVariant; safecall;
    procedure Set_cellPadding(p: OleVariant); safecall;
    function Get_cellPadding: OleVariant; safecall;
    procedure Set_background(const p: WideString); safecall;
    function Get_background: WideString; safecall;
    procedure Set_bgColor(p: OleVariant); safecall;
    function Get_bgColor: OleVariant; safecall;
    procedure Set_borderColor(p: OleVariant); safecall;
    function Get_borderColor: OleVariant; safecall;
    procedure Set_borderColorLight(p: OleVariant); safecall;
    function Get_borderColorLight: OleVariant; safecall;
    procedure Set_borderColorDark(p: OleVariant); safecall;
    function Get_borderColorDark: OleVariant; safecall;
    procedure Set_align(const p: WideString); safecall;
    function Get_align: WideString; safecall;
    procedure refresh; safecall;
    function Get_rows: IHTMLElementCollection; safecall;
    procedure Set_width(p: OleVariant); safecall;
    function Get_width: OleVariant; safecall;
    procedure Set_height(p: OleVariant); safecall;
    function Get_height: OleVariant; safecall;
    procedure Set_dataPageSize(p: Integer); safecall;
    function Get_dataPageSize: Integer; safecall;
    procedure nextPage; safecall;
    procedure previousPage; safecall;
    function Get_tHead: IHTMLTableSection; safecall;
    function Get_tFoot: IHTMLTableSection; safecall;
    function Get_tBodies: IHTMLElementCollection; safecall;
    function Get_caption: IHTMLTableCaption; safecall;
    function createTHead: IDispatch; safecall;
    procedure deleteTHead; safecall;
    function createTFoot: IDispatch; safecall;
    procedure deleteTFoot; safecall;
    function createCaption: IHTMLTableCaption; safecall;
    procedure deleteCaption; safecall;
    function insertRow(index: Integer): IDispatch; safecall;
    procedure deleteRow(index: Integer); safecall;
    function Get_readyState: WideString; safecall;
    procedure Set_onreadystatechange(p: OleVariant); safecall;
    function Get_onreadystatechange: OleVariant; safecall;
    property cols: Integer read Get_cols write Set_cols;
    property border: OleVariant read Get_border write Set_border;
    property frame: WideString read Get_frame write Set_frame;
    property rules: WideString read Get_rules write Set_rules;
    property cellSpacing: OleVariant read Get_cellSpacing write Set_cellSpacing;
    property cellPadding: OleVariant read Get_cellPadding write Set_cellPadding;
    property background: WideString read Get_background write Set_background;
    property bgColor: OleVariant read Get_bgColor write Set_bgColor;
    property borderColor: OleVariant read Get_borderColor write Set_borderColor;
    property borderColorLight: OleVariant read Get_borderColorLight write Set_borderColorLight;
    property borderColorDark: OleVariant read Get_borderColorDark write Set_borderColorDark;
    property align: WideString read Get_align write Set_align;
    property rows: IHTMLElementCollection read Get_rows;
    property width: OleVariant read Get_width write Set_width;
    property height: OleVariant read Get_height write Set_height;
    property dataPageSize: Integer read Get_dataPageSize write Set_dataPageSize;
    property tHead: IHTMLTableSection read Get_tHead;
    property tFoot: IHTMLTableSection read Get_tFoot;
    property tBodies: IHTMLElementCollection read Get_tBodies;
    property caption: IHTMLTableCaption read Get_caption;
    property readyState: WideString read Get_readyState;
    property onreadystatechange: OleVariant read Get_onreadystatechange write Set_onreadystatechange;
  end;

// *********************************************************************//
// Interface: IHTMLTableRow
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3050F23C-98B5-11CF-BB82-00AA00BDCE0B}
// *********************************************************************//
  IHTMLTableRow = interface(IDispatch)
    ['{3050F23C-98B5-11CF-BB82-00AA00BDCE0B}']
    procedure Set_align(const p: WideString); safecall;
    function Get_align: WideString; safecall;
    procedure Set_vAlign(const p: WideString); safecall;
    function Get_vAlign: WideString; safecall;
    procedure Set_bgColor(p: OleVariant); safecall;
    function Get_bgColor: OleVariant; safecall;
    procedure Set_borderColor(p: OleVariant); safecall;
    function Get_borderColor: OleVariant; safecall;
    procedure Set_borderColorLight(p: OleVariant); safecall;
    function Get_borderColorLight: OleVariant; safecall;
    procedure Set_borderColorDark(p: OleVariant); safecall;
    function Get_borderColorDark: OleVariant; safecall;
    function Get_rowIndex: Integer; safecall;
    function Get_sectionRowIndex: Integer; safecall;
    function Get_cells: IHTMLElementCollection; safecall;
    function insertCell(index: Integer): IDispatch; safecall;
    procedure deleteCell(index: Integer); safecall;
    property align: WideString read Get_align write Set_align;
    property vAlign: WideString read Get_vAlign write Set_vAlign;
    property bgColor: OleVariant read Get_bgColor write Set_bgColor;
    property borderColor: OleVariant read Get_borderColor write Set_borderColor;
    property borderColorLight: OleVariant read Get_borderColorLight write Set_borderColorLight;
    property borderColorDark: OleVariant read Get_borderColorDark write Set_borderColorDark;
    property rowIndex: Integer read Get_rowIndex;
    property sectionRowIndex: Integer read Get_sectionRowIndex;
    property cells: IHTMLElementCollection read Get_cells;
  end;

implementation

end.
