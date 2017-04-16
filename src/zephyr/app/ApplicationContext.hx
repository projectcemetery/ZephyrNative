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

package zephyr.app;

#if android
import android.app.Activity;
#end

import haxe.io.Bytes;
import zephyr.controller.Controller;
import zephyr.tags.Tag;
import zephyr.style.Engine;

/**
 *  Context for native application
 *  Hides some native methods
 */
class ApplicationContext {    

    /**
     *  Owner application
     */
    var owner : INativeApplication;

    /**
     *  Controllers
     */
    var controllers : Map<String, Controller>; 

    /**
     *  Current controller
     */
    var currentController : Controller;

    /**
     *  Constructor
     */
    public function new (owner : INativeApplication) {
        this.owner = owner;
        controllers = new Map<String, Controller> ();
        // Apply default style
        var asset = getAsset ("default.css");
        addStyle (asset.toString ());
    }

    /**
     *  Register controller
     *  @param cls - 
     */
    public function registerController (cls : Class<Controller>) : Void {        
        var controllerName = Type.getClassName (cls);
        var controller : Controller = cast Type.createInstance (cls, []);  
        controller.context = this;      
        controllers[controllerName] = controller;
    }

    /**
     *  Navigate to controller
     *  @param cls - controller class
     */
    public function navigate (cls : Class<Controller>) : Void {
        var name = Type.getClassName (cls);        
        var controller = controllers[name];
        if (currentController != null) currentController.onLeave ();
        controller.onEnter ();
        currentController = controller;
    }

    /**
     *  Set view
     *  @param view - 
     */
    public inline function setView (view : Tag) : Void {        
        var view = view.render (this);
        owner.setView (view);
    }

    /**
     *  Get asset by name
     *  @param name - asset name
     *  @return Bytes
     */
    public inline function getAsset (name : String) : Bytes {
        return owner.getAsset (name);
    }

    /**
     *  Add styles to app
     *  @param text - stylesheet
     */
    public inline function addStyle (text : String) : Void {
        owner.addStyle (text);
    }

    /**
     *  Return engine for styling native views
     *  @return AndroidEngine
     */
    public function getEngine () : Engine {
        return owner.getEngine ();
    }

    #if android
    /**
     *  Return android activity
     *  @return Activity
     */
    public inline function getAndroidActivity () : Activity {
        return cast (owner, Activity);
    }    
    #end
}