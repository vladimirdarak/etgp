unit UCAbstract;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, DbCtrls, Forms, ZDataset, ExtCtrls, StdCtrls, ComCtrls;

type

  TCAbstract = class(TObject)
    procedure OnAddClick(Sender: TObject); virtual; abstract;
    procedure OnEditClick(Sender: TObject); virtual; abstract;
    procedure OnDeleteClick(Sender: TObject); virtual; abstract;
    procedure OnAfterScroll(DataSet: TDataSet); virtual; abstract;
    procedure SetTab(PageControl: TPageControl); virtual; abstract;

    {function GetForm:TForm;
    procedure SetForm(Form: TForm);}

    private
      //FForm: TForm;
    public
      //property Form: TForm read GetForm write SetForm;
  end;

implementation

end.

