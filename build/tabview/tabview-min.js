(function(){var b=YAHOO.util,c=b.Dom,i=b.Event,g=window.document,k="active",d="activeIndex",f="activeTab",e="disabled",a="contentEl",h="element",j=function(m,l){l=l||{};if(arguments.length==1&&!YAHOO.lang.isString(m)&&!m.nodeName){l=m;m=l.element||null;}if(!m&&!l.element){m=this._createTabViewElement(l);}j.superclass.constructor.call(this,m,l);};YAHOO.extend(j,b.Element,{CLASSNAME:"yui-navset",TAB_PARENT_CLASSNAME:"yui-nav",CONTENT_PARENT_CLASSNAME:"yui-content",_tabParent:null,_contentParent:null,addTab:function(q,m){var o=this.get("tabs"),s=this._tabParent,l=this._contentParent,n=q.get(h),p=q.get(a),r;if(!o){this._queue[this._queue.length]=["addTab",arguments];return false;}r=this.getTab(m);m=(m===undefined)?o.length:m;o.splice(m,0,q);if(r){s.insertBefore(n,r.get(h));if(p){l.appendChild(p);}}else{s.appendChild(n);if(p){l.appendChild(p);}}if(!q.get(k)){q.set("contentVisible",false,true);}else{this.set(f,q,true);this.set("activeIndex",m,true);}this._initTabEvents(q);},_initTabEvents:function(l){l.addListener(l.get("activationEvent"),l._onActivate,this,l);l.addListener("activationEventChange",l._onActivationEventChange,this,l);},_removeTabEvents:function(l){l.removeListener(l.get("activationEvent"),l._onActivate,this,l);l.removeListener("activationEventChange",l._onActivationEventChange,this,l);},DOMEventHandler:function(q){var r=i.getTarget(q),t=this._tabParent,s=this.get("tabs"),n,m,l;if(c.isAncestor(t,r)){for(var o=0,p=s.length;o<p;o++){m=s[o].get(h);l=s[o].get(a);if(r==m||c.isAncestor(m,r)){n=s[o];break;}}if(n){n.fireEvent(q.type,q);}}},getTab:function(l){return this.get("tabs")[l];},getTabIndex:function(p){var m=null,o=this.get("tabs");for(var n=0,l=o.length;n<l;++n){if(p==o[n]){m=n;break;}}return m;},removeTab:function(n){var m=this.get("tabs").length,l=this.getTabIndex(n);if(n===this.get(f)){if(m>1){if(l+1===m){this.set(d,l-1);}else{this.set(d,l+1);}}else{this.set(f,null);}}this._removeTabEvents(n);this._tabParent.removeChild(n.get(h));this._contentParent.removeChild(n.get(a));this._configs.tabs.value.splice(l,1);n.fireEvent("remove",{type:"remove",tabview:this});},toString:function(){var l=this.get("id")||this.get("tagName");return"TabView "+l;},contentTransition:function(m,l){if(m){m.set("contentVisible",true);}if(l){l.set("contentVisible",false);}},initAttributes:function(l){j.superclass.initAttributes.call(this,l);if(!l.orientation){l.orientation="top";}var n=this.get(h);if(!c.hasClass(n,this.CLASSNAME)){c.addClass(n,this.CLASSNAME);}this.setAttributeConfig("tabs",{value:[],readOnly:true});this._tabParent=this.getElementsByClassName(this.TAB_PARENT_CLASSNAME,"ul")[0]||this._createTabParent();this._contentParent=this.getElementsByClassName(this.CONTENT_PARENT_CLASSNAME,"div")[0]||this._createContentParent();this.setAttributeConfig("orientation",{value:l.orientation,method:function(o){var p=this.get("orientation");this.addClass("yui-navset-"+o);if(p!=o){this.removeClass("yui-navset-"+p);}if(o==="bottom"){this.appendChild(this._tabParent);}}});this.setAttributeConfig(d,{value:l.activeIndex,validator:function(p){var o=true;if(p&&this.getTab(p).get(e)){o=false;}return o;}});this.setAttributeConfig(f,{value:l[f],method:function(p){var o=this.get(f);if(p){p.set(k,true);}if(o&&o!==p){o.set(k,false);}if(o&&p!==o){this.contentTransition(p,o);}else{if(p){p.set("contentVisible",true);}}},validator:function(p){var o=true;if(p&&p.get(e)){o=false;}return o;}});this.on("activeTabChange",this._onActiveTabChange);this.on("activeIndexChange",this._onActiveIndexChange);if(this._tabParent){this._initTabs();}this.DOM_EVENTS.submit=false;this.DOM_EVENTS.focus=false;this.DOM_EVENTS.blur=false;for(var m in this.DOM_EVENTS){if(YAHOO.lang.hasOwnProperty(this.DOM_EVENTS,m)){this.addListener.call(this,m,this.DOMEventHandler);}}},deselectTab:function(l){if(this.getTab(l)===this.get(f)){this.set(f,null);}},selectTab:function(l){this.set(f,this.getTab(l));},_onActiveTabChange:function(n){var l=this.get(d),m=this.getTabIndex(n.newValue);if(l!==m){if(!(this.set(d,m))){this.set(f,n.prevValue);}}},_onActiveIndexChange:function(l){if(l.newValue!==this.getTabIndex(this.get(f))){if(!(this.set(f,this.getTab(l.newValue)))){this.set(d,l.prevValue);}}},_initTabs:function(){var q=c.getChildren(this._tabParent),o=c.getChildren(this._contentParent),n=this.get(d),r,m,s;for(var p=0,l=q.length;p<l;++p){m={};if(o[p]){m.contentEl=o[p];}r=new YAHOO.widget.Tab(q[p],m);this.addTab(r);if(r.hasClass(r.ACTIVE_CLASSNAME)){s=r;}}if(n){this.set(f,this.getTab(n));}else{this._configs[f].value=s;this._configs[d].value=this.getTabIndex(s);}},_createTabViewElement:function(l){var m=g.createElement("div");if(this.CLASSNAME){m.className=this.CLASSNAME;}return m;},_createTabParent:function(l){var m=g.createElement("ul");if(this.TAB_PARENT_CLASSNAME){m.className=this.TAB_PARENT_CLASSNAME;}this.get(h).appendChild(m);return m;},_createContentParent:function(l){var m=g.createElement("div");if(this.CONTENT_PARENT_CLASSNAME){m.className=this.CONTENT_PARENT_CLASSNAME;}this.get(h).appendChild(m);return m;}});YAHOO.widget.TabView=j;})();(function(){var d=YAHOO.util,i=d.Dom,l=YAHOO.lang,m="activeTab",j="label",g="labelEl",q="content",c="contentEl",o="element",p="cacheData",b="dataSrc",h="dataLoaded",a="dataTimeout",n="loadMethod",f="postData",k="disabled",e=function(s,r){r=r||{};if(arguments.length==1&&!l.isString(s)&&!s.nodeName){r=s;s=r.element;}if(!s&&!r.element){s=this._createTabElement(r);}this.loadHandler={success:function(t){this.set(q,t.responseText);},failure:function(t){}};e.superclass.constructor.call(this,s,r);this.DOM_EVENTS={};};YAHOO.extend(e,YAHOO.util.Element,{LABEL_TAGNAME:"em",ACTIVE_CLASSNAME:"selected",HIDDEN_CLASSNAME:"yui-hidden",ACTIVE_TITLE:"active",DISABLED_CLASSNAME:k,LOADING_CLASSNAME:"loading",dataConnection:null,loadHandler:null,_loading:false,toString:function(){var r=this.get(o),s=r.id||r.tagName;return"Tab "+s;},initAttributes:function(r){r=r||{};e.superclass.initAttributes.call(this,r);this.setAttributeConfig("activationEvent",{value:r.activationEvent||"click"});
this.setAttributeConfig(g,{value:r[g]||this._getLabelEl(),method:function(s){s=i.get(s);var t=this.get(g);if(t){if(t==s){return false;}t.parentNode.replaceChild(s,t);this.set(j,s.innerHTML);}}});this.setAttributeConfig(j,{value:r.label||this._getLabel(),method:function(t){var s=this.get(g);if(!s){this.set(g,this._createLabelEl());}s.innerHTML=t;}});this.setAttributeConfig(c,{value:r[c]||document.createElement("div"),method:function(s){s=i.get(s);var t=this.get(c);if(t){if(t===s){return false;}if(!this.get("selected")){i.addClass(s,this.HIDDEN_CLASSNAME);}t.parentNode.replaceChild(s,t);this.set(q,s.innerHTML);}}});this.setAttributeConfig(q,{value:r[q]||this.get(c).innerHTML,method:function(s){this.get(c).innerHTML=s;}});this.setAttributeConfig(b,{value:r.dataSrc});this.setAttributeConfig(p,{value:r.cacheData||false,validator:l.isBoolean});this.setAttributeConfig(n,{value:r.loadMethod||"GET",validator:l.isString});this.setAttributeConfig(h,{value:false,validator:l.isBoolean,writeOnce:true});this.setAttributeConfig(a,{value:r.dataTimeout||null,validator:l.isNumber});this.setAttributeConfig(f,{value:r.postData||null});this.setAttributeConfig("active",{value:r.active||this.hasClass(this.ACTIVE_CLASSNAME),method:function(s){if(s===true){this.addClass(this.ACTIVE_CLASSNAME);this.set("title",this.ACTIVE_TITLE);}else{this.removeClass(this.ACTIVE_CLASSNAME);this.set("title","");}},validator:function(s){return l.isBoolean(s)&&!this.get(k);}});this.setAttributeConfig(k,{value:r.disabled||this.hasClass(this.DISABLED_CLASSNAME),method:function(s){if(s===true){i.addClass(this.get(o),this.DISABLED_CLASSNAME);}else{i.removeClass(this.get(o),this.DISABLED_CLASSNAME);}},validator:l.isBoolean});this.setAttributeConfig("href",{value:r.href||this.getElementsByTagName("a")[0].getAttribute("href",2)||"#",method:function(s){this.getElementsByTagName("a")[0].href=s;},validator:l.isString});this.setAttributeConfig("contentVisible",{value:r.contentVisible,method:function(s){if(s){i.removeClass(this.get(c),this.HIDDEN_CLASSNAME);if(this.get(b)){if(!this._loading&&!(this.get(h)&&this.get(p))){this._dataConnect();}}}else{i.addClass(this.get(c),this.HIDDEN_CLASSNAME);}},validator:l.isBoolean});},_dataConnect:function(){if(!d.Connect){return false;}i.addClass(this.get(c).parentNode,this.LOADING_CLASSNAME);this._loading=true;this.dataConnection=d.Connect.asyncRequest(this.get(n),this.get(b),{success:function(r){this.loadHandler.success.call(this,r);this.set(h,true);this.dataConnection=null;i.removeClass(this.get(c).parentNode,this.LOADING_CLASSNAME);this._loading=false;},failure:function(r){this.loadHandler.failure.call(this,r);this.dataConnection=null;i.removeClass(this.get(c).parentNode,this.LOADING_CLASSNAME);this._loading=false;},scope:this,timeout:this.get(a)},this.get(f));},_createTabElement:function(r){var v=document.createElement("li"),s=document.createElement("a"),u=r.label||null,t=r.labelEl||null;s.href=r.href||"#";v.appendChild(s);if(t){if(!u){u=this._getLabel();}}else{t=this._createLabelEl();}s.appendChild(t);return v;},_getLabelEl:function(){return this.getElementsByTagName(this.LABEL_TAGNAME)[0];},_createLabelEl:function(){var r=document.createElement(this.LABEL_TAGNAME);return r;},_getLabel:function(){var r=this.get(g);if(!r){return undefined;}return r.innerHTML;},_onActivate:function(u,t){var s=this,r=false;d.Event.preventDefault(u);if(s===t.get(m)){r=true;}t.set(m,s,r);},_onActivationEventChange:function(s){var r=this;if(s.prevValue!=s.newValue){r.removeListener(s.prevValue,r._onActivate);r.addListener(s.newValue,r._onActivate,this,r);}}});YAHOO.widget.Tab=e;})();YAHOO.register("tabview",YAHOO.widget.TabView,{version:"@VERSION@",build:"@BUILD@"});