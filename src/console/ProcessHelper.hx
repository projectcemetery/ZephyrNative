/*
 * Copyright (c) 2017 Grabli66
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package console;

import sys.io.Process;

class ProcessHelper {

    /**
     *  Launch process and call with error text if exists
     *  @param call - 
     *  @param cmd - 
     *  @param args - 
     */
    public static function launch (cmd : String, args : Array<String>, call : String -> Void) {        
        var proc : Process = {
            if (args.length > 0) {
                new Process (cmd, args);
            } else {
                new Process (cmd);
            }
        };
        var code = proc.exitCode (true);
        var sb = new StringBuf ();
        if (code != 0) {
            try {
                var dat = proc.stderr.readLine ();
                sb.add (dat);
                sb.add ("\n");
                while (dat != null) {
                    dat = proc.stderr.readLine ();
                    sb.add (dat);
                    sb.add ("\n");
                }
            } catch (e : Dynamic) {}
        }
        if (sb.length < 1) {
            call (null);
        } else {
            call (sb.toString ());
        }        
    }
}