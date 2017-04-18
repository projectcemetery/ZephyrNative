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

import zephyr.style.Defs;

class Style {

	/**
	 *  Direction of flec component
	 */
	public var flexDirection : Null<FlexDirection>;

	/**
	 *  Content justify
	 */
	public var justifyContent : Null<JustifyContent>;

	public var fontName : Null<String>;
	public var fontSize : Null<Float>;
	public var color : Null<Int>;
	public var backgroundColor : Null<FillStyle>;
	public var borderRadius : Null<Float>;
	public var borderSize : Null<Float>;
	public var borderColor : Null<FillStyle>;
	public var paddingTop : Null<Float>;
	public var paddingLeft : Null<Float>;
	public var paddingRight : Null<Float>;
	public var paddingBottom : Null<Float>;
	public var width : Null<Float>;
	public var height : Null<Float>;
	public var marginTop : Null<Float>;
	public var marginLeft : Null<Float>;
	public var marginRight : Null<Float>;
	public var marginBottom : Null<Float>;	
	public var textAlign : Null<TextAlign>;	

	/**
	 *  Constructor
	 */
	public function new() {
	}

	/**
	 *  Apply style to this
	 *  @param s - 
	 */
	public function apply( s : Style ) {
		if( s.fontName != null ) fontName = s.fontName;
		if( s.fontSize != null ) fontSize = s.fontSize;
		if( s.color != null ) color = s.color;
		if( s.backgroundColor != null ) backgroundColor = s.backgroundColor;
		if( s.borderRadius != null ) borderRadius = s.borderRadius;
		if( s.borderSize != null ) borderSize = s.borderSize;
		if( s.borderColor != null ) borderColor = s.borderColor;
		if( s.paddingLeft != null ) paddingLeft = s.paddingLeft;
		if( s.paddingRight != null ) paddingRight = s.paddingRight;
		if( s.paddingTop != null ) paddingTop = s.paddingTop;
		if( s.paddingBottom != null ) paddingBottom = s.paddingBottom;		
		if( s.width != null ) width = s.width;
		if( s.height != null ) height = s.height;
		if( s.marginLeft != null ) marginLeft = s.marginLeft;
		if( s.marginRight != null ) marginRight = s.marginRight;
		if( s.marginTop != null ) marginTop = s.marginTop;
		if( s.marginBottom != null ) marginBottom = s.marginBottom;		
		if( s.textAlign != null ) textAlign = s.textAlign;
	}

	/**
	 *  Set padding
	 *  @param v - 
	 */
	public function padding( v : Float ) {
		this.paddingTop = v;
		this.paddingLeft = v;
		this.paddingRight = v;
		this.paddingBottom = v;
	}

	/**
	 *  Set margin
	 *  @param v - 
	 */
	public function margin( v : Float ) {
		this.marginTop = v;
		this.marginLeft = v;
		this.marginRight = v;
		this.marginBottom = v;
	}

	/**
	 *  Transform style to string
	 */
	public function toString() {
		var fields = [];
		for( f in Type.getInstanceFields(Style) ) {
			var v : Dynamic = Reflect.field(this, f);
			if( v == null || Reflect.isFunction(v) || f == "toString" || f == "apply" )
				continue;
			if( f.toLowerCase().indexOf("color") >= 0 && Std.is(v,Int) )
				v = "#" + StringTools.hex(v, 6);
			fields.push(f + ": " + v);
		}
		return "{" + fields.join(", ") + "}";
	}

}