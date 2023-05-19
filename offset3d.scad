// BSD 2-Clause License
//
// Copyright (c) 2017-2019, Revar Desmera
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

// Function: is_nan()
// Synopsis: Return true if the argument is "not a number".
// Topics: Type Checking
// See Also: typeof(), is_type(), is_str(), is_def(), is_int(), is_finite()
// Usage:
//   bool = is_nan(x);
// Description:
//   Returns true if a given value `x` is nan, a floating point value representing "not a number".
// Arguments:
//   x = value to check
// Example:
//   bool = is_nan(undef);  // Returns: false
//   bool = is_nan(false);  // Returns: false
//   bool = is_nan(42);     // Returns: false
//   bool = is_nan("foo");  // Returns: false
//   bool = is_nan(NAN);    // Returns: true
function is_nan(x) = (x!=x);

// Function: is_finite()
// Synopsis: Returns true if the argument is a finite number.
// Topics: Type Checking
// See Also: typeof(), is_type(), is_str(), is_def(), is_int(), is_nan()
// Usage:
//   bool = is_finite(x);
// Description:
//   Returns true if a given value `x` is a finite number.
// Arguments:
//   x = value to check
// Example:
//   bool = is_finite(undef);  // Returns: false
//   bool = is_finite(false);  // Returns: false
//   bool = is_finite(42);     // Returns: true
//   bool = is_finite("foo");  // Returns: false
//   bool = is_finite(NAN);    // Returns: false
//   bool = is_finite(INF);    // Returns: false
//   bool = is_finite(-INF);   // Returns: false
function is_finite(x) = is_num(x) && !is_nan(0*x);

// Function: segs()
// Synopsis: Returns the number of sides for a circle given `$fn`, `$fa`, and `$fs`.
// Topics: Geometry
// Usage:
//   sides = segs(r);
// Description:
//   Calculate the standard number of sides OpenSCAD would give a circle based on `$fn`, `$fa`, and `$fs`.
// Arguments:
//   r = Radius of circle to get the number of segments for.
// Example:
//   $fn=12; sides=segs(10);  // Returns: 12
//   $fa=2; $fs=3, sides=segs(10);  // Returns: 21
function segs(r) = 
    $fn>0? ($fn>3? $fn : 3) :
    let( r = is_finite(r)? r : 0 )
    ceil(max(5, min(360/$fa, abs(r)*2*PI/$fs)));

// Function: quant()
// Synopsis: Returns `x` quantized to the nearest integer multiple of `y`.
// Topics: Math, Quantization
// See Also: quant(), quantdn(), quantup()
// Usage:
//   num = quant(x, y);
// Description:
//   Quantize a value `x` to an integer multiple of `y`, rounding to the nearest multiple.
//   The value of `y` does NOT have to be an integer.  If `x` is a list, then every item
//   in that list will be recursively quantized.
// Arguments:
//   x = The value or list to quantize.
//   y = Positive quantum to quantize to
// Example:
//   a = quant(12,4);    // Returns: 12
//   b = quant(13,4);    // Returns: 12
//   c = quant(13.1,4);  // Returns: 12
//   d = quant(14,4);    // Returns: 16
//   e = quant(14.1,4);  // Returns: 16
//   f = quant(15,4);    // Returns: 16
//   g = quant(16,4);    // Returns: 16
//   h = quant(9,3);     // Returns: 9
//   i = quant(10,3);    // Returns: 9
//   j = quant(10.4,3);  // Returns: 9
//   k = quant(10.5,3);  // Returns: 12
//   l = quant(11,3);    // Returns: 12
//   m = quant(12,3);    // Returns: 12
//   n = quant(11,2.5);  // Returns: 10
//   o = quant(12,2.5);  // Returns: 12.5
//   p = quant([12,13,13.1,14,14.1,15,16],4);  // Returns: [12,12,12,16,16,16,16]
//   q = quant([9,10,10.4,10.5,11,12],3);      // Returns: [9,9,9,12,12,12]
//   r = quant([[9,10,10.4],[10.5,11,12]],3);  // Returns: [[9,9,9],[12,12,12]]
function quant(x,y) =
    assert( is_finite(y) && y>0, "The quantum `y` must be a positive value.")
    is_num(x) ? round(x/y)*y 
              : _roundall(x/y)*y;

function _roundall(data) =
    [for(x=data) is_list(x) ? _roundall(x) : round(x)];

// Module: offset3d()
// Usage:
//   offset3d(r, [size], [convexity]) CHILDREN;
// Description:
//   Expands or contracts the surface of a 3D object by a given amount.  This is very, very slow.
//   No really, this is unbearably slow.  It uses `minkowski()`.  Use this as a last resort.
//   This is so slow that no example images will be rendered.
// Arguments:
//   r = Radius to expand object by.  Negative numbers contract the object. 
//   size = Maximum size of object to be contracted, given as a scalar.  Default: 100
//   convexity = Max number of times a line could intersect the walls of the object.  Default: 10
module offset3d(r, size=100, convexity=10) {
    n = quant(max(8,segs(abs(r))),4);
    if (r==0) {
        children();
    } else if (r>0) {
        render(convexity=convexity)
        minkowski() {
            children();
            sphere(r, $fn=n);
        }
    } else {
        size2 = size * [1,1,1];
        size1 = size2 * 1.02;
        render(convexity=convexity)
        difference() {
            cube(size2, center=true);
            minkowski() {
                difference() {
                    cube(size1, center=true);
                    children();
                }
                sphere(-r, $fn=n);
            }
        }
    }
}