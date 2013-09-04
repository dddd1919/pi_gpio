$(".btn-onoff").click(function(){
  origin_class = $(this).attr("class");
  if (origin_class.match("btn-onoff"))
  {
	  var $this = $(this);
	  $.post("set_pin", { onoff: $this.html(), id: $this.parent('div').attr("id")}, function(data,status){
	    if ($this.html() == data)  //如果设置失败需要把按钮状态还原
	    {
	      $this.attr("class", origin_class)
	    }
	    else
	    {
	      $this.html(data);
	    }          
	  });
	};
});

$(document).ready(function(){
	$('div[class="switch has-switch"]').click(function(){
		var class_name = $(this).parent().attr("controller");
		var button_status = $(this).children().attr('class');
		var pin_button = $(this).parent('td').siblings('td[class="' + class_name + '"]')
		if (button_status.match('switch-on')){
			pin_button.children("div").removeAttr("data-toggle");
			pin_button.children("div").children('button').attr('class', 'btn btn-mini btn-success');
			pin_button.children("div").children('button').text('低电位');
			console.log(pin_button);
		}
		else{
			pin_button.children("div").attr("data-toggle", "buttons-checkbox");
			pin_button.children("div").children('button').attr('class', 'btn btn-mini btn-success btn-onoff');
			pin_button.children("div").children('button').text('低电位');
			console.log(pin_button);
		}		
	});

});
