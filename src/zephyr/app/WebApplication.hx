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

package zephyr.app;

#if web
import haxe.io.Bytes;
import js.Browser;
import zephyr.app.NativeView;
import zephyr.app.EntryPointHelper;

/**
 *  Application for webview: browser, cordova, etc
 */
@:keep
class WebApplication implements INativeApplication {

    /**
     *  Entry point
     */
    public static function main () {
        Browser.document.addEventListener ("DOMContentLoaded", function () {
            var entryPoint = EntryPointHelper.getEntryPoint();
            var cls = Type.resolveClass (entryPoint);
            if (cls != null) {
                var app = new WebApplication ();
                var inst : IApplication = cast Type.createEmptyInstance (cls);
                inst.onReady (new ApplicationContext (app));
            }
        });        
    }

    /**
     *  Constructor
     */
    public function new () {}

    /**
     *  Get asset by name
     *  @param name - asset name
     *  @return Bytes
     */
    public function getAsset (name : String) : Bytes {
        var hostname = Browser.location.hostname;
        if (hostname == "") throw "Need launch from server";
        var data = haxe.Http.requestUrl('/assets/${name}');
        return Bytes.ofString (data);
    }


    /**
     *  Add styles to app
     *  @param text - stylesheet
     */
    public function addStyle (text : String) : Void {
        var style = Browser.document.createStyleElement ();
        style.type = 'text/css';
        style.appendChild (Browser.document.createTextNode (text));
        Browser.document.head.appendChild (style);
    }

    /**
     *  Apply view
     *  @param view - 
     */
    public function setView (view : NativeView) : Void {        
        Browser.document.body.appendChild (view);
    }    
}
#end