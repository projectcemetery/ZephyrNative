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

import neko.Lib;

/**
 *  Log text
 */
class Logger {

    /**
     *  Log info line
     *  @param e - 
     */
    public static inline function info (e : String) {
        Lib.println (e);
    }

    /**
     *  Start Log info
     *  @param e - 
     */
    public static inline function infoStart (e : String) {
        Lib.print (e);
    }

    /**
     *  Start Log info
     *  @param e - 
     */
    public static inline function endInfoSuccess () {
        if (Sys.systemName () != "Windows") {
            Lib.println ('\033[0;32m - DONE\033[0m');
        } else {
            Lib.println (" - DONE");
        }
    }

    /**
     *  Start Log info
     *  @param e - 
     */
    public static inline function endInfoError () {
        if (Sys.systemName () != "Windows") {
            Lib.println ('\033[0;31m - ERROR\033[0m');
        } else {
            Lib.println (" - ERROR");
        }
    }

    /**
     *  Log info line
     *  @param e - 
     */
    public static inline function success (e : String) {
        if (Sys.systemName () != "Windows") {
            Lib.println ('\033[0;32m${e}\033[0m');
        } else {
            Lib.println (e);
        }
    }

    /**
     *  Log error line
     *  @param e - 
     */
    public static inline function error (e : String) {
        if (Sys.systemName () != "Windows") {
            Lib.println ('\033[0;31m${e}\033[0m');
        } else {
            Lib.println (e);
        }
    }
}