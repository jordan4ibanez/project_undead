
-- globalized reference for hurting the player
function hurt_player(player, damage)
    digest_hurt(player, damage)
end

-- globalized reference for healing the player
function heal_player(player, regen)
    digest_heal(player, regen)
end

-- globalized reference for hunger (adder and subtractor)
function raise_hunger(player, hunger_amount)
    digest_stat_addition(player, "hunger", hunger_amount)
end
function lower_hunger(player, hunger_amount)
    digest_stat_subtraction(player, "hunger", hunger_amount)
end


-- globalized reference for thirst (adder and subtractor)
function raise_thirst(player, thirst_amount)
    digest_stat_addition(player, "thirst", thirst_amount)
end
function lower_thirst(player, thirst_amount)
    digest_stat_subtraction(player, "thirst", thirst_amount)
end

-- globalized reference for exhaustion (adder and subtractor)
function raise_exhaustion(player, exhaustion_amount)
    digest_stat_addition(player, "exhaustion", exhaustion_amount)
end
function lower_exhaustion(player, exhaustion_amount)
    digest_stat_subtraction(player, "exhaustion", exhaustion_amount)
end

-- globalized reference for panic (adder and subtractor)
function raise_panic(player, panic_amount)
    digest_stat_addition(player, "panic", panic_amount)
end
function lower_panic(player, panic_amount)
    digest_stat_subtraction(player, "panic", panic_amount)
end

-- globalized reference for infection (adder and subtractor)
function raise_infection(player, infection_amount)
    digest_stat_addition(player, "infection", infection_amount)
end
function lower_infection(player, infection_amount)
    digest_stat_subtraction(player, "infection", infection_amount)
end

-- globalized reference for sadness (adder and subtractor)
function raise_sadness(player, sadness_amount)
    digest_stat_addition(player, "sadness", sadness_amount)
end
function lower_sadness(player, sadness_amount)
    digest_stat_subtraction(player, "sadness", sadness_amount)
end

-- globalized reference for strength (adder and subtractor)
function raise_strength(player, strength_amount)
    digest_stat_addition(player, "strength", strength_amount)
end
function lower_strength(player, strength_amount)
    digest_stat_subtraction(player, "strength", strength_amount)
end

-- globalized reference for fitness (adder and subtractor)
function raise_fitness(player, fitness_amount)
    digest_stat_addition(player, "fitness", fitness_amount)
end
function lower_fitness(player, fitness_amount)
    digest_stat_subtraction(player, "fitness", fitness_amount)
end