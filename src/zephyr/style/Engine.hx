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

package zephyr.style;

import zephyr.tags.Tag;
import zephyr.style.Defs;
import zephyr.app.NativeView;
import zephyr.app.INativeApplication;

class Rule {
	public var id : Int;
	public var cssClass : CssClass;
	public var priority : Int;
	public var style : Style;
	public function new() {
	}
}

@:access(zephyr.tags.Tag)
class Engine {

	/**
	 *  Native application context
	 */
	var context : INativeApplication;

	/**
	 *  All rules
	 */
	var rules : Array<Rule>;

	/**
	 *  Constructor
	 */
	public function new (context : INativeApplication) {
		rules = [];
		this.context = context;
	}

	/**
	 *  Apply style
	 *  @param c - 
	 */
	public function applyClasses (tag : Tag) {
		var style = new Style();
		tag.style = style;
		var rules = [];
		for (rule in this.rules) {
			if(!ruleMatch(rule.cssClass, tag))
				continue;
			rules.push(rule);
		}
		rules.sort(sortByPriority);
		for (rule in rules) {			
			style.apply(rule.style);
		}
	}

	/**
	 *  Sort rules by priority
	 *  @param r1 - 
	 *  @param r2 - 
	 */
	function sortByPriority(r1:Rule, r2:Rule) {
		var dp = r1.priority - r2.priority;
		return dp == 0 ? r1.id - r2.id : dp;
	}

	/**
	 *  Is rule matching
	 *  @param c - 
	 *  @param d - 
	 */
	public static function ruleMatch (css : CssClass, tag : Tag) {
		if (css.pseudoClass != null) {
			var pc = ":" + css.pseudoClass;
			var found = false;
			for (cc in tag.styles)
				if( cc == pc ) {
					found = true;
					break;
				}
			if (!found)
				return false;
		}
		if (css.className != null) {
			if (tag.styles == null )
				return false;
			var found = false;
			for( cc in tag.styles )
				if( cc == css.className ) {
					found = true;
					break;
				}
			if( !found )
				return false;
		}
		if (css.node != null && css.node != tag.name)
			return false;
		if (css.id != null && css.id != tag.id)
			return false;
		if (css.parent != null ) {
			var p = tag.parent;
			while (p != null) {
				if (ruleMatch(css.parent, p))
					break;
				p = p.parent;
			}
			if (p == null)
				return false;
		}
		return true;
	}

	/**
	 *  Add rules to engine from stylesheet text
	 *  @param text - 
	 */
	public function addRules (text : String) {		
		for (r in new Parser().parseRules(text)) {
			var cssClass = r.c;
			var imp = r.imp ? 1 : 0;
			var nids = 0, nothers = 0, nnodes = 0;
			while (cssClass != null) {
				if (cssClass.id != null) nids++;
				if (cssClass.node != null) nnodes++;
				if (cssClass.pseudoClass != null) nothers++;
				if (cssClass.className != null) nothers++;
				cssClass = cssClass.parent;
			}
			var rule = new Rule();
			rule.id = rules.length;
			rule.cssClass = r.c;
			rule.style = r.s;
			rule.priority = (imp << 24) | (nids << 16) | (nothers << 8) | nnodes;
			rules.push(rule);
		}
	}

	#if android
	
	/**
	 *  Return layout params from style unit
	 *  @param u - 
	 *  @return android.widget.LinearLayout.LinearLayout_LayoutParams
	 */
	function getLayoutParams (width : Null<Unit>, height : Null<Unit>) : android.widget.LinearLayout.LinearLayout_LayoutParams {
		var params = new android.widget.LinearLayout.LinearLayout_LayoutParams (-1, -2);

		var screenWidth = context.getScreenWidth ();
		var screenHeight = context.getScreenHeight ();

		trace (screenWidth, screenHeight);

		if (width != null) {
			switch (width) {
				case Px (v) : params.width = Std.int (v);
				case Vh (v) : params.width = Std.int ((screenWidth / 100) * v);
				default: {}
			}
		}

		if (height != null) {					
			switch (height) {
				case Px (v) : params.height = Std.int (v);
				case Vh (v) : params.height = Std.int ((screenHeight / 100) * v);
				default: {}
			}
		}

		return params;
	}

	/**
	 *  Style native view android with tag styles
	 *  @param view - 
	 *  @param tag - 
	 */
	public function styleView (view : NativeView, tag : Tag) {
		applyClasses (tag);
		trace (tag.name);
		trace (tag.style);

		var style = tag.style;
		var layout : android.widget.LinearLayout = null;
		if (Std.is (view, android.widget.LinearLayout)) {
			layout = cast (view, android.widget.LinearLayout);
		}

		if (layout != null) {
			if (style.flexDirection != null) {
				switch (style.flexDirection) {
					case FlexDirection.Row: layout.setOrientation (0);
					case FlexDirection.Column: layout.setOrientation (1);
					default: {}
				}
			}
		}

		var params = getLayoutParams (style.width, style.height);

		if (style.backgroundColor != null) {
			switch (style.backgroundColor) {
				case FillStyle.Color (color): view.setBackgroundColor (color);
				default: {}
			}			
		}

		// align items
		if (tag.parent != null && tag.parent.style.alignItems != null) {
			switch (tag.parent.style.alignItems) {
				case Center: {										
					params.gravity = 17;
				}
				default: {}
			}
		}
		trace (params.width, params.height);
		view.setLayoutParams (params);
				
		if (Std.is (view, android.widget.TextView)) {
			var textView  = cast (view, android.widget.TextView);		
			if (textView != null) {
				if (tag.style.fontSize != null) {
					switch (tag.style.fontSize) {
						case Pt (v): {
							textView.setTextSize (v);
						}
						default: {}
					}
				}
				if (tag.style.color != null) {
					if ((tag.style.color & 0xFF000000) > 0) {
						textView.setTextColor (tag.style.color);
					} else {
						textView.setTextColor (tag.style.color + 0xFF000000);
					}
				}
			}
		}

	}
	#end

	#if web
	/**
	 *  Style native web view with tag styles
	 *  @param view - 
	 *  @param tag - 
	 */
	public function styleView (view : NativeView, tag : Tag) {
		for (s in tag.styles) {
			if (!view.classList.contains (s)) view.classList.add (s);
		}

		if (tag.id != null) {
			view.id = tag.id;
		}
	}
	#end
}

/*
.container {
    justify-content : flex-start | flex-end | center | space-between | space-around;
    flex-direction : row | row-reverse | column | column-reverse;
    align-items: flex-start | flex-end | center | baseline | stretch;
}

.child {
    flex-grow: Int;
    align-self: auto | flex-start | flex-end | center | baseline | stretch;
}*/