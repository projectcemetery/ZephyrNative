package zephyr.tags;

import zephyr.tags.textview.*;
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
    public static function vbox (?options : TagOptions, ?childs : Array<Tag>) : VBox {
        return new VBox (childs);
    }

    /**
     *  Add toolbar
     *  @param childs - 
     *  @return Toolbar
     */
/*    public static function toolbar () : Toolbar {
        return new Toolbar ();
    }

    public static function listview<T> (?options : ListViewOptions<T>) : Listview<T> {
        return new Listview (options);
    }

    public static function imagebutton () : Imagebutton {
        return new Imagebutton ();
    }
*/
    /**
     *  Create TextView tag
     *  @param options - 
     *  @return TextView
     */
    public static function textview (options : TextViewOptions) : TextView {
        return new TextView (options);
    }
}