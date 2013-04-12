unit UCiselnikDefaultForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  ExtCtrls, StdCtrls, DbCtrls;

type

  { TfrmCiselnikFormDefault }

  TfrmCiselnikFormDefault = class(TForm)
    grdAttrs: TDBGrid;
    gbDescription: TGroupBox;
    grdList: TDBGrid;
    GroupBox1: TGroupBox;
    mDesc: TDBMemo;
    pnlAttributes: TPanel;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmCiselnikFormDefault: TfrmCiselnikFormDefault;

implementation

{$R *.lfm}

end.

