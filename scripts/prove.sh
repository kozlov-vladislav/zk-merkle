#!/bin/bash
node ./data/$1/$1_js/generate_witness.js ./data/$1/$1_js/$1.wasm $2 ./data/$1/witness.wtns
snarkjs groth16 prove ./data/$1/$1_1.zkey ./data/$1/witness.wtns ./data/$1/keys/proof.json ./data/$1/keys/public.json
snarkjs groth16 verify ./data/$1/keys/verification_key.json ./data/$1/keys/public.json ./data/$1/keys/proof.json