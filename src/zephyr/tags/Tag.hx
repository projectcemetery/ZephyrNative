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

package zephyr.tags;

import zephyr.app.ApplicationContext;
import zephyr.app.NativeView;
import zephyr.style.Style;

/**
 *  Markup object
 */
class Tag extends TagContainer {

    /**
     *  Tag name
     */
    public var name (default, null) : String; 

     /**
      *  Id of tag
      */
     public var id (default, null) : String;

     /**
      *  Css classes
      */
     public var styles (default, null) : Array<String>;

     /**
      *  Css style
      */
     public var style : Style;

     /**
      *  Parent tag
      */
     public var parent : Tag;

     /**
      *  Custom style. 
      *  TODO: implement from options
      */
     public var customStyle : Style;

     /**
      *  Parse css classes string. Like: mystyle another_style good_style
      *  @param cls - 
      */
     function parseCssOption (cls : String) {
        styles = cls.split (" ");
     }

     /**
      *  Render childrens
      */
     function renderChilds (context : ApplicationContext) : Array<NativeView> {
        if (childs == null) return [];
        return [for (i in childs) i.render (context)];
     }
     
     #if android
     /**
      *  Render for android
      */
     function renderAndroid (context : ApplicationContext) : NativeView {
         throw "Unsupported platform";
     }
     #end
     #if web
     /**
      *  Render for web
      */
     function renderWeb (context : ApplicationContext) : NativeView {
         throw "Unsupported platform";
     }
     #end
     #if ios
     /**
      *  Render for ios
      */
     function renderIos (context : ApplicationContext) : NativeView {
         throw "Unsupported platform";
     }
     #end

     /**
      *  Constructor
      *  @param tags - 
      */
     public function new (name : String, ?options : TagOptions, ?tags : Array<Tag>) {
         super (tags);
         this.name = name;
         id = "";
         styles = new Array<String> ();

         // Apply parent
         if (tags != null) {
             for (tag in tags) {
                 tag.parent = this;
             }
         }

         if (options != null) {
             if (options.id != null) id = options.id;
             if (options.css != null) parseCssOption (options.css);
         }         
     }

    /**
     *  Render tag to android view
     *  Virtual
     *  @return View
     */
    public function render (context : ApplicationContext) : NativeView {
        #if android
        var view = renderAndroid (context);
        #elseif web
        var view = renderWeb (context);
        #elseif ios
        var view = renderIos (context);
        #else
        throw "Usupported platform";
        #end

        // TODO: style native
        // Apply styles to native view
        //var engine = context.getStyleEngine ();
        //engine.applyNative (view);
        return view;
    }
}