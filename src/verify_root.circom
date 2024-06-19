pragma circom 2.0.0;
include "../circomlib/circuits/poseidon.circom";
include "./utils.circom";


template MerkleN(N) {
   signal input in[N];
   signal output out;

   component comp[N];
   component leafs[N];

   for(var i = 1; i < N; i++) {
       comp[i] = Poseidon(2);
   }
   for(var i = 0; i < N; i++) {
       leafs[i] = Poseidon(1);
       leafs[i].inputs[0] <== in[i];
   }

   for(var i = 2 * N - 1; i > 1; i -= 2) {
       comp[i >> 1].inputs[0] <== i >= N ? leafs[i - N].out : comp[i].out;
       comp[i >> 1].inputs[1] <== i >= N ? leafs[i - N - 1].out : comp[i ^ 1].out;
   }

   out <== comp[1].out; 
}


template RootAndUnique(N) {
    component tree = MerkleN(N);
    component num = UniqueN(N);

    signal input in[N];
    signal output out_tree;
    signal output out_num;

    for(var i = 0; i < N; i++){
       tree.in[i] <== in[i];
       num.in[i] <== in[i];
    }

    out_tree <== tree.out;
    out_num <== num.out;
}


component main = RootAndUnique(4);