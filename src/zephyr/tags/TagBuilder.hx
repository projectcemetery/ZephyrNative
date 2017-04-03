package zephyr.tags;

/**
 *  Helper for markup
 */
class TagBuilder {

    /**
     *  Add vertical box
     *  @param childs - 
     *  @return VBox
     */
    public static function vbox (?childs : Array<Tag>) : VBox {
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

    public static function textview (options : TextViewOptions) : Textview {
        return new Textview (options);
    }*/
}