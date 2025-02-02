-module(bank_test).
-include_lib("eunit/include/eunit.hrl").
-compile(export_all).


bank_balance_test() ->
    S = bank:start(),
    Err = bank:balance(S, bob),
    ?assertEqual(no_account, Err).


bank_deposit_withdraw_lend_test() ->
    S = bank:start(),

    % deposit
    {ok, BalanceBob1} = bank:deposit(S, bob, 100),
    ?assertEqual(100, BalanceBob1),

    {ok, BalanceAlice} = bank:deposit(S, alice, 70),
    ?assertEqual(70, BalanceAlice),
    BalanceAliceGet = bank:balance(S, alice),
    ?assertEqual(70, BalanceAliceGet),

    {ok, BalanceBob2} = bank:deposit(S, bob, 5),
    ?assertEqual(105, BalanceBob2),


    % withdraw
    {ok, BalanceBob3} = bank:withdraw(S, bob, 25),
    ?assertEqual(80, BalanceBob3),
    BalanceBob3Get = bank:balance(S, bob),
    ?assertEqual(80, BalanceBob3Get),

    % withdraw errors
    insufficient_funds = bank:withdraw(S, alice, 1000),
    no_account = bank:withdraw(S, noexist, 1000).

bank_lend_test() ->
    S = bank:start(),

    bank:deposit(S, bob, 50),
    bank:deposit(S, alice, 0),

    ok = bank:lend(S, bob, alice, 40),
    BalanceBob = bank:balance(S, bob),
    ?_assertEqual(10, BalanceBob),
    BalanceAlice = bank:balance(S, alice),
    ?_assertEqual(40, BalanceAlice),


    % lend errors
    {no_account, eve} = bank:lend(S, bob, eve, 10),
    {no_account, eve} = bank:lend(S, eve, bob, 10),
    {no_account, both} = bank:lend(S, eve, victor, 10),

    insufficient_funds = bank:lend(S, bob, alice, 1000000).


bank_error_test() ->
    S = spawn(fun () -> receive _ -> ok end end),

    no_bank = bank:balance(S, heyho),
    no_bank = bank:deposit(S, heyho, 10),
    no_bank = bank:withdraw(S, heyho, 10),
    no_bank = bank:lend(S, heyho, hohey, 10).

