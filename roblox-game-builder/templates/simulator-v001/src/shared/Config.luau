-- Example balance only; replace for each game. No player data or production permissions.
return {
 version=1, schema=1, capacity=24, coinsCap=1000000,
 currencyName='Монеты', items={scrap={name='Находка',sell=5}},
 collectItem='scrap', upgrades={{cost=0,yield=1},{cost=20,yield=2},{cost=60,yield=3}},
}
