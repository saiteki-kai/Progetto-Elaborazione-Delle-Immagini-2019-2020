% APPROCCIO:
    % trovo la scatola (sse non è presente mi fermo)
    % determino se è quadrata o rettangolare
    % trovo i "presunti" cioccolatini
        % elimino i cerchi esterni alla scatola
        % elimino i cerchi overlappati
        % ricostruisco io alcuni cerchi
    % se la scatola è rettangolare
        % costruisco una griglia
        % classifico i cioccolatini come (1,2,3,4) classi:
            % - 1 bianchi
            % - 2 dorati
            % - 3 neri
            % - 4 rigetto
         % trovo eventuali posizioni errate
         % conto cioccolatini
         % conto bollini
    % se la scatola e quadrata
        % classifico i cioccolatini come (1,2) classi:
            % - 1 dorati
            % - 2 rigetto
        % conto cioccolatini
        % conto bollini
    % ritorno un valore logico 0-1
    % mostro gli eventuali errori trovati


% function iscomplaiant = main(path)
%     
%     image = im2double(imread(path));
%     
%     [r, c, ~] = size(image);
%     resized = imresize(image, 1/5);
%     
%     mask = find_box(resized);
%     mask = imresize(mask, [r c]);
%     
%     box = mask .* image;
%     
%     iscomplaiant = false;
% 
% end