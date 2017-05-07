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

package zephyr.asset;

import haxe.io.Bytes;
import haxe.io.Path;

/**
 *  Asset info and data
 */
class Asset {

    /**
     *  Asset type
     */
    public var type : AssetType;

    /**
     *  Asset data
     */
    public var data : Bytes;

    /**
     *  Get asset type by file name
     *  @param name - 
     */
    public static function getAssetType (fileName : String) : AssetType {
        var ext = Path.extension (fileName);
        switch (ext) {
            case "png": return AssetType.Raster (RasterType.Png);
            case "jpg": return AssetType.Raster (RasterType.Jpeg);
            case "txt": return AssetType.Text (TextType.Txt);
            case "json": return AssetType.Text (TextType.Json);
            case "xml": return AssetType.Text (TextType.Xml);
            case "svg": return AssetType.Vector (VectorType.Svg);
            case "pdf": return AssetType.Vector (VectorType.Pdf);
            default: {}
        }

        return AssetType.Binary;
    }

    /**
     *  Constructor
     *  @param type - asset type
     *  @param data - asset bytes data
     */
    public function new (type : AssetType, data : Bytes) {
        this.type = type;
        this.data = data;
    }
}