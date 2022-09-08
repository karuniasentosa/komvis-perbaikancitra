unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtDlgs,
  ExtCtrls, ComCtrls, LCLIntf;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnThreshold: TButton;
    btnOpen: TButton;
    btnContrast: TButton;
    btnBrightness: TButton;
    btnSave: TButton;
    Image1: TImage;
    op: TOpenPictureDialog;
    sp: TSavePictureDialog;
    tbBrightness: TTrackBar;
    tbThreshold: TTrackBar;
    tbContrastG: TTrackBar;
    tbContrastP: TTrackBar;
    procedure btnBrightnessClick(Sender: TObject);
    procedure btnContrastClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnThresholdClick(Sender: TObject);
  private
    lebar, tinggi: integer;
    grayValue: array[0..1000, 0..1000] of byte;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnOpenClick(Sender: TObject);
var
  y, x: integer;
  r, g, b, avg: byte;
begin
  if op.Execute then begin
    Image1.Picture.LoadFromFile(op.FileName);
    lebar := Image1.width;
    tinggi := Image1.height;
    for y := 0 to tinggi -  1 do
      for x := 0 to lebar - 1 do begin
        r := GetRValue(image1.Canvas.Pixels[x,y]);
        g := GetGValue(image1.Canvas.Pixels[x,y]);
        b := GetBValue(image1.Canvas.Pixels[x,y]);
        avg := (r + g + b) div 3;
        grayValue[x, y] := avg;
        image1.Canvas.Pixels[x, y] := RGB(avg, avg, avg);
      end;
  end;
end;

procedure TForm1.btnBrightnessClick(Sender: TObject);
var
  y, x: integer;
  brightValue: integer;
  grayResult : integer;
begin
  brightValue := tbBrightness.poSiTioN;

  for y := 0 to Image1.Height-1 do
    for x := 0 to IMage1.Width - 1 do begin
      grayResult := grayValue[x,y] + brightValue;
      if grayResult > 255 then grayResult := 255;
      if grayResult < 0 then grayResult := 0;
      grayValue[x, y] := grayResult;
      image1.canvas.pixels[x, y] := RGB(grayResult, grayResult, grayResult);
    end;

end;

procedure TForm1.btnContrastClick(Sender: TObject);
var
  y, x: integer;
  contrastG: integer;
  contrastP: integer;
  grayResult: integer
;begin
  contrastG := tbContrastG.position;
  contrastP := tbcontrastp.position;

  for y := 0 to image1.height - 1 do
    for x := 0 to image1.width - 1 do begin
      grayResult := contrastG * (grayValue[x, y] - contrastP) + contrastP;
      if grayResult > 255 then grayResult := 255;
      if grayResult < 0 then grayResult := 0;
      grayValue[x, y] := grayResult;
      image1.canvas.pixels[x, y] := RGB(grayResult, grayResult, grayResult);
    end;

end;

procedure TForm1.btnSaveClick(Sender: TObject);
begin
  if sp.Execute then image1.Picture.savetofile(sp.filename);
end;

procedure TForm1.btnThresholdClick(Sender: TObject);
var
  y, x : integer;
  threshold: byte;
begin
  threshold :=  tbThreshold.Position;
  for y := 0 to image1.height - 1 do
    for x := 0 to image1.width - 1 do
      begin
        if image1.canvas.pixels[x, y] > threshold then
           image1.canvas.pixels[x, y] := RGB(255, 255, 255);
        if image1.canvas.pixels[x, y] < threshold then
           image1.canvas.pixels[x, y] := RGB(0, 0, 0);
      end;
end;

end.

