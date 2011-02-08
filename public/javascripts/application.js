$(function(){ 
    var loading_spinner_small = $("<img class='spinner-small' src='/images/ajax-loader-white.gif' />");
    var show_flash = function(message){
        $(".flash.error").text(message).animate({ top:0 }).delay(1200).animate({ top:-62 });
    }
    
    $.blockUI.defaults = { 
        growlCSS: { 
            width:    '120px', 
            top:      '30px', 
            left:     '', 
            right:    '20px', 
            border:   'none', 
            padding:  '15px', 
            opacity:   0.8, 
            cursor:    null, 
            color:    '#fff', 
            backgroundColor: '#000', 
            '-webkit-border-radius': '10px', 
            '-moz-border-radius':    '10px'
        } 
    }
    
    //show a saving message whenever ajax requests start
    $(document).ajaxStart(function(){
        $.growlUI("Saving");
    });
    
    //show the new list form when create new button is clicked
    $("#create_new_list_button").click(function(){
        $("#new_list_button_container").addClass("hide");
        $("#new_list").removeClass("hide");
        return false; 
    });
    //reverse it when they create the list
    $("#list_submit").click(function(){
        $("#new_list").addClass("hide");
        $("#new_list_button_container").removeClass("hide");
    });
    
    //show the flash if there is one existing on the page already
    if($(".flash.error").text() != ""){
        show_flash($(".flash.error").text());
    }
    
    //hide complete/delete buttons except on hover
    $(".list_item").live("mouseover", function(){
        $(".completed-item-link", this).removeClass("hide");
    }).live("mouseout", function(){
        $(".completed-item-link", this).addClass("hide");
    });
    
    $(".list").live("mouseover", function(){
        $(".fb-share-list", this).removeClass("hide");
    }).live("mouseout", function(){
        $(".fb-share-list", this).addClass("hide");
    });
    
    $(".fb-share-list").live("click", function(){
        if(!$("#fb-access-token").length){
            showFBConnectDialog();
            return;
        }
        
        if($("input#private_toggle").attr("checked")){
            $("<div>Please make the list public before sharing.</div>").dialog();
            return;
        }
        $(".fb-share-dialog #shareable-id").attr("value", $(this).data("list-id"));
        $(".fb-share-dialog #shareable-type").attr("value", "List");
        $(".fb-share-dialog #share-text").val("I created the list \""+$(this).siblings(".list-item-text").text().trim()+"\" on Listolicious.");
        $(".fb-share-dialog").dialog({
            height: 200,
            width: 500
        });
    });
    
    $("#share_list_button").click(function(){
        if(!$("#fb-access-token").length){
            showFBConnectDialog();
            return;
        }
        
        if($("input#private_toggle").attr("checked")){
            $("<div>Please make the list public before sharing.</div>").dialog();
            return;
        }
        $(".fb-share-dialog #shareable-id").attr("value", $("select#current_list_select").attr("value"));
        $(".fb-share-dialog #shareable-type").attr("value", "List");
        $(".fb-share-dialog #share-text").val("I created the list \""+$("select#current_list_select option:selected").text().trim()+"\" on Listolicious.");
        $(".fb-share-dialog").dialog({
            height: 200,
            width: 500
        });
        return false;
    });
    
    
    $("#share-submit").click(function(){
        $("#share-submit").attr("disabled", "true");
        $.ajax({
            type: "POST",
            url: '/shares',
            data: "share[content]="+$("#share-text").val().trim()+"&share[shareable_type]="+$(".fb-share-dialog #shareable-type").attr("value")+"&share[shareable_id]="+$(".fb-share-dialog #shareable-id").attr("value"),
            success: function (data) {
               if(data == "success"){
                   $(".fb-share-dialog").dialog("close");
                   $("<div>Your list was shared to Facebook.</div>").dialog({
                       buttons: {
                           Ok:function() {	$(this).dialog( "close" );}
                       }
                   })
                   $("#share-submit").removeAttr("disabled");
               } 
            },
            error: function (data) {
                show_flash("Error sharing");
                if(data == "failure"){
                    $("#share-submit").removeAttr("disabled");
                }
                else if(data = "facebook_error"){
                    $(".fb-share-dialog").dialog("close");
                    $("#share-submit").removeAttr("disabled");
                    showFBConnectDialog();
                }
            }
        });
        return false;
    })
    
    function showFBConnectDialog(){
        $("#fb_connect_dialog").dialog({ width: 330 });
    }
    
    //when the user changes the selected list, load it and display
    $("select#current_list_select").change(function(){
      window.location.pathname = '/lists/'+$(this).attr("value");
    });
    
    //when they change the public options, save it
    $("#private_toggle").change(function(){
        //$(this).parent().append(loading_spinner_small);
        $.ajax({
            type: "PUT",
            url: '/lists/'+$("select#current_list_select").attr("value"),
            data: "list[private]="+$(this).attr("checked"),
            success: function (data) {
                var test = "test";
            },
            error: function () {
                show_flash("Error saving your list");
            }
        });
    });


    //custom select box   http://tutorialzine.com/2010/11/better-select-jquery-css3/
    var select = $('select#current_list_select');

    var selectBoxContainer = $('<div>',{
        width       : 315,
        className   : 'tzSelect',
        html        : '<div class="selectBox"></div>'
    });

    var dropDown = $('<ul>',{className:'dropDown'});
    var selectBox = selectBoxContainer.find('.selectBox');

    // Looping though the options of the original select element
    select.find('option').each(function(i){
        var option = $(this);
        if(i==select.attr('selectedIndex')){
            selectBox.html(option.text());
        }

        // Creating a dropdown item according to the
        // data-icon and data-html-text HTML5 attributes:
        var li = $('<li>',{
            html:   '<span class="text">'+option.text()+'</span>'
        });
        
        var deleteSpan = $('<span class="delete-list"></span>');
        var deleteLink = $('<a href="/lists/'+option.val()+'?current_list='+select.val()+'"><img src="/images/delete.png" /></a>')
                                    .click(function(){
                                        if (!confirm("Are you sure you want to delete this list?")) {
                                            return false;
                                        }
                                        else{
                                            var link = $(this),
                                                href = link.attr('href'),
                                                method = "delete",
                                                form = $('<form method="post" action="'+href+'"></form>'),
                                                metadata_input = '<input name="_method" value="'+method+'" type="hidden" />';

                                            var csrf_token = $('meta[name=csrf-token]').attr('content'),
                                                csrf_param = $('meta[name=csrf-param]').attr('content');
                                                
                                            if (csrf_param != null && csrf_token != null) {
                                              metadata_input += '<input name="'+csrf_param+'" value="'+csrf_token+'" type="hidden" />';
                                            }

                                            form.hide()
                                                .append(metadata_input)
                                                .appendTo('body');

                                            form.submit();
                                        }
                                        return false;
                                    });
        
        deleteSpan.append(deleteLink);
        li.prepend(deleteSpan);

        li.click(function(event){
            selectBox.html(option.text());
            dropDown.trigger('hide');
            // When a click occurs, we are also reflecting
            // the change on the original select element:
            select.val(option.val());
            select.trigger("change");
            //return false;
        }).mouseover(function(){
            $('span.delete-list', this).css({display: 'block'});
        }).mouseout(function(){
            $('span.delete-list', this).css({display: 'none'});
        });

        dropDown.append(li);
    });

    selectBoxContainer.append(dropDown.hide());
    select.hide().after(selectBoxContainer);

    // Binding custom show and hide events on the dropDown:
    dropDown.bind('show',function(){
        if(dropDown.is(':animated')){
            return false;
        }

        selectBox.addClass('expanded');
        dropDown.slideDown();

    }).bind('hide',function(){
        if(dropDown.is(':animated')){
            return false;
        }

        selectBox.removeClass('expanded');
        dropDown.slideUp();
        
    }).bind('toggle',function(){
        if(selectBox.hasClass('expanded')){
            dropDown.trigger('hide');
        }
        else dropDown.trigger('show');
    });

    selectBox.click(function(){
        dropDown.trigger('toggle');
        return false;
    });

    // If we click anywhere on the page, while the
    // dropdown is shown, it is going to be hidden:
    $(document).click(function(){
        dropDown.trigger('hide');
    });
  
    //if($("#adsense").length > 0){
    //    $("#adsense").html('<div><script type="text/javascript"><!-- google_ad_client = "ca-pub-3189710085578029"; /* listolicious */ google_ad_slot = "7844847673"; google_ad_width = 200; google_ad_height = 200; //--> </script>	<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"> </script> </div> <div> <script type="text/javascript"><!-- google_ad_client = "ca-pub-3189710085578029"; /* listolicious bottom */ google_ad_slot = "4571154962"; google_ad_width = 200; google_ad_height = 200; //--> </script> <script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"> </script> </div>');
    //}
});
