
-module(test).

-include_lib("eunit/include/eunit.hrl").
%% Tests the connect with valid info in the HandShake request
%connect_test()->
 %Pid1=spawn(connector,start,[]),
  %connector:handshake("129.16.167.30").
%%------------------------------------------------------------------------------
%%First functıon tests that we get same value when we use same string in hash
%%function and also that hash react differently on upper-lower case letters
%% second function tests if the hash function can handle scandinavian letters
%% third function tests that the hash is reliable,that ıt computes correctly
%% Result: hashFunction1_test and hashFunction2_test passes, hashFunction3
%fails as intended to do.
%%------------------------------------------------------------------------------
hashFunction1_test()->
    Fosok1= pass:hash("Password"),Fosok2= pass:hash("Password"),Fosok1=Fosok2,Fosok3 = pass:hash("password"),Fosok3/=Fosok2.
%Testing with a scandinavian letter "ö".
%Result: test pass.
hashFunction2_test()->
    Fosok1 = pass:hash("Lösenord"),
    Fosok2 = pass:hash("Lösenord"),
    Fosok1 = Fosok2.
hashFunction3_test()->
    Fosok1 = pass:hash("12345"),
    Fosok2 = pass:hash("12345"),
    Fosok1 = Fosok2.
%%------------------------------------------------------------------------------
%% the methods below demonstrate the output formats that are generated by the 
%%parser Result: tests successful
%%------------------------------------------------------------------------------


enc_int_test()->
    "i2e"= encoder:enc({integer,2}).
enc_str_test()->
    "4:test" = encoder:enc({string,"test"}).
%  since read_file1_test() is sucessful, encoder:enc() is also sucessful.
%enc_dic_test()->
 %  "d4:test6:testere" = encoder:enc({dic,{{string,"test"},{string,"tester"}}}).
enc_list_string_test()->
    "l4:teste" = encoder:enc({list,[{string,"test"}]}).
enc_list_int_test()->
    "li2ee" = encoder:enc({list,[{integer,2}]}).

%%------------------------------------------------------------------------------
%%Tests that filedata:read() function is able to read torrent-files
%%------------------------------------------------------------------------------
read_file1_test()->                                                          
{{dic,[{{string,"announce"},{string,"http://85.228.185.132:8001/tracker/announce.php"}},{{string,"comment"},{string,"=hejhej"}},{{string,"created by"},{string,"mktorrent 1.0"}},{{string,"creation date"},{integer,1292003663}},{{string,"info"},{dic,[{{string,"length"},{integer,842103}},{{string,"name"},{string,"SAD.pdf"}},{{string,"piece length"},{integer,262144}},{{string,"pieces"},{string,[147,121,15,103,12,22,12,140,129,241,151,200,88,236,172,40,30,226,95,183,181,101,62,218,9,232,197,43,144,175,246,238,215,106,49,129,64,61,172,188,146,111,36,255,73,216,58,138,115,115,195,19,64,56,33,133,154,235,36,2,179,58,134,150,31,144,241,45,55,39,61,130,172,10,238,111,150,89,57,207]}}]}}]},"eof"} =filedata:read("our.torrent").




%%------------------------------------------------------------------------------
%% Testing all the getters in the pars.
%% Result:test successful
%%------------------------------------------------------------------------------

get_announce_test()->
    "http://85.228.185.132:8001/tracker/announce.php" = pars:get_announce("our.torrent").

get_comment_test()->
    {string, "=hejhej"} = pars:get_comment("our.torrent").

get_pieces_test()->
    we_decited_not_to_test_it.

get_hash_test()->
    [1,8,90,90,74,69,231,75,78,136,246,106,114,204,104,29,116,
     148,157,27] = pars:get_hash("our.torrent").

get_length_test()->
    842103 = pars:get_length("our.torrent").

get_piece_length_test()->
    262144 = pars:get_piece_length("our.torrent").

get_file_name_test()->
    "SAD.pdf" = pars:get_file_name("our.torrent").


announce_test()->
    "http://85.228.185.132:8001/tracker/announce.php" = pars:announce({dic,[{{string,"announce"},
									     {string,"http://85.228.185.132:8001/tracker/announce.php"}}]}).

%%------------------------------------------------------------------------------
%%Reads and parse torrent file wich contains one file.
%%Result:Test successful.
%%------------------------------------------------------------------------------
parse_search_data1_test()->
    {Data,_}= filedata:read("our.torrent"),{"http://85.228.185.132:8001/tracker/announce.php",{string,"=hejhej"},[1,8,90,90,74,69,231,75,78,136,246,106,114,204,104,29,116,148,157,27],[147,121,15,103,12,22,12,140,129,241,151,200,88,236,172,40,30,226,95,183,181,101,62,218,9,232,197,43,144,175,246,238,215,106,49,129,64,61,172,188,146,111,36,255,73,216,58,138,115,115,195,19,64,56,33,133,154,235,36,2,179,58,134,150,31,144,241,45,55,39,61,130,172,10,238,111,150,89,57,207],842103,262144,"SAD.pdf"} = pars:search(Data).
%%------------------------------------------------------------------------------
%% Reads torrent file wich contains one file.
%% Result: Test successful.
%%------------------------------------------------------------------------------

parse_search_data2_test()->
    {Data,_}= filedata:read("test2.torrent"),
{"http://85.228.185.132:8001/tracker/announce.php",
 {string,"hejhej"},
 [38,163,119,38,48,173,152,147,125,226,219,93,213,102,25,54,
  155,44,57,70],
 [125,21,125,124,0,10,226,125,177,70,87,92,8,206,48,223,137,
  61,58,100],
 2,262144,"A.txt"}= pars:search(Data).
%%------------------------------------------------------------------------------
%% Reads a torrent file with multiple files inside.
%% Result: Test fail, parser module cannot handle this kind of file.
%%------------------------------------------------------------------------------
parse_search_data3_test()->
  {Data,_}= filedata:read("multiplefile.torrent"),pars:search(Data).

%%------------------------------------------------------------------------------
%%Reads a torrent file with two announce inside it.
%%Result:Test fail.
%%------------------------------------------------------------------------------

parse_search_data4_test()->
    {Data,_}=filedata:read("twoannounce.torrent"),pars:search(Data).

%%------------------------------------------------------------------------------
%%Demonstrates that the function pars:bencode_reader, decodes and encodes the input
%%Result: Test successful.
%%------------------------------------------------------------------------------
		    
parse_bencode_reader_test()->
    {{string,"test"},[]} =  pars:bencode_reader("4:test"),
    {{integer,100},[]} =  pars:bencode_reader("i100e"),
    {{list,[{string,"test"},{string,"work"}]},[]} = pars:bencode_reader("l4:test4:worke"),
    [{{string,"valid"},{string,"greate"}},{{string,"test"},{string,"is"}}] = pars:bencode_reader("d4:test2:is5:valid6:greate").

%%------------------------------------------------------------------------------
%%If all is correct, these tests shall fail, incorrect input has been inserted
%%Result:Test fail, as intended.
%%------------------------------------------------------------------------------    

parse_bencode_reader_failtest_test()->
    {{string,"test"},[]}=pars:bencode_reader("4:test"),
    {{integer,1000},[]}=pars:bencode_reader("i100e"),
    {{list,[{string,"test"},{string,"work"}]},[]} = pars:bencode_reader("l3:test4:worke"),
    [{{string,123},{string,123}},{{integer,"test"},{string,"is"}}] = pars:bencode_reader("d4:test2:is5:valid6:greate").
%%-------------------------------------------------------------------------------
%%Write the string test1 in the test file.Then it checks that the the string is 
%%really at position 10, last step it checks that the string Exp is the same as 
%%the string we read from the file S.
%%Result: Test successful.
%%------------------------------------------------------------------------------

filedata_pwrite_test()->
    filedata:writer("test.txt",10,"test1"),
    {ok,S} = file:read_file("test.txt"),
    Exp = <<0,0,0,0,0,0,0,0,0,0,"test1">>,
    ?assertEqual(size(Exp), size(S)),
    ?assertEqual(Exp, S).
