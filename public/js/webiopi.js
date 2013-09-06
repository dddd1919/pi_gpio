$(".btn-onoff").click(function(){
  origin_class = $(this).attr("class");
  if (origin_class.match("btn-onoff"))
  {
	  var $this = $(this);
	  $.post("set_pin", { onoff: $this.html(), id: $this.attr("id")}, function(data,status){
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
	$(".switch-left").text("IN");
  $(".switch-right").text("OUT");
	$('div[class="switch has-switch"]').click(function(){
		var $this = $(this)
		var class_name = $this.parent().attr("controller");
		var button_status = $this.children().attr('class');
		var pin_button = $this.parent('td').siblings('td[class="' + class_name + '"]');
		var pin_info = $this.parent('td').siblings('td[info="' + class_name + '"]').children('span').text();
		if (button_status.match('switch-on')){
			$.post("inout_switch", { pin: pin_info, direction:"in"}, function(data,status){
		    if (status == "success" && data == "true"){  //如果设置失败需要把按钮状态还原
			    pin_button.children("button").removeAttr("data-toggle");
					pin_button.children("button").attr('class', 'btn btn-success');
					pin_button.children("button").text('低电位');
			  } else {
			  	$this.children().bootstrapSwitch('toggleState');
			  };
			});
		}	else{
			$.post("inout_switch", { pin: pin_info, direction:"out"}, function(data,status){
		    if (status == "success" && data == "true"){  //如果设置失败需要把按钮状态还原
			    pin_button.children("button").attr("data-toggle", "button");
					pin_button.children("button").attr('class', 'btn btn-success btn-onoff');
					pin_button.children("button").text('低电位');
			  } else {
			  	$this.children().bootstrapSwitch('toggleState');
			  };
			});
		};
	});
});