-module(monitor_test).
-include_lib("eunit/include/eunit.hrl").
-compile(export_all).


monitor_test() ->
    monitor:start(),

    % TODO race condition during startup
    timer:sleep(100),

    Ref = make_ref(),
    Twenty = double:double(10),
    ?assertEqual(20, Twenty),

    % crash the double process
    double ! {self(), Ref, crash},

    Thirty = double:double(15),
    ?assertEqual(30, Thirty).
