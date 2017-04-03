
package console;

import sys.FileSystem;

/**
 *  Util for working with files
 */
class FileUtil {

    /**
     *  Copy directory recursive
     */
    public static function copyDir (src : String, dest : String) : Void {
        // ./src ./work

        if (!FileSystem.exists (src)) throw "Source directory not exists";
        //FileSystem.createDirectory ();
    }
}