#!/bin/bash
mkdir data
cd data
mkdir $1
cd $1
mkdir keys
circom ../../src/$1.circom --r1cs --wasm --sym --c --O0
snarkjs groth16 setup $1.r1cs ../../setup/pot12_final.ptau $1_0.zkey
snarkjs zkey contribute $1_0.zkey $1_1.zkey --name="DMDMDM" -v
snarkjs zkey export verificationkey $1_1.zkey keys/verification_key.json
