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
  <style>
    .delete-confirm-modal .modal-dialog {
      position: fixed;
      top: 16px;
      left: 50%;
      transform: translateX(-50%) !important;
      margin: 0;
      width: calc(100% - 20px);
      max-width: 420px;
    }
    .delete-confirm-modal {
      overflow: hidden !important;
    }
    .delete-confirm-modal .modal-content {
      overflow: hidden;
    }
    .delete-confirm-modal .modal-footer .btn {
      min-width: 90px;
    }
    @media (max-width: 767px) {
      .delete-confirm-modal .modal-dialog {
        top: 10px;
        width: calc(100% - 16px);
      }
    }
  </style>
</head>
<body>

<div class="container-fluid">
 
  <form autocomplete="off">
 
  <div class="col-md-12">
  <div class="panel panel-primary">
  	<div class="panel-heading"><a href="home" class="btn btn-info btn-sm">
		<span class="glyphicon glyphicon-home"></span> 
	  </a> Maintenance </div>
  		<div class="panel-body">
			<div class="form-group col-md-3">
				<label for="memberId">Member Name</label>
				<select class="form-control" id="memberId" name="memberId">
				 <option value="">--Select--</option>				 		 		    			    
				</select>
			  </div>
			
		    
		    <div class="form-group col-md-3">
		      <label for="year">Year</label>
		      <select class="form-control" id="year" name="year">
		       <option value="">--Select--</option>		       
			   <option value="2026">2026</option>
			  </select>
		    </div>

			<div class="form-group col-md-3">
				<label for="month">Month</label>
				<select class="form-control" id="month" name="month">
				 <option value="">--Select--</option>
				 <option value="January">January</option>
				 <option value="February">February</option>	
				 <option value="March">March</option>
				 <option value="April">April</option>	
				 <option value="May">May</option>	
				 <option value="June">June</option>	
				 <option value="July">July</option>	
				 <option value="August">August</option>	
				 <option value="September">September</option>			    			    
				 <option value="October">October</option>	
				 <option value="November">November</option>	
				 <option value="December">December</option>	
				</select>
			  </div>
		

			<div class="form-group col-md-3">
				<label for="amount">Amount</label>
				<input type="number" class="form-control" id="amount"  name="amount" value="300">
			</div>

			<div class="form-group col-md-3">
				<label for="month">Status</label>
				<select class="form-control" id="status" name="status">
				 <option value="">--Select--</option>
				 <option value="Paid">Paid</option>				 		 
				</select>
			  </div>
		    
		    
			<input type="hidden" class="form-control" id="id"  name="id">

			<div class="form-group col-md-12">
				<button type="button" class="btn btn-success" id="save">Save</button>   
				<button type="button" class="btn btn-primary" id="search">Search</button>
				<button type="button" class="btn btn-info" id="update">Update</button>
				
				<a id="downloadExcel" href="" class="btn btn-info" role="button">Download Excel</a>


				
		    	    
		  </div>
	</div>
	</div>
  </form>
  
  

    
	<div class="col-md-12" id="investorListDiv">
	<div class="panel panel-primary">
		<div class="panel-heading">Maintenance Details <label id="totalMembershipAmount" style="color: yellow;"></label></div>
		<div class="panel-body"> 
			<div class="table-responsive">          
				<table class="table-bordered table-striped table table-hover documentUpload" >
					<thead>
					<tr>
						<th>Sl.No</th>
						<th>Member Name</th>
						<th>Year</th>
						<th>Month</th>
						<th>Amount</th>	
						<th>Status</th>						
						<th>Actions</th>
						
					</tr>
					</thead>  
					<tbody>    
				<tbody id="tbdata"> 
				</tbody>					
			</div>
			</div>
			</div>
			</div>

		

	</div>
<script>
$(document).ready(function(){

	$('#update').hide();

	function showDeleteConfirmModal(message, onConfirm) {
		$("#deleteConfirmMessage").text(message || "Are you sure you want to delete?");
		$("#deleteConfirmOkBtn")
			.off("click.deleteConfirm")
			.on("click.deleteConfirm", function () {
				$("#deleteConfirmModal").modal("hide");
				if (typeof onConfirm === "function") {
					onConfirm();
				}
			});

		$("#deleteConfirmModal")
			.off("hidden.bs.modal.deleteConfirm")
			.on("hidden.bs.modal.deleteConfirm", function () {
				$("#deleteConfirmOkBtn").off("click.deleteConfirm");
			});

		$("#deleteConfirmModal").modal("show");
	}

	$.ajax({
			  url: "/member/fetch",		  			  
			  type: "GET",
			  contentType: "application/json",			  
			  beforeSend: function() {		  				
			}
		})
		.done(function(data){
            if(data.length>0){  
				var memberName = "";       	   
       	        $.each(data,function(index, item){ 				
					memberName += "<option value = '"+item.memberId+'~'+item.firstName+' '+ item.lastName+"'>" + item.firstName+' '+ item.lastName+ " </option>";                    
     		    });	
				 $("#memberId").append(memberName);			  
       	 	}
     	}).fail(function(jqXHR, textStatus, errorThrown){	  			
			var errorResponseObj = jqXHR.responseJSON;
			var errorMsg = errorResponseObj.errorMessage;		
			
		})
		.always(function(data, textStatus, jqXHR){	
						
		});

	

    $("#save").click(function(){    
        var memberId = $("#memberId").val();
		var memberName;
		if(memberId != null && memberId != undefined) {
			const myArray = memberId.split("~");
			memberId = myArray[0];
			memberName = myArray[1];

		}
        var year = $("#year").val();
        var month = $("#month").val();
        var amount = $("#amount").val();
		var status = $("#status").val();

		
        var payload={
        		'memberId':memberId,
        		'year':year,
        		'month':month,
        		'amount':amount,
				'memberName': memberName,
				'status':status      		
         };
		 if(payload.amount == '' || payload.amount == null || payload.amount == undefined ||
		 payload.memberId == '' || payload.memberId == null || payload.memberId == undefined ||
		 payload.year == '' || payload.year == null || payload.year == undefined ||
		 payload.month == '' || payload.month == null || payload.month == undefined ||
		 payload.memberName == '' || payload.memberName == null || payload.memberName == undefined ||
		payload.status == '' || payload.status == null || payload.status == undefined) {
			alert('Fill all fields in form');
			return false;

		 }

        $.ajax({
			  url: "/maintenance/save",		  			  
			  type: "POST",
			  contentType: "application/json",
			  dataType: "json",		
			  data:JSON.stringify(payload),
			  beforeSend: function() {	
			}
		})
		.done(function(data){
            alert('Maintenance saved Successfully');
			$("#memberId").val('');
			$("#year").val('');
			$("#month").val('');
			$("#status").val('');
     	}).fail(function(jqXHR, textStatus, errorThrown){	  			
			var errorResponseObj = jqXHR.responseJSON;
			var errorMsg = errorResponseObj.errorMessage;	
			alert(errorMsg);	
			
		})
		.always(function(data, textStatus, jqXHR){	
			$("#search").click();
		
		});
	
    });

	

	$("#search").click(function(){    
        
        var memberId = $("#memberId").val();
		var year = $("#year").val();
		var memberName;
		if(memberId != null && memberId != undefined) {
			const myArray = memberId.split("~");
			memberId = myArray[0];
			memberName = myArray[1];

		}
		var url ='';
		if(memberId == '' || memberId == null || memberId == undefined) {
			url = "/maintenance/fetch";
		}  else if(memberId != null && memberId != undefined && (year == '' || year == null || year == undefined)){
			url = "/maintenance/fetch/"+memberId;
		} else {
			url = "/maintenance/fetch/"+memberId+"/"+year;
		}
        
        $.ajax({
			  url: url,		  			  
			  type: "GET",
			  contentType: "application/json",			  
			  beforeSend: function() {		  				
			}
		})
		.done(function(data){
            if(data.length>0){
         	    var trHTML = '';
       		   $('#tbdata').empty();
			   var totalMembershipAmount = 0;
       	        $.each(data,function(index, item){   
					        	
       	        	 var insno= index+1; 
						totalMembershipAmount = totalMembershipAmount +  item.amount; 
						        	 
     		         trHTML += '<tr><td>'+insno+'</td><td>'+item.memberName+'</td><td>'+item.year+'</td><td>'
						+item.month+'</td><td>'+item.amount+'</td><td>'+item.status+'</td><td> <button type="button" class="btn btn-success btn-sm" value="'+item.id+'" id="edit"><span class="glyphicon">&#xe065;</span></button> '+
								'<button type="button" class="btn btn-danger btn-sm" value="'+item.id+'" id="delete"><span class="glyphicon">&#xe020;</span></button> <button type="button" class="btn btn-info btn-sm" value="'+item.id+'" id="print"><span class="glyphicon glyphicon-print"></span></button></td></tr>';
     		      }); 
				   $('#totalMembershipAmount').empty();
				   $('#totalMembershipAmount').append('( Total Maintenance Amount : '+totalMembershipAmount +' )');
				   
       	          $('#tbdata').append(trHTML);
       	          $("#investorListDiv").show();
       	 }else{
       		    var trHTML = '';
     		    $('#tbdata').empty();
     		  	trHTML += '<td rowspan="6" style="color: Red;">No Search Found</td>';
  		        $('#tbdata').append(trHTML);
     	        $("#investorListDiv").show(); 
				 totalMembershipAmount = 0;
				 $('#totalMembershipAmount').empty();
				   $('#totalMembershipAmount').append('( Total Maintenance Amount : '+totalMembershipAmount +' )');                
           }
     	}).fail(function(jqXHR, textStatus, errorThrown){	  			
			var errorResponseObj = jqXHR.responseJSON;
			var errorMsg = errorResponseObj.errorMessage;		
			
		})
		.always(function(data, textStatus, jqXHR){	
						
		});

		/////



		
	
    });

	$('body').on('click', '#delete', function() {  
		
        var id = $(this).val();
		showDeleteConfirmModal("Delete this maintenance record?", function () {
			$.ajax({
				  url: "/maintenance/delete/"+id,		  			  
				  type: "GET",
				  contentType: "application/json",			  
				  beforeSend: function() {		  				
				}
			})
			.done(function(data){
	            alert('Member Deleted Successfully');
				
	     	}).fail(function(jqXHR, textStatus, errorThrown){	  			
				var errorResponseObj = jqXHR.responseJSON;
				var errorMsg = errorResponseObj.errorMessage;	
				alert(errorMsg);
				
			})
			.always(function(data, textStatus, jqXHR){	
				$("#search").click();		
			});
		});
	
    });

	$('body').on('click', '#edit', function() {  
		$('#save').hide();
		$('#search').hide();
		$('#downloadExcel').hide();
		$('#update').show();
		

        var id = $(this).val();   
        $.ajax({
			  url: "/maintenance/edit/"+id,		  			  
			  type: "GET",
			  contentType: "application/json",			  
			  beforeSend: function() {		  				
			}
		})
		.done(function(data){
			$("#memberId").val(data.memberId+'~'+data.memberName);
			$("#year").val(data.year);
			$("#month").val(data.month);
			$("#amount").val(data.amount);
			$("#id").val(data.id);
			$("#status").val(data.status);
			
			
     	}).fail(function(jqXHR, textStatus, errorThrown){	  			
			var errorResponseObj = jqXHR.responseJSON;
			var errorMsg = errorResponseObj.errorMessage;
			$('#update').hide();
			$('#save').show();
			$('#search').show();
		})
		.always(function(data, textStatus, jqXHR){	
			
		});
	
    });
	

	
    $("#update").click(function(){    
		var memberId = $("#memberId").val();
		var memberName;
		if(memberId != null && memberId != undefined) {
			const myArray = memberId.split("~");
			memberId = myArray[0];
			memberName = myArray[1];

		}
        var year = $("#year").val();
        var month = $("#month").val();
        var amount = $("#amount").val();
		var id = $("#id").val();
		var status = $("#status").val();
		
      
		
        var payload={
        		'memberId':memberId,
        		'year':year,
        		'month':month,
        		'amount':amount,
				'id':id,
				'memberName': memberName,
				'status':status
         };

		 if(payload.amount == '' || payload.amount == null || payload.amount == undefined ||
		 payload.memberId == '' || payload.memberId == null || payload.memberId == undefined ||
		 payload.year == '' || payload.year == null || payload.year == undefined ||
		 payload.month == '' || payload.month == null || payload.month == undefined ||
		 payload.memberName == '' || payload.memberName == null || payload.memberName == undefined ||
		payload.status == '' || payload.status == null || payload.status == undefined) {
			alert('Fill all fields in form');
			return false;

		 }
        $.ajax({
			  url: "/maintenance/save",		  			  
			  type: "POST",
			  contentType: "application/json",
			  dataType: "json",		
			  data:JSON.stringify(payload),
			  beforeSend: function() {		  				
			}
		})
		.done(function(data){
            alert('Updated Successfully');
			var memberId = $("#memberId").val('');
			var year = $("#year").val('');
			var month = $("#month").val('');
			var id = $("#id").val();
     	}).fail(function(jqXHR, textStatus, errorThrown){	  			
			var errorResponseObj = jqXHR.responseJSON;
			var errorMsg = errorResponseObj.errorMessage;	
			alert(errorMsg);	
			
		})
		.always(function(data, textStatus, jqXHR){	
			$("#search").click();
			$('#save').show();
			$('#search').show();
			$('#update').hide();
		
		});
	
    });


$("#downloadExcel").click(function(){    
		var memberId = $("#memberId").val();
		var memberName;
		if(memberId != null && memberId != undefined) {
			const myArray = memberId.split("~");
			memberId = myArray[0];
			memberName = myArray[1];

		}
        var year = $("#year").val();
        var month = $("#month").val();
		var status = $("#status").val();
		

		$(this).attr("href", "maintenance/downloadExcel?memberId="+memberId+"&year="+year+"&month="+month+"&status="+status);
	
    });

	$('body').on('click', '#print', function() {  
		var id = $(this).val();   
		window.open("paymentReceipt/"+id);	
	
    });


});
</script>

<div id="deleteConfirmModal" class="modal delete-confirm-modal" role="dialog" aria-labelledby="deleteConfirmTitle">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title" id="deleteConfirmTitle">Delete Confirmation</h4>
      </div>
      <div class="modal-body">
        <p id="deleteConfirmMessage">Are you sure you want to delete?</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-danger" id="deleteConfirmOkBtn">Delete</button>
      </div>
    </div>
  </div>
</div>
</body>
</html>
