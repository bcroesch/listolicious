// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function(){ 
    //when the user changes the selected list, load it and display
    $("select#current_list_select").change(function(){
      var list_id = $(this).attr("value");
      $.get('/lists/'+list_id, function(data){
          $("input[type='hidden']#list_id").val(list_id);
      }, "script")
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
            html:   '<span class="delete-list"><a data-remote="true" data-method="delete" href="/list/'+option.val()+'"><img src="/images/delete.png" /></a></span><span class="text">'+option.text()+'</span>'
        });

        li.click(function(){
            selectBox.html(option.text());
            dropDown.trigger('hide');
            // When a click occurs, we are also reflecting
            // the change on the original select element:
            select.val(option.val());
            select.trigger("change");
            return false;
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
  
});