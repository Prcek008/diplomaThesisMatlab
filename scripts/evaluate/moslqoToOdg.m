function [ odg ] = moslqoToOdg( moslqo )
mos = abs((4.6607-log((4.999-moslqo)./(moslqo-0.999)))./1.4945);
odg = mos;
end

