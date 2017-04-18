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

class Rule {
	public var id : Int;
	public var c : CssClass;
	public var priority : Int;
	public var s : Style;
	public function new() {
	}
}

@:access(zephyr.tags.Tag)
class Engine {

	/**
	 *  All rules
	 */
	var rules : Array<Rule>;

	/**
	 *  Constructor
	 */
	public function new() {
		rules = [];
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
			if(!ruleMatch(rule.c, tag))
				continue;
			rules.push(rule);
		}
		rules.sort(sortByPriority);
		for(rule in rules )
			style.apply(rule.s);
		if(tag.customStyle != null )
			style.apply(tag.customStyle);
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
			for( cc in tag.styles )
				if( cc == pc ) {
					found = true;
					break;
				}
			if( !found )
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
		for( r in new Parser().parseRules(text) ) {
			var c = r.c;
			var imp = r.imp ? 1 : 0;
			var nids = 0, nothers = 0, nnodes = 0;
			while( c != null ) {
				if( c.id != null ) nids++;
				if( c.node != null ) nnodes++;
				if( c.pseudoClass != null ) nothers++;
				if( c.className != null ) nothers++;
				c = c.parent;
			}
			var rule = new Rule();
			rule.id = rules.length;
			rule.c = r.c;
			rule.s = r.s;
			rule.priority = (imp << 24) | (nids << 16) | (nothers << 8) | nnodes;
			rules.push(rule);
		}
	}

	#if android
	/**
	 *  Style native view android with tag styles
	 *  @param view - 
	 *  @param tag - 
	 */
	public function styleView (view : NativeView, tag : Tag) {
		
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