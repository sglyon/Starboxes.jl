__precompile__()
module Starboxes

export Starbox

type Starbox{Tv<:Vector,Tstar}
    # given by user
    newline_char::Char
    star::Tstar
    width::Int
    pad::Int

    # internal
    parts::Tv
    star_size::Int

    function Starbox(msg::AbstractString, newline_char::Char, star::Tstar, width::Int, pad::Int)
        parts = split(msg, newline_char)
        new{Tv,Tstar}(newline_char, star, width, pad, parts, length(star))
    end
end

function Starbox{T<:AbstractString,Tstar}(msg::T, newline_char::Char='/',
                                    star::Tstar='*', width::Int=79, pad::Int=0)
    Starbox{Vector{SubString{T}},Tstar}(msg, newline_char, star, width, pad)
end

function padline(io::IO, n::Int)
    for i in 1:n
        print(io, ' ')
    end
end

function print_border(io::IO, sb::Starbox)
    padline(io, sb.pad)
    for i in 1:floor(Int, sb.width/sb.star_size)
        print(io, sb.star)
    end

    # repeat as many characters as we need to fill the full width
    for i in 1:(sb.width % sb.star_size)
        print(io, sb.star[i])
    end

    println(io)
end

function print_part(io::IO, sb::Starbox, i::Int)
    padline(io, sb.pad)

    # add a leading star
    print(io, sb.star)

    # determine how much whitespace should go before
    len = length(sb.parts[i])
    skip1 = floor(Int, (sb.width - len) / 2 - sb.star_size)
    padline(io, skip1)

    # print the part
    print(io, sb.parts[i])

    # determine how much whitespace should go after
    skip2 = sb.width - skip1 - len - 2*sb.star_size
    padline(io, skip2)

    # add trailing star
    print(io, sb.star_size > 1 ? reverse(sb.star) : sb.star)

    println(io)
    nothing
end

function Base.show(io::IO, ::MIME"text/plain", sb::Starbox)
    print_border(io, sb)
    for i in 1:length(sb.parts)
        print_part(io, sb, i)
    end
    print_border(io, sb)
    nothing
end

end # module
