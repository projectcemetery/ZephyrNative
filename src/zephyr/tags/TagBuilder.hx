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

import zephyr.tags.box.*;
import zephyr.tags.button.*;
import zephyr.tags.textview.*;
import zephyr.tags.toolbar.*;
import zephyr.tags.listview.*;
import zephyr.tags.TagOptions;

/**
 *  Helper for markup
 */
class TagBuilder {

    /**
     *  Add vertical box tag
     *  @param childs - 
     *  @return VBox
     */
    public static function vbox (options : TagOptions, ?childs : Array<Tag>) : Box {
        return new VBox (options, childs);
    }

    /**
     *  Add horizontal box tag
     *  @param childs - 
     *  @return HBox
     */
    public static function hbox (options : TagOptions, ?childs : Array<Tag>) : Box {
        return new HBox (options, childs);
    }

    public static function button (options : ButtonOptions) : Button {
        return new Button (options);
    }

    /**
     *  Add toolbar
     *  @param childs - 
     *  @return Toolbar
     */
    public static function toolbar (?options : ToolbarOptions) : Toolbar {
        return new Toolbar (options);
    }

    /**
     *  Add listview
     *  @param options - 
     *  @return ListView<T>
     */
    public static function listview<T> (?options : ListViewOptions<T>) : ListView<T> {
        return new ListView (options);
    }

    /**
     *  Create TextView tag
     *  @param options - 
     *  @return TextView
     */
    public static function textview (options : TextViewOptions) : TextView {
        return new TextView (options);
    }
}