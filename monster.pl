% 1. Encode information about the monsters and their moves
basicType(ghost).
basicType(psychic).
basicType(fighting).
basicType(normal).
basicType(dark).

monster(annihilape,ghost).
monster(espathra,psychic).
monster(flamigo,fighting).
monster(lechonk,normal).
monster(mabosstiff,dark).

move(lowKick,fighting).
move(shadowPunch,ghost).
move(rageFist,ghost).
move(bodySlam,normal).
move(psybeam,psychic).
move(quickAttack,normal).
move(shadowBall,ghost).
move(payback,dark).
move(megaKick,normal).
move(closeCombat,fighting).
move(tackle,normal).
move(takeDown,normal).
move(zenHeadbutt,psychic).
move(bodySlam,normal).
move(snarl,dark).
move(lick,ghost).
move(bite,dark).

monsterMove(annihilape,lowKick).
monsterMove(annihilape,shadowPunch).
monsterMove(annihilape,rageFist).
monsterMove(annihilape,bodySlam).
monsterMove(espathra,psybeam).
monsterMove(espathra,quickAttack).
monsterMove(espathra,lowKick).
monsterMove(espathra,shadowBall).
monsterMove(flamigo,lowKick).
monsterMove(flamigo,payback).
monsterMove(flamigo,megaKick).
monsterMove(flamigo,closeCombat).
monsterMove(lechonk,tackle).
monsterMove(lechonk,takeDown).
monsterMove(lechonk,zenHeadbutt).
monsterMove(lechonk,bodySlam).
monsterMove(mabosstiff,snarl).
monsterMove(mabosstiff,lick).
monsterMove(mabosstiff,bite).
monsterMove(mabosstiff,bodySlam).
               
% 2. Encode effectiveness
typeEffectiveness(weak,psychic,psychic).
typeEffectiveness(strong,psychic,fighting).
typeEffectiveness(superweak,psychic,dark).
typeEffectiveness(ordinary,psychic,ghost).
typeEffectiveness(ordinary,psychic,normal).
typeEffectiveness(weak,fighting,psychic).
typeEffectiveness(ordinary,fighting,fighting).
typeEffectiveness(strong,fighting,dark).
typeEffectiveness(superweak,fighting,ghost).
typeEffectiveness(strong,fighting,normal).
typeEffectiveness(strong,dark,psychic).
typeEffectiveness(weak,dark,psychic).
typeEffectiveness(weak,dark,psychic).
typeEffectiveness(strong,dark,psychic).
typeEffectiveness(ordinary,dark,psychic).
typeEffectiveness(strong,ghost,psychic).
typeEffectiveness(ordinary,ghost,fighting).
typeEffectiveness(weak,ghost,dark).
typeEffectiveness(strong,ghost,ghost).
typeEffectiveness(superweak,ghost,normal).
typeEffectiveness(ordinary,normal,psychic).
typeEffectiveness(ordinary,normal,fighting).
typeEffectiveness(ordinary,normal,dark).
typeEffectiveness(superweak,normal,ghost).
typeEffectiveness(ordinary,normal,normal).

% 3. Encode basic effectiveness relationships
moreEffective(strong,ordinary).
moreEffective(ordinary,weak).
moreEffective(weak,superweak). 

% 4. Encode transitive effectiveness information
moreEffectiveThan(E1, E2) :- moreEffective(E1, E2).
moreEffectiveThan(E1, E2) :- moreEffective(E1, E3), moreEffectiveThan(E3, E2).


% 5. Define a Prolog rule called monsterMoveMatch(T,MO1,MO2,MV)
monsterMoveMatch(T, MO1, MO2, MV):-
    monsterMove(MO1,MV),   % Get the type of MO1
    monsterMove(MO2,MV),   % Get the type of MO2
    not(MO1=MO2),
    move(MV,T).           % Get the type of the move MV

% 6. Define a Prolog rule called moreEffectiveMoveType(MV1,MV2,T)
moreEffectiveMoveType(MV1,MV2,T):-
    typeEffectiveness(strong,Type1,T), % Move MV1 is strong against monsters of type T
    typeEffectiveness(ordinary,Type2,T), % Move MV2 is ordinary against monsters of type T
    move(MV1,Type1), % Verify that MV1 has type Type1
    move(MV2,Type2), % Verify that MV2 has type Type2
    moreEffectiveThan(strong,ordinary). % MV1 is more effective than MV2

% 7. Define a Prolog rule called moreEffectiveMove(MO1,MV1,MO2,MV2)
moreEffectiveMove(MO1,MV1,MO2,MV2):-
    % Verify that MO1 can perform MV1
    monster(MO1,Type1),
    move(MV1,Type1),

    % Verify that MO2 can perform MV2
    monster(MO2,Type2),
    move(MV2,Type2),

    % Determine the type effectiveness for MV1 against MO2
    typeEffectiveness(Effectiveness1, Type1, Type2),

    % Determine the type effectiveness for MV2 against MO1
    typeEffectiveness(Effectiveness2, Type2, Type1),

    % Check if MV1 is more effective than MV2
    moreEffective(Effectiveness1, Effectiveness2).