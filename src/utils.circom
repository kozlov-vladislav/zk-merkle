pragma circom 2.0.0;
include "../circomlib/circuits/comparators.circom";

template Sum2() {
   signal input in1;
   signal input in2;
   signal output out;

   out <== in1 + in2;
}

template SumN(N) {
   signal input in[N];
   signal output out;
   component comp[N-1];

   for(var i = 0; i < N-1; i++){
       comp[i] = Sum2();
   }
   comp[0].in1 <== in[0];
   comp[0].in2 <== in[1];
   for(var i = 0; i < N-2; i++){
       comp[i+1].in1 <== comp[i].out;
       comp[i+1].in2 <== in[i+2];

   }
   out <== comp[N-2].out; 
}

template UniqueN(N) {
   signal input in[N];
   signal output out;

   component comp[N-1];

   component sum = SumN(N);

   sum.in[0] <== 1;

   for(var i = 0; i < N-1; i++) {
       comp[i] = LessThan(250);
       comp[i].in[0] <== in[i];
       comp[i].in[1] <== in[i + 1];
       sum.in[i + 1] <== comp[i].out;
   }
   
   out <== sum.out; 
}