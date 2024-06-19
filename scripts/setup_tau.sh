#!/bin/bash
mkdir setup
cd setup
snarkjs powersoftau new bn128 14 pot12_0000.ptau -v
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="DMDMDM" -v
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
