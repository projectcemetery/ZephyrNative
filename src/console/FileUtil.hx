
package console;

import sys.FileSystem;
import haxe.io.Path;
import sys.io.File;

/**
 *  Util for working with files
 */
class FileUtil {

    /**
     *  Copy directory recursive
     */
    public static function copyDir (src : String, dest : String) : Void {
        var fullSrc = FileSystem.absolutePath (src);                
        var fullDest = FileSystem.absolutePath (dest);        
        
        if (!FileSystem.exists (fullSrc)) throw "Source directory not exists";
        if (!FileSystem.exists (fullDest)) FileSystem.createDirectory (fullDest);

        var allFiles = FileSystem.readDirectory (fullSrc);        
        for (file in allFiles) {            
            var srcPath = Path.join ([ fullSrc, file ]);
            var dstPath = Path.join ([ fullDest, file ]);            
            if (FileSystem.isDirectory (srcPath)) {
                copyDir (srcPath, dstPath);
            } else {
                File.copy (srcPath, dstPath);
            }
        }
    }
}