pragma circom 2.0.0;
include "../circomlib/circuits/poseidon.circom";


template MerkleFullN(N) {
   signal input in[N];
   signal output out[2*N-1];

   component comp[N];
   component leafs[N];

   for(var i = 1; i < N; i++) {
       comp[i] = Poseidon(2);
   }
   for(var i = 0; i < N; i++) {
       leafs[i] = Poseidon(1);
       leafs[i].inputs[0] <== in[i];
       out[i + N - 1] <== leafs[i].out;
   }

   for(var i = 2 * N - 1; i > 1; i -= 2) {
       comp[i >> 1].inputs[0] <== i >= N ? leafs[i - N].out : comp[i].out;
       comp[i >> 1].inputs[1] <== i >= N ? leafs[i - N - 1].out : comp[i ^ 1].out;
   }

   for(var i = 1; i < N; i++) {
       out[i - 1] <== comp[i].out;
   }
}

component main = MerkleFullN(4);