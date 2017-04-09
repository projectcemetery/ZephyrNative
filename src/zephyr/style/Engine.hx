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
	public function applyClasses( c : Tag) {
		var s = new Style();
		c.style = s;
		var rules = [];
		for( r in this.rules ) {
			if( !ruleMatch(r.c, c) )
				continue;
			rules.push(r);
		}
		rules.sort(sortByPriority);
		for( r in rules )
			s.apply(r.s);
		if( c.customStyle != null )
			s.apply(c.customStyle);
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
	public static function ruleMatch( c : CssClass, d : Tag) {
		if( c.pseudoClass != null ) {
			var pc = ":" + c.pseudoClass;
			var found = false;
			for( cc in d.styles )
				if( cc == pc ) {
					found = true;
					break;
				}
			if( !found )
				return false;
		}
		if( c.className != null ) {
			if( d.styles == null )
				return false;
			var found = false;
			for( cc in d.styles )
				if( cc == c.className ) {
					found = true;
					break;
				}
			if( !found )
				return false;
		}
		if( c.node != null && c.node != d.name )
			return false;
		if( c.id != null && c.id != d.id )
			return false;
		if( c.parent != null ) {
			var p = d.parent;
			while( p != null ) {
				if( ruleMatch(c.parent, p) )
					break;
				p = p.parent;
			}
			if( p == null )
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