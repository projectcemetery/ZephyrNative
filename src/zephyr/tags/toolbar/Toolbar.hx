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

package zephyr.tags.toolbar;

#if web
import js.Browser;
#end

import zephyr.app.ApplicationContext;
import zephyr.app.NativeView;

/**
 *  Tag for Toolbar
 */
class Toolbar extends Tag {
    public inline static var tagName = "toolbar";

    /**
     *  Options for toolbar rendering
     */
    var options : ToolbarOptions;

    #if android
    /**
     *  Render for android
     */
    override function renderAndroid (context : ApplicationContext) : NativeView {
        throw "Unsupported platform";
    }
    #end

    #if web
    /**
     *  Render for web
     *  @param context - 
     *  @return NativeView
     */
    override function renderWeb (context : ApplicationContext) : NativeView {
        var toolbar = Browser.document.createElement (tagName);        

        if (options.title != null) {
            var titleView = options.title.render (context);            
            titleView.classList.add ("title");              
            for (s in options.title.styles) titleView.classList.add (s);
            toolbar.appendChild (titleView);
        }

        return toolbar;
    }
    #end    

    /**
     *  Constructor
     *  @param options - 
     */
    public function new (options : ToolbarOptions) {
        super (tagName, options);
        this.options = options;
    } 
}