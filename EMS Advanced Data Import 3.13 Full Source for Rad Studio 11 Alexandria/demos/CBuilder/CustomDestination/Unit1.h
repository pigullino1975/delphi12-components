//---------------------------------------------------------------------------

#ifndef Unit1H
#define Unit1H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "QImport3.hpp"
#include "QImport3XLS.hpp"
#include <Grids.hpp>
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
    TButton *Button1;
    TStringGrid *StringGrid1;
    TQImport3XLS *QImportXLS1;
    TButton *Button2;
    void __fastcall QImportXLS1UserDefinedImport(TObject *Sender,
      TQImportRow *Row);
    void __fastcall QImportXLS1BeforeImport(TObject *Sender);
    void __fastcall FormCreate(TObject *Sender);
    void __fastcall Button1Click(TObject *Sender);
    void __fastcall Button2Click(TObject *Sender);
    void __fastcall QImportXLS1AfterImport(TObject *Sender);
private:	// User declarations
    int FCounter;
public:		// User declarations
        __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
 