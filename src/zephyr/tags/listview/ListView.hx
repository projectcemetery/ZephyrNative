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

package zephyr.tags.listview;

import zephyr.app.NativeView;
import zephyr.app.ApplicationContext;

#if web
import js.Browser;
import zephyr.tags.TagBuilder.*;
#end

#if android
import android.widget.BaseAdapter;
import android.view.View;
import android.view.ViewGroup;

/**
 *  List view adapter
 */
class ListViewAdapter<T> extends BaseAdapter {

    /**
     *  List view
     */
    var owner : ListView<T>;

    /**
     *  Application context
     */
    var context : ApplicationContext;

    /**
     *  List view options
     */
    var options : ListViewOptions<T>;

    /**
     *  Constructor
     *  @param options - 
     *  @param context - 
     */
    public function new (owner : ListView<T>, options : ListViewOptions<T>, context : ApplicationContext) {
        super();
        this.context = context;
        this.options = options;
    }
    
    /**
     *  Get item count
     *  @return Int
     */
    @:overload
    override public function getCount() : Int {
        return options.dataSource.length;
    }
    
    /**
     *  Get item
     *  @param position - 
     *  @return T
     */
    @:overload
    override public function getItem(position : Int) : T {
        return options.dataSource.get(position);
    }

    /**
     *  Get item id
     *  @param position - 
     *  @return haxe.Int64
     */
    @:overload
    override public function getItemId(position : Int) : haxe.Int64 {
        return position;
    }

    /**
     *  Get view
     */    
    @:overload
    override public function getView(position : Int, convertView : View, parent : ViewGroup) : View {
        var data = options.dataSource[position];        
        var tag = options.renderItem (data);
        tag.parent = owner;
        return tag.render (context);
    }
}

#end

/**
 *  Tag for listview
 */
class ListView<T> extends Tag {
    public inline static var tagName = "listview";


    /**
     *  Options for listview
     */
    var options : ListViewOptions<T>;

    /**
     *  Constructor
     *  @param options - 
     */
    public function new (options : ListViewOptions<T>) {
        super ("listview", options);
        this.options = options;
    }

    #if android
    /**
     *  Render for android
     *  @param context - 
     *  @return View
     */
    override function renderAndroid (context : ApplicationContext) : NativeView {
        var engine = context.getEngine ();
        var listview = new android.widget.ListView(context.getAndroidActivity ());
        engine.styleView (listview, this);
        
        if (options != null) {
            var adapter = new ListViewAdapter (this, options, context);
            listview.setAdapter (adapter);
        }
        
        return listview;        
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
        var listview = Browser.document.createElement (tagName);
        engine.styleView (listview, this);
        return listview;
    }
    #end
}