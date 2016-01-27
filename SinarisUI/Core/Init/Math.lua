--------------------------------------------------------------------------------
-- AddOn Name: SinarisUI
-- Author: Sinaris
-- Credits:
-- Version 2.0
--------------------------------------------------------------------------------

local S, L, M = select( 2, ... ):Unpack()

local select = select
local modf, ceil, floor = math.modf, math.ceil, math.floor
local format, gsub, match, reverse = string.format, string.gsub, string.match, string.reverse

S['Round'] = function( Number, Decimals )
	if( not Decimals ) then
		Decimals = 0
	end

	return ( ( '%%.%df' ):format( Decimals ) ):format( Number )
end

S['ColorGradient'] = function( Min, Max, ... )
	local Percent

	if( Max == 0 ) then
		Percent = 0
	else
		Percent = Min / Max
	end

	if( Percent >= 1 ) then
		local R, G, B = select( select( '#', ... ) - 2, ... )

		return R, G, B
	elseif( Percent <= 0 ) then
		local R, G, B = ...

		return R, G, B
	end

	local Num = ( select( '#', ... ) / 3 )
	local Segment, RelPercent = modf( Percent * ( Num - 1 ) )
	local R1, G1, B1, R2, G2, B2 = select( ( Segment * 3 ) + 1, ... )

	return R1 + ( R2 - R1 ) * RelPercent, G1 + ( G2 - G1 ) * RelPercent, B1 + ( B2 - B1 ) * RelPercent
end

S['RGBToHex'] = function( r, g, b )
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0

	return format( '|cff%02x%02x%02x', r * 255, g * 255, b * 255 )
end

S['ShortValue'] = function( v )
	if( v >= 1e9 ) then
		return ( '%.1fb' ):format( v / 1e9 ):gsub( '%.?0+([kmb])$', '%1' )
	elseif( v >= 1e6 ) then
		return ( '%.1fm' ):format( v / 1e6 ):gsub( '%.?0+([kmb])$', '%1' )
	elseif( v >= 1e3 or v <= -1e3 ) then
		return ( '%.1fk' ):format( v / 1e3 ):gsub( '%.?0+([kmb])$', '%1' )
	else
		return v
	end
end

S['ShortValueNegative'] = function( v )
	if( v <= 999 ) then
		return v
	end

	if( v >= 1000000 ) then
		local value = format( '%.1fm', v / 1000000 )
		return value
	elseif( v >= 1000 ) then
		local value = format( '%.1fk', v / 1000 )
		return value
	end
end

S['CommaValue'] = function( V )
	local Value = V

	while true do
		Value, K = gsub( Value, '^(-?%d+)(%d%d%d)', '%1,%2' )

		if( K == 0 ) then
			break
		end
	end

	return Value
end

S['Comma'] = function( num )
	local Left, Number, Right = match( num, '^([^%d]*%d)(%d*)(.-)$' )

	return Left .. reverse( gsub( reverse( Number ), '(%d%d%d)', '%1,' ) ) .. Right
end

S['FormatTime'] = function( s )
	local Day, Hour, Minute = 86400, 3600, 60

	if( s >= Day ) then
		return format( '%dd', ceil( s / Day ) )
	elseif( s >= Hour ) then
		return format( '%dh', ceil( s / Hour ) )
	elseif( s >= Minute ) then
		return format( '%dm', ceil( s / Minute ) )
	elseif( s >= Minute / 12 ) then
		return floor( s )
	end

	return format( '%.1f', s )
end

S['ShortenString'] = function( string, numChars, dots )
	local bytes = string:len()

	if( bytes <= numChars ) then
		return string
	else
		local len, pos = 0, 1

		while( pos <= bytes ) do
			len = len + 1
			local c = string:byte( pos )

			if( c > 0 and c <= 127 ) then
				pos = pos + 1
			elseif( c >= 192 and c <= 223 ) then
				pos = pos + 2
			elseif( c >= 224 and c <= 239 ) then
				pos = pos + 3
			elseif( c >= 240 and c <= 247 ) then
				pos = pos + 4
			end

			if( len == numChars ) then
				break
			end
		end

		if( len == numChars and pos <= bytes ) then
			return string:sub( 1, pos - 1 ) .. ( dots and '...' or '' )
		else
			return string
		end
	end
end
