<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
  <title>Maintenance</title>
  <meta charset="utf-8">
 
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="/css/bootstrap.min.css">
  <script src="/js/jquery.min.js"></script>
  <script src="/js/bootstrap.min.js"></script>
  <script type="text/javascript" src="/js/jquery.canvasjs.min.js"></script>
</head>
<body>

<div class="container-fluid">
 
  <form autocomplete="off">
 
  <div class="col-md-12">
  <div class="panel panel-primary">
  	<div class="panel-heading"><a href="home" class="btn btn-info btn-sm">
		<span class="glyphicon glyphicon-home"></span> 
	  </a> Transactions Report <label id="totalTransactionAmount" style="color: yellow;"></label>   </div>
  		<div class="panel-body">
			<div id="chartContainer" style="height: 300px; width: 100%;"></div>
	</div>
	</div>
  </form>
  
  
  
<script>
$(document).ready(function(){

	$.ajax({
			  url: "/report/main",		  			  
			  type: "GET",
			  contentType: "application/json",			  
			  beforeSend: function() {		  				
			}
		})
		.done(function(data){
            if(data.length > 0){
				var totalTransactionAmount = 0;
       	        $.each(data,function(index, item){  
					totalTransactionAmount = totalTransactionAmount +  item.y; 
					$('#totalTransactionAmount').empty();
					$('#totalTransactionAmount').append('( Total Balance Amount : '+totalTransactionAmount +' )');
				});
				var options = {
					title: {
						text: "Total Amounts"
					},
					data: [{
							type: "pie",
							startAngle: 45,
							showInLegend: "true",
							legendText: "{label}",
							indexLabel: "{label} ({y})",
							yValueFormatString:"#,##0.#"%"",
							dataPoints: data
					}]
				};

				$("#chartContainer").CanvasJSChart(options);
       	 	}else{
       		                 
           }
     	}).fail(function(jqXHR, textStatus, errorThrown){	  			
			var errorResponseObj = jqXHR.responseJSON;
			var errorMsg = errorResponseObj.errorMessage;		
			
		})
		.always(function(data, textStatus, jqXHR){	
						
		});

	

	



	
});
</script>
</body>
</html>
