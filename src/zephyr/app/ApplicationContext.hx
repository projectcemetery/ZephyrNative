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

import zephyr.controller.Controller;
import zephyr.tags.Tag;

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
    public function setView (view : Tag) : Void {
        var view = view.render (this);
        owner.setView (view);
    }

    #if android
    /**
     *  Return android activity
     *  @return Activity
     */
    public function getAndroidActivity () : Activity {
        return cast (owner, Activity);
    }
    #end
}