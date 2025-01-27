-module(task1_test).
-include_lib("eunit/include/eunit.hrl").
-compile(export_all).


eval_error_test_() ->
    [
        ?_assertEqual(error, task1:eval({undef, 3, 5})),
        ?_assertEqual(error, task1:eval({add, a, 8}))
    ].

eval_add_test_() ->
    [
        ?_assertEqual({ok, 8}, task1:eval({add, 3, 5})),
        ?_assertEqual({ok, 3.8}, task1:eval({add, 2.4, 1.4}))
    ].

eval_sub_test_() ->
    [
        ?_assertEqual({ok, 3}, task1:eval({sub, 5, 2})),
        ?_assertEqual({ok, 7.2}, task1:eval({sub, 10.4, 3.2}))
    ].

eval_mul_test_() ->
    [
        ?_assertEqual({ok, 10}, task1:eval({mul, 5, 2})),
        ?_assertEqual({ok, 10.0}, task1:eval({mul, 2.5, 4}))
    ].

eval_div_test_() ->
    [
        ?_assertEqual({ok, 5.0}, task1:eval({'div', 10, 2})),
        ?_assertEqual({ok, 2.0}, task1:eval({'div', 22.2, 11.1}))
    ].

eval_complex_test_() ->
    [
        ?_assertEqual({ok, 3}, task1:eval({add, {add, 1, 1}, 1})),
        ?_assertEqual({ok, 5}, task1:eval({add, {add, 1, {add, 1, 1}}, {add, 1, 1}})),
        ?_assertEqual({ok, 7}, task1:eval({add, {add, 1, {add, 1, 1}}, {mul, 2, 2}})),
        % 5 + 3*2 - 8/4 == 9
        ?_assertEqual({ok, 9.0}, task1:eval({sub, {add, 5, {mul, 3, 2}}, {'div', 8, 4}})),

        % copmlex error cases
        ?_assertEqual(error, task1:eval({add, {add, 1, 1}, undef})),
        ?_assertEqual(error, task1:eval({add, {undef, 1, 1}, 1}))
    ].


eval_map_error_test_() ->
    [
        ?_assertEqual({error, unknown_error}, task1:eval({undef, 1, 1}, #{})),

        ?_assertEqual({error, variable_not_found}, task1:eval({add, 1, b}, #{})),

        ?_assertEqual({error, variable_not_found}, task1:eval({add, a, {add, a, undef}}, #{a=>1})),

        ?_assertEqual({error, unknown_error}, task1:eval({add, a, {undef, a, a}}, #{a=>1})),

        % 5 + 3*2 - 8/4 == 9
        ?_assertEqual({error, variable_not_found}, task1:eval({sub, {add, a, {mul, b, c}}, {'div', d, e}}, #{a=>5, b=>3, c=>2, d=>8}))
    ].

eval_map_test_() ->
    [
        ?_assertEqual({ok, 2}, task1:eval({add, 1, 1}, #{})),
        ?_assertEqual({ok, 3}, task1:eval({add, a, b}, #{a=>2, b=>1})),
        ?_assertEqual({ok, 3}, task1:eval({add, 1, {add, 1, 1}}, #{})),

        ?_assertEqual({ok, 3}, task1:eval({add, a, {add, a, a}}, #{a=>1})),
        ?_assertEqual({ok, 6}, task1:eval({add, a, {add, a, a}}, #{a=>2})),

        ?_assertEqual({ok, 3}, task1:eval({sub, 5, a}, #{a=>2})),

        % 5 + 3*2 - 8/4 == 9
        ?_assertEqual({ok, 9.0}, task1:eval({sub, {add, a, {mul, b, c}}, {'div', d, e}}, #{a=>5, b=>3, c=>2, d=>8, e=>4}))
    ].


map_test_() ->
    [
        ?_assertEqual([], task1:map(fun(X)-> X end, [])),
        ?_assertEqual([1,2,3], task1:map(fun(X)-> X end, [1,2,3])),
        ?_assertEqual([2,4,6], task1:map(fun(X)-> X*2 end, [1,2,3])),
        ?_assertEqual([6,7,8], task1:map(fun(X)-> X+5 end, [1,2,3]))
    ].

filter_test_() ->
    [
        ?_assertEqual([2], task1:filter(fun(X) -> X > 0 end, [-1, 2, 0])),

        ?_assertEqual([hi, stockholm], task1:filter(fun(X) -> is_atom(X) end, [hi, 4, 5, stockholm, 2025]))
    ].

split_test_() ->
    [
        ?_assertEqual({[2], [-1, 0]}, task1:split(fun(X) -> X > 0 end, [-1, 2, 0])),
        ?_assertEqual({[programming, erl, i, love], [3, 6, 8, 2]}, task1:split(fun(X) -> is_atom(X) end, [3, programming, 6, 8, erl, i, 2, love]))
    ].


groupby_test_() -> 
    [
        ?_assertEqual(#{negative => [1, 4], positive => [2, 3], zero => [5]},
            task1:groupby(
            fun(X) -> if X < 0 -> negative;
                         X > 0 -> positive;
                         true -> zero
                    end
            end,
                    [-1, 11, 10, -8, 0])),

        ?_assertEqual(#{small => [1,2,3,8], medium => [4,7,9], large => [5,6,10]},
            task1:groupby(
            fun(X) -> if X < 50 -> small;
                         X > 50 andalso X < 100 -> medium;
                         true -> large
                    end
            end,
                    [-50, 20, 45, 70, 300, 180, 56, -2, 77, 9999]))
    ].