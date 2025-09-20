{***************************************************************************}
{ TAdvMemo styler component                                                 }
{ for Delphi & C++Builder                                                   }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2002 - 2023                                        }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of TMS software.                                    }
{***************************************************************************}

{$I TMSDEFS.INC}

unit AdvmWS;

interface

uses
  Classes, AdvMemo, Graphics;

const
  AllDelimiters = #32',;:.()[]=-*/^%<>#';//All the symbols
  //Next constants (keywords) is defined as comma delimmited
  
  AllHTMLKeyWordsDefaults = '"HEAD","META","BODY","HTML","TITLE","COMMENT"';

  AllHTMLKeyWordsStandard = '"A","B","I","U","P","BASE","BODY","BLINK","LINK","FONT","STRONG","IMG",' +
    '"BASEFONT","BGSOUND","DD","DEL","DFN","DIR","DIV","SPAN","DL","DT","COL",' +
    '"BR","HR","HTML","HEAD","COLGROUP","TABLE","MULTICOL","TBODY","TD","TEXTAREA",' +
    '"TFOOT","TH","THEAD","TR","TT","CAPTION","CENTER","CITE","CODE",' +
    '"BLOCKQUOTE","FORM","FRAME","IFRAME","ILAYER","FRAMESET","BUTTON",' +
    '"LABEL","LAYER","OPTION","ARTICLE","ASIDE","SECTION","NAV","FIELDSET","PRE"';

  AllJSKeyWords = '"SCRIPT","OBJECT","FOR","IF","THEN","THIS","DO",' +
    '"WHILE","BREAK","{","}","(",")","SWITCH","ELSE",' +
    '"FUNCTION","WINDOW","DOCUMENT",";","RETURN","STYLE","VAR","WINDOW","LOCATION"';

  AllJSFunctions = '"alert","confirm","prompt","indexOf","select","write","focus"';

type
  {$IFDEF DELPHIXE2_LVL}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF}
  TAdvHTMLMemoStyler = class(TAdvCustomMemoStyler)
  private
    FVersion: string;
    FAutoFormat: boolean;
  protected
    function HasFormatting: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;

    function Format(s: string): string; override;
  published
    property AutoFormat: boolean read FAutoFormat write FAutoFormat default true;
    property LineComment;
    property MultiCommentLeft;
    property MultiCommentRight;
    property CommentStyle;
    property NumberStyle;
    property HighlightStyle;
    property AllStyles;

    property Version: string read FVersion;
    property Description;
    property Filter;
    property DefaultExtension;
    property StylerName;
    property Extensions;
    property RegionDefinitions;
  end;

  {$IFDEF DELPHIXE2_LVL}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF}
  TAdvJSMemoStyler = class(TAdvCustomMemoStyler)
  private
    FVersion: string;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property AutoBlockEnd;
    property BlockStart;
    property BlockEnd;
    property EscapeChar;
    property LineComment;
    property MultiCommentLeft;
    property MultiCommentRight;
    property CommentStyle;
    property NumberStyle;
    property HighlightStyle;
    property AllStyles;

    property Version: string read FVersion;
    property Description;
    property Filter;
    property DefaultExtension;
    property StylerName;
    property Extensions;
  end;

  {$IFDEF DELPHIXE2_LVL}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF}
  TAdvWebMemoStyler = class(TAdvCustomMemoStyler)
  private
    FVersion: string;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property LineComment;
    property MultiCommentLeft;
    property MultiCommentRight;
    property CommentStyle;
    property NumberStyle;
    property HighlightStyle;
    property AllStyles;

    property Version: string read FVersion;
    property Description;
    property Filter;
    property DefaultExtension;
    property StylerName;
    property Extensions;
    property RegionDefinitions;
  end;

implementation

uses
  SysUtils;

constructor TAdvWebMemoStyler.Create(AOwner: TComponent);
var
  itm: TElementStyle;
begin
  inherited;
  FVersion := '3.0';
  Description := 'Web pages';
  Filter := 'HTML Document (*.htm,*.html)|*.htm;*.html';
  DefaultExtension := '.html';
  StylerName := 'HTML document';
  Extensions := 'html;htm';

  LineComment := '//';
  MultiCommentLeft := '<!--';
  MultiCommentRight := '-->';
  CommentStyle.TextColor := clSilver;
  CommentStyle.BkColor := clNone;
  CommentStyle.Style := [fsItalic];
  NumberStyle.TextColor := clNavy;
  NumberStyle.BkColor := clNone;
  NumberStyle.Style := [fsBold];
  BlockStart := '{';
  BlockEnd := '}';
  //---------Script Standard Default--------------
  itm := AllStyles.Add;
  itm.Info := 'Script Standard Default';
  itm.Font.Color := clFuchsia;
  itm.Font.Style := [fsBold];
  itm.KeyWords.CommaText := AllJSKeyWords;
  //---------HTML Standard Default--------------
  itm := AllStyles.Add;
  itm.Info := 'HTML Standard Default';
  itm.Font.Color := clFuchsia;
  itm.Font.Style := [fsBold];
  itm.KeyWords.CommaText := AllHTMLKeyWordsStandard;
  //----------Single Quote ' ' ----------------
  itm := AllStyles.Add;
  itm.StyleType := stBracket;
  itm.Info := 'Single Quote';
  itm.Font.Color := clGreen;
  itm.Font.Style := [];
  itm.BracketStart := #39;
  itm.BracketEnd := #39;
  //------------Double Quote " "----------------
  itm := AllStyles.Add;
  itm.StyleType := stBracket;
  itm.Info := 'Double Quote';
  itm.Font.Color := clTeal;
  itm.Font.Style := [];
  itm.BracketStart := '"';
  itm.BracketEnd := '"';
  //----------SYMBOL --------------
  itm := AllStyles.Add;
  itm.StyleType := stSymbol;
  itm.Info := 'Symbols Delimiters';
  itm.Font.Color := clTeal;
  itm.Font.Style := [];
  itm.Symbols := AllDelimiters + #13 + #10;
  //----------Javascript functions --------------
  itm := AllStyles.Add;
  itm.Info := 'JavaScript Functions';
  itm.Font.Color := clGreen;
  itm.Font.Style := [fsBold];
  itm.KeyWords.CommaText := AllJSFunctions;

  with HintParameter.Parameters do
  begin
    Add('alert(message)');
    Add('confirm(message)');
    Add('prompt(message,defaultvalue)');
  end;

  with AutoCompletion do
  begin
    Add('alert');
    Add('confirm');
    Add('prompt');
  end;

  with RegionDefinitions.Add do
  begin
    Identifier := '<BODY>';
    RegionStart := '<BODY>';
    RegionEnd := '</BODY>';
    RegionType := rtClosed;
  end;

  with RegionDefinitions.Add do
  begin
    Identifier := '<HEAD>';
    RegionStart := '<HEAD>';
    RegionEnd := '</HEAD>';
    RegionType := rtClosed;
  end;

  with RegionDefinitions.Add do
  begin
    Identifier := '<HTML>';
    RegionStart := '<HTML>';
    RegionEnd := '</HTML>';
    RegionType := rtClosed;
  end;

  with RegionDefinitions.Add do
  begin
    Identifier := '<SCRIPT>';
    RegionStart := '<SCRIPT>';
    RegionEnd := '</SCRIPT>';
    RegionType := rtClosed;
  end;

  with RegionDefinitions.Add do
  begin
    Identifier := '<STYLE>';
    RegionStart := '<STYLE>';
    RegionEnd := '</STYLE>';
    RegionType := rtClosed;
  end;

  with RegionDefinitions.Add do
  begin
    Identifier := '<FORM>';
    RegionStart := '<FORM>';
    RegionEnd := '</FORM>';
    RegionType := rtClosed;
  end;

  with RegionDefinitions.Add do
  begin
    Identifier := '<DIV>';
    RegionStart := '<DIV>';
    RegionEnd := '</DIV>';
    RegionType := rtClosed;
  end;

  with RegionDefinitions.Add do
  begin
    Identifier := '<ARTICLE>';
    RegionStart := '<ARTICLE>';
    RegionEnd := '</ARTICLE>';
    RegionType := rtClosed;
  end;

  with RegionDefinitions.Add do
  begin
    Identifier := '<ASIDE>';
    RegionStart := '<ASIDE>';
    RegionEnd := '</ASIDE>';
    RegionType := rtClosed;
  end;

  with RegionDefinitions.Add do
  begin
    Identifier := '<FIELDSET>';
    RegionStart := '<FIELDSET>';
    RegionEnd := '</FIELDSET>';
    RegionType := rtClosed;
  end;

  with RegionDefinitions.Add do
  begin
    Identifier := '<TABLE>';
    RegionStart := '<TABLE>';
    RegionEnd := '</TABLE>';
    RegionType := rtClosed;
  end;

  with RegionDefinitions.Add do
  begin
    Identifier := '<SECTION>';
    RegionStart := '<SECTION>';
    RegionEnd := '</SECTION>';
    RegionType := rtClosed;
  end;
end;


{ TAdvHTMLMemoStyler }

constructor TAdvHTMLMemoStyler.Create(AOwner: TComponent);
var
  itm: TElementStyle;
begin
  inherited;
  FVersion := '3.0';
  Description := 'Web pages';
  Filter := 'HTML Document (*.htm,*.html)|*.htm;*.html';
  DefaultExtension := '.html';
  StylerName := 'HTML document';
  Extensions := 'htm;html';

  KeyWordPrefix := '<';
  LineComment := '//';
  MultiCommentLeft := '<!--';
  MultiCommentRight := '-->';
  CommentStyle.TextColor := clSilver;
  CommentStyle.BkColor := clNone;
  CommentStyle.Style := [fsItalic];
  NumberStyle.TextColor := clBlack;
  NumberStyle.BkColor := clNone;
  NumberStyle.Style := [];
  //------------HTML Standard Default ------------------
  itm := AllStyles.Add;
  itm.BGColor := clNone;
  itm.StyleType := stKeyword;
  itm.Info := 'HTML Standard Default';
  itm.Font.Color := clNavy;
  itm.Font.Style := [];
  with itm.KeyWords do
  begin
    Add('&lt');
    Add('ABREV');
    Add('ACRONYM');
    Add('ADDRESS');
    Add('APPLET');
    Add('AREA');
    Add('AU');
    Add('AUTHOR');
    Add('B');
    Add('BANNER');
    Add('BASE');
    Add('BASEFONT');
    Add('BGSOUND');
    Add('BIG');
    Add('BLINK');
    Add('BLOCKQUOTE');
    Add('BODY');
    Add('BQ');
    Add('BR');
    Add('CAPTION');
    Add('CENTER');
    Add('CITE');
    Add('CODE');
    Add('COL');
    Add('COLGROUP');
    Add('COMMENT');
    Add('CREDIT');
    Add('DEL');
    Add('DFN');
    Add('DIR');
    Add('DIV');
    Add('DL');
    Add('DT');
    Add('DD');
    Add('EM');
    Add('EMBED');
    Add('FIG');
    Add('FN');
    Add('FONT');
    Add('FORM');
    Add('FRAME');
    Add('FRAMESET');
    Add('HEAD');
    Add('H1');
    Add('H2');
    Add('H3');
    Add('H4');
    Add('H5');
    Add('H6');
    Add('HR');
    Add('HTML');
    Add('I');
    Add('IFRAME');
    Add('IMG');
    Add('INPUT');
    Add('INS');
    Add('ISINDEX');
    Add('KBD');
    Add('LANG');
    Add('LH');
    Add('LI');
    Add('LINK');
    Add('LISTING');
    Add('MAP');
    Add('MARQUEE');
    Add('MATH');
    Add('MENU');
    Add('META');
    Add('MULTICOL');
    Add('NOBR');
    Add('NOFRAMES');
    Add('NOTE');
    Add('OL');
    Add('OVERLAY');
    Add('P');
    Add('PARAM');
    Add('PERSON');
    Add('PLAINTEXT');
    Add('PRE');
    Add('Q');
    Add('RANGE');
    Add('SAMP');
    Add('SCRIPT');
    Add('SELECT');
    Add('SMALL');
    Add('SPACER');
    Add('SPOT');
    Add('STRIKE');
    Add('STRONG');
    Add('SUB');
    Add('SUP');
    Add('TAB');
    Add('TBODY');
    Add('TEXTAREA');
    Add('TEXTFLOW');
    Add('TFOOT');
    Add('TH');
    Add('THEAD');
    Add('TITLE');
    Add('TT');
    Add('U');
    Add('UL');
    Add('VAR');
    Add('WBR');
    Add('XMP');
    Add('DOCTYPE');
    Add('PUBLIC');
  end;
  //---------HTML Table Keywords--------------
  itm := AllStyles.Add;
  itm.BGColor := clNone;
  itm.Info := 'HTML Table Keywords';
  itm.Font.Color := clOlive;
  itm.Font.Style := [];
  with itm.KeyWords do
  begin
    Add('TABLE');
    Add('BORDER');
    Add('TD');
    Add('TR');
    Add('STYLE');
    Add('BORDERCOLOR');
    Add('WIDTH');
    Add('ID');
    Add('BORDERCOLORLIGHT');
    Add('BORDERCOLORDARK');
  end;
  //---------HTML Link Keywords--------------
  itm := AllStyles.Add;
  itm.BGColor := clNone;
  itm.Info := 'HTML Link Keywords';
  itm.Font.Color := clRed;
  itm.Font.Style := [];
  with itm.KeyWords do
  begin
    Add('A');
    Add('HREF');
  end;
  //------------Simple Bracket ' '----------------
  itm := AllStyles.Add;
  itm.BGColor := clNone;
  itm.StyleType := stBracket;
  itm.Info := 'Simple Bracket';
  itm.Font.Color := clBackground;
  itm.Font.Style := [];
  itm.BracketStart := #39;
  itm.BracketEnd := #39;
  //------------Double Bracket " "----------------
  itm := AllStyles.Add;
  itm.BGColor := clNone;
  itm.StyleType := stBracket;
  itm.Info := 'Double Bracket';
  itm.Font.Color := clBlue;
  itm.Font.Style := [];
  itm.BracketStart := '"';
  itm.BracketEnd := '"';
  //----------SYMBOL --------------
  itm := AllStyles.Add;
  itm.StyleType := stSymbol;
  itm.Info := 'Symbols Delimiters';
  itm.Font.Color := clTeal;
  itm.Font.Style := [];
  itm.Symbols := AllDelimiters + #13 + #10;
  //------------------------------

  with RegionDefinitions.Add do
  begin
    Identifier := '<BODY>';
    RegionStart := '<BODY>';
    RegionEnd := '</BODY>';
    RegionType := rtClosed;
  end;

  with RegionDefinitions.Add do
  begin
    Identifier := '<HEAD>';
    RegionStart := '<HEAD>';
    RegionEnd := '</HEAD>';
    RegionType := rtClosed;
  end;

  with RegionDefinitions.Add do
  begin
    Identifier := '<HTML>';
    RegionStart := '<HTML>';
    RegionEnd := '</HTML>';
    RegionType := rtClosed;
  end;

  with RegionDefinitions.Add do
  begin
    Identifier := '<SCRIPT>';
    RegionStart := '<SCRIPT>';
    RegionEnd := '</SCRIPT>';
    RegionType := rtClosed;
  end;

  with RegionDefinitions.Add do
  begin
    Identifier := '<STYLE>';
    RegionStart := '<STYLE>';
    RegionEnd := '</STYLE>';
    RegionType := rtClosed;
  end;

  with RegionDefinitions.Add do
  begin
    Identifier := '<FORM>';
    RegionStart := '<FORM>';
    RegionEnd := '</FORM>';
    RegionType := rtClosed;
  end;
end;


function TAdvHTMLMemoStyler.Format(s: string): string;
var
  i, tagstart,tagend,tagclose, scan: integer;
  res,tag: string;
  lastopenlb: boolean;
  indent: integer;
  commentstart, commentend: integer;

  function GetTag(atag: string): string;
  begin
    delete(atag,1,1);

    if (Length(atag) > 1) and (atag[1] = '/') then
      delete(atag,1,1);

    if pos(' ',atag) > 0 then
      delete(atag,pos(' ',atag), Length(atag))
    else
    begin
      if atag[length(atag)] = '>' then
        delete(atag,length(atag),1);
    end;
    atag := uppercase(atag);
    Result := atag;
  end;

  function IsIndentTag(atag: string): boolean;
  begin
    Result := true;
    atag := GetTag(atag);

    if (atag = 'META') or (atag = 'LINK') or (atag='TITLE') or (atag = 'LI') or (atag = 'INPUT') or (atag = '!DOCTYPE') or (atag = 'HTML') or (atag = 'A') or (atag = 'IMG') or (atag = 'I') or (atag='B') or (atag='U') or (atag = 'P') then
      Result := false;
  end;

  function IsLineBreakTag(atag: string): boolean;
  begin
    Result := true;

    atag := GetTag(atag);

    if (atag = 'A') or (atag = 'IMG') or (atag='P') or (atag='I') or (atag='B') or (atag='U') or (atag='LI') or (atag='TITLE') then
      Result := false;
  end;

begin
  res := '';
  scan := 1;
  commentstart := -1;
  commentend := -1;
  tagstart := -1;
  tagend := -1;
  lastopenlb := true;
  indent := 0;

  s := StringReplace(s,#13,'',[rfReplaceAll]);
  s := StringReplace(s,#10,'',[rfReplaceAll]);

  for i := 1 to Length(s) do
  begin
    if s[i] = '<' then
    begin
      res := res + copy(s,scan,i - scan); // part before tag
      tagstart := i;
      scan := i + 1;
    end;

    if s[i] = '!' then
    begin
      if i = tagstart + 1 then // comment start
        commentstart := i - 1;
    end;

    if (s[i] = '-') and (commentstart <> -1) then
    begin
      commentend := i; // comment end?
    end;

    if s[i] = '/' then
    begin
      tagend := i;
      //lastopenlb := true;
    end;

    if s[i] = '>' then
    begin
      tagclose := i;

      tag := Copy(s,tagstart,tagclose - tagstart + 1);

      if (commentstart <> -1) and (commentend = tagclose - 1) then
      begin
        tag := Copy(s,commentstart,  tagclose - commentstart + 1);

        res := res + #13#10 + '<!--' + #13#10 + copy(tag,5, Length(tag) - 7) +#13#10+'-->'+#13#10 + StringOfChar(' ',indent);
        commentstart := -1;
      end
      else
      if (tagend = tagstart + 1) or (tagend = tagclose - 1) then // it is a closing tag
      begin
        if IsLineBreakTag(tag) then
        begin
          if (indent > 0) and (tagend <> tagclose - 1) then
            dec(indent,2);
          res := res + #13#10 + StringOfChar(' ',indent) + tag;
        end
        else
          res := res + tag;

        lastopenlb := true;
        commentstart := -1;
      end
      else    // it is an opening tag
      begin
        if lastopenlb then
        begin
          res := res + #13#10 + StringOfChar(' ',indent) + tag;

          if IsIndentTag(tag) then
            inc(indent,2);
        end
        else
          res := res + tag;

        lastopenlb := IsLineBreakTag(tag);
      end;

      tagstart := -1;
      scan := i + 1;
    end;
  end;

  Result := res;
end;

function TAdvHTMLMemoStyler.HasFormatting: boolean;
begin
  Result := FAutoFormat;
end;

{ TAdvJSMemoStyler }

constructor TAdvJSMemoStyler.Create(AOwner: TComponent);
var
  itm: TElementStyle;
begin
  inherited;
  FVersion := '3.0';
  Description := 'JavaScript';
  Filter := 'Javascript Files (*.js)|*.js';
  DefaultExtension := '.js';
  StylerName := 'JavaScript';
  Extensions := 'js';
  EscapeChar := '\';
  AutoBlockEnd := true;

  LineComment := '//';
  MultiCommentLeft := '<!--';
  MultiCommentRight := '-->';
  BlockStart := '{';
  BlockEnd := '}';
  CommentStyle.TextColor := clSilver;
  CommentStyle.BkColor := clNone;
  CommentStyle.Style := [fsItalic];
  NumberStyle.TextColor := clNavy;
  NumberStyle.BkColor := clNone;
  NumberStyle.Style := [fsBold];

  //------------Script Standard Default----------------
  itm := AllStyles.Add;
  itm.BGColor := clNone;
  itm.Info := 'Script Standard Default';
  itm.Font.Color := clFuchsia;
  itm.Font.Style := [fsBold];
  itm.KeyWords.CommaText := AllJSKeyWords;
  //------------Simple Quote ' '----------------
  itm := AllStyles.Add;
  itm.BGColor := clNone;
  itm.StyleType := stBracket;
  itm.Info := 'Simple Quote';
  itm.Font.Color := clGreen;
  itm.Font.Style := [];
  itm.BracketStart := #39;
  itm.BracketEnd := #39;
  //------------Double Quote " "----------------
  itm := AllStyles.Add;
  itm.BGColor := clNone;
  itm.StyleType := stBracket;
  itm.Info := 'Double Quote';
  itm.Font.Color := clTeal;
  itm.Font.Style := [];
  itm.BracketStart := '"';
  itm.BracketEnd := '"';
  //----------SYMBOL --------------
  itm := AllStyles.Add;
  itm.BGColor := clNone;
  itm.StyleType := stSymbol;
  itm.Info := 'Symbols Delimiters';
  itm.Font.Color := clTeal;
  itm.Font.Style := [];
  itm.Symbols := AllDelimiters + #13 + #10;
  //----------Javascript functions --------------
  itm := AllStyles.Add;
  itm.BGColor := clNone;
  itm.Info := 'JavaScript Functions';
  itm.Font.Color := clGreen;
  itm.Font.Style := [fsBold];
  itm.KeyWords.CommaText := AllJSFunctions;

  with HintParameter.Parameters do
  begin
    Add('alert(message)');
    Add('confirm(message)');
    Add('prompt(message,defaultvalue)');
  end;

  with AutoCompletion do
  begin
    Add('alert');
    Add('confirm');
    Add('prompt');
  end;


end;


end.
