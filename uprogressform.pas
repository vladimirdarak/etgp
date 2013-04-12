unit UProgressForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls;

type

  { TfrmProgress }

  TfrmProgress = class(TForm)
    pbProgress: TProgressBar;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.lfm}

end.

