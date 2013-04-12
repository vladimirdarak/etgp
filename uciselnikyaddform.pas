unit UCiselnikyAddForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DbCtrls, Buttons, DBGrids;

type

  { TfrmCiselnikAdd }

  TfrmCiselnikAdd = class(TForm)
    btnCancel: TBitBtn;
    btnOk: TBitBtn;
    mDescription: TDBMemo;
    edtName: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmCiselnikAdd: TfrmCiselnikAdd;

implementation

{$R *.lfm}

{ TfrmCiselnikAdd }

procedure TfrmCiselnikAdd.btnOkClick(Sender: TObject);
begin

end;

procedure TfrmCiselnikAdd.btnCancelClick(Sender: TObject);
begin

end;

end.

