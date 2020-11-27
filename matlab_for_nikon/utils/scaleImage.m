function [ Img_out, scaleval ] = scaleImage( Img_in, prc )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
      Imgmin = min(Img_in(:));
      Img_out = Img_in - Imgmin;
      Imgprc = prctile(Img_out(:), prc);
      Img_out = Img_out / Imgprc;
      scaleval = [Imgmin Imgprc];

end

