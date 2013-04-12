unit UOperationNameForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids;

type

  { TfrmCiselnikFormOperationName }

  TfrmCiselnikFormOperationName = class(TForm)
    grdList: TDBGrid;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmCiselnikFormOperationName: TfrmCiselnikFormOperationName;

implementation

{$R *.lfm}

end.

