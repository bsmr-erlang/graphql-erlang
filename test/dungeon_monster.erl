-module(dungeon_monster).
-include("dungeon.hrl").

-export([execute/4]).

execute(_Ctx, #monster { id = ID,
                         name = Name,
                         hitpoints = HP,
                         inventory = Inventory,
                         mood = Mood,
                         plush_factor = PlushFactor,
                         stats = Stats,
                         properties = Properties,
                         color = Color}, Field, Args) ->
    case Field of
        <<"id">> -> dungeon:wrap({monster, ID});
        <<"name">> -> {ok, Name};
        <<"color">> -> color(Color, Args);
        <<"hitpoints">> -> {ok, HP};
        <<"hp">> -> {ok, HP};
        <<"inventory">> -> {ok, [dungeon:load(OID) || OID <- Inventory]};
        <<"mood">> -> {ok, Mood};
        <<"plushFactor">> -> {ok, PlushFactor};
        <<"spikyness">> -> {ok, 5};
        <<"stats">> -> stats(Stats, Args);
        <<"statsVariantOne">> -> stats(Stats);
        <<"statsVariantTwo">> -> stats(Stats);
        <<"statsVariantThree">> -> stats(Stats);
        <<"properties">> ->
            {ok, [{ok, P} || P <- Properties]};
        <<"errorListResolution">> ->
            %% This produces a wrong return on purpose
            {ok, [<<"MECH">>, <<"DRAGON">>]}
    end.

color(Color, #{ <<"colorType">> := <<"rgb">> }) ->
    {ok, Color};
color(Color, #{ <<"colorType">> := <<"gray">> }) ->
    {ok, gray(Color)}.

gray(#{ r := R,
        g := G,
        b := B }) ->
    V = 0.30*R + 0.59*G + 0.11*B,
    #{ r => V, g => V, b => V }.

stats(SS) ->
    {ok, [{ok, S} || S <- SS]}.
                     
stats(SS, #{ <<"minAttack">> := Min }) ->
    {ok, [{ok, S} || S <- SS,
                     S#stats.attack >= Min]}.

