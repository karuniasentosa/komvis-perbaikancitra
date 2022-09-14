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
    btnGrayscale: TButton;
    btnSmoothing: TButton;
    Button1: TButton;
    Image1: TImage;
    op: TOpenPictureDialog;
    sp: TSavePictureDialog;
    tbBrightness: TTrackBar;
    tbThreshold: TTrackBar;
    tbContrastG: TTrackBar;
    tbContrastP: TTrackBar;
    procedure btnBrightnessClick(Sender: TObject);
    procedure btnContrastClick(Sender: TObject);
    procedure btnGrayscaleClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSmoothingClick(Sender: TObject);
    procedure btnThresholdClick(Sender: TObject);
    procedure btnSharpeningClick(Sender: TObject);
    function clampByte(v: integer): byte;
    function contrastValue(v: byte; g, p: integer): byte;
  private
    lebar, tinggi: integer;
    // grayValue: array[0..1000, 0..1000] of byte;
    bitmapR, bitmapG, bitmapB: array[0..1000, 0..1000] of byte;
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
begin
  if op.Execute then begin
    Image1.Picture.LoadFromFile(op.FileName);
    lebar := Image1.width;
    tinggi := Image1.height;
    for y := 0 to tinggi -  1 do
      for x := 0 to lebar - 1 do begin
        bitmapR[x, y] := GetRValue(image1.Canvas.Pixels[x,y]);
        bitmapG[x, y] := GetGValue(image1.Canvas.Pixels[x,y]);
        bitmapB[x, y] := GetBValue(image1.Canvas.Pixels[x,y]);
      end;
  end;
end;

procedure TForm1.btnBrightnessClick(Sender: TObject);
var
  y, x: integer;
  brightValue: integer;
  resultR, resultG, resultB : byte;
begin
  brightValue := tbBrightness.position;

  for y := 0 to tinggi - 1 do
    for x := 0 to lebar - 1 do begin
      resultR := clampByte(bitmapR[x, y] + brightValue);
      resultG := clampByte(bitmapG[x, y] + brightValue);
      resultB := clampByte(bitmapB[x, y] + brightValue);
      bitmapR[x, y] := resultR;
      bitmapG[x, y] := resultG;
      bitmapB[x, y] := resultB;
      image1.canvas.pixels[x, y] := RGB(resultR, resultG, resultB);
    end;

end;

procedure TForm1.btnContrastClick(Sender: TObject);
var
  y, x: integer;
  contrastG: integer;
  contrastP: integer;
  resultR, resultG, resultB: byte
;begin
  contrastG := tbContrastG.position;
  contrastP := tbcontrastp.position;

  for y := 0 to tinggi - 1 do
    for x := 0 to lebar - 1 do begin
      resultR := contrastValue(bitmapR[x, y], contrastG, contrastP);
      resultG := contrastValue(bitmapG[x, y], contrastG, contrastP);
      resultB := contrastValue(bitmapB[x, y], contrastG, contrastP);

      bitmapR[x, y] := resultR;
      bitmapB[x, y] := resultB;
      bitmapG[x, y] := resultG;

      image1.canvas.pixels[x, y] := RGB(resultR, resultG, resultB);
    end;

end;

procedure TForm1.btnGrayscaleClick(Sender: TObject);
var
  y, x : integer ;
  grayValue : byte;
begin
  for y := 0 to tinggi - 1 do
    for x := 0 to lebar -  1 do begin
      grayValue := (bitmapR[x, y] + bitmapG[x, y] + bitmapB[x, y]) div 3;
      bitmapR[x, y] := grayValue;
      bitmapG[x, y] := grayValue;
      bitmapB[x, y] := grayValue;
      image1.canvas.pixels[x, y] := RGB(grayValue, grayValue, grayValue);
    end;
end;

procedure TForm1.btnSaveClick(Sender: TObject);
begin
  if sp.Execute then image1.Picture.savetofile(sp.filename);
end;

procedure TForm1.btnSmoothingClick(Sender: TObject);
var
   x, y: integer;
   R, G, B: integer;
begin
  for y:= 0 to image1.Height -1 do
    for x:= 0 to image1.Width -1 do begin
      R := (bitmapR[x, y] + bitmapR[x - 1, y - 1] + bitmapR[x, y-1]+
        bitmapR[x + 1, y - 1] + bitmapR[x - 1, y] + bitmapR[x + 1, y]+
        bitmapR[x - 1, y + 1] + bitmapR[x, y + 1] + bitmapR[x + 1, y + 1]) div 9;

      G := (bitmapG[x, y] + bitmapG[x - 1, y - 1] + bitmapG[x, y-1]+
        bitmapG[x + 1, y - 1] + bitmapG[x - 1, y] + bitmapG[x + 1, y]+
        bitmapG[x - 1, y + 1] + bitmapG[x, y + 1] + bitmapG[x + 1, y + 1]) div 9;

      B := (bitmapB[x, y] + bitmapB[x - 1, y - 1] + bitmapB[x, y-1]+
        bitmapB[x + 1, y - 1] + bitmapB[x - 1, y] + bitmapB[x + 1, y]+
        bitmapB[x - 1, y + 1] + bitmapB[x, y + 1] + bitmapB[x + 1, y + 1]) div 9;
      bitmapR[x, y] := R;
      bitmapG[x, y] := G;
      bitmapB[x, y] := B;
      image1.Canvas.Pixels[x, y] := RGB(R, G, B);
    end;
end;

procedure TForm1.btnThresholdClick(Sender: TObject);
var
  y, x : integer;
  threshold: byte;
begin
  threshold :=  -tbThreshold.Position;
  for y := 0 to tinggi - 1 do
    for x := 0 to lebar - 1 do
      begin
        if (image1.canvas.pixels[x, y] and 255) > threshold then
           image1.canvas.pixels[x, y] := RGB(255, 255, 255)
        else
           image1.canvas.pixels[x, y] := RGB(0, 0, 0);
      end;
end;

procedure TForm1.btnSharpeningClick(Sender: TObject);
var
  x, y: integer;
  r1, r2, r3: integer;
  g1, g2, g3: integer;
  b1, b2, b3: integer;
begin
  for y:= 0 to image1.Height - 1 do
    for x:= 0 to image1.Width - 1 do begin
      r1:= bitmapR[x, y];
      g1:= bitmapG[x, y];
      b1:= bitmapB[x, y];

      r2 := bitmapR[x + 1, y + 1];
      g2 := bitmapG[x + 1, y + 1];
      b2 := bitmapB[x + 1, y + 1];

      r3:= r1 + (r1 - r2) div 2;
      g3:= g1 + (g1 - g2) div 2;
      b3:= b1 + (b1 - b2) div 2;

      r3 := clampByte(r3);
      g3 := clampByte(g3);
      b3 := clampByte(b3);
      bitmapR[x, y] := r3;
      bitmapG[x, y] := g3;
      bitmapB[x, y] := b3;
      image1.Canvas.Pixels[x, y] :=  RGB(r3, g3, b3);
    end;

end;

function tform1.clampByte(v: integer): byte;
begin
  if v > 255 then clampByte := 255;
  if v < 0 then clampByte := 0;
  clampByte := v;
end;
function tform1.contrastValue(v: byte; g, p: integer): byte;
begin;
  contrastValue := clampByte(g * (v  - p) + p);
end;

end.

