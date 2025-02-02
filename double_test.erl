-module(double_test).
-include_lib("eunit/include/eunit.hrl").
-compile(export_all).


double_test() ->
    double:start(),

    Ref = make_ref(),
    double ! {self(), Ref, 10},
    receive
        {Ref, Value} -> ?assertEqual(20, Value)
    end,

    Ref2 = make_ref(),
    double ! {self(), Ref2, crashit},

    receive
        {Ref2, _} -> ?assertEqual(this_should_not_be_hit, but_was_hit)
    after 100 ->
        pass
    end.
