<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
  <title>Builders</title>
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
	  </a> Builders </div>
  		<div class="panel-body">
			<div class="form-group col-md-3">
				<label for="amount">Builder Name</label>
				<input type="text" class="form-control" id="builderName"  name="builderName">
			</div>	
		

			<div class="form-group col-md-3">
				<label for="amount">Amount</label>
				<input type="number" class="form-control" id="amount"  name="amount" >
			</div>

			<div class="form-group col-md-3">
				<label for="amount">Construction Plot No</label>
				<input type="text" class="form-control" id="plotNumber"  name="plotNumber">
			</div>

			<div class="form-group col-md-3">
				<label for="month">Status</label>
				<select class="form-control" id="status" name="status">
				 <option value="">--Select--</option>
				 <option value="Paid">Paid</option>
				 <option value="Unpaid">Unpaid</option>					 		 
				</select>
			  </div>
		    
		    

			<div class="form-group col-md-12">
				<button type="button" class="btn btn-success" id="save">Save</button>   
				<button type="button" class="btn btn-primary" id="search">Search</button>
				<button type="button" class="btn btn-info" id="update">Update</button>
				
				<a id="downloadExcel" href="" class="btn btn-info" role="button">Download Excel</a>


				
		    	    
		  </div>
	</div>
	</div>
  </form>
  
  

    
	<div class="col-md-12" id="builderListDiv">
	<div class="panel panel-primary">
		<div class="panel-heading">Builder Details <label id="totalBuilderAmount" style="color: yellow;"></label></div>
		<div class="panel-body"> 
			<div class="table-responsive">          
				<table class="table-bordered table-striped table table-hover documentUpload" >
					<thead>
					<tr>
						<th>Sl.No</th>
						<th>Builder Name</th>						
						<th>Amount</th>	
						<th>Status</th>							
						<th>Construction Plot No</th>
						<th>Updated Date</th>												
						<th>Action</th>
						
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
        var builderName = $("#builderName").val();		
        var amount = $("#amount").val();
		var status = $("#status").val();
		var plotNumber = $("#plotNumber").val();

		
        var payload={
        		'builderName':builderName,
        		'amount':amount,
        		'status':status,
        		'plotNumber':plotNumber	
         };
		 if(payload.amount == '' || payload.amount == null || payload.amount == undefined ||
		 payload.builderName == '' || payload.builderName == null || payload.builderName == undefined ||
		 payload.status == '' || payload.status == null || payload.status == undefined ||
		 payload.plotNumber == '' || payload.plotNumber == null || payload.plotNumber == undefined) {
			alert('Fill all fields in form');
			return false;

		 }

        $.ajax({
			  url: "/builder/save",		  			  
			  type: "POST",
			  contentType: "application/json",
			  dataType: "json",		
			  data:JSON.stringify(payload),
			  beforeSend: function() {	
			}
		})
		.done(function(data){
            alert('Builder details saves successfully');
			$("#builderName").val('');
			$("#amount").val('');
			$("#plotNumber").val('');
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
      
        
        $.ajax({
			  url:  "/builder/fetch",		  			  
			  type: "GET",
			  contentType: "application/json",			  
			  beforeSend: function() {		  				
			}
		})
		.done(function(data){
            if(data.length>0){
         	    var trHTML = '';
       		   $('#tbdata').empty();
			   var totalBuilderAmount = 0;
       	        $.each(data,function(index, item){   

					var paidStatus = '';
					if(item.status === 'Paid') {
						 totalBuilderAmount = totalBuilderAmount +  item.amount; 
						 paidStatus= '<span class="label label-success">Paid</span>';  
					}
					else {
						 paidStatus= '<span class="label label-danger">Unpaid</span>';  
					}
					        	
       	        	 var insno= index+1; 
					
						        	 
     		         trHTML += '<tr><td>'+insno+'</td><td>'+item.builderName+'</td><td>'+item.amount+'</td><td>'
						+paidStatus+'</td><td>'+item.plotNumber+'</td><td>'+item.creationDateTime+'</td><td><button type="button" class="btn btn-danger btn-sm" value="'+item.id+'" id="delete"><span class="glyphicon">&#xe020;</span></button></td></tr>';
     		      }); 
				   $('#totalBuilderAmount').empty();
				   $('#totalBuilderAmount').append('( Total Builders Amount : '+totalBuilderAmount +' )');
				   
       	          $('#tbdata').append(trHTML);
       	          $("#builderListDiv").show();
       	 }else{
       		    var trHTML = '';
     		    $('#tbdata').empty();
     		  	trHTML += '<td rowspan="6" style="color: Red;">No Search Found</td>';
  		        $('#tbdata').append(trHTML);
     	        $("#builderListDiv").show(); 
				 totalBuilderAmount = 0;
				 $('#totalBuilderAmount').empty();
				   $('#totalBuilderAmount').append('( Total Maintenance Amount : '+totalBuilderAmount +' )');                
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
		showDeleteConfirmModal("Delete this builder record?", function () {
			$.ajax({
				  url: "/builder/delete/"+id,		  			  
				  type: "GET",
				  contentType: "application/json",			  
				  beforeSend: function() {		  				
				}
			})
			.done(function(data){
	            alert('Builder details deleted Successfully');
				
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

	
  


$("#downloadExcel").click(function(){
		$(this).attr("href", "builder/downloadExcel");	
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
