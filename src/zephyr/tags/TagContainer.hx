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

/**
 *  Container of tags
 */
class TagContainer {

    /**
     *  All tags
     */
    var childs : Array<Tag>;

    /**
     *  Constructor
     *  @param tags - 
     */
    public function new (?tags : Array<Tag>) {
        childs = tags;
    }

    /**
     *  Find tag by id recursive
     *  @param id - 
     *  @return Tag
     */
    public function findById (id : String) : Tag {
        if (id.length < 1) return null;
        
        // First search in childs
        for (t in childs) {            
            if (t.id == id) return t;
        }

        // Second search in child childs
        for (t in childs) {
            var it = t.findById (id);
            if (it != null) return it;
        }

        return null;
    }

    /**
     *  Find all tags by css style names
     *  @param styleNames - 
     */
    public function findByCss (styleNames : Array<String>) : Array<Tag> {        
        var res = new Array<Tag> ();
        for (t in childs) {
            var styles = t.findByCss (styleNames);
            if (styles != null) res = res.concat (styles);
        }

        return if (res.length > 0) res else null;
    }
}