unit UCompanyEditForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DbCtrls, Buttons;

type

  { TfrmCompanyEdit }

  TfrmCompanyEdit = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    edtPhone: TDBEdit;
    edtPhone1: TDBEdit;
    edtEmail: TDBEdit;
    edtStreet: TDBEdit;
    edtPsc: TDBEdit;
    edtCity: TDBEdit;
    edtName: TDBEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure edtStreetChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmCompanyEdit: TfrmCompanyEdit;

implementation

{$R *.lfm}

{ TfrmCompanyEdit }

procedure TfrmCompanyEdit.edtStreetChange(Sender: TObject);
begin

end;

end.

