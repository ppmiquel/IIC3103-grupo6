(function(){$(document).ready(function(){var t;return window.productTemplate=Handlebars.compile($("#product_template").text()),$("#taxon_products").sortable({handle:".js-sort-handle"}),t=function(t){return Select2.util.escapeMarkup(t.pretty_name)},$("#taxon_products").on("sortstop",function(t,e){return $.ajax({url:Spree.routes.classifications_api,method:"PUT",dataType:"json",data:{token:Spree.api_key,product_id:e.item.data("product-id"),taxon_id:$("#taxon_id").val(),position:e.item.index()}})}),$("#taxon_id").length>0&&$("#taxon_id").select2({dropdownCssClass:"taxon_select_box",placeholder:Spree.translations.find_a_taxon,ajax:{url:Spree.routes.taxons_search,datatype:"json",data:function(t,e){return{per_page:50,page:e,without_children:!0,token:Spree.api_key,q:{name_cont:t}}},results:function(t,e){var a;return a=e<t.pages,{results:t.taxons,more:a}}},formatResult:t,formatSelection:t}),$("#taxon_id").on("change",function(t){var e;return e=$("#taxon_products"),$.ajax({url:Spree.routes.taxon_products_api,data:{id:t.val,token:Spree.api_key},success:function(t){var a,r,o,n,s,i,u,d,p;if(e.empty(),0===t.products.length)return $("#taxon_products").html("<div class='alert alert-info'>"+Spree.translations.no_results+"</div>");for(i=t.products,d=[],a=0,o=i.length;o>a;a++){if(s=i[a],void 0!==s.master.images[0]&&void 0!==s.master.images[0].small_url)s.image=s.master.images[0].small_url;else for(u=s.variants,r=0,n=u.length;n>r;r++)if(p=u[r],void 0!==p.images[0]&&void 0!==p.images[0].small_url){s.image=p.images[0].small_url;break}d.push(e.append(productTemplate({product:s})))}return d}})}),$("#taxon_products").on("click",".js-delete-product",function(){var t,e,a,r,o,n;return t=$("#taxon_id").val(),e=$(this).parents(".product"),a=e.data("product-id"),o=String(e.data("taxons")).split(",").map(Number),r=o.indexOf(parseFloat(t)),o.splice(r,1),n=o.length>0?o:[""],$.ajax({url:Spree.routes.products_api+"/"+a,data:{product:{taxon_ids:n},token:Spree.api_key},type:"PUT",success:function(){return e.fadeOut(400,function(){return e.remove()})}})}),$("#taxon_products").on("click",".js-edit-product",function(){var t,e;return t=$(this).parents(".product"),e=t.data("product-id"),window.location=Spree.routes.edit_product(e)}),$(".variant_autocomplete").variantAutocomplete()})}).call(this);