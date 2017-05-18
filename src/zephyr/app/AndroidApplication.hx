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

#if android
import haxe.io.Bytes;
import android.view.Display;
import android.graphics.Point;
import android.app.Activity;
import android.os.Bundle;
import android.view.Window;
import zephyr.app.NativeView;
import zephyr.style.Engine;
import zephyr.asset.Asset;

@:keep
class AndroidApplication extends android.app.Activity implements INativeApplication {
    
    /**
     *  Display
     */
    var display : Display;

    /**
     *  Engine for styling
     */
    var styleEngine : Engine;

    /**
     *  Show exception on screen
     *  @param e - 
     */
    function showException (e : Dynamic) {
        var textView = new android.widget.TextView (this);

        if (Std.is (e, java.lang.Exception)) {            
            var sw = new java.io.StringWriter();
            var pw = new java.io.PrintWriter(sw);
            e.printStackTrace(pw);
            textView.setText (sw.toString());
        } else {
            textView.setText (Std.string (e));
        }

        setContentView (textView);
    }

    /**
     *  On activity create
     *  @param bundle - 
     */
    @:overload
    override function onCreate (bundle : Bundle) : Void {
        super.onCreate (bundle);

        this.requestWindowFeature (Window.FEATURE_NO_TITLE);
        var entryPoint = EntryPointHelper.getEntryPoint();
        var cls = Type.resolveClass (entryPoint);
        if (cls != null) {
            try {
                display = getWindowManager().getDefaultDisplay();
                styleEngine = new Engine (this);
                var context = new ApplicationContext (this);
                var inst : IApplication = cast Type.createEmptyInstance (cls);                                
                inst.onReady (context);
            } catch (e : java.lang.Exception) {
                showException (e);
            }
        } else {
            showException ("Entry point not found");
        }
    }

    /**
     *  Add styles to app
     *  @param text - stylesheet
     */
    public function addStyle (text : String) : Void {
        styleEngine.addRules (text);        
    }

    /**
     *  Return engine for styling native views
     *  @return AndroidEngine
     */
    public function getEngine () : Engine {
        return styleEngine;
    }

    /**
     *  Get asset by name
     *  @param name - asset name
     *  @return Bytes
     */
    public function getAsset (name : String) : Asset {
        var prefix = "/assets/";
        var path = name;
		if (name.indexOf (prefix) > -1) {
            path = name.substr (prefix.length);
        }		

        var input = getAssets ().open (path);
        var size = input.available ();
        var buffer = new java.NativeArray<java.types.Int8> (size);
        input.read (buffer);
        input.close ();
        var data = Bytes.ofData (buffer);
        var tp = Asset.getAssetType (path);
        return new Asset (tp, data);
    }

    /**
     *  Apply view
     *  @param view - 
     */
    public function setView (view : NativeView) : Void {
        setContentView (view);
    }

    /**
     *  Return screen width
     *  @return Float
     */
    public inline function getScreenWidth () : Float {
        var size = new Point();
        display.getSize(size);
        return size.x;
    }

    /**
     *  Return screen height
     *  @return Float
     */
    public inline function getScreenHeight () : Float {
        var size = new Point();
        display.getSize(size);
        return size.y;
    }
}
#end