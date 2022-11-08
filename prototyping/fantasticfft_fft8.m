function out = fantasticfft_fft8(x)
    out(1) = sum(x); %a+b+c+d+e+f+g+h;
    out(2) = 0;

    out(3) = (x(1) - x(5)) + 0.707 * (x(2) - x(6) + x(8) - x(4)); % (a-e)+p*(b-f+h-d);
    out(4) = x(7) - x(3) + 0.707 * (x(8) - x(4) - x(2) + x(6));   % (g-c)+p*(h-d-b+f);
    
    out(5) = x(1) + x(5) - x(7) - x(3); % a+e-g-c;
    out(6) = x(4) + x(8) - x(2) - x(6); % d+h-b-f;
    
    out(7) = (x(1) - x(5)) + 0.707 * (x(6) - x(2) + x(4) - x(8)); % (a-e)+p*(f-b+d-h);
    out(8) = (x(3) - x(7)) + 0.707 * (x(8) + x(6) - x(2) - x(4)); % (c-g)+p*(h+f-b-d);
    
    out(9)  = x(1) + x(5) + x(3) + x(7) - x(2) - x(6) - x(4) - x(8); %a+e+c+g-b-f-d-h;
    out(10) = 0;
    
    out(11) = (x(1) - x(5)) + 0.707 * (x(6) - x(2) + x(4) - x(8)); % (a-e)+p*(f-b-h+d);
    out(12) = (x(7) - x(3)) + 0.707 * (x(2) + x(4) - x(8) - x(6)); % (g-c)+p*(b+d-h-f);

    out(13) = x(1) + x(5) - x(7) - x(3); % a+e-g-c;
    out(14) = x(2) + x(6) - x(4) - x(8); % b+f-d-h;
    
    out(15) = (x(1) - x(5)) + 0.707 * (x(2) - x(6) + x(8) - x(4)); % (a-e)+p*(b+h-f-d);
    out(16) = (x(3) - x(7)) + 0.707 * (x(2) + x(4) - x(8) - x(6)); % (c-g)+p*(b+d-h-f);
end