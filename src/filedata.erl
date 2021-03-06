%%%-----------------------------------------------------------------------------
%%% File    : filedata.erl
%%% Author  : Michal Musialik
%%% Description : File reader and writer
%%% Created : 13 Oct 2010 by mysko <mysko@mysko-laptop>
%%% Version : 1.0
%%%-----------------------------------------------------------------------------

%%-----------------------------Refernces----------------------------------------
%% Web pages:
%% http://www.erldocs.com
%% http://www.erlang.org/
%% Books:
%% A concurrent approach to software development
%% Francesco Cesarini
%% ISBN: 978-0-596-51818-9
%%
%% Programming Erlang
%% Joe Amstrong
%% ISBN-10: 1-9343560-0-X
%%------------------------------------------------------------------------------

-module(filedata).
-compile(export_all).
	
%%--------------------------------Reference for this function-------------------
%% http://paste.lisp.org/display/59691
%% Date 20 Okt 2010
%% Reading lines in torrent file and sending raw data to pars mode where 
%% bencode parser handle the incomming data
%%------------------------------------------------------------------------------
read(File)->
    {ok, S} = file:open(File, read),
    Result = pars:bencode_reader(read_lines(S)),
    file:close(S),
    Result.


read_lines(S) -> 
read_lines(S, []).
read_lines(S, Acc) ->
    Line = io:get_line(S, ''),
    case Line of
        eof -> lists:concat(lists:reverse([Line|Acc]));
        _   -> read_lines(S, [Line|Acc])
    end.

%%------------------------------------------------------------------------------
%% Writing a string with raw data from conector, file is read, position is 
%% selected and raw data is written, for ever new chuk of data.
%% Starting possition of poaition is 0, is less then 0 error is generated
%%------------------------------------------------------------------------------
writer(Filename,Position,String)->
{ok, S} = file:open(Filename,[read,write,raw,binary]),
    io:format("-Writing to file in poistion: ~w~n",[Position]),
    if Position >= 0 ->
	    file:pwrite(S,Position,String),
	    file:close(S);	
       Position < 0 -> error
    end.


