package zephyr.tags;

import zephyr.tags.box.*;
import zephyr.tags.textview.*;
import zephyr.tags.toolbar.*;
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

    /**
     *  Add toolbar
     *  @param childs - 
     *  @return Toolbar
     */
    public static function toolbar (?options : ToolbarOptions) : Toolbar {
        return new Toolbar (options);
    }

  /*  public static function listview<T> (?options : ListViewOptions<T>) : Listview<T> {
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