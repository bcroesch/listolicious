// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function(){ 
  //when the user changes the selected list, load it and display
  $("select#current_list_select").change(function(){
      var list_id = $(this).attr("value");
      $.get('/lists/'+list_id, function(data){
          $("input[type='hidden']#list_id").val(list_id);
      }, "script")
  })
});