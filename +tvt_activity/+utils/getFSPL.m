function [ o ] = getFSPL( f )
    o = 20 * log10((4 * pi * f / 299792458)); % [dB]
    o = 1/tvt_activity.utils.db2Lin(o);
end

