// Flags =  0 : long , 2 float , 4 unsigned , 8 short , 64 dfloat (sim only)  (see more options in the CCmdMode definition)
        { 0 , (long unsigned *) & SysState.Timing.UsecTimer },
        { 4 , (long unsigned *) & SysState.Timing.UsecTimer }, //1:UsecTimer [Time] {Microsecond timer at hardware}
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastVload  [ClaRecsCopy] {FastVload }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastVout  [ClaRecsCopy] {FastVout }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastIsense  [ClaRecsCopy] {FastIsense }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastIload  [ClaRecsCopy] {FastVload }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastVdc  [ClaRecsCopy] {FastVdc }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastD  [ClaRecsCopy] {FastD }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastVref  [ClaRecsCopy] {FastVref }
        { 258 , (long unsigned *) &ClaRecsCopy.kuku[0] }, //:FastCurrentDemand  [ClaRecsCopy] {FastCurrentDemand }
