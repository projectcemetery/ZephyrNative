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

package zephyr.tags.box;

#if android
import android.view.View;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LinearLayout_LayoutParams;
import android.content.Context;
#end

#if web
import js.Browser;
#end

import zephyr.app.ApplicationContext;
import zephyr.app.NativeView;

/**
 *  Box layout
 */
class Box extends Tag {

    #if android
    /**
     * Render for android
    **/
    override function renderAndroid (context : ApplicationContext) : NativeView {
        var layout =  new LinearLayout (context.getAndroidActivity ());
        layout.setOrientation(LinearLayout.VERTICAL);        
        layout.setWeightSum (1);
        var params = new LinearLayout_LayoutParams (-1,-1);

        var childs = renderChilds (context);
        for (child in childs) {
            layout.addView (child);
        }

        layout.setLayoutParams (params);

        return layout;
    }
    #end

    #if web
    /**
     *  Render for web
     *  @param context - 
     *  @return NativeView
     */
    override function renderWeb (context : ApplicationContext) : NativeView {
        var engine = context.getEngine ();
        var box = Browser.document.createElement (name);
        engine.styleView (box, this);

        // Render childs
        var childs = renderChilds (context);
        for (child in childs) {
            box.appendChild (child);
        }

        return box;
    }
    #end

    /**
      *  Constructor
      *  @param tags - 
      */
     public function new (name : String, options : TagOptions, ?tags : Array<Tag>) {
         super (name, options, tags);
     }
}