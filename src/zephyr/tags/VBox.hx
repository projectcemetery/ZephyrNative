package zephyr.tags;

import android.view.View;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LinearLayout_LayoutParams;
import android.content.Context;

class VBox extends Tag {

    /**
      *  Constructor
      *  @param tags - 
      */
     public function new (?tags : Array<Tag>) {
         super (tags);
     }

     /**
      *  Render page
      *  @param context - 
      *  @return View
      */
     override public function render (context : Context) : View {
        var layout =  new LinearLayout (context);
        layout.setOrientation(LinearLayout.VERTICAL);        
        layout.setWeightSum (1);
        var params = new LinearLayout_LayoutParams (-1,-1);

        var childs = renderChilds (context);
        for (i in childs) {
            layout.addView (i);
        }

        layout.setLayoutParams (params);

        return layout;
     }
}