pragma circom 2.0.0;
include "../circomlib/circuits/comparators.circom";
include "../circomlib/circuits/poseidon.circom";

template MerkleInclusionHelper() {
   signal input left;
   signal input right;
   signal input reversed;
   signal output out;

   signal out1;
   component comp1 = Poseidon(2);
   comp1.inputs[0] <== left;
   comp1.inputs[1] <== right;
   out1 <== comp1.out;

   signal out2;
   component comp2 = Poseidon(2);
   comp2.inputs[1] <== left;
   comp2.inputs[0] <== right;
   out2 <== comp2.out;

   signal out01;
   out01 <== (1 - reversed) * out1;
   signal out02;
   out02 <== reversed * out2;

   out <== out01 + out02;
}

template MerkleInclusion(depth) {
   signal input path[depth];
   signal input reversed[depth];
   signal input value;
   signal output out;

   component single_hash = Poseidon(1);

   single_hash.inputs[0] <== value;
   signal hashed_value;
   hashed_value <== single_hash.out;

   component comp[depth];
   for(var i = 0; i < depth; i += 1) {
       comp[i] = MerkleInclusionHelper();
   }
   comp[0].left <== hashed_value;
   comp[0].right <== path[0];
   comp[0].reversed <== reversed[0];
   for(var i = 1; i < depth; i += 1) {
        comp[i].left <== comp[i - 1].out;
        comp[i].right <== path[i];
        comp[i].reversed <== reversed[i];
   }

   out <== comp[depth - 1].out; 
}


component main = MerkleInclusion(2);