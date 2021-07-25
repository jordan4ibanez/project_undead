
-- globalized reference for hurting the player
function hurt_player(player, damage)
    digest_hurt(player, damage)
end

--globalized reference for healing the player
function heal_player(player, regen)
    digest_heal(player, regen)
end

