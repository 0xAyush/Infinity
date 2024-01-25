/*
*   ********************
*   * Infinity Zig-Zag *
*   ********************
*
*   A demonstration of the fact that the length of the limit is not necessarily equal to the limit of the length
*   Ayush Sharma (C) 2024
*   MIT Licence
*
*
*   The program animates a family of curves (zig-zags centered at y = 0) that uniformly converge to f(x) = 0 on the interval (0,1)
*   The family of curves maintains a length forcedLength > 1 (set to 2 by default) which is not equal to the length of the horizontal line (0,1) (a length of 1) represented by f(x) = 0 on (0,1)
*   This demonstrates the fact that just because two curves converge it does not mean they have equal length. We can extend this analysis to higher dimensions by extruding the curves.
*
*   We also show the whole family in the background, semi-transparent.
*   
*   We draw/animate the first maxZig > 1 members of the family, by default set to fifty.
*   Change animSpeed to get faster animation, by default set to 20.
*
*   Program does not auto center, change this manually.
*
*/

/////////////////////////////////////////////////////////////////////////////////////
// Parameters/Controls //         Animation Parameters                             //
/////////////////////////////////////////////////////////////////////////////////////
float forceLength = 2.0; // This the length every member of the sequence would take//
int maxZig = 70;         // Number of terms of sequence shown                      //
float animSpeed = 30;    // Animation speed                                        //
/////////////////////////////////////////////////////////////////////////////////////
// With default settings we get a zig-zag of length 2 converging to (0,1)          //
/////////////////////////////////////////////////////////////////////////////////////
// Parameters/Controls // Screen Parameters                                        //
/////////////////////////////////////////////////////////////////////////////////////
void setup() {         //                                                          //
  size(800,800);       //                                                          //
  background(255);     //                                                          //
}                      // Setup  Window dimension in px                            //
                       //                                                          //
int centering = 200;   // Postive to shift screen left, negative otherwise         //
int zoom = 400;        // Bigger number bigger picture                             //
/////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////////////////////
// STATEMENT:                                                                                //
//                                                                                           //
// IF N bet the number of zeros and epsilon be the desired deviation from the interval (0,1) //
// and l > 1 be the arbitrary length of the zig-zag                                          //
// THEN,                                                                                     //
// N = ceil( sqrt(l^2 - 1) / (2* epsilon))                                                   //
// a zig-zag of such parameters is within epsilon of the line/interval (0,1)                 //
///////////////////////////////////////////////////////////////////////////////////////////////
// PROOF:                                                                                    //
//                                                                                           //
// IF N bet the number of zeros and epsilon be the desired deviation from the interval (0,1) //
// and l be the arbitrary length of the zig-zag                                              //
// THEN,                                                                                     //
// In one turn of the zig-zag look at the up going line, its the same length as the down     //
// going line, total of N lines, if length of one line be a, the total length be N*a         //
// i.e                                                                                       //
//                                                                                           //
//  l = N*a (1)                                                                              //
//                                                                                           //
// in one upgoing length, construct the right-triangle containing it, height of  2*epsilon,  //
// lets say d = 2*epsilon                                                                    //
// base of 1/N (because N uniformly placed lengths)                                          //
// a is the hypotensuse                                                                      //
// By Pythagoras                                                                             //
//                                                                                           //
//    a^2 = d^2 + 1/N^2                                                                      //
// => a = sqrt(d^2 + 1/N^2) (2)                                                              //
//                                                                                           //
// by substituting using (2) in (1) we get:                                                  //
//                                                                                           //
//    l = N*sqrt(d^2 + 1/N^2) = sqrt(N^2*d^2 + N^2/N^2) = sqrt(N^2*d^2 + 1)                  //
// => l^2 = N^2*d^2 + 1                                                                      //
// => N^2*d^2 = l^2 - 1                                                                      //
// => N^2 = (l^2 - 1)/d^2                                                                    //
// => N^2 = (l^2 - 1)/(2*epsilon^2)                                                          //
// => N = sqrt(l^2 - 1)/(2*epsilon)                                                          //
//                                                                                           //
// To prevent fractional N we use ceil                                                       //
//                                                                                           //
// Therefore, N = ceil(sqrt(l^2 - 1)/(2*epsilon))                                            //
//                                                                                           //
//                                                                                           //
//                                                                                      QED  //
///////////////////////////////////////////////////////////////////////////////////////////////


/////////////
//  CODE   //
/////////////



////////////////////////////////////////////////////////////////////////////////////////////////
// Init                                                                                       //
////////////////////////////////////////////////////////////////////////////////////////////////
// Accumulators
float t = 0;
int i = 0;

//dt
float dt = animSpeed/100;

//scale variable
float svar = 200.0/zoom;


////////////////////////////////////////////////////////////////////////////////////////////////
// Loop                                                                                       //
////////////////////////////////////////////////////////////////////////////////////////////////

void draw() {
  
  // Screen setup
  background(255);
  translate(height/2 - centering,width/2);
  scale(zoom);
  stroke(0);
  strokeWeight(0.005*svar);
  
  // Draw the sequence
  for(int i = 0; i < maxZig; i++) {
    float progress = float(i + 1)/maxZig;
    stroke(255*progress,255*(1.0 - progress),255,50*(pow(progress,0.01))); // Cyan -> Purple in later curves, alpha gets higher in later stages, less steep
    zigZag(i + 1,forceLength);
  }
  
  // Draw the limit point
  stroke(0);
  line(0,0,1,0);
  
  // Limit approach animation
  //float progress = float(i + 1)/maxZig;
  bounds(i + 1,forceLength); // Draw the bounds
  //stroke(255*(1 - progress),70,255*(pow(progress,0.425))); // Green -> Red in later curves
  stroke(255,0,0);
  zigZag(i + 1,forceLength); // Draw the curves
  
  // Loop and update
  if(t > 1){
    i += 1;
    t = 0;
  }
  if(i == maxZig) {
    i = 0;
  }
  t += dt;
}

////////////////////////////////////////////////////////////////////////////////////////////////
// Utils                                                                                      //
////////////////////////////////////////////////////////////////////////////////////////////////

// Draw a zig-zag of length D which fits into the interval (0,1) and has N zeros
void zigZag(int N,float D) {
  float delta = 1.0/N; // dx = 1/N
  float dy = sqrt(pow(D/N,2) - pow(delta,2)); // dx^2 + dy^2 = (D/N)^2 for one lenght element
  int parity = 1; // Flip-flop zig-zag
  for(int i = 0; i < N; i++) {
    line(float(i)*delta,parity * dy/2,float(i+1)*delta,parity * -dy/2);
    parity *= -1;
  }
}

// Calculate epsilon for zig-zag of length D which fits into the interval (0,1) and has N zeros, draw lines bounding the limit point epslion above and epsilon below; eps = dy/2
void bounds(int N,float D) {
  float delta = 1.0/N;
  float dy = sqrt(pow(D/N,2) - pow(delta,2));
  line(0,-dy/2,1,-dy/2);
  line(0,+dy/2,1,+dy/2);
}
