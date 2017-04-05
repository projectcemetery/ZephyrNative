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

import android.view.View;
import android.content.Context;

/**
 *  Markup object
 */
class Tag extends TagContainer {

     /**
      *  Id of tag
      */
     public var id (default, null) : String;

     /**
      *  Css styles
      */
     public var styles (default, null) : Array<String>;

     /**
      *  Render childrens
      */
     function renderChilds (context : Context) : Array<View> {
        if (childs == null) return [];
        return [for (i in childs) i.render (context)];
     }

     /**
      *  Constructor
      *  @param tags - 
      */
     public function new (?tags : Array<Tag>) {
         super (tags);
         styles = new Array<String> ();
     }

    /**
     *  Render tag to android view
     *  Virtual
     *  @return View
     */
    public function render (context : Context) : View {
        throw "Not implemented";
    }

    /**
     *  Find all tags by css style names
     *  @param styleNames - 
     */
    override public function findByCss (styleNames : Array<String>) : Array<Tag> {
        var res = new Array<Tag> ();

        var found = false;
        for (s in styleNames) {
            if (styles.indexOf (s) < 0) break;
            found = true;
        }
        
        if (found) res.push (this);        

        for (t in childs) {
            var styles = t.findByCss (styleNames);
            if (styles != null) res = res.concat (styles);
        }

        return if (res.length > 0) res else null;
    }

    /**
     *  Apply css style to tag
     */
    /*public function applyStyle (style : StyleSheet) {

    }*/
}