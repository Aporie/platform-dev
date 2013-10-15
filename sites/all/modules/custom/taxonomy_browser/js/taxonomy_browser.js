/**
 * @file
 * create a jstree object for the taxonomy_browser module
 *  
 */

(function($){
$(document).ready(function(){
	$("#tb_browser_tree").jstree({ 
		"themes" : {
			"theme" : "ec-default",
			"dots" : true,
			"icons" : true
		},
		"cookies": { "tb_browser_tree": { "path": "/"} }, 
		"plugins" : [ "themes", "html_data", "cookies" ],
	});

  $("#tb_browser_tree-responsive").jstree({ 
    "themes" : {
      "theme" : "ec-default",
      "dots" : true,
      "icons" : true
    },
    "cookies": { "tb_browser_tree": { "path": "/"} }, 
    "plugins" : [ "themes", "html_data", "cookies" ],
  });  

});
})(jQuery);
