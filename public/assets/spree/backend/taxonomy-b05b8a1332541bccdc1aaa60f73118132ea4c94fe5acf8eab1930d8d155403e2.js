(function(){var e,r,t,n,o,a;e=function(){return $.jstree.rollback(last_rollback),$("#ajax_error").show().html("<strong>"+server_error+"</strong><br />"+taxonomy_tree_error)},n=function(r,t){var n,o,a,s,p;return n=t.rlbk,s=t.rslt.cp,a=t.rslt.o,o=t.rslt.np,p=Spree.url(base_url).clone(),p.setPath(p.path()+"/"+a.prop("id")),$.ajax({type:"POST",dataType:"json",url:p.toString(),data:{_method:"put","taxon[parent_id]":o.prop("id"),"taxon[child_index]":s,token:Spree.api_key},error:e}),!0},r=function(r,t){var n,o,a,s,p;return n=t.rlbk,s=t.rslt.obj,o=t.rslt.name,p=t.rslt.position,a=t.rslt.parent,$.ajax({type:"POST",dataType:"json",url:base_url.toString(),data:{"taxon[name]":o,"taxon[parent_id]":a.prop("id"),"taxon[child_index]":p,token:Spree.api_key},error:e,success:function(e){return s.prop("id",e.id)}})},o=function(r,t){var n,o,a,s;return n=t.rlbk,a=t.rslt.obj,o=t.rslt.new_name,s=Spree.url(base_url).clone(),s.setPath(s.path()+"/"+a.prop("id")),$.ajax({type:"POST",dataType:"json",url:s.toString(),data:{_method:"put","taxon[name]":o,token:Spree.api_key},error:e})},t=function(r,t){var n,o,a,s;return o=t.rlbk,a=t.rslt.obj,n=base_url.clone(),n.setPath(n.path()+"/"+a.prop("id")),s=confirm(Spree.translations.are_you_sure_delete),s?$.ajax({type:"POST",dataType:"json",url:n.toString(),data:{_method:"delete",token:Spree.api_key},error:e}):($.jstree.rollback(o),o=null)},a="undefined"!=typeof exports&&null!==exports?exports:this,a.setup_taxonomy_tree=function(e){var s;return s=$("#taxonomy_tree"),void 0!==e?(a.base_url=Spree.url(Spree.routes.taxonomy_taxons_path),$.ajax({url:Spree.url(base_url.path().replace("/taxons","/jstree")).toString(),data:{token:Spree.api_key},success:function(e){var a,p;return p=null,a={json_data:{data:e,ajax:{url:function(e){return Spree.url(base_url.path()+"/"+e.prop("id")+"/jstree?token="+Spree.api_key).toString()}}},themes:{theme:"spree",url:Spree.url(Spree.routes.jstree_theme_path)},strings:{new_node:new_taxon,loading:Spree.translations.loading+"..."},crrm:{move:{check_move:function(e){var r,t,n;return n=e.cp,t=e.o,r=e.np,r&&"root"!==t.prop("rel")?"taxonomy_tree"!==r.prop("id")||0!==n:!1}}},contextmenu:{items:function(e){return taxon_tree_menu(e,this)}},plugins:["themes","json_data","dnd","crrm","contextmenu"]},s.jstree(a).bind("move_node.jstree",n).bind("remove.jstree",t).bind("create.jstree",r).bind("rename.jstree",o).bind("loaded.jstree",function(){return $(this).jstree("core").toggle_node($(".jstree-icon").first())})}}),s.on("dblclick","a",function(){return s.jstree("rename",this)}),$(document).keypress(function(e){return 13===e.keyCode?e.preventDefault():void 0})):void 0}}).call(this);